"""Verify release checksums and optionally expand packaged gzip data (stdlib only)."""
import argparse
import gzip
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def digest(path):
    h = hashlib.sha256()
    with path.open('rb') as f:
        for block in iter(lambda: f.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--verify-only', action='store_true')
    args = parser.parse_args()
    entries = json.loads((ROOT / 'validation/release_manifest.json').read_text())['files']
    expanded = 0
    for entry in entries:
        path = ROOT / entry['path']
        if digest(path) != entry['sha256']:
            raise ValueError(f'Checksum mismatch: {entry["path"]}')
        if args.verify_only or entry['path'] == entry['expanded_path']:
            continue
        target = ROOT / entry['expanded_path']
        if target.exists():
            if digest(target) != entry['expanded_sha256']:
                raise ValueError(f'Refusing to overwrite changed file: {entry["expanded_path"]}')
            continue
        temp = target.with_name(target.name + '.unpacking')
        try:
            with gzip.open(path, 'rb') as source, temp.open('wb') as dest:
                for block in iter(lambda: source.read(1024 * 1024), b''):
                    dest.write(block)
            if digest(temp) != entry['expanded_sha256']:
                raise ValueError(f'Expanded checksum mismatch: {entry["path"]}')
            temp.replace(target)
            expanded += 1
        finally:
            temp.unlink(missing_ok=True)
    print(json.dumps(dict(status='passed',verified_files=len(entries),expanded_files=expanded)))

if __name__ == '__main__':
    main()
