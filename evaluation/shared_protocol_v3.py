"""Shared response contract. Legacy Finance answers remain a separate baseline."""
import hashlib,json
VERSION='section_json_v3'
DEFAULT_OUTPUT_BUDGET=32000
COMMON='''Use only the supplied rules and case facts. Do not add external rules or invented facts.
Return one JSON object only, without Markdown fences or surrounding text.
Use selected_rules entries with rule_id (a main source rule number, as a string), rule_title, and why_selected.
Use a reasoning_trace array. Each entry has step (integer), description, result, and rule_id.
Prefix description with Check —, Compute —, or Conclusion —. Describe the supporting case facts and the inference explicitly.
A rule-based step must cite exactly one main rule number in rule_id and in its description as [Rule n]. Split uses of multiple rules into separate steps.
For direct fact statements or pure arithmetic without a rule application, set rule_id to null. Do not invent a rule citation.
Cite main source rule numbers: e.g. finance clauses 7.2 and 7.3 both use Rule 7. Repeated rule use is allowed.
Use PASS/FAIL for condition checks, a numeric value for calculations, and the decision label for the conclusion result.
Keep the factual evidence needed for the conclusion. Do not list irrelevant rules. Finish with the requested final-answer field.
'''
LAW=COMMON+'''This is a legal-style logic task. Closed-world assumption: unstated atomic facts are false unless expressly stated otherwise.
Use these top-level keys: selected_rules, reasoning_trace, final_result.
final_result must be the final legal consequence after resolving exceptions and priorities (such as the applicable penalty), not merely the name of an offence or triggered article.
'''
def law_messages(case,question):
    return [{'role':'system','content':LAW},{'role':'user','content':'Rules:\n'+case['rules_text']+'\n\nCase:\n'+case['case_text']+'\n\nQuestion:\n'+question['question']}]
def finance_instructions(legacy_template):
    # Preserve expense-item/review-subject nesting and task-specific labels.
    marker='Below is the rule file:'
    addition='\nShared output contract (takes precedence for trace fields and citations only):\n'+COMMON+'Keep the task-specific JSON fields and nesting specified above; apply this trace contract separately to each expense item or review subject.\n'
    if marker in legacy_template:return legacy_template.replace(marker,addition+'\n'+marker)
    pos=legacy_template.index('{{rules_json}}')
    return legacy_template[:pos]+addition+legacy_template[pos:]
def budget(model_record):
    # User-requested common ceiling; never silently reduce to a provider default.
    return DEFAULT_OUTPUT_BUDGET
def digest(obj):return hashlib.sha256(json.dumps(obj,ensure_ascii=False,sort_keys=True).encode()).hexdigest()
