"""Preserve every exported tree; factor composite cases without merging paths."""
import hashlib
import json
import math
import re
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]/'benchmark'
HERE=ROOT/'references'
SOURCE=ROOT/'finance/data/all_reasoning_paths.jsonl'


def human(text):
    text=str(text)
    symbols={'and':'AND','or':'OR','not':'NOT','longrightarrow':'IMPLIES','Rightarrow':'=>','le':'<='}
    for a,b in symbols.items():text=text.replace('\\<'+a+'>',b)
    text=re.sub(r'input_record_(\d+)',r'(input \1)',text)
    return text.replace('_',' ')


def statement(n):
    return human(n['expression'])+' = '+human(n['value'])


def render(n,nodes,labels=None):
    kind=n['kind'];children=[nodes[i] for i in n['premises']]
    def number(i):return labels[i] if labels is not None else i
    label=f'Step {number(n["id"])}: '
    def link(c):return f'step {number(c["id"])} ({human(c["value"])})'
    # The full expression and input bindings remain in the source graph. Cite
    # already evaluated premises instead of recursively printing them again.
    expression=n['expression']
    for c in sorted(children,key=lambda c:len(c['expression']),reverse=True):
        if c['expression']!=expression:
            expression=expression.replace(c['expression'],f'[step {number(c["id"])}]')
    compact=human(expression)+' = '+human(n['value'])
    support=' Supported by '+', '.join(link(c) for c in children)+'.' if children else ''
    if kind=='fact':return label+'Evidence: '+statement(n)+'.'
    if kind.startswith('if:'):
        return label+'IF guard '+link(children[0])+': select '+kind.split(':')[1]+' branch '+', '.join(link(c) for c in children[1:])+'. Result: '+human(n['value'])+'.'
    if kind.startswith('and:') or kind.startswith('or:') or kind.startswith('implies:'):
        return label+'Inference '+kind.upper()+': '+compact+'.'+support
    if kind.startswith('rule:'):
        return label+'Rule: '+statement(n)+'.'+support
    if kind=='not':return label+'Negation: '+compact+'.'+support
    if kind in ('case','let'):
        return label+kind.capitalize()+' selected evaluation: '+human(n['value'])+'.'+support
    return label+kind.capitalize()+': '+compact+'.'+support


def main():
    texts=[];text_ids={};counts={};roots={};summary=[]
    def intern(text):
        if text not in text_ids:text_ids[text]=len(texts);texts.append(text)
        return text_ids[text]
    source_hash=hashlib.sha256(SOURCE.read_bytes()).hexdigest()
    with (HERE/'finance_evidence_catalog.jsonl').open('w') as out:
        for line in SOURCE.open():
            row=json.loads(line);assert row['complete'] and row['status']=='complete'
            nodes={n['id']:n for n in row['path_nodes']}
            paths=[]
            for index,root in enumerate(row['path_roots']):
                order=[];seen=set()
                def visit(i):
                    if i in seen:return
                    seen.add(i)
                    for j in nodes[i]['premises']:visit(j)
                    order.append(i)
                visit(root)
                labels={node_id:i for i,node_id in enumerate(order,1)}
                paths.append(dict(reference_id=f'{row["case"]}:path:{index}',root_id=root,node_ids=order,
                                  step_ids=[intern(render(nodes[i],nodes,labels)) for i in order]))
            counts[row['case']]=len(paths);roots[row['case']]=row['path_roots']
            out.write(json.dumps(dict(case=row['case'],source_sha256=source_hash,
                                     input_bindings=row['input_bindings'],nodes=row['path_nodes'],paths=paths),ensure_ascii=False)+'\n')
            summary.append(dict(case=row['case'],exported_paths=len(row['path_roots']),preserved_paths=len(paths)))
    (HERE/'finance_evidence_steps.json').write_text(json.dumps(texts,ensure_ascii=False)+'\n')
    mapping={};new=[]
    for p in sorted((ROOT/'finance/data').glob('sample[123].json')):
        for c in json.loads(p.read_text()):
            key=f'finance/{p.stem}/{c["id"]}'
            names=[b['resolved_case_name'] for b in c['isabelle_case_conditions_nl']]
            mapping[key]=names
            new.append(dict(key=key,domain='finance',dataset=p.stem,case_id=c['id'],
                            hol_types=c['hol_types'],components=names,
                            reference_format='cartesian_evidence_paths_v2',
                            reference_count=math.prod(counts[n] for n in names)))
    law_cases={}
    for p in (ROOT/'law/data').glob('*/dataset.json'):
        d=json.loads(p.read_text())
        for c in d['cases']:law_cases[d['bundle_name'],c['case_id']]=c
    for line in (ROOT/'law/data/law_multireference_candidates.jsonl').open():
        r=json.loads(line);c=law_cases[r['dataset'],r['case_id']]
        new.append(dict(key=f'law/{r["dataset"]}/{r["case_id"]}',domain='law',dataset=r['dataset'],
                        case_id=r['case_id'],hol_types=c['hol_types'],references=r['references'],
                        reference_count=len(r['references'])))
    (HERE/'references.jsonl').write_text(''.join(json.dumps(r,ensure_ascii=False)+'\n' for r in new))
    manifest=dict(schema='evidence_preserving_v2',source_sha256=source_hash,
        catalog_sha256=hashlib.sha256((HERE/'finance_evidence_catalog.jsonl').read_bytes()).hexdigest(),
        steps_sha256=hashlib.sha256((HERE/'finance_evidence_steps.json').read_bytes()).hexdigest(),
        formal_subcases=len(counts),formal_paths=sum(counts.values()),unique_step_texts=len(texts),
        finance_cases=len(mapping),finance_composite_references=sum(r['reference_count'] for r in new if r['domain']=='finance'),
        law_references=sum(r['reference_count'] for r in new if r['domain']=='law'),
        text_format='Every reachable node once in dependency order; path-local step numbers replace repeated formula expansion and arbitrary source node IDs in text. Original node IDs, expressions, premises and input bindings preserved in catalog.',
        path_deduplication='none; text interning is storage sharing only',per_subcase=summary)
    (HERE/'evidence_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print({k:v for k,v in manifest.items() if k!='per_subcase'})


if __name__=='__main__':main()
