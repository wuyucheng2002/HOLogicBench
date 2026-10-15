"""Independent batch oracle for root-global enumeration (no Isabelle required).

Enumerates every raw tree without pruning, then batch-filters root signatures.
Checks every exported root against that set. SHA-256 encodes structural identity;
this is regression validation, not a machine-checked implementation proof.
"""
import argparse
import functools
import hashlib
import itertools
import json
from pathlib import Path


@functools.lru_cache(maxsize=65536)
def label_digest(kind, expression, value):
    return hashlib.sha256(json.dumps(
        [kind, expression, value],
        ensure_ascii=False).encode()).hexdigest()


def digest(n, children):
    label = label_digest(n['kind'], n['expression'], n['value'])
    return hashlib.sha256((label + ''.join(sorted(children))).encode()).hexdigest()


def expected(record):
    nodes = {n['id']: n for n in record['nodes']}
    evidence_pool, rule_pool = {}, {}

    @functools.lru_cache(None)
    def visit(i):
        n = nodes[i]
        result = {}
        for alt in n['alternatives']:
            for combo in itertools.product(*(visit(j).items() for j in alt)):
                children = dict(combo)
                ev = set()
                rs = set()
                cost = 1
                for e, r, s in children.values():
                    ev.update(e)
                    rs.update(r)
                    cost += s
                if n['kind'] in ('fact', 'case-input', 'opaque'):
                    ev.add((n['expression'], n['value']))
                if n['kind'].startswith('rule:'):
                    rs.add(n['kind'])
                ev, rs = frozenset(ev), frozenset(rs)
                ev = evidence_pool.setdefault(ev, ev)
                rs = rule_pool.setdefault(rs, rs)
                result[digest(n, children)] = (ev, rs, cost)
        return result

    roots = visit(record['root'])
    # Batch grouping, unlike production's streaming antichain implementation.
    buckets = {}
    for ev, rs, cost in roots.values():
        group = buckets.setdefault(rs, {})
        group[ev] = min(cost, group.get(ev, cost))
    minimal_evidence = {}
    for rs, group in buckets.items():
        by_count = {}
        for e in group:
            by_count.setdefault(len(e), []).append(e)
        minimal_evidence[rs] = {e for e in group if not any(
            f < e for count, bucket in by_count.items() if count < len(e)
            for f in bucket)}
    result = {key for key, (ev, rs, cost) in roots.items()
              if ev in minimal_evidence[rs] and cost == buckets[rs][ev]}
    count = len(roots)
    visit.cache_clear()
    return result, count


def actual(record):
    nodes = {n['id']: n for n in record['path_nodes']}

    @functools.lru_cache(None)
    def visit(i):
        n = nodes[i]
        children = [visit(j) for j in n['premises']]
        assert len(children) == len(set(children)), 'Duplicate premise'
        return digest(n, children)

    roots = [visit(i) for i in record['path_roots']]
    assert len(roots) == len(set(roots)) == record['path_count']
    assert all(nodes[i]['value'] == record['result'] for i in record['path_roots'])
    return set(roots)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    base = Path(__file__).resolve().parent.parent / 'data'
    parser.add_argument('--raw', type=Path, default=base / 'all_reasoning_paths.raw.jsonl')
    parser.add_argument('--output', type=Path, default=base / 'all_reasoning_paths.jsonl')
    args = parser.parse_args()
    raw = {}
    with args.raw.open() as f:
        for line in f:
            r = json.loads(line)
            assert r['case'] not in raw
            raw[r['case']] = r
    seen = set()
    total = candidates = 0
    with args.output.open() as f:
        for line in f:
            r = json.loads(line)
            name = r['case']
            assert name not in seen
            seen.add(name)
            source = raw[name]
            assert r['complete'] and not r['issues']
            assert source['result'] == r['result']
            want, count = expected(source)
            got = actual(r)
            assert want == got, (name, len(want - got), len(got - want))
            total += len(got)
            candidates += count
            if len(seen) % 200 == 0:
                print(f'Checked {len(seen)} cases', flush=True)
    assert seen == set(raw), 'Missing cases'
    print(json.dumps(dict(cases=len(seen), unpruned_root_trees=candidates,
                          global_minimal_trees=total, mismatches=0), indent=2))


if __name__ == '__main__':
    main()
