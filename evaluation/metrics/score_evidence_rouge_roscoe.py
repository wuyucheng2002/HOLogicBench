"""Exact metricwise maxima with all fact and branch steps retained."""
import argparse
from collections import defaultdict
import functools
import hashlib
import itertools
import json
import os
from pathlib import Path
import time
os.environ.setdefault('HF_HUB_OFFLINE','1')
os.environ.setdefault('TRANSFORMERS_OFFLINE','1')
os.environ.setdefault('TOKENIZERS_PARALLELISM','false')
import numpy as np
import torch
from rouge_score import rouge_scorer
from sentence_transformers import SentenceTransformer
from evidence_reference_reader import EvidenceReferences,HERE
from score_multireference import steps


def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--device',default='mps');p.add_argument('--embedding-model',default='all-mpnet-base-v2');p.add_argument('--domain',choices=['law','finance']);p.add_argument('--batch-size',type=int,default=64);args=p.parse_args()
    torch.set_num_threads(4)
    if args.device=='mps':torch.mps.set_per_process_memory_fraction(0.3)
    refs=EvidenceReferences();preds={f.name.removesuffix('_predictions.jsonl'):{r['key']:r for r in map(json.loads,f.open())} for f in sorted(HERE.glob('*_predictions.jsonl'))}
    if args.domain:
        refs.records={k:r for k,r in refs.records.items() if r['domain']==args.domain}
        preds={name:{k:r for k,r in rows.items() if k in refs.records} for name,rows in preds.items()}
        if args.domain=='law':refs.texts=[]
    config=dict(reference_sha256=sha(HERE/'references.jsonl'),steps_sha256=sha(HERE/'finance_evidence_steps.json'),
        rouge='rouge-score 0.1.2 ROUGE-L F1, no stemming',roscoe_model='sentence-transformers/all-mpnet-base-v2',
        roscoe_max_seq_length=512,roscoe='mean hypothesis-step max cosine to reference steps',
        reference_steps='one complete source inference or fact node per finance step; law line splitting',
        hypothesis_steps='original domain-specific splitting',prediction_sha256={f.name:sha(f) for f in sorted(HERE.glob('*_predictions.jsonl'))})
    sig=hashlib.sha256(json.dumps(config,sort_keys=True).encode()).hexdigest()
    (HERE/'rouge_roscoe_configuration.json').write_text(json.dumps(dict(config,signature=sig),indent=2)+'\n')
    output=HERE/'rouge_roscoe_case_scores.jsonl';done={}
    if output.exists():
        for r in map(json.loads,output.open()):
            assert r['configuration_signature']==sig
            done[r['model'],r['key']]=r
    model=SentenceTransformer(args.embedding_model,device=args.device);model.max_seq_length=512
    alltexts=list(dict.fromkeys(refs.texts+[s for r in refs.records.values() if r['domain']=='law' for ref in r['references'] for s in steps(ref['text'],'law')]+[s for rows in preds.values() for r in rows.values() if r['text'] for s in steps(r['text'],'finance' if r['key'].startswith('finance/') else 'law')]))
    text_index={s:i for i,s in enumerate(alltexts)}
    lengths=[len(model.tokenizer.encode(s,truncation=False)) for s in alltexts]
    reference_texts=set(refs.texts)|{s for r in refs.records.values() if r['domain']=='law' for ref in r['references'] for s in steps(ref['text'],'law')}
    assert all(lengths[text_index[s]]<=512 for s in reference_texts),'A reference step exceeds MPNet full capacity'
    config['reference_steps_over_limit']=0
    config['hypothesis_distinct_steps_over_limit']=sum(n>512 for n in lengths)
    config['hypothesis_long_step_handling']='existing per-step encoder truncation, now at native 512-token capacity; counted explicitly'
    (HERE/'roscoe_token_coverage.json').write_text(json.dumps({k:v for k,v in config.items() if k.startswith('reference_steps_') or k.startswith('hypothesis_')},indent=2)+'\n')
    cache=HERE/'cache'/('hol_roscoe_v2_'+sig);cache.mkdir(parents=True,exist_ok=True)
    vp=cache/'vectors.npy';dp=cache/'done.npy'
    if vp.exists():vectors=np.load(vp,mmap_mode='r+');encoded=np.load(dp,mmap_mode='r+')
    else:
        vectors=np.lib.format.open_memmap(vp,mode='w+',dtype=np.float32,shape=(len(alltexts),768))
        encoded=np.lib.format.open_memmap(dp,mode='w+',dtype=np.uint8,shape=(len(alltexts),))
        encoded[:]=0
    missing=sorted((i for i in range(len(alltexts)) if not encoded[i]),key=lambda i:min(lengths[i],512),reverse=True)
    for offset in range(0,len(missing),256):
        ids=missing[offset:offset+256]
        value=model.encode([alltexts[i] for i in ids],batch_size=args.batch_size,normalize_embeddings=True,show_progress_bar=False)
        vectors[ids]=value;encoded[ids]=1;vectors.flush();encoded.flush()
        if args.device=='mps':torch.mps.empty_cache()
        if offset%2048==0:print('ROSCOE vectors',offset,'/',len(missing),flush=True)
    del model
    if args.device=='mps':torch.mps.empty_cache()
    elif args.device=='cuda':torch.cuda.empty_cache()
    rouge=rouge_scorer.RougeScorer(['rougeL'],use_stemmer=False)
    tokenize=rouge._tokenizer.tokenize
    step_tokens=[tokenize(s) for s in refs.texts]
    step_embedding_ids=np.asarray([text_index[s] for s in refs.texts])
    parity_checks=0
    for name,rows in preds.items():
        for key in sorted(refs.records,key=lambda k:refs.records[k]['reference_count']):
            if (name,key) in done:continue
            started=time.time();record=refs.records[key];prediction=rows[key];text=prediction['text']
            if not text.strip():
                scores=dict(rouge_l=0.0,roscoe_sa_prec=0.0);winners=dict(rouge_l=None,roscoe_sa_prec=None)
            else:
                hyp_tokens=tokenize(text);masks={}
                for i,t in enumerate(hyp_tokens):masks[t]=masks.get(t,0)|(1<<i)
                def advance(state,tokens):
                    for t in tokens:
                        x=state|masks.get(t,0);state=x & ~(x-((state<<1)|1))
                    return state
                hyp_steps=steps(text,record['domain']);he=np.asarray(vectors[[text_index[s] for s in hyp_steps]])
                best_rouge=-1.0;best_roscoe=-1.0;win_rouge=None;win_roscoe=None
                if record['domain']=='law':
                    for ref in record['references']:
                        rt=tokenize(ref['text']);v=2*advance(0,rt).bit_count()/(len(rt)+len(hyp_tokens)) if rt and hyp_tokens else 0.0
                        ss=steps(ref['text'],'law');ev=np.asarray(vectors[[text_index[s] for s in ss]])
                        z=float((he@ev.T).max(1).mean())
                        if v>best_rouge:best_rouge=v;win_rouge=ref['reference_id']
                        if z>best_roscoe:best_roscoe=z;win_roscoe=ref['reference_id']
                else:
                    names=record['components'];collections=[refs.paths[n] for n in names]
                    needed=sorted({s for paths in collections for path in paths for s in path['step_ids']})
                    position={s:i for i,s in enumerate(needed)}
                    similarity=he@np.asarray(vectors[step_embedding_ids[needed]]).T
                    features=[];lens=[];headers=[]
                    for i,(n,paths) in enumerate(zip(names,collections),1):
                        headers.append(tokenize(f'[Scenario {i}: {n}]'))
                        features.append(np.stack([similarity[:,[position[s] for s in path['step_ids']]].max(1) for path in paths]))
                        lens.append([sum(len(step_tokens[s]) for s in path['step_ids']) for path in paths])
                    @functools.lru_cache(maxsize=250000)
                    def step_advance(step,state):return advance(state,step_tokens[step])
                    @functools.lru_cache(maxsize=200000)
                    def path_advance(component,index,state):
                        for step in collections[component][index]['step_ids']:state=step_advance(step,state)
                        return state
                    # Every Cartesian choice is visited, including text-equivalent paths.
                    for choice in itertools.product(*(range(len(x)) for x in collections)):
                        state=0;length=0
                        for j,index in enumerate(choice):
                            state=advance(state,headers[j]);state=path_advance(j,index,state)
                            length+=len(headers[j])+lens[j][index]
                        v=2*state.bit_count()/(length+len(hyp_tokens)) if length and hyp_tokens else 0.0
                        z=float(np.maximum.reduce([features[j][index] for j,index in enumerate(choice)]).mean())
                        if v>best_rouge:
                            best_rouge=v;win_rouge='|'.join(collections[j][index]['reference_id'] for j,index in enumerate(choice))
                        if z>best_roscoe:
                            best_roscoe=z;win_roscoe='|'.join(collections[j][index]['reference_id'] for j,index in enumerate(choice))
                    # Independent exact tokenizer and ROUGE check on a materialized choice.
                    first=next(refs.iter_choices(key));r=refs.get(key,first)['text']
                    flat=[]
                    for j,index in enumerate(first):
                        flat+=headers[j]
                        for s in collections[j][index]['step_ids']:flat+=step_tokens[s]
                    assert flat==tokenize(r)
                    if record['reference_count']==1 and parity_checks<3:
                        expected=rouge.score(r,text)['rougeL'].fmeasure
                        assert abs(expected-best_rouge)<1e-12
                        parity_checks+=1
                    step_advance.cache_clear();path_advance.cache_clear()
                scores=dict(rouge_l=best_rouge,roscoe_sa_prec=best_roscoe)
                winners=dict(rouge_l=win_rouge,roscoe_sa_prec=win_roscoe)
            result=dict(model=name,key=key,metric_maxima=scores,best_reference_ids=winners,
                reference_count=record['reference_count'],configuration_signature=sig,reference_sha256=config['reference_sha256'])
            with output.open('a') as f:f.write(json.dumps(result)+'\n')
            done[name,key]=result
            if len(done)%50==0 or record['reference_count']>1000:
                print('ROUGE/ROSCOE',name,key,'done',len(done),'/',len(preds)*len(refs.records),'case seconds',round(time.time()-started),flush=True)
    print('ROUGE/ROSCOE all cases complete',flush=True)


if __name__=='__main__':main()
