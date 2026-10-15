"""Normalize Finance and Law responses and grade against the released targets."""
import importlib.util
import json
import math
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


sys.path.insert(0, str(ROOT / 'benchmark/finance/scripts'))
from answer_grading import (SAMPLE1_SUBTASKS, SAMPLE2_SUBTASKS, SAMPLE3_EVAL_TASKS,
                            build_gold_mapping_s3, build_gold_mapping_grouped,
                            extract_s3_pred, extract_grouped_pred,
                            get_items_path_for, get_pred_map_for)
from reasoning_text import extract_reasoning_trace
law_grading = load_module('law_answer_grading', ROOT / 'benchmark/law/scripts/run_llm_evaluation.py')


def parse_response(text):
    """Accept a JSON object, optionally wrapped in a single Markdown code fence."""
    clean = re.sub(r'\s*```$', '', re.sub(r'^```(?:json)?\s*', '', text.strip(), flags=re.I))
    obj = json.loads(clean)
    if not isinstance(obj, dict):
        raise ValueError('Expected a JSON object')
    return obj


def extract_law_reasoning(obj):
    """Render explicit Law steps, preserving descriptions, results, and rule IDs."""
    trace = obj.get('reasoning_trace')
    if not isinstance(trace, list) or not trace:
        raise ValueError('Missing Law reasoning_trace')
    lines = []
    for i, step in enumerate(trace, 1):
        if not isinstance(step, dict) or not isinstance(step.get('description'), str):
            raise ValueError('Invalid Law reasoning step')
        description = ' '.join(step['description'].splitlines())
        result = step.get('result', '')
        rule = step.get('rule_id')
        if rule is not None and str(rule).isdigit() and not re.search(
                r'\b(?:Rule|Article)\s*' + re.escape(str(rule)) + r'\b', description, re.I):
            description += f' [Rule {rule}]'
        lines.append(f'Step {i}: {description}' + (f'. Result: {result}.' if result != '' else ''))
    return '\n'.join(lines)


class PredictionExporter:
    def __init__(self, root=ROOT):
        self.refs = {row['key']: row for row in map(json.loads,
                     (root / 'benchmark/references/references.jsonl').read_text().splitlines())}
        self.law = {}
        for path in (root / 'benchmark/law/data').glob('*/dataset.json'):
            data = json.loads(path.read_text())
            for case in data['cases']:
                key = 'law/' + data['bundle_name'] + '/' + case['case_id']
                self.law[key] = (case['gold_trace']['final_result'],
                                 data['scoring_target']['main']['final_result_aliases'])
        self.sample3 = {}
        for task, (_, ranges) in SAMPLE3_EVAL_TASKS.items():
            ids = [i for lo, hi in ranges for i in range(lo, hi + 1)]
            for cid, gold in build_gold_mapping_s3(task, ids).items():
                self.sample3[cid] = (task, gold)
        self.grouped = {'sample1': SAMPLE1_SUBTASKS, 'sample2': SAMPLE2_SUBTASKS}
        self.goldmaps = {sample: build_gold_mapping_grouped(tasks)
                         for sample, tasks in self.grouped.items()}
        if len(self.refs) != 1379 or set(self.law) != {k for k in self.refs if k.startswith('law/')}:
            raise ValueError('Unexpected benchmark coverage')

    def prediction(self, key, model, attempt):
        ref = self.refs[key]
        row = dict(key=key, model=model, text='', answer_correct=0,
                   status=attempt['status'], request_sha256=attempt['request_sha256'])
        if attempt['status'] != 'ok':
            return row
        try:
            obj = parse_response(attempt['content'])
            if ref['domain'] == 'law':
                text = extract_law_reasoning(obj)
                answer = obj.get('final_result')
                if not isinstance(answer, str) or not answer.strip():
                    raise ValueError('Missing final_result')
                gold, aliases = self.law[key]
                correct = int(law_grading.compare_scalar_field(answer, gold, aliases))
            else:
                text = extract_reasoning_trace(obj)
                if not text.strip():
                    raise ValueError('Missing Finance reasoning_trace')
                _, sample, cid = key.split('/')
                cid = int(cid)
                record = dict(status='ok', model_output=obj)
                if sample == 'sample3':
                    task, gold = self.sample3[cid]
                    answer = extract_s3_pred(record, task)
                    if isinstance(answer, float) and not math.isfinite(answer):
                        answer = None
                else:
                    tasks = self.grouped[sample]
                    gold = self.goldmaps[sample][cid]
                    answer = extract_grouped_pred(record, get_items_path_for(tasks, cid),
                                                  get_pred_map_for(tasks, cid))
                correct = int(answer is not None and answer == gold)
            row.update(text=text, answer_correct=correct,
                       answer_correction=dict(predicted_answer=answer, gold=gold, correct=correct))
        except (ValueError, TypeError, AttributeError, KeyError):
            # Strict parsing is fixed before generation; malformed outputs are not retried.
            row.update(status='invalid_output', text='', answer_correct=0)
        return row
