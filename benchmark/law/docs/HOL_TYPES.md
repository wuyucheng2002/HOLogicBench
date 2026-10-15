# Law HOL 类型标注

范围为 `data/*/dataset.json` 中10个规则包的全部300条案例，每包30条。字段与 finance 一致：`hol_types` 是多标签列表，`hol_type_flags` 是五项布尔值，`hol_type_annotation` 保存版本及逐项依据。原始问题、答案、轨迹和 Isabelle 代码均保留。

版本为 `law-policy-semantics-v1`，层级为 `policy_semantics`。依据包括规则目录、`gold_trace`、内嵌证明和各包 `Isabelle_code/<bundle>/Conflict.thy`。每项依据记录关联条款、规则编号、定义名、源文件及触发条件。

## 类型口径

| 标签 | 判定方式 |
| --- | --- |
| PR | 两个已触发条款实际形成 `stronger_than` 或 `exception_to` 关系。仅规则库中存在但本案未触发的关系不计入。 |
| PT | 已触发例外通过 `defeated` 和 `applicable` 排除基础条款，收紧基础政策的有效适用范围。普通优先关系不额外标 PT。 |
| PC | 要求组合两个政策形成审核政策。事实合取、中间概念推导、多个条款同时触发不单独满足此标准，故为 false。 |
| PS | 要求依据上下文选出并返回供后续应用的政策。`applicable` 是布尔判断，最终返回法律后果；未发现独立的政策返回操作，故为 false。 |
| PQ | 在条款政策域上量化。`defeated` 存在量化覆盖条款，`final_no_liability` 存在量化免责条款，`final_legal_result_holds` 存在量化结论条款并排除免责。全部案例使用此类最终结论定义。 |

PQ 包括存在量化及其否定，不仅限于分类表中的全称量化示例。只有一个实际触发条款的案例也需在候选域中检查免责与覆盖关系，仍标 PQ。PR 统计实际触发关系；没有实际冲突时，检查不存在覆盖条款由 PQ 表达。

## 形式化边界

`article` 是有限枚举，而不是 `Policy = X → bool` 函数类型。通过 `P_a(x) = article_triggered a x`，可把每个条款解释成政策谓词。PR、PQ 对应这些政策的关系和有限域量化；本标注不声称 Isabelle 已直接实现用户表中的高阶函数签名。

PT 沿用 finance 的例外语义解释：固定例外政策 E 后，可写作 `T_E(P)(x) = P(x) ∧ ¬E(x)`；代码以 `exception_to`、`defeated`、`applicable` 展开，未显式返回新政策函数。只有例外关系两端均触发时标 PT。若论文要求严格的函数类型级证据，需另行重构并证明对应编码。

PC 不把事实或犯罪构成要素的合取视为政策组合；finance 中被组合的是命名审核子政策。PS 不把冲突消解后的适用条款集合等同于 `Context → Policy` 的单政策选择。本次为可复现的语义标注，不是独立人工复核金标准。

历史评测结果、归档 ZIP、轨迹副本及 `case_plans.json` 未作为独立案例重复标注。

## 统计

| 数据集 | 案例数 | PR | PT | PC | PS | PQ |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| archive_relic_with_rescue_exceptions | 30 | 25 | 15 | 0 | 0 | 30 |
| aviation_security_with_authorizations | 30 | 26 | 15 | 0 | 0 | 30 |
| cyber_intrusion_with_authorizations | 30 | 25 | 15 | 0 | 0 | 30 |
| dream_archive_with_exceptions | 30 | 27 | 23 | 0 | 0 | 30 |
| environmental_pollution_with_permits | 30 | 25 | 15 | 0 | 0 | 30 |
| mechanical_city_maintenance_rules | 30 | 28 | 24 | 0 | 0 | 30 |
| mirror_customs_border_rules | 30 | 28 | 24 | 0 | 0 | 30 |
| orbital_habitat_safety_rules | 30 | 28 | 24 | 0 | 0 | 30 |
| property_crime_with_defenses | 30 | 24 | 15 | 0 | 0 | 30 |
| subterranean_signal_dispatch_rules | 30 | 28 | 24 | 0 | 0 | 30 |
| 合计 | 300 | 264 | 194 | 0 | 0 | 300 |

组合分布：36条仅 PQ，70条 PR + PQ，194条 PR + PT + PQ。标签计数不互斥。机器可读汇总见 `data/hol_type_summary.json`。

## 重建与检查

从仓库根目录运行：

```sh
python3 law/scripts/add_hol_types.py
python3 law/scripts/add_hol_types.py --check
```

脚本从规则目录与已触发条款推导冲突关系、被排除条款及适用条款，与 gold trace 核对；同时检查关系存在于源码中、量化定义存在且证明引用了结论定义。全部数据验证成功后才写入。`--check` 只读，核对全部标签、依据和汇总；不运行 Isabelle 证明器。

`aswa_case_17` 的 gold 已按形式化规则修正为 `imprisonment_between_7_15_years`，冲突及 HOL 标签同步更新；PR 比初版增加1。
