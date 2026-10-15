# HOLogicBench

HOLogicBench evaluates language models on reasoning under complex rules in Finance and Law. Cases, rules, and reference derivations are linked to Isabelle/HOL formalizations, enabling evaluation of both final answers and explicit reasoning.

**1,379 cases · 16 model settings · 22,064 model–case evaluations**

English | [中文](README.cn.md)

## How the project works

```text
Rules + case facts
        │
        ├─→ Isabelle/HOL rules and cases → explanation graphs → valid reference paths
        │                                                              │
        └─→ fixed prompts → model responses → answers and reasoning ────┤
                                                                       ↓
                                              answer accuracy + reasoning metrics
                                                                       ↓
                                                per-case records → aggregate results
```

1. **Build cases and rules.** Finance contains 200 sample1, 200 sample2, and 679 sample3 cases. Law contains ten rule bundles with 30 cases each. Cases specify the facts, expected conclusions, and semantic labels.
2. **Construct formal references.** Isabelle theories encode rules, exceptions, priorities, and case conclusions. Path enumeration preserves distinct factual support and branch choices, so one answer can have multiple valid derivations. Completeness concerns the exported explanation specification, not all possible HOL proofs.
3. **Generate and normalize responses.** Models receive rules and case facts and produce final decisions and explicit reasoning steps. Scoring uses the actual response without supplementing it with internal model reasoning. Requests, protocols, and configurations are retained.
4. **Score each case.** Final answers are checked against the formal targets. Each reasoning metric independently takes its maximum over valid references; different metrics may select different references.
5. **Aggregate and analyze.** Per-case scores are averaged by semantic category and over all cases. Supplementary analyses are stored separately from the main table.

Finance has 262,249 composite references stored in factored form; Law has 2,677 references. The raw Finance formal export includes 1,602 subcases and 25,108 paths, of which the benchmark uses 1,321 subcases and 24,078 paths.

## Repository layout

```text
benchmark/                 Data, formalizations, and reference paths
  finance/                 Finance cases, builders, rules, proofs, and tests
  law/                     Law cases, builders, rules, and validation sessions
  references/              Shared references and the Finance evidence catalog
evaluation/                Response protocols and generation clients
  metrics/                 Metric implementations and reference readers
results/                   Model experiment records and results
  main/                    Main table data: CSV and JSON
  per_case/                Predictions, scores, and reference witnesses
  generation/              Frozen requests, generation configurations, and new runs
  configuration/           Metric parameters, environments, and stage checks
  supplementary/           Error, depth, thinking-mode, and counterfactual analyses
scripts/                   Verification, extraction, and rescoring helpers
requirements/              Optional Python dependencies
docs/                      Data format and license information
validation/                Manifests, checksums, formal provenance, and check reports
```

Start with the [main CSV](results/main/hol_main_results.csv) or [main JSON](results/main/hol_main_results.json), then inspect [per-case records](results/per_case/) for individual examples. See [data formats](docs/DATA_FORMAT.md) for field definitions and file relationships.

The `requests*.jsonl.gz` files in `results/generation/` preserve generation inputs. The files in `benchmark/references/` contain scoring references.

## Metrics and aggregation

| Metric | Definition |
| --- | --- |
| Accuracy | Whether the final answer matches the case target |
| BERTScore-F1 | ModernBERT-base layer 22; 8,192-token windows with 1,024-token overlap; full-text token matching |
| ROSCOE-SA precision | MPNet step embeddings; mean of each hypothesis step's maximum cosine similarity to reference steps; 512 tokens per step |

Each reasoning metric independently selects its best reference and is then averaged with equal weight per case. BERTScore uses midpoint ownership of overlapping windows, with no IDF or baseline rescaling; it is not an average of window scores. ROUGE-L is also retained in per-case records. Empty reasoning receives zero reasoning scores.

PR (policy priority), PT (policy transformation), PC (policy composition), PS (policy selection), and PQ (policy quantification) are overlapping semantic labels, with 268, 265, 1,015, 998, and 300 cases respectively. **Overall counts each of the 1,379 cases once**, including 20 cases outside these five labels. Average weights the 16 model settings equally. Averaging category scores does not recover Overall. Annotation definitions are documented for [Finance](benchmark/finance/docs/HOL_TYPES.md) and [Law](benchmark/law/docs/HOL_TYPES.md).

## Offline verification

Run all commands from the **repository root** with Python 3.10 or later. The following checks use only the standard library and require no API calls or GPU:

```sh
python3 scripts/unpack_data.py --verify-only
python3 scripts/audit_release.py
python3 scripts/reproduce_results.py --output reproduced
python3 -m unittest discover -s benchmark/finance/tests -p 'test_*.py'
python3 -m unittest discover -s evaluation -p 'test_*.py'
python3 benchmark/finance/path_proofs/theorem1/check_enumeration.py
```

Verification checks case coverage, answer/score agreement, reference witnesses, formal source hashes, and the means in the main table. It aggregates saved scores; it does not recompute neural metrics or rebuild Isabelle proofs. The new aggregate files are written to `reproduced/`.

## Rescoring existing predictions

Large files are distributed as gzip archives. Main-table verification reads them directly. Before running the original construction or generation scripts, extract them with:

```sh
python3 scripts/unpack_data.py
```

Install [requirements/metrics.txt](requirements/metrics.txt) in an environment with a suitable PyTorch build. Obtain local ModernBERT-base and MPNet weights separately, then prepare a fresh scoring directory:

```sh
python3 scripts/prepare_metric_run.py --model DeepSeek-R1 --output metric_run
python3 metric_run/score_evidence_modernbert.py --device cuda --model-dir models/ModernBERT-base
python3 metric_run/score_evidence_rouge_roscoe.py --device cuda --embedding-model models/all-mpnet-base-v2
```

Repeat `--model` to select multiple settings. The scorers use offline model files. Exhaustive Finance scoring requires substantial compute and cache space. Allow approximately 3 GB for extraction and a separate scoring workspace, plus additional storage for model weights and caches. Paths in these examples are relative to the repository root.

To inspect one saved Law request after extraction, without making an API call:

```sh
python3 evaluation/run_law_v3.py --model DeepSeek-R1 --max-requests 1
```

Adding `--execute` and setting the appropriate API environment variable enables generation. Other clients' `run` commands call the model; inspect their `--help` before use. Isabelle is located through `ISABELLE_BIN` or `PATH`.

## Evaluating a new model

The unified entry point [scripts/run_model_evaluation.py](scripts/run_model_evaluation.py) performs these stages in order:

1. Read the frozen shared prompts for all 1,379 cases, directly from the compressed request file.
2. Generate responses through an OpenAI-compatible **Chat Completions** endpoint.
3. Extract explicit reasoning for **both Finance and Law**, grade final answers, and export predictions with complete case coverage.
4. Write Accuracy summaries; optionally run the neural scorers and aggregate all metrics.

Generation and export use only Python's standard library. No manual extraction, response conversion, or provider adapter is needed for compatible non-streaming endpoints. Use a new filename-safe setting name; different thinking configurations should use different names.

### Generate and export with one command

Run from the repository root, replacing the model ID and API base with your provider's values:

```sh
python3 scripts/run_model_evaluation.py \
  --model provider/model-id \
  --name NewModel \
  --api-base https://openrouter.ai/api/v1
```

The script reads `API_KEY` from the environment or prompts for it without echo. Use `--api-key-env OPENROUTER_API_KEY` to select a different environment variable. Credentials are not included in saved requests or configuration.

Before a paid run, add `--dry-run` to validate all request inputs without network calls or output files. To try a small live subset, use a separate name and add `--limit 2`; add `--domain law` to test Law specifically. Subset predictions stay in the run directory and do not enter the full-benchmark prediction directory.

The default output budget is 32,000 tokens. Use `--max-tokens` to change it and `--token-field max_completion_tokens` for endpoints using that field. Provider-specific body options, such as temperature or thinking controls, can be supplied with `--request-options options.json`:

```json
{"temperature": 0}
```

Options are passed through to the provider. The runner sets `model`, `messages`, `stream: false`, and the token-budget field itself; do not put those fields or credentials in the options file. Native provider APIs using another protocol, and streaming-only endpoints, need a separate adapter.

### Outputs, extraction, and failure handling

| Output | Contents |
| --- | --- |
| `results/generation/NewModel/configuration.json` | Protocol, input/code hashes, and retry configuration |
| `results/generation/NewModel/requests.jsonl` | Exact request bodies and hashes |
| `results/generation/NewModel/attempts.jsonl` | Responses, status, finish reason, usage, and attempt numbers |
| `results/generation/NewModel/predictions.jsonl` | Predictions for the selected cases, including failed cases |
| `results/per_case/NewModel_predictions.jsonl` | Standard predictions, published only for full benchmark coverage |
| `results/new_models/NewModel/accuracy_summary.json` | Status counts and category/Overall Accuracy |

The shared export implementation is [evaluation/prediction_export.py](evaluation/prediction_export.py). Finance reuses `extract_reasoning_trace()` and the original answer-mapping logic. Law uses `extract_law_reasoning()` to render descriptions, results, and explicit rule IDs as one step per line, then compares `final_result` against the dataset target and aliases. Internal model thinking is not used as the scored reasoning text.

Each prediction contains `key`, `model`, `text`, and integer `answer_correct` (`0` or `1`), with extraction status and request provenance. Finance cases with multiple expense items or review subjects require the complete answer list to match. Law correctness is determined from the final-result field, not inferred from the reasoning body.

The parser accepts a JSON object, optionally in a Markdown code fence. Failed, truncated, empty, or unparseable responses remain in the evaluation with empty scoring text and zero correctness. This strict parsing policy is recorded in the new run's configuration. Only transient transport/HTTP errors are retried automatically; output format and answer correctness never trigger retries. `--retries` defaults to two additional attempts. Authentication, billing, or access errors stop the run immediately.

After an interruption, rerun the same command with `--resume`. Completed cases are skipped, and generation settings must match the saved configuration. To continue after an authentication error, fix the credential first; the recorded attempt budget still applies. Released model predictions are protected from overwrite. A process killed without cleanup may leave `.pipeline.lock`; remove it only after confirming the previous process has stopped.

### Include neural scoring in the same invocation

Install [requirements/metrics.txt](requirements/metrics.txt), prepare local model weights, then add `--score` and the weight directories:

```sh
python3 scripts/run_model_evaluation.py \
  --model provider/model-id \
  --name NewModel \
  --api-base https://openrouter.ai/api/v1 \
  --score \
  --device cuda \
  --model-dir models/ModernBERT-base \
  --embedding-model models/all-mpnet-base-v2
```

If generation has already finished under that name, add `--resume` to reuse its responses. The script prepares an isolated metric workspace, runs ModernBERT BERTScore followed by ROUGE/ROSCOE, checks coverage and reference hashes, joins scores with predictions, and writes:

- `results/new_models/NewModel/metrics/`: scorer inputs, configuration, checkpoints, and raw scores.
- `results/new_models/NewModel/case_scores.jsonl`: merged per-case scores and reference witnesses.
- `results/new_models/NewModel/summary.json` and `summary.csv`: category and Overall aggregates.

`--score` requires a full run. Each metric is averaged equally over cases; Overall counts all 1,379 cases once. The released main table remains a record of its 16 settings; new runs receive their own summaries.

See [data formats](docs/DATA_FORMAT.md) and [license information](docs/LICENSE_NOTICE.md) for additional details.
