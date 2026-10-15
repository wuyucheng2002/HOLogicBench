"""Independently audit and reaggregate all 16 settings without APIs or model weights."""
import argparse
import csv
import gzip
import hashlib
import json
import math
import statistics
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BENCHMARK = ROOT / 'benchmark'
H = BENCHMARK / 'references'
TYPES = ['PR', 'PT', 'PC', 'PS', 'PQ']
METRICS = ['accuracy', 'bertscore_f1', 'roscoe_sa_prec', 'rule_recall']

def open_text(path):
    return path.open(encoding='utf-8') if path.exists() else gzip.open(str(path)+'.gz', 'rt', encoding='utf-8')

def records(path):
    with open_text(path) as f:
        rows = [json.loads(line) for line in f if line.strip()]
    mapping = {r['key']: r for r in rows}
    assert len(rows) == len(mapping), f'Duplicate keys in {path.name}'
    return mapping

def close(a, b, context):
    assert math.isclose(a, b, rel_tol=0, abs_tol=1e-10), (context, a, b)

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, help='Optional separate output directory')
    args = parser.parse_args()
    refs = records(H / 'references.jsonl')
    table = json.loads((ROOT / 'results/main/hol_main_results.json').read_text())
    assert len(refs) == table['overall_case_count'] == 1379
    assert len(table['models']) == 16
    assert sum(r['domain'] == 'finance' for r in refs.values()) == 1079
    assert sum(r['domain'] == 'law' for r in refs.values()) == 300
    refhash = hashlib.sha256((H / 'references.jsonl').read_bytes()).hexdigest()
    counts = {}
    with open_text(H / 'finance_evidence_catalog.jsonl') as f:
        for line in f:
            row = json.loads(line)
            counts[row['case']] = len(row['paths'])
    assert sum(counts.values()) == 25108
    for r in refs.values():
        expected = math.prod(counts[n] for n in r['components']) if r['domain'] == 'finance' else len(r['references'])
        assert r['reference_count'] == expected
    assert sum(r['reference_count'] for r in refs.values() if r['domain']=='finance') == 262249
    assert sum(r['reference_count'] for r in refs.values() if r['domain']=='law') == 2677
    def valid_witness(ref, witness):
        if ref['domain'] == 'law':
            return witness in {r['reference_id'] for r in ref['references']}
        if not isinstance(witness, str):
            return False
        parts = witness.split('|')
        if len(parts) != len(ref['components']):
            return False
        for name, part in zip(ref['components'], parts):
            prefix = name + ':path:'
            if not part.startswith(prefix):
                return False
            idx = part[len(prefix):]
            if not idx.isdigit() or not 0 <= int(idx) < counts[name]:
                return False
        return True
    rule_refs = records(H / 'rule_recall_references.jsonl')
    assert rule_refs.keys() == refs.keys()
    computed = []
    model_results = {}
    for model in table['models']:
        name = model['model']
        scores = records(ROOT / 'results/per_case' / (name + '_case_scores.jsonl'))
        preds = records(ROOT / 'results/per_case' / (name + '_predictions.jsonl'))
        recalls = records(ROOT / 'results/per_case' / (name + '_rule_recall.jsonl'))
        assert scores.keys() == preds.keys() == recalls.keys() == refs.keys(), name
        for key, row in scores.items():
            assert row['model'] == preds[key]['model'] == name
            assert row['answer_correct'] == preds[key]['answer_correct']
            assert row['answer_correct'] in (0, 1)
            assert row['reference_sha256'] == refhash
            assert row['reference_count'] == refs[key]['reference_count']
            assert row['hol_types'] == refs[key]['hol_types']
            close(row['rule_recall'], recalls[key]['rule_recall'], (name,key,'recall'))
            assert 0 <= row['rule_recall'] <= 1
            rr = recalls[key]
            cited = set(map(str, rr['predicted_rule_ids']))
            choices = rule_refs[key]['variants']
            expected_recall = max(len(cited & set(map(str,v['rule_ids']))) / len(v['rule_ids']) if v['rule_ids'] else 1.0 for v in choices)
            close(row['rule_recall'], expected_recall, (name,key,'maximum rule recall'))
            assert valid_witness(refs[key], rr['best_reference_id']), (name,key,'rule witness')
            for metric, value in row['metric_maxima'].items():
                assert math.isfinite(value) and -1.00001 <= value <= 1.00001
                witness = row['best_reference_ids'][metric]
                if not preds[key]['text'].strip():
                    assert value == 0 and witness is None
                else:
                    assert valid_witness(refs[key], witness), (name,key,metric,witness)
        groups = {}
        for category in TYPES + ['Overall']:
            keys = [k for k,r in refs.items() if category=='Overall' or category in r['hol_types']]
            def value(k, metric):
                if metric=='accuracy': return preds[k]['answer_correct']
                if metric=='rule_recall': return scores[k]['rule_recall']
                return scores[k]['metric_maxima'][metric]
            vals = {m:statistics.mean(value(k,m) for k in keys) for m in METRICS}
            for m,v in vals.items():
                expected = model['overall_'+m] if category=='Overall' else model['groups'][category][m]
                close(v,expected,(name,category,m))
            if category!='Overall':
                assert len(keys)==table['case_counts'][category]==model['groups'][category]['n']
            groups[category]=vals
            computed.append(dict(model=name,hol_type=category,n=len(keys),**vals))
        model_results[name]=groups
    for category in TYPES+['Overall']:
        vals={m:statistics.mean(groups[category][m] for groups in model_results.values()) for m in METRICS}
        for m,v in vals.items():
            expected=table['average']['overall_'+m] if category=='Overall' else table['average']['groups'][category][m]
            close(v,expected,('Average',category,m))
        computed.append(dict(model='Average',hol_type=category,n=1379 if category=='Overall' else table['case_counts'][category],**vals))
    with (ROOT/'results/main/hol_main_results.csv').open() as f:
        saved={(r['model'],r['hol_type']):r for r in csv.DictReader(f)}
    assert len(saved)==len(computed)
    for row in computed:
        old=saved[row['model'],row['hol_type']]
        assert int(old['n'])==row['n']
        for m in METRICS:close(row[m],float(old[m]),(row['model'],row['hol_type'],m,'CSV'))
    proof=json.loads((ROOT/'validation/formal/law_validation_manifest.json').read_text())
    for path,digest in proof['source_sha256'].items():
        assert hashlib.sha256((BENCHMARK/path).read_bytes()).hexdigest()==digest,path
    assert hashlib.sha256((BENCHMARK/'law/data/law_multireference_candidates.jsonl').read_bytes()).hexdigest()==proof['candidates_sha256']
    report=dict(status='passed',model_settings=16,cases=1379,model_case_pairs=16*1379,
                table_rows=len(computed),law_proof_source_hashes_verified=True,
                neural_similarity_scores_recomputed=False,rule_recall_recomputed=True,
                checks=['case coverage','prediction/score agreement','finite metric ranges','reference counts',
                        'reference witness validity','rule recall maxima from recorded cited IDs','all table means','CSV agreement','proof source hashes'])
    if args.output:
        args.output.mkdir(parents=True,exist_ok=True)
        (args.output/'verification.json').write_text(json.dumps(report,indent=2)+'\n')
        with (args.output/'reproduced_results.csv').open('w',newline='') as f:
            writer=csv.DictWriter(f,fieldnames=['model','hol_type','n']+METRICS)
            writer.writeheader();writer.writerows(computed)
    print(json.dumps(report,indent=2))

if __name__=='__main__':
    main()
