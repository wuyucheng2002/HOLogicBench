"""Regression checks for explanation alternatives, minimality and limits."""

import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))

import unittest

from enumerate_reasoning_paths import LimitReached, expand_forest, validate_forest, materialize_path


def node(i, kind, expr, value, alternatives):
    return dict(id=i, kind=kind, expression=expr, value=value, alternatives=alternatives)


class EnumerationTests(unittest.TestCase):
    def test_two_independent_reasons(self):
        data = dict(root=2, nodes=[node(0, 'fact', 'A', 'True', [[]]),
            node(1, 'fact', 'B', 'True', [[]]),
            node(2, 'or:true', 'A | B', 'True', [[0], [1]])])
        self.assertEqual(len(expand_forest(data)), 2)
        compact = expand_forest(data, packed=True)
        self.assertEqual([materialize_path(compact, i) for i in range(2)], expand_forest(data))

    def test_cartesian_product_and_duplicate_permutations(self):
        nodes = [node(i, 'fact', str(i), 'True', [[]]) for i in range(4)]
        nodes += [node(4, 'or:true', 'A', 'True', [[0], [1]]),
                  node(5, 'or:true', 'B', 'True', [[2], [3]]),
                  node(6, 'and:true', 'A & B', 'True', [[4, 5], [5, 4]])]
        self.assertEqual(len(expand_forest(dict(root=6, nodes=nodes))), 4)

    def test_absorption_and_distinct_named_rules(self):
        nodes = [node(0, 'fact', 'A', 'True', [[]]), node(1, 'fact', 'B', 'True', [[]]),
                 node(2, 'and:true', 'A & B', 'True', [[0, 1]]),
                 node(3, 'or:true', 'A | (A & B)', 'True', [[2], [0]])]
        self.assertEqual(len(expand_forest(dict(root=3, nodes=nodes))), 1)
        nodes += [node(4, 'rule:different_rule', 'R', 'True', [[2]]),
                  node(5, 'or:true', 'A | R', 'True', [[0], [4]])]
        self.assertEqual(len(expand_forest(dict(root=5, nodes=nodes))), 2)

    def test_limit_does_not_claim_exhaustiveness(self):
        nodes = [node(0, 'fact', 'A', 'True', [[]]), node(1, 'fact', 'B', 'True', [[]]),
                 node(2, 'or:true', 'A | B', 'True', [[0], [1]])]
        with self.assertRaises(LimitReached):
            expand_forest(dict(root=2, nodes=nodes), 1)

    def test_tautology_is_not_an_extra_required_fact(self):
        nodes = [node(0, 'fact', 'A', 'True', [[]]),
                 node(1, 'literal', 'True', 'True', [[]]),
                 node(2, 'and:true', 'A & True', 'True', [[0, 1]]),
                 node(3, 'or:true', 'A | (A & True)', 'True', [[2], [0]])]
        paths = expand_forest(dict(root=3, nodes=nodes))
        self.assertEqual(len(paths), 1)
        self.assertEqual(paths[0]['premises'][0]['expression'], 'A')

    def test_corrupt_priority_is_rejected(self):
        data = dict(root=2, result='Rejection', nodes=[
            node(0, 'fact', 'guard', 'False', [[]]),
            node(1, 'literal', 'Rejection', 'Rejection', [[]]),
            node(2, 'if:then', 'if guard then Rejection else Approval', 'Rejection', [[0, 1]])])
        with self.assertRaises(ValueError):
            validate_forest(data)


if __name__ == '__main__':
    unittest.main()
