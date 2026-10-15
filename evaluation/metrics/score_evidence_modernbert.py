"""Exact full-text BERTScore over all references, with shared overlapping windows.

Windows encode up to 8190 content tokens plus CLS/SEP. Adjacent windows overlap
by 1024 content tokens. The overlap is divided at its midpoint; each original
content token is scored exactly once. Matching is global across all owned tokens,
not an average of window scores. First CLS and last SEP retain BERTScore's zero
averaging weights, while remaining eligible alignment targets as in bert-score.
"""
import argparse
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
from transformers import AutoModel, AutoTokenizer
from evidence_reference_reader import EvidenceReferences, HERE

CONTENT=8190
OVERLAP=1024
STRIDE=CONTENT-OVERLAP


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def windows(length):
    if length == 0:
        yield (0,0,0,0,True,True)
        return
    starts=[0]
    while starts[-1]+CONTENT < length:
        starts.append(starts[-1]+STRIDE)
    for i,start in enumerate(starts):
        stop=min(start+CONTENT,length)
        lo=0 if i==0 else OVERLAP//2
        hi=stop-start if i==len(starts)-1 else CONTENT-OVERLAP//2
        yield start,stop,lo,hi,i==0,i==len(starts)-1


class Encoder:
    def __init__(self,model_dir,device):
        self.device=device
        self.tokenizer=AutoTokenizer.from_pretrained(model_dir,local_files_only=True)
        self.model=AutoModel.from_pretrained(model_dir,local_files_only=True,
            reference_compile=False,attn_implementation='sdpa',torch_dtype=torch.float16 if device in ('mps','cuda') else torch.float32).to(device).eval()
        assert self.model.config.num_hidden_layers==22
        assert self.model.config.max_position_embeddings==8192
        if device in ('mps','cuda'):
            from modernbert_sparse_attention import install
            install(self.model)

    def ids(self,text):
        return np.asarray(self.tokenizer.encode(text,add_special_tokens=False,truncation=False),dtype=np.uint16)

    @torch.inference_mode()
    def encode_window(self,ids):
        assert len(ids)<=CONTENT
        t=self.tokenizer
        sequence=[t.cls_token_id]+ids.tolist()+[t.sep_token_id]
        x=torch.tensor([sequence],dtype=torch.long,device=self.device)
        v=self.model(input_ids=x,attention_mask=torch.ones_like(x)).last_hidden_state[0].float()
        return torch.nn.functional.normalize(v,dim=-1)

    @torch.inference_mode()
    def encode_full(self,ids):
        chunks=[]
        for start,stop,lo,hi,first,last in windows(len(ids)):
            v=self.encode_window(ids[start:stop])
            if first:chunks.append(v[:1].cpu())
            chunks.append(v[lo+1:hi+1].cpu())
            if last:chunks.append(v[-1:].cpu())
            del v
        return torch.cat(chunks).to(self.device)


class TokenReferences:
    def __init__(self,refs,encoder):
        self.refs=refs;self.encoder=encoder
        self.steps=[encoder.ids(s) for s in refs.texts]
        self.newline=encoder.ids('\n')
        self.path_cache={}
        # Byte-level tokenization boundaries must be exact; NFC cannot cross a newline.
        # Verify each possible step at both of its actual line boundaries.
        for s,ids in zip(refs.texts,self.steps):
            joined=np.concatenate((encoder.ids('Header.\n'),ids,encoder.ids('\nFooter.')))
            assert np.array_equal(joined,encoder.ids('Header.\n'+s+'\nFooter.'))
        print('All step tokenization boundaries verified',len(self.steps),flush=True)

    def path_ids(self,name,index):
        key=(name,index)
        if key not in self.path_cache:
            steps=self.refs.paths[name][index]['step_ids'];parts=[]
            for j,s in enumerate(steps):
                if j:parts.append(self.newline)
                parts.append(self.steps[s])
            self.path_cache[key]=np.concatenate(parts)
        return self.path_cache[key]

    def choices(self,key):
        r=self.refs.records[key]
        if r['domain']=='law':
            for ref in r['references']:
                yield ref['reference_id'],self.encoder.ids(ref['text'])
            return
        names=r['components']
        prefixes=[self.encoder.ids(('' if i==1 else '\n\n')+f'[Scenario {i}: {name}]\n') for i,name in enumerate(names,1)]
        for indices in self.refs.iter_choices(key):
            parts=[];ident=[]
            for name,index,prefix in zip(names,indices,prefixes):
                parts.extend((prefix,self.path_ids(name,index)))
                ident.append(self.refs.paths[name][index]['reference_id'])
            ids=np.concatenate(parts)
            if all(i==0 for i in indices):
                assert np.array_equal(ids,self.encoder.ids(self.refs.get(key,indices)['text']))
            yield '|'.join(ident),ids


def build_bank(key,tokens,folder):
    folder.mkdir(parents=True,exist_ok=True)
    meta=folder/'bank.json'
    if meta.exists():return json.loads(meta.read_text())
    lookup={};bank=[];references=[];offset=0
    with (folder/'tokens.u16').open('wb') as f:
        for ref_id,ids in tokens.choices(key):
            parts=[];covered=0
            for start,stop,lo,hi,first,last in windows(len(ids)):
                content=ids[start:stop].tobytes()
                signature=(hashlib.sha256(content).hexdigest(),lo,hi,first,last)
                if signature not in lookup:
                    i=len(bank);lookup[signature]=i
                    bank.append([offset,stop-start,lo,hi,first,last])
                    f.write(content);offset+=stop-start
                parts.append(lookup[signature]);covered+=hi-lo
            assert covered==len(ids)
            references.append([ref_id,len(ids),parts])
    data=dict(key=key,windows=bank,references=references)
    meta.write_text(json.dumps(data)+'\n')
    print('Window bank',key,'references',len(references),'unique windows',len(bank),flush=True)
    return data


def verify_reduction(encoder):
    # A dense BERTScore implementation must match the public reduction routine.
    from bert_score.utils import greedy_cos_idf
    a=encoder.encode_full(encoder.ids('A signed contract is missing. The claim is partially approved.'))
    b=encoder.encode_full(encoder.ids('The claim is partly approved because the contract lacks a signature.'))
    sim=a@b.T
    p=sim.max(0).values[1:-1].mean();r=sim.max(1).values[1:-1].mean()
    direct=2*p*r/(p+r)
    ma=torch.ones((1,len(a)),device=encoder.device,dtype=torch.long)
    mb=torch.ones((1,len(b)),device=encoder.device,dtype=torch.long)
    wa=ma.float();wb=mb.float();wa[:,[0,-1]]=0;wb[:,[0,-1]]=0
    public=greedy_cos_idf(a[None].clone(),ma,wa,b[None].clone(),mb,wb)[2][0]
    assert torch.allclose(direct,public,atol=1e-6),(direct,public)
    # Check long-window coverage on every boundary and a 50k-token example.
    for length in [1,8189,8190,8191,14332,15356,47438,50000]:
        intervals=[(a+lo,a+hi) for a,b,lo,hi,first,last in windows(length)]
        assert intervals[0][0]==0 and intervals[-1][1]==length
        assert all(x[1]==y[0] for x,y in zip(intervals,intervals[1:]))
    result=dict(status='passed',short_text_public_bertscore_difference=float(abs(direct-public)),
        coverage_test_lengths=[1,8189,8190,8191,14332,15356,47438,50000])
    (HERE/'modernbert_reduction_verification.json').write_text(json.dumps(result,indent=2)+'\n')
    print('BERTScore reduction and full-token coverage passed',flush=True)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--model-dir',type=Path,required=True)
    parser.add_argument('--cache',type=Path,default=HERE/'cache')
    parser.add_argument('--device',default='mps')
    parser.add_argument('--key',action='append')
    parser.add_argument('--inventory-only',action='store_true')
    args=parser.parse_args();torch.set_num_threads(4)
    if args.device=='mps':torch.mps.set_per_process_memory_fraction(0.60)
    weights_sha=digest(args.model_dir/'model.safetensors')
    assert weights_sha=='340ac08b74eef0d7bdec2d7981a6a3d4249bf0e6aab60634b72ad02c2b8023a9'
    predictions={p.name.removesuffix('_predictions.jsonl'):{r['key']:r for r in map(json.loads,p.open())} for p in sorted(HERE.glob('*_predictions.jsonl'))}
    config=dict(model='answerdotai/ModernBERT-base',weights_sha256=weights_sha,
        tokenizer_sha256=digest(args.model_dir/'tokenizer.json'),layer=22,window_tokens=8192,
        content_tokens=CONTENT,overlap_content_tokens=OVERLAP,overlap_handling='midpoint ownership; each content token once',
        matching='global token cosine greedy precision/recall, then harmonic F1; not a mean of window scores',
        idf=False,rescale_with_baseline=False,special_tokens='first CLS and last SEP only; zero averaging weights, eligible matching targets',
        encoder_dtype='float16' if args.device in ('mps','cuda') else 'float32',matching_dtype='float32',
        reference_sha256=digest(HERE/'references.jsonl'),steps_sha256=digest(HERE/'finance_evidence_steps.json'),
        prediction_sha256={p.name:digest(p) for p in sorted(HERE.glob('*_predictions.jsonl'))})
    signature=hashlib.sha256(json.dumps(config,sort_keys=True).encode()).hexdigest()
    cache=args.cache/signature;cache.mkdir(parents=True,exist_ok=True)
    (HERE/'modernbert_configuration.json').write_text(json.dumps(dict(config,signature=signature),indent=2)+'\n')
    encoder=Encoder(args.model_dir,args.device);verify_reduction(encoder)
    refs=EvidenceReferences(set(args.key) if args.key else None)
    tokens=TokenReferences(refs,encoder)
    out=HERE/'modernbert_case_scores.jsonl';completed={}
    if out.exists():
        for r in map(json.loads,out.open()):
            assert r['configuration_signature']==signature
            completed[r['key'],r['model']]=r
    # Small cases first; checkpoints permit exact resumption of large cases.
    order=sorted(refs.records,key=lambda k:(refs.records[k]['reference_count'],k))
    for key in order:
        if all((key,n) in completed for n in predictions):continue
        names=list(predictions)
        folder=cache/hashlib.sha256(key.encode()).hexdigest()[:20]
        bank=build_bank(key,tokens,folder)
        if args.inventory_only:continue
        started=time.time();hyp=[];slices=[];cursor=0
        for name in names:
            text=predictions[name][key]['text']
            v=encoder.encode_full(encoder.ids(text)) if text.strip() else torch.empty((0,768),device=args.device)
            slices.append((cursor,cursor+len(v)));cursor+=len(v);hyp.append(v)
        hypothesis=torch.cat(hyp);del hyp
        nw=len(bank['windows']);nm=len(names)
        feature_shape=(nw,cursor);recall_shape=(nw,nm)
        state_path=folder/'feature_state.json'
        state=dict(models=names,feature_shape=feature_shape,recall_shape=recall_shape)
        if state_path.exists():
            old=json.loads(state_path.read_text())
            assert old==json.loads(json.dumps(state))
            mode='r+'
        else:
            state_path.write_text(json.dumps(state));mode='w+'
        if cursor:
            features=np.memmap(folder/'precision.f32',dtype=np.float32,mode=mode,shape=feature_shape)
            recalls=np.memmap(folder/'recall.f32',dtype=np.float32,mode=mode,shape=recall_shape)
            done=np.memmap(folder/'done.u8',dtype=np.uint8,mode=mode,shape=(nw,))
            raw=np.memmap(folder/'tokens.u16',dtype=np.uint16,mode='r')
            for i,(offset,length,lo,hi,first,last) in enumerate(bank['windows']):
                if done[i]:continue
                v=encoder.encode_window(np.asarray(raw[offset:offset+length]))
                owned=v[lo+1:hi+1]
                # One matrix multiplication per core; all eleven hypotheses share it.
                with torch.inference_mode():
                    similarities=owned@hypothesis.T
                    maxima=similarities.max(0).values
                    if first:maxima=torch.maximum(maxima,v[0]@hypothesis.T)
                    if last:maxima=torch.maximum(maxima,v[-1]@hypothesis.T)
                    features[i]=maxima.cpu().numpy()
                    for j,(a,b) in enumerate(slices):
                        recalls[i,j]=float(similarities[:,a:b].max(1).values.sum()) if b>a else 0.0
                del v,owned,similarities,maxima
                if args.device=='mps':torch.mps.empty_cache()
                done[i]=1
                if i%16==0 or i==nw-1:
                    features.flush();recalls.flush();done.flush()
                    print('BERT windows',key,i+1,'/',nw,'elapsed',round(time.time()-started),flush=True)
            best=np.full(nm,-np.inf);winners=[None]*nm
            for ref_id,length,parts in bank['references']:
                pm=np.maximum.reduce([features[i] for i in parts])
                rs=np.sum(recalls[parts],axis=0,dtype=np.float64)
                for j,(a,b) in enumerate(slices):
                    if b-a<=2:value=0.0
                    else:
                        p=float(pm[a+1:b-1].mean(dtype=np.float64));r=rs[j]/length
                        value=2*p*r/(p+r) if p+r else 0.0
                    if value>best[j]:
                        best[j]=value
                        winners[j]=ref_id if b-a>2 else None
            del features,recalls,done,raw
        else:best=np.zeros(nm);winners=[None]*nm
        with out.open('a') as f:
            for name,value,winner in zip(names,best,winners):
                if (key,name) in completed:continue
                row=dict(key=key,model=name,bertscore_f1=float(value),best_reference_id=winner,
                    reference_count=len(bank['references']),configuration_signature=signature,
                    reference_sha256=config['reference_sha256'])
                f.write(json.dumps(row)+'\n');completed[key,name]=row
        del hypothesis
        if args.device=='mps':torch.mps.empty_cache()
        print('BERT CASE COMPLETE',key,'models',len(names),'cases',len(completed)//len(predictions),flush=True)


if __name__=='__main__':main()
