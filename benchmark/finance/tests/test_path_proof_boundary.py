"""Regression: root-global minimization must not prune intermediate reasons."""

import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))

import itertools
import json
import random
import unittest

from enumerate_reasoning_paths import expand_forest
from test_reasoning_paths import node


def raw_trees(record):
    """Small exhaustive oracle: deduplicate children but NEVER prune locally."""
    nodes = {n['id']: n for n in record['nodes']}

    def visit(i):
        n = nodes[i]
        result = {}
        for alt in n['alternatives']:
            for combo in itertools.product(*(visit(j) for j in alt)):
                children = {json.dumps(t, sort_keys=True): t for t in combo}
                t = {k: n[k] for k in ('kind', 'expression', 'value')}
                t['premises'] = [children[k] for k in sorted(children)]
                result[json.dumps(t, sort_keys=True)] = t
        return list(result.values())
    return visit(record['root'])


def evidence(t):
    own = {(t['expression'], t['value'])} if t['kind'] == 'fact' else set()
    return own.union(*(evidence(c) for c in t['premises']))


def size(t):
    return 1 + sum(size(c) for c in t['premises'])


def signature(t):
    return (t['kind'], t['expression'], t['value'],
            tuple(sorted(signature(c) for c in t['premises'])))


def rules(t):
    own = {t['kind']} if t['kind'].startswith('rule:') else set()
    return own.union(*(rules(c) for c in t['premises']))


def minimal(trees):
    return [t for t in trees if not any(rules(u) == rules(t) and (
        evidence(u) < evidence(t) or
        (evidence(u) == evidence(t) and size(u) < size(t))) for u in trees)]


class ProofBoundaryTests(unittest.TestCase):
    def test_local_pruning_loses_global_minimum(self):
        # All facts are true. No named rules, so rule sets are identical.
        # P = ((A & True) & True) | (A & B), target = P & B.
        p = '((A & True) & True) | (A & B)'
        nodes = [
            node(0, 'fact', 'A', 'True', [[]]),
            node(1, 'fact', 'B', 'True', [[]]),
            node(2, 'literal', 'True', 'True', [[]]),
            node(3, 'and:true', 'A & True', 'True', [[0, 2]]),
            node(4, 'and:true', '(A & True) & True', 'True', [[3, 2]]),
            node(5, 'and:true', 'A & B', 'True', [[0, 1]]),
            node(6, 'or:true', p, 'True', [[4], [5]]),
            node(7, 'and:true', '(' + p + ') & B', 'True', [[6, 1]]),
        ]
        record = dict(root=7, nodes=nodes)
        all_paths = raw_trees(record)
        local_paths = expand_forest(record)
        self.assertEqual(sorted(map(size, all_paths)), [6, 8])
        self.assertEqual(list(map(size, local_paths)), [6])
        self.assertTrue(all(evidence(t) == {('A', 'True'), ('B', 'True')}
                            for t in all_paths))
        # Under the documented GLOBAL same-evidence shortest-tree criterion,
        # only the size-6 tree is minimal; the old implementation removed it.
        global_minima = [t for t in all_paths if not any(
            evidence(u) < evidence(t) or
            (evidence(u) == evidence(t) and size(u) < size(t))
            for u in all_paths)]
        self.assertEqual(list(map(size, global_minima)), [6])
        self.assertEqual(set(map(signature, local_paths)),
                         set(map(signature, global_minima)))

    def test_random_forests_against_exhaustive_oracle(self):
        rng = random.Random(20261003)
        for trial in range(100):
            nodes = [node(i, 'fact', str(i), 'True', [[]]) for i in range(3)]
            for i in range(3, 8):
                kind = rng.choice(['and:true', 'or:true', 'rule:R', 'rule:S'])
                alts = [[rng.randrange(i) for _ in range(rng.randint(1, 2))]
                        for _ in range(rng.randint(1, 2))]
                nodes.append(node(i, kind, str(i), 'True', alts))
            record = dict(root=7, nodes=nodes)
            with self.subTest(trial=trial):
                self.assertEqual(set(map(signature, expand_forest(record))),
                                 set(map(signature, minimal(raw_trees(record)))))


if __name__ == '__main__':
    unittest.main()
