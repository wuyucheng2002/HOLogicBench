# HOLogicBench

HOLogicBench 用于评测语言模型在复杂规则约束下的推理能力。项目包含高校报销（Finance）与法律风格规则（Law）两个领域，将案例、规则与参考推导连接到 Isabelle/HOL 形式化实现，并从最终答案和推理过程两个方面评测模型。

**1,379 个案例 · 16 组模型设置 · 22,064 条模型—案例评分**

[English](README.md) | 中文

## 项目如何工作

```text
规则文本 + 案例事实
        │
        ├─→ Isabelle/HOL 规则与案例 → 解释图 → 有效参考推理路径
        │                                        │
        └─→ 固定提示词 → 模型回答 → 最终答案与推理文本 ─┤
                                                 ↓
                              答案准确率 + 多参考推理指标
                                                 ↓
                                    逐案例记录 → 分类与总体结果
```

1. **构建案例与规则。** Finance 有 200 个 sample1、200 个 sample2 和 679 个 sample3 案例；Law 有 10 个规则包，每包 30 个案例。每个案例包含规则适用所需的事实、期望结论与语义标签。
2. **构建形式化参考。** Isabelle 理论描述规则、例外、优先关系与案例结论。路径枚举保留不同事实支持和分支选择；一个答案可以对应多条有效推导。这里的完备性针对导出的解释规范，不表示枚举了全部可能的 HOL 证明。
3. **生成与整理回答。** 模型读取规则和案例事实，输出最终结论及显式推理步骤。评分文本保留实际回答，不使用模型内部思维文本补写步骤。生成请求、协议与实验配置一并保留。
4. **逐案例评分。** 最终答案与形式化目标比较；每项推理指标分别对有效参考取最大值。不同指标可以选择不同的最优参考。
5. **汇总与分析。** 先得到逐案例分数，再计算各语义类别、Overall 和模型平均值。补充分析单独保存，不混入主表。

Finance 有 262,249 条组合参考，采用分组件存储，避免重复展开；Law 有 2,677 条参考。原始 Finance 形式化导出包含 1,602 个子案例和 25,108 条路径，其中 benchmark 使用 1,321 个子案例的 24,078 条路径。

## 目录与阅读顺序

```text
benchmark/                 数据、形式化实现与参考路径
  finance/                 Finance 数据、构建代码、规则、证明与测试
  law/                     Law 数据、构建代码、规则与验证会话
  references/              两领域的统一参考、Finance 证据目录与规则集合
evaluation/                回答协议与模型生成代码
  metrics/                 当前指标实现、引用提取与参考读取
results/                   全部模型实验记录与结果
  main/                    主表数据：CSV、JSON
  per_case/                逐案例回答、分数、引用编号与参考见证
  generation/              固定生成请求、生成配置；新调用也写入此处
  configuration/           指标参数、运行环境与各阶段核验记录
  supplementary/           错误分析、深度分析、thinking 对比、反事实实验
scripts/                   统一复核、匿名检查、解压与重评分入口
requirements/              可选 Python 依赖
docs/                      数据格式与许可状态
validation/                文件清单、校验和、形式化来源记录与本次检查报告
```

先看 [主表 CSV](results/main/hol_main_results.csv) 或 [主表 JSON](results/main/hol_main_results.json)，需要追查个别案例时查看 [逐案例记录](results/per_case/)。数据字段与文件之间的对应关系见 [数据格式](docs/DATA_FORMAT.md)。

`results/generation/` 里的 `requests*.jsonl.gz` 是实际生成请求，属于实验记录；`benchmark/references/` 是用于评分的参考数据，两者用途不同。代码目录中不再嵌套模型实验结果目录。

## 指标与汇总口径

| 指标 | 含义 |
| --- | --- |
| Accuracy | 模型最终答案是否匹配案例目标 |
| BERTScore-F1 | ModernBERT-base 第 22 层；8,192-token 窗口、1,024-token 重叠；按全文 token 匹配 |
| ROSCOE-SA precision | MPNet 编码推理步骤，对模型步骤取参考步骤的最大相似度，再平均；每步最多 512 tokens |

每项推理指标独立选择最优参考，再按案例等权平均。ROUGE-L 也保留在逐案例文件中。空推理文本的推理分数为零。

PR（政策优先关系）、PT（政策变换）、PC（政策组合）、PS（政策选择）、PQ（政策量化）是可重叠的任务语义标签，数量分别为 268、265、1,015、998、300。**Overall 将全部 1,379 个案例各计一次**，包括五类标签以外的 20 个案例；Average 对 16 组设置等权平均。不能直接平均类别分数得到 Overall。标注边界见 [Finance](benchmark/finance/docs/HOL_TYPES.md) 和 [Law](benchmark/law/docs/HOL_TYPES.md)。

## 离线复核

以下命令均从**仓库根目录**运行，使用 Python 3.10 或以上版本，只需标准库，不调用 API 或 GPU：

```sh
python3 scripts/unpack_data.py --verify-only
python3 scripts/audit_release.py
python3 scripts/reproduce_results.py --output reproduced
python3 -m unittest discover -s benchmark/finance/tests -p 'test_*.py'
python3 -m unittest discover -s evaluation -p 'test_*.py'
python3 benchmark/finance/path_proofs/theorem1/check_enumeration.py
```

复核检查案例覆盖、回答与分数一致性、参考见证、形式化文件哈希及主表的所有均值。它重建的是已保存分数的汇总，不重新计算神经相似度或构建 Isabelle 证明。随包结果不会被覆盖；新汇总写入 `reproduced/`。

## 重新评分或生成回答

大文件以 `.gz` 保存，主表复核直接读取压缩文件。需要运行原始构建代码时先执行：

```sh
python3 scripts/unpack_data.py
```

神经指标依赖见 [requirements/metrics.txt](requirements/metrics.txt)。自行准备本地 ModernBERT-base 与 MPNet 模型后，建立独立评分目录：

```sh
python3 scripts/prepare_metric_run.py --model DeepSeek-R1 --output metric_run
python3 metric_run/score_evidence_modernbert.py --device cuda --model-dir models/ModernBERT-base
python3 metric_run/score_evidence_rouge_roscoe.py --device cuda --embedding-model models/all-mpnet-base-v2
```

模型权重不随包提供。当前评分器使用离线模型文件；完整 Finance 多参考评分需要较多 GPU 时间和缓存空间。相关目录均为相对路径，建议为解压及独立评分工作目录预留约 3 GB 磁盘空间，模型与运行缓存需额外空间。

生成代码位于 `evaluation/`。例如，解压后仅检查一条 Law 请求：

```sh
python3 evaluation/run_law_v3.py --model DeepSeek-R1 --max-requests 1
```

上面的命令不联网。主动添加 `--execute` 并设置相应 API 环境变量才会发出请求。其他客户端的 `run` 会实际调用模型，使用前查看 `--help`。旧的请求重建入口已删除，使用随包的固定请求即可。Isabelle 通过 `ISABELLE_BIN` 环境变量或 `PATH` 定位。

## 新增模型的评估流程

统一入口 [scripts/run_model_evaluation.py](scripts/run_model_evaluation.py) 会依次完成：

1. 直接从压缩请求文件读取全部 1,379 个案例的固定提示词。
2. 通过兼容 OpenAI **Chat Completions** 的接口生成回答。
3. 同时处理 **Finance 和 Law** 的显式推理文本，判定最终答案，并导出完整案例集的标准预测文件。
4. 汇总 Accuracy；也可以继续运行神经指标并汇总全部分数。

生成和导出只需要 Python 标准库。对于兼容的非流式接口，无需手动解压、转换响应或另写供应商适配器。使用新的、适合用作文件名的模型设置名；不同 thinking 设置应分别命名。

### 一次调用完成生成与导出

从仓库根目录运行，替换模型 ID 和供应商接口地址：

```sh
python3 scripts/run_model_evaluation.py \
  --model provider/model-id \
  --name NewModel \
  --api-base https://openrouter.ai/api/v1
```

脚本从环境变量 `API_KEY` 读取密钥；未设置时会以隐藏输入方式询问。可用 `--api-key-env OPENROUTER_API_KEY` 指定其他环境变量。密钥不会写入请求文件或配置文件。

正式调用前可添加 `--dry-run`，离线检查全部请求，不调用接口、不创建输出文件。若要实际试跑少量案例，使用单独的设置名并添加 `--limit 2`；添加 `--domain law` 可专门试跑 Law。子集预测只保存在当前运行目录，不会写入完整评测的预测目录。

默认输出上限为 32,000 tokens，可通过 `--max-tokens` 修改。接口要求另一种字段名时，添加 `--token-field max_completion_tokens`。temperature、thinking 等供应商参数可通过 `--request-options options.json` 传入，例如：

```json
{"temperature": 0}
```

这些参数会直接传给供应商。脚本自行设置 `model`、`messages`、`stream: false` 和 token 上限字段，选项文件中不要重复设置这些字段或放入凭据。使用其他协议的供应商原生接口，以及仅支持流式响应的接口，仍需单独适配。

### 输出文件、文本提取与失败处理

| 输出位置 | 内容 |
| --- | --- |
| `results/generation/NewModel/configuration.json` | 协议、输入与代码哈希、重试配置 |
| `results/generation/NewModel/requests.jsonl` | 实际请求体与哈希 |
| `results/generation/NewModel/attempts.jsonl` | 响应、状态、结束原因、用量与尝试次数 |
| `results/generation/NewModel/predictions.jsonl` | 本次选择案例的预测，包含失败案例 |
| `results/per_case/NewModel_predictions.jsonl` | 标准预测，仅在覆盖完整 benchmark 时写入 |
| `results/new_models/NewModel/accuracy_summary.json` | 状态计数、分类及 Overall Accuracy |

两领域的统一导出实现在 [evaluation/prediction_export.py](evaluation/prediction_export.py)。Finance 复用 `extract_reasoning_trace()` 和原实验的答案映射逻辑；Law 使用 `extract_law_reasoning()`，将描述、结果和显式规则编号渲染为逐行推理步骤，再将 `final_result` 与数据集目标及别名进行比较。模型内部思维文本不作为推理评分输入。

每条预测包含 `key`、`model`、`text` 和整数 `answer_correct`（`0` 或 `1`），以及提取状态与请求来源。Finance 中包含多个费用项或审核对象的案例，要求完整答案列表一致。Law 的正确性根据最终结论字段判定，不从推理正文中猜测答案。

解析器接受 JSON 对象，也接受 Markdown 代码块包裹的 JSON。请求失败、响应截断、空回答或无法解析的输出仍保留在评测中，评分文本为空、正确性为零；这一严格解析策略会记录在运行配置中。只有临时网络或 HTTP 错误会自动重试，输出格式和答案正确性不会触发重试。`--retries` 默认为额外重试两次，认证、余额或访问权限错误会立即停止运行。

中断后，在相同命令后添加 `--resume` 即可继续。已完成案例会被跳过，生成配置必须与保存的配置一致。认证错误需要先修正密钥再继续，已记录的尝试次数仍计入预算。随包模型的预测文件受到覆盖保护。若进程被强制终止而遗留 `.pipeline.lock`，确认旧进程已停止后再删除锁文件。

### 一次调用同时完成神经指标评分

安装 [requirements/metrics.txt](requirements/metrics.txt) 并准备本地模型权重，然后添加 `--score` 和权重目录：

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

如果该设置已经完成生成，添加 `--resume` 可复用已有回答。脚本会准备独立评分目录，依次运行 ModernBERT BERTScore 和 ROUGE/ROSCOE，检查案例覆盖与参考哈希，合并分数并生成：

- `results/new_models/NewModel/metrics/`：评分输入、配置、检查点和原始分数。
- `results/new_models/NewModel/case_scores.jsonl`：逐案例合并分数与参考见证。
- `results/new_models/NewModel/summary.json` 和 `summary.csv`：分类及 Overall 汇总。

`--score` 要求完整案例集。每项指标按案例等权平均，Overall 将全部 1,379 个案例各计一次。随包主表继续记录原有 16 组设置，新增运行使用自己的汇总结果。

文件格式说明见 [docs/DATA_FORMAT.md](docs/DATA_FORMAT.md)，许可状态见 [docs/LICENSE_NOTICE.md](docs/LICENSE_NOTICE.md)。
