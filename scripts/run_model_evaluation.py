"""Generate Finance/Law answers, export predictions, and optionally score a new model.

Uses the frozen shared prompts and an OpenAI-compatible Chat Completions endpoint.
Generation and export require only Python's standard library. --dry-run is offline.
"""
import argparse
from collections import Counter
from contextlib import contextmanager
import csv
import getpass
import gzip
import hashlib
import json
import os
from pathlib import Path
import re
import statistics
import subprocess
import sys
import time
from urllib import error, parse, request

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'evaluation'))
from prediction_export import PredictionExporter

VERSION = 'new_model_pipeline_v1'
TRANSIENT = {408, 429, 500, 502, 503, 504, 529}
RESERVED = {'model', 'messages', 'stream', 'stream_options', 'max_tokens', 'max_completion_tokens'}


def digest(value):
    return hashlib.sha256(json.dumps(value, ensure_ascii=False, sort_keys=True,
                                    allow_nan=False).encode()).hexdigest()


def file_digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path, value):
    atomic_write(path, json.dumps(value, ensure_ascii=False, indent=2, allow_nan=False) + '\n')


def atomic_write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = path.with_name(path.name + '.tmp')
    temp.write_text(text, encoding='utf-8')
    temp.replace(path)


def write_rows(path, rows):
    atomic_write(path, ''.join(json.dumps(row, ensure_ascii=False, allow_nan=False) + '\n' for row in rows))


def check_options(value):
    if isinstance(value, dict):
        for key, item in value.items():
            if re.search(r'api.?key|token$|secret|password|authorization|headers', key, re.I):
                raise ValueError('Credentials and headers must not appear in request options')
            check_options(item)
    elif isinstance(value, list):
        for item in value:
            check_options(item)


def make_jobs(args, refs):
    source = ROOT / 'results/generation/minimax_m3_official/requests.jsonl.gz'
    with gzip.open(source, 'rt', encoding='utf-8') as stream:
        prompts = [row for row in map(json.loads, stream) if row['target_mode'] == 'off']
    if len(prompts) != len(refs) or {row['key'] for row in prompts} != set(refs):
        raise ValueError('Frozen prompts do not cover the reference index exactly once')
    options = json.loads(args.request_options.read_text()) if args.request_options else {}
    if not isinstance(options, dict) or RESERVED.intersection(options):
        raise ValueError('Request options must be an object without model/messages/stream/token-budget fields')
    check_options(options)
    jobs = []
    for row in sorted(prompts, key=lambda row: row['key']):
        if args.domain != 'all' and refs[row['key']]['domain'] != args.domain:
            continue
        payload = dict(model=args.model, messages=row['request']['messages'], stream=False,
                       **{args.token_field: args.max_tokens}, **options)
        jobs.append(dict(key=row['key'], model=args.name, request=payload,
                         request_sha256=digest(payload)))
    return jobs[:args.limit] if args.limit else jobs


def redact(value, secret):
    if isinstance(value, str):
        return value.replace(secret, '[REDACTED]') if secret else value
    if isinstance(value, list):
        return [redact(item, secret) for item in value]
    if isinstance(value, dict):
        return {redact(k, secret): redact(v, secret) for k, v in value.items()}
    return value


class NoRedirect(request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        # Never forward an Authorization header to a redirected endpoint.
        return None


def call_model(endpoint, payload, secret, timeout):
    req = request.Request(endpoint, data=json.dumps(payload, ensure_ascii=False,
                          allow_nan=False).encode(), method='POST', headers={
                          'Authorization': 'Bearer ' + secret, 'Content-Type': 'application/json'})
    try:
        with request.build_opener(NoRedirect).open(req, timeout=timeout) as response:
            raw = json.load(response)
    except error.HTTPError as exc:
        return dict(status='http_error', http_status=exc.code,
                    retryable=exc.code in TRANSIENT or exc.code in {401, 402, 403})
    except (error.URLError, TimeoutError, OSError):
        return dict(status='transport_error', retryable=True)
    except (ValueError, UnicodeError):
        return dict(status='invalid_response', retryable=False)
    raw = redact(raw, secret)
    if not isinstance(raw, dict):
        return dict(status='invalid_response', retryable=False)
    if raw.get('error'):
        return dict(status='api_error', retryable=False, response=raw)
    choices = raw.get('choices')
    choice = choices[0] if isinstance(choices, list) and choices else {}
    if not isinstance(choice, dict):
        return dict(status='invalid_response', retryable=False, response=raw)
    message = choice.get('message') or {}
    content = message.get('content') if isinstance(message, dict) else None
    finish = choice.get('finish_reason')
    status = 'ok' if finish == 'stop' else 'incomplete_response'
    if not isinstance(content, str) or not content.strip():
        status = 'empty_response'
    return dict(status=status, content=content if isinstance(content, str) else '',
                finish_reason=finish, retryable=False, response=raw)


def load_attempts(path, jobs):
    """Repair only an interrupted final append; reject earlier corrupt records."""
    known = {row['key']: row['request_sha256'] for row in jobs}
    latest = {}
    if not path.exists():
        return latest
    with path.open('rb+') as stream:
        while True:
            start = stream.tell()
            line = stream.readline()
            if not line:
                break
            if not line.endswith(b'\n'):
                stream.truncate(start)
                break
            row = json.loads(line)
            if known.get(row['key']) != row['request_sha256']:
                raise ValueError('Attempt log does not match this request manifest')
            if row['attempt'] != latest.get(row['key'], {}).get('attempt', 0) + 1:
                raise ValueError('Attempt log contains inconsistent attempt numbers')
            latest[row['key']] = row
    return latest


def generate(args, jobs, folder):
    path = folder / 'attempts.jsonl'
    latest = load_attempts(path, jobs)
    secret = None
    for index, job in enumerate(jobs, 1):
        prior = latest.get(job['key'])
        if prior and prior.get('http_status') in {401, 402, 403} and prior['attempt'] >= args.retries + 1:
            raise ValueError('Authentication/access retry budget exhausted; use a new run name')
        if prior and (not prior['retryable'] or prior['attempt'] >= args.retries + 1):
            continue
        if secret is None:
            secret = os.environ.get(args.api_key_env) or getpass.getpass('API key (hidden): ')
            if not secret.strip():
                raise ValueError('An API key is required')
        start = prior['attempt'] + 1 if prior else 1
        for attempt in range(start, args.retries + 2):
            result = call_model(args.endpoint, job['request'], secret, args.timeout)
            row = dict(result, key=job['key'], model=args.name,
                       request_sha256=job['request_sha256'], attempt=attempt)
            with path.open('a', encoding='utf-8') as stream:
                stream.write(json.dumps(row, ensure_ascii=False, allow_nan=False) + '\n')
                stream.flush()
                os.fsync(stream.fileno())
            latest[job['key']] = row
            print(f"[{index}/{len(jobs)}] {job['key']}: {row['status']} (attempt {attempt})", flush=True)
            if row.get('http_status') in {401, 402, 403}:
                raise ValueError('Authentication, billing, or access failure; generation stopped')
            if not row['retryable'] or attempt > args.retries:
                break
            time.sleep(min(30, 2 ** attempt))
    return latest


def aggregate(predictions, refs, scores=None):
    groups = {}
    for category in ['PR', 'PT', 'PC', 'PS', 'PQ', 'Overall']:
        selected = [row for row in predictions if category == 'Overall' or category in refs[row['key']]['hol_types']]
        if not selected:
            continue
        group = dict(n=len(selected), accuracy=statistics.mean(row['answer_correct'] for row in selected))
        if scores is not None:
            for metric in ['bertscore_f1', 'roscoe_sa_prec', 'rouge_l']:
                group[metric] = statistics.mean(scores[row['key']]['metric_maxima'][metric] for row in selected)
        groups[category] = group
    return groups


def score_predictions(args, predictions, refs, folder):
    stage = folder / 'metrics'
    pred_path = ROOT / 'results/per_case' / (args.name + '_predictions.jsonl')
    if not stage.exists():
        subprocess.run([sys.executable, str(ROOT / 'scripts/prepare_metric_run.py'), '--model', args.name,
                        '--output', str(stage)], check=True)
    if file_digest(stage / pred_path.name) != file_digest(pred_path):
        raise ValueError('Metric workspace contains different predictions; use a new run name')
    if file_digest(stage / 'references.jsonl') != file_digest(ROOT / 'benchmark/references/references.jsonl'):
        raise ValueError('Metric workspace contains different references')
    subprocess.run([sys.executable, str(stage / 'score_evidence_modernbert.py'), '--device', args.device,
                    '--model-dir', str(args.model_dir.resolve())], check=True)
    subprocess.run([sys.executable, str(stage / 'score_evidence_rouge_roscoe.py'), '--device', args.device,
                    '--embedding-model', str(args.embedding_model.resolve())], check=True)
    def indexed(path):
        rows = [json.loads(line) for line in path.read_text().splitlines()]
        mapping = {row['key']: row for row in rows}
        if len(rows) != len(refs) or set(mapping) != set(refs):
            raise ValueError('Incomplete or duplicate metric coverage')
        refhash = file_digest(stage / 'references.jsonl')
        for row in rows:
            if row['model'] != args.name or row['reference_sha256'] != refhash:
                raise ValueError('Incompatible metric output')
        return mapping
    bert = indexed(stage / 'modernbert_case_scores.jsonl')
    roscoe = indexed(stage / 'rouge_roscoe_case_scores.jsonl')
    merged = []
    for row in predictions:
        key = row['key']
        merged.append(dict(row, hol_types=refs[key]['hol_types'], reference_count=refs[key]['reference_count'],
                           metric_maxima=dict(roscoe[key]['metric_maxima'], bertscore_f1=bert[key]['bertscore_f1']),
                           best_reference_ids=dict(roscoe[key]['best_reference_ids'], bertscore_f1=bert[key]['best_reference_id']),
                           reference_sha256=bert[key]['reference_sha256']))
    write_rows(folder / 'case_scores.jsonl', merged)
    groups = aggregate(predictions, refs, {row['key']: row for row in merged})
    write_json(folder / 'summary.json', dict(model=args.name, groups=groups))
    with (folder / 'summary.csv').open('w', newline='', encoding='utf-8') as stream:
        writer = csv.DictWriter(stream, fieldnames=['model', 'category', 'n', 'accuracy', 'bertscore_f1', 'roscoe_sa_prec', 'rouge_l'])
        writer.writeheader()
        for category, values in groups.items():
            writer.writerow(dict(model=args.name, category=category, **values))


@contextmanager
def run_lock(folder):
    lock = folder / '.pipeline.lock'
    try:
        descriptor = os.open(lock, os.O_CREAT | os.O_EXCL | os.O_WRONLY, 0o600)
    except FileExistsError:
        raise ValueError('Run is locked; if a previous process was killed, remove .pipeline.lock after confirming it has stopped') from None
    try:
        os.close(descriptor)
        yield
    finally:
        lock.unlink(missing_ok=True)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--model', required=True, help='Provider model ID')
    ap.add_argument('--name', required=True, help='New filename-safe experiment name')
    ap.add_argument('--api-base', default='https://openrouter.ai/api/v1')
    ap.add_argument('--api-key-env', default='API_KEY', help='Environment variable; otherwise prompt without echo')
    ap.add_argument('--max-tokens', type=int, default=32000)
    ap.add_argument('--token-field', choices=['max_tokens', 'max_completion_tokens'], default='max_tokens')
    ap.add_argument('--request-options', type=Path, help='Optional JSON body fields, e.g. temperature or thinking controls')
    ap.add_argument('--timeout', type=float, default=600)
    ap.add_argument('--retries', type=int, default=2, help='Additional attempts for transient transport/HTTP errors only')
    ap.add_argument('--domain', choices=['all', 'finance', 'law'], default='all')
    ap.add_argument('--limit', type=int, help='Pilot subset; does not publish to results/per_case')
    ap.add_argument('--dry-run', action='store_true', help='Validate and preview requests without API calls or output files')
    ap.add_argument('--resume', action='store_true', help='Resume a run with exactly the same generation configuration')
    ap.add_argument('--score', action='store_true', help='Also run both neural scorers and aggregate all metrics')
    ap.add_argument('--model-dir', type=Path, help='Local ModernBERT-base weights, required with --score')
    ap.add_argument('--embedding-model', type=Path, help='Local MPNet weights, required with --score')
    ap.add_argument('--device', default='cuda')
    args = ap.parse_args(argv)
    if not re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9_.-]*', args.name) or args.name in {'.', '..'}:
        ap.error('--name must contain only letters, digits, dots, underscores, or hyphens')
    if args.max_tokens < 1 or args.timeout <= 0 or args.retries < 0 or (args.limit is not None and args.limit < 1):
        ap.error('Token budget, timeout and limit must be positive; retries must be nonnegative')
    url = parse.urlsplit(args.api_base)
    if url.scheme not in {'http', 'https'} or not url.netloc or url.username or url.password or url.query or url.fragment:
        ap.error('--api-base must be an HTTP(S) base URL without credentials, query, or fragment')
    args.endpoint = args.api_base.rstrip('/') + '/chat/completions'
    if args.score:
        if args.domain != 'all' or args.limit is not None:
            ap.error('--score requires the complete benchmark')
        if not args.model_dir or not args.embedding_model or not args.model_dir.is_dir() or not args.embedding_model.is_dir():
            ap.error('--score requires existing local --model-dir and --embedding-model directories')
    exporter = PredictionExporter(ROOT)
    jobs = make_jobs(args, exporter.refs)
    if args.dry_run:
        print(json.dumps(dict(status='dry_run', requests=len(jobs), domains=dict(Counter(
            exporter.refs[job['key']]['domain'] for job in jobs)), model=args.model, endpoint=args.endpoint)))
        return 0
    run = ROOT / 'results/generation' / args.name
    output = ROOT / 'results/new_models' / args.name
    target = ROOT / 'results/per_case' / (args.name + '_predictions.jsonl')
    manifest = json.loads((ROOT / 'validation/release_manifest.json').read_text())
    if any(entry['path'] == str(target.relative_to(ROOT)) for entry in manifest['files']):
        ap.error('Choose a new name; released model predictions cannot be overwritten')
    if run.exists() and not args.resume:
        ap.error('Run already exists; choose another name or use --resume')
    if not run.exists() and (args.resume or target.exists() or output.exists()):
        ap.error('Missing run to resume, or existing outputs would be overwritten')
    config = dict(version=VERSION, name=args.name, model=args.model, endpoint=args.endpoint,
                  domain=args.domain, limit=args.limit, requests_sha256=digest(jobs),
                  reference_sha256=file_digest(ROOT / 'benchmark/references/references.jsonl'),
                  target_sha256=digest(dict(law=exporter.law, sample3=exporter.sample3,
                                            grouped=exporter.goldmaps)),
                  retries=args.retries, timeout=args.timeout, parsing='strict_json_v1',
                  failures='zero score, no retry based on output format or correctness',
                  code_sha256={str(p.relative_to(ROOT)): file_digest(p) for p in [
                      ROOT / 'scripts/run_model_evaluation.py', ROOT / 'evaluation/prediction_export.py',
                      ROOT / 'benchmark/finance/scripts/answer_grading.py', ROOT / 'benchmark/finance/scripts/count.py',
                      ROOT / 'benchmark/finance/scripts/reasoning_text.py', ROOT / 'benchmark/law/scripts/run_llm_evaluation.py']})
    if run.exists():
        if json.loads((run / 'configuration.json').read_text()) != config:
            ap.error('Resume configuration differs; use a new experiment name')
    run.mkdir(parents=True, exist_ok=True)
    with run_lock(run):
        write_json(run / 'configuration.json', config)
        write_rows(run / 'requests.jsonl', jobs)
        latest = generate(args, jobs, run)
        predictions = [exporter.prediction(job['key'], args.name, latest[job['key']]) for job in jobs]
        if len({row['key'] for row in predictions}) != len(jobs):
            raise ValueError('Duplicate exported case keys')
        complete = {row['key'] for row in predictions} == set(exporter.refs)
        write_rows(run / 'predictions.jsonl', predictions)
        if complete:
            write_rows(target, predictions)
        summary = dict(model=args.name, complete_benchmark=complete, cases=len(predictions),
                       statuses=dict(Counter(row['status'] for row in predictions)),
                       groups=aggregate(predictions, exporter.refs))
        write_json(output / 'accuracy_summary.json', summary)
        print(json.dumps(summary), flush=True)
        if args.score:
            score_predictions(args, predictions, exporter.refs, output)
    return 0


if __name__ == '__main__':
    try:
        raise SystemExit(main())
    except (ValueError, OSError, subprocess.CalledProcessError) as exc:
        print('Pipeline stopped: ' + str(exc), file=sys.stderr)
        raise SystemExit(1)
