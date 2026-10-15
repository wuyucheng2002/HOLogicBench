"""Execute a separate versioned Law run; default is a no-network manifest check.

Use OPENROUTER_API_KEY, --execute, --model and --max-requests explicitly.
All attempts persist with exact request, full response, finish reason and usage.
No successful legacy answer is replaced, and no new results enter the old table.
"""
import argparse,datetime,json,os,sys,time,random,threading
from concurrent.futures import ThreadPoolExecutor,as_completed
from pathlib import Path
from urllib import request,error
from shared_protocol_v3 import VERSION,digest
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'results/generation/law_section_json_v3'
def assess(data):
    choice=(data.get('choices') or [{}])[0];message=choice.get('message') or {};text=message.get('content') or '';finish=choice.get('finish_reason')
    if not isinstance(text,str):return 'unsupported_content',None
    if finish=='length':return 'truncated',None
    if not text.strip():return 'empty_content',None
    try:obj=json.loads(text)
    except (ValueError,TypeError):return 'invalid_json',None
    if not isinstance(obj,dict) or not isinstance(obj.get('final_result'),str) or not obj['final_result'].strip():return 'missing_final_result',obj
    if not isinstance(obj.get('reasoning_trace'),list) or not obj['reasoning_trace']:return 'invalid_trace',obj
    if not isinstance(obj.get('selected_rules'),list):return 'invalid_rule_selection',obj
    for i,s in enumerate(obj['reasoning_trace'],1):
        if not isinstance(s,dict) or not {'step','description','result','rule_id'}<=s.keys():return 'invalid_trace_step',obj
        if s['step']!=i or not isinstance(s['description'],str):return 'invalid_trace_step',obj
        if s['rule_id'] is not None and (not isinstance(s['rule_id'],str) or not s['rule_id'].isdigit() or '[Rule '+s['rule_id']+']' not in s['description']):return 'invalid_rule_citation',obj
    return ('ok' if finish=='stop' else 'unconfirmed_finish'),obj

def receive_stream(response, max_seconds=600):
    events=[];parts=[];reasoning=[];finish=None;usage={};identity={};done=False;started=time.monotonic()
    for rawline in response:
        if time.monotonic()-started>max_seconds:break
        line=rawline.decode('utf-8').strip()
        if not line.startswith('data:'):continue
        value=line[5:].strip()
        if value=='[DONE]':done=True;break
        event=json.loads(value);events.append(event)
        if event.get('error'):return dict(error=event['error'],stream_events=events)
        for k in ['id','model','provider','created']:
            if k in event:identity[k]=event[k]
        if event.get('usage'):usage=event['usage']
        for choice in event.get('choices',[]):
            delta=choice.get('delta',{})
            if delta.get('content'):parts.append(delta['content'])
            if delta.get('reasoning'):reasoning.append(delta['reasoning'])
            if choice.get('finish_reason'):finish=choice['finish_reason']
    return dict(identity,choices=[dict(message=dict(content=''.join(parts),reasoning=''.join(reasoning)),finish_reason=finish)],usage=usage,stream_events=events,stream_done=done)

def wire_request(payload, backend):
    wire=dict(payload,stream=True,stream_options={'include_usage':True})
    if backend=='openai':
        assert payload['model']=='openai/gpt-5.4-mini'
        wire['model']='gpt-5.4-mini'
        wire['max_completion_tokens']=wire.pop('max_tokens')
    return wire

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--execute',action='store_true');ap.add_argument('--backend',choices=['openrouter','openai','vercel'],default='openrouter');ap.add_argument('--log-name',default='attempts.jsonl');ap.add_argument('--model');ap.add_argument('--exclude-model',action='append',default=[]);ap.add_argument('--max-requests',type=int,default=1);ap.add_argument('--retry-incomplete',action='store_true');ap.add_argument('--concurrency',type=int,default=96);ap.add_argument('--per-model-concurrency',type=int,default=96);ap.add_argument('--max-retries',type=int,default=2);args=ap.parse_args()
    if args.backend=='openai' and (args.model!='GPT-5.4-Mini' or args.log_name!='gpt_openai_direct.jsonl'):ap.error('OpenAI backend requires --model GPT-5.4-Mini --log-name gpt_openai_direct.jsonl')
    if args.backend=='vercel' and (args.model!='Gemini-3.1-Flash' or args.log_name!='gemini_vercel.jsonl'):ap.error('Vercel backend requires --model Gemini-3.1-Flash --log-name gemini_vercel.jsonl')
    jobs=list(map(json.loads,(OUT/'requests_32k.jsonl').read_text().splitlines()))
    for j in jobs:assert j['protocol']==VERSION and j['request_sha256']==digest(j['request'])
    jobs=[j for j in jobs if j['model'] not in args.exclude_model]
    if args.model:jobs=[j for j in jobs if j['model']==args.model]
    if not jobs:raise SystemExit('No matching jobs')
    if args.max_requests<=0:raise SystemExit('max-requests must be positive')
    assert Path(args.log_name).name==args.log_name and args.log_name.endswith('.jsonl')
    log=OUT/args.log_name;history={}
    for source in dict.fromkeys([log] if args.backend in {'openai','vercel'} else [OUT/'attempts.jsonl',log]):
        if source.exists():
            with source.open() as f:
                for line in f:
                    try:r=json.loads(line)
                    except json.JSONDecodeError:continue
                    if args.model and r['model']!=args.model:continue
                    history[r['request_sha256']]={'status':r['status']}
    jobs=[j for j in jobs if j['request_sha256'] not in history or (args.retry_incomplete and history[j['request_sha256']]['status'] in {'http_error','api_error','transport_or_decode_error','empty_content','truncated'})][:args.max_requests]
    print(json.dumps(dict(protocol=VERSION,selected=len(jobs),execute=args.execute,output=str(log))))
    if not args.execute:return
    key_env={'openai':'OPENAI_API_KEY','vercel':'AI_GATEWAY_API_KEY','openrouter':'OPENROUTER_API_KEY'}[args.backend]
    key=os.environ.get(key_env)
    if not key:raise SystemExit('Set '+key_env+'; credentials are never written to logs.')
    if args.concurrency<1 or args.per_model_concurrency<1:raise SystemExit('Concurrency must be positive')
    lock=threading.Lock();stop=threading.Event();limits={j['model']:threading.Semaphore(args.per_model_concurrency) for j in jobs};blocked=set()
    # Round-robin models keeps long-running models from monopolizing the queue.
    grouped={}
    for j in jobs:grouped.setdefault(j['model'],[]).append(j)
    ordered=[]
    for i in range(max(map(len,grouped.values()),default=0)):
        ordered.extend(v[i] for v in grouped.values() if i<len(v))
    def run_one(j):
        with limits[j['model']]:
            for attempt in range(args.max_retries+1):
                if stop.is_set() or j['model'] in blocked:return
                row=dict(j,attempt=attempt+1,started_at=datetime.datetime.now(datetime.timezone.utc).isoformat(),backend=args.backend,endpoint={'openai':'https://api.openai.com/v1/chat/completions','vercel':'https://ai-gateway.vercel.sh/v1/chat/completions','openrouter':'https://openrouter.ai/api/v1/chat/completions'}[args.backend])
                wire=wire_request(j['request'],args.backend);row['wire_request']=wire;row['wire_request_sha256']=digest(wire)
                with lock:
                    with (OUT/'request_starts.jsonl').open('a') as starts:starts.write(json.dumps(dict(model=j['model'],key=j['key'],request_sha256=j['request_sha256'],started_at=row['started_at']))+'\n')
                req=request.Request(row['endpoint'],data=json.dumps(wire).encode(),headers={'Authorization':'Bearer '+key,'Content-Type':'application/json'},method='POST')
                retry=False;delay=min(60,2**(attempt+2)+random.random()*3)
                try:
                    with request.urlopen(req,timeout=90) as response:
                        row['http_status']=response.status;row['request_id']=response.headers.get('x-request-id');data=receive_stream(response)
                    row['full_response']=data;row['usage']=data.get('usage',{});row['finish_reasons']=[c.get('finish_reason') for c in data.get('choices',[])];row['status'],row['model_output']=assess(data)
                    if data.get('stream_done') is False:row['status']='transport_or_decode_error';retry=True
                    if data.get('error'):
                        row['status']='api_error';retry=True
                except error.HTTPError as exc:
                    row.update(status='http_error',http_status=exc.code,error_body=exc.read().decode('utf-8',errors='replace'))
                    retry=exc.code in {408,429,500,502,503,504}
                    try:delay=min(60,max(delay,float(exc.headers.get('Retry-After',0))))
                    except (ValueError,TypeError):pass
                    if exc.code==403:blocked.add(j['model'])
                    if exc.code in {401,402}:stop.set()
                except Exception as exc:
                    row.update(status='transport_or_decode_error',error_type=type(exc).__name__,error_message=str(exc));retry=True
                row['ended_at']=datetime.datetime.now(datetime.timezone.utc).isoformat()
                with lock:
                    with log.open('a') as f:f.write(json.dumps(row,ensure_ascii=False)+'\n');f.flush();os.fsync(f.fileno())
                    print(j['model'],j['key'],row['status'],'attempt',attempt+1,flush=True)
                # Never retry based on answer correctness or schema compliance.
                if not retry or attempt==args.max_retries:return
                if stop.wait(delay):return
    # Dedicated model pools avoid workers waiting on another model's semaphore.
    from contextlib import ExitStack
    workers=min(args.per_model_concurrency,max(1,args.concurrency//max(1,len(grouped))))
    with ExitStack() as stack:
        pools={m:stack.enter_context(ThreadPoolExecutor(max_workers=workers)) for m in grouped}
        futures=[pools[j['model']].submit(run_one,j) for j in ordered]
        for future in as_completed(futures):future.result()
    latest={}
    if log.exists():
        for r in map(json.loads,log.open()):latest[r['request_sha256']]={'status':r['status']}
    from collections import Counter
    summary=dict(protocol=VERSION,unique_requests=len(latest),statuses=dict(Counter(r['status'] for r in latest.values())),stopped_for_auth_or_credit=stop.is_set(),blocked_models=sorted(blocked),excluded_models=args.exclude_model)
    (OUT/('run_summary.json' if args.log_name=='attempts.jsonl' else Path(args.log_name).stem+'_summary.json')).write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary),flush=True)
if __name__=='__main__':main()
