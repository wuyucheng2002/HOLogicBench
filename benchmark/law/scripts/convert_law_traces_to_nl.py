#!/usr/bin/env python3
"""
Convert law/Isabelle_code trace results to English natural language.

Reads:  data/law_trace_results.json
        law/Isabelle_code/<bundle>/bundle_meta.json  (per-bundle NL descriptions)
Writes: data/law_nl_traces.json

Each output entry contains:
  - bundle, case_id, difficulty_level, case_type, target_articles
  - reasoning_steps  : total number of NL reasoning steps generated
  - natural_language_trace : step-by-step English description
  - final_result     : human-readable final legal outcome
  - is_no_liability  : bool

Run:
    python3 convert_law_traces_to_nl.py
"""
import json
import re
from pathlib import Path

INPUT_JSON   = Path(__file__).resolve().parent.parent / "data/law_trace_results.json"
OUTPUT_JSON  = Path(__file__).resolve().parent.parent / "data/law_nl_traces.json"
LAW_CODE_DIR = Path(__file__).resolve().parent.parent / "Isabelle_code"

# Placeholder used in bundle_meta positive_text / negative_text
ACTOR_DISPLAY = "the actor"


# ── Bundle metadata cache ─────────────────────────────────────────────────────

_meta_cache: dict = {}

def _load_meta(bundle_name: str) -> dict:
    if bundle_name not in _meta_cache:
        path = LAW_CODE_DIR / bundle_name / "bundle_meta.json"
        with open(path, encoding="utf-8") as f:
            _meta_cache[bundle_name] = json.load(f)
    return _meta_cache[bundle_name]


# ── Snake-case → Title Case helper ────────────────────────────────────────────

def _snake_to_title(s: str) -> str:
    return s.replace("_", " ").title()


# ── Atomic fact → English sentence ────────────────────────────────────────────

def fact_to_nl(predicate: str, holds: bool, bundle_name: str) -> str:
    """
    Use bundle_meta node texts when available.
    Falls back to a programmatic conversion.
    """
    meta  = _load_meta(bundle_name)
    nodes = meta.get("nodes", {})
    node  = nodes.get(predicate)

    if node:
        if holds:
            text = node.get("positive_text", "")
        else:
            text = node.get("negative_text", "")
            positive = node.get("positive_text", "")
            if not text or text == positive:
                # Missing negative templates must never reuse a positive assertion.
                if positive:
                    clause = positive.replace("{name}", ACTOR_DISPLAY).rstrip(". ")
                    text = "It is not the case that " + clause + "."
        if text:
            sentence = text.replace("{name}", ACTOR_DISPLAY.capitalize())
            # Ensure the sentence ends with a period
            return sentence if sentence.endswith(".") else sentence + "."

    # Fallback: programmatic
    readable = _snake_to_title(predicate)
    if holds:
        return f"{readable} holds."
    else:
        return f"{readable} does not hold."


# ── Derived condition → English phrase ────────────────────────────────────────

def condition_to_nl(condition_name: str) -> str:
    """Convert an Isabelle derived condition identifier to a readable English phrase."""
    return _snake_to_title(condition_name)


# ── Article identifier → English title ────────────────────────────────────────

def article_to_title(article: str, bundle_name: str) -> str:
    """Return the article's human-readable title from bundle_meta, or convert name."""
    meta     = _load_meta(bundle_name)
    articles = meta.get("articles", {})
    entry    = articles.get(article)
    if entry and "title" in entry:
        return entry["title"]
    # Fallback: strip "Art_" prefix and title-case
    return _snake_to_title(article.removeprefix("Art_"))


def article_to_rule_text(article: str, bundle_name: str) -> str:
    """Return the article's rule_text from bundle_meta, or empty string."""
    meta  = _load_meta(bundle_name)
    entry = meta.get("articles", {}).get(article, {})
    return entry.get("rule_text", "")


# ── Legal result → English ────────────────────────────────────────────────────

def result_to_nl(result: str) -> str:
    """Convert a legal_result Isabelle constructor to English."""
    if result == "No_Criminal_Liability":
        return "No Criminal Liability"
    return _snake_to_title(result)


# ── Rule map builder ──────────────────────────────────────────────────────────

def _body_predicates(rule: dict) -> list[tuple[str, bool]]:
    """Extract (predicate, required_value) pairs from a rule body."""
    body = rule.get("body", {})
    items: list[tuple[str, bool]] = []
    for it in body.get("all_of", []):
        items.append((it["predicate"], it["value"]))
    for grp in body.get("any_of_groups", []):
        for it in grp:
            items.append((it["predicate"], it["value"]))
    return items


def _build_rule_maps(bundle_name: str) -> tuple[dict, dict, dict, dict]:
    """
    Returns four look-up dicts built from bundle_meta rules[]:
      cond_to_rnum   : {condition_predicate: rule_number}   (head predicate)
      art_to_rnum    : {article_name: rule_number}          (article_triggered heads)
      atom_to_rnum   : {atom_predicate: first rule_number that uses it in body}
      cond_neg_atoms : {condition_predicate: [neg_atom, ...]}  atoms required False
    """
    meta  = _load_meta(bundle_name)
    rules = meta.get("rules", [])

    cond_to_rnum:   dict = {}
    art_to_rnum:    dict = {}
    atom_to_rnum:   dict = {}
    cond_neg_atoms: dict = {}

    for i, rule in enumerate(rules):
        rnum = i + 1
        head = rule.get("head", {})
        pred = head.get("predicate", "")
        art  = head.get("article", "")

        if pred == "article_triggered" and art:
            art_to_rnum[art] = rnum
        elif pred:
            cond_to_rnum[pred] = rnum
            # collect neg atoms for this condition
            negs = [p for p, v in _body_predicates(rule) if not v]
            if negs:
                cond_neg_atoms[pred] = negs

        for atom, _ in _body_predicates(rule):
            atom_to_rnum.setdefault(atom, rnum)   # first rule wins

    return cond_to_rnum, art_to_rnum, atom_to_rnum, cond_neg_atoms


# ── NL trace generator ────────────────────────────────────────────────────────

def generate_nl_trace(case: dict) -> tuple[str, int]:
    """
    Build a flowing narrative reasoning trace with [Rule N] citations.
    Returns (nl_text, step_count).
    """
    bundle = case["bundle"]
    meta   = _load_meta(bundle)

    cond_to_rnum, art_to_rnum, atom_to_rnum, cond_neg_atoms = _build_rule_maps(bundle)

    # Sets for fast look-up
    true_atoms      = {af["predicate"] for af in case.get("atomic_facts", []) if af["holds"]}
    established     = {dc["name"] for dc in case.get("derived_conditions", []) if dc["holds"]}

    # Negative atoms that appear as required-False in bodies of True conditions
    relevant_neg_atoms: set = set()
    for dc in case.get("derived_conditions", []):
        if dc["holds"]:
            for neg in cond_neg_atoms.get(dc["name"], []):
                relevant_neg_atoms.add(neg)

    lines: list[str] = []
    step = 0

    lines.append("Reasoning:")
    lines.append("")

    # ── 1. Atomic facts ───────────────────────────────────────────────────────
    # Positive facts first (in case-file order), then relevant negatives
    for af in case.get("atomic_facts", []):
        pred = af["predicate"]
        if af["holds"]:
            sentence = fact_to_nl(pred, True, bundle)
            rnum     = atom_to_rnum.get(pred, "?")
            lines.append(f"{sentence} [Rule {rnum}]")
            step += 1

    for af in case.get("atomic_facts", []):
        pred = af["predicate"]
        if not af["holds"] and pred in relevant_neg_atoms:
            sentence = fact_to_nl(pred, False, bundle)
            rnum     = atom_to_rnum.get(pred, "?")
            lines.append(f"{sentence} [Rule {rnum}]")
            step += 1

    lines.append("")

    # ── 2. Derived conditions ─────────────────────────────────────────────────
    rules_list = meta.get("rules", [])
    cond_rule_map = {r["head"].get("predicate", ""): r
                     for r in rules_list
                     if r["head"].get("predicate", "") != "article_triggered"}

    for dc in case.get("derived_conditions", []):
        pred  = dc["name"]
        rnum  = cond_to_rnum.get(pred, "?")
        rule  = cond_rule_map.get(pred, {})
        nat   = rule.get("natural_text", "")

        if dc["holds"]:
            if nat:
                nat_lc = nat[0].lower() + nat[1:]
                lines.append(f"Therefore, {nat_lc} [Rule {rnum}]")
            else:
                lines.append(f"Therefore, {_snake_to_title(pred)} is established [Rule {rnum}].")
        else:
            lines.append(f"Since the required conditions were not met, "
                         f"{_snake_to_title(pred)} is not established [Rule {rnum}].")
        step += 1

    lines.append("")

    # ── 3. Article triggers ───────────────────────────────────────────────────
    for at in case.get("article_triggers", []):
        art   = at["article"]
        rnum  = art_to_rnum.get(art, "?")
        title = article_to_title(art, bundle)

        # Find the source condition from the trigger rule body
        trigger_rule = next(
            (r for r in rules_list
             if r["head"].get("predicate") == "article_triggered"
             and r["head"].get("article") == art),
            None,
        )
        src_cond = trigger_rule["body"]["all_of"][0]["predicate"] if trigger_rule else ""

        if at["triggered"]:
            lines.append(f"Consequently, {title} is triggered [Rule {rnum}].")
        else:
            if src_cond and src_cond not in established:
                src_nl = _snake_to_title(src_cond)
                lines.append(f"Since {src_nl} is not established, "
                             f"{title} is not triggered [Rule {rnum}].")
            else:
                lines.append(f"{title} is not triggered [Rule {rnum}].")
        step += 1

    lines.append("")

    # ── 4. Conflict resolution ────────────────────────────────────────────────
    for ov in case.get("override_relations", []):
        higher = article_to_title(ov["higher"], bundle)
        lower  = article_to_title(ov["lower"], bundle)
        lines.append(f"However, {higher} takes priority over {lower}.")
        step += 1

    # ── 5. Defeat status ──────────────────────────────────────────────────────
    for ad in case.get("article_defeat", []):
        title = article_to_title(ad["article"], bundle)
        if ad["defeated"]:
            lines.append(f"Therefore, {title} is defeated by a higher-priority article.")
        else:
            lines.append(f"{title} is not defeated.")
        step += 1

    lines.append("")

    # ── 6. Applicability ──────────────────────────────────────────────────────
    for ap in case.get("article_applicability", []):
        title     = article_to_title(ap["article"], bundle)
        rule_text = article_to_rule_text(ap["article"], bundle) if ap["applicable"] else ""
        if ap["applicable"]:
            suffix = f" {rule_text}" if rule_text else ""
            lines.append(f"{title} is applicable.{suffix}")
        else:
            lines.append(f"{title} is not applicable.")
        step += 1

    lines.append("")

    # ── Conclusion ────────────────────────────────────────────────────────────
    final           = case.get("final_result", "NOT_PARSED")
    is_no_liability = case.get("is_no_liability", False)
    final_nl        = result_to_nl(final)

    if is_no_liability:
        lines.append(f"Answer: {final_nl}")
    else:
        lines.append(f"Answer: {final_nl}")
    step += 1

    return "\n".join(lines), step


# ── Aggregate statistics ───────────────────────────────────────────────────────

def _bundle_stats(converted: list[dict]) -> dict:
    bundles: dict = {}
    for c in converted:
        b = c["bundle"]
        if b not in bundles:
            bundles[b] = {"total": 0, "no_liability": 0}
        bundles[b]["total"] += 1
        if c["is_no_liability"]:
            bundles[b]["no_liability"] += 1
    return bundles


# ── Main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    print(f"Reading {INPUT_JSON} …")
    with open(INPUT_JSON, encoding="utf-8") as f:
        data = json.load(f)

    total = len(data["trace"])
    print(f"Converting {total} traces …")

    converted: list[dict] = []
    for case in data["trace"]:
        nl_trace, step_count = generate_nl_trace(case)

        converted.append({
            "bundle":               case["bundle"],
            "case_id":              case["case_id"],
            "difficulty_level":     case["difficulty_level"],
            "case_type":            case["case_type"],
            "target_articles":      case.get("target_articles", []),
            "reasoning_steps":      step_count,
            "natural_language_trace": nl_trace,
            "final_result":         result_to_nl(case.get("final_result", "")),
            "is_no_liability":      case.get("is_no_liability", False),
        })

    # Summary statistics
    total_steps    = sum(c["reasoning_steps"] for c in converted)
    avg_steps      = total_steps / len(converted) if converted else 0
    no_liab_count  = sum(1 for c in converted if c["is_no_liability"])
    bundle_stats   = _bundle_stats(converted)

    difficulty_dist: dict = {}
    for c in converted:
        d = c["difficulty_level"]
        difficulty_dist[d] = difficulty_dist.get(d, 0) + 1

    output = {
        "total_cases": len(converted),
        "summary": {
            "avg_reasoning_steps":  round(avg_steps, 2),
            "no_liability_cases":   no_liab_count,
            "liability_cases":      len(converted) - no_liab_count,
            "difficulty_distribution": difficulty_dist,
            "bundle_stats":         bundle_stats,
        },
        "traces": converted,
    }

    with open(OUTPUT_JSON, "w", encoding="utf-8") as f:
        json.dump(output, f, indent=2, ensure_ascii=False)

    print(f"\nSaved → {OUTPUT_JSON}")
    print(f"  Total cases        : {len(converted)}")
    print(f"  Avg reasoning steps: {avg_steps:.2f}")
    print(f"  No-liability cases : {no_liab_count}/{len(converted)}")
    print(f"  Difficulty dist    : {difficulty_dist}")

    print("\n─── Sample (first 2 traces) ───")
    for c in converted[:2]:
        print(f"\n{'─'*60}")
        for line in c["natural_language_trace"].splitlines():
            print(f"  {line}")


if __name__ == "__main__":
    main()
