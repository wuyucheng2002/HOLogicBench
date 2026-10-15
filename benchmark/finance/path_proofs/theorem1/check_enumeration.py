"""Independent bounded differential checks, not a formal proof.

Run: python3 benchmark/finance/path_proofs/theorem1/check_enumeration.py
The oracle expands all trees and then applies the paper's global minimum.
"""
from functools import lru_cache
from itertools import product
from pathlib import Path
import random
import sys

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / 'finance/scripts'))
from enumerate_reasoning_paths import expand_forest


def canonical(label, children):
    return (label, tuple(sorted(set(children))))


def unpack(t):
    return canonical(tuple(t[k] for k in ('kind', 'expression', 'value')),
                     [unpack(c) for c in t['premises']])


@lru_cache(None)
def metrics(t):
    (kind, expression, value), children = t
    ev = {(expression, value)} if kind in ('fact', 'case-input', 'opaque') else set()
    rules = {kind} if kind.startswith('rule:') else set()
    size = 1
    for child in children:
        ce, cr, cs = metrics(child)
        ev.update(ce)
        rules.update(cr)
        size += cs
    return frozenset(ev), frozenset(rules), size


def dominates(u, t):
    ue, ur, us = metrics(u)
    te, tr, ts = metrics(t)
    return ur == tr and (ue < te or (ue == te and us < ts))


def oracle(record):
    nodes = {n['id']: n for n in record['nodes']}

    @lru_cache(None)
    def visit(v):
        n = nodes[v]
        label = tuple(n[k] for k in ('kind', 'expression', 'value'))
        return frozenset(canonical(label, ts)
                         for alt in n['alternatives']
                         for ts in product(*(visit(p) for p in alt)))

    raw = visit(record['root'])
    return raw, {t for t in raw if not any(dominates(u, t) for u in raw)}


def node(i, kind, expr, alternatives):
    return dict(id=i, kind=kind, expression=expr, value='True', alternatives=alternatives)


def check(record):
    raw, expected = oracle(record)
    result = [unpack(t) for t in expand_forest(record)]
    assert len(result) == len(set(result)), 'structural duplicates'
    assert set(result) == expected, (record, expected, result)
    return raw, expected


def main():
    # Exact counterexample from the appendix: Z = ((A & True) & True) | (A & B).
    nodes = [node(0, 'fact', 'A', [[]]), node(1, 'fact', 'B', [[]]),
             node(2, 'literal', 'True', [[]]), node(3, 'and', 'A & True', [[0, 2]]),
             node(4, 'and', '(A & True) & True', [[3, 2]]),
             node(5, 'and', 'A & B', [[0, 1]]),
             node(6, 'or', 'Z', [[4], [5]]), node(7, 'and', 'Z & B', [[6, 1]])]
    raw, minimum = check(dict(nodes=nodes, root=7))
    assert sorted(metrics(t)[2] for t in raw) == [6, 8]
    assert [metrics(t)[2] for t in minimum] == [6]
    local_raw, local_min = check(dict(nodes=nodes, root=6))
    assert sorted(metrics(t)[2] for t in local_raw) == [4, 6]
    assert [metrics(t)[2] for t in local_min] == [6]
    print('PASS: appendix counterexample; root sizes 6/8, global minimum 6; local pruning loses it.')

    for alts in ([], [[]], [[], []]):
        check(dict(nodes=[node(0, 'fact', 'A', alts)], root=0))
    check(dict(nodes=[node(0, 'fact', 'A', [[]]),
                      node(1, 'and', 'A & A', [[0, 0], [0]])], root=1))
    print('PASS: empty alternative set, empty product, duplicate alternatives/premises.')

    rng = random.Random(20261008)
    for _ in range(1000):
        nodes = []
        for i in range(rng.randint(1, 7)):
            alts = [[] for _ in range(rng.randrange(3))] if i == 0 else [
                [rng.randrange(i) for _ in range(rng.randrange(3))]
                for _ in range(rng.randrange(4))]
            nodes.append(node(i, rng.choice(['fact', 'case-input', 'opaque', 'and', 'rule:R', 'rule:S']),
                              str(rng.randrange(3)), alts))
        record = dict(nodes=nodes, root=len(nodes)-1)
        check(record)
        # Change enumeration order to exercise streaming-filter invariance.
        for n in nodes:
            rng.shuffle(n['alternatives'])
            for alt in n['alternatives']:
                rng.shuffle(alt)
        check(record)
    print('PASS: 1000 random finite DAGs, each checked in two enumeration orders (2000 comparisons).')
    print('Scope: abstract enumeration/minimization only; random DAGs need not encode valid business rules.')


if __name__ == '__main__':
    main()
