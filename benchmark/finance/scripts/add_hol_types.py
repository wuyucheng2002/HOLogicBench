"""Annotate finance cases with evidence-backed, multi-label HOL policy semantics.

Run from any directory. --check verifies saved annotations without writing.
See ../docs/HOL_TYPES.md for the annotation boundary and formalization caveat.
"""

import argparse
from collections import Counter
import json
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent
TYPES = ("PR", "PT", "PC", "PS", "PQ")
VERSION = "finance-policy-semantics-v1"
SCHEMAS = {
    "appointment form printed": 3,
    "invoice lacks supervision seal": 4,
    "expense office stationery": 6,
    "has trip report form": 7,
    "has foreign affairs office approval": 8,
    "fund type": 9,
    "training participant role": 10,
    "staff unmarried visiting parents": 11,
    "expense graduate thesis review defense": 13,
    "approval form original provided": 14,
    "rule15 case.claim type": 15,
    "claim type": 16,
    "is equipment maintenance fee": 17,
    "is domestic official hospitality": 18,
    "visit scope": 19,
    "is special business for temp loan": 20,
}
# Composition of separately named policy predicates, not arbitrary Boolean fields.
COMPOSE = {
    3: ("rule_3_evaluate", "材料、签章、合同及特殊审批子政策联合审核"),
    6: ("rule_6_requirements", "办公用品、资产审核、图书及印刷等子政策联合审核"),
    7: ("rule_7_evaluate", "差旅凭证、交通、住宿及补贴子政策联合审核"),
    8: ("rule_8_evaluate", "外事审批、票据、支付及交通标准子政策联合审核"),
    9: ("rule_9_evaluate", "会议材料、地点、期限与费用限额子政策联合审核"),
    10: ("rule_10_evaluate", "培训材料、综合定额及讲师费用子政策联合审核"),
    11: ("rule_11_evaluate", "探亲资格、费用范围及申请材料子政策联合审核"),
    13: ("rule_13_evaluate", "评审答辩、讲课与咨询费用子政策联合审核"),
    14: ("rule_14_evaluate", "工程审批、合同支付及阶段材料子政策联合审核"),
    18: ("rule_18_evaluate", "公务接待材料、住宿、餐费及交通子政策联合审核"),
    19: ("rule_19_evaluate", "来访材料、住宿、餐费及其他接待子政策联合审核"),
    20: ("rule_20_evaluate", "借款业务、人员资格、核销期限及未清借款子政策联合审核"),
}
SELECT = {
    6: ("rule_6_requirements", ["expense office stationery", "expense books", "expense printing materials", "expense monograph publication subsidy"], "费用类别决定适用的办公、图书、印刷或出版要求"),
    7: ("rule7_2_transport_ok", ["fund type", "person position", "chosen mode", "has contract specific transport rule"], "资金来源、人员职级及合同情境选择交通标准政策"),
    8: ("rule8_3", ["is research project fund", "is non research project fund", "overseas traveler role"], "资金来源与人员职级选择境外交通标准政策"),
    9: ("rule_9_evaluate", ["fund type", "conf scope", "domestic class", "intl class"], "资金来源和会议类别选择定额政策"),
    10: ("rule10_1_comprehensive_quota", ["training participant role"], "参训人员职级选择培训定额政策"),
    11: ("rule_11_evaluate", ["staff unmarried visiting parents", "staff married visiting spouse", "staff married visiting parents"], "婚姻和探亲对象选择频次及费用政策"),
    13: ("rule_13_evaluate", ["expense graduate thesis review defense", "expense lecture fees", "expense expert consultation fees", "lecture speaker role", "consultation participant role"], "费用类别及专家职级选择适用的限额政策"),
    14: ("rule_14_evaluate", ["is first payment", "is final settlement payment", "project amount over 100k"], "支付阶段和工程规模选择材料与审批要求"),
    15: ("rule_15_evaluate", ["rule15 case.claim type"], "业务类型选择质保金退还或审价费政策"),
    16: ("rule_16_evaluate", ["claim type"], "资产类型选择固定资产、无形资产或材料政策"),
    18: ("rule18_2_accommodation_rules", ["is local shanghai unit visit", "visitor level provincial ministerial"], "来访地域及人员级别选择住宿安排政策"),
    19: ("rule_19_evaluate", ["visit scope", "guest level", "banquet type", "gift target level"], "来访范围、宾客级别及接待类别选择相应政策"),
    20: ("rule20_4_writeoff_deadline", ["is same city settlement", "is nonlocal settlement"], "结算地域选择30天或60天核销期限政策"),
}


def annotate(case):
    evidence = []

    def add(tag, name, source, reason, facts=()):
        evidence.append(dict(type=tag, case_name=name, source_definition=source,
                             reason=reason, conditions=list(facts)))

    def block(lines, name):
        # Rule 19 contains embedded rule 9 and rule 7 records. Only recurse when
        # its link is active; unused default embedded records are not evidence.
        first = lines[0].split(" must ")[0]
        rule = SCHEMAS[first]
        nested = []
        if rule == 19:
            starts = sorted(next(i for i, line in enumerate(lines) if line.startswith(prefix))
                            for prefix in ("fund type must", "has trip report form must")
                            if any(line.startswith(prefix) for line in lines))
            bounds = starts + [len(lines)]
            nested = [lines[a:b] for a, b in zip(bounds, bounds[1:])]
            lines = lines[:starts[0]] if starts else lines
        values = {}
        for line in lines:
            key, value = line.split(" must be ", 1)
            values[key] = value.removeprefix("set to ")

        def yes(key):
            return values.get(key) == "true"

        def facts(keys):
            return [line for line in lines if line.split(" must ")[0] in keys]

        def transform(trigger, source, reason):
            if yes(trigger):
                add("PT", name, source, reason, facts([trigger]))

        if rule in COMPOSE:
            source, reason = COMPOSE[rule]
            add("PC", name, source, reason)
        if rule in SELECT:
            source, keys, reason = SELECT[rule]
            add("PS", name, source, reason, facts(keys))
        if rule == 7:
            if yes("has contract specific transport rule"):
                add("PR", name, "rule7_2_transport_ok", "合同交通政策优先于通常交通等级政策", facts(["has contract specific transport rule", "satisfies contract transport rule"]))
            else:
                transform("transport above standard", "rule7_2_transport_ok", "超标准情境要求审查说明及签字是否足以形成例外政策")
            for trigger, source, reason in [
                ("transport ticket unobtainable in remote research", "rule7_4_invoice_ok", "无法取得交通票据时审查替代凭证例外政策"),
                ("lodging invoice unobtainable", "rule7_4_invoice_ok", "无法取得住宿发票时审查替代凭证例外政策"),
                ("intercity and lodging both paid by external unit", "rule7_6_subsidy_eligibility_ok", "外部承担交通和住宿后将补贴政策收紧为零"),
            ]:
                transform(trigger, source, reason)
        elif rule == 8:
            transform("foreign website purchase without formal receipts", "rule8_5", "无正式境外购物票据时使用记录及真实性声明的例外要求")
        elif rule == 9:
            exempt = values.get("fund type") == "R9_NonResearch" and values.get("conf scope") == "R9_International_In_China"
            omitted = [k for k in ["has lodging arranged", "has meal arranged"] if values.get(k) == "false"]
            if omitted and not exempt:
                add("PT", name, "r9_effective_total_cap_ppd", "未安排食宿的分项额度从原综合限额中扣除，形成调整后的限额政策", facts(omitted))
        elif rule == 10:
            transform("training exceeds 30 days", "rule10_2_duration_adjustment", "超过30天的培训将超出天数定额调整为原定额的70%")
        elif rule == 19:
            transform("is major diplomatic event for head state", "r19_7_companion_ok", "重大外交活动以礼宾要求替代常规陪同人数限制")
            for child in nested:
                child_rule = SCHEMAS[child[0].split(" must ")[0]]
                active = ((child_rule == 9 and yes("is conference related visit") and yes("conference has lodging or meal expense")) or
                          (child_rule == 7 and values.get("visit scope") == "R19_Domestic_Visit" and (yes("claims intercity transport") or yes("claims lodging"))))
                if active:
                    source = "r19_rule9_hard_link_ok" if child_rule == 9 else "r19_1c_domestic_trip_link_rule7_ok"
                    add("PC", name, source, f"来访政策与规则{child_rule}的关联政策共同约束本次申请")
                    block(child, name + f"/linked_rule{child_rule}_case")
        elif rule == 20:
            transform("has unwritten off loan", "rule20_5_outstanding_loan_control", "已有未核销借款时审查特殊理由能否形成再次借款的例外政策")

    blocks = case["isabelle_case_conditions_nl"]
    if not blocks:
        raise ValueError(f"No conditions for case {case['id']}")
    for item in blocks:
        block(item["conditions_nl"], item["case_name"])
    # Explicit same-claim invoice + expense compositions in sample3.
    signatures = {SCHEMAS[b["conditions_nl"][0].split(" must ")[0]] for b in blocks}
    if 4 in signatures:
        for other, source in [(6, "combined_evaluate"), (17, "combined_eval_4_17")]:
            if other in signatures:
                add("PC", " + ".join(b["case_name"] for b in blocks), source,
                    f"同一申请同时满足发票政策与规则{other}费用政策")
    labels = [tag for tag in TYPES if any(e["type"] == tag for e in evidence)]
    return {"hol_types": labels, "hol_type_flags": {t: t in labels for t in TYPES},
            "hol_type_annotation": {"version": VERSION, "level": "policy_semantics",
                                    "evidence": evidence}}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    summary = {"version": VERSION, "annotation_level": "policy_semantics", "datasets": {}}
    pending = []
    for stem in ["sample1", "sample2", "sample3"]:
        path = BASE / "data" / f"{stem}.json"
        cases = json.loads(path.read_text())
        assert len({c['id'] for c in cases}) == len(cases)
        annotations = {c["id"]: annotate(c) for c in cases}
        for suffix in [""]:
            target = BASE / "data" / f"{stem}{suffix}.json"
            rows = json.loads(target.read_text())
            assert {r['id'] for r in rows} == set(annotations), target
            for row in rows:
                annotation = annotations[row["id"]]
                assert annotate(row) == annotation, (target, row["id"])
                if args.check:
                    assert all(row.get(k) == v for k, v in annotation.items()), (target, row["id"])
                row.update(annotation)
            pending.append((target, rows))
        counts = Counter(t for a in annotations.values() for t in a["hol_types"])
        combos = Counter("+".join(a["hol_types"]) or "none" for a in annotations.values())
        summary["datasets"][stem] = {"case_count": len(cases), "label_counts": {t: counts[t] for t in TYPES}, "combinations": dict(sorted(combos.items()))}
    summary["total_cases"] = sum(d["case_count"] for d in summary["datasets"].values())
    summary["label_counts"] = {t: sum(d["label_counts"][t] for d in summary["datasets"].values()) for t in TYPES}
    summary_path = BASE / "data" / "hol_type_summary.json"
    if args.check:
        assert json.loads(summary_path.read_text()) == summary
    else:
        # Validate all six inputs before making any writes.
        for target, rows in pending + [(summary_path, summary)]:
            target.write_text(json.dumps(rows, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
