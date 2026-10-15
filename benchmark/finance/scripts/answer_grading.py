"""Finance answer grading shared with the original experiment's table builder."""
from typing import Any, Dict, List, Optional, Tuple
import count


def get_nested_value(obj, path):
    return count.get_nested_value(obj, path)


SAMPLE3_EVAL_TASKS: Dict[str, Tuple[str, List[Tuple[int, int]]]] = {
    "material":   ("sample3_3_results.jsonl",      [(1, 40)]),
    "invoice":    ("sample3_4_results.jsonl",      [(41, 60)]),
    "approval6":  ("sample3_6_results.jsonl",      [(61, 100)]),
    "approval4_6": ("sample3_6_results.jsonl",     [(101, 140)]),
    "approval7":  ("sample3_7_results.jsonl",      [(141, 182)]),
    "approval8":  ("sample3_8_results.jsonl",      [(223, 252)]),
    "approval9":  ("sample3_9_results.jsonl",      [(253, 312)]),
    "approval10": ("sample3_10_results.jsonl",     [(353, 382)]),
    "approval11": ("sample3_11_results.jsonl",     [(423, 452)]),
    "approval13": ("sample3_13_results.jsonl",     [(453, 482)]),
    "approval14": ("sample3_14_results.jsonl",     [(523, 552)]),
    "approval15": ("sample3_15_results.jsonl",     [(553, 572)]),
    "approval16": ("sample3_16_results.jsonl",     [(573, 592)]),
    "approval17": ("sample3_17_results.jsonl",     [(593, 613)]),
    "approval18": ("sample3_18_results.jsonl",     [(614, 643)]),
    "approval19": ("sample3_19_results.jsonl",     [(644, 679)]),
    "approval20": ("sample3_20_results.jsonl",     [(680, 719)]),
    "amount":     ("sample3_amount_results.jsonl", [(183, 222), (383, 422), (483, 522)]),
}

# ── sample1/sample2: per-case LIST gold labels ────────────────────────────────
# (case_start, case_end, task_config_key, items_path)
SAMPLE1_SUBTASKS: List[Tuple[int, int, str, List[str]]] = [
    (1,   50,  "sample1top50",      ["model_output", "fee_items"]),
    (51,  100, "sample1_51_100",    ["model_output", "fee_items"]),
    (101, 150, "sample1_101_150",   ["model_output", "fee_items"]),
    (151, 200, "sample1_151_200",   ["model_output", "fee_items"]),
]
SAMPLE2_SUBTASKS: List[Tuple[int, int, str, List[str]]] = [
    (1,   50,  "sample2_1_50",      ["model_output", "review_objects"]),
    (51,  100, "sample2_51_100",    ["model_output", "review_objects"]),
    (101, 150, "sample2_101_150",   ["model_output", "review_objects"]),
    (151, 200, "sample2_151_200",   ["model_output", "review_objects"]),
]


def build_gold_mapping_s3(task_name: str, case_ids: List[int]) -> Dict[int, Any]:
    config = count.TASK_CONFIGS[task_name]
    key = "gold_values" if task_name == "amount" else "gold_labels"
    gold = config[key]
    if len(gold) != len(case_ids):
        raise ValueError(f"{task_name}: gold={len(gold)} case={len(case_ids)}")
    return dict(zip(case_ids, gold))


def extract_s3_pred(record: Dict, task_name: str) -> Optional[Any]:
    if record.get("status") != "ok":
        return None
    config = count.TASK_CONFIGS[task_name]
    raw = get_nested_value(record, config["json_path"])
    if task_name == "amount":
        if raw is None:
            return None
        try:
            return float(raw) if "." in str(raw) else int(raw)
        except (TypeError, ValueError):
            return None
    if not isinstance(raw, str):
        return None
    return config["pred_map"].get(raw, f"ERROR({raw})")


# ── sample1/sample2 helpers ───────────────────────────────────────────────────

def build_gold_mapping_grouped(
    subtasks: List[Tuple[int, int, str, List[str]]]
) -> Dict[int, List[str]]:
    """case_id -> gold list (as stored in gold_pairs)"""
    mapping: Dict[int, List[str]] = {}
    for start, end, config_key, _ in subtasks:
        config = count.TASK_CONFIGS[config_key]
        gold_pairs = config["gold_pairs"]
        case_ids = list(range(start, end + 1))
        if len(gold_pairs) != len(case_ids):
            raise ValueError(
                f"{config_key}: gold_pairs={len(gold_pairs)} != cases={len(case_ids)}"
            )
        for case_id, gold_list in zip(case_ids, gold_pairs):
            mapping[case_id] = gold_list
    return mapping


def extract_grouped_pred(
    record: Dict,
    items_path: List[str],
    pred_map: Dict[str, str],
) -> Optional[List[str]]:
    """Extract list of mapped predictions from fee_items / review_objects.

    Matching is case-insensitive: sample1 outputs 'Fully Reimbursable'
    while the pred_map key is 'Fully reimbursable'.
    """
    if record.get("status") != "ok":
        return None
    items = get_nested_value(record, items_path)
    if not isinstance(items, list) or len(items) == 0:
        return None
    # Build a lowercase-keyed version once for fast lookup
    pred_map_lower = {k.lower(): v for k, v in pred_map.items()}
    result: List[str] = []
    for item in items:
        if not isinstance(item, dict):
            continue
        raw = item.get("audit_result")
        if isinstance(raw, str):
            mapped = pred_map_lower.get(raw.lower(), f"ERROR({raw})")
            result.append(mapped)
    return result if result else None


def get_pred_map_for(subtasks: List[Tuple[int, int, str, List[str]]], case_id: int) -> Dict[str, str]:
    for start, end, config_key, _ in subtasks:
        if start <= case_id <= end:
            return count.TASK_CONFIGS[config_key]["pred_map"]
    return {}


def get_items_path_for(subtasks: List[Tuple[int, int, str, List[str]]], case_id: int) -> List[str]:
    for start, end, _, items_path in subtasks:
        if start <= case_id <= end:
            return items_path
    return []


# ── table builder ─────────────────────────────────────────────────────────────

