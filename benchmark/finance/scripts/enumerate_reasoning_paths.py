#!/usr/bin/env python3
"""Export finite, syntax-directed business explanations using Isabelle.

Default scope: every reimbursement case discovered by run_isabelle_trace,
plus sample references (unresolved references get explicit error entries).
Outputs a packed AND/OR forest and optionally all expanded minimal trees.
No claim is made to enumerate all HOL proofs or to have proved completeness.
"""
from __future__ import annotations

import argparse
import asyncio
import hashlib
import itertools
import json
import re
import subprocess
import tempfile
import uuid
from collections import Counter
from pathlib import Path

import run_isabelle_trace as legacy

BASE = Path(__file__).resolve().parent.parent


def prepare_session(args, log_path):
    """Cache semantically identical theories; normalize Isabelle symbol encoding.

    Diagnostic `value` commands have no effect on definitions and are omitted.
    Original theory files are never changed.
    """
    directory = BASE / 'data/reasoning_session'
    directory.mkdir(parents=True, exist_ok=True)
    symbols = args.isabelle.resolve().parent.parent / 'etc/symbols'
    translation = {}
    for symbol, code in re.findall(r'^(\\<[^>]+>)\s+code:\s+0x([0-9a-fA-F]+)',
                                   symbols.read_text(encoding='utf-8'), re.M):
        translation.setdefault(int(code, 16), symbol)

    def write_changed(path, text):
        if not path.exists() or path.read_text(encoding='utf-8') != text:
            path.write_text(text, encoding='utf-8')

    for source in (legacy.RULES_THY, legacy.CASES_THY):
        text = source.read_text(encoding='utf-8').translate(translation)
        text = re.sub(r'^value\s+"[^"]*"', lambda m: '\n' * m[0].count('\n'), text, flags=re.M)
        write_changed(directory / source.name, text)
    write_changed(directory / 'ROOT',
        'session Reasoning_Paths_Base = HOL +\n  theories\n    baoxiao_rules\n    baoxiao_cases\n')
    print(f'Building/checking cached theory session. Log: {log_path}', flush=True)
    with log_path.open('w', encoding='utf-8') as log:
        result = subprocess.run(['bash', str(args.isabelle), 'build', '-b', '-D', str(directory)],
                                stdout=log, stderr=subprocess.STDOUT, timeout=args.timeout)
    if result.returncode:
        raise RuntimeError(f'Cached theory build failed; inspect {log_path}')
    return directory


def discover():
    funcs = legacy.parse_rule_functions(legacy.RULES_THY, legacy.CASES_THY)
    cases = legacy.parse_cases(legacy.CASES_THY, legacy.RULES_THY)
    cases += legacy.parse_anonymous_cases(legacy.CASES_THY, funcs)
    cases += legacy.make_list_cases(legacy.parse_list_definitions(legacy.CASES_THY), funcs)
    cases += legacy.make_sr_span_cases(funcs)
    result = {}
    for item in cases:
        name, typ, expr = item[:3]
        fs = item[3] if len(item) > 3 and item[3] is not None else funcs.get(typ, [])
        finals = [f for f in fs if f['is_final']]
        if not finals:
            finals = [f for f in fs if 'amount_decision' in f['name']]
        if not finals:
            continue  # inner sr_span entries are superseded by the sr_claim entry
        result[name] = {'case': name, 'type': typ, 'evaluator': finals[-1]['name'],
                        'expression': f"{finals[-1]['name']} {expr or name}"}
    # Never silently drop a discovered case without an evaluator.
    for name, typ, *_ in cases:
        result.setdefault(name, {'case': name, 'type': typ, 'error': 'No evaluator found'})
    for source, path in legacy.SAMPLE_FILES.items():
        for entry in json.loads(path.read_text(encoding='utf-8')):
            for raw in entry.get('isabelle_case_names', []):
                name = re.split(r'[（(]', raw, maxsplit=1)[0].rstrip()
                record = result.setdefault(name, {'case': name, 'error': 'Sample reference not resolved'})
                record.setdefault('sample_refs', []).append({'file': source, 'id': entry.get('id')})
    return list(result.values())


def ml_string(value):
    # SML and Isabelle path strings here are UTF-8; avoid JSON \u escapes.
    return json.dumps(value, ensure_ascii=False)


def run_isabelle(cases, args, raw_path, log_path):
    with tempfile.TemporaryDirectory(prefix='hol-paths-') as tmp:
        theory = Path(tmp) / 'All_Reasoning_Paths.thy'
        base_session = getattr(args, 'session', 'HOL')
        if base_session == 'cached':
            base_session = 'Reasoning_Paths_Base'
        imported = (base_session + '.baoxiao_cases' if base_session != 'HOL'
                    else str(legacy.CASES_THY.with_suffix('')))
        lines = ['theory All_Reasoning_Paths',
                 f'imports {ml_string(imported)}', 'begin',
                 f'ML_file {ml_string(str(BASE / "groundtruth/reasoning_paths.ML"))}',
                 'ML \\<open>val reasoning_paths_context = @{context}\\<close>']
        expressions = ',\n'.join(ml_string(c['expression']) for c in cases if 'expression' in c)
        lines.append('ML \\<open>Reasoning_Paths.initialize reasoning_paths_context ['
                     + expressions + ']\\<close>')
        pairs = ',\n'.join(f'({ml_string(c["case"])}, {ml_string(c["expression"])})'
                            for c in cases if 'expression' in c)
        lines.append('ML \\<open>ignore (Par_List.map '
                     '(Reasoning_Paths.write_case reasoning_paths_context '
                     f'{args.max_depth} {ml_string(str(raw_path))}) [{pairs}])\\<close>')
        lines.append('end')
        theory.write_text('\n'.join(lines), encoding='utf-8')
        with log_path.open('w', encoding='utf-8') as log:
            proc = subprocess.Popen(['bash', str(args.isabelle), 'server', '-p', '0',
                                     '-n', 'paths_' + uuid.uuid4().hex],
                                    stdout=subprocess.PIPE, stderr=log, text=True)
            try:
                info = proc.stdout.readline().strip()
                if not info:
                    raise RuntimeError(f'Isabelle server failed to start; inspect {log_path}')
                host, port, password = legacy.parse_server_info(info)

                async def evaluate():
                    def progress(reply):
                        body = reply.get('body')
                        if isinstance(body, dict) and reply['type'] in ('NOTE', 'ERROR', 'FAILED'):
                            log.write(json.dumps(reply, ensure_ascii=False) + '\n')
                            log.flush()

                    async def send(command, body):
                        return await legacy._send_command(host, port, password,
                                                         command + ' ' + json.dumps(body),
                                                         on_message=progress)
                    replies = await send('session_start', {'session': base_session,
                        'dirs': [str(getattr(args, 'session_dir', legacy.GROUNDTRUTH))],
                        'options': [f'threads={getattr(args, "jobs", 4)}']})
                    session = next((r['body']['session_id'] for r in replies
                                    if r['type'] == 'FINISHED' and 'session_id' in r['body']), None)
                    if not session:
                        raise RuntimeError(str(replies))
                    try:
                        replies = await send('use_theories', {'session_id': session,
                            'theories': ['All_Reasoning_Paths'], 'master_dir': tmp,
                            'watchdog_timeout': float(args.timeout)})
                        log.write(json.dumps(replies, ensure_ascii=False, indent=2))
                        ok = any(r['type'] == 'FINISHED' and r['body'].get('ok') for r in replies)
                        return 0 if ok else 1
                    finally:
                        await send('session_stop', {'session_id': session})

                return asyncio.run(asyncio.wait_for(evaluate(), timeout=args.timeout))
            finally:
                proc.terminate()
                try:
                    proc.wait(timeout=10)
                except subprocess.TimeoutExpired:
                    proc.kill()
                    proc.wait()


class LimitReached(Exception):
    pass


def validate_forest(record):
    """Check graph integrity and the truth conditions of recorded inference edges."""
    nodes = {n['id']: n for n in record['nodes']}
    if len(nodes) != len(record['nodes']) or record['root'] not in nodes:
        raise ValueError('Duplicate node IDs or missing root')
    if nodes[record['root']]['value'] != record['result']:
        raise ValueError('Root value differs from the case result')
    for node_id, n in nodes.items():
        if not n['alternatives']:
            raise ValueError('A node has no justification')
        for alt in n['alternatives']:
            if any(i not in nodes or i >= node_id for i in alt):
                raise ValueError('Missing, cyclic, or non-postorder dependency')
            vals = [nodes[i]['value'] for i in alt]
            kind = n['kind']
            if kind in ('and:true', 'or:false'):
                expected = 'True' if kind == 'and:true' else 'False'
                if len(vals) != 2 or vals != [expected, expected] or n['value'] != expected:
                    raise ValueError(f'Invalid {kind} premises')
            elif kind in ('or:true', 'and:false'):
                expected = 'True' if kind == 'or:true' else 'False'
                if vals != [expected] or n['value'] != expected:
                    raise ValueError(f'Invalid {kind} premise')
            elif kind == 'not':
                if len(vals) != 1 or {vals[0], n['value']} != {'True', 'False'}:
                    raise ValueError('Invalid negation')
            elif kind == 'implies:false':
                if vals != ['True', 'False'] or n['value'] != 'False':
                    raise ValueError('Invalid false implication')
            elif kind.startswith('if:'):
                expected = 'True' if kind == 'if:then' else 'False'
                if len(vals) != 2 or vals[0] != expected or vals[1] != n['value']:
                    raise ValueError('Invalid ordered branch')
            elif kind.startswith('rule:') or kind == 'let':
                if vals != [n['value']]:
                    raise ValueError('Definition unfolding changed the value')


def expand_forest(record, limit=0, packed=False):
    """Return unique, support-minimal trees for this finite forest.

    Prune ONLY at the root, when named business-rule sets agree.
    Intermediate nodes retain every structurally distinct tree: evidence and
    size dominance are not preserved under composition with sibling premises.
    Distinct business-rule explanations survive even with equal evidence.
    Children are canonicalized: premise permutations and duplicate premises
    do not create new paths. Limit applies at every intermediate node too.
    """
    nodes = {n['id']: n for n in record['nodes']}
    cache, active = {}, set()
    # Hash-cons small structural keys instead of serializing whole trees for
    # every Cartesian candidate. Bitsets make evidence inclusion inexpensive.
    intern, trees, evidence_ids, rule_ids = {}, [], {}, {}

    def bit(table, key):
        if key not in table:
            table[key] = 1 << len(table)
        return table[key]

    def visit(node_id):
        if node_id in cache:
            return cache[node_id]
        if node_id in active:
            raise ValueError('Cycle in explanation forest')
        active.add(node_id)
        node = nodes[node_id]
        candidates = {}
        groups = {}  # rule bitset -> evidence cardinality -> evidence -> [size, keys]
        label = tuple(node[k] for k in ('kind', 'expression', 'value'))
        for alt in node['alternatives']:
            for combination in itertools.product(*(visit(i) for i in alt)):
                children = sorted({c[0]: c for c in combination}.values(), key=lambda c: c[0])
                key = (label, tuple(c[0] for c in children))
                if key in candidates:
                    continue
                evidence, rules = 0, 0
                for child in children:
                    evidence |= child[1]
                    rules |= child[2]
                size = 1 + sum(c[3] for c in children)
                if node['kind'] in ('fact', 'case-input', 'opaque'):
                    evidence |= bit(evidence_ids, (node['expression'], node['value']))
                if node['kind'].startswith('rule:'):
                    rules |= bit(rule_ids, node['kind'])
                if node_id != record['root']:
                    if key not in intern:
                        intern[key] = len(trees)
                        trees.append(key)
                    candidates[key] = (intern[key], evidence, rules, size)
                    if limit and len(candidates) > limit:
                        raise LimitReached(f'More than {limit} intermediate trees')
                    continue
                cardinality = bin(evidence).count('1')  # compatible with Python 3.9
                group = groups.setdefault(rules, {})
                same = group.get(cardinality, {}).get(evidence)
                if same is not None and same[0] < size:
                    continue
                if any((e & evidence) == e for count, bucket in group.items()
                       if count < cardinality for e in bucket):
                    continue
                if same is not None and size < same[0]:
                    for old in same[1]:
                        del candidates[old]
                    del group[cardinality][evidence]
                for count, bucket in group.items():
                    if count <= cardinality:
                        continue
                    for e, (old_size, keys) in list(bucket.items()):
                        if (e & evidence) == evidence:
                            for old in keys:
                                del candidates[old]
                            del bucket[e]
                if key not in intern:
                    intern[key] = len(trees)
                    trees.append(key)
                candidates[key] = (intern[key], evidence, rules, size)
                bucket = group.setdefault(cardinality, {})
                bucket.setdefault(evidence, [size, set()])[1].add(key)
                if limit and len(candidates) > limit:
                    raise LimitReached(f'More than {limit} intermediate trees')
        active.remove(node_id)
        cache[node_id] = list(candidates.values())
        return cache[node_id]

    roots = visit(record['root'])
    if packed:
        reachable, pending = set(), [c[0] for c in roots]
        while pending:
            i = pending.pop()
            if i not in reachable:
                reachable.add(i)
                pending.extend(trees[i][1])
        return {'path_roots': [c[0] for c in roots], 'path_nodes': [
            {'id': i, **dict(zip(('kind', 'expression', 'value'), trees[i][0])),
             'premises': list(trees[i][1])} for i in sorted(reachable)]}
    materialized = {}

    def materialize(tree_id):
        if tree_id not in materialized:
            label, children = trees[tree_id]
            tree = dict(zip(('kind', 'expression', 'value'), label))
            tree['premises'] = [materialize(i) for i in children]
            materialized[tree_id] = tree
        return materialized[tree_id]

    return [materialize(c[0]) for c in roots]


def materialize_path(record, index=0):
    if 'paths' in record:
        return record['paths'][index]
    nodes = {n['id']: n for n in record['path_nodes']}
    def tree(i):
        n = nodes[i]
        return {**{k: n[k] for k in ('kind', 'expression', 'value')},
                'premises': [tree(j) for j in n['premises']]}
    return tree(record['path_roots'][index])


def convert(cases, raw_path, output, max_paths, forest_only=False, stats=None, expanded=False):
    raw = {}
    if raw_path.exists():
        for line in raw_path.read_text(encoding='utf-8').splitlines():
            data = json.loads(line)
            if data['case'] in raw:
                raise ValueError(f"Duplicate backend case: {data['case']}")
            raw[data['case']] = data
    counts = Counter()
    if stats is not None:
        stats.update(total_paths=0, max_paths_per_case=0, cases_with_multiple_paths=0)
    with output.open('w', encoding='utf-8') as stream:
        for case in cases:
            entry = {**case, **raw.get(case['case'], {})}
            if 'nodes' not in entry:
                entry['status'] = 'error'
                entry.setdefault('error', 'No backend output; inspect Isabelle log')
                entry['complete'] = False
            else:
                validate_forest(entry)
                entry['complete'] = not entry['issues']
                entry['status'] = 'complete' if entry['complete'] else 'partial_opaque'
                if not forest_only:
                    try:
                        if expanded:
                            entry['paths'] = expand_forest(entry, max_paths)
                            entry['path_count'] = len(entry['paths'])
                            entry['path_format'] = 'nested_trees'
                        else:
                            entry.update(expand_forest(entry, max_paths, packed=True))
                            entry['path_count'] = len(entry['path_roots'])
                            entry['path_format'] = 'shared_trees'
                        if stats is not None:
                            stats['total_paths'] += entry['path_count']
                            stats['max_paths_per_case'] = max(stats['max_paths_per_case'], entry['path_count'])
                            stats['cases_with_multiple_paths'] += entry['path_count'] > 1
                    except LimitReached as exc:
                        entry.update(status='forest_only_limit', complete=False, expansion_error=str(exc))
                else:
                    entry['status'] = 'forest_only' if entry['complete'] else 'partial_opaque'
            counts[entry['status']] += 1
            stream.write(json.dumps(entry, ensure_ascii=False) + '\n')
    return dict(counts)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--isabelle', type=Path, default=Path(legacy.ISABELLE_BIN))
    parser.add_argument('--session', choices=['HOL', 'cached'], default='cached',
                        help='Cache normalized theory copies by default; HOL loads original files directly')
    parser.add_argument('--case', help='Regex selecting case names; default: all')
    parser.add_argument('--limit-cases', type=int, default=0)
    parser.add_argument('--jobs', type=int, default=4, help='Parallel Isabelle workers')
    parser.add_argument('--resume', action='store_true', help='Resume the same output with unchanged theory sources')
    parser.add_argument('--max-paths', type=int, default=0, help='0 means exhaustive; nonzero caps intermediate expansion')
    parser.add_argument('--max-depth', type=int, default=100)
    parser.add_argument('--timeout', type=int, default=7200)
    parser.add_argument('--forest-only', action='store_true', help='Store compact AND/OR alternatives without Cartesian expansion')
    parser.add_argument('--expanded', action='store_true', help='Duplicate every full nested tree (can produce multi-GB files)')
    parser.add_argument('--show-case', help='Print one fully expanded path from an existing output; do not run Isabelle')
    parser.add_argument('--path-index', type=int, default=0, help='Zero-based path index for --show-case')
    parser.add_argument('--reuse-raw', type=Path, help='Re-expand an existing backend JSONL without running Isabelle')
    parser.add_argument('--output', type=Path, default=BASE / 'data/all_reasoning_paths.jsonl')
    parser.add_argument('--list', action='store_true', help='List discovered cases without running Isabelle')
    args = parser.parse_args()
    if args.show_case:
        with args.output.open(encoding='utf-8') as stream:
            for line in stream:
                record = json.loads(line)
                if record['case'] == args.show_case:
                    if args.path_index < 0 or args.path_index >= record.get('path_count', 0):
                        parser.error('Path index out of range, or paths were not enumerated')
                    print(json.dumps({'case': record['case'], 'result': record['result'],
                        'path_count': record['path_count'], 'input_bindings': record.get('input_bindings', []),
                        'path': materialize_path(record, args.path_index)}, ensure_ascii=False, indent=2))
                    return
        parser.error('Case not found in output')
    if args.jobs < 1 or (args.resume and args.reuse_raw):
        parser.error('--jobs must be positive; --resume and --reuse-raw are mutually exclusive')
    if min(args.max_paths, args.limit_cases, args.max_depth) < 0:
        parser.error('Limits must be nonnegative')
    cases = discover()
    if args.case:
        cases = [c for c in cases if re.search(args.case, c['case'])]
    if args.limit_cases:
        cases = cases[:args.limit_cases]
    if args.list:
        print(json.dumps(cases, ensure_ascii=False, indent=2))
        return
    if not cases:
        parser.error('No matching cases')
    output = args.output.resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    raw_path = args.reuse_raw or output.with_suffix('.raw.jsonl')
    log_path = output.with_suffix('.isabelle.log')
    returncode = 0
    if not args.reuse_raw:
        manifest_path = output.with_suffix('.manifest.json')
        manifest = {'semantics_version': 1, 'max_depth': args.max_depth,
                    'sources': {p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                                for p in (legacy.RULES_THY, legacy.CASES_THY)}}
        pending = cases
        if args.resume:
            if not manifest_path.exists() or json.loads(manifest_path.read_text()) != manifest:
                parser.error('Resume requires a matching source/depth manifest; use a new output for changed sources')
            completed = {}
            if raw_path.exists():
                for line in raw_path.read_text(encoding='utf-8').splitlines(keepends=True):
                    try:
                        item = json.loads(line)
                    except json.JSONDecodeError:
                        if not line.endswith('\n'):
                            break  # interrupted last write: recompute that case
                        raise
                    if 'nodes' in item and not item.get('issues'):
                        validate_forest(item)
                        completed[item['case']] = item
            pending = [c for c in cases if c['case'] not in completed
                       or c.get('expression') != completed[c['case']].get('expression')]
            for c in pending:
                completed.pop(c['case'], None)
            raw_path.write_text(''.join(json.dumps(r, ensure_ascii=False) + '\n'
                                        for r in completed.values()), encoding='utf-8')
        else:
            raw_path.write_text('', encoding='utf-8')
            manifest_path.write_text(json.dumps(manifest, indent=2), encoding='utf-8')
        print(f'Running Isabelle for {len(pending)} remaining / {len(cases)} cases. Log: {log_path}', flush=True)
        try:
            if pending and args.session == 'cached':
                args.session_dir = prepare_session(args, output.with_suffix('.build.log'))
            if pending:
                returncode = run_isabelle(pending, args, raw_path, log_path)
        except KeyboardInterrupt:
            print('Interrupted; written cases retained. Continue with --resume.', flush=True)
            returncode = 130
        except (subprocess.TimeoutExpired, TimeoutError):
            returncode = 124
        except (OSError, RuntimeError, ValueError) as exc:
            print(f'Backend failed: {exc}', flush=True)
            returncode = 1
    stats = {}
    counts = convert(cases, raw_path, output, args.max_paths, args.forest_only, stats, args.expanded)
    summary = {'total_cases': len(cases), 'statuses': counts, 'backend_exit_code': returncode,
               'output': str(output), 'raw_output': str(raw_path),
               'path_statistics': stats,
               'semantics': 'v2: exhaustive intermediate trees; root-global support/size minimum per named-rule set',
               'verification': 'Isabelle/NBE values; enumeration completeness is not a proved HOL theorem',
               'source_sha256': {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in
                                 (legacy.RULES_THY, legacy.CASES_THY, BASE / 'groundtruth/reasoning_paths.ML', Path(__file__))}}
    output.with_suffix('.summary.json').write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding='utf-8')
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    if returncode or counts.get('error') or counts.get('partial_opaque') or counts.get('forest_only_limit'):
        raise SystemExit(1)


if __name__ == '__main__':
    main()
