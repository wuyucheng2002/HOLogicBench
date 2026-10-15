"""Render the recorded Finance reasoning_trace without changing its contents."""

def steps_to_text(steps: list) -> str:
    """Convert a reasoning_trace list of step-dicts to NL text.

    Each step:  {"step": N, "description": "Check — ...", "result": "PASS"}
    →  "Step N: Check — .... Result: PASS."
    """
    lines = []
    for s in steps:
        if not isinstance(s, dict):
            continue
        step_num = s.get("step", "?")
        desc     = s.get("description", "").rstrip(".")
        result   = s.get("result", "")
        lines.append(f"Step {step_num}: {desc}. Result: {result}.")
    return "\n".join(lines)

def extract_reasoning_trace(model_output: dict) -> str:
    """Convert reasoning_trace from model output to NL text.

    Handles three output shapes:
      • Direct top-level  reasoning_trace               (single-rule templates)
      • fee_items[*].reasoning_trace                    (PROMPT_TEMPLATE_1 / sample1)
      • review_objects[*].reasoning_trace               (PROMPT_TEMPLATE_2 / sample2)
    """
    if not isinstance(model_output, dict):
        return ""

    # ── Single-level ──────────────────────────────────────────────────────────
    if "reasoning_trace" in model_output:
        return steps_to_text(model_output["reasoning_trace"])

    # ── fee_items (sample1) ───────────────────────────────────────────────────
    if "fee_items" in model_output:
        items = model_output["fee_items"]
        if not items:
            return ""
        if len(items) == 1:
            return steps_to_text(items[0].get("reasoning_trace", []))
        blocks = []
        for item in items:
            idx  = item.get("fee_item_index", "")
            name = item.get("fee_item_name", f"Item {idx}")
            text = steps_to_text(item.get("reasoning_trace", []))
            if text:
                blocks.append(f"[Item {idx}: {name}]\n{text}")
        return "\n\n".join(blocks)

    # ── review_objects (sample2) ──────────────────────────────────────────────
    if "review_objects" in model_output:
        objects = model_output["review_objects"]
        if not objects:
            return ""
        if len(objects) == 1:
            return steps_to_text(objects[0].get("reasoning_trace", []))
        blocks = []
        for obj in objects:
            idx  = obj.get("object_index", "")
            name = obj.get("object_name", f"Object {idx}")
            text = steps_to_text(obj.get("reasoning_trace", []))
            if text:
                blocks.append(f"[Object {idx}: {name}]\n{text}")
        return "\n\n".join(blocks)

    return ""
