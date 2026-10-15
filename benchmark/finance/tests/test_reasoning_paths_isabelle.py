"""Optional end-to-end test: python3 test_reasoning_paths_isabelle.py.

Starts Isabelle and checks actual unfolding, branch priority, OR alternatives,
and absorption, independently of the large reimbursement theory.
"""

import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))

import argparse
import json
import tempfile
from pathlib import Path

import enumerate_reasoning_paths as paths


def main():
    cases = [dict(case=name, expression=expr) for name, expr in [
        ('yes', 'route yes'), ('no', 'route no'), ('middle', 'route middle'),
        ('absorption', 'alternative yes'), ('dispatch', 'routed yes')]]
    original = paths.legacy.CASES_THY
    paths.legacy.CASES_THY = paths.BASE / 'tests/isabelle/baoxiao_rules.thy'
    try:
        with tempfile.TemporaryDirectory(prefix='hol-path-tests-') as tmp:
            raw, log = Path(tmp) / 'results.jsonl', Path(tmp) / 'isabelle.log'
            raw.write_text('', encoding='utf-8')
            args = argparse.Namespace(max_depth=100, timeout=180, isabelle=paths.legacy.ISABELLE_BIN)
            code = paths.run_isabelle(cases, args, raw, log)
            if code:
                raise AssertionError(log.read_text(encoding='utf-8')[-12000:])
            by_name = {r['case']: r for r in map(json.loads, raw.read_text(encoding='utf-8').splitlines())}
            records = [by_name[c['case']] for c in cases]
            assert len(records) == 5, records
            for record, count in zip(records, [2, 1, 1, 1, 2]):
                assert not record.get('error'), record
                assert not record['issues'], record['issues']
                trees = paths.expand_forest(record)
                assert len(trees) == count, (record['case'], len(trees))
                print(record['case'], record['result'], len(trees), 'paths')
            assert [r['result'] for r in records[:3]] == ['2', '0', '1']
            no = records[1]
            assert not any(n['expression'].startswith(('b ', 'c '))
                           for n in no['nodes'] if n['kind'] == 'fact'), no
            print('Isabelle integration checks passed')
    finally:
        paths.legacy.CASES_THY = original


if __name__ == '__main__':
    main()
