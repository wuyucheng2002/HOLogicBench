# 数据与文件之间的关系

所有路径均相对仓库根目录。文件里的案例 ID 是逻辑标识，不是磁盘路径。

## 案例和参考

- `benchmark/finance/data/sample{1,2,3}.json`：Finance 案例、事实、形式化案例对应关系、语义标签。
- `benchmark/law/data/<bundle>/dataset.json`：Law 案例、规则文本、问题和目标答案。
- `benchmark/references/references.jsonl`：统一案例索引。`key` 为 `finance/<sample>/<id>` 或 `law/<bundle>/<id>`；`hol_types` 为可重叠标签；`reference_count` 为有效参考数量。
- Finance 索引行的 `components` 指向 `finance_evidence_catalog.jsonl.gz` 中的形式化子案例。路径包含原始节点、前提、根节点和 `step_ids`；文本从 `finance_evidence_steps.json` 读取。完整参考是多个组件的笛卡尔积，不重复存储全部组合。
- Law 索引行直接保存 `references`，包含 `reference_id` 和推理文本。
- `rule_recall_references.jsonl` 为每个案例保存不同的有效规则编号集合。

解压后，可读取一条 Finance 参考：

```sh
python3 evaluation/metrics/evidence_reference_reader.py finance/sample3/22 --indices 0 --output reference_example.json
```

## 逐案例结果

`results/per_case/` 中，每组设置有三个文件：

| 文件后缀 | 关键字段 |
| --- | --- |
| `_predictions.jsonl` | `key`、`model`、实际评分文本 `text`、`answer_correct`、答案修正记录（如有） |
| `_case_scores.jsonl` | `key`、标签、`metric_maxima`、`best_reference_ids`、`reference_sha256`、`rule_recall` |
| `_rule_recall.jsonl` | `predicted_rule_ids`、参考规则、命中/遗漏编号、`best_reference_id`、召回分数 |

每组文件恰好覆盖 1,379 个不同 `key`。模型回答文件是规范化后的评分输入，不是完整接口日志或模型内部思维过程。V4-Flash 的历史/补充回答对应关系保存在 `source_group_index.jsonl` 中。

`results/main/hol_main_results.json` 与 CSV 由上述逐案例分数汇总。不同指标的 `best_reference_ids` 可以不同；数值必须与选用的参考集匹配，不应混用其他参考版本。

## 实验记录与补充分析

`results/generation/` 保存固定请求与生成配置；`results/configuration/` 保存评分设置、记录的运行环境和分阶段核验。历史配置中的源文件名与哈希用于追溯原实验，它们不总是当前包中的可执行入口；当前文件完整性以 `validation/release_manifest.json` 和 `validation/SHA256SUMS` 为准。

`results/supplementary/` 包含错误分析、依赖深度、thinking 对比和反事实 pilot。各自的协议与样本范围见对应目录中的报告。其样本数量不能直接与主表相加。

## 完整性与压缩

`validation/release_manifest.json` 将分发文件 `path` 映射到解压位置 `expanded_path`，分别保存压缩与展开后的 SHA-256。`source` / `source_sha256`（如存在）描述原始来源或导出前的字节；移动、删减和可移植性修改后的文件以当前 `sha256` 为准。

`python3 scripts/unpack_data.py --verify-only` 检查分发文件；去掉参数后解压，遇到已有且内容不同的目标文件会停止，不覆盖本地修改。完整 `SHA256SUMS` 中的路径同样以仓库根目录为基准。
