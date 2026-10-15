from __future__ import annotations

import json
import re
import argparse
import sys
from pathlib import Path


MATERIAL_COMPLETE = "Materials complete"
MATERIAL_INCOMPLETE = "Materials incomplete"
INVOICE_CORRECT = "Invoices compliant"
INVOICE_ERROR = "Invoices non-compliant"
FULL = "Fully reimbursable"
PARTIAL = "Partially reimbursable"
REJECT = "Not reimbursable"
PENDING = "Pending"
NEED_MORE = "Need more materials"
LOAN_ELIGIBLE = "Eligible for temporary loan"
LOAN_INELIGIBLE = "Ineligible for temporary loan"
GLOBAL_FULL_APPROVAL = "Global_Reimbursement Full_Approval"
GLOBAL_REJECTION = "Global_Reimbursement Rejection"
LOCAL_FULL_APPROVAL = "Full_Approval"
LOCAL_REJECTION = "Rejection"
GLOBAL_CAN_BORROW = "Global_Loan Can_Borrow"
GLOBAL_CANNOT_BORROW = "Global_Loan Cannot_Borrow"

MATERIAL_STATUS_PATH = ["model_output", "material_review", "status"]
INVOICE_STATUS_PATH = ["model_output", "invoice_review", "status"]
LOAN_STATUS_PATH = ["model_output", "invoice_review", "status"]
AUDIT_RESULT_PATH = ["model_output", "audit_result"]
AMOUNT_RESULT_PATH = ["model_output", "reimbursable_amount"]


TASK_CONFIGS = {
    "material": {
        "default_result_file": Path("sample3_3_results.jsonl"),
        "json_path": MATERIAL_STATUS_PATH,
        "gold_labels": [
            "Material_Complete", "Material_Complete", "Material_Complete", "Material_Complete", "Material_Complete",
            "Material_Complete", "Material_Complete", "Material_Complete", "Material_Complete", "Material_Complete",
            "Material_Complete", "Material_Complete", "Material_Complete", "Material_Complete", "Material_Complete",
            "Material_Complete", "Material_Complete", "Material_Complete", "Material_Complete", "Material_Complete",
            "Material_Incomplete", "Material_Incomplete", "Material_Incomplete", "Material_Incomplete", "Material_Incomplete",
            "Material_Incomplete", "Material_Incomplete", "Material_Incomplete", "Material_Incomplete", "Material_Incomplete",
            "Material_Incomplete", "Material_Incomplete", "Material_Incomplete", "Material_Incomplete", "Material_Incomplete",
            "Material_Incomplete", "Material_Incomplete", "Material_Incomplete", "Material_Incomplete", "Material_Incomplete",
        ],
        "pred_map": {
            MATERIAL_COMPLETE: "Material_Complete",
            MATERIAL_INCOMPLETE: "Material_Incomplete",
        },
    },
    "invoice": {
        "default_result_file": Path("sample3_4_results.jsonl"),
        "json_path": INVOICE_STATUS_PATH,
        "gold_labels": [
            "Invoice_Correct",
            "Invoice_Error", "Invoice_Error", "Invoice_Error", "Invoice_Error", "Invoice_Error",
            "Invoice_Error", "Invoice_Error", "Invoice_Error", "Invoice_Error", "Invoice_Error",
            "Invoice_Error", "Invoice_Error", "Invoice_Error", "Invoice_Error", "Invoice_Error",
            "Invoice_Error", "Invoice_Error", "Invoice_Error", "Invoice_Error",
        ],
        "pred_map": {
            INVOICE_CORRECT: "Invoice_Correct",
            INVOICE_ERROR: "Invoice_Error",
        },
    },
    "approval6": {
        "default_result_file": Path("sample3_6_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "start_index": 1,
        "end_index": 40,
        "gold_labels": [GLOBAL_FULL_APPROVAL] * 20 + [GLOBAL_REJECTION] * 20,
        "pred_map": {
            FULL: GLOBAL_FULL_APPROVAL,
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: GLOBAL_REJECTION,
            MATERIAL_INCOMPLETE: GLOBAL_REJECTION,
            PENDING: "Global_Reimbursement Unknown",
        },
    },
    "approval4_6": {
        "default_result_file": Path("sample3_6_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "start_index": 41,
        "end_index": 80,
        "gold_labels": [LOCAL_FULL_APPROVAL] * 20 + [LOCAL_REJECTION] * 20,
        "pred_map": {
            FULL: LOCAL_FULL_APPROVAL,
            "Global_Reimbursement Full_Approval": LOCAL_FULL_APPROVAL,
            PARTIAL: "Partial_Approval",
            "Global_Reimbursement Partial_Approval": "Partial_Approval",
            REJECT: LOCAL_REJECTION,
            "Global_Reimbursement Rejection": LOCAL_REJECTION,
            MATERIAL_INCOMPLETE: LOCAL_REJECTION,
            PENDING: "Unknown",
            "Global_Reimbursement Unknown": "Unknown",
        },
    },
    "approval7": {
        "default_result_file": Path("sample3_7_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "gold_labels": [
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
        },
    },
    "approval8": {
        "default_result_file": Path("sample3_8_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "gold_labels": [
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
        },
    },
    "approval9": {
        "default_result_file": Path("sample3_9_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "gold_labels": [
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
        },
    },
    
    "approval10": {
        "default_result_file": Path("sample3_10_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "gold_labels": [
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Partial_Approval",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
            "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
        },
    },
    "approval11": {
        "default_result_file": Path("sample3_11_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "gold_labels": [
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
        },
    },

    "approval13": {
        "default_result_file": Path("sample3_13_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "gold_labels": [
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Unknown", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Unknown", "Global_Reimbursement Unknown", "Global_Reimbursement Unknown", "Global_Reimbursement Unknown",
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
        },
    },
    "approval14": {
        "default_result_file": Path("sample3_14_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "gold_labels": [
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
        },
    },
    "approval15": {
        "default_result_file": Path("sample3_15_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "gold_labels": [
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
        },
    },
    "approval16": {
        "default_result_file": Path("sample3_16_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "gold_labels": [
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
        },
    },
    "approval17": {
        "default_result_file": Path("sample3_17_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "gold_labels": [
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
        },
    },
    "approval18": {
        "default_result_file": Path("sample3_18_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "gold_labels": [
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection",
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
        },
    },
    "approval19": {
        "default_result_file": Path("sample3_19_results.jsonl"),
        "json_path": AUDIT_RESULT_PATH,
        "gold_labels": [
            "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval",
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
        },
    },
    
    "approval20": {
        "default_result_file": Path("sample3_20_results.jsonl"),
        "json_path": LOAN_STATUS_PATH,
        "gold_labels": [GLOBAL_CAN_BORROW] * 20 + [GLOBAL_CANNOT_BORROW] * 20,
        "pred_map": {
            LOAN_ELIGIBLE: GLOBAL_CAN_BORROW,
            "Can_Borrow": GLOBAL_CAN_BORROW,
            "Can Borrow": GLOBAL_CAN_BORROW,
            GLOBAL_CAN_BORROW: GLOBAL_CAN_BORROW,
            LOAN_INELIGIBLE: GLOBAL_CANNOT_BORROW,
            "Cannot_Borrow": GLOBAL_CANNOT_BORROW,
            "Cannot Borrow": GLOBAL_CANNOT_BORROW,
            GLOBAL_CANNOT_BORROW: GLOBAL_CANNOT_BORROW,
        },
    },
    "amount": {
        "default_result_file": Path("sample3_amount_results.jsonl"),
        "json_path": AMOUNT_RESULT_PATH,
        "gold_values": [
            2890, 4970, 3600, 3090, 1680, 1910, 3010, 5190, 1540, 2130,
            1800, 1380, 1230, 2570, 2470, 2070, 4190, 2960, 1840, 2070,
            1590, 3190, 2740, 2230, 2340, 2880, 2435, 2150, 2560, 2610,
            2865, 2960, 2150, 1870, 1770, 1800, 1470, 1410, 1350, 1830,

            15200, 16250, 18425, 9060, 18425, 8600, 11700, 17318, 15200, 19500,
            20900, 4380, 4800, 16885, 15200, 18550, 8980, 18800, 14000, 15000,

            18720, 24050, 10520, 16250, 15200, 16250, 18425, 15200, 15200, 16250,
            15200, 16250, 18425, 15200, 15200, 16250, 18425, 15200, 16250, 18425,

            5250, 5600, 8180, 7000, 9300, 6550, 6350, 9600, 3600, 4100,
            7840, 7720, 8580, 9100, 5200, 5220, 4000, 2580, 9150, 4300,

            7650, 4000, 900, 5550, 8180, 5600, 5600, 5600, 4100, 9000,
            6150, 5250, 5600, 5600, 5600, 9000, 8180, 8180, 4100, 5850,
        ],
    },
    "sample1top50": {
        "default_result_file": Path("sample1_results.jsonl"),
        "gold_pairs": [
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            NEED_MORE: "Global_Reimbursement Unknown",
        },
    },
    "sample1_51_100": {
        "default_result_file": Path("sample1_results.jsonl"),
        "start_index": 51,
        "end_index": 100,
        "items_path": ["model_output", "fee_items"],
        "gold_pairs": [
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            NEED_MORE: "Global_Reimbursement Unknown",
        },
    },
    "sample1_101_150": {
        "default_result_file": Path("sample1_results.jsonl"),
        "start_index": 101,
        "end_index": 150,
        "items_path": ["model_output", "fee_items"],
        "gold_pairs": [
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            NEED_MORE: "Global_Reimbursement Unknown",
        },
    },
    "sample1_151_200": {
        "default_result_file": Path("sample1_results.jsonl"),
        "start_index": 151,
        "end_index": 200,
        "items_path": ["model_output", "fee_items"],
        "gold_pairs": [
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            NEED_MORE: "Global_Reimbursement Unknown",
        },
    },
    "sample2_1_50": {
        "default_result_file": Path("sample2_results.jsonl"),
        "start_index": 1,
        "end_index": 50,
        "items_path": ["model_output", "review_objects"],
        "gold_pairs": [
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            NEED_MORE: "Global_Reimbursement Unknown",
        },
    },
    "sample2_51_100": {
        "default_result_file": Path("sample2_2_results.jsonl"),
        "start_index": 1,
        "end_index": 50,
        "items_path": ["model_output", "review_objects"],
        "gold_pairs": [
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            NEED_MORE: "Global_Reimbursement Unknown",
        },
    },
    "sample2_101_150": {
        "default_result_file": Path("sample2_results.jsonl"),
        "start_index": 101,
        "end_index": 150,
        "items_path": ["model_output", "review_objects"],
        "gold_pairs": [
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            NEED_MORE: "Global_Reimbursement Unknown",
        },
    },
    "sample2_151_200": {
        "default_result_file": Path("sample2_2_results.jsonl"),
        "start_index": 151,
        "end_index": 200,
        "items_path": ["model_output", "review_objects"],
        "gold_pairs": [
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown"],
            ["Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection"],
            ["Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Unknown", "Global_Reimbursement Full_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Partial_Approval", "Global_Reimbursement Partial_Approval"],
            ["Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection", "Global_Reimbursement Full_Approval", "Global_Reimbursement Full_Approval", "Global_Reimbursement Rejection"],
        ],
        "pred_map": {
            FULL: "Global_Reimbursement Full_Approval",
            PARTIAL: "Global_Reimbursement Partial_Approval",
            REJECT: "Global_Reimbursement Rejection",
            PENDING: "Global_Reimbursement Unknown",
            MATERIAL_INCOMPLETE: "Global_Reimbursement Rejection",
            NEED_MORE: "Global_Reimbursement Unknown",
        },
    },
}


def get_nested_value(data: dict, path: list[str]) -> object:
    current: object = data
    for key in path:
        if not isinstance(current, dict):
            return None
        current = current.get(key)
    return current


def load_predictions(
    result_file: Path,
    json_path: list[str],
    pred_map: dict[str, str],
    start_index: int | None = None,
    end_index: int | None = None,
) -> list[str]:
    predictions: list[str] = []
    with result_file.open("r", encoding="utf-8") as f:
        for line_no, line in enumerate(f, start=1):
            line = line.strip()
            if not line:
                continue
            if start_index is not None and line_no < start_index:
                continue
            if end_index is not None and line_no > end_index:
                break
            record = json.loads(line)
            status = get_nested_value(record, json_path)
            if not isinstance(status, str):
                predictions.append("ERROR")
                continue
            predictions.append(pred_map.get(status, "ERROR"))
    return predictions


def load_numeric_values(result_file: Path, json_path: list[str]) -> list[float | None]:
    with result_file.open("r", encoding="utf-8") as f:
        text = f.read()

    field_name = json_path[-1]
    object_splits = re.split(r'(?=\{"case_id":\s*\d+)', text)
    values: list[float | None] = []
    pattern = re.compile(rf'"{re.escape(field_name)}"\s*:\s*(-?\d+(?:\.\d+)?)')

    for chunk in object_splits:
        if not chunk.strip():
            continue
        match = pattern.search(chunk)
        if match:
            raw = match.group(1)
            values.append(float(raw) if "." in raw else int(raw))
        else:
            values.append(None)

    return values


def load_grouped_predictions(
    result_file: Path,
    pred_map: dict[str, str],
    start_index: int,
    end_index: int,
    items_path: list[str],
) -> list[list[str]]:
    pairs: list[list[str]] = []
    with result_file.open("r", encoding="utf-8") as f:
        for line_no, line in enumerate(f, start=1):
            if not line.strip():
                continue
            if line_no < start_index:
                continue
            if line_no > end_index:
                break
            record = json.loads(line)
            items = get_nested_value(record, items_path)
            if not isinstance(items, list):
                items = []
            current: list[str] = []
            for item in items:
                if not isinstance(item, dict):
                    continue
                status = item.get("audit_result")
                if isinstance(status, str):
                    current.append(pred_map.get(status, "ERROR"))
            pairs.append(current)
    return pairs


def evaluate_sample1_pairs(
    task: str, result_file: Path, gold_pairs: list[list[str]], pred_pairs: list[list[str]]
) -> int:
    if len(pred_pairs) != len(gold_pairs):
        print(f"Count mismatch: gold={len(gold_pairs)}, pred={len(pred_pairs)}", file=sys.stderr)
        return 1

    small_total = 0
    small_correct = 0
    final_total = len(gold_pairs)
    final_correct = 0
    mismatch_details: list[str] = []

    for idx, (gold_pair, pred_pair) in enumerate(zip(gold_pairs, pred_pairs), start=1):
        if len(pred_pair) != len(gold_pair):
            mismatch_details.append(
                f"{idx}: gold={gold_pair}, pred={pred_pair}, reason=wrong_output_count"
            )
            small_total += len(gold_pair)
            continue

        case_ok = True
        for sub_idx, (gold, pred) in enumerate(zip(gold_pair, pred_pair), start=1):
            small_total += 1
            if gold == pred:
                small_correct += 1
            else:
                case_ok = False
                mismatch_details.append(f"{idx}.{sub_idx}: gold={gold}, pred={pred}")

        if case_ok:
            final_correct += 1

    print(f"Task: {task}")
    print(f"Result file: {result_file}")
    print(f"Final-case total: {final_total}")
    print(f"Final-case correct: {final_correct}")
    print(f"Final-case accuracy: {final_correct / final_total:.2%}")
    print()
    print(f"Small-case total: {small_total}")
    print(f"Small-case correct: {small_correct}")
    print(f"Small-case accuracy: {small_correct / small_total:.2%}")

    if mismatch_details:
        print()
        print("Mismatches:")
        for item in mismatch_details:
            print(item)

    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Count accuracy for a model result file.")
    parser.add_argument("task", nargs="?", default="material", type=str.lower, choices=TASK_CONFIGS)
    parser.add_argument("result_file", nargs="?", type=Path, help="Explicit input file (relative to the current directory).")
    parser.add_argument("--model", help="Model directory name under results/generation/finance_legacy/; required if result_file is omitted.")
    args = parser.parse_args()
    task = args.task
    config = TASK_CONFIGS[task]
    if args.result_file is not None:
        result_file = args.result_file.expanduser().resolve()
    elif args.model:
        result_file = Path(__file__).resolve().parents[3] / "results/generation/finance_legacy" / args.model / config["default_result_file"]
    else:
        parser.error("Provide result_file or --model to select the experiment explicitly.")
    if not result_file.is_file():
        parser.error(f"Result file does not exist: {result_file}")

    if task == "amount":
        gold_values = config["gold_values"]
        predicted_values = load_numeric_values(result_file, config["json_path"])

        correct = 0
        mismatch_details: list[str] = []
        if len(predicted_values) != len(gold_values):
            print(f"Count mismatch: gold={len(gold_values)}, pred={len(predicted_values)}", file=sys.stderr)
            return 1

        missing_count = 0
        for idx, (gold, pred) in enumerate(zip(gold_values, predicted_values), start=1):
            if pred is None:
                missing_count += 1
                mismatch_details.append(f"{idx}: gold={gold}, pred=MISSING")
                continue
            if gold == pred:
                correct += 1
            else:
                mismatch_details.append(f"{idx}: gold={gold}, pred={pred}")

        total = len(gold_values)
        accuracy = correct / total if total else 0.0

        print(f"Task: {task}")
        print(f"Result file: {result_file}")
        print(f"Total: {total}")
        print(f"Correct: {correct}")
        print(f"Wrong: {total - correct}")
        print(f"Missing reimbursable_amount: {missing_count}")
        print(f"Accuracy: {accuracy:.2%}")

        if mismatch_details:
            print()
            print("Mismatches:")
            for item in mismatch_details:
                print(item)

        return 0

    if task == "sample1top50":
        gold_pairs = config["gold_pairs"]
        pred_pairs = load_grouped_predictions(
            result_file, config["pred_map"], 1, 50, ["model_output", "fee_items"]
        )
        return evaluate_sample1_pairs(task, result_file, gold_pairs, pred_pairs)

    if task in {"sample1_51_100", "sample1_101_150", "sample1_151_200", "sample2_1_50", "sample2_51_100", "sample2_101_150", "sample2_151_200"}:
        gold_pairs = config["gold_pairs"]
        pred_pairs = load_grouped_predictions(
            result_file,
            config["pred_map"],
            config["start_index"],
            config["end_index"],
            config["items_path"],
        )
        return evaluate_sample1_pairs(task, result_file, gold_pairs, pred_pairs)

    gold_labels = config["gold_labels"]
    predictions = load_predictions(
        result_file,
        config["json_path"],
        config["pred_map"],
        config.get("start_index"),
        config.get("end_index"),
    )

    if len(predictions) != len(gold_labels):
        print(f"Count mismatch: gold={len(gold_labels)}, pred={len(predictions)}", file=sys.stderr)
        return 1

    correct = 0
    error_count = 0
    mismatch_details: list[str] = []
    for idx, (gold, pred) in enumerate(zip(gold_labels, predictions), start=1):
        if pred == "ERROR":
            error_count += 1
        if gold == pred:
            correct += 1
        else:
            mismatch_details.append(f"{idx}: gold={gold}, pred={pred}")

    total = len(gold_labels)
    accuracy = correct / total if total else 0.0

    gold_counts: dict[str, int] = {}
    pred_counts: dict[str, int] = {}
    for label in gold_labels:
        gold_counts[label] = gold_counts.get(label, 0) + 1
    for label in predictions:
        pred_counts[label] = pred_counts.get(label, 0) + 1

    ordered_pred_labels = list(gold_counts.keys())
    for label in pred_counts:
        if label not in ordered_pred_labels:
            ordered_pred_labels.append(label)

    gold_distribution = ", ".join(f"{label}={gold_counts.get(label, 0)}" for label in gold_counts)
    pred_distribution = ", ".join(f"{label}={pred_counts.get(label, 0)}" for label in ordered_pred_labels)

    print(f"Task: {task}")
    print(f"Result file: {result_file}")
    print(f"Total: {total}")
    print(f"Correct: {correct}")
    print(f"Wrong: {total - correct}")
    print(f"Unmapped errors: {error_count}")
    print(f"Accuracy: {accuracy:.2%}")
    print()
    print(f"Gold distribution: {gold_distribution}")
    print(f"Pred distribution: {pred_distribution}")

    if mismatch_details:
        print()
        print("Mismatches:")
        for item in mismatch_details:
            print(item)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
