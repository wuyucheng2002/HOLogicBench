#!/usr/bin/env python3
"""
Generate and evaluate sub-rule reasoning traces for every case in
baoxiao_cases.thy, using Isabelle as the backend solver.

Steps:
  1. Parse baoxiao_rules.thy  → unary functions per case-type
  2. Parse baoxiao_cases.thy  → individual case definitions
  3. Generate baoxiao_trace.thy with value statements for each (case, sub-rule)
  4. Run baoxiao_trace.thy through the Isabelle server
  5. Save structured JSON trace to isabelle_trace_results.json

Run:
    python3 run_isabelle_trace.py

Output:
    isabelle_trace_results.json   — structured per-case reasoning trace
    isabelle_trace_results.txt    — human-readable summary
"""
import asyncio
import os
import shutil
import json
import re
import subprocess
import sys
from pathlib import Path

# ── Paths ───────────────────────────────────────────────────────────────────
ISABELLE_BIN  = os.environ.get("ISABELLE_BIN") or shutil.which("isabelle") or "isabelle"
GROUNDTRUTH   = Path(__file__).resolve().parent.parent / "groundtruth"
RULES_THY     = GROUNDTRUTH / "baoxiao_rules.thy"
CASES_THY     = GROUNDTRUTH / "baoxiao_cases.thy"
TRACE_THY     = GROUNDTRUTH / "baoxiao_trace.thy"
OUTPUT_JSON   = Path(__file__).resolve().parent.parent / "data/isabelle_trace_results.json"
OUTPUT_TXT    = Path(__file__).resolve().parent.parent / "data/isabelle_trace_results.txt"
COVERAGE_JSON = Path(__file__).resolve().parent.parent / "data/isabelle_trace_coverage.json"
SERVER_PORT   = 7790
SERVER_LOG    = "isabelle_trace_server.log"

# Sample files to check for case-name coverage
SAMPLE_FILES: dict = {
    "sample1": Path(__file__).resolve().parent.parent / "data/sample1.json",
    "sample2": Path(__file__).resolve().parent.parent / "data/sample2.json",
    "sample3": Path(__file__).resolve().parent.parent / "data/sample3.json",
}

# Return types that are the "final result" (vs intermediate bool conditions)
RESULT_TYPES  = {"reimbursement_result", "rule3_answer", "rule4_answer",
                 "global_claim_result"}


# ── Step 1: parse sub-rule functions from baoxiao_rules.thy ─────────────────

def parse_rule_functions(*thy_paths: Path) -> dict:
    """
    Extract unary functions whose input type is any *_case variant or sr_claim,
    scanning one or more theory files (rules.thy and/or cases.thy).

    Returns:
        {case_type: [{"name": str, "return_type": str, "is_final": bool}, ...]}

    Only includes functions with signature  "input ⇒ TYPE"
    (skips multi-arg functions where TYPE itself contains ⇒).
    """
    content = ""
    for p in thy_paths:
        with open(p, encoding="utf-8") as f:
            content += f.read() + "\n"

    # Match:  definition  name  ::  "input \<Rightarrow> output"
    # Input type may be rule7_case, rule7v2_amount_case, claim_case_main, sr_claim …
    pattern = re.compile(
        r'definition\s+(\w+)\s*::\s*"'
        r'(\w+_case(?:_\w+)?|\w+_case_main|sr_claim)'   # *_case*, claim_case_main, sr_claim
        r'\s*\\<Rightarrow>\s*'
        r'([^"]+)"'                                       # return type (up to closing quote)
    )

    funcs: dict = {}
    for m in pattern.finditer(content):
        func_name   = m.group(1)
        input_type  = m.group(2)
        return_type = m.group(3).strip()

        # Skip multi-arg functions (return type contains another arrow)
        if r"\<Rightarrow>" in return_type:
            continue

        entry = {
            "name":        func_name,
            "return_type": return_type,
            "is_final":    return_type in RESULT_TYPES,
        }
        funcs.setdefault(input_type, []).append(entry)

    # Order: sub-conditions (bool) first, final-result functions last;
    # within each group preserve the original definition order in the file.
    # Python sort is stable, so sorting only on is_final keeps file order.
    for case_type in funcs:
        funcs[case_type].sort(key=lambda e: e["is_final"])

    return funcs


# ── Step 2a: parse individual case definitions (cases.thy + rules.thy) ───────

def parse_cases(*thy_paths: Path) -> list:
    """
    Extract individual case definitions with explicit *_case type from one or
    more theory files.  Duplicates (same case_name) are de-duplicated while
    preserving the first-seen order.

    Returns:
        [(case_name, case_type, None), ...]   ← None = no index expression
    in file order.
    """
    pattern = re.compile(
        r'definition\s+(\w+)\s*::\s*(\w+_case(?:_\w+)?|\w+_case_main)\s+where'
    )
    seen: set  = set()
    results: list = []
    for path in thy_paths:
        with open(path, encoding="utf-8") as f:
            content = f.read()
        for m in pattern.finditer(content):
            name, typ = m.group(1), m.group(2)
            if name not in seen:
                seen.add(name)
                results.append((name, typ, None))
    return results


# ── Step 2b: parse anonymous Unicode-format definitions ──────────────────────

def parse_anonymous_cases(cases_path: Path, rule_funcs: dict) -> list:
    """
    Parse  definition "name ≡ ⦇...⦈"  (no explicit type annotation) and infer
    the case type via three strategies tried in order:

    1. Direct list membership  — name appears in body of a "TYPE list" definition
    2. Record-update base      — a typed definition foo :: TYPE has body  ≡ name\\<lparr>
    3. Value-map argument      — name appears in  value "map funcname [...name...]"
                                 where funcname has a known input TYPE

    Returns [(name, inferred_type, None), ...] in definition order.
    Names whose type cannot be inferred are silently skipped.
    """
    with open(cases_path, encoding="utf-8") as f:
        content = f.read()

    anon_pat = re.compile(r'definition\s*"(\w+)\s*≡\s*⦇')
    anon_names = [m.group(1) for m in anon_pat.finditer(content)]
    if not anon_names:
        return []

    anon_set = set(anon_names)
    name_to_type: dict = {}

    # ── Strategy 1: direct list-body membership ───────────────────────────────
    list_hdr_pat = re.compile(r'definition\s+(\w+)\s*::\s*"(\w+)\s+list"\s*where')
    for m in list_hdr_pat.finditer(content):
        list_name, elem_type = m.group(1), m.group(2)
        search = f'"{list_name} \\<equiv>'
        idx = content.find(search)
        if idx == -1:
            continue
        body_end = content.find('"', idx + len(search))
        if body_end == -1:
            continue
        body = content[idx + len(search):body_end]
        for name in anon_set:
            if name not in name_to_type and re.search(rf'\b{re.escape(name)}\b', body):
                name_to_type[name] = elem_type

    # ── Strategy 2: record-update base-case in a typed definition ─────────────
    base_pat = re.compile(
        r'definition\s+\w+\s*::\s*(\w+_case(?:_\w+)?|\w+_case_main)\s+where\s*'
        r'"[^"]*\\<equiv>\s*(\w+)\\<lparr>'
    )
    for m in base_pat.finditer(content):
        def_type, base_name = m.group(1), m.group(2)
        if base_name in anon_set and base_name not in name_to_type:
            name_to_type[base_name] = def_type

    # ── Strategy 3: value "map funcname [...name...]" argument ─────────────────
    func_to_input: dict = {
        func["name"]: input_type
        for input_type, fns in rule_funcs.items()
        for func in fns
    }
    # Also capture functions excluded from rule_funcs (e.g. multi-return-type sigs)
    extra_fn_pat = re.compile(
        r'definition\s+(\w+)\s*::\s*"(\w+_case(?:_\w+)?|\w+_case_main)\s*\\<Rightarrow>'
    )
    for m in extra_fn_pat.finditer(content):
        func_to_input.setdefault(m.group(1), m.group(2))

    value_map_pat = re.compile(r'value\s+"map\s+(\w+)\s*\[([^\]]+)\]"')
    for m in value_map_pat.finditer(content):
        func_name, args_str = m.group(1), m.group(2)
        if func_name not in func_to_input:
            continue
        input_type = func_to_input[func_name]
        for name in anon_set:
            if name not in name_to_type and re.search(rf'\b{re.escape(name)}\b', args_str):
                name_to_type[name] = input_type

    seen: set = set()
    results: list = []
    for name in anon_names:
        if name in seen:
            continue
        seen.add(name)
        typ = name_to_type.get(name)
        if typ:
            results.append((name, typ, None))

    return results


# ── Step 2c: parse list definitions and produce virtual indexed cases ─────────

def _count_literal_elements(body: str) -> int:
    """Count top-level comma-separated elements inside an Isabelle list body.

    Tracks nesting depth via \\<lparr>/\\<rparr> (record-update brackets)
    and ordinary ( / ) parentheses so that commas inside record updates are
    not mistaken for element separators.
    """
    body = body.strip()
    if not body:
        return 0
    depth, count, i = 0, 1, 0
    while i < len(body):
        # \\<lparr> and \\<rparr> are each 8 ASCII characters in Isabelle source
        if body[i:].startswith(r'\<lparr>') or body[i:].startswith(r'\<Lparr>'):
            depth += 1; i += 8
        elif body[i:].startswith(r'\<rparr>') or body[i:].startswith(r'\<Rparr>'):
            depth -= 1; i += 8
        elif body[i] in '([':
            depth += 1; i += 1
        elif body[i] in ')]':
            depth -= 1; i += 1
        elif body[i] == ',' and depth == 0:
            count += 1; i += 1
        else:
            i += 1
    return count


def parse_list_definitions(cases_path: Path) -> dict:
    """
    Find all  definition listname :: "elemtype list" where  definitions and
    compute how many elements each list contains (handles both literal lists
    and @-concatenations of other named lists).

    Returns:
        {list_name: {"elem_type": str, "length": int}}
    """
    with open(cases_path, encoding="utf-8") as f:
        content = f.read()

    # --- collect headers: list_name → elem_type ---
    header_pat = re.compile(
        r'definition\s+(\w+)\s*::\s*"(\w+)\s+list"\s*where'
    )
    headers = {m.group(1): m.group(2) for m in header_pat.finditer(content)}
    if not headers:
        return {}

    # --- collect bodies: list_name → body_text (the RHS of \<equiv>) ---
    # Each body definition looks like:  "listname \<equiv> BODY"
    # Isabelle bodies never contain a bare " character ('' is used for string
    # literals), so finding the next " after \<equiv> gives the closing quote.
    bodies: dict = {}
    for name in headers:
        search = f'"{name} \\<equiv>'
        idx = content.find(search)
        if idx == -1:
            continue
        body_start = idx + len(search)
        # skip any leading whitespace / newline
        while body_start < len(content) and content[body_start] in ' \t\n':
            body_start += 1
        body_end = content.find('"', body_start)
        if body_end == -1:
            continue
        bodies[name] = content[body_start:body_end].strip()

    # --- resolve lengths recursively ---
    lengths: dict = {}

    def resolve(name: str, stack: frozenset) -> int:
        if name in lengths:
            return lengths[name]
        if name not in bodies or name in stack:
            return 0
        body = bodies[name]
        stack = stack | {name}

        if body.startswith('['):
            bracket_end = body.rfind(']')
            inner = body[1:bracket_end].strip()
            n = _count_literal_elements(inner) if inner else 0
        elif '@' in body:
            parts = [p.strip() for p in re.split(r'\s*@\s*', body)]
            n = sum(resolve(p, stack) for p in parts if p)
        else:
            n = resolve(body.strip(), stack)

        lengths[name] = n
        return n

    for name in list(headers):
        resolve(name, frozenset())

    return {
        name: {"elem_type": headers[name], "length": lengths.get(name, 0)}
        for name in headers
    }


def make_list_cases(list_defs: dict, rule_funcs: dict) -> list:
    """
    For every list whose element type has evaluation functions in rule_funcs,
    produce a virtual case entry per element:

        (virtual_name, elem_type, index_expr)

    where  virtual_name = "listname_N"  (1-indexed, matching sample convention)
    and    index_expr   = "(listname ! (N-1))"  (0-indexed Isabelle).

    Only lists with length > 0 and a known elem_type are included.
    """
    virtual: list = []
    for list_name, info in sorted(list_defs.items()):
        elem_type = info["elem_type"]
        length    = info["length"]
        if length == 0 or elem_type not in rule_funcs:
            continue
        for idx in range(length):
            virtual.append((
                f"{list_name}_{idx + 1}",   # e.g. rule7_all_cases_1
                elem_type,
                f"({list_name} ! {idx})",   # Isabelle 0-indexed
            ))
    return virtual


# ── Step 3: generate baoxiao_trace.thy ──────────────────────────────────────

def generate_trace_theory(rule_funcs: dict, cases: list) -> list:
    """
    Write GROUNDTRUTH/baoxiao_trace.thy with one `value` statement per
    (case, function) pair.

    cases is a list of 3- or 4-tuples:
        (case_name, case_type, index_expr_or_None)
        (case_name, case_type, index_expr_or_None, custom_funcs_or_None)

    When index_expr is None        → value "func case_name"
    When index_expr is set         → value "func (expr)"
    When custom_funcs is not None  → use that list instead of rule_funcs[case_type]

    Returns value_map: list of dicts
        {line, case_name, case_type, func_name, return_type, is_final, expr}
    """
    header = [
        "theory baoxiao_trace",
        "  imports baoxiao_cases",
        "begin",
        "",
    ]
    body_lines: list[str] = []
    value_map:  list[dict] = []

    for tup in cases:
        case_name    = tup[0]
        case_type    = tup[1]
        index_expr   = tup[2]
        custom_funcs = tup[3] if len(tup) > 3 else None

        funcs = custom_funcs if custom_funcs is not None else rule_funcs.get(case_type)
        if not funcs:
            continue

        body_lines.append(f"(* ── {case_name} : {case_type} ── *)")
        for func in funcs:
            subject = index_expr if index_expr else case_name
            expr = f"{func['name']} {subject}"
            value_map.append({
                # line is 1-indexed; header occupies lines 1-4
                "line":        len(header) + len(body_lines) + 1,
                "case_name":   case_name,
                "case_type":   case_type,
                "func_name":   func["name"],
                "return_type": func["return_type"],
                "is_final":    func["is_final"],
                "expr":        expr,
            })
            body_lines.append(f'value "{expr}"')
        body_lines.append("")

    body_lines.append("end")

    with open(TRACE_THY, "w", encoding="utf-8") as f:
        f.write("\n".join(header + body_lines))

    total = len(value_map)
    n_individual = sum(1 for c in cases if c[2] is None)
    n_list_elem  = sum(1 for c in cases if c[2] is not None)
    print(
        f"Generated {TRACE_THY.name}: "
        f"{n_individual} individual + {n_list_elem} list-element cases "
        f"= {total} value statements"
    )
    return value_map


# ── Step 3b: sr_span virtual cases (multi-rule, multi-claim structure) ────────

# sr_spanK_cases_new_50 is a list of 50 sr_multi_case elements; each element
# holds K sr_claim items in its case_claims field.  The sample files reference
# these as  sr_spanK_case_N_claim_M  (1-indexed N and M).
_SR_SPAN_LISTS: dict = {
    2: ("sr_span2_cases_new_50", 50),
    3: ("sr_span3_cases_new_50", 50),
    4: ("sr_span4_cases_new_50", 50),
    5: ("sr_span5_cases_new_50", 50),
}

# Maps (case_index % 4) → (inner rule_case type, sr_claim constructor name)
# Mirrors the mk_sr_multi_case_new logic: sr_rule_of_index i = [SR7,SR8,SR10,SR13] ! (i mod 4)
_SR_SPAN_RULE_MAP: dict = {
    0: ("rule7_case",  "SRC7"),
    1: ("rule8_case",  "SRC8"),
    2: ("rule10_case", "SRC10"),
    3: ("rule13_case", "SRC13"),
}


def make_sr_span_cases(rule_funcs: dict) -> list:
    """
    Generate virtual case entries for every  sr_spanK_case_N_claim_M  name.

    Each name yields TWO consecutive entries (merged into one case by build_trace):
      1. (name, inner_rule_case_type, extractor_expr, inner_funcs)
         — runs all sub-condition functions of the inner rule case, all forced to
           is_final=False so they appear as conditions, not as the final result.
      2. (name, "sr_claim", claim_expr, None)
         — runs identity_of_sr_claim_new + eval_sr_claim_new (the final result).

    The inner case type is determined statically from the case index:
        ci % 4  →  rule7/8/10/13_case  (matches mk_sr_multi_case_new logic)
    """
    result: list = []
    for span_size, (list_name, case_count) in sorted(_SR_SPAN_LISTS.items()):
        for ci in range(case_count):
            inner_type, constructor = _SR_SPAN_RULE_MAP[ci % 4]
            # All inner functions become conditions (override is_final) so that
            # eval_sr_claim_new remains the sole final_result for this case.
            inner_funcs = [
                {**f, "is_final": False}
                for f in rule_funcs.get(inner_type, [])
            ]
            for cl in range(span_size):
                virtual_name = f"sr_span{span_size}_case_{ci + 1}_claim_{cl + 1}"
                claim_expr   = f"(case_claims ({list_name} ! {ci}) ! {cl})"
                inner_expr   = (
                    f"(case {claim_expr} of {constructor} x \\<Rightarrow> x)"
                )
                result.append((virtual_name, inner_type, inner_expr, inner_funcs))
                result.append((virtual_name, "sr_claim", claim_expr, None))
    return result


# ── Step 4: Isabelle server protocol (stdlib only) ───────────────────────────

def start_server() -> tuple:
    proc = subprocess.Popen(
        ["bash", ISABELLE_BIN, "server",
         "-p", str(SERVER_PORT), "-n", "baoxiao_trace", "-L", SERVER_LOG],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    line = proc.stdout.readline().decode("utf-8").strip()
    if not line:
        raise RuntimeError(proc.stderr.read().decode())
    return line, proc


def parse_server_info(info: str) -> tuple:
    m = re.search(r'=\s*(\S+):(\d+)\s*\(password\s*"([^"]+)"\)', info)
    if not m:
        raise ValueError(f"Cannot parse: {info!r}")
    return m.group(1), int(m.group(2)), m.group(3)


async def _read_one(reader: asyncio.StreamReader) -> dict:
    first = (await reader.readline()).decode("utf-8")
    lm = re.match(r'^(\d+)\n$', first)
    if lm:
        first = (await reader.readexactly(int(lm.group(1)))).decode("utf-8")
    m = re.match(r'^(\w+)\s*(.*)', first, re.DOTALL)
    if not m:
        raise ValueError(f"Bad response: {first!r}")
    body_str = m.group(2).strip()
    try:
        body = json.loads(body_str) if body_str else {}
    except json.JSONDecodeError:
        body = body_str
    return {"type": m.group(1), "body": body}


async def _send_command(host, port, password, command,
                        terminal=frozenset({"FINISHED", "FAILED", "ERROR"}),
                        on_message=None):
    reader, writer = await asyncio.open_connection(host, port)
    try:
        writer.write(f"{password}\n{command}\n".encode("utf-8"))
        await writer.drain()
        await _read_one(reader)          # discard password-OK
        responses = []
        while True:
            r = await _read_one(reader)
            if on_message:
                on_message(r)
            responses.append(r)
            if r["type"] in terminal:
                break
        return responses
    finally:
        writer.close()
        try:
            await writer.wait_closed()
        except Exception:
            pass


async def _run_isabelle(host, port, password, n_stmts) -> list:
    # session_start
    print("Starting HOL session…")
    s_args = json.dumps({
        "session": "HOL", "options": [], "dirs": [],
        "include_sessions": [], "verbose": False, "print_mode": [],
    })
    resp = await _send_command(host, port, password, f"session_start {s_args}")
    session_id = next(
        (r["body"]["session_id"] for r in resp
         if r["type"] == "FINISHED" and isinstance(r["body"], dict)),
        None,
    )
    if not session_id:
        sys.exit(f"No session_id. Responses: {resp}")
    print(f"Session: {session_id}")

    # use_theories
    print(
        f"Processing baoxiao_trace.thy  "
        f"({n_stmts} value statements — this will take several minutes)…"
    )
    u_args = json.dumps({
        "session_id":       session_id,
        "theories":         ["baoxiao_trace"],
        "master_dir":       str(GROUNDTRUTH),
        "watchdog_timeout": 1800.0,      # 30-min cap for large traces
        "check_delay":      0.5,
    })

    _last_pct = [-1]

    def _on_use_theories_msg(r):
        body = r["body"] if isinstance(r["body"], dict) else {}
        pct = body.get("percentage")
        if pct is not None and pct != _last_pct[0]:
            _last_pct[0] = pct
            print(f"  baoxiao_trace.thy: {pct}%", flush=True)

    resp = await _send_command(
        host, port, password, f"use_theories {u_args}",
        terminal=frozenset({"FINISHED", "FAILED", "ERROR"}),
        on_message=_on_use_theories_msg,
    )

    # Check for failure
    for r in resp:
        if r["type"] in ("FAILED", "ERROR"):
            msg = r["body"].get("message", r["body"]) if isinstance(r["body"], dict) else r["body"]
            sys.exit(f"Isabelle FAILED: {msg}")

    raw_msgs = []
    for r in resp:
        body = r["body"] if isinstance(r["body"], dict) else {}
        for node in body.get("nodes", []):
            for msg in node.get("messages", []):
                raw_msgs.append({
                    "kind":    msg.get("kind", ""),
                    "line":    msg.get("pos", {}).get("line", 0),
                    "message": msg.get("message", ""),
                })

    # session_stop
    await _send_command(
        host, port, password,
        f"session_stop {json.dumps({'session_id': session_id})}",
    )
    return raw_msgs


def collect_messages(n_stmts: int) -> list:
    print("Starting Isabelle server…")
    server_info, server_proc = start_server()
    print(f"Server: {server_info}")
    try:
        host, port, password = parse_server_info(server_info)
        raw = asyncio.run(_run_isabelle(host, port, password, n_stmts))
        print(f"Received {len(raw)} messages.")
        return raw
    finally:
        try:
            server_proc.terminate()
        except Exception:
            pass


# ── Step 5: match messages → value_map entries ───────────────────────────────

def build_trace(value_map: list, raw_msgs: list) -> list:
    """
    Match each Isabelle output message to its (case, function) entry.

    Returns per-case trace list:
        [{"case": str, "type": str, "conditions": [...], "final_result": str}, ...]
    """
    # Build line → entry index map
    line_to_idx = {e["line"]: i for i, e in enumerate(value_map)}
    results = ["NOT_EVALUATED"] * len(value_map)

    for msg in raw_msgs:
        if msg["kind"] != "writeln":
            continue
        line = msg["line"]
        text = msg["message"]

        # Strategy 1: line-number match
        if line in line_to_idx:
            raw = text
            # Strip  "expr" =  prefix when present
            pm = re.match(r'^".*?"\s*=\s*(.+)$', raw, re.DOTALL)
            results[line_to_idx[line]] = pm.group(1).strip() if pm else raw.strip()
            continue

        # Strategy 2: "expr" = value pattern
        pm = re.match(r'^"(.+?)"\s*=\s*(.+)$', text, re.DOTALL)
        if pm:
            expr_text   = pm.group(1).strip()
            result_text = pm.group(2).strip()
            for i, e in enumerate(value_map):
                if e["expr"] == expr_text and results[i] == "NOT_EVALUATED":
                    results[i] = result_text
                    break

    # Group by case
    case_order  = []
    seen_cases  = set()
    case_groups: dict = {}
    for e, result in zip(value_map, results):
        cn = e["case_name"]
        if cn not in seen_cases:
            case_order.append(cn)
            seen_cases.add(cn)
            case_groups[cn] = {
                "case":         cn,
                "type":         e["case_type"],
                "conditions":   [],
                "final_result": "NOT_EVALUATED",
            }
        entry = {
            "function":    e["func_name"],
            "return_type": e["return_type"],
            "result":      result,
        }
        if e["is_final"]:
            case_groups[cn]["final_result"] = result
        else:
            case_groups[cn]["conditions"].append(entry)

    return [case_groups[cn] for cn in case_order]


# ── Step 6: sample coverage check ────────────────────────────────────────────

def check_sample_coverage(trace: list) -> dict:
    """
    Cross-reference the trace against SAMPLE_FILES.

    Returns a coverage report dict and mutates each trace entry to add
    'sample_refs': list of {file, id} for every sample entry that
    references this case via isabelle_case_names.

    Also reports:
      - trace cases not referenced by any sample
      - sample isabelle_case_names not present in the trace
    """
    trace_map = {c["case"]: c for c in trace}

    # Load samples that exist on disk
    samples: dict = {}
    for name, path in SAMPLE_FILES.items():
        if path.exists():
            with open(path, encoding="utf-8") as f:
                samples[name] = json.load(f)
        else:
            print(f"  [warning] sample file not found: {path}")

    def _normalize_case_name(cn: str) -> str:
        # Strip trailing Chinese/ASCII parenthesised annotations, e.g. "foo（变体）" → "foo"
        for bracket in ("（", "("):
            idx = cn.find(bracket)
            if idx != -1:
                cn = cn[:idx].rstrip()
        return cn

    # Build reverse index: isabelle_case_name → [(sample_file, entry_id)]
    reverse: dict = {}
    for sname, entries in samples.items():
        for entry in entries:
            eid = entry.get("id", "?")
            for raw_cn in entry.get("isabelle_case_names", []):
                cn = _normalize_case_name(raw_cn)
                reverse.setdefault(cn, []).append({"file": sname, "id": eid})

    # Annotate trace entries
    for c in trace:
        c["sample_refs"] = reverse.get(c["case"], [])

    # Trace cases with no sample reference
    uncovered_trace = sorted(c["case"] for c in trace if not c["sample_refs"])

    # Sample case names absent from trace (grouped by sample file)
    missing_in_trace: dict = {}
    for sname, entries in samples.items():
        names_not_in_trace = sorted(
            {_normalize_case_name(cn)
             for e in entries for cn in e.get("isabelle_case_names", [])}
            - set(trace_map)
        )
        if names_not_in_trace:
            missing_in_trace[sname] = names_not_in_trace

    return {
        "trace_cases_without_sample_ref": uncovered_trace,
        "sample_case_names_not_in_trace": missing_in_trace,
    }


# ── Step 7: save ──────────────────────────────────────────────────────────────

def save(trace: list) -> None:
    resolved_cases = sum(
        1 for c in trace if c["final_result"] != "NOT_EVALUATED"
    )

    print("\n─── Checking sample coverage …")
    coverage = check_sample_coverage(trace)

    # Report
    uncovered = coverage["trace_cases_without_sample_ref"]
    print(f"  Trace cases with no sample reference : {len(uncovered)}")
    for cn in uncovered:
        print(f"    {cn}")
    total_missing = sum(
        len(v) for v in coverage["sample_case_names_not_in_trace"].values()
    )
    print(f"  Sample case names absent from trace  : {total_missing}")
    for sname, names in coverage["sample_case_names_not_in_trace"].items():
        print(f"    {sname}: {len(names)} missing  "
              f"(e.g. {', '.join(names[:3])}{'…' if len(names) > 3 else ''})")

    with open(OUTPUT_JSON, "w", encoding="utf-8") as f:
        json.dump(
            {"total_cases": len(trace), "resolved": resolved_cases, "trace": trace},
            f, indent=2, ensure_ascii=False,
        )

    with open(COVERAGE_JSON, "w", encoding="utf-8") as f:
        json.dump(coverage, f, indent=2, ensure_ascii=False)

    with open(OUTPUT_TXT, "w", encoding="utf-8") as f:
        f.write(f"Isabelle reasoning trace — {resolved_cases}/{len(trace)} cases resolved\n")
        f.write("=" * 80 + "\n\n")
        for c in trace:
            f.write(f"[{c['case']} : {c['type']}]\n")
            for cond in c["conditions"]:
                tick = "✓" if cond["result"] == "True" else (
                       "✗" if cond["result"] == "False" else "?")
                f.write(f"  {tick} {cond['function']:55s} = {cond['result']}\n")
            f.write(f"  → RESULT: {c['final_result']}\n\n")

    print(f"\nSaved {resolved_cases}/{len(trace)} cases →")
    print(f"  {OUTPUT_JSON}")
    print(f"  {OUTPUT_TXT}")
    print(f"  {COVERAGE_JSON}")


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    print("─── Parsing rule functions …")
    # Scan both files: sr_claim evaluation functions live in cases.thy
    rule_funcs = parse_rule_functions(RULES_THY, CASES_THY)
    for ct, fns in sorted(rule_funcs.items()):
        sub = sum(1 for f in fns if not f["is_final"])
        fin = sum(1 for f in fns if f["is_final"])
        print(f"  {ct:20s}: {sub} sub-rules, {fin} evaluators")

    print("\n─── Parsing individual cases …")
    # Scan both cases.thy and rules.thy so that case definitions in rules.thy
    # (e.g. rule4_ok, rule4_bad_*, rule6_base_ok, default_*_gate_case) are included.
    individual_cases = parse_cases(CASES_THY, RULES_THY)
    # Add anonymous Unicode-format definitions (definition "name ≡ ⦇...⦈")
    anonymous_cases = parse_anonymous_cases(CASES_THY, rule_funcs)
    known_names = {n for n, _, _ in individual_cases}
    anonymous_cases = [(n, t, e) for n, t, e in anonymous_cases if n not in known_names]
    individual_cases = individual_cases + anonymous_cases
    from collections import Counter
    type_counts = Counter(ct for _, ct, _ in individual_cases)
    for ct, n in sorted(type_counts.items()):
        print(f"  {ct:20s}: {n} cases")
    print(f"  Anonymous Unicode cases resolved: {len(anonymous_cases)}")
    print(f"  Individual total: {len(individual_cases)}")

    print("\n─── Parsing list definitions …")
    list_defs  = parse_list_definitions(CASES_THY)
    list_cases = make_list_cases(list_defs, rule_funcs)
    for lname, info in sorted(list_defs.items()):
        traceable = info["elem_type"] in rule_funcs
        print(f"  {lname:40s}: {info['length']:3d} elem  [{info['elem_type']}]"
              f"{'  ✓ traceable' if traceable else ''}")
    print(f"  List-element virtual cases: {len(list_cases)}")

    print("\n─── Building sr_span claim cases …")
    sr_span_cases = make_sr_span_cases(rule_funcs)
    print(f"  sr_span virtual cases: {len(sr_span_cases)}")

    cases = individual_cases + list_cases + sr_span_cases
    print(f"  Combined total: {len(cases)}")

    print("\n─── Generating trace theory …")
    value_map = generate_trace_theory(rule_funcs, cases)

    print("\n─── Running Isabelle …")
    raw_msgs = collect_messages(len(value_map))

    print("\n─── Building trace …")
    trace = build_trace(value_map, raw_msgs)
    resolved = sum(1 for c in trace if c["final_result"] != "NOT_EVALUATED")
    print(f"Resolved {resolved}/{len(trace)} cases")

    save(trace)

    print("\n─── Sample (first 3 cases) ───")
    for c in trace[:3]:
        print(f"\n  [{c['case']} : {c['type']}]")
        for cond in c["conditions"]:
            tick = "✓" if cond["result"] == "True" else (
                   "✗" if cond["result"] == "False" else "?")
            print(f"    {tick} {cond['function'][:50]:50s} = {cond['result']}")
        print(f"    → {c['final_result']}")


if __name__ == "__main__":
    main()
