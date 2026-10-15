"""GLM-5.3-Flash and Kimi K2.6: provider-default thinking, same benchmark prompts."""
import argparse,collections,copy,hashlib,json
from pathlib import Path
import minimax_m3_official as core
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'results/generation/openrouter_glm_kimi'
MODELS={'GLM-5.3-Flash':'z-ai/glm-5.3-flash','Kimi-K2.6':'moonshotai/kimi-k2.6'}
core.OUT=OUT;core.ENDPOINT='https://openrouter.ai/api/v1/chat/completions';core.AUTH_ENV='OPENROUTER_API_KEY';core.AUTH_PROMPT='OpenRouter API key (hidden): ';core.STOP_ON_STREAM_ERROR=False;core.MAX_CONCURRENCY=128
original_validate=core.validate

def validate(raw,row):
 shadow=dict(row,request=dict(row['request'],thinking={'type':'unspecified'}))
 status,evidence=original_validate(raw,shadow);evidence.pop('requested_type',None);evidence['requested_reasoning']='omitted; model/provider defaults'
 if raw.get('model') and raw['model']!=row['request']['model']:return 'unexpected_model',evidence
 return status,evidence
core.validate=validate


def export():
 # Stream the multi-GB attempt log. Keeping all full responses in memory can be
 # killed by the OS once long streamed responses accumulate.
 seen=set();counts=collections.Counter();observed=collections.Counter();reported_cost=0.0
 temps={name:(OUT/(name+'_responses.jsonl.tmp')).open('w') for name in MODELS}
 try:
  with (OUT/'attempts.jsonl').open() as attempts:
   for line in attempts:
    r=json.loads(line);raw=r.get('full_response',{})
    reported_cost+=(raw.get('usage') or {}).get('cost',0) or 0
    status=r.get('status')
    if status=='incomplete_stream':
     repaired,evidence=validate(raw,r)
     if repaired=='complete':
      r.update(original_client_status=status,status=repaired,observed_evidence=evidence,validation_version='native_stop_and_terminal_usage_v1')
      status='complete'
    if status!='complete' or r['uid'] in seen:continue
    seen.add(r['uid']);temps[r['model']].write(json.dumps(r,ensure_ascii=False)+'\n')
    counts[r['model']+'/'+r['domain']]+=1;e=r['observed_evidence']
    state='present' if e['reasoning_chars'] or e['has_reasoning_details'] or (e['reasoning_tokens'] or 0)>0 else 'not_observed' if e['reasoning_tokens']==0 else 'unknown'
    observed[r['model']+'/'+state]+=1
 finally:
  for f in temps.values():f.close()
 for name in MODELS:(OUT/(name+'_responses.jsonl.tmp')).replace(OUT/(name+'_responses.jsonl'))
 jobs=core.read(OUT/'requests.jsonl');report=dict(expected=len(jobs),complete=len(seen),counts=dict(counts),missing=[j['uid'] for j in jobs if j['uid'] not in seen],observed_reasoning=dict(observed),reported_cost=reported_cost)
 core.dump(OUT/'summary.json',report);print(json.dumps({k:v for k,v in report.items() if k!='missing'}),flush=True);return report
core.export=export
if __name__=='__main__':
 ap=argparse.ArgumentParser();ap.add_argument('action',choices=['run','export']);ap.add_argument('--probe',action='store_true');args=ap.parse_args()
 if args.action=='run':core.run(args)
 else:export()
