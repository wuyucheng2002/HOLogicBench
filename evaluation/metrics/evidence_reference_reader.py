"""Materialize exact reference choices without collapsing any evidence paths."""
import argparse
import itertools
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REFERENCE_DIR = HERE if (HERE / "references.jsonl").exists() else HERE.parents[1] / "benchmark/references"


class EvidenceReferences:
    def __init__(self, keys=None):
        self.records = {r['key']: r for r in map(json.loads, (REFERENCE_DIR/'references.jsonl').open())
                        if keys is None or r['key'] in keys}
        needed = {n for r in self.records.values() for n in r.get('components', [])}
        self.texts = json.loads((REFERENCE_DIR/'finance_evidence_steps.json').read_text())
        self.paths = {}
        for r in map(json.loads, (REFERENCE_DIR/'finance_evidence_catalog.jsonl').open()):
            if r['case'] in needed:
                self.paths[r['case']] = r['paths']
        assert needed == self.paths.keys()

    def get(self, key, indices):
        record = self.records[key]
        if record['domain'] == 'law':
            assert len(indices) == 1
            return record['references'][indices[0]]
        names = record['components']
        assert len(indices) == len(names)
        chosen = [self.paths[n][i] for n, i in zip(names, indices)]
        blocks = []
        for i, (name, path) in enumerate(zip(names, chosen), 1):
            blocks.append(f'[Scenario {i}: {name}]\n' +
                          '\n'.join(self.texts[s] for s in path['step_ids']))
        return dict(reference_id='|'.join(p['reference_id'] for p in chosen),
                    text='\n\n'.join(blocks),
                    components=[dict(case=n, **p) for n, p in zip(names, chosen)])

    def iter_choices(self, key):
        r = self.records[key]
        if r['domain'] == 'law':
            for i in range(len(r['references'])):
                yield (i,)
        else:
            yield from itertools.product(*(range(len(self.paths[n])) for n in r['components']))

    def iter_references(self, key):
        for indices in self.iter_choices(key):
            yield self.get(key, indices)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('key')
    parser.add_argument('--indices', help='Comma-separated zero-based path index per component')
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    refs = EvidenceReferences({args.key})
    indices = tuple(map(int, args.indices.split(','))) if args.indices else next(refs.iter_choices(args.key))
    result = refs.get(args.key, indices)
    text = json.dumps(result, ensure_ascii=False, indent=2)+'\n'
    if args.output:
        args.output.write_text(text)
    else:
        print(text, end='')


if __name__ == '__main__':
    main()
