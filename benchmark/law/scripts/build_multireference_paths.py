"""Enumerate finite Boolean explanation paths and emit Isabelle obligations.

Every exported path is a sufficient signed-fact support for the case conclusion.
This is syntax-directed explanation enumeration, not enumeration of all HOL proofs.
"""
from functools import lru_cache
import itertools
import json
from pathlib import Path
import re
import sys

BASE=Path(__file__).resolve().parent.parent
sys.path.insert(0,str(BASE/'scripts'))
from convert_law_traces_to_nl import fact_to_nl, article_to_title, result_to_nl


def AND(*xs):return ('and',tuple(xs))
def OR(*xs):return ('or',tuple(xs))
def NOT(x):return ('not',x)
def REF(x):return ('ref',x)


def parse(s):
    s=re.sub(r'\s+x\b','',s)
    tokens=re.findall(r'\\<[^>]+>|\w+|[()]',s)
    assert ''.join(tokens)==re.sub(r'\s+','',s),s
    pos=0
    def atom():
        nonlocal pos
        t=tokens[pos];pos+=1
        if t==r'\<not>':return NOT(atom())
        if t=='(':
            v=expr();assert tokens[pos]==')';pos+=1;return v
        assert re.fullmatch(r'\w+',t),t
        return REF(t)
    def conj():
        nonlocal pos
        xs=[atom()]
        while pos<len(tokens) and tokens[pos]==r'\<and>':pos+=1;xs.append(atom())
        return xs[0] if len(xs)==1 else AND(*xs)
    def expr():
        nonlocal pos
        xs=[conj()]
        while pos<len(tokens) and tokens[pos]==r'\<or>':pos+=1;xs.append(conj())
        return xs[0] if len(xs)==1 else OR(*xs)
    v=expr();assert pos==len(tokens),(s,tokens[pos:]);return v


def load_rules(folder):
    defs={};names=[]
    for name in ['Case_kernel','Middle_concept']:
        text=(folder/f'{name}.thy').read_text()
        for m in re.finditer(r'definition (\w+) :: "person => bool" where\s*"\1 x (?:=|\\<longleftrightarrow>)\s*(.*?)"',text,re.S):
            defs[m[1]]=parse(m[2]);names.append(m[1])
    text=(folder/'Middle_concept.thy').read_text()
    for art,body in re.findall(r'"article_triggered (Art_\w+) x =\s*(.*?)"',text,re.S):defs['trigger:'+art]=parse(body)
    text=(folder/'General.thy').read_text()
    results=dict(re.findall(r'"article_result (Art_\w+) = (\w+)"',text))
    text=(folder/'Conflict.thy').read_text()
    edges=set(re.findall(r'(?:stronger_than|exception_to) (Art_\w+) (Art_\w+) = True',text))
    for art in results:
        defs['defeated:'+art]=AND(REF('trigger:'+art),OR(*(REF('trigger:'+h) for h,l in sorted(edges) if l==art)))
        defs['applicable:'+art]=AND(REF('trigger:'+art),NOT(REF('defeated:'+art)))
    defs['no_liability']=OR(*(REF('applicable:'+a) for a,r in results.items() if r=='No_Criminal_Liability'))
    return defs,names,results


def enumerate_case(defs,facts,root):
    @lru_cache(None)
    def value(node):
        op,args=node
        if op=='ref':return value(defs[args]) if args in defs else facts[args]
        if op=='not':return not value(args)
        return all(value(a) for a in args) if op=='and' else any(value(a) for a in args)
    @lru_cache(None)
    def paths(node):
        op,args=node;v=value(node)
        if op=='ref':
            if args not in defs:return frozenset([(frozenset([(args,v)]),frozenset())])
            return frozenset((support,steps|{(args,v)}) for support,steps in paths(defs[args]))
        if op=='not':return paths(args)
        combine=(op=='and' and v) or (op=='or' and not v)
        choices=[paths(a) for a in args if combine or value(a)==v]
        if combine:
            accum={(frozenset(),frozenset())}
            for choices_i in choices:
                accum={(a|c,b|d) for a,b in accum for c,d in choices_i}
            return frozenset(accum)
        return frozenset(itertools.chain.from_iterable(choices))
    assert value(root)
    candidates=paths(root)
    # Minimize support only within an identical derived-claim set.
    groups={}
    for support,steps in candidates:groups.setdefault(steps,set()).add(support)
    kept=[]
    for steps,supports in groups.items():
        minima=[]
        for support in sorted(supports,key=lambda x:(len(x),sorted(x))):
            if not any(s<=support for s in minima):minima.append(support)
        kept.extend((s,steps) for s in minima)
    return sorted(kept,key=lambda p:(sorted(p[0]),sorted(p[1]))),value


def main():
    dest=BASE/'data/multireference_validation';dest.mkdir(exist_ok=True)
    all_records=[];totals={};roots=[];audit=[]
    for dataset in sorted((BASE/'data').glob('*/dataset.json')):
        data=json.loads(dataset.read_text());bundle=data['bundle_name'];folder=BASE/'Isabelle_code'/bundle
        defs,names,results=load_rules(folder)
        catalog=data['scoring_target']['main']['rule_catalog']
        rnums={r['target']:r['rule_number'] for r in catalog if isinstance(r['target'],str)}
        out=dest/bundle;out.mkdir(exist_ok=True)
        for name in ['General','Case_kernel','Middle_concept','Conflict']:
            (out/f'{name}.thy').write_text((folder/f'{name}.thy').read_text())
        articles=list(results)
        disj=' \\<or> '.join('P '+a for a in articles)
        proof=['theory Paths_Validated imports Conflict begin',
               'lemma ex_article: "(\\<exists>a::article. P a) = ('+disj+')"',
               '  by (metis article.exhaust)']
        obligations=0
        for case in data['cases']:
            code=case['isabelle']['theory_code'];facts={}
            ax=code.split('axiomatization where',1)[1].split('\nlemma',1)[0]
            for neg,pred in re.findall(r'"(\\<not> )?(\w+) actor"',ax):facts[pred]=not bool(neg)
            conclusion=case['gold_trace']['final_result']
            expr=REF('no_liability') if conclusion=='No_Criminal_Liability' else AND(NOT(REF('no_liability')),OR(*(REF('applicable:'+a) for a,r in results.items() if r==conclusion)))
            try:
                paths,val=enumerate_case(defs,facts,expr)
            except AssertionError:
                audit.append(dict(case_id=case['case_id'],field='final_result',stored_value=conclusion,status='blocked_source_conclusion_mismatch'))
                continue
            for field,prefix in [('triggered_articles','trigger'),('applicable_articles','applicable')]:
                actual={a for a in results if val(REF(prefix+':'+a))}
                if actual!=set(case['gold_trace'][field]):
                    audit.append(dict(case_id=case['case_id'],field=field,source_value=sorted(actual),stored_value=case['gold_trace'][field]))
            records=[]
            # Postorder named claims gives deterministic dependency-respecting text.
            order=[];seen=set()
            def visit(n):
                op,a=n
                if op=='ref' and a in defs:
                    if a in seen:return
                    seen.add(a);visit(defs[a]);order.append(a)
                elif op=='not':visit(a)
                elif op in ['and','or']:
                    for child in a:visit(child)
            visit(expr)
            supports={}
            for idx,(support,steps) in enumerate(paths):
                support_key=tuple(sorted(support))
                if support_key not in supports:
                    lemma=f'{case["case_id"]}_support_{len(supports)}';supports[support_key]=lemma
                    facts_thy=['(\\<not> '+p+' x)' if not v else p+' x' for p,v in support_key]
                    conclusion_thy='final_no_liability x' if conclusion=='No_Criminal_Liability' else f'final_legal_result_holds x {conclusion}'
                    proof.append('lemma '+lemma+':')
                    proof.append('  assumes '+ ' and '.join('"'+f+'"' for f in facts_thy))
                    proof.append('  shows "'+conclusion_thy+'"')
                    proof.append('  using assms by (auto simp: '+ ' '.join(n+'_def' for n in names)+' defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)')
                    obligations+=1
                lines=[fact_to_nl(p,v,bundle) for p,v in support_key]
                for name in order:
                    if (name,val(REF(name))) not in steps:continue
                    v=val(REF(name))
                    if ':' in name:
                        kind,art=name.split(':');title=article_to_title(art,bundle)
                        word={'trigger':'triggered','defeated':'defeated','applicable':'applicable'}[kind]
                        line=f'{title} is '+('' if v else 'not ')+word+'.'
                        if kind=='trigger':line+=f' [Rule {rnums[art]}]'
                    elif name=='no_liability':line='An applicable no-liability article '+('exists.' if v else 'does not exist.')
                    else:
                        line=name.replace('_',' ').capitalize()+(' is established.' if v else ' is not established.')
                        if name in rnums:line+=f' [Rule {rnums[name]}]'
                    lines.append(line)
                lines.append('Answer: '+result_to_nl(conclusion))
                records.append(dict(reference_id=f'{case["case_id"]}:path:{idx}',text='\n'.join(lines),
                    support=[list(x) for x in support_key],validation_lemma=supports[support_key]))
            # Deduplicate only identical rendered references, retaining proof witnesses.
            unique={}
            for r in records:unique.setdefault(r['text'],r)
            all_records.append(dict(domain='law',dataset=bundle,case_id=case['case_id'],
                generated_path_count=len(paths),references=list(unique.values())))
        proof.append('end');(out/'Paths_Validated.thy').write_text('\n'.join(proof)+'\n')
        session='MultiRef_'+bundle
        extra=''
        if bundle=='aviation_security_with_authorizations':
            (out/'aswa_case_17.thy').write_text((folder/'aswa_case_17.thy').read_text())
            extra='    aswa_case_17\n'
        (out/'ROOT').write_text(f'session {session} = HOL +\n options [document=false]\n theories Paths_Validated\n'+extra)
        roots.append(bundle);totals[bundle]=dict(obligations=obligations,references=sum(len(r['references']) for r in all_records if r['dataset']==bundle))
        print(bundle,totals[bundle],flush=True)
    (dest/'ROOTS').write_text('\n'.join(roots)+'\n')
    (BASE/'data/law_multireference_candidates.jsonl').write_text(''.join(json.dumps(r,ensure_ascii=False)+'\n' for r in all_records))
    (dest/'summary.json').write_text(json.dumps(totals,indent=2)+'\n')
    (dest/'source_trace_audit.json').write_text(json.dumps(audit,indent=2)+'\n')


if __name__=='__main__':main()
