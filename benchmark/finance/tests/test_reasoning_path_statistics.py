
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))

import unittest

from summarize_reasoning_paths import describe, path_metrics


class StatisticsTests(unittest.TestCase):
    def test_shared_evidence_is_counted_once_but_tree_nodes_are_unfolded(self):
        nodes = [
            dict(id=0, kind='fact', expression='A', value='True', premises=[]),
            dict(id=1, kind='rule:R', expression='R', value='True', premises=[0]),
            dict(id=2, kind='rule:R', expression='R2', value='True', premises=[0]),
            dict(id=3, kind='and:true', expression='R & R2', value='True', premises=[1, 2]),
        ]
        result = path_metrics(dict(path_nodes=nodes, path_roots=[3]))[0]
        self.assertEqual(result, dict(path_index=0, tree_nodes=5, depth_edges=2,
                                     rule_occurrences=2, distinct_rules=1, distinct_evidence=1))

    def test_leaf_depth(self):
        nodes = [dict(id=0, kind='literal', expression='True', value='True', premises=[])]
        result = path_metrics(dict(path_nodes=nodes, path_roots=[0]))[0]
        self.assertEqual(result['depth_edges'], 0)
        self.assertEqual(result['distinct_evidence'], 0)

    def test_percentiles(self):
        result = describe([1, 2, 3, 4])
        self.assertEqual(result['median'], 2.5)
        self.assertAlmostEqual(result['p90'], 3.7)


if __name__ == '__main__':
    unittest.main()
