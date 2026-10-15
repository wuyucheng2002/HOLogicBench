"""Describe the corrected finance tree export; do not modify source records."""
import argparse
from collections import Counter, defaultdict
import functools
import hashlib
import json
from pathlib import Path
import statistics


def describe(values):
    a = sorted(values)
    def percentile(p):
        pos = (len(a) - 1) * p
        low = int(pos)
        high = min(low + 1, len(a) - 1)
        return a[low] + (a[high] - a[low]) * (pos - low)
    return dict(min=a[0], max=a[-1], mean=statistics.mean(a),
                median=statistics.median(a), p90=percentile(.9),
                p95=percentile(.95), p99=percentile(.99))


def path_metrics(record):
    nodes = {n['id']: n for n in record['path_nodes']}
    rule_ids, evidence_ids = {}, {}
    def bit(table, key):
        if key not in table:
            table[key] = 1 << len(table)
        return table[key]
    @functools.lru_cache(None)
    def visit(i):
        n = nodes[i]
        children = [visit(j) for j in n['premises']]
        named = n['kind'].startswith('rule:')
        rules = bit(rule_ids, n['kind']) if named else 0
        evidence = (bit(evidence_ids, (n['expression'], n['value']))
                    if n['kind'] in ('fact', 'case-input', 'opaque') else 0)
        for c in children:
            rules |= c[3]
            evidence |= c[4]
        # Count an unfolded tree, not distinct storage nodes.
        return (1 + sum(c[0] for c in children),
                max((c[1] + 1 for c in children), default=0),
                int(named) + sum(c[2] for c in children), rules, evidence)
    result = []
    for index, root in enumerate(record['path_roots']):
        size, depth, occurrences, rules, evidence = visit(root)
        result.append(dict(path_index=index, tree_nodes=size, depth_edges=depth,
                           rule_occurrences=occurrences,
                           distinct_rules=bin(rules).count('1'),
                           distinct_evidence=bin(evidence).count('1')))
    return result


def main():
    base = Path(__file__).resolve().parent.parent / 'data'
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', type=Path, default=base / 'all_reasoning_paths.jsonl')
    parser.add_argument('--output-dir', type=Path, default=base / 'reasoning_path_statistics')
    args = parser.parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    rows, all_metrics = [], defaultdict(list)
    groups = {key: defaultdict(list) for key in ('type', 'evaluator', 'result')}
    seen = set()
    source_hash = hashlib.sha256()
    with args.input.open('rb') as source, (args.output_dir / 'per_path.jsonl').open('w') as paths:
        for line in source:
            source_hash.update(line)
            r = json.loads(line)
            assert r['case'] not in seen
            seen.add(r['case'])
            assert r['complete'] and not r['issues'], r['case']
            metrics = path_metrics(r)
            assert len(metrics) == r['path_count'] > 0
            row = {k: r[k] for k in ('case', 'type', 'evaluator', 'result', 'path_count')}
            row['sample_refs'] = r.get('sample_refs', [])
            row['unique_derivation'] = r['path_count'] == 1
            for key in metrics[0]:
                if key == 'path_index':
                    continue
                vals = [m[key] for m in metrics]
                row[key] = describe(vals)
                all_metrics[key].extend(vals)
            for m in metrics:
                paths.write(json.dumps(dict(case=r['case'], **m), ensure_ascii=False) + '\n')
            rows.append(row)
            for key in groups:
                groups[key][r[key]].append(r['path_count'])
    rows.sort(key=lambda r: (-r['path_count'], r['case']))
    counts = [r['path_count'] for r in rows]
    total = sum(counts)
    hist = Counter(counts)
    buckets = [(1, 1), (2, 2), (3, 4), (5, 8), (9, 16), (17, 64), (65, 256), (257, None)]
    summary = dict(
        input=str(args.input.resolve()), source_sha256=source_hash.hexdigest(),
        scope='1602 exported finance/reimbursement formal cases; not the separate law dataset or NL sample count',
        definitions=dict(path_count='Canonical root-global non-dominated business derivation trees, not all HOL proofs',
                         tree_nodes='Nodes in the unfolded tree, including facts, literals and connective/computation scaffolding',
                         depth_edges='Longest root-to-leaf edge count; a leaf has depth zero',
                         rule_occurrences='Named business-rule nodes counted with tree multiplicity',
                         distinct_rules='Distinct named business rules within one tree',
                         distinct_evidence='Distinct input (expression,value) pairs within one tree',
                         percentiles='Linear interpolation at (n-1)*p',
                         path_weighted='Every exported tree has equal weight; large-path-count cases dominate'),
        total_cases=len(rows), total_paths=total, unique_cases=hist[1],
        multi_path_cases=len(rows)-hist[1], paths_per_case=describe(counts),
        exact_path_count_histogram=[dict(path_count=k, cases=v) for k,v in sorted(hist.items())],
        buckets=[dict(range=str(low) if low==high else f'{low}-{high or "infinity"}',
                      cases=sum(low <= n and (high is None or n <= high) for n in counts))
                 for low,high in buckets],
        concentration={f'top_{k}_case_path_share':sum(counts[:k])/total for k in (1,5,10,20)},
        path_weighted_metrics={k:describe(v) for k,v in all_metrics.items()},
        case_weighted_metric_means={k:statistics.mean(r[k]['mean'] for r in rows) for k in all_metrics},
        top_cases=[{k:r[k] for k in ('case','type','result','path_count')} for r in rows[:20]],
        groups={key:[dict(group=g, cases=len(v), total_paths=sum(v), unique_cases=v.count(1),
                          multi_path_cases=len(v)-v.count(1), paths_per_case=describe(v))
                     for g,v in sorted(buckets.items())] for key,buckets in groups.items()})
    for name, data in [('per_case.json', rows), ('summary.json', summary)]:
        (args.output_dir / name).write_text(json.dumps(data, ensure_ascii=False, indent=2)+'\n')
    print(json.dumps({k:summary[k] for k in ('total_cases','total_paths','unique_cases','multi_path_cases',
        'paths_per_case','buckets','concentration','top_cases','path_weighted_metrics','case_weighted_metric_means')},
        ensure_ascii=False,indent=2))


if __name__ == '__main__':
    main()
