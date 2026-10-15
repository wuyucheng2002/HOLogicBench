"""Offline regression checks for generation, grading, and pipeline recovery."""
import argparse
from contextlib import redirect_stdout, redirect_stderr
import copy
import importlib.util
import io
import json
from pathlib import Path
import shutil
import tempfile
import unittest
from unittest.mock import patch, MagicMock
from urllib.error import HTTPError

from prediction_export import PredictionExporter, extract_law_reasoning, parse_response
import answer_grading as finance

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('new_model_pipeline', ROOT / 'scripts/run_model_evaluation.py')
pipeline = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pipeline)


def set_nested(obj, path, value):
    for part in path[:-1]:
        obj = obj.setdefault(part, {})
    obj[path[-1]] = value


def gold_response(exporter, key):
    step = dict(step=1, description='Check — supplied facts', result='PASS', rule_id=None)
    if key.startswith('law/'):
        return dict(reasoning_trace=[step], final_result=exporter.law[key][0])
    _, sample, cid = key.split('/')
    cid = int(cid)
    obj = dict(reasoning_trace=[step])
    if sample == 'sample3':
        task, gold = exporter.sample3[cid]
        config = finance.count.TASK_CONFIGS[task]
        raw = gold if task == 'amount' else next(k for k, v in config['pred_map'].items() if v == gold)
        set_nested(obj, config['json_path'][1:], raw)
    else:
        tasks = exporter.grouped[sample]
        mapping = finance.get_pred_map_for(tasks, cid)
        obj = {finance.get_items_path_for(tasks, cid)[-1]: [
            dict(audit_result=next(k for k, v in mapping.items() if v == gold), reasoning_trace=[step])
            for gold in exporter.goldmaps[sample][cid]]}
    return obj


class ExportTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.exporter = PredictionExporter()

    def test_all_1379_gold_answers_and_traces(self):
        for key in self.exporter.refs:
            with self.subTest(key=key):
                content = json.dumps(gold_response(self.exporter, key))
                result = self.exporter.prediction(key, 'TestModel', dict(status='ok', content=content, request_sha256='test'))
                self.assertEqual(result['answer_correct'], 1)
                self.assertTrue(result['text'])

    def test_law_retains_explicit_citation_and_result(self):
        text = extract_law_reasoning({'reasoning_trace': [
            {'description': 'Check — a\nb', 'result': 'FAIL', 'rule_id': '7'},
            {'description': '[Rule 8] exception', 'result': 'PASS', 'rule_id': '8'}]})
        self.assertIn('Check — a b [Rule 7]. Result: FAIL.', text)
        self.assertEqual(text.count('[Rule 8]'), 1)

    def test_wrong_law_answer_is_not_accepted_from_reasoning(self):
        key = next(iter(self.exporter.law))
        obj = gold_response(self.exporter, key)
        obj['reasoning_trace'][0]['description'] = self.exporter.law[key][0]
        obj['final_result'] = 'unrelated decision'
        row = self.exporter.prediction(key, 'TestModel', dict(status='ok', content=json.dumps(obj), request_sha256='test'))
        self.assertEqual(row['answer_correct'], 0)
        self.assertTrue(row['text'])

    def test_failed_truncated_and_malformed_outputs_stay_in_export(self):
        for key in ['finance/sample1/1', next(iter(self.exporter.law))]:
            for status, content in [('incomplete_response', json.dumps(gold_response(self.exporter, key))),
                                    ('transport_error', ''), ('ok', 'malformed JSON')]:
                row = self.exporter.prediction(key, 'TestModel', dict(status=status, content=content, request_sha256='test'))
                self.assertEqual((row['key'], row['text'], row['answer_correct']), (key, '', 0))

    def test_grouped_finance_requires_every_item(self):
        key = next(k for k in self.exporter.refs if k.startswith('finance/sample1/')
                   and len(self.exporter.goldmaps['sample1'][int(k.split('/')[-1])]) > 1)
        obj = gold_response(self.exporter, key)
        obj['fee_items'].pop()
        row = self.exporter.prediction(key, 'TestModel', dict(status='ok', content=json.dumps(obj), request_sha256='test'))
        self.assertEqual(row['answer_correct'], 0)

    def test_single_markdown_fence_is_supported(self):
        self.assertEqual(parse_response('```json\n{"x":1}\n```'), {'x': 1})

    def test_missing_finance_trace_is_a_failed_export(self):
        key = 'finance/sample3/1'
        obj = gold_response(self.exporter, key)
        obj.pop('reasoning_trace')
        row = self.exporter.prediction(key, 'TestModel', dict(status='ok', content=json.dumps(obj), request_sha256='test'))
        self.assertEqual((row['status'], row['answer_correct']), ('invalid_output', 0))

    def test_frozen_request_selection_has_exact_coverage(self):
        args = argparse.Namespace(model='provider/test', name='TestModel', request_options=None,
                                  token_field='max_tokens', max_tokens=32000, domain='all', limit=None)
        jobs = pipeline.make_jobs(args, self.exporter.refs)
        self.assertEqual(len(jobs), 1379)
        self.assertEqual({j['key'] for j in jobs}, set(self.exporter.refs))
        self.assertTrue(all(set(j['request']) == {'model', 'messages', 'stream', 'max_tokens'} for j in jobs))


class TransportTests(unittest.TestCase):
    def test_transient_error_and_auth_failures_are_classified(self):
        for code, retry in [(429, True), (401, True), (400, False)]:
            opener = MagicMock()
            opener.open.side_effect = HTTPError('https://example.test/v1', code, 'test', {}, None)
            with patch.object(pipeline.request, 'build_opener', return_value=opener):
                row = pipeline.call_model('https://example.test/v1', {}, 'test-credential', 1)
            self.assertEqual(row['retryable'], retry)
            self.assertNotIn('response', row)

    def test_response_redaction_and_length_termination(self):
        raw = dict(choices=[dict(message=dict(content='test-credential'), finish_reason='length')])
        opener = MagicMock()
        opener.open.return_value.__enter__.return_value = io.StringIO(json.dumps(raw))
        with patch.object(pipeline.request, 'build_opener', return_value=opener):
            row = pipeline.call_model('https://example.test/v1', {}, 'test-credential', 1)
        self.assertEqual(row['status'], 'incomplete_response')
        self.assertFalse(row['retryable'])
        self.assertNotIn('test-credential', json.dumps(row))

    def test_secret_fields_and_redirects_are_rejected(self):
        with self.assertRaises(ValueError):
            pipeline.check_options({'provider': {'api_key': 'test-credential'}})
        self.assertIsNone(pipeline.NoRedirect().redirect_request(None, None, 302, '', {}, 'https://example.test'))


class PipelineTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for name in ['scripts/run_model_evaluation.py', 'evaluation/prediction_export.py',
                     'benchmark/finance/scripts/answer_grading.py', 'benchmark/finance/scripts/count.py',
                     'benchmark/finance/scripts/reasoning_text.py', 'benchmark/law/scripts/run_llm_evaluation.py',
                     'benchmark/references/references.jsonl']:
            target = self.root / name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(ROOT / name, target)
        (self.root / 'validation').mkdir()
        (self.root / 'validation/release_manifest.json').write_text('{"files":[]}')
        self.exporter = PredictionExporter()
        keys = ['finance/sample1/1', 'finance/sample3/1', next(iter(self.exporter.law))]
        self.exporter.refs = {k: self.exporter.refs[k] for k in keys}
        self.jobs = [dict(key=k, model='TestModel', request={'model': 'provider/test', 'messages': []},
                          request_sha256=pipeline.digest({'model': 'provider/test', 'messages': []})) for k in keys]
        self.argv = ['--model', 'provider/test', '--name', 'TestModel', '--api-base', 'https://example.test/v1']

    def invoke(self, extra=(), responses=None):
        if responses is None:
            responses = [dict(status='ok', content=json.dumps(gold_response(self.exporter, j['key'])), retryable=False)
                         for j in self.jobs]
        with patch.object(pipeline, 'ROOT', self.root), \
             patch.object(pipeline, 'PredictionExporter', return_value=self.exporter), \
             patch.object(pipeline, 'make_jobs', return_value=self.jobs), \
             patch.object(pipeline, 'call_model', side_effect=responses) as call, \
             patch.dict(pipeline.os.environ, {'API_KEY': 'test-credential'}), \
             patch.object(pipeline.time, 'sleep'), redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            result = pipeline.main(self.argv + list(extra))
            return result, call.call_count

    def test_generation_export_and_resume_skip_completed_cases(self):
        self.assertEqual(self.invoke(), (0, 3))
        path = self.root / 'results/per_case/TestModel_predictions.jsonl'
        rows = [json.loads(s) for s in path.read_text().splitlines()]
        self.assertEqual(sum(r['answer_correct'] for r in rows), 3)
        before = path.read_bytes()
        self.assertEqual(self.invoke(['--resume'], responses=[]), (0, 0))
        self.assertEqual(path.read_bytes(), before)
        for p in self.root.rglob('*.json*'):
            self.assertNotIn('test-credential', p.read_text())

    def test_transport_retry_is_bounded_and_bad_answers_are_not_retried(self):
        responses = [dict(status='transport_error', retryable=True),
                     dict(status='ok', content='malformed', retryable=False),
                     dict(status='incomplete_response', content='', retryable=False),
                     dict(status='ok', content=json.dumps(gold_response(self.exporter, self.jobs[2]['key'])), retryable=False)]
        self.assertEqual(self.invoke(responses=responses), (0, 4))
        rows = [json.loads(s) for s in (self.root / 'results/per_case/TestModel_predictions.jsonl').read_text().splitlines()]
        self.assertEqual([r['answer_correct'] for r in rows], [0, 0, 1])

    def test_dry_run_makes_no_outputs_or_calls(self):
        self.assertEqual(self.invoke(['--dry-run'], responses=[]), (0, 0))
        self.assertFalse((self.root / 'results').exists())

    def test_resume_rejects_changed_configuration(self):
        self.invoke()
        with self.assertRaises(SystemExit):
            self.invoke(['--resume', '--retries', '9'])

    def test_released_predictions_are_protected(self):
        manifest = self.root / 'validation/release_manifest.json'
        manifest.write_text(json.dumps({'files': [{'path': 'results/per_case/TestModel_predictions.jsonl'}]}))
        with self.assertRaises(SystemExit):
            self.invoke(responses=[])
        self.assertFalse((self.root / 'results/generation/TestModel').exists())

    def test_existing_run_requires_explicit_resume(self):
        self.invoke()
        with self.assertRaises(SystemExit):
            self.invoke(responses=[])

    def test_partial_selection_does_not_publish_full_predictions(self):
        self.exporter.refs['finance/sample1/2'] = dict(domain='finance', hol_types=[])
        self.invoke(['--limit', '3'])
        self.assertFalse((self.root / 'results/per_case/TestModel_predictions.jsonl').exists())
        self.assertTrue((self.root / 'results/generation/TestModel/predictions.jsonl').exists())

    def test_auth_failure_stops_and_can_resume_after_fix(self):
        with self.assertRaises(ValueError):
            self.invoke(responses=[dict(status='http_error', retryable=True, http_status=401)])
        self.assertFalse((self.root / 'results/per_case/TestModel_predictions.jsonl').exists())
        self.assertEqual(self.invoke(['--resume']), (0, 3))

    def test_interrupted_final_log_append_is_repaired(self):
        self.invoke()
        path = self.root / 'results/generation/TestModel/attempts.jsonl'
        with path.open('ab') as stream:
            stream.write(b'{"interrupted":')
        self.assertEqual(self.invoke(['--resume'], responses=[]), (0, 0))
        self.assertTrue(path.read_bytes().endswith(b'\n'))

    def test_neural_scoring_sequence_and_summary(self):
        self.invoke()
        output = self.root / 'results/new_models/TestModel'
        weights = self.root / 'weights'
        weights.mkdir()
        args = argparse.Namespace(name='TestModel', device='cpu', model_dir=weights, embedding_model=weights)
        predictions = [json.loads(s) for s in (self.root / 'results/per_case/TestModel_predictions.jsonl').read_text().splitlines()]
        commands = []
        def fake_run(command, check):
            commands.append(command)
            stage = output / 'metrics'
            if 'prepare_metric_run.py' in command[1]:
                stage.mkdir()
                for src in [self.root / 'results/per_case/TestModel_predictions.jsonl', self.root / 'benchmark/references/references.jsonl']:
                    shutil.copyfile(src, stage / src.name)
            else:
                rows = []
                for key in self.exporter.refs:
                    row = dict(model='TestModel', key=key, reference_sha256=pipeline.file_digest(stage / 'references.jsonl'))
                    if 'modernbert.py' in command[1]:
                        row.update(bertscore_f1=0.5, best_reference_id='reference')
                    else:
                        row.update(metric_maxima=dict(roscoe_sa_prec=0.6, rouge_l=0.7), best_reference_ids={})
                    rows.append(row)
                name = 'modernbert_case_scores.jsonl' if 'modernbert.py' in command[1] else 'rouge_roscoe_case_scores.jsonl'
                pipeline.write_rows(stage / name, rows)
        with patch.object(pipeline, 'ROOT', self.root), patch.object(pipeline.subprocess, 'run', side_effect=fake_run):
            pipeline.score_predictions(args, predictions, self.exporter.refs, output)
        self.assertEqual(len(commands), 3)
        group = json.loads((output / 'summary.json').read_text())['groups']['Overall']
        self.assertEqual(group['accuracy'], 1)
        self.assertEqual(group['bertscore_f1'], 0.5)
        self.assertTrue((output / 'summary.csv').exists())


if __name__ == '__main__':
    unittest.main()
