"""Complement observed legacy thinking modes without overwriting benchmark sources."""
import argparse,ast,collections,copy,datetime,fcntl,getpass,hashlib,json,os,re,signal,threading,time
from concurrent.futures import ThreadPoolExecutor,as_completed
from pathlib import Path
from urllib import request,error
from shared_protocol_v3 import digest
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'results/generation/deepseek_v4_flash_paired'
MODEL='deepseek/deepseek-v4-flash'
def dump(p,x):p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n')
def lines(p):
 if p.exists():
  for l in p.open():
   if l.strip():yield json.loads(l)
def evidence(raw):
 m=(raw.get('choices') or [{}])[0].get('message') or {}
 rt=((raw.get('usage') or {}).get('completion_tokens_details') or {}).get('reasoning_tokens')
 txt=m.get('reasoning') or m.get('reasoning_content') or ''
 details=m.get('reasoning_details') or []
 if (rt or 0)>0 or txt.strip() or details:mode='on'
 elif rt==0:mode='off_observed'
 else:mode='unknown'
 return dict(mode=mode,reasoning_tokens=rt,reasoning_chars=len(txt),has_details=bool(details))
def receive(response,row):
 raw=dict(choices=[dict(message=dict(content='',reasoning='',reasoning_details=[]),finish_reason=None)],stream_events=[],stream_done=False)
 row['full_response']=raw;started=time.monotonic()
 for line in response:
  if time.monotonic()-started>3600:raise TimeoutError('Stream exceeded 3600 seconds')
  s=line.decode().strip()
  if not s.startswith('data:'):continue
  s=s[5:].strip()
  if s=='[DONE]':raw['stream_done']=True;break
  e=json.loads(s);raw['stream_events'].append(e)
  for k in ['id','model','provider','created','usage','error']:
   if k in e:raw[k]=e[k]
  for c in e.get('choices',[]):
   delta=c.get('delta') or {};m=raw['choices'][0]['message']
   m['content']+=delta.get('content') or ''
   m['reasoning']+=delta.get('reasoning') or delta.get('reasoning_content') or ''
   m['reasoning_details'].extend(delta.get('reasoning_details') or [])
   if c.get('finish_reason'):raw['choices'][0]['finish_reason']=c['finish_reason']
 return raw
def check(raw,target):
 c=(raw.get('choices') or [{}])[0];m=c.get('message') or {};txt=m.get('content') or ''
 ev=evidence(raw)
 if raw.get('error'):return 'api_error',ev
 if not raw.get('stream_done'):return 'incomplete_stream',ev
 if c.get('finish_reason')!='stop':return 'unfinished',ev
 if not txt.strip():return 'empty',ev
 observed='on' if ev['mode']=='on' else 'off' if ev['mode']=='off_observed' else 'unknown'
 if observed!=target:return 'mode_mismatch_or_unknown',ev
 return 'complete',ev

def export():
 latest={}
 for row in lines(OUT/'attempts.jsonl'):
  if row.get('status')=='complete':latest[row['key']]=row
 jobs=list(lines(OUT/'requests.jsonl'))
 (OUT/'complement_responses.jsonl').write_text(''.join(json.dumps(r,ensure_ascii=False)+'\n' for r in latest.values()))
 report=dict(expected=len(jobs),completed=len(latest),missing=[r['key'] for r in jobs if r['key'] not in latest])
 dump(OUT/'summary.json',report)
 print(json.dumps({k:v for k,v in report.items() if k!='missing'}),flush=True)
 return report

def run(args):
 lockfile=(OUT/'.run.lock').open('a');fcntl.flock(lockfile,fcntl.LOCK_EX|fcntl.LOCK_NB)
 jobs=list(lines(OUT/'requests.jsonl'));history=list(lines(OUT/'attempts.jsonl'));done={r['key'] for r in history if r.get('status')=='complete'}
 repair_keys={r['key'] for r in json.loads((OUT/'verification.json').read_text()).get('json_or_required_field_issues',[])} if args.repair_format else set()
 jobs=[j for j in jobs if j['key'] in repair_keys] if args.repair_format else [j for j in jobs if j['key'] not in done]
 if args.probe:
  selected={}
  for j in jobs:selected.setdefault((j['domain'],j['target_mode']),j)
  jobs=list(selected.values())
 if args.limit:jobs=jobs[:args.limit]
 if not jobs:return export()
 key=os.environ.get('OPENROUTER_API_KEY') or getpass.getpass('OpenRouter key (hidden): ')
 stop=threading.Event();cv=threading.Condition();lock=threading.Lock();active=0;ceiling=64;cooldown=0;last_429=0;last_growth=0;successes=0;unhealthy={};provider_active=collections.Counter()
 signal.signal(signal.SIGUSR1,lambda *_:stop.set())
 round_id=datetime.datetime.now(datetime.timezone.utc).isoformat()
 def one(j):
  nonlocal active,ceiling,cooldown,last_429,last_growth,successes
  for attempt in range(1,5):
   with cv:
    while active>=ceiling or time.monotonic()<cooldown:
     if stop.is_set():return
     if ceiling<64 and time.monotonic()-max(last_429,last_growth)>30:
      ceiling=min(64,ceiling*2);last_growth=time.monotonic();cv.notify_all()
     cv.wait(1)
    if stop.is_set():return
    active+=1
   row=dict(j,attempt=attempt,round_id=round_id,started_at=datetime.datetime.now(datetime.timezone.utc).isoformat(),max_attempts=4);delay=2**attempt;fatal=False
   wire=copy.deepcopy(j['request'])
   previous=[r for r in history if r['key']==j['key']]
   preferred=wire['provider']['only'][0]
   alternatives=['alibaba/fp8','streamlake/fp8','novita/fp8','gmicloud/fp8','siliconflow/fp8','parasail/fp8','baidu/fp8','deepinfra/fp8']
   # Known failures: AtlasCloud may ignore off; DeepInfra shared pool overloads.
   with cv:
    candidates=[p for p in alternatives if unhealthy.get(p,0)<time.monotonic()]
    if attempt==1 and preferred not in ['atlas-cloud/fp4','deepinfra/fp8','digitalocean'] and unhealthy.get(preferred,0)<time.monotonic() and provider_active[preferred]<8:
     chosen=preferred
    else:chosen=min(candidates or alternatives,key=lambda p:provider_active[p])
    provider_active[chosen]+=1
   wire['provider']={'only':[chosen],'allow_fallbacks':False,'require_parameters':True}
   row['wire_request']=wire;row['wire_request_sha256']=digest(wire);row['provider_changed_from_manifest']=wire['provider']!=j['request']['provider']
   with lock:
    with (OUT/'request_starts.jsonl').open('a') as f:f.write(json.dumps({k:row[k] for k in ['key','round_id','attempt','started_at','wire_request_sha256']})+'\n')
   try:
    req=request.Request('https://openrouter.ai/api/v1/chat/completions',data=json.dumps(wire).encode(),headers={'Authorization':'Bearer '+key,'Content-Type':'application/json'})
    with request.urlopen(req,timeout=600) as response:
     row['http_status']=response.status;row['request_id']=response.headers.get('x-request-id');raw=receive(response,row)
    row['status'],row['observed_evidence']=check(raw,j['target_mode'])
    if args.repair_format:
     row['retry_selection']='format_issues_from_verification';row['format_validation_required']=True
     if row['status']=='complete':
      text=raw['choices'][0]['message']['content'].strip();clean=re.sub(r'\s*```$','',re.sub(r'^```(?:json)?\s*','',text,flags=re.I))
      try:
       obj=json.loads(clean)
       if not isinstance(obj,dict) or (j['domain']=='law' and (not obj.get('final_result') or not obj.get('reasoning_trace'))):raise ValueError('missing required fields')
      except ValueError as exc:row['status']='format_error';row['format_error']=str(exc)
   except error.HTTPError as exc:
    row.update(status='http_error',http_status=exc.code,error_body=exc.read().decode(errors='replace'));fatal=exc.code not in {408,429,500,502,503,504}
    if exc.code in {401,402,403}:stop.set()
    if exc.code==429:
     try:delay=max(30,float(exc.headers.get('Retry-After',30)))
     except (ValueError,TypeError):delay=30
   except Exception as exc:row.update(status='transport_error',error_type=type(exc).__name__,error_message=str(exc))
   finally:
    with cv:
     active-=1;provider_active[chosen]-=1
     if row.get('http_status')==429:
      ceiling=max(1,ceiling//2);cooldown=max(cooldown,time.monotonic()+delay);row['concurrency_after_429']=ceiling;last_429=time.monotonic();successes=0;unhealthy[chosen]=time.monotonic()+300
     elif row.get('status')=='mode_mismatch_or_unknown':unhealthy[chosen]=time.monotonic()+3600
     elif row.get('status')=='format_error':unhealthy[chosen]=time.monotonic()+300
     elif row.get('status')=='complete':
      successes+=1
      if ceiling<64 and successes>=8 and time.monotonic()-max(last_429,last_growth)>30:
       ceiling=min(64,ceiling*2);last_growth=time.monotonic();successes=0;row['concurrency_recovered_to']=ceiling
     cv.notify_all()
   row['ended_at']=datetime.datetime.now(datetime.timezone.utc).isoformat()
   with lock:
    with (OUT/'attempts.jsonl').open('a') as f:f.write(json.dumps(row,ensure_ascii=False)+'\n');f.flush();os.fsync(f.fileno())
    print(j['key'],j['target_mode'],row['status'],'attempt',attempt,flush=True)
   if row['status']=='complete' or fatal:return
   if attempt<4 and stop.wait(delay):return
 print('Selected',len(jobs),'requests; global concurrency 64; 4 attempts maximum per round',flush=True)
 with ThreadPoolExecutor(max_workers=64) as pool:
  for f in as_completed([pool.submit(one,j) for j in jobs]):f.result()
 export()
if __name__=='__main__':
 ap=argparse.ArgumentParser();ap.add_argument('action',choices=['run','export']);ap.add_argument('--probe',action='store_true');ap.add_argument('--repair-format',action='store_true');ap.add_argument('--limit',type=int);a=ap.parse_args()
 if a.action=='run':run(a)
 else:export()
