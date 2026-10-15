#!/usr/bin/env python3
"""
Export reasoning traces from law/Isabelle_code bundles to JSON.

Unlike run_isabelle_trace.py (which uses Isabelle value statements for
functional code), this script statically parses proof-based case theories.

Each *_case_*.thy file encodes a reasoning trace as:
  1. axiomatization facts  — atomic predicate values for the actor
  2. derive_* lemmas       — derived mid-level conditions
  3. trigger_art_* / not_trigger_art_* lemmas — which articles fire
  4. overrides_* lemmas    — conflict priority relations
  5. defeated_* / not_defeated_* lemmas
  6. applicable_* / not_applicable_* lemmas
  7. final theorem         — final_legal_result_holds or final_no_liability

Output: data/law_trace_results.json

Run:
    python3 run_law_trace.py
"""
import json
import re
from pathlib import Path

# ── Paths ────────────────────────────────────────────────────────────────────
LAW_CODE_DIR = Path(__file__).resolve().parent.parent / "Isabelle_code"
OUTPUT_JSON  = Path(__file__).resolve().parent.parent / "data/law_trace_results.json"
OUTPUT_TXT   = Path(__file__).resolve().parent.parent / "data/law_trace_results.txt"

# Regex: single-line lemma/theorem statement
_LEMMA_RE   = re.compile(r'^(?:lemma|theorem)\s+(\w+)\s*:\s*"([^"]+)"', re.MULTILINE)
# Regex: facts inside axiomatization block (fN or named)
_FACT_RE    = re.compile(r'(?:^|\band\b)\s*(\w+)\s*:\s*"([^"]*)"', re.MULTILINE)
# Regex: axiomatization block (everything up to first lemma or end)
_AXM_RE     = re.compile(r'axiomatization\s+where\s+(.*?)(?=\nlemma\b|\nend\b)', re.DOTALL)
# Negation prefix in Isabelle
_NEG        = r'\<not>'


# ── Parse General.thy for article → result mapping ───────────────────────────

def parse_general(general_path: Path) -> dict:
    """
    Returns {article_name: legal_result_str, ...} from article_result fun.
    Also returns list of article names in declaration order.
    """
    with open(general_path, encoding="utf-8") as f:
        content = f.read()

    # datatype article = Art_A | Art_B | ...
    art_match = re.search(r'datatype\s+article\s*=\s*(.*?)(?=\n\n|\ndatatype|\nfun)', content, re.DOTALL)
    article_order = re.findall(r'\bArt_\w+\b', art_match.group(1)) if art_match else []

    # fun article_result :: "article => legal_result" where ...
    result_map: dict = {}
    for m in re.finditer(r'"article_result\s+(Art_\w+)\s*=\s*(\w+)"', content):
        result_map[m.group(1)] = m.group(2)

    return {"articles": article_order, "result_map": result_map}


# ── Parse a single case .thy file ─────────────────────────────────────────────

def _strip_actor(text: str, actor: str) -> str:
    """Remove trailing ' actor_name' from a predicate application."""
    suffix = f" {actor}"
    return text[:-len(suffix)].rstrip() if text.endswith(suffix) else text


def _parse_conclusion(text: str, actor: str) -> tuple[bool, str]:
    """
    Return (holds, clean_text) where holds=False if text starts with \\<not>.
    clean_text has the negation prefix and trailing actor removed.
    """
    text = text.strip()
    holds = True
    if text.startswith(_NEG):
        holds = False
        text = text[len(_NEG):].strip()
    # Remove trailing actor reference
    text = _strip_actor(text, actor)
    return holds, text


def parse_case_file(thy_path: Path, actor: str) -> dict:
    """
    Parse one case .thy file.  Returns a dict with keys:
        atomic_facts, derived_conditions, article_triggers,
        override_relations, article_defeat, article_applicability,
        final_result, is_no_liability
    """
    with open(thy_path, encoding="utf-8") as f:
        content = f.read()

    # ── 1. Atomic facts ───────────────────────────────────────────────────────
    atomic_facts: list[dict] = []
    axm_match = _AXM_RE.search(content)
    if axm_match:
        axm_block = axm_match.group(1)
        for m in _FACT_RE.finditer(axm_block):
            fact_id   = m.group(1)
            raw       = m.group(2).strip()
            holds, predicate = _parse_conclusion(raw, actor)
            atomic_facts.append({"id": fact_id, "predicate": predicate, "holds": holds})

    # ── 2–6. Lemmas ───────────────────────────────────────────────────────────
    derived_conditions:    list[dict] = []
    article_triggers:      list[dict] = []
    override_relations:    list[dict] = []
    article_defeat:        list[dict] = []
    article_applicability: list[dict] = []
    final_result    = "NOT_PARSED"
    is_no_liability = False

    for m in _LEMMA_RE.finditer(content):
        lemma_name = m.group(1)
        conclusion = m.group(2).strip()

        # ── Final theorem ─────────────────────────────────────────────────────
        if lemma_name.startswith("final_result"):
            if "final_no_liability" in conclusion:
                final_result    = "No_Criminal_Liability"
                is_no_liability = True
            else:
                # "final_legal_result_holds actor RESULT"
                rm = re.search(r'final_legal_result_holds\s+\S+\s+(\w+)', conclusion)
                if rm:
                    final_result    = rm.group(1)
                    is_no_liability = False
            continue

        # ── Classify by conclusion content ───────────────────────────────────
        holds, clean = _parse_conclusion(conclusion, actor)

        if "article_triggered" in clean:
            # "article_triggered Art_X actor" → article=Art_X
            am = re.search(r'article_triggered\s+(Art_\w+)', clean)
            if am:
                article_triggers.append({"article": am.group(1), "triggered": holds})

        elif clean.startswith("overrides "):
            # "overrides Art_Higher Art_Lower"
            om = re.match(r'overrides\s+(Art_\w+)\s+(Art_\w+)', clean)
            if om:
                override_relations.append({"higher": om.group(1), "lower": om.group(2)})

        elif "defeated " in clean and "actor" in conclusion:
            # "defeated actor Art_X"
            dm = re.search(r'defeated\s+\S+\s+(Art_\w+)', clean)
            if dm:
                article_defeat.append({"article": dm.group(1), "defeated": holds})

        elif "applicable " in clean and "actor" in conclusion:
            # "applicable actor Art_X"
            apm = re.search(r'applicable\s+\S+\s+(Art_\w+)', clean)
            if apm:
                article_applicability.append({"article": apm.group(1), "applicable": holds})

        elif lemma_name.startswith("derive_") or lemma_name.startswith("not_derive_"):
            # Derived mid-level condition
            derived_conditions.append({"name": clean, "holds": holds})

    return {
        "atomic_facts":          atomic_facts,
        "derived_conditions":    derived_conditions,
        "article_triggers":      article_triggers,
        "override_relations":    override_relations,
        "article_defeat":        article_defeat,
        "article_applicability": article_applicability,
        "final_result":          final_result,
        "is_no_liability":       is_no_liability,
    }


# ── Parse one bundle directory ────────────────────────────────────────────────

def parse_bundle(bundle_dir: Path) -> list[dict]:
    """
    Process all *_case_*.thy files in the bundle.
    Returns a list of case trace dicts.
    """
    bundle_name = bundle_dir.name

    # Read per-bundle metadata
    meta_path = bundle_dir / "bundle_meta.json"
    actor = "actor"
    if meta_path.exists():
        with open(meta_path, encoding="utf-8") as f:
            meta = json.load(f)
        actor = meta.get("person_symbol", "actor")

    # Read article → result mapping
    general_path = bundle_dir / "General.thy"
    general_info = parse_general(general_path) if general_path.exists() else {}
    result_map   = general_info.get("result_map", {})

    # Read per-case metadata (difficulty, type, target_articles)
    plans_map: dict = {}
    plans_path = bundle_dir / "case_plans.json"
    if plans_path.exists():
        with open(plans_path, encoding="utf-8") as f:
            plans = json.load(f)
        for p in plans:
            plans_map[p["case_id"]] = p

    # Find and sort case files (exclude case_demo.thy and framework files)
    case_files = sorted(
        f for f in bundle_dir.glob("*.thy")
        if re.search(r'_case_\d+', f.stem) and f.stem != "case_demo"
    )

    traces: list[dict] = []
    for thy_path in case_files:
        case_id = thy_path.stem
        parsed  = parse_case_file(thy_path, actor)

        plan = plans_map.get(case_id, {})
        entry: dict = {
            "bundle":           bundle_name,
            "case_id":          case_id,
            "difficulty_level": plan.get("difficulty_level", ""),
            "case_type":        plan.get("case_type", ""),
            "target_articles":  plan.get("target_articles", []),
        }
        entry.update(parsed)
        traces.append(entry)

    return traces


# ── Save ─────────────────────────────────────────────────────────────────────

def save(all_traces: list[dict]) -> None:
    resolved = sum(1 for t in all_traces if t["final_result"] != "NOT_PARSED")

    with open(OUTPUT_JSON, "w", encoding="utf-8") as f:
        json.dump(
            {
                "total_cases": len(all_traces),
                "resolved":    resolved,
                "trace":       all_traces,
            },
            f, indent=2, ensure_ascii=False,
        )

    # Human-readable summary
    with open(OUTPUT_TXT, "w", encoding="utf-8") as f:
        f.write(f"Law reasoning trace — {resolved}/{len(all_traces)} cases parsed\n")
        f.write("=" * 80 + "\n\n")
        for t in all_traces:
            f.write(f"[{t['case_id']} : {t['bundle']}]\n")
            f.write(f"  Difficulty : {t['difficulty_level']}   Type: {t['case_type']}\n")

            f.write("  Atomic facts:\n")
            for af in t["atomic_facts"]:
                tick = "✓" if af["holds"] else "✗"
                f.write(f"    {tick} {af['id']:4s} {af['predicate']}\n")

            if t["derived_conditions"]:
                f.write("  Derived conditions:\n")
                for dc in t["derived_conditions"]:
                    tick = "✓" if dc["holds"] else "✗"
                    f.write(f"    {tick} {dc['name']}\n")

            if t["article_triggers"]:
                f.write("  Article triggers:\n")
                for at in t["article_triggers"]:
                    tick = "✓" if at["triggered"] else "✗"
                    f.write(f"    {tick} {at['article']}\n")

            if t["override_relations"]:
                f.write("  Overrides:\n")
                for ov in t["override_relations"]:
                    f.write(f"    {ov['higher']}  >  {ov['lower']}\n")

            if t["article_defeat"]:
                f.write("  Defeat status:\n")
                for ad in t["article_defeat"]:
                    tick = "✓" if ad["defeated"] else "✗"
                    f.write(f"    {tick} defeated  {ad['article']}\n")

            if t["article_applicability"]:
                f.write("  Applicability:\n")
                for ap in t["article_applicability"]:
                    tick = "✓" if ap["applicable"] else "✗"
                    f.write(f"    {tick} applicable {ap['article']}\n")

            f.write(f"  → RESULT: {t['final_result']}\n\n")

    print(f"\nSaved {resolved}/{len(all_traces)} cases →")
    print(f"  {OUTPUT_JSON}")
    print(f"  {OUTPUT_TXT}")


# ── Main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    if not LAW_CODE_DIR.exists():
        raise SystemExit(f"Directory not found: {LAW_CODE_DIR}")

    OUTPUT_JSON.parent.mkdir(parents=True, exist_ok=True)

    all_traces: list[dict] = []

    bundle_dirs = sorted(d for d in LAW_CODE_DIR.iterdir() if d.is_dir())
    print(f"Found {len(bundle_dirs)} bundles in {LAW_CODE_DIR.name}/\n")

    for bundle_dir in bundle_dirs:
        traces = parse_bundle(bundle_dir)
        all_traces.extend(traces)
        resolved = sum(1 for t in traces if t["final_result"] != "NOT_PARSED")
        print(f"  {bundle_dir.name:50s}  {resolved:3d}/{len(traces):3d} resolved")

    print(f"\nTotal: {len(all_traces)} cases across {len(bundle_dirs)} bundles")

    save(all_traces)

    # Sample output
    print("\n─── Sample (first 3 cases) ───")
    for t in all_traces[:3]:
        print(f"\n  [{t['case_id']} | {t['bundle']}]")
        print(f"    Difficulty: {t['difficulty_level']}  Type: {t['case_type']}")
        for af in t["atomic_facts"][:4]:
            tick = "✓" if af["holds"] else "✗"
            print(f"    {tick} {af['id']:4s} {af['predicate']}")
        if len(t["atomic_facts"]) > 4:
            print(f"    ... ({len(t['atomic_facts'])} facts total)")
        for at in t["article_triggers"]:
            tick = "✓" if at["triggered"] else "✗"
            print(f"    trigger  {tick}  {at['article']}")
        print(f"    → {t['final_result']}")


if __name__ == "__main__":
    main()
