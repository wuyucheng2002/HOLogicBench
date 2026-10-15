"""Annotate current law datasets with HOL policy semantics; --check is read-only."""

import argparse
from collections import Counter
import json
from pathlib import Path
import re

BASE = Path(__file__).resolve().parent.parent
TYPES = ("PR", "PT", "PC", "PS", "PQ")
VERSION = "law-policy-semantics-v1"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def annotate(case, catalog, theory, source_file):
    trace = case["gold_trace"]
    triggered = set(trace["triggered_articles"])
    rules = {r["rule_number"]: r for r in catalog}
    articles = {r["target"] for r in catalog if r["rule_kind"] == "article"}
    require(triggered <= articles, f"Unknown article: {case['case_id']}")
    evidence = []
    active_numbers = []
    defeated = set()
    for kind, trace_key, relation in [
        ("conflict_stronger", "stronger_conflicts", "stronger_than"),
        ("conflict_exception", "exception_conflicts", "exception_to"),
    ]:
        expected = []
        for rule in catalog:
            if rule["rule_kind"] != kind:
                continue
            higher, lower = rule["target"]
            require(re.search(rf'{relation}\s+{re.escape(higher)}\s+{re.escape(lower)}\s*=\s*True', theory),
                    f"Catalog relation absent from {source_file}: {rule}")
            if higher in triggered and lower in triggered:
                expected.append([higher, lower])
                active_numbers.append(rule["rule_number"])
                defeated.add(lower)
                shared = dict(case_name=case["case_id"], source_file=source_file,
                              rule_numbers=[rule["rule_number"]], articles=[higher, lower],
                              conditions=[f"article_triggered {higher} actor", f"article_triggered {lower} actor"])
                evidence.append(dict(type="PR", source_definition=relation,
                                     reason="两个已触发条款之间存在优先或例外覆盖关系", **shared))
                if kind == "conflict_exception":
                    evidence.append(dict(type="PT", source_definition="applicable",
                                         reason="例外条款通过 defeated/applicable 收紧基础条款的有效适用范围；本案排除该基础条款",
                                         **shared))
        require({tuple(p) for p in expected} == {tuple(p) for p in trace[trace_key]},
                f"Conflict trace mismatch: {case['case_id']} {trace_key}")
    require(set(active_numbers) == set(trace["conflict_rule_numbers"]), f"Conflict rule mismatch: {case['case_id']}")
    require(len(active_numbers) == trace["conflict_count"], f"Conflict count mismatch: {case['case_id']}")
    require(defeated == set(trace["defeated_articles"]), f"Defeat mismatch: {case['case_id']}")
    require(triggered - defeated == set(trace["applicable_articles"]), f"Applicability mismatch: {case['case_id']}")

    # The source explicitly quantifies over the reified article policy domain.
    for name, variable in [("defeated", "higher"), ("final_no_liability", "art"), ("final_legal_result_holds", "art")]:
        pattern = rf'definition {name}\b.*?(?=\ndefinition |\nend)'
        match = re.search(pattern, theory, flags=re.S)
        require(match is not None and f"\\<exists>{variable}." in match.group(), f"Missing policy quantifier: {source_file} {name}")
    conclusion = "final_no_liability" if trace["final_no_liability"] else "final_legal_result_holds"
    require(conclusion in case["isabelle"]["theory_code"], f"Missing conclusion proof: {case['case_id']}")
    require(set(trace["conclusion_rule_numbers"]) <= set(rules), f"Unknown conclusion rule: {case['case_id']}")
    evidence.append(dict(type="PQ", case_name=case["case_id"], source_file=source_file,
                         source_definition=conclusion,
                         reason="在有限条款政策域上作存在量化，检查是否有适用的免责或结论条款；责任结论同时排除所有适用免责条款",
                         rule_numbers=trace["conclusion_rule_numbers"],
                         articles=trace["applicable_articles"],
                         conditions=[f"final_no_liability = {trace['final_no_liability']}", f"final_result = {trace['final_result']}"]))
    labels = [t for t in TYPES if any(e["type"] == t for e in evidence)]
    return dict(hol_types=labels, hol_type_flags={t: t in labels for t in TYPES},
                hol_type_annotation=dict(version=VERSION, level="policy_semantics", evidence=evidence))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    paths = sorted((BASE / "data").glob("*/dataset.json"))
    require(bool(paths), "No law datasets found")
    summary = dict(version=VERSION, annotation_level="policy_semantics", datasets={})
    pending = []
    seen = set()
    for path in paths:
        data = json.loads(path.read_text())
        bundle = data["bundle_name"]
        require(bundle == path.parent.name, f"Bundle path mismatch: {path}")
        source_file = f"Isabelle_code/{bundle}/Conflict.thy"
        theory = (BASE / source_file).read_text()
        catalog = data["scoring_target"]["main"]["rule_catalog"]
        cases = data["cases"]
        require(len(cases) == data["case_count"], f"Case count mismatch: {path}")
        for case in cases:
            key = (bundle, case["case_id"])
            require(key not in seen, f"Duplicate case: {key}")
            seen.add(key)
            require(case["bundle_name"] == bundle, f"Case bundle mismatch: {key}")
            annotation = annotate(case, catalog, theory, source_file)
            if args.check:
                require(all(case.get(k) == v for k, v in annotation.items()), f"Annotation mismatch: {key}")
            case.update(annotation)
        counts = Counter(t for case in cases for t in case["hol_types"])
        combinations = Counter("+".join(case["hol_types"]) or "none" for case in cases)
        summary["datasets"][bundle] = dict(case_count=len(cases), label_counts={t: counts[t] for t in TYPES}, combinations=dict(sorted(combinations.items())))
        pending.append((path, data))
    summary["total_cases"] = len(seen)
    summary["label_counts"] = {t: sum(d["label_counts"][t] for d in summary["datasets"].values()) for t in TYPES}
    summary_path = BASE / "data/hol_type_summary.json"
    if args.check:
        require(json.loads(summary_path.read_text()) == summary, "Summary mismatch")
    else:
        # Complete validation of every bundle before writing any dataset.
        for path, data in pending + [(summary_path, summary)]:
            path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
