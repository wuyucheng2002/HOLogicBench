"""Full paired MiniMax M3 experiment through its official China API."""
import argparse,collections,copy,datetime,fcntl,getpass,hashlib,json,os,re,signal,threading,time
from concurrent.futures import ThreadPoolExecutor,as_completed
from pathlib import Path
from urllib import request,error
from deepseek_flash_paired import receive
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'results/generation/minimax_m3_official';ENDPOINT='https://api.minimaxi.com/v1/chat/completions'
AUTH_ENV='MINIMAX_API_KEY';AUTH_PROMPT='MiniMax API key (hidden): ';STOP_ON_STREAM_ERROR=True;MAX_CONCURRENCY=64
def digest(x):return hashlib.sha256(json.dumps(x,sort_keys=True,ensure_ascii=False).encode()).hexdigest()
def read(p):return [json.loads(l) for l in p.open()] if p.exists() else []
def dump(p,x):p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n')
def validate(raw,j):
 c=(raw.get('choices') or [{}])[0];m=c.get('message') or {};text=m.get('content') or '';thinking=m.get('reasoning') or m.get('reasoning_content') or '';tokens=((raw.get('usage') or {}).get('completion_tokens_details') or {}).get('reasoning_tokens');ev=dict(reasoning_chars=len(thinking),reasoning_tokens=tokens,has_reasoning_details=bool(m.get('reasoning_details')),requested_type=j['request']['thinking']['type'])
 if raw.get('error'):return 'api_error',ev
 terminal=(raw.get('stream_events') or [{}])[-1]
 native_end=bool(terminal.get('usage')) and (terminal.get('base_resp') or {}).get('status_code')==0 and c.get('finish_reason')=='stop'
 ev['completion_evidence']='done_marker' if raw.get('stream_done') else 'native_stop_and_terminal_usage' if native_end else 'missing'
 if not raw.get('stream_done') and not native_end:return 'incomplete_stream',ev
 if c.get('finish_reason')!='stop':return 'unfinished',ev
 if not text.strip():return 'empty',ev
 if j['target_mode']=='off' and (thinking.strip() or (tokens or 0)>0 or '<think>' in text):return 'disabled_mode_violation',ev
 clean=re.sub(r'\s*```$','',re.sub(r'^```(?:json)?\s*','',text.strip(),flags=re.I))
 try:
  obj=json.loads(clean)
  if not isinstance(obj,dict):return 'format_error',ev
  if j['domain']=='law':
   if not obj.get('final_result') or not isinstance(obj.get('reasoning_trace'),list) or not obj['reasoning_trace']:return 'missing_required_fields',ev
  else:
   sys_path=str(ROOT/'benchmark/finance/scripts')
   import sys
   if sys_path not in sys.path:sys.path.insert(0,sys_path)
   from reasoning_text import extract_reasoning_trace
   if not extract_reasoning_trace(obj).strip():return 'missing_reasoning_trace',ev
 except (ValueError,TypeError,AttributeError):return 'format_error',ev
 return 'complete',ev

def history():
 rows=read(OUT/'attempts.jsonl')
 for r in rows:
  if r.get('status')=='incomplete_stream':
   status,evidence=validate(r.get('full_response',{}),r)
   if status=='complete':r.update(original_client_status=r['status'],status=status,observed_evidence=evidence,validation_version='native_stop_and_terminal_usage_v1')
 return rows

def export():
 latest={}
 for r in history():
  if r['status']=='complete':latest.setdefault(r['uid'],r)
 for mode in ['on','off']:
  rows=sorted((r for r in latest.values() if r['target_mode']==mode),key=lambda r:r['key'])
  (OUT/('thinking_'+mode+'.jsonl')).write_text(''.join(json.dumps(r,ensure_ascii=False)+'\n' for r in rows))
 jobs=read(OUT/'requests.jsonl');report=dict(expected=len(jobs),complete=len(latest),counts=dict(collections.Counter(r['domain']+'/'+r['target_mode'] for r in latest.values())),missing=[j['uid'] for j in jobs if j['uid'] not in latest],actual_no_reasoning_in_adaptive=sum(r['target_mode']=='on' and not r['observed_evidence']['reasoning_chars'] and not (r['observed_evidence']['reasoning_tokens'] or 0) for r in latest.values()))
 dump(OUT/'summary.json',report);print(json.dumps({k:v for k,v in report.items() if k!='missing'}),flush=True)
 return report

def run(args):
 OUT.mkdir(exist_ok=True);lockfile=(OUT/'.run.lock').open('a');fcntl.flock(lockfile,fcntl.LOCK_EX|fcntl.LOCK_NB)
 jobs=read(OUT/'requests.jsonl');hist=history();done={r['uid'] for r in hist if r['status']=='complete'};jobs=[j for j in jobs if j['uid'] not in done]
 if getattr(args,'only_uids',None) is not None:jobs=[j for j in jobs if j['uid'] in args.only_uids]
 if args.probe:
  selected={}
  for j in jobs:selected.setdefault((j['model'],j['domain'],j['target_mode']),j)
  jobs=list(selected.values())
 if not jobs:return export()
 key=os.environ.get(AUTH_ENV) or getpass.getpass(AUTH_PROMPT)
 stop=threading.Event();cv=threading.Condition();lock=threading.Lock();active=0;ceiling=4 if args.probe else MAX_CONCURRENCY;cooldown=0.;last429=0.;lastgrowth=0.;successes=0;finished=0
 signal.signal(signal.SIGUSR1,lambda *_:stop.set())
 round_id=datetime.datetime.now(datetime.timezone.utc).isoformat()
 def one(j):
  nonlocal active,ceiling,cooldown,last429,lastgrowth,successes,finished
  for attempt in range(1,5):
   with cv:
    while active>=ceiling or time.monotonic()<cooldown:
     if stop.is_set():return
     cv.wait(1)
    if stop.is_set():return
    active+=1
   row=dict(j,attempt=attempt,round_id=round_id,started_at=time.time(),endpoint=ENDPOINT);delay=2**attempt;fatal=False
   try:
    req=request.Request(ENDPOINT,data=json.dumps(j['request']).encode(),headers={'Authorization':'Bearer '+key,'Content-Type':'application/json'})
    with request.urlopen(req,timeout=600) as response:
     row['http_status']=response.status;row['request_id']=response.headers.get('x-request-id');raw=receive(response,row)
    row['status'],row['observed_evidence']=validate(raw,j)
    if row['status']=='api_error':
     code=(raw.get('error') or {}).get('code');code=int(code) if str(code).isdigit() else code;row['provider_error_code']=code
     fatal=(STOP_ON_STREAM_ERROR and code not in [429,529]) or code in [400,401,402,403,404]
     if fatal:stop.set()
     if code in [429,529]:delay=60 if code==529 else 30
   except error.HTTPError as exc:
    row.update(status='http_error',http_status=exc.code,error_body=exc.read().decode(errors='replace'));fatal=exc.code not in [408,429,500,502,503,504,529]
    if exc.code in [400,401,402,403,404]:stop.set()
    if exc.code in [429,529]:
     try:delay=max(60 if exc.code==529 else 30,float(exc.headers.get('Retry-After',30)))
     except (TypeError,ValueError):delay=60 if exc.code==529 else 30
   except Exception as exc:row.update(status='transport_error',error_type=type(exc).__name__,error_message=str(exc))
   finally:
    with cv:
     active-=1
     if row.get('http_status') in [429,529] or row.get('provider_error_code') in [429,529]:
      ceiling=max(1,ceiling//2);cooldown=max(cooldown,time.monotonic()+delay);last429=time.monotonic();successes=0;row['concurrency_after_backoff']=ceiling
     elif row.get('status')=='complete':
      successes+=1
      if not args.probe and ceiling<MAX_CONCURRENCY and successes>=8 and time.monotonic()-max(last429,lastgrowth)>60:ceiling=min(MAX_CONCURRENCY,ceiling*2);lastgrowth=time.monotonic();successes=0
     cv.notify_all()
   row['ended_at']=time.time()
   with lock:
    with (OUT/'attempts.jsonl').open('a') as f:f.write(json.dumps(row,ensure_ascii=False)+'\n');f.flush();os.fsync(f.fileno())
    if row['status']=='complete':finished+=1
    dump(OUT/'progress.json',dict(round_id=round_id,selected=len(jobs),round_completed=finished,prior_completed=len(done),active=active,concurrency=ceiling,stopping=stop.is_set(),updated_at=time.time()))
    print(j['uid'],row['status'],'attempt',attempt,flush=True)
   if row['status']=='complete' or fatal:return
   if attempt<4 and stop.wait(delay):return
 print('Selected',len(jobs),'requests; concurrency ceiling',ceiling,'; at most 4 attempts',flush=True)
 with ThreadPoolExecutor(max_workers=ceiling) as pool:
  for future in as_completed([pool.submit(one,j) for j in jobs]):future.result()
 export()
if __name__=='__main__':
 ap=argparse.ArgumentParser();ap.add_argument('action',choices=['run','export']);ap.add_argument('--probe',action='store_true');args=ap.parse_args()
 if args.action=='run':run(args)
 else:export()
