theory baoxiao_cases
  imports baoxiao_rules
begin
definition rule3_case_full_1 :: rule3_case where
"rule3_case_full_1 \<equiv> \<lparr>
  appointment_form_printed = True,
  fund_ledger_entry_submitted = True,
  appointment_form_signed_by_project_leader = True,
  appointment_form_signed_by_handler = True,
  project_leader_matches_system = True,
  project_leader_authorization_letter_filed = False,
  original_receipts_signed_by_project_leader = True,
  original_receipts_signed_by_handler = True,
  has_single_pen_approval_for_university_funds = False,
  has_research_project_leader_signature = True,
  has_department_approval_for_special_transactions = False,
  electronic_invoice_verified_in_system = False,
  electronic_invoice_selected_in_form = False,
  has_travel_approval = False,
  has_overseas_travel_approval = False,
  has_conference_approval = False,
  has_equipment_purchase_approval = False,
  has_research_fund_transfer_approval = False,
  payment_amount_ge_30000 = False,
  has_signed_contract = False,
  contract_stamped_with_university_seal = False,
  has_contract_for_construction = False,
  payment_amount_gt_50000 = False,
  has_large_sum_payment_application = False,
  large_sum_form_signed_by_leader = False,
  large_sum_form_stamped = False
\<rparr>"
definition rule3_case_full_2 :: rule3_case where
"rule3_case_full_2 \<equiv> \<lparr>
  appointment_form_printed = True,
  fund_ledger_entry_submitted = True,
  appointment_form_signed_by_project_leader = True,
  appointment_form_signed_by_handler = True,
  project_leader_matches_system = True,
  project_leader_authorization_letter_filed = False,
  original_receipts_signed_by_project_leader = True,
  original_receipts_signed_by_handler = True,
  has_single_pen_approval_for_university_funds = True,
  has_research_project_leader_signature = False,
  has_department_approval_for_special_transactions = False,
  electronic_invoice_verified_in_system = False,
  electronic_invoice_selected_in_form = False,
  has_travel_approval = False,
  has_overseas_travel_approval = False,
  has_conference_approval = False,
  has_equipment_purchase_approval = False,
  has_research_fund_transfer_approval = False,
  payment_amount_ge_30000 = True,
  has_signed_contract = True,
  contract_stamped_with_university_seal = True,
  has_contract_for_construction = False,
  payment_amount_gt_50000 = True,
  has_large_sum_payment_application = True,
  large_sum_form_signed_by_leader = True,
  large_sum_form_stamped = True
\<rparr>"
definition rule3_case_full_3 :: rule3_case where
"rule3_case_full_3 \<equiv> \<lparr>
  appointment_form_printed = True,
  fund_ledger_entry_submitted = True,
  appointment_form_signed_by_project_leader = True,
  appointment_form_signed_by_handler = True,
  project_leader_matches_system = True,
  project_leader_authorization_letter_filed = False,
  original_receipts_signed_by_project_leader = True,
  original_receipts_signed_by_handler = True,
  has_single_pen_approval_for_university_funds = False,
  has_research_project_leader_signature = True,
  has_department_approval_for_special_transactions = True,
  electronic_invoice_verified_in_system = True,
  electronic_invoice_selected_in_form = True,
  has_travel_approval = True,
  has_overseas_travel_approval = False,
  has_conference_approval = False,
  has_equipment_purchase_approval = False,
  has_research_fund_transfer_approval = False,
  payment_amount_ge_30000 = False,
  has_signed_contract = False,
  contract_stamped_with_university_seal = False,
  has_contract_for_construction = False,
  payment_amount_gt_50000 = False,
  has_large_sum_payment_application = False,
  large_sum_form_signed_by_leader = False,
  large_sum_form_stamped = False
\<rparr>"
definition rule3_case_incomplete_1 :: rule3_case where
"rule3_case_incomplete_1 \<equiv> \<lparr>
  appointment_form_printed = False,
  fund_ledger_entry_submitted = True,
  appointment_form_signed_by_project_leader = True,
  appointment_form_signed_by_handler = True,
  project_leader_matches_system = True,
  project_leader_authorization_letter_filed = False,
  original_receipts_signed_by_project_leader = True,
  original_receipts_signed_by_handler = True,
  has_single_pen_approval_for_university_funds = False,
  has_research_project_leader_signature = True,
  has_department_approval_for_special_transactions = False,
  electronic_invoice_verified_in_system = False,
  electronic_invoice_selected_in_form = False,
  has_travel_approval = False,
  has_overseas_travel_approval = False,
  has_conference_approval = False,
  has_equipment_purchase_approval = False,
  has_research_fund_transfer_approval = False,
  payment_amount_ge_30000 = False,
  has_signed_contract = False,
  contract_stamped_with_university_seal = False,
  has_contract_for_construction = False,
  payment_amount_gt_50000 = False,
  has_large_sum_payment_application = False,
  large_sum_form_signed_by_leader = False,
  large_sum_form_stamped = False
\<rparr>"
definition rule3_case_incomplete_2 :: rule3_case where
"rule3_case_incomplete_2 \<equiv> \<lparr>
  appointment_form_printed = True,
  fund_ledger_entry_submitted = True,
  appointment_form_signed_by_project_leader = True,
  appointment_form_signed_by_handler = True,
  project_leader_matches_system = True,
  project_leader_authorization_letter_filed = False,
  original_receipts_signed_by_project_leader = True,
  original_receipts_signed_by_handler = True,
  has_single_pen_approval_for_university_funds = True,
  has_research_project_leader_signature = False,
  has_department_approval_for_special_transactions = False,
  electronic_invoice_verified_in_system = False,
  electronic_invoice_selected_in_form = False,
  has_travel_approval = False,
  has_overseas_travel_approval = False,
  has_conference_approval = False,
  has_equipment_purchase_approval = False,
  has_research_fund_transfer_approval = False,
  payment_amount_ge_30000 = True,
  has_signed_contract = False,
  contract_stamped_with_university_seal = False,
  has_contract_for_construction = False,
  payment_amount_gt_50000 = False,
  has_large_sum_payment_application = False,
  large_sum_form_signed_by_leader = False,
  large_sum_form_stamped = False
\<rparr>"
definition rule3_case_incomplete_3 :: rule3_case where
"rule3_case_incomplete_3 \<equiv> \<lparr>
  appointment_form_printed = True,
  fund_ledger_entry_submitted = True,
  appointment_form_signed_by_project_leader = True,
  appointment_form_signed_by_handler = True,
  project_leader_matches_system = True,
  project_leader_authorization_letter_filed = False,
  original_receipts_signed_by_project_leader = True,
  original_receipts_signed_by_handler = True,
  has_single_pen_approval_for_university_funds = False,
  has_research_project_leader_signature = True,
  has_department_approval_for_special_transactions = True,
  electronic_invoice_verified_in_system = True,
  electronic_invoice_selected_in_form = False,
  has_travel_approval = True,
  has_overseas_travel_approval = False,
  has_conference_approval = False,
  has_equipment_purchase_approval = False,
  has_research_fund_transfer_approval = False,
  payment_amount_ge_30000 = False,
  has_signed_contract = False,
  contract_stamped_with_university_seal = False,
  has_contract_for_construction = False,
  payment_amount_gt_50000 = False,
  has_large_sum_payment_application = False,
  large_sum_form_signed_by_leader = False,
  large_sum_form_stamped = False
\<rparr>"
definition test_rule3_full_1 :: rule3_answer where
"test_rule3_full_1 = rule3_to_answer (rule_3_evaluate rule3_case_full_1)"
definition test_rule3_full_2 :: rule3_answer where
"test_rule3_full_2 = rule3_to_answer (rule_3_evaluate rule3_case_full_2)"
definition test_rule3_full_3 :: rule3_answer where
"test_rule3_full_3 = rule3_to_answer (rule_3_evaluate rule3_case_full_3)"
definition test_rule3_incomplete_1 :: rule3_answer where
"test_rule3_incomplete_1 = rule3_to_answer (rule_3_evaluate rule3_case_incomplete_1)"
definition test_rule3_incomplete_2 :: rule3_answer where
"test_rule3_incomplete_2 = rule3_to_answer (rule_3_evaluate rule3_case_incomplete_2)"
definition test_rule3_incomplete_3 :: rule3_answer where
"test_rule3_incomplete_3 = rule3_to_answer (rule_3_evaluate rule3_case_incomplete_3)"
lemma test_rule3_full_3_ok:
  "test_rule3_full_3 = Material_Complete"
  by (simp add:
      test_rule3_full_3_def
      rule3_to_answer_def
      rule_3_evaluate_def
      rule_3_appointment_form_requirements_def
      rule_3_project_leader_verification_def
      rule_3_original_receipts_signatures_def
      rule_3_fund_type_approval_def
      rule_3_electronic_invoice_handling_def
      rule_3_contract_requirements_def
      rule_3_large_sum_payment_requirements_def
      rule_3_special_approval_requirements_def
      rule3_case_full_3_def)
definition rule3_case_full_extra_1 :: rule3_case where
"rule3_case_full_extra_1 \<equiv> \<lparr>
  appointment_form_printed = True,
  fund_ledger_entry_submitted = True,
  appointment_form_signed_by_project_leader = True,
  appointment_form_signed_by_handler = True,
  project_leader_matches_system = True,
  project_leader_authorization_letter_filed = False,
  original_receipts_signed_by_project_leader = True,
  original_receipts_signed_by_handler = True,
  has_single_pen_approval_for_university_funds = True,
  has_research_project_leader_signature = False,
  has_department_approval_for_special_transactions = True,
  electronic_invoice_verified_in_system = True,
  electronic_invoice_selected_in_form = True,
  has_travel_approval = False,
  has_overseas_travel_approval = False,
  has_conference_approval = True,
  has_equipment_purchase_approval = False,
  has_research_fund_transfer_approval = False,
  payment_amount_ge_30000 = True,
  has_signed_contract = True,
  contract_stamped_with_university_seal = True,
  has_contract_for_construction = False,
  payment_amount_gt_50000 = False,
  has_large_sum_payment_application = False,
  large_sum_form_signed_by_leader = False,
  large_sum_form_stamped = False
\<rparr>"
definition rule3_case_full_extra_2 :: rule3_case where
"rule3_case_full_extra_2 \<equiv> rule3_case_full_extra_1\<lparr>
  has_single_pen_approval_for_university_funds := False,
  has_research_project_leader_signature := True
\<rparr>"
definition rule3_case_full_extra_3 :: rule3_case where
"rule3_case_full_extra_3 \<equiv> rule3_case_full_extra_1\<lparr>
  has_single_pen_approval_for_university_funds := True,
  has_research_project_leader_signature := True
\<rparr>"
definition rule3_case_full_extra_4 :: rule3_case where
"rule3_case_full_extra_4 \<equiv> rule3_case_full_extra_1\<lparr>
  has_department_approval_for_special_transactions := False,
  has_conference_approval := False,
  electronic_invoice_verified_in_system := False,
  electronic_invoice_selected_in_form := False
\<rparr>"
definition rule3_case_full_extra_5 :: rule3_case where
"rule3_case_full_extra_5 \<equiv> rule3_case_full_extra_4\<lparr>
  payment_amount_ge_30000 := False,
  has_signed_contract := False,
  contract_stamped_with_university_seal := False
\<rparr>"
definition rule3_case_full_extra_6 :: rule3_case where
"rule3_case_full_extra_6 \<equiv> rule3_case_full_extra_4\<lparr>
  payment_amount_ge_30000 := False,
  has_contract_for_construction := True,
  has_signed_contract := True,
  contract_stamped_with_university_seal := True
\<rparr>"
definition rule3_case_full_extra_7 :: rule3_case where
"rule3_case_full_extra_7 \<equiv> rule3_case_full_extra_1\<lparr>
  payment_amount_gt_50000 := True,
  has_large_sum_payment_application := True,
  large_sum_form_signed_by_leader := True,
  large_sum_form_stamped := True
\<rparr>"
definition rule3_case_full_extra_8 :: rule3_case where
"rule3_case_full_extra_8 \<equiv> rule3_case_full_extra_7\<lparr>
  has_equipment_purchase_approval := True,
  has_conference_approval := False
\<rparr>"
definition rule3_case_full_extra_9 :: rule3_case where
"rule3_case_full_extra_9 \<equiv> rule3_case_full_extra_1\<lparr>
  has_conference_approval := False,
  has_overseas_travel_approval := True
\<rparr>"
definition rule3_case_full_extra_10 :: rule3_case where
"rule3_case_full_extra_10 \<equiv> rule3_case_full_extra_1\<lparr>
  has_conference_approval := False,
  has_research_fund_transfer_approval := True
\<rparr>"
definition rule3_case_full_extra_11 :: rule3_case where
"rule3_case_full_extra_11 \<equiv> rule3_case_full_extra_1\<lparr>
  has_conference_approval := False,
  has_travel_approval := True
\<rparr>"
definition rule3_case_full_extra_12 :: rule3_case where
"rule3_case_full_extra_12 \<equiv> rule3_case_full_extra_1\<lparr>
  electronic_invoice_verified_in_system := False,
  electronic_invoice_selected_in_form := True
\<rparr>"
definition rule3_case_full_extra_13 :: rule3_case where
"rule3_case_full_extra_13 \<equiv> rule3_case_full_extra_1\<lparr>
  payment_amount_ge_30000 := False,
  has_contract_for_construction := True,
  has_signed_contract := True,
  contract_stamped_with_university_seal := True
\<rparr>"
definition rule3_case_full_extra_14 :: rule3_case where
"rule3_case_full_extra_14 \<equiv> rule3_case_full_extra_1\<lparr>
  has_travel_approval := True,
  has_conference_approval := True,
  has_equipment_purchase_approval := True
\<rparr>"
definition rule3_case_full_extra_15 :: rule3_case where
"rule3_case_full_extra_15 \<equiv> rule3_case_full_extra_1\<lparr>
  has_single_pen_approval_for_university_funds := False,
  has_research_project_leader_signature := True,
  has_department_approval_for_special_transactions := False,
  has_conference_approval := False,
  electronic_invoice_verified_in_system := False,
  electronic_invoice_selected_in_form := False
\<rparr>"
definition rule3_case_full_extra_16 :: rule3_case where
"rule3_case_full_extra_16 \<equiv> rule3_case_full_extra_1\<lparr>
  has_department_approval_for_special_transactions := False,
  has_conference_approval := False,
  payment_amount_ge_30000 := True,
  has_signed_contract := True,
  contract_stamped_with_university_seal := True
\<rparr>"
definition rule3_case_full_extra_17 :: rule3_case where
"rule3_case_full_extra_17 \<equiv> rule3_case_full_extra_1\<lparr>
  payment_amount_ge_30000 := False,
  has_contract_for_construction := True,
  payment_amount_gt_50000 := True,
  has_large_sum_payment_application := True,
  large_sum_form_signed_by_leader := True,
  large_sum_form_stamped := True
\<rparr>"
(* ===== 17 Material_Incomplete ===== *)
definition rule3_case_incomplete_extra_1 :: rule3_case where
"rule3_case_incomplete_extra_1 \<equiv> rule3_case_full_extra_1\<lparr>
  appointment_form_printed := False
\<rparr>"
definition rule3_case_incomplete_extra_2 :: rule3_case where
"rule3_case_incomplete_extra_2 \<equiv> rule3_case_full_extra_1\<lparr>
  fund_ledger_entry_submitted := False
\<rparr>"
definition rule3_case_incomplete_extra_3 :: rule3_case where
"rule3_case_incomplete_extra_3 \<equiv> rule3_case_full_extra_1\<lparr>
  original_receipts_signed_by_handler := False
\<rparr>"
definition rule3_case_incomplete_extra_4 :: rule3_case where
"rule3_case_incomplete_extra_4 \<equiv> rule3_case_full_extra_1\<lparr>
  appointment_form_signed_by_handler := False
\<rparr>"
definition rule3_case_incomplete_extra_5 :: rule3_case where
"rule3_case_incomplete_extra_5 \<equiv> rule3_case_full_extra_1\<lparr>
  project_leader_matches_system := False
\<rparr>"
definition rule3_case_incomplete_extra_6 :: rule3_case where
"rule3_case_incomplete_extra_6 \<equiv> rule3_case_full_extra_1\<lparr>
  has_single_pen_approval_for_university_funds := False,
  has_research_project_leader_signature := False
\<rparr>"
definition rule3_case_incomplete_extra_7 :: rule3_case where
"rule3_case_incomplete_extra_7 \<equiv> rule3_case_full_extra_1\<lparr>
  has_department_approval_for_special_transactions := True,
  has_conference_approval := False,
  has_travel_approval := False,
  has_overseas_travel_approval := False,
  has_equipment_purchase_approval := False,
  has_research_fund_transfer_approval := False
\<rparr>"
definition rule3_case_incomplete_extra_8 :: rule3_case where
"rule3_case_incomplete_extra_8 \<equiv> rule3_case_full_extra_1\<lparr>
  electronic_invoice_selected_in_form := False
\<rparr>"
definition rule3_case_incomplete_extra_9 :: rule3_case where
"rule3_case_incomplete_extra_9 \<equiv> rule3_case_full_extra_1\<lparr>
  payment_amount_ge_30000 := True,
  has_signed_contract := False,
  contract_stamped_with_university_seal := False
\<rparr>"
definition rule3_case_incomplete_extra_10 :: rule3_case where
"rule3_case_incomplete_extra_10 \<equiv> rule3_case_full_extra_1\<lparr>
  payment_amount_ge_30000 := False,
  has_contract_for_construction := True,
  has_signed_contract := False
\<rparr>"
definition rule3_case_incomplete_extra_11 :: rule3_case where
"rule3_case_incomplete_extra_11 \<equiv> rule3_case_full_extra_1\<lparr>
  payment_amount_gt_50000 := True,
  has_large_sum_payment_application := True,
  large_sum_form_signed_by_leader := False,
  large_sum_form_stamped := True
\<rparr>"
definition rule3_case_incomplete_extra_12 :: rule3_case where
"rule3_case_incomplete_extra_12 \<equiv> rule3_case_full_extra_1\<lparr>
  has_department_approval_for_special_transactions := False,
  has_conference_approval := False,
  has_travel_approval := True
\<rparr>"
definition rule3_case_incomplete_extra_13 :: rule3_case where
"rule3_case_incomplete_extra_13 \<equiv> rule3_case_full_extra_1\<lparr>
  has_department_approval_for_special_transactions := False,
  has_conference_approval := False,
  has_overseas_travel_approval := True
\<rparr>"
definition rule3_case_incomplete_extra_14 :: rule3_case where
"rule3_case_incomplete_extra_14 \<equiv> rule3_case_full_extra_1\<lparr>
  has_department_approval_for_special_transactions := False,
  has_conference_approval := True
\<rparr>"
definition rule3_case_incomplete_extra_15 :: rule3_case where
"rule3_case_incomplete_extra_15 \<equiv> rule3_case_full_extra_1\<lparr>
  has_department_approval_for_special_transactions := False,
  has_conference_approval := False,
  has_equipment_purchase_approval := True
\<rparr>"
definition rule3_case_incomplete_extra_16 :: rule3_case where
"rule3_case_incomplete_extra_16 \<equiv> rule3_case_full_extra_1\<lparr>
  has_department_approval_for_special_transactions := False,
  has_conference_approval := False,
  has_research_fund_transfer_approval := True
\<rparr>"
definition rule3_case_incomplete_extra_17 :: rule3_case where
"rule3_case_incomplete_extra_17 \<equiv> rule3_case_full_extra_1\<lparr>
  payment_amount_ge_30000 := True,
  has_signed_contract := True,
  contract_stamped_with_university_seal := False
\<rparr>"
(* Rule 4: Negative List for Reimbursement Invoices *)
definition rule4_case_correct_1 :: rule4_case where
"rule4_case_correct_1 \<equiv> \<lparr>
  invoice_lacks_supervision_seal = False,
  invoice_scope_mismatch = False,
  invoice_content_incomplete = False,
  invoice_missing_date = False,
  invoice_missing_quantity = False,
  invoice_missing_unit_price = False,
  invoice_missing_amount = False,
  invoice_missing_description = False,
  invoice_missing_payee_seal = False,
  invoice_amount_figures_words_inconsistent = False,
  invoice_altered = False,
  invoice_forged = False,
  invoice_fraudulent = False,
  taxi_receipts_consecutive_numbers = False,
  taxi_receipts_large_quantity_same_taxi = False,
  reimbursement_procedure_incomplete = False
\<rparr>"
definition rule4_case_error_1 :: rule4_case where
"rule4_case_error_1 \<equiv> rule4_case_correct_1\<lparr>invoice_lacks_supervision_seal := True\<rparr>"
definition rule4_case_error_2 :: rule4_case where
"rule4_case_error_2 \<equiv> rule4_case_correct_1\<lparr>invoice_scope_mismatch := True\<rparr>"
definition rule4_case_error_3 :: rule4_case where
"rule4_case_error_3 \<equiv> rule4_case_correct_1\<lparr>invoice_content_incomplete := True\<rparr>"
definition rule4_case_error_4 :: rule4_case where
"rule4_case_error_4 \<equiv> rule4_case_correct_1\<lparr>invoice_missing_date := True\<rparr>"
definition rule4_case_error_5 :: rule4_case where
"rule4_case_error_5 \<equiv> rule4_case_correct_1\<lparr>invoice_missing_quantity := True\<rparr>"
definition rule4_case_error_6 :: rule4_case where
"rule4_case_error_6 \<equiv> rule4_case_correct_1\<lparr>invoice_missing_unit_price := True\<rparr>"
definition rule4_case_error_7 :: rule4_case where
"rule4_case_error_7 \<equiv> rule4_case_correct_1\<lparr>invoice_missing_amount := True\<rparr>"
definition rule4_case_error_8 :: rule4_case where
"rule4_case_error_8 \<equiv> rule4_case_correct_1\<lparr>invoice_missing_description := True\<rparr>"
definition rule4_case_error_9 :: rule4_case where
"rule4_case_error_9 \<equiv> rule4_case_correct_1\<lparr>invoice_missing_payee_seal := True\<rparr>"
definition rule4_case_error_10 :: rule4_case where
"rule4_case_error_10 \<equiv> rule4_case_correct_1\<lparr>invoice_amount_figures_words_inconsistent := True\<rparr>"
definition rule4_case_error_11 :: rule4_case where
"rule4_case_error_11 \<equiv> rule4_case_correct_1\<lparr>invoice_altered := True\<rparr>"
definition rule4_case_error_12 :: rule4_case where
"rule4_case_error_12 \<equiv> rule4_case_correct_1\<lparr>invoice_forged := True\<rparr>"
definition rule4_case_error_13 :: rule4_case where
"rule4_case_error_13 \<equiv> rule4_case_correct_1\<lparr>invoice_fraudulent := True\<rparr>"
definition rule4_case_error_14 :: rule4_case where
"rule4_case_error_14 \<equiv> rule4_case_correct_1\<lparr>taxi_receipts_consecutive_numbers := True\<rparr>"
definition rule4_case_error_15 :: rule4_case where
"rule4_case_error_15 \<equiv> rule4_case_correct_1\<lparr>taxi_receipts_large_quantity_same_taxi := True\<rparr>"
definition rule4_case_error_16 :: rule4_case where
"rule4_case_error_16 \<equiv> rule4_case_correct_1\<lparr>reimbursement_procedure_incomplete := True\<rparr>"
definition rule4_case_error_17 :: rule4_case where
"rule4_case_error_17 \<equiv> rule4_case_correct_1\<lparr>
  invoice_missing_date := True,
  invoice_missing_amount := True,
  invoice_missing_description := True
\<rparr>"
definition rule4_case_error_18 :: rule4_case where
"rule4_case_error_18 \<equiv> rule4_case_correct_1\<lparr>
  invoice_lacks_supervision_seal := True,
  invoice_scope_mismatch := True,
  invoice_content_incomplete := True
\<rparr>"
definition rule4_case_error_19 :: rule4_case where
"rule4_case_error_19 \<equiv> rule4_case_correct_1\<lparr>
  invoice_altered := True,
  invoice_forged := True,
  invoice_fraudulent := True,
  reimbursement_procedure_incomplete := True
\<rparr>"
(* Rule 6: Reimbursement for Office and Printing Expenses *)
definition rule6_case_a_1 :: rule6_case where "rule6_case_a_1 \<equiv> rule6_base_ok"
definition rule6_case_a_2 :: rule6_case where "rule6_case_a_2 \<equiv> rule6_base_ok\<lparr>expense_computer_accessories := True\<rparr>"
definition rule6_case_a_3 :: rule6_case where "rule6_case_a_3 \<equiv> rule6_base_ok\<lparr>expense_office_furniture := True\<rparr>"
definition rule6_case_a_4 :: rule6_case where "rule6_case_a_4 \<equiv> rule6_base_ok\<lparr>expense_newspapers := True, expense_magazines := True\<rparr>"
definition rule6_case_a_5 :: rule6_case where "rule6_case_a_5 \<equiv> rule6_base_ok\<lparr>expense_drinking_water := True\<rparr>"
definition rule6_case_a_6 :: rule6_case where "rule6_case_a_6 \<equiv> rule6_base_ok\<lparr>expense_cleaning_supplies := True, has_seller_goods_list := False, has_online_shopping_transaction_record := True\<rparr>"
definition rule6_case_a_7 :: rule6_case where "rule6_case_a_7 \<equiv> rule6_base_ok\<lparr>expense_office_stationery := False, expense_books := True, book_expense_has_detailed_list := True\<rparr>"
definition rule6_case_a_8 :: rule6_case where "rule6_case_a_8 \<equiv> rule6_case_a_7\<lparr>single_book_value_ge_1000 := True, book_registered_with_library := True, has_fixed_asset_addition_slip := True\<rparr>"
definition rule6_case_a_9 :: rule6_case where "rule6_case_a_9 \<equiv> rule6_base_ok\<lparr>expense_printing_materials := True, single_invoice_over_1000_for_printing := True, has_detailed_list_for_printing := True\<rparr>"
definition rule6_case_a_10 :: rule6_case where "rule6_case_a_10 \<equiv> rule6_base_ok\<lparr>expense_papers := True, multiple_invoices_around_same_time_over_1000 := True, has_detailed_list_for_printing := True\<rparr>"
definition rule6_case_a_11 :: rule6_case where "rule6_case_a_11 \<equiv> rule6_base_ok\<lparr>expense_exam_papers := True, single_invoice_over_1000_for_printing := True, has_detailed_list_for_printing := True\<rparr>"
definition rule6_case_a_12 :: rule6_case where "rule6_case_a_12 \<equiv> rule6_base_ok\<lparr>expense_promotional_materials := True\<rparr>"
definition rule6_case_a_13 :: rule6_case where "rule6_case_a_13 \<equiv> rule6_base_ok\<lparr>expense_search_fees := True, expense_retrieval_fees := True\<rparr>"
definition rule6_case_a_14 :: rule6_case where "rule6_case_a_14 \<equiv> rule6_base_ok\<lparr>expense_paper_review_fees := True, expense_publication_fees := True, expense_page_charges := True\<rparr>"
definition rule6_case_a_15 :: rule6_case where "rule6_case_a_15 \<equiv> rule6_base_ok\<lparr>expense_monograph_publication_subsidy := True, monograph_publication_has_contract := True\<rparr>"
definition rule6_case_a_16 :: rule6_case where "rule6_case_a_16 \<equiv> rule6_case_a_15\<lparr>contract_party_is_individual_or_department := True, contract_approved_by_project_fund_admin := True\<rparr>"
definition rule6_case_a_17 :: rule6_case where "rule6_case_a_17 \<equiv> rule6_base_ok\<lparr>is_asset_management_office_review_required := True, has_external_purchase_inventory_review_form := True, expense_office_stationery := False, has_seller_goods_list := False\<rparr>"
definition rule6_case_a_18 :: rule6_case where "rule6_case_a_18 \<equiv> rule6_base_ok\<lparr>expense_office_stationery := False, expense_cleaning_supplies := True, is_asset_management_office_review_required := False, has_seller_goods_list := False, has_online_shopping_transaction_record := True\<rparr>"
definition rule6_case_a_19 :: rule6_case where "rule6_case_a_19 \<equiv> rule6_base_ok\<lparr>expense_books := True, book_expense_has_detailed_list := True, single_book_value_ge_1000 := True, book_registered_with_library := True, has_fixed_asset_addition_slip := True, expense_printing_materials := True, single_invoice_over_1000_for_printing := True, has_detailed_list_for_printing := True, expense_monograph_publication_subsidy := True, monograph_publication_has_contract := True, contract_party_is_individual_or_department := True, contract_approved_by_project_fund_admin := True\<rparr>"
definition rule6_case_a_20 :: rule6_case where "rule6_case_a_20 \<equiv> rule6_base_ok\<lparr>expense_office_stationery := False, is_low_value_consumable := False, has_seller_goods_list := False\<rparr>"
definition rule6_case_r_1 :: rule6_case where "rule6_case_r_1 \<equiv> rule6_base_ok\<lparr>artificially_split_invoice_amounts := True\<rparr>"
definition rule6_case_r_2 :: rule6_case where "rule6_case_r_2 \<equiv> rule6_base_ok\<lparr>is_low_value_consumable := False\<rparr>"
definition rule6_case_r_3 :: rule6_case where "rule6_case_r_3 \<equiv> rule6_base_ok\<lparr>expense_computer_accessories := True, is_low_value_consumable := False\<rparr>"
definition rule6_case_r_4 :: rule6_case where "rule6_case_r_4 \<equiv> rule6_base_ok\<lparr>is_asset_management_office_review_required := True, has_external_purchase_inventory_review_form := False\<rparr>"
definition rule6_case_r_5 :: rule6_case where "rule6_case_r_5 \<equiv> rule6_base_ok\<lparr>has_seller_goods_list := False, has_online_shopping_transaction_record := False\<rparr>"
definition rule6_case_r_6 :: rule6_case where "rule6_case_r_6 \<equiv> rule6_base_ok\<lparr>expense_cleaning_supplies := True, has_seller_goods_list := False, has_online_shopping_transaction_record := False\<rparr>"
definition rule6_case_r_7 :: rule6_case where "rule6_case_r_7 \<equiv> rule6_base_ok\<lparr>expense_office_stationery := False, expense_books := True, book_expense_has_detailed_list := False\<rparr>"
definition rule6_case_r_8 :: rule6_case where "rule6_case_r_8 \<equiv> rule6_case_r_7\<lparr>book_expense_has_detailed_list := True, single_book_value_ge_1000 := True, book_registered_with_library := False, has_fixed_asset_addition_slip := True\<rparr>"
definition rule6_case_r_9 :: rule6_case where "rule6_case_r_9 \<equiv> rule6_case_r_7\<lparr>book_expense_has_detailed_list := True, single_book_value_ge_1000 := True, book_registered_with_library := True, has_fixed_asset_addition_slip := False\<rparr>"
definition rule6_case_r_10 :: rule6_case where "rule6_case_r_10 \<equiv> rule6_base_ok\<lparr>single_invoice_over_1000_for_printing := True, has_detailed_list_for_printing := False\<rparr>"
definition rule6_case_r_11 :: rule6_case where "rule6_case_r_11 \<equiv> rule6_base_ok\<lparr>multiple_invoices_around_same_time_over_1000 := True, has_detailed_list_for_printing := False\<rparr>"
definition rule6_case_r_12 :: rule6_case where "rule6_case_r_12 \<equiv> rule6_base_ok\<lparr>expense_monograph_publication_subsidy := True, monograph_publication_has_contract := False\<rparr>"
definition rule6_case_r_13 :: rule6_case where "rule6_case_r_13 \<equiv> rule6_base_ok\<lparr>expense_monograph_publication_subsidy := True, monograph_publication_has_contract := True, contract_party_is_individual_or_department := True, contract_approved_by_project_fund_admin := False\<rparr>"
definition rule6_case_r_14 :: rule6_case where "rule6_case_r_14 \<equiv> rule6_base_ok\<lparr>expense_office_furniture := True, is_low_value_consumable := False\<rparr>"
definition rule6_case_r_15 :: rule6_case where "rule6_case_r_15 \<equiv> rule6_base_ok\<lparr>expense_drinking_water := True, is_low_value_consumable := False\<rparr>"
definition rule6_case_r_16 :: rule6_case where "rule6_case_r_16 \<equiv> rule6_base_ok\<lparr>expense_magazines := True, is_low_value_consumable := False\<rparr>"
definition rule6_case_r_17 :: rule6_case where "rule6_case_r_17 \<equiv> rule6_base_ok\<lparr>expense_office_stationery := False, expense_cleaning_supplies := True, has_seller_goods_list := False, has_online_shopping_transaction_record := False\<rparr>"
definition rule6_case_r_18 :: rule6_case where "rule6_case_r_18 \<equiv> rule6_base_ok\<lparr>expense_monograph_publication_subsidy := True, monograph_publication_has_contract := True, contract_party_is_individual_or_department := True, contract_approved_by_project_fund_admin := False, single_invoice_over_1000_for_printing := True, has_detailed_list_for_printing := False\<rparr>"
definition rule6_case_r_19 :: rule6_case where "rule6_case_r_19 \<equiv> rule6_base_ok\<lparr>expense_books := True, book_expense_has_detailed_list := False, single_book_value_ge_1000 := True, book_registered_with_library := False, has_fixed_asset_addition_slip := False\<rparr>"
definition rule6_case_r_20 :: rule6_case where "rule6_case_r_20 \<equiv> rule6_base_ok\<lparr>is_asset_management_office_review_required := True, has_external_purchase_inventory_review_form := False, expense_monograph_publication_subsidy := True, monograph_publication_has_contract := False\<rparr>"
definition rule6_approval_cases :: "rule6_case list" where
"rule6_approval_cases \<equiv> [
  rule6_case_a_1, rule6_case_a_2, rule6_case_a_3, rule6_case_a_4, rule6_case_a_5,
  rule6_case_a_6, rule6_case_a_7, rule6_case_a_8, rule6_case_a_9, rule6_case_a_10,
  rule6_case_a_11, rule6_case_a_12, rule6_case_a_13, rule6_case_a_14, rule6_case_a_15,
  rule6_case_a_16, rule6_case_a_17, rule6_case_a_18, rule6_case_a_19, rule6_case_a_20 ]"
definition rule6_rejection_cases :: "rule6_case list" where
"rule6_rejection_cases \<equiv> [
  rule6_case_r_1, rule6_case_r_2, rule6_case_r_3, rule6_case_r_4, rule6_case_r_5,
  rule6_case_r_6, rule6_case_r_7, rule6_case_r_8, rule6_case_r_9, rule6_case_r_10,
  rule6_case_r_11, rule6_case_r_12, rule6_case_r_13, rule6_case_r_14, rule6_case_r_15,
  rule6_case_r_16, rule6_case_r_17, rule6_case_r_18, rule6_case_r_19, rule6_case_r_20 ]"
(* ===== Rule4 + Rule6 mixed: only Full / Rejection ===== *)
definition combined_mixed_approval_cases :: "(rule4_case * rule6_case) list" where
"combined_mixed_approval_cases \<equiv> map (\<lambda>c6. (rule4_ok, c6)) rule6_approval_cases"
definition combined_mixed_rejection_cases :: "(rule4_case * rule6_case) list" where
"combined_mixed_rejection_cases \<equiv>
  [ (rule4_bad_1,  rule6_case_a_1),
    (rule4_bad_2,  rule6_case_a_2),
    (rule4_bad_3,  rule6_case_a_3),
    (rule4_bad_4,  rule6_case_a_4),
    (rule4_bad_5,  rule6_case_a_5),
    (rule4_bad_6,  rule6_case_a_6),
    (rule4_bad_7,  rule6_case_a_7),
    (rule4_bad_8,  rule6_case_a_8),
    (rule4_bad_9,  rule6_case_a_9),
    (rule4_bad_10, rule6_case_a_10),
    (rule4_ok, rule6_case_r_1),
    (rule4_ok, rule6_case_r_2),
    (rule4_ok, rule6_case_r_3),
    (rule4_ok, rule6_case_r_4),
    (rule4_ok, rule6_case_r_5),
    (rule4_ok, rule6_case_r_6),
    (rule4_ok, rule6_case_r_7),
    (rule4_ok, rule6_case_r_8),
    (rule4_ok, rule6_case_r_9),
    (rule4_ok, rule6_case_r_10) ]"
definition combined_mixed_all_cases :: "(rule4_case * rule6_case) list" where
"combined_mixed_all_cases \<equiv> combined_mixed_approval_cases @ combined_mixed_rejection_cases"
(* Rule 7: Reimbursement for Travel Expenses *)
definition case7_full_base :: rule7_case where
  "case7_full_base \<equiv> \<lparr>
    has_trip_report_form = True,
    signed_by_unit_head_and_sealed = True,
    unit_head_self_trip_has_other_leader_sign = False,
    is_unit_head_self_trip = False,
    has_intercity_transport_expense = True,
    has_lodging_expense = True,
    has_city_transport_expense = True,
    has_city_transport_receipts = True,
    city_transport_within_budget = True,
    fund_type = Research_Fund,
    person_position = R7P_Bureau_or_Equivalent_Duty,
    chosen_mode = Train,
    chosen_class = Train_First,
    has_contract_specific_transport_rule = False,
    satisfies_contract_transport_rule = False,
    transport_above_standard = False,
    has_transport_special_explanation = False,
    has_project_leader_signature_for_transport_exception = False,
    lodging_rank_of_traveler = Lodging_Bureau,
    lodging_nightly_amount = 600,
    lodging_nights = 2,
    city_key = ''BJ_ALL'',
    travel_month = 5,
    has_intercity_transport_invoice = True,
    has_lodging_invoice = True,
    transport_ticket_unobtainable_in_remote_research = False,
    has_approved_special_explanation_for_transport_no_ticket = False,
    has_other_valid_supporting_docs_for_transport_no_ticket = False,
    lodging_invoice_unobtainable = False,
    has_approved_special_explanation_for_lodging_no_invoice = False,
    has_handwritten_receipt_signed_by_payee = False,
    trip_days_calendar = 3,
    region_type = Other_Region,
    meal_subsidy_claimed_total = 300,
    city_transport_actual_claimed_total = 180,
    city_transport_lump_sum_claimed_total = 0,
    use_city_transport_lump_sum = False,
    intercity_and_lodging_both_paid_by_external_unit = False,
    only_one_of_intercity_or_lodging_paid_by_external_unit = False,
    has_signed_special_explanation_for_partial_external_support = False,
    has_valid_notice_or_invitation_for_partial_external_support = False,
    transport_or_meal_already_paid_by_external_unit = False,
    claimed_transport_or_meal_again_in_school = False,
    uses_self_drive_or_rental = False,
    has_signed_special_explanation_for_self_drive = False,
    rental_fuel_toll_total = 0,
    public_transport_lowest_standard_total = 0,
    is_external_invitee = False,
    external_invitee_transport_lodging_confirmed_by_project_leader = False,
    external_invitee_claims_meal_subsidy = False,
    external_invitee_claims_city_transport_lump_sum = False
  \<rparr>"
(* 3 Full_Approval *)
definition case7_full_1 :: rule7_case where
  "case7_full_1 \<equiv> case7_full_base"
definition case7_full_2 :: rule7_case where
  "case7_full_2 \<equiv> case7_full_base\<lparr>
    is_unit_head_self_trip := True,
    unit_head_self_trip_has_other_leader_sign := True,
    has_city_transport_expense := False,
    city_transport_actual_claimed_total := 0,
    use_city_transport_lump_sum := True,
    city_transport_lump_sum_claimed_total := 240
  \<rparr>"
definition case7_full_3 :: rule7_case where
  "case7_full_3 \<equiv> case7_full_base\<lparr>
    is_external_invitee := True,
    external_invitee_transport_lodging_confirmed_by_project_leader := True,
    external_invitee_claims_meal_subsidy := False,
    external_invitee_claims_city_transport_lump_sum := False
  \<rparr>"
(* 3 Rejection: hard constraints fail *)
definition case7_reject_1 :: rule7_case where
  "case7_reject_1 \<equiv> case7_full_base\<lparr>has_trip_report_form := False\<rparr>"
definition case7_reject_2 :: rule7_case where
  "case7_reject_2 \<equiv> case7_full_base\<lparr>
    has_intercity_transport_invoice := False,
    transport_ticket_unobtainable_in_remote_research := False
  \<rparr>"
definition case7_reject_3 :: rule7_case where
  "case7_reject_3 \<equiv> case7_full_base\<lparr>
    uses_self_drive_or_rental := True,
    has_signed_special_explanation_for_self_drive := False,
    rental_fuel_toll_total := 200,
    public_transport_lowest_standard_total := 300
  \<rparr>"
(* 3 Partial_Approval: hard pass, standard fail *)
definition case7_partial_1 :: rule7_case where
  "case7_partial_1 \<equiv> case7_full_base\<lparr>
    person_position := R7P_Other_Personnel,
    chosen_mode := Air,
    chosen_class := Air_Business,
    transport_above_standard := False
  \<rparr>"
definition case7_partial_2 :: rule7_case where
  "case7_partial_2 \<equiv> case7_full_base\<lparr>
    lodging_nightly_amount := 700
  \<rparr>"
definition case7_partial_3 :: rule7_case where
  "case7_partial_3 \<equiv> case7_full_base\<lparr>
    use_city_transport_lump_sum := True,
    has_city_transport_expense := False,
    city_transport_actual_claimed_total := 0,
    city_transport_lump_sum_claimed_total := 500
  \<rparr>"
definition case7_season_qd_full :: rule7_case where
  "case7_season_qd_full \<equiv> case7_full_base\<lparr>
    city_key := ''QD_ALL'',
    travel_month := 8,
    lodging_rank_of_traveler := Lodging_Bureau,
    lodging_nightly_amount := 580 
  \<rparr>"
definition case7_season_ly_full :: rule7_case where
  "case7_season_ly_full \<equiv> case7_full_base\<lparr>
    city_key := ''HEN_LY'',
    travel_month := 4,  
    lodging_rank_of_traveler := Lodging_Bureau,
    lodging_nightly_amount := 720 
  \<rparr>"
definition case7_season_xz_partial :: rule7_case where
  "case7_season_xz_partial \<equiv> case7_full_base\<lparr>
    city_key := ''XZ_LS'',
    travel_month := 7, 
    lodging_rank_of_traveler := Lodging_Bureau,
    lodging_nightly_amount := 760
  \<rparr>"
(* Rule 7: 20 cases *)
(* ===== 9 cases for rule_7_evaluate ===== *)
definition rule7_base_ok :: rule7_case where
"rule7_base_ok ≡ ⦇
  has_trip_report_form = True,
  signed_by_unit_head_and_sealed = True,
  unit_head_self_trip_has_other_leader_sign = False,
  is_unit_head_self_trip = False,
  has_intercity_transport_expense = True,
  has_lodging_expense = True,
  has_city_transport_expense = True,
  has_city_transport_receipts = True,
  city_transport_within_budget = True,
  fund_type = Research_Fund,
  person_position = R7P_Bureau_or_Equivalent_Duty,
  chosen_mode = Air,
  chosen_class = Air_Economy,
  has_contract_specific_transport_rule = False,
  satisfies_contract_transport_rule = False,
  transport_above_standard = False,
  has_transport_special_explanation = False,
  has_project_leader_signature_for_transport_exception = False,
  lodging_rank_of_traveler = Lodging_Other,
  lodging_nightly_amount = 450,
  lodging_nights = 3,
  city_key = ''BJ_ALL'',
  travel_month = 5,
  has_intercity_transport_invoice = True,
  has_lodging_invoice = True,
  transport_ticket_unobtainable_in_remote_research = False,
  has_approved_special_explanation_for_transport_no_ticket = False,
  has_other_valid_supporting_docs_for_transport_no_ticket = False,
  lodging_invoice_unobtainable = False,
  has_approved_special_explanation_for_lodging_no_invoice = False,
  has_handwritten_receipt_signed_by_payee = False,
  trip_days_calendar = 3,
  region_type = Other_Region,
  meal_subsidy_claimed_total = 240,
  city_transport_actual_claimed_total = 150,
  city_transport_lump_sum_claimed_total = 0,
  use_city_transport_lump_sum = False,
  intercity_and_lodging_both_paid_by_external_unit = False,
  only_one_of_intercity_or_lodging_paid_by_external_unit = False,
  has_signed_special_explanation_for_partial_external_support = False,
  has_valid_notice_or_invitation_for_partial_external_support = False,
  transport_or_meal_already_paid_by_external_unit = False,
  claimed_transport_or_meal_again_in_school = False,
  uses_self_drive_or_rental = False,
  has_signed_special_explanation_for_self_drive = False,
  rental_fuel_toll_total = 0,
  public_transport_lowest_standard_total = 0,
  is_external_invitee = False,
  external_invitee_transport_lodging_confirmed_by_project_leader = False,
  external_invitee_claims_meal_subsidy = False,
  external_invitee_claims_city_transport_lump_sum = False
⦈"
(*********************************)
definition rule7_full_cases :: "rule7_case list" where
"rule7_full_cases \<equiv> [
  rule7_base_ok,
  rule7_base_ok\<lparr>has_contract_specific_transport_rule := True, satisfies_contract_transport_rule := True, chosen_class := Air_Business\<rparr>,
  rule7_base_ok\<lparr>person_position := R7P_Other_Personnel, chosen_mode := Train, chosen_class := Train_Business, transport_above_standard := True, has_transport_special_explanation := True, has_project_leader_signature_for_transport_exception := True\<rparr>,
  rule7_base_ok\<lparr>uses_self_drive_or_rental := True, has_signed_special_explanation_for_self_drive := True, rental_fuel_toll_total := 200, public_transport_lowest_standard_total := 300, has_city_transport_expense := False, city_transport_actual_claimed_total := 0, city_transport_lump_sum_claimed_total := 0\<rparr>,
  rule7_base_ok\<lparr>is_external_invitee := True, external_invitee_transport_lodging_confirmed_by_project_leader := True, external_invitee_claims_meal_subsidy := False, external_invitee_claims_city_transport_lump_sum := False\<rparr>
]"
definition rule7_partial_cases :: "rule7_case list" where
"rule7_partial_cases \<equiv> [
  rule7_base_ok\<lparr>person_position := R7P_Bureau_or_Equivalent_Duty, chosen_mode := Air, chosen_class := Air_Business\<rparr>,
  rule7_base_ok\<lparr>person_position := R7P_Other_Personnel, chosen_mode := Train, chosen_class := Train_Business\<rparr>,
  rule7_base_ok\<lparr>lodging_nightly_amount := 700\<rparr>,
  rule7_base_ok\<lparr>city_key := ''HN_SY'', travel_month := 1, lodging_rank_of_traveler := Lodging_Other, lodging_nightly_amount := 500\<rparr>,
  rule7_base_ok\<lparr>trip_days_calendar := 3, region_type := Other_Region, meal_subsidy_claimed_total := 350\<rparr>,
  rule7_base_ok\<lparr>use_city_transport_lump_sum := True, city_transport_lump_sum_claimed_total := 300, city_transport_actual_claimed_total := 0\<rparr>,
  rule7_base_ok\<lparr>has_city_transport_expense := True, use_city_transport_lump_sum := False, has_city_transport_receipts := False\<rparr>,
  rule7_base_ok\<lparr>has_city_transport_expense := True, use_city_transport_lump_sum := False, city_transport_within_budget := False\<rparr>,
  rule7_base_ok\<lparr>has_contract_specific_transport_rule := True, satisfies_contract_transport_rule := False\<rparr>,
  rule7_base_ok\<lparr>person_position := R7P_Other_Personnel, chosen_mode := Air, chosen_class := Air_Business, transport_above_standard := True, has_transport_special_explanation := True, has_project_leader_signature_for_transport_exception := False\<rparr>
]"
definition rule7_reject_cases :: "rule7_case list" where
"rule7_reject_cases \<equiv> [
  rule7_base_ok\<lparr>has_trip_report_form := False\<rparr>,
  rule7_base_ok\<lparr>has_intercity_transport_expense := True, has_intercity_transport_invoice := False, transport_ticket_unobtainable_in_remote_research := False\<rparr>,
  rule7_base_ok\<lparr>transport_or_meal_already_paid_by_external_unit := True, claimed_transport_or_meal_again_in_school := True\<rparr>,
  rule7_base_ok\<lparr>uses_self_drive_or_rental := True, has_signed_special_explanation_for_self_drive := False, rental_fuel_toll_total := 400, public_transport_lowest_standard_total := 300\<rparr>,
  rule7_base_ok\<lparr>is_external_invitee := True, external_invitee_transport_lodging_confirmed_by_project_leader := True, external_invitee_claims_meal_subsidy := True\<rparr>
]"
definition rule7_all_cases :: "rule7_case list" where
"rule7_all_cases \<equiv> rule7_full_cases @ rule7_partial_cases @ rule7_reject_cases"
(* Rule 7: +5 Full +5 Rejection *)
definition rule7_more_full_1 :: rule7_case where
"rule7_more_full_1 \<equiv> rule7_base_ok\<lparr>
  city_key := ''SH_ALL'',
  travel_month := 6,
  lodging_rank_of_traveler := Lodging_Other,
  lodging_nightly_amount := 480,
  lodging_nights := 2,
  trip_days_calendar := 2,
  meal_subsidy_claimed_total := 180,
  city_transport_actual_claimed_total := 120
\<rparr>"
definition rule7_more_full_2 :: rule7_case where
"rule7_more_full_2 \<equiv> rule7_base_ok\<lparr>
  has_contract_specific_transport_rule := True,
  satisfies_contract_transport_rule := True,
  chosen_class := Air_Business,
  city_key := ''QH_XN'',
  travel_month := 7,
  region_type := Xinjiang_Qinghai_Tibet,
  lodging_nightly_amount := 520
\<rparr>"
definition rule7_more_full_3 :: rule7_case where
"rule7_more_full_3 \<equiv> rule7_base_ok\<lparr>
  uses_self_drive_or_rental := True,
  has_signed_special_explanation_for_self_drive := True,
  rental_fuel_toll_total := 260,
  public_transport_lowest_standard_total := 300,
  has_city_transport_expense := False,
  city_transport_actual_claimed_total := 0,
  city_transport_lump_sum_claimed_total := 0
\<rparr>"
definition rule7_more_full_4 :: rule7_case where
"rule7_more_full_4 \<equiv> rule7_base_ok\<lparr>
  is_external_invitee := True,
  external_invitee_transport_lodging_confirmed_by_project_leader := True,
  external_invitee_claims_meal_subsidy := False,
  external_invitee_claims_city_transport_lump_sum := False,
  meal_subsidy_claimed_total := 0
\<rparr>"
definition rule7_more_full_5 :: rule7_case where
"rule7_more_full_5 \<equiv> rule7_base_ok\<lparr>
  city_key := ''HEN_LY'',
  travel_month := 4,
  lodging_nightly_amount := 480,
  has_intercity_transport_invoice := False,
  transport_ticket_unobtainable_in_remote_research := True,
  has_approved_special_explanation_for_transport_no_ticket := True,
  has_other_valid_supporting_docs_for_transport_no_ticket := True
\<rparr>"
definition rule7_more_reject_1 :: rule7_case where
"rule7_more_reject_1 \<equiv> rule7_base_ok\<lparr>
  is_unit_head_self_trip := True,
  unit_head_self_trip_has_other_leader_sign := False
\<rparr>"
definition rule7_more_reject_2 :: rule7_case where
"rule7_more_reject_2 \<equiv> rule7_base_ok\<lparr>
  has_lodging_expense := True,
  has_lodging_invoice := False,
  lodging_invoice_unobtainable := False
\<rparr>"
definition rule7_more_reject_3 :: rule7_case where
"rule7_more_reject_3 \<equiv> rule7_base_ok\<lparr>
  only_one_of_intercity_or_lodging_paid_by_external_unit := True,
  has_signed_special_explanation_for_partial_external_support := False,
  has_valid_notice_or_invitation_for_partial_external_support := False
\<rparr>"
definition rule7_more_reject_4 :: rule7_case where
"rule7_more_reject_4 \<equiv> rule7_base_ok\<lparr>
  uses_self_drive_or_rental := True,
  has_signed_special_explanation_for_self_drive := True,
  rental_fuel_toll_total := 200,
  public_transport_lowest_standard_total := 300,
  city_transport_actual_claimed_total := 50
\<rparr>"
definition rule7_more_reject_5 :: rule7_case where
"rule7_more_reject_5 \<equiv> rule7_base_ok\<lparr>
  intercity_and_lodging_both_paid_by_external_unit := True,
  meal_subsidy_claimed_total := 100
\<rparr>"
definition rule7_more_full_cases :: "rule7_case list" where
"rule7_more_full_cases \<equiv> [rule7_more_full_1, rule7_more_full_2, rule7_more_full_3, rule7_more_full_4, rule7_more_full_5]"
definition rule7_more_reject_cases :: "rule7_case list" where
"rule7_more_reject_cases \<equiv> [rule7_more_reject_1, rule7_more_reject_2, rule7_more_reject_3, rule7_more_reject_4, rule7_more_reject_5]"
definition rule7v2_full_amount_cases :: "rule7v2_amount_case list" where
"rule7v2_full_amount_cases \<equiv> [
  mk_rule7v2_case rule7_base_ok 1200 1300,
  mk_rule7v2_case (rule7_base_ok\<lparr>person_position := R7P_Academician, chosen_mode := Air, chosen_class := Air_First, city_key := ''SH_ALL'', travel_month := 6, lodging_rank_of_traveler := Lodging_Ministerial, lodging_nightly_amount := 1050, lodging_nights := 2, trip_days_calendar := 2, meal_subsidy_claimed_total := 180, city_transport_actual_claimed_total := 90\<rparr>) 2600 2100,
  mk_rule7v2_case (rule7_base_ok\<lparr>person_position := R7P_Academician, chosen_mode := Train, chosen_class := Train_Business, city_key := ''TJ_CORE'', travel_month := 4, lodging_rank_of_traveler := Lodging_Bureau, lodging_nightly_amount := 470\<rparr>) 1800 1410,
  mk_rule7v2_case (rule7_base_ok\<lparr>person_position := R7P_Other_Personnel, chosen_mode := Train, chosen_class := Train_Second, city_key := ''SZ_ALL'', travel_month := 10, lodging_nightly_amount := 430, lodging_nights := 4, trip_days_calendar := 4, meal_subsidy_claimed_total := 320\<rparr>) 900 1720,
  mk_rule7v2_case (rule7_base_ok\<lparr>person_position := R7P_Bureau_or_Equivalent_Duty, chosen_mode := Ship, chosen_class := Ship_Second, city_key := ''HEB_MAIN'', travel_month := 5, lodging_nightly_amount := 340, lodging_nights := 2, trip_days_calendar := 2, meal_subsidy_claimed_total := 150\<rparr>) 700 680,
  mk_rule7v2_case (rule7_base_ok\<lparr>person_position := R7P_Other_Personnel, chosen_mode := Ship, chosen_class := Ship_Third, city_key := ''GX_OTHER'', travel_month := 3, lodging_nightly_amount := 320\<rparr>) 560 960,
  mk_rule7v2_case (rule7_base_ok\<lparr>person_position := R7P_Academician, chosen_mode := Other_Mode, chosen_class := Other_Class, city_key := ''QD_ALL'', travel_month := 8, lodging_nightly_amount := 440\<rparr>) 1300 1320,
  mk_rule7v2_case (rule7_base_ok\<lparr>has_contract_specific_transport_rule := True, satisfies_contract_transport_rule := True, person_position := R7P_Other_Personnel, chosen_mode := Air, chosen_class := Air_Business, city_key := ''HN_SY'', travel_month := 1, lodging_nightly_amount := 470, lodging_nights := 4, trip_days_calendar := 4, meal_subsidy_claimed_total := 360\<rparr>) 2800 1880,
  mk_rule7v2_case (rule7_base_ok\<lparr>uses_self_drive_or_rental := True, has_signed_special_explanation_for_self_drive := True, rental_fuel_toll_total := 250, public_transport_lowest_standard_total := 300, has_city_transport_expense := False, city_transport_actual_claimed_total := 0, city_transport_lump_sum_claimed_total := 0, city_key := ''JS_OTHER'', travel_month := 9, lodging_nightly_amount := 350\<rparr>) 0 1050,
  mk_rule7v2_case (rule7_base_ok\<lparr>is_external_invitee := True, external_invitee_transport_lodging_confirmed_by_project_leader := True, meal_subsidy_claimed_total := 0, city_key := ''FJ_CORE'', travel_month := 11, lodging_nightly_amount := 360\<rparr>) 900 1080,
  mk_rule7v2_case (rule7_base_ok\<lparr>use_city_transport_lump_sum := True, city_transport_actual_claimed_total := 0, city_transport_lump_sum_claimed_total := 160, trip_days_calendar := 2, city_key := ''AH_ALL'', travel_month := 6, lodging_nightly_amount := 340, lodging_nights := 2\<rparr>) 760 680,
  mk_rule7v2_case (rule7_base_ok\<lparr>has_intercity_transport_expense := False, city_key := ''NB_ALL'', travel_month := 5, lodging_nightly_amount := 330\<rparr>) 0 990,
  mk_rule7v2_case (rule7_base_ok\<lparr>has_lodging_expense := False, city_key := ''JX_ALL'', travel_month := 7, lodging_nightly_amount := 340, lodging_nights := 0\<rparr>) 840 0,
  mk_rule7v2_case (rule7_base_ok\<lparr>has_intercity_transport_invoice := False, transport_ticket_unobtainable_in_remote_research := True, has_approved_special_explanation_for_transport_no_ticket := True, has_other_valid_supporting_docs_for_transport_no_ticket := True, city_key := ''SC_CD'', travel_month := 6, lodging_nightly_amount := 360\<rparr>) 1100 1080,
  mk_rule7v2_case (rule7_base_ok\<lparr>has_lodging_invoice := False, lodging_invoice_unobtainable := True, has_approved_special_explanation_for_lodging_no_invoice := True, has_handwritten_receipt_signed_by_payee := True, city_key := ''YN_CORE'', travel_month := 8, lodging_nightly_amount := 360\<rparr>) 1000 1080,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''HEN_LY'', travel_month := 4, lodging_nightly_amount := 490, lodging_nights := 2, trip_days_calendar := 2, meal_subsidy_claimed_total := 180\<rparr>) 760 980,
  mk_rule7v2_case (rule7_base_ok\<lparr>region_type := Xinjiang_Qinghai_Tibet, city_key := ''XZ_LS'', travel_month := 8, lodging_nightly_amount := 520, lodging_nights := 4, trip_days_calendar := 4, meal_subsidy_claimed_total := 460\<rparr>) 1500 2080,
  mk_rule7v2_case (rule7_base_ok\<lparr>region_type := Xinjiang_Qinghai_Tibet, city_key := ''QH_XN'', travel_month := 7, lodging_nightly_amount := 500, lodging_nights := 3, trip_days_calendar := 3, meal_subsidy_claimed_total := 330\<rparr>) 980 1500,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''SN_YLQ'', travel_month := 6, lodging_nightly_amount := 250, lodging_nights := 3\<rparr>) 700 750,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''GS_OTHER'', travel_month := 11, lodging_nightly_amount := 300, lodging_nights := 3\<rparr>) 780 900
]"
(* ===== 20 Partial ===== *)
definition rule7v2_partial_amount_cases :: "rule7v2_amount_case list" where
"rule7v2_partial_amount_cases \<equiv> [
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''UNKNOWN_CITY''\<rparr>) 1200 1400,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''SH_ALL'', travel_month := 5, lodging_nightly_amount := 520\<rparr>) 1300 1560,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''QD_ALL'', travel_month := 8, lodging_nightly_amount := 480\<rparr>) 1000 1440,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''HEN_LY'', travel_month := 4, lodging_nightly_amount := 560, lodging_nights := 2, trip_days_calendar := 2, meal_subsidy_claimed_total := 180\<rparr>) 900 1120,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''XZ_OTHER'', travel_month := 7, region_type := Xinjiang_Qinghai_Tibet, lodging_nightly_amount := 380\<rparr>) 900 1140,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''QH_XN'', travel_month := 7, region_type := Xinjiang_Qinghai_Tibet, lodging_nightly_amount := 600\<rparr>) 900 1800,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''QH_HB_HN'', travel_month := 6, region_type := Xinjiang_Qinghai_Tibet, lodging_nightly_amount := 400\<rparr>) 920 1200,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''HN_HK_WC_CM'', travel_month := 12, lodging_nightly_amount := 470, lodging_nights := 2\<rparr>) 860 940,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''GX_GL_BH'', travel_month := 2, lodging_nightly_amount := 450\<rparr>) 880 1350,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''DL_ALL'', travel_month := 8, lodging_nightly_amount := 450\<rparr>) 960 1350,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''HEB_ZJK'', travel_month := 1, lodging_nightly_amount := 560\<rparr>) 900 1680,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''XZ_LS'', travel_month := 8, region_type := Xinjiang_Qinghai_Tibet, lodging_nightly_amount := 560\<rparr>) 980 1680,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''QH_HX'', travel_month := 6, region_type := Xinjiang_Qinghai_Tibet, lodging_nightly_amount := 320\<rparr>) 860 960,
  mk_rule7v2_case (rule7_base_ok\<lparr>city_key := ''SN_YLQ'', travel_month := 6, lodging_nightly_amount := 300\<rparr>) 700 900,
  mk_rule7v2_case (rule7_base_ok\<lparr>trip_days_calendar := 2, meal_subsidy_claimed_total := 250, city_key := ''JS_CORE'', travel_month := 5, lodging_nightly_amount := 360, lodging_nights := 2\<rparr>) 700 720,
  mk_rule7v2_case (rule7_base_ok\<lparr>use_city_transport_lump_sum := True, city_transport_actual_claimed_total := 0, city_transport_lump_sum_claimed_total := 200, trip_days_calendar := 2, city_key := ''AH_ALL'', travel_month := 6, lodging_nightly_amount := 340, lodging_nights := 2\<rparr>) 760 680,
  mk_rule7v2_case (rule7_base_ok\<lparr>person_position := R7P_Academician, chosen_mode := Air, chosen_class := Air_Economy, city_key := ''SC_CD'', travel_month := 6, lodging_nightly_amount := 360\<rparr>) 1200 1080,
  mk_rule7v2_case (rule7_base_ok\<lparr>person_position := R7P_Bureau_or_Equivalent_Duty, chosen_mode := Train, chosen_class := Train_Business, city_key := ''FJ_OTHER'', travel_month := 10, lodging_nightly_amount := 340\<rparr>) 960 1020,
  mk_rule7v2_case (rule7_base_ok\<lparr>person_position := R7P_Other_Personnel, chosen_mode := Ship, chosen_class := Ship_Second, city_key := ''GX_OTHER'', travel_month := 4, lodging_nightly_amount := 320\<rparr>) 700 960,
  mk_rule7v2_case (rule7_base_ok\<lparr>person_position := R7P_Bureau_or_Equivalent_Duty, chosen_mode := Air, chosen_class := Air_Business, transport_above_standard := True, has_transport_special_explanation := False, has_project_leader_signature_for_transport_exception := True, city_key := ''BJ_ALL'', travel_month := 6, lodging_nightly_amount := 480\<rparr>) 1800 1440
]"
definition rule7v2_amount_cases :: "rule7v2_amount_case list" where
"rule7v2_amount_cases \<equiv> rule7v2_full_amount_cases @ rule7v2_partial_amount_cases"
value "map rule7v2_amount_decision rule7v2_full_amount_cases"
value "map rule7v2_amount_decision rule7v2_partial_amount_cases"
value "map rule7v2_amount_decision rule7v2_amount_cases"
(* Rule 8: Reimbursement for Overseas Travel (Exit-Entry) *)
definition rule8_base_ok :: rule8_case where
"rule8_base_ok ≡ ⦇
  has_foreign_affairs_office_approval = True,
  has_overseas_expense_statement = True,
  expense_statement_includes_registration_fees = True,
  expense_statement_includes_living_allowance = True,
  expense_statement_includes_incidental_expenses = True,
  expense_statement_includes_transportation = True,
  airfare_expense_with_boarding_pass = True,
  accommodation_expense_with_receipts = False,
  conference_registration_fees_with_receipts = False,
  inter_city_transportation_with_receipts = False,
  visa_fees_with_receipts = False,
  insurance_fees_with_receipts = False,
  reviewed_by_foreign_affairs_travel_center = True,
  signed_by_foreign_affairs_travel_center = True,
  is_research_project_fund = False,
  is_non_research_project_fund = True,
  overseas_traveler_role = Role_Division_Chief_And_Below,
  travel_by_first_class_air = False,
  travel_by_business_class_air = False,
  travel_by_economy_class_air = True,
  travel_by_high_grade_soft_sleeper_rail = False,
  travel_by_soft_sleeper_rail = False,
  travel_by_hard_seat_rail = True,
  travel_by_business_class_hsr = False,
  travel_by_first_class_hsr = False,
  travel_by_second_class_hsr = False,
  travel_by_first_class_ship = False,
  travel_by_second_class_ship = False,
  travel_by_third_class_ship = True,
  international_airfare_paid_by_business_card = True,
  international_airfare_paid_by_bank_transfer = False,
  accommodation_paid_by_business_card = False,
  accommodation_paid_by_bank_transfer = True,
  expenses_prepaid_for_future_travel = False,
  reimbursement_completed_after_return = True,
  travel_advance_for_airfare_arranged = False,
  travel_advance_for_accommodation_arranged = False,
  trip_duration_over_one_month = False,
  has_special_circumstances_for_advance = False,
  all_overseas_expenses_reimbursed_together = True,
  books_purchased_overseas = False,
  materials_purchased_overseas = False,
  books_reimbursed_with_overseas_expenses = False,
  materials_reimbursed_with_overseas_expenses = False,
  foreign_website_purchase_without_formal_receipts = False,
  printed_purchase_records_provided = False,
  authenticity_statement_attached = False,
  exclusivity_statement_attached = False,
  foreign_currency_selected_in_appointment = True,
  foreign_currency_converted_by_system = True,
  foreign_currency_converted_manually = False,
  exchange_rate_proof_attached = False,
  multiple_currencies_cannot_be_scheduled = False
⦈"
definition rule8_full_cases :: "rule8_case list" where
"rule8_full_cases \<equiv> [
  rule8_base_ok,
  rule8_base_ok\<lparr>is_research_project_fund := True, is_non_research_project_fund := False, travel_by_business_class_air := True, travel_by_economy_class_air := False\<rparr>,
  rule8_base_ok\<lparr>overseas_traveler_role := Role_Bureau_Director_Level, travel_by_economy_class_air := True, travel_by_hard_seat_rail := False, travel_by_second_class_hsr := True, travel_by_third_class_ship := False\<rparr>,
  rule8_base_ok\<lparr>overseas_traveler_role := Role_National_Mgmt_Post_Level2_OrAbove, travel_by_first_class_air := True, travel_by_economy_class_air := False\<rparr>,
  rule8_base_ok\<lparr>foreign_currency_converted_by_system := False, multiple_currencies_cannot_be_scheduled := True, foreign_currency_converted_manually := True, exchange_rate_proof_attached := True\<rparr>
]"
definition rule8_partial_cases :: "rule8_case list" where
"rule8_partial_cases \<equiv> [
  rule8_base_ok\<lparr>travel_by_economy_class_air := False\<rparr>,
  rule8_base_ok\<lparr>travel_by_hard_seat_rail := False, travel_by_second_class_hsr := False\<rparr>,
  rule8_base_ok\<lparr>travel_by_third_class_ship := False\<rparr>,
  rule8_base_ok\<lparr>overseas_traveler_role := Role_Bureau_Director_Level, travel_by_first_class_air := True\<rparr>,
  rule8_base_ok\<lparr>overseas_traveler_role := Role_Bureau_Director_Level, travel_by_high_grade_soft_sleeper_rail := True\<rparr>,
  rule8_base_ok\<lparr>overseas_traveler_role := Role_Bureau_Director_Level, travel_by_business_class_hsr := True\<rparr>,
  rule8_base_ok\<lparr>overseas_traveler_role := Role_Bureau_Director_Level, travel_by_first_class_ship := True\<rparr>,
  rule8_base_ok\<lparr>overseas_traveler_role := Role_Bureau_Director_Level, travel_by_first_class_air := True, travel_by_business_class_hsr := True\<rparr>,
  rule8_base_ok\<lparr>travel_by_economy_class_air := False, travel_by_hard_seat_rail := False, travel_by_second_class_hsr := False, travel_by_third_class_ship := False\<rparr>,
  rule8_base_ok\<lparr>overseas_traveler_role := Role_Bureau_Director_Level, travel_by_first_class_air := True\<rparr>
]"
definition rule8_reject_cases :: "rule8_case list" where
"rule8_reject_cases \<equiv> [
  rule8_base_ok\<lparr>has_foreign_affairs_office_approval := False\<rparr>,
  rule8_base_ok\<lparr>airfare_expense_with_boarding_pass := True, reviewed_by_foreign_affairs_travel_center := False, signed_by_foreign_affairs_travel_center := False\<rparr>,
  rule8_base_ok\<lparr>international_airfare_paid_by_business_card := False, international_airfare_paid_by_bank_transfer := False\<rparr>,
  rule8_base_ok\<lparr>all_overseas_expenses_reimbursed_together := False\<rparr>,
  rule8_base_ok\<lparr>foreign_currency_selected_in_appointment := True, foreign_currency_converted_by_system := False, multiple_currencies_cannot_be_scheduled := False, foreign_currency_converted_manually := False\<rparr>
]"
definition rule8_all_cases :: "rule8_case list" where
"rule8_all_cases \<equiv> rule8_full_cases @ rule8_partial_cases @ rule8_reject_cases"
(* Rule 8: +5 Full +5 Rejection *)
definition rule8_more_full_1 :: rule8_case where
"rule8_more_full_1 \<equiv> rule8_base_ok\<lparr>
  accommodation_expense_with_receipts := True
\<rparr>"
definition rule8_more_full_2 :: rule8_case where
"rule8_more_full_2 \<equiv> rule8_base_ok\<lparr>
  is_research_project_fund := True,
  is_non_research_project_fund := False,
  overseas_traveler_role := Role_National_Mgmt_Post_Level2_OrAbove,
  travel_by_first_class_air := True,
  travel_by_economy_class_air := False
\<rparr>"
definition rule8_more_full_3 :: rule8_case where
"rule8_more_full_3 \<equiv> rule8_base_ok\<lparr>
  overseas_traveler_role := Role_Bureau_Director_Level,
  travel_by_economy_class_air := False,
  travel_by_business_class_air := True,
  travel_by_hard_seat_rail := False,
  travel_by_second_class_hsr := True,
  travel_by_third_class_ship := False
\<rparr>"
definition rule8_more_full_4 :: rule8_case where
"rule8_more_full_4 \<equiv> rule8_base_ok\<lparr>
  foreign_currency_converted_by_system := False,
  multiple_currencies_cannot_be_scheduled := True,
  foreign_currency_converted_manually := True,
  exchange_rate_proof_attached := True
\<rparr>"
definition rule8_more_full_5 :: rule8_case where
"rule8_more_full_5 \<equiv> rule8_base_ok\<lparr>
  books_purchased_overseas := True,
  materials_purchased_overseas := True,
  books_reimbursed_with_overseas_expenses := True,
  materials_reimbursed_with_overseas_expenses := True,
  foreign_website_purchase_without_formal_receipts := True,
  printed_purchase_records_provided := True,
  authenticity_statement_attached := True,
  exclusivity_statement_attached := True
\<rparr>"
definition rule8_more_reject_1 :: rule8_case where
"rule8_more_reject_1 \<equiv> rule8_base_ok\<lparr>
  has_overseas_expense_statement := False
\<rparr>"
definition rule8_more_reject_2 :: rule8_case where
"rule8_more_reject_2 \<equiv> rule8_base_ok\<lparr>
  conference_registration_fees_with_receipts := True,
  reviewed_by_foreign_affairs_travel_center := True,
  signed_by_foreign_affairs_travel_center := False
\<rparr>"
definition rule8_more_reject_3 :: rule8_case where
"rule8_more_reject_3 \<equiv> rule8_base_ok\<lparr>
  expenses_prepaid_for_future_travel := True,
  reimbursement_completed_after_return := True
\<rparr>"
definition rule8_more_reject_4 :: rule8_case where
"rule8_more_reject_4 \<equiv> rule8_base_ok\<lparr>
  foreign_website_purchase_without_formal_receipts := True,
  printed_purchase_records_provided := False,
  authenticity_statement_attached := False,
  exclusivity_statement_attached := False
\<rparr>"
definition rule8_more_reject_5 :: rule8_case where
"rule8_more_reject_5 \<equiv> rule8_base_ok\<lparr>
  foreign_currency_selected_in_appointment := True,
  foreign_currency_converted_by_system := False,
  multiple_currencies_cannot_be_scheduled := True,
  foreign_currency_converted_manually := True,
  exchange_rate_proof_attached := False
\<rparr>"
definition rule8_more_full_cases :: "rule8_case list" where
"rule8_more_full_cases \<equiv> [rule8_more_full_1, rule8_more_full_2, rule8_more_full_3, rule8_more_full_4, rule8_more_full_5]"
definition rule8_more_reject_cases :: "rule8_case list" where
"rule8_more_reject_cases \<equiv> [rule8_more_reject_1, rule8_more_reject_2, rule8_more_reject_3, rule8_more_reject_4, rule8_more_reject_5]"
(* Rule 9: Reimbursement for Conference Fees *)
definition case9_base_full :: rule9_case where
  "case9_base_full \<equiv> \<lparr>
    fund_type = R9_Research,
    conf_scope = R9_Domestic_Business,
    domestic_class = R9_Class1,
    intl_class = R9_Intl2,
    attendee_count = 100,
    conference_days = 2,
    has_lodging_arranged = True,
    has_meal_arranged = True,
    actual_lodging_ppd = 480,
    actual_meal_ppd = 150,
    actual_other_ppd = 100,
    actual_total_ppd = 730,
    excluded_items_within_budget = True,
    has_notice_and_agenda = True,
    has_budget_form = True,
    has_expense_detail_list = True,
    has_signin_sheet_with_org = True,
    has_service_invoices = True,
    has_original_supporting_docs = True,
    has_e_settlement_docs = True,
    has_contract_or_agreement = True,
    reimbursed_in_single_batch = True,
    split_reimbursement_needed_by_channel = False,
    each_channel_reimbursed_once = False,
    previous_channel_details_listed = False,
    is_regular_work_meeting_or_seminar = False,
    has_work_meal = False,
    has_work_meal_attendee_list_and_detail = False,
    work_meal_standard_pp = 0,
    has_advance_payment = False,
    advance_ratio_percent = 0,
    advance_has_notice_and_agenda = False,
    advance_has_budget_form = False,
    advance_has_related_contract = False,
    advance_has_intl_approval_if_intl = False,
    has_foreign_guests_in_domestic_conf = False,
    approved_by_foreign_affairs_office = False,
    duration_days = 2,
    in_shanghai_attendee_ratio_percent = 40,
    held_outside_shanghai = False,
    held_in_prohibited_scenic_area = False,
    venue_rent_ppd = 200,
    equipment_rent_ppd = 100,
    cold_meal_pp_once = 180,
    staff_count = 8,
    resident_staff_count = 3,
    staff_board_ppd = 400,
    volunteer_subsidy_ppd = 80,
    interpretation_labor_ppd = 5000,
    interpretation_is_un_language = True,
    written_translation_per_thousand = 180,
    sim_interpret_and_office_rent_ppd = 100,
    bus_cost_per_vehicle_day = 1000,
    bus_seats = 20,
    other_service_ppd = 100
  \<rparr>"
(* 3 Full *)
definition case9_full_1 :: rule9_case where
  "case9_full_1 \<equiv> case9_base_full"
definition case9_full_2 :: rule9_case where
  "case9_full_2 \<equiv> case9_base_full\<lparr>
    conf_scope := R9_Domestic_Management,
    conference_days := 1,
    duration_days := 1,
    has_lodging_arranged := False,
    actual_lodging_ppd := 0,
    actual_meal_ppd := 130,
    actual_other_ppd := 80,
    actual_total_ppd := 210
  \<rparr>"
definition case9_full_3 :: rule9_case where
  "case9_full_3 \<equiv> case9_base_full\<lparr>
    fund_type := R9_NonResearch,
    conf_scope := R9_International_In_China,
    intl_class := R9_Intl2,
    conference_days := 2,
    duration_days := 2,
    actual_lodging_ppd := 300,
    actual_meal_ppd := 200,
    actual_other_ppd := 250,
    actual_total_ppd := 750,
    venue_rent_ppd := 200,
    equipment_rent_ppd := 100,
    cold_meal_pp_once := 220,
    staff_count := 10,
    resident_staff_count := 5,
    staff_board_ppd := 450,
    volunteer_subsidy_ppd := 100,
    interpretation_is_un_language := False,
    interpretation_labor_ppd := 6000,
    written_translation_per_thousand := 200,
    sim_interpret_and_office_rent_ppd := 100,
    bus_seats := 30,
    bus_cost_per_vehicle_day := 1500,
    other_service_ppd := 100
  \<rparr>"
(* 6 Partial *)
definition case9_partial_1 :: rule9_case where
  "case9_partial_1 \<equiv> case9_base_full\<lparr>
    actual_lodging_ppd := 500,
    actual_meal_ppd := 150,
    actual_other_ppd := 110,
    actual_total_ppd := 760
  \<rparr>"
definition case9_partial_2 :: rule9_case where
  "case9_partial_2 \<equiv> case9_base_full\<lparr>
    fund_type := R9_NonResearch,
    conf_scope := R9_Domestic_Management,
    domestic_class := R9_Class34,
    conference_days := 1,
    duration_days := 1,
    actual_lodging_ppd := 340,
    actual_meal_ppd := 130,
    actual_other_ppd := 90,
    actual_total_ppd := 560
  \<rparr>"
definition case9_partial_3 :: rule9_case where
  "case9_partial_3 \<equiv> case9_base_full\<lparr>
    has_meal_arranged := False,
    actual_lodging_ppd := 500,
    actual_meal_ppd := 100,
    actual_other_ppd := 50,
    actual_total_ppd := 650
  \<rparr>"
definition case9_partial_4 :: rule9_case where
  "case9_partial_4 \<equiv> case9_base_full\<lparr>
    conf_scope := R9_Domestic_Management,
    conference_days := 1,
    duration_days := 1,
    has_lodging_arranged := False,
    has_meal_arranged := False,
    actual_lodging_ppd := 0,
    actual_meal_ppd := 30,
    actual_other_ppd := 90,
    actual_total_ppd := 120
  \<rparr>"
definition case9_partial_5 :: rule9_case where
  "case9_partial_5 \<equiv> case9_full_3\<lparr>
    intl_class := R9_Intl1,
    venue_rent_ppd := 350
  \<rparr>"
definition case9_partial_6 :: rule9_case where
  "case9_partial_6 \<equiv> case9_full_3\<lparr>
    intl_class := R9_Intl3,
    cold_meal_pp_once := 200
  \<rparr>"
(* 3 Rejection *)
definition case9_reject_1 :: rule9_case where
  "case9_reject_1 \<equiv> case9_base_full\<lparr>
    has_notice_and_agenda := False
  \<rparr>"
definition case9_reject_2 :: rule9_case where
  "case9_reject_2 \<equiv> case9_base_full\<lparr>
    conference_days := 3,
    duration_days := 3
  \<rparr>"
definition case9_reject_3 :: rule9_case where
  "case9_reject_3 \<equiv> case9_base_full\<lparr>
    has_foreign_guests_in_domestic_conf := True,
    approved_by_foreign_affairs_office := False
  \<rparr>"
definition case9_full_extra_1 :: rule9_case where
  "case9_full_extra_1 \<equiv> case9_base_full\<lparr>attendee_count := 50\<rparr>"
definition case9_full_extra_2 :: rule9_case where
  "case9_full_extra_2 \<equiv> case9_base_full\<lparr>
    reimbursed_in_single_batch := False,
    split_reimbursement_needed_by_channel := True,
    each_channel_reimbursed_once := True,
    previous_channel_details_listed := True
  \<rparr>"
definition case9_full_extra_3 :: rule9_case where
  "case9_full_extra_3 \<equiv> case9_base_full\<lparr>
    is_regular_work_meeting_or_seminar := True,
    has_work_meal := True,
    has_work_meal_attendee_list_and_detail := True,
    work_meal_standard_pp := 50
  \<rparr>"
definition case9_full_extra_4 :: rule9_case where
  "case9_full_extra_4 \<equiv> case9_base_full\<lparr>
    has_advance_payment := True,
    advance_ratio_percent := 20,
    advance_has_notice_and_agenda := True,
    advance_has_budget_form := True,
    advance_has_related_contract := True
  \<rparr>"
definition case9_full_extra_5 :: rule9_case where
  "case9_full_extra_5 \<equiv> case9_base_full\<lparr>
    has_advance_payment := True,
    advance_ratio_percent := 30,
    advance_has_notice_and_agenda := True,
    advance_has_budget_form := True,
    advance_has_related_contract := True
  \<rparr>"
definition case9_full_extra_6 :: rule9_case where
  "case9_full_extra_6 \<equiv> case9_base_full\<lparr>
    has_foreign_guests_in_domestic_conf := True,
    approved_by_foreign_affairs_office := True
  \<rparr>"
definition case9_full_extra_7 :: rule9_case where
  "case9_full_extra_7 \<equiv> case9_base_full\<lparr>
    conference_days := 1, duration_days := 1,
    actual_lodging_ppd := 450, actual_meal_ppd := 130, actual_other_ppd := 90, actual_total_ppd := 670
  \<rparr>"
definition case9_full_extra_8 :: rule9_case where
  "case9_full_extra_8 \<equiv> case9_base_full\<lparr>
    conf_scope := R9_Domestic_Management,
    conference_days := 1, duration_days := 1,
    actual_lodging_ppd := 340, actual_meal_ppd := 130, actual_other_ppd := 70, actual_total_ppd := 540
  \<rparr>"
definition case9_full_extra_9 :: rule9_case where
  "case9_full_extra_9 \<equiv> case9_base_full\<lparr>
    fund_type := R9_NonResearch, conf_scope := R9_Domestic_Business, domestic_class := R9_Class1,
    actual_lodging_ppd := 500, actual_meal_ppd := 150, actual_other_ppd := 110, actual_total_ppd := 760
  \<rparr>"
definition case9_full_extra_10 :: rule9_case where
  "case9_full_extra_10 \<equiv> case9_base_full\<lparr>
    fund_type := R9_NonResearch, conf_scope := R9_Domestic_Business, domestic_class := R9_Class2,
    actual_lodging_ppd := 400, actual_meal_ppd := 150, actual_other_ppd := 100, actual_total_ppd := 650
  \<rparr>"
definition case9_full_extra_11 :: rule9_case where
  "case9_full_extra_11 \<equiv> case9_base_full\<lparr>
    fund_type := R9_NonResearch, conf_scope := R9_Domestic_Business, domestic_class := R9_Class34,
    actual_lodging_ppd := 340, actual_meal_ppd := 130, actual_other_ppd := 80, actual_total_ppd := 550
  \<rparr>"
definition case9_full_extra_12 :: rule9_case where
  "case9_full_extra_12 \<equiv> case9_base_full\<lparr>
    fund_type := R9_Research, conf_scope := R9_International_In_China,
    conference_days := 2, duration_days := 2,
    actual_lodging_ppd := 650, actual_meal_ppd := 180, actual_other_ppd := 270, actual_total_ppd := 1100
  \<rparr>"
definition case9_full_extra_13 :: rule9_case where
  "case9_full_extra_13 \<equiv> case9_base_full\<lparr>
    fund_type := R9_Research, conf_scope := R9_International_In_China,
    has_lodging_arranged := False, has_meal_arranged := True,
    conference_days := 2, duration_days := 2,
    actual_lodging_ppd := 0, actual_meal_ppd := 200, actual_other_ppd := 300, actual_total_ppd := 500
  \<rparr>"
definition case9_full_extra_14 :: rule9_case where
  "case9_full_extra_14 \<equiv> case9_base_full\<lparr>
    fund_type := R9_Research, conf_scope := R9_International_In_China,
    has_lodging_arranged := True, has_meal_arranged := False,
    conference_days := 2, duration_days := 2,
    actual_lodging_ppd := 700, actual_meal_ppd := 0, actual_other_ppd := 300, actual_total_ppd := 1000
  \<rparr>"
definition case9_full_extra_15 :: rule9_case where
  "case9_full_extra_15 \<equiv> case9_full_3\<lparr>
    intl_class := R9_Intl1,
    venue_rent_ppd := 300, cold_meal_pp_once := 220, bus_seats := 30, bus_cost_per_vehicle_day := 1500
  \<rparr>"
definition case9_full_extra_16 :: rule9_case where
  "case9_full_extra_16 \<equiv> case9_full_3\<lparr>
    intl_class := R9_Intl3,
    venue_rent_ppd := 150, cold_meal_pp_once := 180,
    bus_seats := 5, bus_cost_per_vehicle_day := 800
  \<rparr>"
definition case9_full_extra_17 :: rule9_case where
  "case9_full_extra_17 \<equiv> case9_base_full\<lparr>
    in_shanghai_attendee_ratio_percent := 50,
    held_outside_shanghai := True
  \<rparr>"
(* ---------- Partial extras (14) ---------- *)
definition case9_partial_extra_1 :: rule9_case where
  "case9_partial_extra_1 \<equiv> case9_base_full\<lparr>
    actual_lodging_ppd := 500, actual_meal_ppd := 150, actual_other_ppd := 101, actual_total_ppd := 751
  \<rparr>"
definition case9_partial_extra_2 :: rule9_case where
  "case9_partial_extra_2 \<equiv> case9_base_full\<lparr>excluded_items_within_budget := False\<rparr>"
definition case9_partial_extra_3 :: rule9_case where
  "case9_partial_extra_3 \<equiv> case9_base_full\<lparr>actual_total_ppd := 729\<rparr>"
definition case9_partial_extra_4 :: rule9_case where
  "case9_partial_extra_4 \<equiv> case9_base_full\<lparr>
    conf_scope := R9_Domestic_Management,
    conference_days := 1, duration_days := 1,
    actual_lodging_ppd := 340, actual_meal_ppd := 130, actual_other_ppd := 90, actual_total_ppd := 560
  \<rparr>"
definition case9_partial_extra_5 :: rule9_case where
  "case9_partial_extra_5 \<equiv> case9_base_full\<lparr>
    has_lodging_arranged := False, has_meal_arranged := True,
    actual_lodging_ppd := 0, actual_meal_ppd := 150, actual_other_ppd := 110, actual_total_ppd := 260
  \<rparr>"
definition case9_partial_extra_6 :: rule9_case where
  "case9_partial_extra_6 \<equiv> case9_base_full\<lparr>
    has_lodging_arranged := True, has_meal_arranged := False,
    actual_lodging_ppd := 500, actual_meal_ppd := 0, actual_other_ppd := 110, actual_total_ppd := 610
  \<rparr>"
definition case9_partial_extra_7 :: rule9_case where
  "case9_partial_extra_7 \<equiv> case9_base_full\<lparr>
    has_lodging_arranged := False, has_meal_arranged := False,
    actual_lodging_ppd := 0, actual_meal_ppd := 0, actual_other_ppd := 120, actual_total_ppd := 120
  \<rparr>"
definition case9_partial_extra_8 :: rule9_case where
  "case9_partial_extra_8 \<equiv> case9_full_3\<lparr>equipment_rent_ppd := 101\<rparr>"
definition case9_partial_extra_9 :: rule9_case where
  "case9_partial_extra_9 \<equiv> case9_full_3\<lparr>attendee_count := 80, staff_count := 9\<rparr>"
definition case9_partial_extra_10 :: rule9_case where
  "case9_partial_extra_10 \<equiv> case9_full_3\<lparr>staff_count := 10, resident_staff_count := 6\<rparr>"
definition case9_partial_extra_11 :: rule9_case where
  "case9_partial_extra_11 \<equiv> case9_full_3\<lparr>interpretation_is_un_language := True, interpretation_labor_ppd := 5100\<rparr>"
definition case9_partial_extra_12 :: rule9_case where
  "case9_partial_extra_12 \<equiv> case9_full_3\<lparr>written_translation_per_thousand := 250\<rparr>"
definition case9_partial_extra_13 :: rule9_case where
  "case9_partial_extra_13 \<equiv> case9_full_3\<lparr>bus_seats := 26, bus_cost_per_vehicle_day := 1600\<rparr>"
definition case9_partial_extra_14 :: rule9_case where
  "case9_partial_extra_14 \<equiv> case9_full_3\<lparr>other_service_ppd := 150\<rparr>"
(* ---------- Rejection extras (17) ---------- *)
definition case9_reject_extra_1 :: rule9_case where
  "case9_reject_extra_1 \<equiv> case9_base_full\<lparr>attendee_count := 0\<rparr>"
definition case9_reject_extra_2 :: rule9_case where
  "case9_reject_extra_2 \<equiv> case9_base_full\<lparr>conference_days := 0, duration_days := 0\<rparr>"
definition case9_reject_extra_3 :: rule9_case where
  "case9_reject_extra_3 \<equiv> case9_base_full\<lparr>duration_days := 1\<rparr>"
definition case9_reject_extra_4 :: rule9_case where
  "case9_reject_extra_4 \<equiv> case9_base_full\<lparr>actual_lodging_ppd := -1, actual_total_ppd := 729\<rparr>"
definition case9_reject_extra_5 :: rule9_case where
  "case9_reject_extra_5 \<equiv> case9_base_full\<lparr>has_budget_form := False\<rparr>"
definition case9_reject_extra_6 :: rule9_case where
  "case9_reject_extra_6 \<equiv> case9_base_full\<lparr>has_service_invoices := False\<rparr>"
definition case9_reject_extra_7 :: rule9_case where
  "case9_reject_extra_7 \<equiv> case9_base_full\<lparr>
    reimbursed_in_single_batch := False,
    split_reimbursement_needed_by_channel := True,
    each_channel_reimbursed_once := False,
    previous_channel_details_listed := True
  \<rparr>"
definition case9_reject_extra_8 :: rule9_case where
  "case9_reject_extra_8 \<equiv> case9_base_full\<lparr>
    is_regular_work_meeting_or_seminar := True,
    has_work_meal := True,
    has_work_meal_attendee_list_and_detail := False,
    work_meal_standard_pp := 50
  \<rparr>"
definition case9_reject_extra_9 :: rule9_case where
  "case9_reject_extra_9 \<equiv> case9_base_full\<lparr>
    is_regular_work_meeting_or_seminar := True,
    has_work_meal := True,
    has_work_meal_attendee_list_and_detail := True,
    work_meal_standard_pp := 60
  \<rparr>"
definition case9_reject_extra_10 :: rule9_case where
  "case9_reject_extra_10 \<equiv> case9_base_full\<lparr>
    has_advance_payment := True,
    advance_ratio_percent := 10,
    advance_has_notice_and_agenda := True,
    advance_has_budget_form := True,
    advance_has_related_contract := True
  \<rparr>"
definition case9_reject_extra_11 :: rule9_case where
  "case9_reject_extra_11 \<equiv> case9_base_full\<lparr>
    has_advance_payment := True,
    advance_ratio_percent := 25,
    advance_has_notice_and_agenda := True,
    advance_has_budget_form := True,
    advance_has_related_contract := False
  \<rparr>"
definition case9_reject_extra_12 :: rule9_case where
  "case9_reject_extra_12 \<equiv> case9_full_3\<lparr>
    has_advance_payment := True,
    advance_ratio_percent := 25,
    advance_has_notice_and_agenda := True,
    advance_has_budget_form := True,
    advance_has_related_contract := True,
    advance_has_intl_approval_if_intl := False
  \<rparr>"
definition case9_reject_extra_13 :: rule9_case where
  "case9_reject_extra_13 \<equiv> case9_base_full\<lparr>held_in_prohibited_scenic_area := True\<rparr>"
definition case9_reject_extra_14 :: rule9_case where
  "case9_reject_extra_14 \<equiv> case9_base_full\<lparr>in_shanghai_attendee_ratio_percent := 80, held_outside_shanghai := True\<rparr>"
definition case9_reject_extra_15 :: rule9_case where
  "case9_reject_extra_15 \<equiv> case9_base_full\<lparr>
    conf_scope := R9_Domestic_Management,
    conference_days := 2, duration_days := 2
  \<rparr>"
definition case9_reject_extra_16 :: rule9_case where
  "case9_reject_extra_16 \<equiv> case9_base_full\<lparr>
    conf_scope := R9_International_In_China,
    conference_days := 3, duration_days := 3
  \<rparr>"
definition case9_reject_extra_17 :: rule9_case where
  "case9_reject_extra_17 \<equiv> case9_base_full\<lparr>conference_days := 4, duration_days := 4\<rparr>"


(* Simple test case for Rule 10 *)
definition simple_rule10_case :: rule10_case where
"simple_rule10_case ≡ ⦇
  training_participant_role = Role_Bureau_Director_Level,
  training_duration_days = 20,
  training_exceeds_30_days = False,
  training_days_beyond_30 = 0,
  training_has_instructor_fees = True,
  training_instructor_fees = 5000,
  training_accommodation_expense = 8000,
  training_meals_expense = 3000,
  training_venue_materials_transport_expense = 1400,
  training_other_expense = 600,
  training_total_expense = 13000,
  training_accommodation_quota = 400,
  training_meals_quota = 150,
  training_venue_materials_transport_quota = 70,
  training_other_quota = 30,
  training_total_quota = 650,
  has_training_expense_detailed_list = True,
  has_trainee_list_with_contact = True,
  has_training_service_provider_receipts = True,
  instructor_lecture_fees = 5000,
  instructor_accommodation_expense = 400,
  instructor_meals_expense = 150,
  instructor_transportation_expense = 800,
  instructor_from_other_locations = False
⦈"
definition "full_approval_case1 ≡ ⦇
  training_participant_role = Role_National_Mgmt_Post_Level2_OrAbove,
  training_duration_days = 20,
  training_exceeds_30_days = False,
  training_days_beyond_30 = 0,
  training_has_instructor_fees = True,
  training_instructor_fees = 2000,
  training_accommodation_expense = 10000,
  training_meals_expense = 3000,
  training_venue_materials_transport_expense = 1600,
  training_other_expense = 600,
  training_total_expense = 15200,
  training_accommodation_quota = 500,
  training_meals_quota = 150,
  training_venue_materials_transport_quota = 80,
  training_other_quota = 30,
  training_total_quota = 760,
  has_training_expense_detailed_list = True,
  has_trainee_list_with_contact = True,
  has_training_service_provider_receipts = True,
  instructor_lecture_fees = 2000,
  instructor_accommodation_expense = 500,
  instructor_meals_expense = 150,
  instructor_transportation_expense = 800,
  instructor_from_other_locations = True
⦈"
definition "full_approval_case2 ≡ ⦇
  training_participant_role = Role_Bureau_Director_Level,
  training_duration_days = 25,
  training_exceeds_30_days = False,
  training_days_beyond_30 = 0,
  training_has_instructor_fees = False,
  training_instructor_fees = 0,
  training_accommodation_expense = 10000,
  training_meals_expense = 3750,
  training_venue_materials_transport_expense = 1750,
  training_other_expense = 750,
  training_total_expense = 16250,
  training_accommodation_quota = 400,
  training_meals_quota = 150,
  training_venue_materials_transport_quota = 70,
  training_other_quota = 30,
  training_total_quota = 650,
  has_training_expense_detailed_list = True,
  has_trainee_list_with_contact = True,
  has_training_service_provider_receipts = True,
  instructor_lecture_fees = 0,
  instructor_accommodation_expense = 0,
  instructor_meals_expense = 0,
  instructor_transportation_expense = 0,
  instructor_from_other_locations = False
⦈"
definition "full_approval_case3 ≡ ⦇
  training_participant_role = Role_Division_Chief_And_Below,
  training_duration_days = 35,
  training_exceeds_30_days = True,
  training_days_beyond_30 = 5,
  training_has_instructor_fees = True,
  training_instructor_fees = 1500,
  training_accommodation_expense = 11390,
  training_meals_expense = 4355,
  training_venue_materials_transport_expense = 1675,
  training_other_expense = 1005,
  training_total_expense = 18425,
  training_accommodation_quota = 340,
  training_meals_quota = 130,
  training_venue_materials_transport_quota = 50,
  training_other_quota = 30,
  training_total_quota = 550,
  has_training_expense_detailed_list = True,
  has_trainee_list_with_contact = True,
  has_training_service_provider_receipts = True,
  instructor_lecture_fees = 1500,
  instructor_accommodation_expense = 340,
  instructor_meals_expense = 130,
  instructor_transportation_expense = 600,
  instructor_from_other_locations = True
⦈"
definition "rejection_case1 ≡ ⦇
  training_participant_role = Role_National_Mgmt_Post_Level2_OrAbove,
  training_duration_days = 15,
  training_exceeds_30_days = False,
  training_days_beyond_30 = 0,
  training_has_instructor_fees = True,
  training_instructor_fees = 1800,
  training_accommodation_expense = 7500,
  training_meals_expense = 2250,
  training_venue_materials_transport_expense = 1200,
  training_other_expense = 450,
  training_total_expense = 13200,
  training_accommodation_quota = 500,
  training_meals_quota = 150,
  training_venue_materials_transport_quota = 80,
  training_other_quota = 30,
  training_total_quota = 760,
  has_training_expense_detailed_list = False,
  has_trainee_list_with_contact = True,
  has_training_service_provider_receipts = True,
  instructor_lecture_fees = 1800,
  instructor_accommodation_expense = 500,
  instructor_meals_expense = 150,
  instructor_transportation_expense = 400,
  instructor_from_other_locations = True
⦈"
definition "rejection_case2 ≡ ⦇
  training_participant_role = Role_Bureau_Director_Level,
  training_duration_days = 20,
  training_exceeds_30_days = False,
  training_days_beyond_30 = 0,
  training_has_instructor_fees = False,
  training_instructor_fees = 0,
  training_accommodation_expense = 8000,
  training_meals_expense = 3000,
  training_venue_materials_transport_expense = 1400,
  training_other_expense = 600,
  training_total_expense = 13000,
  training_accommodation_quota = 400,
  training_meals_quota = 150,
  training_venue_materials_transport_quota = 70,
  training_other_quota = 30,
  training_total_quota = 650,
  has_training_expense_detailed_list = True,
  has_trainee_list_with_contact = False,
  has_training_service_provider_receipts = True,
  instructor_lecture_fees = 0,
  instructor_accommodation_expense = 0,
  instructor_meals_expense = 0,
  instructor_transportation_expense = 0,
  instructor_from_other_locations = False
⦈"
definition "rejection_case3 ≡ ⦇
  training_participant_role = Role_Division_Chief_And_Below,
  training_duration_days = 25,
  training_exceeds_30_days = False,
  training_days_beyond_30 = 0,
  training_has_instructor_fees = True,
  training_instructor_fees = 1200,
  training_accommodation_expense = 8500,
  training_meals_expense = 3250,
  training_venue_materials_transport_expense = 1250,
  training_other_expense = 750,
  training_total_expense = 16950,
  training_accommodation_quota = 340,
  training_meals_quota = 130,
  training_venue_materials_transport_quota = 50,
  training_other_quota = 30,
  training_total_quota = 550,
  has_training_expense_detailed_list = True,
  has_trainee_list_with_contact = True,
  has_training_service_provider_receipts = False,
  instructor_lecture_fees = 1200,
  instructor_accommodation_expense = 340,
  instructor_meals_expense = 130,
  instructor_transportation_expense = 500,
  instructor_from_other_locations = True
⦈"
definition "partial_case1 ≡ ⦇
  training_participant_role = Role_National_Mgmt_Post_Level2_OrAbove,
  training_duration_days = 20,
  training_exceeds_30_days = False,
  training_days_beyond_30 = 0,
  training_has_instructor_fees = True,
  training_instructor_fees = 2500,
  training_accommodation_expense = 11000,
  training_meals_expense = 3300,
  training_venue_materials_transport_expense = 1760,
  training_other_expense = 660,
  training_total_expense = 18720,
  training_accommodation_quota = 500,
  training_meals_quota = 150,
  training_venue_materials_transport_quota = 80,
  training_other_quota = 30,
  training_total_quota = 760,
  has_training_expense_detailed_list = True,
  has_trainee_list_with_contact = True,
  has_training_service_provider_receipts = True,
  instructor_lecture_fees = 2500,
  instructor_accommodation_expense = 600,
  instructor_meals_expense = 200,
  instructor_transportation_expense = 900,
  instructor_from_other_locations = True
⦈"
definition "partial_case2 ≡ ⦇
  training_participant_role = Role_Bureau_Director_Level,
  training_duration_days = 40,
  training_exceeds_30_days = True,
  training_days_beyond_30 = 10,
  training_has_instructor_fees = False,
  training_instructor_fees = 0,
  training_accommodation_expense = 18000,
  training_meals_expense = 6750,
  training_venue_materials_transport_expense = 3150,
  training_other_expense = 1350,
  training_total_expense = 29250,
  training_accommodation_quota = 400,
  training_meals_quota = 150,
  training_venue_materials_transport_quota = 70,
  training_other_quota = 30,
  training_total_quota = 650,
  has_training_expense_detailed_list = True,
  has_trainee_list_with_contact = True,
  has_training_service_provider_receipts = True,
  instructor_lecture_fees = 0,
  instructor_accommodation_expense = 0,
  instructor_meals_expense = 0,
  instructor_transportation_expense = 0,
  instructor_from_other_locations = False
⦈"
definition "partial_case3 ≡ ⦇
  training_participant_role = Role_Division_Chief_And_Below,
  training_duration_days = 15,
  training_exceeds_30_days = False,
  training_days_beyond_30 = 0,
  training_has_instructor_fees = True,
  training_instructor_fees = 1000,
  training_accommodation_expense = 6000,
  training_meals_expense = 2300,
  training_venue_materials_transport_expense = 900,
  training_other_expense = 540,
  training_total_expense = 10740,
  training_accommodation_quota = 340,
  training_meals_quota = 130,
  training_venue_materials_transport_quota = 50,
  training_other_quota = 30,
  training_total_quota = 550,
  has_training_expense_detailed_list = True,
  has_trainee_list_with_contact = True,
  has_training_service_provider_receipts = True,
  instructor_lecture_fees = 1000,
  instructor_accommodation_expense = 340,
  instructor_meals_expense = 130,
  instructor_transportation_expense = 800,
  instructor_from_other_locations = True
⦈"
(* Rule 10: Reimbursement for Training Fees *)
value "rule_10_evaluate simple_rule10_case"
definition rule10_full_extra_1 :: rule10_case where
"rule10_full_extra_1 \<equiv> full_approval_case1\<lparr>
  training_duration_days := 12,
  training_accommodation_expense := 6000,
  training_meals_expense := 1800,
  training_venue_materials_transport_expense := 900,
  training_other_expense := 360,
  training_total_expense := 9060,
  instructor_transportation_expense := 300
\<rparr>"
definition rule10_full_extra_2 :: rule10_case where
"rule10_full_extra_2 \<equiv> full_approval_case3\<lparr>
  training_has_instructor_fees := False,
  training_instructor_fees := 0,
  instructor_lecture_fees := 0,
  instructor_accommodation_expense := 0,
  instructor_meals_expense := 0,
  instructor_transportation_expense := 0,
  instructor_from_other_locations := False
\<rparr>"
definition rule10_partial_extra_1 :: rule10_case where
"rule10_partial_extra_1 \<equiv> full_approval_case2\<lparr>training_total_quota := 640\<rparr>"
definition rule10_partial_extra_2 :: rule10_case where
"rule10_partial_extra_2 \<equiv> full_approval_case1\<lparr>
  training_participant_role := Role_Bureau_Director_Level
\<rparr>"
definition rule10_partial_extra_3 :: rule10_case where
"rule10_partial_extra_3 \<equiv> full_approval_case2\<lparr>training_meals_expense := 4000\<rparr>"
definition rule10_partial_extra_4 :: rule10_case where
"rule10_partial_extra_4 \<equiv> full_approval_case3\<lparr>
  training_exceeds_30_days := True,
  training_days_beyond_30 := 10,
  training_accommodation_expense := 13000
\<rparr>"
definition rule10_partial_extra_5 :: rule10_case where
"rule10_partial_extra_5 \<equiv> full_approval_case1\<lparr>
  training_has_instructor_fees := True,
  instructor_accommodation_expense := 700
\<rparr>"
definition rule10_partial_extra_6 :: rule10_case where
"rule10_partial_extra_6 \<equiv> full_approval_case1\<lparr>
  training_has_instructor_fees := True,
  instructor_lecture_fees := -1
\<rparr>"
definition rule10_partial_extra_7 :: rule10_case where
"rule10_partial_extra_7 \<equiv> full_approval_case2\<lparr>training_other_expense := 900\<rparr>"
definition rule10_reject_extra_1 :: rule10_case where
"rule10_reject_extra_1 \<equiv> full_approval_case1\<lparr>
  has_training_expense_detailed_list := False,
  has_training_service_provider_receipts := False
\<rparr>"
definition rule10_reject_extra_2 :: rule10_case where
"rule10_reject_extra_2 \<equiv> full_approval_case2\<lparr>
  has_trainee_list_with_contact := False
\<rparr>"
(* Rule 10: +5 Full +5 Rejection *)
definition rule10_more_full_1 :: rule10_case where
"rule10_more_full_1 \<equiv> full_approval_case1\<lparr>
  training_duration_days := 15,
  training_accommodation_expense := 7500,
  training_meals_expense := 2200,
  training_venue_materials_transport_expense := 1150,
  training_other_expense := 420,
  training_total_expense := 13270
\<rparr>"
definition rule10_more_full_2 :: rule10_case where
"rule10_more_full_2 \<equiv> full_approval_case2\<lparr>
  training_duration_days := 30,
  training_accommodation_expense := 12000,
  training_meals_expense := 4500,
  training_venue_materials_transport_expense := 2100,
  training_other_expense := 900,
  training_total_expense := 19500
\<rparr>"
definition rule10_more_full_3 :: rule10_case where
"rule10_more_full_3 \<equiv> full_approval_case3\<lparr>
  training_duration_days := 31,
  training_exceeds_30_days := True,
  training_days_beyond_30 := 1,
  training_accommodation_expense := 10438,
  training_meals_expense := 3991,
  training_venue_materials_transport_expense := 1535,
  training_other_expense := 921,
  training_total_expense := 16885
\<rparr>"
definition rule10_more_full_4 :: rule10_case where
"rule10_more_full_4 \<equiv> full_approval_case1\<lparr>
  training_has_instructor_fees := False,
  training_instructor_fees := 0,
  instructor_lecture_fees := 0,
  instructor_accommodation_expense := 0,
  instructor_meals_expense := 0,
  instructor_transportation_expense := 0
\<rparr>"
definition rule10_more_full_5 :: rule10_case where
"rule10_more_full_5 \<equiv> full_approval_case2\<lparr>
  training_duration_days := 12,
  training_accommodation_expense := 4600,
  training_meals_expense := 1700,
  training_venue_materials_transport_expense := 750,
  training_other_expense := 280,
  training_total_expense := 7330
\<rparr>"
definition rule10_more_reject_1 :: rule10_case where
"rule10_more_reject_1 \<equiv> full_approval_case1\<lparr>has_training_expense_detailed_list := False\<rparr>"
definition rule10_more_reject_2 :: rule10_case where
"rule10_more_reject_2 \<equiv> full_approval_case2\<lparr>has_trainee_list_with_contact := False\<rparr>"
definition rule10_more_reject_3 :: rule10_case where
"rule10_more_reject_3 \<equiv> full_approval_case3\<lparr>has_training_service_provider_receipts := False\<rparr>"
definition rule10_more_reject_4 :: rule10_case where
"rule10_more_reject_4 \<equiv> full_approval_case1\<lparr>
  has_training_expense_detailed_list := False,
  has_trainee_list_with_contact := False
\<rparr>"
definition rule10_more_reject_5 :: rule10_case where
"rule10_more_reject_5 \<equiv> full_approval_case2\<lparr>
  has_training_expense_detailed_list := False,
  has_trainee_list_with_contact := False,
  has_training_service_provider_receipts := False
\<rparr>"
definition rule10_more_full_cases :: "rule10_case list" where
"rule10_more_full_cases \<equiv> [rule10_more_full_1, rule10_more_full_2, rule10_more_full_3, rule10_more_full_4, rule10_more_full_5]"
definition rule10_more_reject_cases :: "rule10_case list" where
"rule10_more_reject_cases \<equiv> [rule10_more_reject_1, rule10_more_reject_2, rule10_more_reject_3, rule10_more_reject_4, rule10_more_reject_5]"
(*
  ==========================
  Rule 10 amount version v2
  ==========================
*)
definition rule10v2_full_add_1 :: rule10_case where
"rule10v2_full_add_1 \<equiv> full_approval_case1\<lparr>
  training_duration_days := 10, training_exceeds_30_days := False, training_days_beyond_30 := 0,
  training_accommodation_expense := 5000, training_meals_expense := 1500,
  training_venue_materials_transport_expense := 800, training_other_expense := 300,
  training_total_expense := 8600
\<rparr>"
definition rule10v2_full_add_2 :: rule10_case where
"rule10v2_full_add_2 \<equiv> full_approval_case2\<lparr>
  training_duration_days := 18, training_accommodation_expense := 7200,
  training_meals_expense := 2700, training_venue_materials_transport_expense := 1260,
  training_other_expense := 540, training_total_expense := 11700
\<rparr>"
definition rule10v2_full_add_3 :: rule10_case where
"rule10v2_full_add_3 \<equiv> full_approval_case3\<lparr>
  training_duration_days := 33, training_exceeds_30_days := True, training_days_beyond_30 := 3,
  training_accommodation_expense := 10714, training_meals_expense := 4091,
  training_venue_materials_transport_expense := 1571, training_other_expense := 942,
  training_total_expense := 17318
\<rparr>"
definition rule10v2_full_add_4 :: rule10_case where
"rule10v2_full_add_4 \<equiv> full_approval_case1\<lparr>training_has_instructor_fees := False, training_instructor_fees := 0,
  instructor_lecture_fees := 0, instructor_accommodation_expense := 0, instructor_meals_expense := 0,
  instructor_transportation_expense := 0, instructor_from_other_locations := False\<rparr>"
definition rule10v2_full_add_5 :: rule10_case where
"rule10v2_full_add_5 \<equiv> full_approval_case2\<lparr>
  training_duration_days := 30, training_exceeds_30_days := False,
  training_accommodation_expense := 12000, training_meals_expense := 4500,
  training_venue_materials_transport_expense := 2100, training_other_expense := 900,
  training_total_expense := 19500
\<rparr>"
definition rule10v2_full_add_6 :: rule10_case where
"rule10v2_full_add_6 \<equiv> full_approval_case3\<lparr>
  training_duration_days := 40, training_exceeds_30_days := True, training_days_beyond_30 := 10,
  training_accommodation_expense := 12920, training_meals_expense := 4940,
  training_venue_materials_transport_expense := 1900, training_other_expense := 1140,
  training_total_expense := 20900
\<rparr>"
definition rule10v2_full_add_7 :: rule10_case where
"rule10v2_full_add_7 \<equiv> full_approval_case1\<lparr>
  training_duration_days := 5, training_accommodation_expense := 2400, training_meals_expense := 700,
  training_venue_materials_transport_expense := 350, training_other_expense := 130, training_total_expense := 4380
\<rparr>"
definition rule10v2_full_add_8 :: rule10_case where
"rule10v2_full_add_8 \<equiv> full_approval_case2\<lparr>
  training_duration_days := 8, training_accommodation_expense := 3000, training_meals_expense := 1100,
  training_venue_materials_transport_expense := 500, training_other_expense := 200, training_total_expense := 4800
\<rparr>"
definition rule10v2_full_add_9 :: rule10_case where
"rule10v2_full_add_9 \<equiv> full_approval_case3\<lparr>
  training_duration_days := 31, training_exceeds_30_days := True, training_days_beyond_30 := 1,
  training_accommodation_expense := 10438, training_meals_expense := 3991,
  training_venue_materials_transport_expense := 1535, training_other_expense := 921,
  training_total_expense := 16885
\<rparr>"
definition rule10v2_full_add_10 :: rule10_case where
"rule10v2_full_add_10 \<equiv> full_approval_case1\<lparr>
  instructor_accommodation_expense := 480, instructor_meals_expense := 140, instructor_transportation_expense := 600
\<rparr>"
definition rule10v2_full_add_11 :: rule10_case where
"rule10v2_full_add_11 \<equiv> full_approval_case1\<lparr>
  training_duration_days := 22, training_accommodation_expense := 10900, training_meals_expense := 3200,
  training_venue_materials_transport_expense := 1700, training_other_expense := 650, training_total_expense := 18550
\<rparr>"
definition rule10v2_full_add_12 :: rule10_case where
"rule10v2_full_add_12 \<equiv> full_approval_case2\<lparr>
  training_duration_days := 14, training_accommodation_expense := 5500, training_meals_expense := 2100,
  training_venue_materials_transport_expense := 960, training_other_expense := 420, training_total_expense := 9000
\<rparr>"
definition rule10v2_full_add_13 :: rule10_case where
"rule10v2_full_add_13 \<equiv> full_approval_case3\<lparr>
  training_duration_days := 36, training_exceeds_30_days := True, training_days_beyond_30 := 6,
  training_accommodation_expense := 11528, training_meals_expense := 4407,
  training_venue_materials_transport_expense := 1690, training_other_expense := 1014,
  training_total_expense := 18800
\<rparr>"
definition rule10v2_full_add_14 :: rule10_case where
"rule10v2_full_add_14 \<equiv> full_approval_case1\<lparr>
  training_total_expense := 14000
\<rparr>"
definition rule10v2_full_add_15 :: rule10_case where
"rule10v2_full_add_15 \<equiv> full_approval_case2\<lparr>
  training_total_expense := 15000
\<rparr>"
(* ---- rule10 extra partial (10) ---- *)
definition rule10v2_partial_add_1 :: rule10_case where
"rule10v2_partial_add_1 \<equiv> full_approval_case1\<lparr>training_accommodation_expense := 12000\<rparr>"
definition rule10v2_partial_add_2 :: rule10_case where
"rule10v2_partial_add_2 \<equiv> full_approval_case2\<lparr>training_meals_expense := 5000\<rparr>"
definition rule10v2_partial_add_3 :: rule10_case where
"rule10v2_partial_add_3 \<equiv> full_approval_case3\<lparr>training_other_expense := 1200\<rparr>"
definition rule10v2_partial_add_4 :: rule10_case where
"rule10v2_partial_add_4 \<equiv> full_approval_case1\<lparr>instructor_accommodation_expense := 700\<rparr>"
definition rule10v2_partial_add_5 :: rule10_case where
"rule10v2_partial_add_5 \<equiv> full_approval_case1\<lparr>instructor_meals_expense := 220\<rparr>"
definition rule10v2_partial_add_6 :: rule10_case where
"rule10v2_partial_add_6 \<equiv> full_approval_case2\<lparr>training_venue_materials_transport_expense := 1900\<rparr>"
definition rule10v2_partial_add_7 :: rule10_case where
"rule10v2_partial_add_7 \<equiv> full_approval_case3\<lparr>training_duration_days := 40, training_exceeds_30_days := True, training_days_beyond_30 := 10, training_accommodation_expense := 14000\<rparr>"
definition rule10v2_partial_add_8 :: rule10_case where
"rule10v2_partial_add_8 \<equiv> full_approval_case1\<lparr>training_participant_role := Role_Bureau_Director_Level\<rparr>"
definition rule10v2_partial_add_9 :: rule10_case where
"rule10v2_partial_add_9 \<equiv> full_approval_case2\<lparr>training_total_quota := 600\<rparr>"
definition rule10v2_partial_add_10 :: rule10_case where
"rule10v2_partial_add_10 \<equiv> full_approval_case3\<lparr>training_meals_expense := 5000\<rparr>"
definition rule10v2_full_cases_20 :: "rule10_case list" where
"rule10v2_full_cases_20 \<equiv> [
  full_approval_case1, full_approval_case2, full_approval_case3, rule10_full_extra_1, rule10_full_extra_2,
  rule10v2_full_add_1, rule10v2_full_add_2, rule10v2_full_add_3, rule10v2_full_add_4, rule10v2_full_add_5,
  rule10v2_full_add_6, rule10v2_full_add_7, rule10v2_full_add_8, rule10v2_full_add_9, rule10v2_full_add_10,
  rule10v2_full_add_11, rule10v2_full_add_12, rule10v2_full_add_13, rule10v2_full_add_14, rule10v2_full_add_15
]"
definition rule10v2_partial_cases_20 :: "rule10_case list" where
"rule10v2_partial_cases_20 \<equiv> [
  partial_case1, partial_case2, partial_case3,
  rule10_partial_extra_1, rule10_partial_extra_2, rule10_partial_extra_3, rule10_partial_extra_4, rule10_partial_extra_5,
  rule10_partial_extra_6, rule10_partial_extra_7,
  rule10v2_partial_add_1, rule10v2_partial_add_2, rule10v2_partial_add_3, rule10v2_partial_add_4, rule10v2_partial_add_5,
  rule10v2_partial_add_6, rule10v2_partial_add_7, rule10v2_partial_add_8, rule10v2_partial_add_9, rule10v2_partial_add_10
]"
value "map rule10v2_amount_decision rule10v2_full_cases_20"
value "map rule10v2_amount_decision rule10v2_partial_cases_20"
(* Rule 11: Reimbursement for Family Visit Travel Expenses *)
(* Simple test case for Rule 11 *)
definition simple_rule11_case :: rule11_case where
"simple_rule11_case ≡ ⦇
  staff_unmarried_visiting_parents = False,
  staff_married_visiting_spouse = True,
  staff_married_visiting_parents = False,
  family_visit_round_trip_once_per_year = True,
  family_visit_once_every_four_years = False,
  monthly_base_salary = 8000,
  travel_expense_total = 2000,
  travel_expense_reimbursable = 2000,
  has_inter_city_transportation_costs = True,
  has_local_transportation_costs = False,
  travel_by_air = False,
  equivalent_train_fare = 0,
  has_family_visit_application_form = True,
  form_approved_by_department = True,
  form_stamped_by_hr = True
⦈"
definition "full_approval_case1_11 ≡ ⦇
  staff_unmarried_visiting_parents = True,
  staff_married_visiting_spouse = False,
  staff_married_visiting_parents = False,
  family_visit_round_trip_once_per_year = True,
  family_visit_once_every_four_years = False,
  monthly_base_salary = 5000,
  travel_expense_total = 800,
  travel_expense_reimbursable = 800,
  has_inter_city_transportation_costs = True,
  has_local_transportation_costs = False,
  travel_by_air = False,
  equivalent_train_fare = 0,
  has_family_visit_application_form = True,
  form_approved_by_department = True,
  form_stamped_by_hr = True
⦈"
definition "full_approval_case2_11 ≡ ⦇
  staff_unmarried_visiting_parents = False,
  staff_married_visiting_spouse = True,
  staff_married_visiting_parents = False,
  family_visit_round_trip_once_per_year = True,
  family_visit_once_every_four_years = False,
  monthly_base_salary = 6000,
  travel_expense_total = 950,
  travel_expense_reimbursable = 950,
  has_inter_city_transportation_costs = True,
  has_local_transportation_costs = False,
  travel_by_air = True,
  equivalent_train_fare = 950,
  has_family_visit_application_form = True,
  form_approved_by_department = True,
  form_stamped_by_hr = True
⦈"
definition "full_approval_case3_11 ≡ ⦇
  staff_unmarried_visiting_parents = False,
  staff_married_visiting_spouse = False,
  staff_married_visiting_parents = True,
  family_visit_round_trip_once_per_year = False,
  family_visit_once_every_four_years = True,
  monthly_base_salary = 5500,
  travel_expense_total = 2000,
  travel_expense_reimbursable = 350,
  has_inter_city_transportation_costs = True,
  has_local_transportation_costs = False,
  travel_by_air = False,
  equivalent_train_fare = 0,
  has_family_visit_application_form = True,
  form_approved_by_department = True,
  form_stamped_by_hr = True
⦈"
definition "rejection_case1_11 ≡ ⦇
  staff_unmarried_visiting_parents = True,
  staff_married_visiting_spouse = False,
  staff_married_visiting_parents = False,
  family_visit_round_trip_once_per_year = True,
  family_visit_once_every_four_years = False,
  monthly_base_salary = 4800,
  travel_expense_total = 700,
  travel_expense_reimbursable = 700,
  has_inter_city_transportation_costs = True,
  has_local_transportation_costs = False,
  travel_by_air = False,
  equivalent_train_fare = 0,
  has_family_visit_application_form = False,
  form_approved_by_department = True,
  form_stamped_by_hr = True
⦈"
definition "rejection_case2_11 ≡ ⦇
  staff_unmarried_visiting_parents = False,
  staff_married_visiting_spouse = True,
  staff_married_visiting_parents = False,
  family_visit_round_trip_once_per_year = True,
  family_visit_once_every_four_years = False,
  monthly_base_salary = 6200,
  travel_expense_total = 880,
  travel_expense_reimbursable = 880,
  has_inter_city_transportation_costs = True,
  has_local_transportation_costs = False,
  travel_by_air = False,
  equivalent_train_fare = 0,
  has_family_visit_application_form = True,
  form_approved_by_department = False,
  form_stamped_by_hr = True
⦈"
definition "rejection_case3_11 ≡ ⦇
  staff_unmarried_visiting_parents = False,
  staff_married_visiting_spouse = False,
  staff_married_visiting_parents = True,
  family_visit_round_trip_once_per_year = False,
  family_visit_once_every_four_years = True,
  monthly_base_salary = 5900,
  travel_expense_total = 1800,
  travel_expense_reimbursable = 1800,
  has_inter_city_transportation_costs = True,
  has_local_transportation_costs = False,
  travel_by_air = False,
  equivalent_train_fare = 0,
  has_family_visit_application_form = True,
  form_approved_by_department = True,
  form_stamped_by_hr = False
⦈"
definition "partial_case1_11 ≡ ⦇
  staff_unmarried_visiting_parents = True,
  staff_married_visiting_spouse = False,
  staff_married_visiting_parents = False,
  family_visit_round_trip_once_per_year = False,
  family_visit_once_every_four_years = False,
  monthly_base_salary = 5200,
  travel_expense_total = 850,
  travel_expense_reimbursable = 850,
  has_inter_city_transportation_costs = True,
  has_local_transportation_costs = False,
  travel_by_air = False,
  equivalent_train_fare = 0,
  has_family_visit_application_form = True,
  form_approved_by_department = True,
  form_stamped_by_hr = True
⦈"
definition "partial_case2_11 ≡ ⦇
  staff_unmarried_visiting_parents = False,
  staff_married_visiting_spouse = True,
  staff_married_visiting_parents = False,
  family_visit_round_trip_once_per_year = False,
  family_visit_once_every_four_years = False,
  monthly_base_salary = 6100,
  travel_expense_total = 920,
  travel_expense_reimbursable = 920,
  has_inter_city_transportation_costs = False,
  has_local_transportation_costs = True,
  travel_by_air = False,
  equivalent_train_fare = 0,
  has_family_visit_application_form = True,
  form_approved_by_department = True,
  form_stamped_by_hr = True
⦈"
definition "partial_case3_11 ≡ ⦇
  staff_unmarried_visiting_parents = False,
  staff_married_visiting_spouse = False,
  staff_married_visiting_parents = True,
  family_visit_round_trip_once_per_year = False,
  family_visit_once_every_four_years = False,
  monthly_base_salary = 5800,
  travel_expense_total = 2100,
  travel_expense_reimbursable = 500,
  has_inter_city_transportation_costs = True,
  has_local_transportation_costs = False,
  travel_by_air = True,
  equivalent_train_fare = 400,
  has_family_visit_application_form = True,
  form_approved_by_department = True,
  form_stamped_by_hr = True
⦈"
value "rule_11_evaluate simple_rule11_case"
definition rule11_full_extra_1 :: rule11_case where
"rule11_full_extra_1 \<equiv> full_approval_case1_11\<lparr>
  travel_by_air := True,
  equivalent_train_fare := 1000,
  travel_expense_reimbursable := 900
\<rparr>"
definition rule11_full_extra_2 :: rule11_case where
"rule11_full_extra_2 \<equiv> full_approval_case3_11\<lparr>
  monthly_base_salary := 6000,
  travel_expense_total := 2500,
  travel_expense_reimbursable := 700,
  travel_by_air := True,
  equivalent_train_fare := 800
\<rparr>"
definition rule11_partial_extra_1 :: rule11_case where
"rule11_partial_extra_1 \<equiv> full_approval_case3_11\<lparr>family_visit_once_every_four_years := False\<rparr>"
definition rule11_partial_extra_2 :: rule11_case where
"rule11_partial_extra_2 \<equiv> full_approval_case3_11\<lparr>travel_expense_reimbursable := 999\<rparr>"
definition rule11_partial_extra_3 :: rule11_case where
"rule11_partial_extra_3 \<equiv> full_approval_case2_11\<lparr>has_local_transportation_costs := True\<rparr>"
definition rule11_partial_extra_4 :: rule11_case where
"rule11_partial_extra_4 \<equiv> full_approval_case1_11\<lparr>has_inter_city_transportation_costs := False\<rparr>"
definition rule11_partial_extra_5 :: rule11_case where
"rule11_partial_extra_5 \<equiv> full_approval_case2_11\<lparr>
  travel_by_air := True,
  travel_expense_reimbursable := 1200,
  equivalent_train_fare := 900
\<rparr>"
definition rule11_partial_extra_6 :: rule11_case where
"rule11_partial_extra_6 \<equiv> full_approval_case2_11\<lparr>family_visit_round_trip_once_per_year := False\<rparr>"
definition rule11_partial_extra_7 :: rule11_case where
"rule11_partial_extra_7 \<equiv> full_approval_case1_11\<lparr>family_visit_round_trip_once_per_year := False\<rparr>"
definition rule11_reject_extra_1 :: rule11_case where
"rule11_reject_extra_1 \<equiv> full_approval_case1_11\<lparr>has_family_visit_application_form := False\<rparr>"
definition rule11_reject_extra_2 :: rule11_case where
"rule11_reject_extra_2 \<equiv> full_approval_case2_11\<lparr>form_stamped_by_hr := False\<rparr>"
(* Rule 11: +5 Full +5 Rejection *)
definition rule11_more_full_1 :: rule11_case where
"rule11_more_full_1 \<equiv> full_approval_case1_11\<lparr>
  travel_by_air := True,
  equivalent_train_fare := 900,
  travel_expense_reimbursable := 850
\<rparr>"
definition rule11_more_full_2 :: rule11_case where
"rule11_more_full_2 \<equiv> full_approval_case2_11\<lparr>
  monthly_base_salary := 6200,
  travel_expense_total := 980,
  travel_expense_reimbursable := 980,
  travel_by_air := False
\<rparr>"
definition rule11_more_full_3 :: rule11_case where
"rule11_more_full_3 \<equiv> full_approval_case3_11\<lparr>
  monthly_base_salary := 7000,
  travel_expense_total := 2600,
  travel_expense_reimbursable := 560
\<rparr>"
definition rule11_more_full_4 :: rule11_case where
"rule11_more_full_4 \<equiv> full_approval_case2_11\<lparr>
  travel_by_air := True,
  equivalent_train_fare := 1000,
  travel_expense_reimbursable := 900
\<rparr>"
definition rule11_more_full_5 :: rule11_case where
"rule11_more_full_5 \<equiv> full_approval_case1_11\<lparr>
  monthly_base_salary := 5400,
  travel_expense_total := 900,
  travel_expense_reimbursable := 900
\<rparr>"
definition rule11_more_reject_1 :: rule11_case where
"rule11_more_reject_1 \<equiv> full_approval_case1_11\<lparr>has_family_visit_application_form := False\<rparr>"
definition rule11_more_reject_2 :: rule11_case where
"rule11_more_reject_2 \<equiv> full_approval_case2_11\<lparr>form_approved_by_department := False\<rparr>"
definition rule11_more_reject_3 :: rule11_case where
"rule11_more_reject_3 \<equiv> full_approval_case3_11\<lparr>form_stamped_by_hr := False\<rparr>"
definition rule11_more_reject_4 :: rule11_case where
"rule11_more_reject_4 \<equiv> full_approval_case1_11\<lparr>
  has_family_visit_application_form := False,
  form_stamped_by_hr := False
\<rparr>"
definition rule11_more_reject_5 :: rule11_case where
"rule11_more_reject_5 \<equiv> full_approval_case2_11\<lparr>
  form_approved_by_department := False,
  form_stamped_by_hr := False
\<rparr>"
definition rule11_more_full_cases :: "rule11_case list" where
"rule11_more_full_cases \<equiv> [rule11_more_full_1, rule11_more_full_2, rule11_more_full_3, rule11_more_full_4, rule11_more_full_5]"
definition rule11_more_reject_cases :: "rule11_case list" where
"rule11_more_reject_cases \<equiv> [rule11_more_reject_1, rule11_more_reject_2, rule11_more_reject_3, rule11_more_reject_4, rule11_more_reject_5]"
(* Rule 13: Labor Fee Standards *)
definition case_full_1 :: rule13_case where
  "case_full_1 \<equiv> \<lparr>
    expense_graduate_thesis_review_defense = True,
    expense_lecture_fees = False,
    expense_expert_consultation_fees = False,
    expense_doctoral_dissertation = True,
    expense_master_thesis = False,
    reviewer_count = 6,
    reviewer_fee_per_person = 450,
    defense_committee_count = 6,
    defense_committee_fee_per_person = 400,
    defense_secretary_count = 1,
    defense_secretary_fee_per_person = 150,
    lecture_fee_is_after_tax = True,
    lecture_speaker_role = Role_Division_Chief_And_Below,
    lecture_fee_per_class_hour = 0,
    lecture_class_hours = 0,
    lecture_half_days = 0,
    consultation_participant_role = Role_Division_Chief_And_Below,
    consultation_type_in_person = False,
    consultation_type_communication = False,
    consultation_days = 0,
    consultation_fee_per_day = 0,
    consultation_fee_per_project = 0
  \<rparr>"
definition case_full_2 :: rule13_case where
  "case_full_2 \<equiv> \<lparr>
    expense_graduate_thesis_review_defense = False,
    expense_lecture_fees = True,
    expense_expert_consultation_fees = True,
    expense_doctoral_dissertation = False,
    expense_master_thesis = False,
    reviewer_count = 0,
    reviewer_fee_per_person = 0,
    defense_committee_count = 0,
    defense_committee_fee_per_person = 0,
    defense_secretary_count = 0,
    defense_secretary_fee_per_person = 0,
    lecture_fee_is_after_tax = True,
    lecture_speaker_role = Role_Division_Chief_And_Below,
    lecture_fee_per_class_hour = 500,
    lecture_class_hours = 8,
    lecture_half_days = 2,
    consultation_participant_role = Role_Bureau_Director_Level,
    consultation_type_in_person = True,
    consultation_type_communication = False,
    consultation_days = 2,
    consultation_fee_per_day = 800,
    consultation_fee_per_project = 0
  \<rparr>"
definition case_full_3 :: rule13_case where
  "case_full_3 \<equiv> \<lparr>
    expense_graduate_thesis_review_defense = True,
    expense_lecture_fees = True,
    expense_expert_consultation_fees = True,
    expense_doctoral_dissertation = False,
    expense_master_thesis = True,
    reviewer_count = 3,
    reviewer_fee_per_person = 300,
    defense_committee_count = 5,
    defense_committee_fee_per_person = 300,
    defense_secretary_count = 1,
    defense_secretary_fee_per_person = 100,
    lecture_fee_is_after_tax = True,
    lecture_speaker_role = Role_Academician,
    lecture_fee_per_class_hour = 1400,
    lecture_class_hours = 4,
    lecture_half_days = 1,
    consultation_participant_role = Role_Division_Chief_And_Below,
    consultation_type_in_person = False,
    consultation_type_communication = True,
    consultation_days = 1,
    consultation_fee_per_day = 0,
    consultation_fee_per_project = 80
  \<rparr>"
(* 3 Unknown cases *)
definition case_unknown_1 :: rule13_case where
  "case_unknown_1 \<equiv> \<lparr>
    expense_graduate_thesis_review_defense = False,
    expense_lecture_fees = True,
    expense_expert_consultation_fees = False,
    expense_doctoral_dissertation = False,
    expense_master_thesis = False,
    reviewer_count = 0,
    reviewer_fee_per_person = 0,
    defense_committee_count = 0,
    defense_committee_fee_per_person = 0,
    defense_secretary_count = 0,
    defense_secretary_fee_per_person = 0,
    lecture_fee_is_after_tax = False,
    lecture_speaker_role = Role_Division_Chief_And_Below,
    lecture_fee_per_class_hour = 400,
    lecture_class_hours = 2,
    lecture_half_days = 1,
    consultation_participant_role = Role_Division_Chief_And_Below,
    consultation_type_in_person = False,
    consultation_type_communication = False,
    consultation_days = 0,
    consultation_fee_per_day = 0,
    consultation_fee_per_project = 0
  \<rparr>"
definition case_unknown_2 :: rule13_case where
  "case_unknown_2 \<equiv> \<lparr>
    expense_graduate_thesis_review_defense = True,
    expense_lecture_fees = True,
    expense_expert_consultation_fees = False,
    expense_doctoral_dissertation = True,
    expense_master_thesis = False,
    reviewer_count = 5,
    reviewer_fee_per_person = 300,
    defense_committee_count = 5,
    defense_committee_fee_per_person = 300,
    defense_secretary_count = 1,
    defense_secretary_fee_per_person = 150,
    lecture_fee_is_after_tax = False,
    lecture_speaker_role = Role_Bureau_Director_Level,
    lecture_fee_per_class_hour = 900,
    lecture_class_hours = 4,
    lecture_half_days = 1,
    consultation_participant_role = Role_Division_Chief_And_Below,
    consultation_type_in_person = False,
    consultation_type_communication = False,
    consultation_days = 0,
    consultation_fee_per_day = 0,
    consultation_fee_per_project = 0
  \<rparr>"
definition case_unknown_3 :: rule13_case where
  "case_unknown_3 \<equiv> \<lparr>
    expense_graduate_thesis_review_defense = True,
    expense_lecture_fees = True,
    expense_expert_consultation_fees = True,
    expense_doctoral_dissertation = False,
    expense_master_thesis = True,
    reviewer_count = 2,
    reviewer_fee_per_person = 250,
    defense_committee_count = 3,
    defense_committee_fee_per_person = 250,
    defense_secretary_count = 1,
    defense_secretary_fee_per_person = 100,
    lecture_fee_is_after_tax = False,
    lecture_speaker_role = Role_Academician,
    lecture_fee_per_class_hour = 1500,
    lecture_class_hours = 4,
    lecture_half_days = 1,
    consultation_participant_role = Role_Bureau_Director_Level,
    consultation_type_in_person = True,
    consultation_type_communication = False,
    consultation_days = 3,
    consultation_fee_per_day = 450,
    consultation_fee_per_project = 0
  \<rparr>"
(* 3 Partial_Approval cases *)
definition case_partial_1 :: rule13_case where
  "case_partial_1 \<equiv> \<lparr>
    expense_graduate_thesis_review_defense = True,
    expense_lecture_fees = False,
    expense_expert_consultation_fees = False,
    expense_doctoral_dissertation = True,
    expense_master_thesis = False,
    reviewer_count = 9,
    reviewer_fee_per_person = 500,
    defense_committee_count = 7,
    defense_committee_fee_per_person = 500,
    defense_secretary_count = 1,
    defense_secretary_fee_per_person = 150,
    lecture_fee_is_after_tax = True,
    lecture_speaker_role = Role_Division_Chief_And_Below,
    lecture_fee_per_class_hour = 0,
    lecture_class_hours = 0,
    lecture_half_days = 0,
    consultation_participant_role = Role_Division_Chief_And_Below,
    consultation_type_in_person = False,
    consultation_type_communication = False,
    consultation_days = 0,
    consultation_fee_per_day = 0,
    consultation_fee_per_project = 0
  \<rparr>"
definition case_partial_2 :: rule13_case where
  "case_partial_2 \<equiv> \<lparr>
    expense_graduate_thesis_review_defense = False,
    expense_lecture_fees = True,
    expense_expert_consultation_fees = False,
    expense_doctoral_dissertation = False,
    expense_master_thesis = False,
    reviewer_count = 0,
    reviewer_fee_per_person = 0,
    defense_committee_count = 0,
    defense_committee_fee_per_person = 0,
    defense_secretary_count = 0,
    defense_secretary_fee_per_person = 0,
    lecture_fee_is_after_tax = True,
    lecture_speaker_role = Role_Bureau_Director_Level,
    lecture_fee_per_class_hour = 1200,
    lecture_class_hours = 4,
    lecture_half_days = 1,
    consultation_participant_role = Role_Division_Chief_And_Below,
    consultation_type_in_person = False,
    consultation_type_communication = False,
    consultation_days = 0,
    consultation_fee_per_day = 0,
    consultation_fee_per_project = 0
  \<rparr>"
definition case_partial_3 :: rule13_case where
  "case_partial_3 \<equiv> \<lparr>
    expense_graduate_thesis_review_defense = False,
    expense_lecture_fees = False,
    expense_expert_consultation_fees = True,
    expense_doctoral_dissertation = False,
    expense_master_thesis = False,
    reviewer_count = 0,
    reviewer_fee_per_person = 0,
    defense_committee_count = 0,
    defense_committee_fee_per_person = 0,
    defense_secretary_count = 0,
    defense_secretary_fee_per_person = 0,
    lecture_fee_is_after_tax = True,
    lecture_speaker_role = Role_Division_Chief_And_Below,
    lecture_fee_per_class_hour = 0,
    lecture_class_hours = 0,
    lecture_half_days = 0,
    consultation_participant_role = Role_Division_Chief_And_Below,
    consultation_type_in_person = True,
    consultation_type_communication = False,
    consultation_days = 3,
    consultation_fee_per_day = 350,
    consultation_fee_per_project = 0
  \<rparr>"
definition rule13_full_extra_1 :: rule13_case where
"rule13_full_extra_1 \<equiv> case_full_2\<lparr>
  lecture_speaker_role := Role_Bureau_Director_Level,
  lecture_fee_per_class_hour := 900,
  lecture_class_hours := 6,
  lecture_half_days := 2
\<rparr>"
definition rule13_full_extra_2 :: rule13_case where
"rule13_full_extra_2 \<equiv> case_full_3\<lparr>
  consultation_participant_role := Role_Division_Chief_And_Below,
  consultation_type_in_person := True,
  consultation_type_communication := False,
  consultation_days := 4,
  consultation_fee_per_day := 300,
  consultation_fee_per_project := 0
\<rparr>"
definition rule13_partial_extra_1 :: rule13_case where
"rule13_partial_extra_1 \<equiv> case_full_1\<lparr>reviewer_fee_per_person := 600\<rparr>"
definition rule13_partial_extra_2 :: rule13_case where
"rule13_partial_extra_2 \<equiv> case_full_3\<lparr>defense_committee_count := 6\<rparr>"
definition rule13_partial_extra_3 :: rule13_case where
"rule13_partial_extra_3 \<equiv> case_full_2\<lparr>
  lecture_speaker_role := Role_Division_Chief_And_Below,
  lecture_fee_per_class_hour := 550
\<rparr>"
definition rule13_partial_extra_4 :: rule13_case where
"rule13_partial_extra_4 \<equiv> case_full_2\<lparr>lecture_class_hours := 10, lecture_half_days := 2\<rparr>"
definition rule13_partial_extra_5 :: rule13_case where
"rule13_partial_extra_5 \<equiv> case_full_2\<lparr>
  consultation_participant_role := Role_Bureau_Director_Level,
  consultation_type_in_person := True,
  consultation_days := 2,
  consultation_fee_per_day := 900
\<rparr>"
definition rule13_partial_extra_6 :: rule13_case where
"rule13_partial_extra_6 \<equiv> case_full_2\<lparr>
  consultation_participant_role := Role_Bureau_Director_Level,
  consultation_type_in_person := False,
  consultation_type_communication := True,
  consultation_fee_per_project := 120
\<rparr>"
definition rule13_partial_extra_7 :: rule13_case where
"rule13_partial_extra_7 \<equiv> case_full_3\<lparr>
  consultation_participant_role := Role_Division_Chief_And_Below,
  consultation_type_in_person := True,
  consultation_type_communication := False,
  consultation_days := 3,
  consultation_fee_per_day := 350
\<rparr>"
definition rule13_unknown_extra_1 :: rule13_case where
"rule13_unknown_extra_1 \<equiv> case_full_2\<lparr>
  expense_lecture_fees := True,
  lecture_fee_is_after_tax := False
\<rparr>"
definition rule13_unknown_extra_2 :: rule13_case where
"rule13_unknown_extra_2 \<equiv> case_full_3\<lparr>lecture_fee_is_after_tax := False\<rparr>"
(* Rule 13: evaluator has Full / Partial / Unknown (no Rejection branch). *)
definition rule13_more_full_1 :: rule13_case where
"rule13_more_full_1 \<equiv> case_full_1\<lparr>reviewer_count := 8, reviewer_fee_per_person := 500\<rparr>"
definition rule13_more_full_2 :: rule13_case where
"rule13_more_full_2 \<equiv> case_full_2\<lparr>
  lecture_speaker_role := Role_Bureau_Director_Level,
  lecture_fee_per_class_hour := 900
\<rparr>"
definition rule13_more_full_3 :: rule13_case where
"rule13_more_full_3 \<equiv> case_full_2\<lparr>
  consultation_type_in_person := False,
  consultation_type_communication := True,
  consultation_fee_per_project := 100
\<rparr>"
definition rule13_more_full_4 :: rule13_case where
"rule13_more_full_4 \<equiv> case_full_3\<lparr>
  lecture_fee_per_class_hour := 1500,
  lecture_class_hours := 4,
  lecture_half_days := 1
\<rparr>"
definition rule13_more_full_5 :: rule13_case where
"rule13_more_full_5 \<equiv> case_full_3\<lparr>
  consultation_participant_role := Role_Division_Chief_And_Below,
  consultation_type_in_person := True,
  consultation_type_communication := False,
  consultation_days := 2,
  consultation_fee_per_day := 500
\<rparr>"
definition rule13_more_reject_1 :: rule13_case where
"rule13_more_reject_1 \<equiv> case_full_2\<lparr>lecture_fee_is_after_tax := False\<rparr>"
definition rule13_more_reject_2 :: rule13_case where
"rule13_more_reject_2 \<equiv> case_full_3\<lparr>lecture_fee_is_after_tax := False\<rparr>"
definition rule13_more_reject_3 :: rule13_case where
"rule13_more_reject_3 \<equiv> case_full_1\<lparr>
  expense_lecture_fees := True,
  lecture_fee_is_after_tax := False,
  lecture_speaker_role := Role_Division_Chief_And_Below,
  lecture_fee_per_class_hour := 400,
  lecture_class_hours := 2,
  lecture_half_days := 1
\<rparr>"
definition rule13_more_reject_4 :: rule13_case where
"rule13_more_reject_4 \<equiv> case_full_2\<lparr>
  lecture_fee_is_after_tax := False,
  lecture_speaker_role := Role_Academician
\<rparr>"
definition rule13_more_reject_5 :: rule13_case where
"rule13_more_reject_5 \<equiv> case_full_3\<lparr>
  lecture_fee_is_after_tax := False,
  consultation_participant_role := Role_Bureau_Director_Level
\<rparr>"
definition rule13_more_full_cases :: "rule13_case list" where
"rule13_more_full_cases \<equiv> [rule13_more_full_1, rule13_more_full_2, rule13_more_full_3, rule13_more_full_4, rule13_more_full_5]"
definition rule13_more_reject_cases :: "rule13_case list" where
"rule13_more_reject_cases \<equiv> [rule13_more_reject_1, rule13_more_reject_2, rule13_more_reject_3, rule13_more_reject_4, rule13_more_reject_5]"
(*
  ==========================
  Rule 13 amount version v2
  ==========================
*)
definition rule13v2_full_add_1 :: rule13_case where
"rule13v2_full_add_1 \<equiv> case_full_1\<lparr>reviewer_count := 8, reviewer_fee_per_person := 500\<rparr>"
definition rule13v2_full_add_2 :: rule13_case where
"rule13v2_full_add_2 \<equiv> case_full_1\<lparr>defense_committee_count := 7, defense_committee_fee_per_person := 500\<rparr>"
definition rule13v2_full_add_3 :: rule13_case where
"rule13v2_full_add_3 \<equiv> case_full_2\<lparr>lecture_speaker_role := Role_Bureau_Director_Level, lecture_fee_per_class_hour := 1000\<rparr>"
definition rule13v2_full_add_4 :: rule13_case where
"rule13v2_full_add_4 \<equiv> case_full_2\<lparr>lecture_class_hours := 4, lecture_half_days := 1\<rparr>"
definition rule13v2_full_add_5 :: rule13_case where
"rule13v2_full_add_5 \<equiv> case_full_2\<lparr>consultation_type_in_person := False, consultation_type_communication := True, consultation_fee_per_project := 100, consultation_days := 1\<rparr>"
definition rule13v2_full_add_6 :: rule13_case where
"rule13v2_full_add_6 \<equiv> case_full_3\<lparr>reviewer_count := 2, reviewer_fee_per_person := 280\<rparr>"
definition rule13v2_full_add_7 :: rule13_case where
"rule13v2_full_add_7 \<equiv> case_full_3\<lparr>defense_committee_count := 4, defense_committee_fee_per_person := 260\<rparr>"
definition rule13v2_full_add_8 :: rule13_case where
"rule13v2_full_add_8 \<equiv> case_full_3\<lparr>lecture_fee_per_class_hour := 1500, lecture_class_hours := 4, lecture_half_days := 1\<rparr>"
definition rule13v2_full_add_9 :: rule13_case where
"rule13v2_full_add_9 \<equiv> case_full_3\<lparr>consultation_participant_role := Role_Division_Chief_And_Below, consultation_type_in_person := True, consultation_type_communication := False, consultation_days := 2, consultation_fee_per_day := 500, consultation_fee_per_project := 0\<rparr>"
definition rule13v2_full_add_10 :: rule13_case where
"rule13v2_full_add_10 \<equiv> case_full_2\<lparr>consultation_participant_role := Role_Bureau_Director_Level, consultation_type_in_person := True, consultation_days := 3, consultation_fee_per_day := 400\<rparr>"
definition rule13v2_full_add_11 :: rule13_case where
"rule13v2_full_add_11 \<equiv> case_full_1\<lparr>defense_secretary_fee_per_person := 120\<rparr>"
definition rule13v2_full_add_12 :: rule13_case where
"rule13v2_full_add_12 \<equiv> case_full_2\<lparr>expense_expert_consultation_fees := False, consultation_days := 0, consultation_fee_per_day := 0, consultation_fee_per_project := 0\<rparr>"
definition rule13v2_full_add_13 :: rule13_case where
"rule13v2_full_add_13 \<equiv> case_full_3\<lparr>expense_lecture_fees := False, lecture_fee_per_class_hour := 0, lecture_class_hours := 0, lecture_half_days := 0\<rparr>"
definition rule13v2_full_add_14 :: rule13_case where 
"rule13v2_full_add_14 \<equiv> case_full_1\<lparr>
  expense_graduate_thesis_review_defense := True,
  expense_lecture_fees := True,
  expense_expert_consultation_fees := True,
  expense_doctoral_dissertation := True,
  expense_master_thesis := False,
  reviewer_count := 5,
  reviewer_fee_per_person := 600,
  defense_committee_count := 7,
  defense_committee_fee_per_person := 500,
  defense_secretary_count := 1,
  defense_secretary_fee_per_person := 200,
  lecture_fee_is_after_tax := True,
  lecture_speaker_role := Role_Division_Chief_And_Below,
  lecture_fee_per_class_hour := 500,
  lecture_class_hours := 4,
  lecture_half_days := 1,
  consultation_participant_role := Role_Division_Chief_And_Below,
  consultation_type_in_person := True,
  consultation_type_communication := False,
  consultation_days := 2,
  consultation_fee_per_day := 800,
  consultation_fee_per_project := 0
\<rparr>"
definition rule13v2_full_add_15 :: rule13_case where
"rule13v2_full_add_15 \<equiv> case_full_2\<lparr>lecture_speaker_role := Role_Division_Chief_And_Below, lecture_fee_per_class_hour := 450, lecture_class_hours := 6, lecture_half_days := 2\<rparr>"
(* ---- rule13 extra partial (10) ---- *)
definition rule13v2_partial_add_1 :: rule13_case where
"rule13v2_partial_add_1 \<equiv> case_full_1\<lparr>reviewer_count := 9\<rparr>"
definition rule13v2_partial_add_2 :: rule13_case where
"rule13v2_partial_add_2 \<equiv> case_full_1\<lparr>defense_secretary_fee_per_person := 180\<rparr>"
definition rule13v2_partial_add_3 :: rule13_case where
"rule13v2_partial_add_3 \<equiv> case_full_2\<lparr>lecture_fee_per_class_hour := 700\<rparr>"
definition rule13v2_partial_add_4 :: rule13_case where
"rule13v2_partial_add_4 \<equiv> case_full_2\<lparr>lecture_class_hours := 9, lecture_half_days := 2\<rparr>"
definition rule13v2_partial_add_5 :: rule13_case where
"rule13v2_partial_add_5 \<equiv> case_full_2\<lparr>consultation_fee_per_day := 900\<rparr>"
definition rule13v2_partial_add_6 :: rule13_case where
"rule13v2_partial_add_6 \<equiv> case_full_3\<lparr>consultation_participant_role := Role_Division_Chief_And_Below, consultation_type_in_person := True, consultation_type_communication := False, consultation_days := 3, consultation_fee_per_day := 350\<rparr>"
definition rule13v2_partial_add_7 :: rule13_case where
"rule13v2_partial_add_7 \<equiv> case_full_3\<lparr>defense_committee_count := 6\<rparr>"
definition rule13v2_partial_add_8 :: rule13_case where
"rule13v2_partial_add_8 \<equiv> case_full_3\<lparr>reviewer_fee_per_person := 350\<rparr>"
definition rule13v2_partial_add_9 :: rule13_case where
"rule13v2_partial_add_9 \<equiv> case_full_2\<lparr>consultation_type_in_person := False, consultation_type_communication := True, consultation_fee_per_project := 150\<rparr>"
definition rule13v2_partial_add_10 :: rule13_case where
"rule13v2_partial_add_10 \<equiv> case_full_1\<lparr>defense_committee_fee_per_person := 550\<rparr>"
definition rule13v2_full_cases_20 :: "rule13_case list" where
"rule13v2_full_cases_20 \<equiv> [
  case_full_1, case_full_2, case_full_3, rule13_full_extra_1, rule13_full_extra_2,
  rule13v2_full_add_1, rule13v2_full_add_2, rule13v2_full_add_3, rule13v2_full_add_4, rule13v2_full_add_5,
  rule13v2_full_add_6, rule13v2_full_add_7, rule13v2_full_add_8, rule13v2_full_add_9, rule13v2_full_add_10,
  rule13v2_full_add_11, rule13v2_full_add_12, rule13v2_full_add_13, rule13v2_full_add_14, rule13v2_full_add_15
]"
definition rule13v2_partial_cases_20 :: "rule13_case list" where
"rule13v2_partial_cases_20 \<equiv> [
  case_partial_1, case_partial_2, case_partial_3,
  rule13_partial_extra_1, rule13_partial_extra_2, rule13_partial_extra_3, rule13_partial_extra_4,
  rule13_partial_extra_5, rule13_partial_extra_6, rule13_partial_extra_7,
  rule13v2_partial_add_1, rule13v2_partial_add_2, rule13v2_partial_add_3, rule13v2_partial_add_4, rule13v2_partial_add_5,
  rule13v2_partial_add_6, rule13v2_partial_add_7, rule13v2_partial_add_8, rule13v2_partial_add_9, rule13v2_partial_add_10
]"
(* Rule 14: Approval and Payment of Construction and Renovation Expenses *)
definition case14_full_1 :: rule14_case where
  "case14_full_1 \<equiv> \<lparr>
    approval_form_original_provided = True,
    approval_form_stamped_infra_official_seal = True,
    approval_form_stamped_renovation_review_seal = True,
    project_amount_over_100k = False,
    approval_signed_by_infra_director = False,
    approval_signed_by_vice_president = False,
    payment_follows_contract_amount = True,
    payment_follows_contract_progress = True,
    not_overpayment = True,
    not_advance_payment_across_progress = True,
    is_first_payment = False,
    construction_contract_original_provided = False,
    first_payment_exceeds_contract_ratio_or_amount = False,
    is_final_settlement_payment = False,
    cost_review_opinion_original_provided = False,
    filing_form_original_provided = False,
    opinion_stamped_by_cost_company = False,
    opinion_stamped_by_infra_process = False,
    filing_form_signed_by_engineering_department = False,
    filing_form_signed_and_commented_by_audit_office = False,
    final_payment_based_on_approved_settlement_total = False,
    final_payment_exceeds_contract_price = False
  \<rparr>"
definition case14_full_2 :: rule14_case where
  "case14_full_2 \<equiv> \<lparr>
    approval_form_original_provided = True,
    approval_form_stamped_infra_official_seal = True,
    approval_form_stamped_renovation_review_seal = True,
    project_amount_over_100k = True,
    approval_signed_by_infra_director = True,
    approval_signed_by_vice_president = True,
    payment_follows_contract_amount = True,
    payment_follows_contract_progress = True,
    not_overpayment = True,
    not_advance_payment_across_progress = True,
    is_first_payment = True,
    construction_contract_original_provided = True,
    first_payment_exceeds_contract_ratio_or_amount = False,
    is_final_settlement_payment = False,
    cost_review_opinion_original_provided = False,
    filing_form_original_provided = False,
    opinion_stamped_by_cost_company = False,
    opinion_stamped_by_infra_process = False,
    filing_form_signed_by_engineering_department = False,
    filing_form_signed_and_commented_by_audit_office = False,
    final_payment_based_on_approved_settlement_total = False,
    final_payment_exceeds_contract_price = False
  \<rparr>"
definition case14_full_3 :: rule14_case where
  "case14_full_3 \<equiv> \<lparr>
    approval_form_original_provided = True,
    approval_form_stamped_infra_official_seal = True,
    approval_form_stamped_renovation_review_seal = True,
    project_amount_over_100k = True,
    approval_signed_by_infra_director = True,
    approval_signed_by_vice_president = True,
    payment_follows_contract_amount = True,
    payment_follows_contract_progress = True,
    not_overpayment = True,
    not_advance_payment_across_progress = True,
    is_first_payment = False,
    construction_contract_original_provided = False,
    first_payment_exceeds_contract_ratio_or_amount = False,
    is_final_settlement_payment = True,
    cost_review_opinion_original_provided = True,
    filing_form_original_provided = True,
    opinion_stamped_by_cost_company = True,
    opinion_stamped_by_infra_process = True,
    filing_form_signed_by_engineering_department = True,
    filing_form_signed_and_commented_by_audit_office = True,
    final_payment_based_on_approved_settlement_total = True,
    final_payment_exceeds_contract_price = False
  \<rparr>"
(* -------- Rejection (3) -------- *)
definition case14_reject_1 :: rule14_case where
  "case14_reject_1 \<equiv> \<lparr>
    approval_form_original_provided = True,
    approval_form_stamped_infra_official_seal = False,
    approval_form_stamped_renovation_review_seal = True,
    project_amount_over_100k = False,
    approval_signed_by_infra_director = False,
    approval_signed_by_vice_president = False,
    payment_follows_contract_amount = True,
    payment_follows_contract_progress = True,
    not_overpayment = True,
    not_advance_payment_across_progress = True,
    is_first_payment = False,
    construction_contract_original_provided = False,
    first_payment_exceeds_contract_ratio_or_amount = False,
    is_final_settlement_payment = False,
    cost_review_opinion_original_provided = False,
    filing_form_original_provided = False,
    opinion_stamped_by_cost_company = False,
    opinion_stamped_by_infra_process = False,
    filing_form_signed_by_engineering_department = False,
    filing_form_signed_and_commented_by_audit_office = False,
    final_payment_based_on_approved_settlement_total = False,
    final_payment_exceeds_contract_price = False
  \<rparr>"
definition case14_reject_2 :: rule14_case where
  "case14_reject_2 \<equiv> \<lparr>
    approval_form_original_provided = True,
    approval_form_stamped_infra_official_seal = True,
    approval_form_stamped_renovation_review_seal = True,
    project_amount_over_100k = True,
    approval_signed_by_infra_director = True,
    approval_signed_by_vice_president = False,
    payment_follows_contract_amount = True,
    payment_follows_contract_progress = True,
    not_overpayment = True,
    not_advance_payment_across_progress = True,
    is_first_payment = False,
    construction_contract_original_provided = False,
    first_payment_exceeds_contract_ratio_or_amount = False,
    is_final_settlement_payment = False,
    cost_review_opinion_original_provided = False,
    filing_form_original_provided = False,
    opinion_stamped_by_cost_company = False,
    opinion_stamped_by_infra_process = False,
    filing_form_signed_by_engineering_department = False,
    filing_form_signed_and_commented_by_audit_office = False,
    final_payment_based_on_approved_settlement_total = False,
    final_payment_exceeds_contract_price = False
  \<rparr>"
definition case14_reject_3 :: rule14_case where
  "case14_reject_3 \<equiv> \<lparr>
    approval_form_original_provided = True,
    approval_form_stamped_infra_official_seal = True,
    approval_form_stamped_renovation_review_seal = True,
    project_amount_over_100k = False,
    approval_signed_by_infra_director = False,
    approval_signed_by_vice_president = False,
    payment_follows_contract_amount = True,
    payment_follows_contract_progress = True,
    not_overpayment = True,
    not_advance_payment_across_progress = True,
    is_first_payment = True,
    construction_contract_original_provided = False,
    first_payment_exceeds_contract_ratio_or_amount = False,
    is_final_settlement_payment = False,
    cost_review_opinion_original_provided = False,
    filing_form_original_provided = False,
    opinion_stamped_by_cost_company = False,
    opinion_stamped_by_infra_process = False,
    filing_form_signed_by_engineering_department = False,
    filing_form_signed_and_commented_by_audit_office = False,
    final_payment_based_on_approved_settlement_total = False,
    final_payment_exceeds_contract_price = False
  \<rparr>"
(* -------- Partial_Approval (3) -------- *)
definition case14_partial_1 :: rule14_case where
  "case14_partial_1 \<equiv> \<lparr>
    approval_form_original_provided = True,
    approval_form_stamped_infra_official_seal = True,
    approval_form_stamped_renovation_review_seal = True,
    project_amount_over_100k = False,
    approval_signed_by_infra_director = False,
    approval_signed_by_vice_president = False,
    payment_follows_contract_amount = True,
    payment_follows_contract_progress = True,
    not_overpayment = True,
    not_advance_payment_across_progress = True,
    is_first_payment = True,
    construction_contract_original_provided = True,
    first_payment_exceeds_contract_ratio_or_amount = True,
    is_final_settlement_payment = False,
    cost_review_opinion_original_provided = False,
    filing_form_original_provided = False,
    opinion_stamped_by_cost_company = False,
    opinion_stamped_by_infra_process = False,
    filing_form_signed_by_engineering_department = False,
    filing_form_signed_and_commented_by_audit_office = False,
    final_payment_based_on_approved_settlement_total = False,
    final_payment_exceeds_contract_price = False
  \<rparr>"
definition case14_partial_2 :: rule14_case where
  "case14_partial_2 \<equiv> \<lparr>
    approval_form_original_provided = True,
    approval_form_stamped_infra_official_seal = True,
    approval_form_stamped_renovation_review_seal = True,
    project_amount_over_100k = True,
    approval_signed_by_infra_director = True,
    approval_signed_by_vice_president = True,
    payment_follows_contract_amount = True,
    payment_follows_contract_progress = True,
    not_overpayment = True,
    not_advance_payment_across_progress = True,
    is_first_payment = False,
    construction_contract_original_provided = False,
    first_payment_exceeds_contract_ratio_or_amount = False,
    is_final_settlement_payment = True,
    cost_review_opinion_original_provided = True,
    filing_form_original_provided = True,
    opinion_stamped_by_cost_company = True,
    opinion_stamped_by_infra_process = True,
    filing_form_signed_by_engineering_department = True,
    filing_form_signed_and_commented_by_audit_office = True,
    final_payment_based_on_approved_settlement_total = True,
    final_payment_exceeds_contract_price = True
  \<rparr>"
definition case14_partial_3 :: rule14_case where
  "case14_partial_3 \<equiv> \<lparr>
    approval_form_original_provided = True,
    approval_form_stamped_infra_official_seal = True,
    approval_form_stamped_renovation_review_seal = True,
    project_amount_over_100k = True,
    approval_signed_by_infra_director = True,
    approval_signed_by_vice_president = True,
    payment_follows_contract_amount = True,
    payment_follows_contract_progress = True,
    not_overpayment = True,
    not_advance_payment_across_progress = True,
    is_first_payment = True,
    construction_contract_original_provided = True,
    first_payment_exceeds_contract_ratio_or_amount = True,
    is_final_settlement_payment = True,
    cost_review_opinion_original_provided = True,
    filing_form_original_provided = True,
    opinion_stamped_by_cost_company = True,
    opinion_stamped_by_infra_process = True,
    filing_form_signed_by_engineering_department = True,
    filing_form_signed_and_commented_by_audit_office = True,
    final_payment_based_on_approved_settlement_total = True,
    final_payment_exceeds_contract_price = True
  \<rparr>"
definition rule14_full_extra_1 :: rule14_case where
"rule14_full_extra_1 \<equiv> case14_full_2\<lparr>
  is_first_payment := False,
  construction_contract_original_provided := False
\<rparr>"
definition rule14_full_extra_2 :: rule14_case where
"rule14_full_extra_2 \<equiv> case14_full_3\<lparr>
  is_first_payment := True,
  construction_contract_original_provided := True,
  first_payment_exceeds_contract_ratio_or_amount := False
\<rparr>"
definition rule14_partial_extra_1 :: rule14_case where
"rule14_partial_extra_1 \<equiv> case14_full_2\<lparr>first_payment_exceeds_contract_ratio_or_amount := True\<rparr>"
definition rule14_partial_extra_2 :: rule14_case where
"rule14_partial_extra_2 \<equiv> case14_full_3\<lparr>final_payment_exceeds_contract_price := True\<rparr>"
definition rule14_partial_extra_3 :: rule14_case where
"rule14_partial_extra_3 \<equiv> case14_full_3\<lparr>
  is_first_payment := True,
  construction_contract_original_provided := True,
  first_payment_exceeds_contract_ratio_or_amount := True,
  final_payment_exceeds_contract_price := True
\<rparr>"
definition rule14_partial_extra_4 :: rule14_case where
"rule14_partial_extra_4 \<equiv> case14_full_1\<lparr>
  project_amount_over_100k := True,
  approval_signed_by_infra_director := True,
  approval_signed_by_vice_president := True,
  is_first_payment := True,
  construction_contract_original_provided := True,
  first_payment_exceeds_contract_ratio_or_amount := True
\<rparr>"
definition rule14_partial_extra_5 :: rule14_case where
"rule14_partial_extra_5 \<equiv> case14_full_1\<lparr>
  is_final_settlement_payment := True,
  cost_review_opinion_original_provided := True,
  filing_form_original_provided := True,
  opinion_stamped_by_cost_company := True,
  opinion_stamped_by_infra_process := True,
  filing_form_signed_by_engineering_department := True,
  filing_form_signed_and_commented_by_audit_office := True,
  final_payment_based_on_approved_settlement_total := True,
  final_payment_exceeds_contract_price := True
\<rparr>"
definition rule14_partial_extra_6 :: rule14_case where
"rule14_partial_extra_6 \<equiv> case14_full_3\<lparr>
  is_first_payment := True,
  construction_contract_original_provided := True,
  first_payment_exceeds_contract_ratio_or_amount := False,
  final_payment_exceeds_contract_price := True
\<rparr>"
definition rule14_partial_extra_7 :: rule14_case where
"rule14_partial_extra_7 \<equiv> case14_full_3\<lparr>
  is_first_payment := True,
  construction_contract_original_provided := True,
  first_payment_exceeds_contract_ratio_or_amount := True,
  final_payment_exceeds_contract_price := False
\<rparr>"
definition rule14_reject_extra_1 :: rule14_case where
"rule14_reject_extra_1 \<equiv> case14_full_3\<lparr>filing_form_signed_and_commented_by_audit_office := False\<rparr>"
definition rule14_reject_extra_2 :: rule14_case where
"rule14_reject_extra_2 \<equiv> case14_full_2\<lparr>not_overpayment := False\<rparr>"
(* Rule 14: +5 Full +5 Rejection *)
definition rule14_more_full_1 :: rule14_case where
"rule14_more_full_1 \<equiv> case14_full_1\<lparr>
  is_first_payment := True,
  construction_contract_original_provided := True,
  first_payment_exceeds_contract_ratio_or_amount := False
\<rparr>"
definition rule14_more_full_2 :: rule14_case where
"rule14_more_full_2 \<equiv> case14_full_2\<lparr>
  is_first_payment := False,
  construction_contract_original_provided := False
\<rparr>"
definition rule14_more_full_3 :: rule14_case where
"rule14_more_full_3 \<equiv> case14_full_3\<lparr>
  is_first_payment := True,
  construction_contract_original_provided := True,
  first_payment_exceeds_contract_ratio_or_amount := False
\<rparr>"
definition rule14_more_full_4 :: rule14_case where
"rule14_more_full_4 \<equiv> case14_full_3\<lparr>
  project_amount_over_100k := False,
  approval_signed_by_infra_director := False,
  approval_signed_by_vice_president := False
\<rparr>"
definition rule14_more_full_5 :: rule14_case where
"rule14_more_full_5 \<equiv> case14_full_2\<lparr>
  is_final_settlement_payment := True,
  cost_review_opinion_original_provided := True,
  filing_form_original_provided := True,
  opinion_stamped_by_cost_company := True,
  opinion_stamped_by_infra_process := True,
  filing_form_signed_by_engineering_department := True,
  filing_form_signed_and_commented_by_audit_office := True,
  final_payment_based_on_approved_settlement_total := True,
  final_payment_exceeds_contract_price := False
\<rparr>"
definition rule14_more_reject_1 :: rule14_case where
"rule14_more_reject_1 \<equiv> case14_full_1\<lparr>approval_form_original_provided := False\<rparr>"
definition rule14_more_reject_2 :: rule14_case where
"rule14_more_reject_2 \<equiv> case14_full_2\<lparr>payment_follows_contract_progress := False\<rparr>"
definition rule14_more_reject_3 :: rule14_case where
"rule14_more_reject_3 \<equiv> case14_full_1\<lparr>
  is_first_payment := True,
  construction_contract_original_provided := False
\<rparr>"
definition rule14_more_reject_4 :: rule14_case where
"rule14_more_reject_4 \<equiv> case14_full_3\<lparr>
  filing_form_signed_and_commented_by_audit_office := False
\<rparr>"
definition rule14_more_reject_5 :: rule14_case where
"rule14_more_reject_5 \<equiv> case14_full_1\<lparr>
  project_amount_over_100k := True,
  approval_signed_by_infra_director := True,
  approval_signed_by_vice_president := False
\<rparr>"
definition rule14_more_full_cases :: "rule14_case list" where
"rule14_more_full_cases \<equiv> [rule14_more_full_1, rule14_more_full_2, rule14_more_full_3, rule14_more_full_4, rule14_more_full_5]"
definition rule14_more_reject_cases :: "rule14_case list" where
"rule14_more_reject_cases \<equiv> [rule14_more_reject_1, rule14_more_reject_2, rule14_more_reject_3, rule14_more_reject_4, rule14_more_reject_5]"
(* Rule 15: Reimbursement for Warranty Deposits and Audit Fees *)
definition case15_warranty_full_1 :: rule15_case where
  "case15_warranty_full_1 \<equiv> \<lparr>
    rule15_case.claim_type = Claim_Warranty_Refund,
    has_engineering_or_equipment_invoice = True,
    invoice_issued_in_full_amount_including_warranty = True,
    warranty_receipt_issued_by_finance = True,
    warranty_period_expired = True,
    no_quality_dispute_within_warranty_period = True,
    warranty_receipt_provided_for_refund = True,
    department_head_signed_for_refund = True,
    has_cost_review_opinion = False,
    claimed_amount_matches_school_share_in_opinion = False,
    contractor_share_exists = False,
    contractor_invoice_copy_provided = False
  \<rparr> :: rule15_case"
definition case15_warranty_full_2 :: rule15_case where
  "case15_warranty_full_2 \<equiv> \<lparr>
    rule15_case.claim_type = Claim_Warranty_Refund,
    has_engineering_or_equipment_invoice = True,
    invoice_issued_in_full_amount_including_warranty = True,
    warranty_receipt_issued_by_finance = True,
    warranty_period_expired = True,
    no_quality_dispute_within_warranty_period = True,
    warranty_receipt_provided_for_refund = True,
    department_head_signed_for_refund = True,
    has_cost_review_opinion = True,
    claimed_amount_matches_school_share_in_opinion = True,
    contractor_share_exists = True,
    contractor_invoice_copy_provided = False
  \<rparr> :: rule15_case"
definition case15_warranty_full_3 :: rule15_case where
  "case15_warranty_full_3 \<equiv> \<lparr>
    rule15_case.claim_type = Claim_Warranty_Refund,
    has_engineering_or_equipment_invoice = True,
    invoice_issued_in_full_amount_including_warranty = True,
    warranty_receipt_issued_by_finance = True,
    warranty_period_expired = True,
    no_quality_dispute_within_warranty_period = True,
    warranty_receipt_provided_for_refund = True,
    department_head_signed_for_refund = True,
    has_cost_review_opinion = False,
    claimed_amount_matches_school_share_in_opinion = True,
    contractor_share_exists = True,
    contractor_invoice_copy_provided = True
  \<rparr> :: rule15_case"
(* -------- 淇濅慨閲戯細Rejection (3) -------- *)
definition case15_warranty_reject_1 :: rule15_case where
  "case15_warranty_reject_1 \<equiv> \<lparr>
    rule15_case.claim_type = Claim_Warranty_Refund,
    has_engineering_or_equipment_invoice = False,
    invoice_issued_in_full_amount_including_warranty = True,
    warranty_receipt_issued_by_finance = True,
    warranty_period_expired = True,
    no_quality_dispute_within_warranty_period = True,
    warranty_receipt_provided_for_refund = True,
    department_head_signed_for_refund = True,
    has_cost_review_opinion = False,
    claimed_amount_matches_school_share_in_opinion = False,
    contractor_share_exists = False,
    contractor_invoice_copy_provided = False
  \<rparr> :: rule15_case"
definition case15_warranty_reject_2 :: rule15_case where
  "case15_warranty_reject_2 \<equiv> \<lparr>
    rule15_case.claim_type = Claim_Warranty_Refund,
    has_engineering_or_equipment_invoice = True,
    invoice_issued_in_full_amount_including_warranty = True,
    warranty_receipt_issued_by_finance = True,
    warranty_period_expired = False,
    no_quality_dispute_within_warranty_period = True,
    warranty_receipt_provided_for_refund = True,
    department_head_signed_for_refund = True,
    has_cost_review_opinion = False,
    claimed_amount_matches_school_share_in_opinion = False,
    contractor_share_exists = False,
    contractor_invoice_copy_provided = False
  \<rparr> :: rule15_case"
definition case15_warranty_reject_3 :: rule15_case where
  "case15_warranty_reject_3 \<equiv> \<lparr>
    rule15_case.claim_type = Claim_Warranty_Refund,
    has_engineering_or_equipment_invoice = True,
    invoice_issued_in_full_amount_including_warranty = True,
    warranty_receipt_issued_by_finance = True,
    warranty_period_expired = True,
    no_quality_dispute_within_warranty_period = True,
    warranty_receipt_provided_for_refund = True,
    department_head_signed_for_refund = False,
    has_cost_review_opinion = True,
    claimed_amount_matches_school_share_in_opinion = True,
    contractor_share_exists = True,
    contractor_invoice_copy_provided = True
  \<rparr> :: rule15_case"
(* -------- 瀹′环璐癸細Full_Approval (3) -------- *)
definition case15_cost_full_1 :: rule15_case where
  "case15_cost_full_1 \<equiv> \<lparr>
    rule15_case.claim_type = Claim_Cost_Review_Fee,
    has_engineering_or_equipment_invoice = False,
    invoice_issued_in_full_amount_including_warranty = False,
    warranty_receipt_issued_by_finance = False,
    warranty_period_expired = False,
    no_quality_dispute_within_warranty_period = False,
    warranty_receipt_provided_for_refund = False,
    department_head_signed_for_refund = False,
    has_cost_review_opinion = True,
    claimed_amount_matches_school_share_in_opinion = True,
    contractor_share_exists = False,
    contractor_invoice_copy_provided = False
  \<rparr> :: rule15_case"
definition case15_cost_full_2 :: rule15_case where
  "case15_cost_full_2 \<equiv> \<lparr>
    rule15_case.claim_type = Claim_Cost_Review_Fee,
    has_engineering_or_equipment_invoice = True,
    invoice_issued_in_full_amount_including_warranty = False,
    warranty_receipt_issued_by_finance = False,
    warranty_period_expired = False,
    no_quality_dispute_within_warranty_period = False,
    warranty_receipt_provided_for_refund = False,
    department_head_signed_for_refund = False,
    has_cost_review_opinion = True,
    claimed_amount_matches_school_share_in_opinion = True,
    contractor_share_exists = True,
    contractor_invoice_copy_provided = True
  \<rparr> :: rule15_case"
definition case15_cost_full_3 :: rule15_case where
  "case15_cost_full_3 \<equiv> \<lparr>
    rule15_case.claim_type = Claim_Cost_Review_Fee,
    has_engineering_or_equipment_invoice = False,
    invoice_issued_in_full_amount_including_warranty = True,
    warranty_receipt_issued_by_finance = False,
    warranty_period_expired = True,
    no_quality_dispute_within_warranty_period = True,
    warranty_receipt_provided_for_refund = True,
    department_head_signed_for_refund = True,
    has_cost_review_opinion = True,
    claimed_amount_matches_school_share_in_opinion = True,
    contractor_share_exists = True,
    contractor_invoice_copy_provided = True
  \<rparr> :: rule15_case"
(* -------- 瀹′环璐癸細Rejection (3) -------- *)
definition case15_cost_reject_1 :: rule15_case where
  "case15_cost_reject_1 \<equiv> \<lparr>
    rule15_case.claim_type = Claim_Cost_Review_Fee,
    has_engineering_or_equipment_invoice = False,
    invoice_issued_in_full_amount_including_warranty = False,
    warranty_receipt_issued_by_finance = False,
    warranty_period_expired = False,
    no_quality_dispute_within_warranty_period = False,
    warranty_receipt_provided_for_refund = False,
    department_head_signed_for_refund = False,
    has_cost_review_opinion = False,
    claimed_amount_matches_school_share_in_opinion = True,
    contractor_share_exists = False,
    contractor_invoice_copy_provided = False
  \<rparr> :: rule15_case"
definition case15_cost_reject_2 :: rule15_case where
  "case15_cost_reject_2 \<equiv> \<lparr>
    rule15_case.claim_type = Claim_Cost_Review_Fee,
    has_engineering_or_equipment_invoice = False,
    invoice_issued_in_full_amount_including_warranty = False,
    warranty_receipt_issued_by_finance = False,
    warranty_period_expired = False,
    no_quality_dispute_within_warranty_period = False,
    warranty_receipt_provided_for_refund = False,
    department_head_signed_for_refund = False,
    has_cost_review_opinion = True,
    claimed_amount_matches_school_share_in_opinion = False,
    contractor_share_exists = True,
    contractor_invoice_copy_provided = True
  \<rparr> :: rule15_case"
definition case15_cost_reject_3 :: rule15_case where
  "case15_cost_reject_3 \<equiv> \<lparr>
    rule15_case.claim_type = Claim_Cost_Review_Fee,
    has_engineering_or_equipment_invoice = False,
    invoice_issued_in_full_amount_including_warranty = False,
    warranty_receipt_issued_by_finance = False,
    warranty_period_expired = False,
    no_quality_dispute_within_warranty_period = False,
    warranty_receipt_provided_for_refund = False,
    department_head_signed_for_refund = False,
    has_cost_review_opinion = True,
    claimed_amount_matches_school_share_in_opinion = True,
    contractor_share_exists = True,
    contractor_invoice_copy_provided = False
  \<rparr> :: rule15_case"
definition case15_warranty_full_extra_1 :: rule15_case where
  "case15_warranty_full_extra_1 \<equiv> (case15_warranty_full_1 :: rule15_case)\<lparr>
    has_cost_review_opinion := True,
    claimed_amount_matches_school_share_in_opinion := False,
    contractor_share_exists := False,
    contractor_invoice_copy_provided := True
  \<rparr> :: rule15_case"
definition case15_warranty_full_extra_2 :: rule15_case where
  "case15_warranty_full_extra_2 \<equiv> (case15_warranty_full_1 :: rule15_case)\<lparr>
    has_cost_review_opinion := True,
    claimed_amount_matches_school_share_in_opinion := True,
    contractor_share_exists := True,
    contractor_invoice_copy_provided := True
  \<rparr> :: rule15_case"
definition case15_cost_full_extra_1 :: rule15_case where
  "case15_cost_full_extra_1 \<equiv> (case15_cost_full_1 :: rule15_case)\<lparr>
    has_engineering_or_equipment_invoice := True,
    invoice_issued_in_full_amount_including_warranty := True,
    warranty_period_expired := True
  \<rparr> :: rule15_case"
definition case15_cost_full_extra_2 :: rule15_case where
  "case15_cost_full_extra_2 \<equiv> (case15_cost_full_1 :: rule15_case)\<lparr>
    contractor_share_exists := False,
    contractor_invoice_copy_provided := True
  \<rparr> :: rule15_case"
definition case15_warranty_reject_extra_1 :: rule15_case where
  "case15_warranty_reject_extra_1 \<equiv> (case15_warranty_full_1 :: rule15_case)\<lparr>
    warranty_receipt_issued_by_finance := False
  \<rparr> :: rule15_case"
definition case15_warranty_reject_extra_2 :: rule15_case where
  "case15_warranty_reject_extra_2 \<equiv> (case15_warranty_full_1 :: rule15_case)\<lparr>
    no_quality_dispute_within_warranty_period := False
  \<rparr> :: rule15_case"
definition case15_cost_reject_extra_1 :: rule15_case where
  "case15_cost_reject_extra_1 \<equiv> (case15_cost_full_1 :: rule15_case)\<lparr>
    claimed_amount_matches_school_share_in_opinion := False,
    contractor_share_exists := False
  \<rparr> :: rule15_case"
definition case15_cost_reject_extra_2 :: rule15_case where
  "case15_cost_reject_extra_2 \<equiv> (case15_cost_full_1 :: rule15_case)\<lparr>
    has_cost_review_opinion := False,
    claimed_amount_matches_school_share_in_opinion := False
  \<rparr> :: rule15_case"
(* Rule 16: Reimbursement for Fixed Assets, Intangible Assets, and Externally Purchased Materials *)
definition case16_fixed_full_1 :: rule16_case where
  "case16_fixed_full_1 \<equiv> \<lparr>
    claim_type = Claim_Fixed_Asset,
    has_physical_form_goods = True,
    unit_price_over_1000 = True,
    useful_life_over_1_year = False,
    is_bulk_same_kind_materials = False,
    has_fixed_asset_reimbursement_slip_second_copy = True,
    is_book = False,
    fixed_asset_registered_at_asset_management_office = True,
    fixed_asset_registered_at_library = False,
    is_application_software = False,
    intangible_value_at_least_2000 = False,
    not_indispensable_hardware_component = False,
    has_intangible_asset_reimbursement_slip_second_copy = False,
    not_meet_fixed_asset_standard = False,
    not_meet_intangible_asset_standard = False,
    has_purchased_inventory_confirmation_form = False
  \<rparr> :: rule16_case"
definition case16_fixed_full_2 :: rule16_case where
  "case16_fixed_full_2 \<equiv> \<lparr>
    claim_type = Claim_Fixed_Asset,
    has_physical_form_goods = True,
    unit_price_over_1000 = False,
    useful_life_over_1_year = True,
    is_bulk_same_kind_materials = True,
    has_fixed_asset_reimbursement_slip_second_copy = True,
    is_book = True,
    fixed_asset_registered_at_asset_management_office = False,
    fixed_asset_registered_at_library = True,
    is_application_software = False,
    intangible_value_at_least_2000 = False,
    not_indispensable_hardware_component = False,
    has_intangible_asset_reimbursement_slip_second_copy = False,
    not_meet_fixed_asset_standard = False,
    not_meet_intangible_asset_standard = False,
    has_purchased_inventory_confirmation_form = False
  \<rparr> :: rule16_case"
definition case16_fixed_reject_1 :: rule16_case where
  "case16_fixed_reject_1 \<equiv> \<lparr>
    claim_type = Claim_Fixed_Asset,
    has_physical_form_goods = True,
    unit_price_over_1000 = True,
    useful_life_over_1_year = False,
    is_bulk_same_kind_materials = False,
    has_fixed_asset_reimbursement_slip_second_copy = False,
    is_book = False,
    fixed_asset_registered_at_asset_management_office = True,
    fixed_asset_registered_at_library = False,
    is_application_software = False,
    intangible_value_at_least_2000 = False,
    not_indispensable_hardware_component = False,
    has_intangible_asset_reimbursement_slip_second_copy = False,
    not_meet_fixed_asset_standard = False,
    not_meet_intangible_asset_standard = False,
    has_purchased_inventory_confirmation_form = False
  \<rparr> :: rule16_case"
definition case16_fixed_reject_2 :: rule16_case where
  "case16_fixed_reject_2 \<equiv> \<lparr>
    claim_type = Claim_Fixed_Asset,
    has_physical_form_goods = True,
    unit_price_over_1000 = False,
    useful_life_over_1_year = True,
    is_bulk_same_kind_materials = True,
    has_fixed_asset_reimbursement_slip_second_copy = True,
    is_book = True,
    fixed_asset_registered_at_asset_management_office = False,
    fixed_asset_registered_at_library = False,
    is_application_software = False,
    intangible_value_at_least_2000 = False,
    not_indispensable_hardware_component = False,
    has_intangible_asset_reimbursement_slip_second_copy = False,
    not_meet_fixed_asset_standard = False,
    not_meet_intangible_asset_standard = False,
    has_purchased_inventory_confirmation_form = False
  \<rparr> :: rule16_case"
definition case16_intangible_full_1 :: rule16_case where
  "case16_intangible_full_1 \<equiv> \<lparr>
    claim_type = Claim_Intangible_Asset,
    has_physical_form_goods = False,
    unit_price_over_1000 = False,
    useful_life_over_1_year = False,
    is_bulk_same_kind_materials = False,
    has_fixed_asset_reimbursement_slip_second_copy = False,
    is_book = False,
    fixed_asset_registered_at_asset_management_office = False,
    fixed_asset_registered_at_library = False,
    is_application_software = True,
    intangible_value_at_least_2000 = True,
    not_indispensable_hardware_component = True,
    has_intangible_asset_reimbursement_slip_second_copy = True,
    not_meet_fixed_asset_standard = False,
    not_meet_intangible_asset_standard = False,
    has_purchased_inventory_confirmation_form = False
  \<rparr> :: rule16_case"
definition case16_intangible_full_2 :: rule16_case where
  "case16_intangible_full_2 \<equiv> \<lparr>
    claim_type = Claim_Intangible_Asset,
    has_physical_form_goods = True,
    unit_price_over_1000 = True,
    useful_life_over_1_year = True,
    is_bulk_same_kind_materials = True,
    has_fixed_asset_reimbursement_slip_second_copy = True,
    is_book = False,
    fixed_asset_registered_at_asset_management_office = True,
    fixed_asset_registered_at_library = False,
    is_application_software = True,
    intangible_value_at_least_2000 = True,
    not_indispensable_hardware_component = True,
    has_intangible_asset_reimbursement_slip_second_copy = True,
    not_meet_fixed_asset_standard = False,
    not_meet_intangible_asset_standard = False,
    has_purchased_inventory_confirmation_form = False
  \<rparr> :: rule16_case"
definition case16_intangible_reject_1 :: rule16_case where
  "case16_intangible_reject_1 \<equiv> \<lparr>
    claim_type = Claim_Intangible_Asset,
    has_physical_form_goods = False,
    unit_price_over_1000 = False,
    useful_life_over_1_year = False,
    is_bulk_same_kind_materials = False,
    has_fixed_asset_reimbursement_slip_second_copy = False,
    is_book = False,
    fixed_asset_registered_at_asset_management_office = False,
    fixed_asset_registered_at_library = False,
    is_application_software = True,
    intangible_value_at_least_2000 = False,
    not_indispensable_hardware_component = True,
    has_intangible_asset_reimbursement_slip_second_copy = True,
    not_meet_fixed_asset_standard = False,
    not_meet_intangible_asset_standard = False,
    has_purchased_inventory_confirmation_form = False
  \<rparr> :: rule16_case"
definition case16_intangible_reject_2 :: rule16_case where
  "case16_intangible_reject_2 \<equiv> \<lparr>
    claim_type = Claim_Intangible_Asset,
    has_physical_form_goods = False,
    unit_price_over_1000 = False,
    useful_life_over_1_year = False,
    is_bulk_same_kind_materials = False,
    has_fixed_asset_reimbursement_slip_second_copy = False,
    is_book = False,
    fixed_asset_registered_at_asset_management_office = False,
    fixed_asset_registered_at_library = False,
    is_application_software = True,
    intangible_value_at_least_2000 = True,
    not_indispensable_hardware_component = True,
    has_intangible_asset_reimbursement_slip_second_copy = False,
    not_meet_fixed_asset_standard = False,
    not_meet_intangible_asset_standard = False,
    has_purchased_inventory_confirmation_form = False
  \<rparr> :: rule16_case"
definition case16_material_full_1 :: rule16_case where
  "case16_material_full_1 \<equiv> \<lparr>
    claim_type = Claim_Purchased_Material,
    has_physical_form_goods = False,
    unit_price_over_1000 = False,
    useful_life_over_1_year = False,
    is_bulk_same_kind_materials = False,
    has_fixed_asset_reimbursement_slip_second_copy = False,
    is_book = False,
    fixed_asset_registered_at_asset_management_office = False,
    fixed_asset_registered_at_library = False,
    is_application_software = False,
    intangible_value_at_least_2000 = False,
    not_indispensable_hardware_component = False,
    has_intangible_asset_reimbursement_slip_second_copy = False,
    not_meet_fixed_asset_standard = True,
    not_meet_intangible_asset_standard = True,
    has_purchased_inventory_confirmation_form = True
  \<rparr> :: rule16_case"
definition case16_material_full_2 :: rule16_case where
  "case16_material_full_2 \<equiv> \<lparr>
    claim_type = Claim_Purchased_Material,
    has_physical_form_goods = True,
    unit_price_over_1000 = False,
    useful_life_over_1_year = False,
    is_bulk_same_kind_materials = False,
    has_fixed_asset_reimbursement_slip_second_copy = False,
    is_book = False,
    fixed_asset_registered_at_asset_management_office = False,
    fixed_asset_registered_at_library = False,
    is_application_software = False,
    intangible_value_at_least_2000 = False,
    not_indispensable_hardware_component = False,
    has_intangible_asset_reimbursement_slip_second_copy = False,
    not_meet_fixed_asset_standard = True,
    not_meet_intangible_asset_standard = True,
    has_purchased_inventory_confirmation_form = True
  \<rparr> :: rule16_case"
definition case16_material_reject_1 :: rule16_case where
  "case16_material_reject_1 \<equiv> \<lparr>
    claim_type = Claim_Purchased_Material,
    has_physical_form_goods = False,
    unit_price_over_1000 = False,
    useful_life_over_1_year = False,
    is_bulk_same_kind_materials = False,
    has_fixed_asset_reimbursement_slip_second_copy = False,
    is_book = False,
    fixed_asset_registered_at_asset_management_office = False,
    fixed_asset_registered_at_library = False,
    is_application_software = False,
    intangible_value_at_least_2000 = False,
    not_indispensable_hardware_component = False,
    has_intangible_asset_reimbursement_slip_second_copy = False,
    not_meet_fixed_asset_standard = False,
    not_meet_intangible_asset_standard = True,
    has_purchased_inventory_confirmation_form = True
  \<rparr> :: rule16_case"
definition case16_material_reject_2 :: rule16_case where
  "case16_material_reject_2 \<equiv> \<lparr>
    claim_type = Claim_Purchased_Material,
    has_physical_form_goods = False,
    unit_price_over_1000 = False,
    useful_life_over_1_year = False,
    is_bulk_same_kind_materials = False,
    has_fixed_asset_reimbursement_slip_second_copy = False,
    is_book = False,
    fixed_asset_registered_at_asset_management_office = False,
    fixed_asset_registered_at_library = False,
    is_application_software = False,
    intangible_value_at_least_2000 = False,
    not_indispensable_hardware_component = False,
    has_intangible_asset_reimbursement_slip_second_copy = False,
    not_meet_fixed_asset_standard = True,
    not_meet_intangible_asset_standard = True,
    has_purchased_inventory_confirmation_form = False
  \<rparr> :: rule16_case"
definition case16_fixed_full_extra_1 :: rule16_case where
  "case16_fixed_full_extra_1 \<equiv> (case16_fixed_full_1 :: rule16_case)\<lparr>
    useful_life_over_1_year := True,
    is_bulk_same_kind_materials := True
  \<rparr> :: rule16_case"
definition case16_fixed_full_extra_2 :: rule16_case where
  "case16_fixed_full_extra_2 \<equiv> (case16_fixed_full_2 :: rule16_case)\<lparr>
    has_physical_form_goods := True,
    unit_price_over_1000 := True
  \<rparr> :: rule16_case"
definition case16_intangible_full_extra_1 :: rule16_case where
  "case16_intangible_full_extra_1 \<equiv> (case16_intangible_full_1 :: rule16_case)\<lparr>
    has_physical_form_goods := True,
    unit_price_over_1000 := True
  \<rparr> :: rule16_case"
definition case16_material_full_extra_1 :: rule16_case where
  "case16_material_full_extra_1 \<equiv> (case16_material_full_1 :: rule16_case)\<lparr>
    has_physical_form_goods := True,
    useful_life_over_1_year := True
  \<rparr> :: rule16_case"
definition case16_fixed_reject_extra_1 :: rule16_case where
  "case16_fixed_reject_extra_1 \<equiv> (case16_fixed_full_1 :: rule16_case)\<lparr>
    fixed_asset_registered_at_asset_management_office := False
  \<rparr> :: rule16_case"
definition case16_fixed_reject_extra_2 :: rule16_case where
  "case16_fixed_reject_extra_2 \<equiv> (case16_fixed_full_2 :: rule16_case)\<lparr>
    has_fixed_asset_reimbursement_slip_second_copy := False
  \<rparr> :: rule16_case"
definition case16_intangible_reject_extra_1 :: rule16_case where
  "case16_intangible_reject_extra_1 \<equiv> (case16_intangible_full_1 :: rule16_case)\<lparr>
    not_indispensable_hardware_component := False
  \<rparr> :: rule16_case"
definition case16_material_reject_extra_1 :: rule16_case where
  "case16_material_reject_extra_1 \<equiv> (case16_material_full_1 :: rule16_case)\<lparr>
    not_meet_intangible_asset_standard := False
  \<rparr> :: rule16_case"
(* Rule 17: Reimbursement for Instrument and Equipment Maintenance Fees *)
definition case_invoice_approval :: rule4_case where
  "case_invoice_approval \<equiv> \<lparr>
    invoice_lacks_supervision_seal = False,
    invoice_scope_mismatch = False,
    invoice_content_incomplete = False,
    invoice_missing_date = False,
    invoice_missing_quantity = False,
    invoice_missing_unit_price = False,
    invoice_missing_amount = False,
    invoice_missing_description = False,
    invoice_missing_payee_seal = False,
    invoice_amount_figures_words_inconsistent = False,
    invoice_altered = False,
    invoice_forged = False,
    invoice_fraudulent = False,
    taxi_receipts_consecutive_numbers = False,
    taxi_receipts_large_quantity_same_taxi = False,
    reimbursement_procedure_incomplete = False
  \<rparr>"
definition case_maint_approval :: rule17_case where
  "case_maint_approval \<equiv> \<lparr>
    is_equipment_maintenance_fee = True,
    has_application_in_asset_management_system = True,
    has_maintenance_application_form = True,
    maintenance_form_signed_by_relevant_personnel = True,
    maintenance_form_stamped_by_unit = True,
    has_original_invoices = True
  \<rparr>"
definition combined_case_full_1 :: "rule4_case * rule17_case" where
  "combined_case_full_1 \<equiv> (case_invoice_approval, case_maint_approval)"
definition case_invoice_r1  :: rule4_case where "case_invoice_r1  \<equiv> case_invoice_approval\<lparr>invoice_missing_date := True\<rparr>"
definition case_invoice_r2  :: rule4_case where "case_invoice_r2  \<equiv> case_invoice_approval\<lparr>invoice_missing_amount := True\<rparr>"
definition case_invoice_r3  :: rule4_case where "case_invoice_r3  \<equiv> case_invoice_approval\<lparr>invoice_forged := True\<rparr>"
definition case_invoice_r4  :: rule4_case where "case_invoice_r4  \<equiv> case_invoice_approval\<lparr>invoice_fraudulent := True\<rparr>"
definition case_invoice_r5  :: rule4_case where "case_invoice_r5  \<equiv> case_invoice_approval\<lparr>taxi_receipts_consecutive_numbers := True\<rparr>"
definition case_invoice_r6  :: rule4_case where "case_invoice_r6  \<equiv> case_invoice_approval\<lparr>invoice_scope_mismatch := True, invoice_missing_payee_seal := True\<rparr>"
definition case_invoice_r7  :: rule4_case where "case_invoice_r7  \<equiv> case_invoice_approval\<lparr>invoice_content_incomplete := True, invoice_missing_description := True\<rparr>"
definition case_invoice_r8  :: rule4_case where "case_invoice_r8  \<equiv> case_invoice_approval\<lparr>invoice_altered := True, invoice_amount_figures_words_inconsistent := True\<rparr>"
definition case_invoice_r9  :: rule4_case where "case_invoice_r9  \<equiv> case_invoice_approval\<lparr>taxi_receipts_large_quantity_same_taxi := True, reimbursement_procedure_incomplete := True\<rparr>"
definition case_invoice_r10 :: rule4_case where "case_invoice_r10 \<equiv> case_invoice_approval\<lparr>invoice_lacks_supervision_seal := True, invoice_missing_unit_price := True, invoice_missing_quantity := True\<rparr>"
definition case_invoice_r11 :: rule4_case where "case_invoice_r11 \<equiv> case_invoice_approval\<lparr>invoice_missing_description := True, taxi_receipts_consecutive_numbers := True\<rparr>"
definition case_invoice_r12 :: rule4_case where "case_invoice_r12 \<equiv> case_invoice_approval\<lparr>invoice_scope_mismatch := True, invoice_altered := True, invoice_missing_date := True\<rparr>"
definition case_maint_r1 :: rule17_case where "case_maint_r1 \<equiv> case_maint_approval\<lparr>has_original_invoices := False\<rparr>"
definition case_maint_r2 :: rule17_case where "case_maint_r2 \<equiv> case_maint_approval\<lparr>has_application_in_asset_management_system := False\<rparr>"
definition case_maint_r3 :: rule17_case where "case_maint_r3 \<equiv> case_maint_approval\<lparr>has_maintenance_application_form := False\<rparr>"
definition case_maint_r4 :: rule17_case where "case_maint_r4 \<equiv> case_maint_approval\<lparr>maintenance_form_signed_by_relevant_personnel := False\<rparr>"
definition case_maint_r5 :: rule17_case where "case_maint_r5 \<equiv> case_maint_approval\<lparr>maintenance_form_stamped_by_unit := False\<rparr>"
definition case_maint_r6 :: rule17_case where "case_maint_r6 \<equiv> case_maint_approval\<lparr>is_equipment_maintenance_fee := False\<rparr>"
definition case_maint_r7 :: rule17_case where "case_maint_r7 \<equiv> case_maint_approval\<lparr>has_application_in_asset_management_system := False, has_original_invoices := False\<rparr>"
definition case_maint_r8 :: rule17_case where "case_maint_r8 \<equiv> case_maint_approval\<lparr>has_maintenance_application_form := False, maintenance_form_stamped_by_unit := False, has_original_invoices := False\<rparr>"
definition combined_case_reject_1  :: "rule4_case * rule17_case" where "combined_case_reject_1  \<equiv> (case_invoice_r1,  case_maint_approval)"
definition combined_case_reject_2  :: "rule4_case * rule17_case" where "combined_case_reject_2  \<equiv> (case_invoice_r2,  case_maint_approval)"
definition combined_case_reject_3  :: "rule4_case * rule17_case" where "combined_case_reject_3  \<equiv> (case_invoice_r3,  case_maint_approval)"
definition combined_case_reject_4  :: "rule4_case * rule17_case" where "combined_case_reject_4  \<equiv> (case_invoice_r4,  case_maint_approval)"
definition combined_case_reject_5  :: "rule4_case * rule17_case" where "combined_case_reject_5  \<equiv> (case_invoice_r5,  case_maint_approval)"
definition combined_case_reject_6  :: "rule4_case * rule17_case" where "combined_case_reject_6  \<equiv> (case_invoice_r6,  case_maint_approval)"
definition combined_case_reject_7  :: "rule4_case * rule17_case" where "combined_case_reject_7  \<equiv> (case_invoice_r7,  case_maint_approval)"
definition combined_case_reject_8  :: "rule4_case * rule17_case" where "combined_case_reject_8  \<equiv> (case_invoice_r8,  case_maint_approval)"
definition combined_case_reject_9  :: "rule4_case * rule17_case" where "combined_case_reject_9  \<equiv> (case_invoice_r9,  case_maint_approval)"
definition combined_case_reject_10 :: "rule4_case * rule17_case" where "combined_case_reject_10 \<equiv> (case_invoice_r10, case_maint_approval)"
definition combined_case_reject_11 :: "rule4_case * rule17_case" where "combined_case_reject_11 \<equiv> (case_invoice_r11, case_maint_approval)"
definition combined_case_reject_12 :: "rule4_case * rule17_case" where "combined_case_reject_12 \<equiv> (case_invoice_r12, case_maint_approval)"
definition combined_case_reject_13 :: "rule4_case * rule17_case" where "combined_case_reject_13 \<equiv> (case_invoice_approval, case_maint_r1)"
definition combined_case_reject_14 :: "rule4_case * rule17_case" where "combined_case_reject_14 \<equiv> (case_invoice_approval, case_maint_r2)"
definition combined_case_reject_15 :: "rule4_case * rule17_case" where "combined_case_reject_15 \<equiv> (case_invoice_approval, case_maint_r3)"
definition combined_case_reject_16 :: "rule4_case * rule17_case" where "combined_case_reject_16 \<equiv> (case_invoice_approval, case_maint_r4)"
definition combined_case_reject_17 :: "rule4_case * rule17_case" where "combined_case_reject_17 \<equiv> (case_invoice_approval, case_maint_r5)"
definition combined_case_reject_18 :: "rule4_case * rule17_case" where "combined_case_reject_18 \<equiv> (case_invoice_approval, case_maint_r6)"
definition combined_case_reject_19 :: "rule4_case * rule17_case" where "combined_case_reject_19 \<equiv> (case_invoice_r6, case_maint_r7)"
definition combined_case_reject_20 :: "rule4_case * rule17_case" where "combined_case_reject_20 \<equiv> (case_invoice_r12, case_maint_r8)"
(* Rule 18: Reimbursement for Official Hospitality Expenses *)
definition case18_full_base :: rule18_case where
  "case18_full_base \<equiv> \<lparr>
    is_domestic_official_hospitality = True,
    processed_per_event = True,
    has_financial_invoices = True,
    has_official_letter_from_sending_unit = True,
    official_letter_includes_purpose = True,
    official_letter_includes_agenda = True,
    official_letter_includes_visitor_list = True,
    has_hospitality_list_form = True,
    has_hospitality_approval_form = True,
    has_accommodation_expense_claimed = False,
    accommodation_arranged_for_visitors = True,
    visitor_level_provincial_ministerial = False,
    accommodation_arranged_in_standard_room = True,
    accommodation_arranged_in_suite_for_provincial_level = False,
    is_local_shanghai_unit_visit = False,
    accommodation_arranged_for_local_visit = False,
    is_working_meal_necessary = True,
    meal_type_boxed_lunch_or_buffet = True,
    daily_meal_standard_per_person = 100,
    daily_meal_standard_exceeds_100 = False,
    has_one_formal_meal = True,
    formal_meal_standard_per_person = 150,
    formal_meal_standard_exceeds_150 = False,
    visitor_count = 9,
    accompanying_person_count = 3,
    accompanying_person_controlled = True,
    accompanying_staff_simple_meal_standard = 50,
    accompanying_staff_simple_meal_exceeds_50 = False,
    group_transportation_arranged = True,
    vehicle_selection_reasonable = True,
    accompanying_vehicles_controlled = True
  \<rparr>"
definition case18_full_1 :: rule18_case where
  "case18_full_1 \<equiv> case18_full_base"
definition case18_full_2 :: rule18_case where
  "case18_full_2 \<equiv> case18_full_base\<lparr>
    accommodation_arranged_for_visitors := False,
    is_working_meal_necessary := False,
    has_one_formal_meal := False
  \<rparr>"
definition case18_full_3 :: rule18_case where
  "case18_full_3 \<equiv> case18_full_base\<lparr>
    visitor_level_provincial_ministerial := True,
    accommodation_arranged_in_standard_room := False,
    accommodation_arranged_in_suite_for_provincial_level := True,
    visitor_count := 15,
    accompanying_person_count := 5
  \<rparr>"
definition case18_reject_1 :: rule18_case where
  "case18_reject_1 \<equiv> case18_full_base\<lparr>
    is_domestic_official_hospitality := False
  \<rparr>"
definition case18_reject_2 :: rule18_case where
  "case18_reject_2 \<equiv> case18_full_base\<lparr>
    has_official_letter_from_sending_unit := False
  \<rparr>"
definition case18_reject_3 :: rule18_case where
  "case18_reject_3 \<equiv> case18_full_base\<lparr>
    has_hospitality_approval_form := False
  \<rparr>"
definition case18_partial_1 :: rule18_case where
  "case18_partial_1 \<equiv> case18_full_base\<lparr>
    has_accommodation_expense_claimed := True
  \<rparr>"
definition case18_partial_2 :: rule18_case where
  "case18_partial_2 \<equiv> case18_full_base\<lparr>
    is_local_shanghai_unit_visit := True,
    accommodation_arranged_for_local_visit := True
  \<rparr>"
definition case18_partial_3 :: rule18_case where
  "case18_partial_3 \<equiv> case18_full_base\<lparr>
    daily_meal_standard_per_person := 120,
    daily_meal_standard_exceeds_100 := True
  \<rparr>"
definition case18_full_4 :: rule18_case where
  "case18_full_4 \<equiv> case18_full_base\<lparr>
    visitor_count := 12,
    accompanying_person_count := 4,
    has_one_formal_meal := False,
    formal_meal_standard_per_person := 0
  \<rparr>"
definition case18_full_5 :: rule18_case where
  "case18_full_5 \<equiv> case18_full_base\<lparr>
    is_local_shanghai_unit_visit := True,
    accommodation_arranged_for_local_visit := False,
    is_working_meal_necessary := False,
    meal_type_boxed_lunch_or_buffet := False,
    has_one_formal_meal := False,
    formal_meal_standard_per_person := 0
  \<rparr>"
definition case18_reject_4 :: rule18_case where
  "case18_reject_4 \<equiv> case18_full_base\<lparr>
    has_financial_invoices := False
  \<rparr>"
definition case18_reject_5 :: rule18_case where
  "case18_reject_5 \<equiv> case18_full_base\<lparr>
    official_letter_includes_visitor_list := False
  \<rparr>"
definition case18_partial_4 :: rule18_case where
  "case18_partial_4 \<equiv> case18_full_base\<lparr>
    formal_meal_standard_per_person := 180,
    formal_meal_standard_exceeds_150 := True
  \<rparr>"
definition case18_partial_5 :: rule18_case where
  "case18_partial_5 \<equiv> case18_full_base\<lparr>
    visitor_count := 10,
    accompanying_person_count := 4
  \<rparr>"
definition case18_partial_6 :: rule18_case where
  "case18_partial_6 \<equiv> case18_full_base\<lparr>
    visitor_count := 14,
    accompanying_person_count := 5
  \<rparr>"
definition case18_partial_7 :: rule18_case where
  "case18_partial_7 \<equiv> case18_full_base\<lparr>
    accompanying_staff_simple_meal_standard := 60,
    accompanying_staff_simple_meal_exceeds_50 := True
  \<rparr>"
definition case18_partial_8 :: rule18_case where
  "case18_partial_8 \<equiv> case18_full_base\<lparr>
    meal_type_boxed_lunch_or_buffet := False
  \<rparr>"
definition case18_partial_9 :: rule18_case where
  "case18_partial_9 \<equiv> case18_full_base\<lparr>
    vehicle_selection_reasonable := False
  \<rparr>"
definition case18_partial_10 :: rule18_case where
  "case18_partial_10 \<equiv> case18_full_base\<lparr>
    visitor_level_provincial_ministerial := True,
    accommodation_arranged_in_standard_room := False,
    accommodation_arranged_in_suite_for_provincial_level := False
  \<rparr>"
(* Rule 18: +5 Full +5 Rejection *)
definition rule18_more_full_1 :: rule18_case where
"rule18_more_full_1 \<equiv> case18_full_base\<lparr>
  visitor_count := 6,
  accompanying_person_count := 2,
  daily_meal_standard_per_person := 90,
  formal_meal_standard_per_person := 120
\<rparr>"
definition rule18_more_full_2 :: rule18_case where
"rule18_more_full_2 \<equiv> case18_full_base\<lparr>
  is_working_meal_necessary := False,
  meal_type_boxed_lunch_or_buffet := False,
  has_one_formal_meal := False,
  formal_meal_standard_per_person := 0,
  daily_meal_standard_per_person := 0
\<rparr>"
definition rule18_more_full_3 :: rule18_case where
"rule18_more_full_3 \<equiv> case18_full_base\<lparr>
  visitor_level_provincial_ministerial := True,
  accommodation_arranged_in_standard_room := False,
  accommodation_arranged_in_suite_for_provincial_level := True,
  visitor_count := 20,
  accompanying_person_count := 6
\<rparr>"
definition rule18_more_full_4 :: rule18_case where
"rule18_more_full_4 \<equiv> case18_full_base\<lparr>
  accommodation_arranged_for_visitors := False,
  is_local_shanghai_unit_visit := True,
  accommodation_arranged_for_local_visit := False
\<rparr>"
definition rule18_more_full_5 :: rule18_case where
"rule18_more_full_5 \<equiv> case18_full_base\<lparr>
  visitor_count := 10,
  accompanying_person_count := 3,
  daily_meal_standard_per_person := 100,
  accompanying_staff_simple_meal_standard := 45
\<rparr>"
definition rule18_more_reject_1 :: rule18_case where
"rule18_more_reject_1 \<equiv> case18_full_base\<lparr>
  processed_per_event := False,
  has_hospitality_list_form := False
\<rparr>"
definition rule18_more_reject_2 :: rule18_case where
"rule18_more_reject_2 \<equiv> case18_full_base\<lparr>
  official_letter_includes_purpose := False
\<rparr>"
definition rule18_more_reject_3 :: rule18_case where
"rule18_more_reject_3 \<equiv> case18_full_base\<lparr>
  official_letter_includes_agenda := False
\<rparr>"
definition rule18_more_reject_4 :: rule18_case where
"rule18_more_reject_4 \<equiv> case18_full_base\<lparr>
  has_hospitality_list_form := False
\<rparr>"
definition rule18_more_reject_5 :: rule18_case where
"rule18_more_reject_5 \<equiv> case18_full_base\<lparr>
  has_official_letter_from_sending_unit := False,
  official_letter_includes_purpose := False
\<rparr>"
definition rule18_more_full_cases :: "rule18_case list" where
"rule18_more_full_cases \<equiv> [rule18_more_full_1, rule18_more_full_2, rule18_more_full_3, rule18_more_full_4, rule18_more_full_5]"
definition rule18_more_reject_cases :: "rule18_case list" where
"rule18_more_reject_cases \<equiv> [rule18_more_reject_1, rule18_more_reject_2, rule18_more_reject_3, rule18_more_reject_4, rule18_more_reject_5]"
(* Rule 19: Reimbursement for Visitor Expenses *)
definition case19_full_base :: rule19_case where
  "case19_full_base \<equiv> \<lparr>
    visit_scope = R19_Domestic_Visit,
    has_truthful_filing_to_foreign_affairs_office = True,
    has_fudan_overseas_expert_fund_report = True,
    signed_by_responsible_person = True,
    signed_by_handler = True,
    has_domestic_reception_list = True,
    domestic_list_signed_by_responsible_person = True,
    domestic_list_has_visitor_org = True,
    domestic_list_has_visitor_name = True,
    domestic_list_has_visit_reason = True,
    claims_lodging = True,
    claims_intercity_transport = True,
    claims_daily_meal = True,
    claims_banquet = True,
    claims_local_transport = True,
    claims_gift = True,
    claims_staff_mismeal_subsidy = True,
    delegation_led_by_vice_minister_or_above = False,
    hotel_star = 4,
    guest_level = R19_Other,
    daily_meal_ppd = 280,
    banquet_type = R19_Formal_Banquet,
    banquet_host_is_ministerial_or_vice = False,
    banquet_pp_once = 280,
    local_transport_compliant_with_level_standard = True,
    gift_target_level = R19_Gift_Bureau,
    gift_pp_once = 180,
    gift_is_small_souvenir_for_other = False,
    is_major_diplomatic_event_for_head_state = False,
    arranged_by_protocol_requirement = False,
    foreign_guest_count = 4,
    our_accompany_count = 4,
    staff_mismeal_subsidy_pp_once = 50,
    is_conference_related_visit = False,
    conference_has_lodging_or_meal_expense = False,
    linked_rule9_case = case9_full_1,
    linked_rule7_case = case7_full_1
  \<rparr>"
(* ---------- 3 Full ---------- *)
definition case19_full_1 :: rule19_case where
  "case19_full_1 \<equiv> case19_full_base"
definition case19_full_2 :: rule19_case where
  "case19_full_2 \<equiv> case19_full_base\<lparr>
    delegation_led_by_vice_minister_or_above := True,
    hotel_star := 5,
    guest_level := R19_Ministerial_or_ViceMinisterial,
    daily_meal_ppd := 500,
    banquet_host_is_ministerial_or_vice := True,
    banquet_pp_once := 400,
    gift_target_level := R19_Gift_Ministerial_or_ViceMinisterial,
    gift_pp_once := 400
  \<rparr>"
definition case19_full_3 :: rule19_case where
  "case19_full_3 \<equiv> case19_full_base\<lparr>
    is_conference_related_visit := True,
    conference_has_lodging_or_meal_expense := True,
    linked_rule9_case := case9_full_1
  \<rparr>"
definition case19_partial_1 :: rule19_case where
  "case19_partial_1 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    daily_meal_ppd := 320
  \<rparr>"
definition case19_partial_2 :: rule19_case where
  "case19_partial_2 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    gift_target_level := R19_Gift_Bureau,
    gift_pp_once := 260
  \<rparr>"
definition case19_partial_3 :: rule19_case where
  "case19_partial_3 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    staff_mismeal_subsidy_pp_once := 80
  \<rparr>" 
definition case19_partial_4 :: rule19_case where
  "case19_partial_4 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    foreign_guest_count := 3,
    our_accompany_count := 5
  \<rparr>"
definition case19_reject_1 :: rule19_case where
  "case19_reject_1 \<equiv> case19_full_base\<lparr>
    has_fudan_overseas_expert_fund_report := False
  \<rparr>"
definition case19_rejectpartial_2 :: rule19_case where
  "case19_rejectpartial_2 \<equiv> case19_full_base\<lparr>
    is_conference_related_visit := True,
    conference_has_lodging_or_meal_expense := True,
    linked_rule9_case := case9_partial_1
  \<rparr>" 
definition case19_full_4 :: rule19_case where
  "case19_full_4 \<equiv> case19_full_base\<lparr>
    is_conference_related_visit := True,
    conference_has_lodging_or_meal_expense := True,
    linked_rule9_case := case9_full_2
  \<rparr>"
definition case19_full_5 :: rule19_case where
  "case19_full_5 \<equiv> case19_full_base\<lparr>
    is_conference_related_visit := True,
    conference_has_lodging_or_meal_expense := True,
    linked_rule9_case := case9_full_3
  \<rparr>"
definition case19_full_6 :: rule19_case where
  "case19_full_6 \<equiv> case19_full_base\<lparr>
    claims_lodging := False,
    claims_daily_meal := False,
    claims_banquet := False,
    claims_local_transport := False,
    claims_gift := False,
    claims_staff_mismeal_subsidy := False,
    is_conference_related_visit := True,
    conference_has_lodging_or_meal_expense := True,
    linked_rule9_case := case9_full_1
  \<rparr>"
definition case19_full_7 :: rule19_case where
  "case19_full_7 \<equiv> case19_full_base\<lparr>
    gift_target_level := R19_Gift_Other,
    gift_pp_once := 60,
    gift_is_small_souvenir_for_other := True
  \<rparr>"
definition case19_full_8 :: rule19_case where
  "case19_full_8 \<equiv> case19_full_base\<lparr>
    banquet_type := R19_Tea,
    banquet_pp_once := 60,
    banquet_host_is_ministerial_or_vice := True
  \<rparr>"
definition case19_full_9 :: rule19_case where
  "case19_full_9 \<equiv> case19_full_base\<lparr>
    is_major_diplomatic_event_for_head_state := True,
    arranged_by_protocol_requirement := True,
    foreign_guest_count := 18,
    our_accompany_count := 24
  \<rparr>"
definition case19_full_10 :: rule19_case where
  "case19_full_10 \<equiv> case19_full_base\<lparr>
    guest_level := R19_VicePremier_or_ParliamentLevel,
    daily_meal_ppd := 540,
    banquet_type := R19_Cocktail,
    banquet_pp_once := 100,
    is_conference_related_visit := True,
    conference_has_lodging_or_meal_expense := True,
    linked_rule9_case := case9_full_2
  \<rparr>"
(* ===== Rule19 extra Partial cases (add 11; Partial total = 15) ===== *)
definition case19_partial_5 :: rule19_case where
  "case19_partial_5 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    hotel_star := 5
  \<rparr>"
definition case19_partial_6 :: rule19_case where
  "case19_partial_6 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    delegation_led_by_vice_minister_or_above := True,
    hotel_star := 3
  \<rparr>"
definition case19_partial_7 :: rule19_case where
  "case19_partial_7 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    daily_meal_ppd := 301
  \<rparr>"
definition case19_partial_8 :: rule19_case where
  "case19_partial_8 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    banquet_type := R19_Formal_Banquet,
    banquet_host_is_ministerial_or_vice := False,
    banquet_pp_once := 301
  \<rparr>"
definition case19_partial_9 :: rule19_case where
  "case19_partial_9 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    banquet_type := R19_Tea,
    banquet_pp_once := 70
  \<rparr>"
definition case19_partial_10 :: rule19_case where
  "case19_partial_10 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    local_transport_compliant_with_level_standard := False
  \<rparr>"
definition case19_partial_11 :: rule19_case where
  "case19_partial_11 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    gift_target_level := R19_Gift_Ministerial_or_ViceMinisterial,
    gift_pp_once := 450
  \<rparr>"
definition case19_partial_12 :: rule19_case where
  "case19_partial_12 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    gift_target_level := R19_Gift_Other,
    gift_is_small_souvenir_for_other := False,
    gift_pp_once := 20
  \<rparr>"
definition case19_partial_13 :: rule19_case where
  "case19_partial_13 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    foreign_guest_count := 6,
    our_accompany_count := 8
  \<rparr>"
definition case19_partial_14 :: rule19_case where
  "case19_partial_14 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    is_major_diplomatic_event_for_head_state := True,
    arranged_by_protocol_requirement := False,
    foreign_guest_count := 10,
    our_accompany_count := 20
  \<rparr>"
definition case19_partial_15 :: rule19_case where
  "case19_partial_15 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    staff_mismeal_subsidy_pp_once := 55
  \<rparr>"

definition case19_partial_16 :: rule19_case where
  "case19_partial_16 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    daily_meal_ppd := 310
  \<rparr>"
(* ===== Rule19 extra Rejection cases (add 8; Rejection total = 10) ===== *)
definition case19_reject_3 :: rule19_case where
  "case19_reject_3 \<equiv> case19_full_base\<lparr>
    has_truthful_filing_to_foreign_affairs_office := False
  \<rparr>"
definition case19_reject_4 :: rule19_case where
  "case19_reject_4 \<equiv> case19_full_base\<lparr>
    signed_by_handler := False
  \<rparr>"
definition case19_rejectpartial_5 :: rule19_case where
  "case19_rejectpartial_5 \<equiv> case19_full_base\<lparr>
    is_conference_related_visit := True,
    conference_has_lodging_or_meal_expense := True,
    linked_rule9_case := case9_partial_2
  \<rparr>"
definition case19_rejectpartial_6 :: rule19_case where
  "case19_rejectpartial_6 \<equiv> case19_full_base\<lparr>
    is_conference_related_visit := True,
    conference_has_lodging_or_meal_expense := True,
    linked_rule9_case := case9_partial_3
  \<rparr>"
definition case19_rejectpartial_7 :: rule19_case where
  "case19_rejectpartial_7 \<equiv> case19_full_base\<lparr>
    is_conference_related_visit := True,
    conference_has_lodging_or_meal_expense := True,
    linked_rule9_case := case9_partial_4
  \<rparr>"
definition case19_reject_8 :: rule19_case where
  "case19_reject_8 \<equiv> case19_full_base\<lparr>
    is_conference_related_visit := True,
    conference_has_lodging_or_meal_expense := True,
    linked_rule9_case := case9_reject_1
  \<rparr>"
definition case19_reject_9 :: rule19_case where
  "case19_reject_9 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    is_conference_related_visit := True,
    conference_has_lodging_or_meal_expense := True,
    linked_rule9_case := case9_reject_2
  \<rparr>"
definition case19_reject_10 :: rule19_case where
  "case19_reject_10 \<equiv> case19_full_base\<lparr>
    visit_scope := R19_Overseas_Visit,
    has_fudan_overseas_expert_fund_report := False,
    is_conference_related_visit := True,
    conference_has_lodging_or_meal_expense := True,
    linked_rule9_case := case9_full_1
  \<rparr>"
(* Rule 20: Temporary Loans and Write-offs *)
definition case20_can_1 :: rule20_case where
  "case20_can_1 \<equiv> \<lparr>
    is_special_business_for_temp_loan = True,
    cannot_get_invoice_in_advance = True,
    borrower_is_fudan_staff = True,
    borrower_is_leased_personnel_R_or_L = False,
    borrower_is_postdoc = False,
    borrower_signed_reservation_form = True,
    borrower_is_retired = False,
    borrower_is_student = False,
    borrower_is_external_personnel = False,
    is_same_city_settlement = True,
    is_nonlocal_settlement = False,
    days_until_writeoff = 20,
    has_unwritten_off_loan = False,
    has_special_reason_for_new_loan = False
  \<rparr>"
definition case20_can_2 :: rule20_case where
  "case20_can_2 \<equiv> \<lparr>
    is_special_business_for_temp_loan = True,
    cannot_get_invoice_in_advance = True,
    borrower_is_fudan_staff = False,
    borrower_is_leased_personnel_R_or_L = True,
    borrower_is_postdoc = False,
    borrower_signed_reservation_form = True,
    borrower_is_retired = False,
    borrower_is_student = False,
    borrower_is_external_personnel = False,
    is_same_city_settlement = False,
    is_nonlocal_settlement = True,
    days_until_writeoff = 45,
    has_unwritten_off_loan = True,
    has_special_reason_for_new_loan = True
  \<rparr>"
definition case20_can_3 :: rule20_case where
  "case20_can_3 \<equiv> \<lparr>
    is_special_business_for_temp_loan = True,
    cannot_get_invoice_in_advance = True,
    borrower_is_fudan_staff = False,
    borrower_is_leased_personnel_R_or_L = False,
    borrower_is_postdoc = True,
    borrower_signed_reservation_form = True,
    borrower_is_retired = False,
    borrower_is_student = False,
    borrower_is_external_personnel = False,
    is_same_city_settlement = False,
    is_nonlocal_settlement = True,
    days_until_writeoff = 60,
    has_unwritten_off_loan = False,
    has_special_reason_for_new_loan = False
  \<rparr>"
(* 3 cases: Cannot_Borrow *)
definition case20_cannot_1 :: rule20_case where
  "case20_cannot_1 \<equiv> \<lparr>
    is_special_business_for_temp_loan = False,
    cannot_get_invoice_in_advance = True,
    borrower_is_fudan_staff = True,
    borrower_is_leased_personnel_R_or_L = False,
    borrower_is_postdoc = False,
    borrower_signed_reservation_form = True,
    borrower_is_retired = False,
    borrower_is_student = False,
    borrower_is_external_personnel = False,
    is_same_city_settlement = True,
    is_nonlocal_settlement = False,
    days_until_writeoff = 10,
    has_unwritten_off_loan = False,
    has_special_reason_for_new_loan = False
  \<rparr>"
definition case20_cannot_2 :: rule20_case where
  "case20_cannot_2 \<equiv> \<lparr>
    is_special_business_for_temp_loan = True,
    cannot_get_invoice_in_advance = True,
    borrower_is_fudan_staff = False,
    borrower_is_leased_personnel_R_or_L = False,
    borrower_is_postdoc = False,
    borrower_signed_reservation_form = True,
    borrower_is_retired = False,
    borrower_is_student = True,
    borrower_is_external_personnel = False,
    is_same_city_settlement = True,
    is_nonlocal_settlement = False,
    days_until_writeoff = 20,
    has_unwritten_off_loan = False,
    has_special_reason_for_new_loan = False
  \<rparr>"
definition case20_cannot_3 :: rule20_case where
  "case20_cannot_3 \<equiv> \<lparr>
    is_special_business_for_temp_loan = True,
    cannot_get_invoice_in_advance = True,
    borrower_is_fudan_staff = True,
    borrower_is_leased_personnel_R_or_L = False,
    borrower_is_postdoc = False,
    borrower_signed_reservation_form = True,
    borrower_is_retired = False,
    borrower_is_student = False,
    borrower_is_external_personnel = False,
    is_same_city_settlement = True,
    is_nonlocal_settlement = False,
    days_until_writeoff = 40,
    has_unwritten_off_loan = True,
    has_special_reason_for_new_loan = False
  \<rparr>"
definition case20_can_extra_1 :: rule20_case where
  "case20_can_extra_1 \<equiv> case20_can_1\<lparr>days_until_writeoff := 30\<rparr>"
definition case20_can_extra_2 :: rule20_case where
  "case20_can_extra_2 \<equiv> case20_can_1\<lparr>is_same_city_settlement := False, is_nonlocal_settlement := True, days_until_writeoff := 60\<rparr>"
definition case20_can_extra_3 :: rule20_case where
  "case20_can_extra_3 \<equiv> case20_can_2\<lparr>is_same_city_settlement := True, is_nonlocal_settlement := False, days_until_writeoff := 1, has_unwritten_off_loan := True, has_special_reason_for_new_loan := True\<rparr>"
definition case20_can_extra_4 :: rule20_case where
  "case20_can_extra_4 \<equiv> case20_can_3\<lparr>days_until_writeoff := 59, has_unwritten_off_loan := True, has_special_reason_for_new_loan := True\<rparr>"
definition case20_can_extra_5 :: rule20_case where
  "case20_can_extra_5 \<equiv> case20_can_1\<lparr>borrower_is_leased_personnel_R_or_L := True, is_nonlocal_settlement := True, is_same_city_settlement := False, days_until_writeoff := 15\<rparr>"
definition case20_can_extra_6 :: rule20_case where
  "case20_can_extra_6 \<equiv> case20_can_1\<lparr>borrower_is_leased_personnel_R_or_L := True, borrower_is_postdoc := True, days_until_writeoff := 5\<rparr>"
definition case20_can_extra_7 :: rule20_case where
  "case20_can_extra_7 \<equiv> case20_can_1\<lparr>is_nonlocal_settlement := True, days_until_writeoff := 30\<rparr>"
definition case20_can_extra_8 :: rule20_case where
  "case20_can_extra_8 \<equiv> case20_can_2\<lparr>is_same_city_settlement := True, is_nonlocal_settlement := True, days_until_writeoff := 20, has_unwritten_off_loan := False\<rparr>"
definition case20_can_extra_9 :: rule20_case where
  "case20_can_extra_9 \<equiv> case20_can_3\<lparr>is_same_city_settlement := True, is_nonlocal_settlement := False, days_until_writeoff := 0\<rparr>"
definition case20_can_extra_10 :: rule20_case where
  "case20_can_extra_10 \<equiv> case20_can_2\<lparr>days_until_writeoff := 60, has_unwritten_off_loan := False\<rparr>"
definition case20_can_extra_11 :: rule20_case where
  "case20_can_extra_11 \<equiv> case20_can_1\<lparr>is_same_city_settlement := False, is_nonlocal_settlement := True, days_until_writeoff := 45, has_unwritten_off_loan := True, has_special_reason_for_new_loan := True\<rparr>"
definition case20_can_extra_12 :: rule20_case where
  "case20_can_extra_12 \<equiv> case20_can_3\<lparr>is_same_city_settlement := True, is_nonlocal_settlement := True, days_until_writeoff := 10, has_unwritten_off_loan := True, has_special_reason_for_new_loan := True\<rparr>"
definition case20_can_extra_13 :: rule20_case where
  "case20_can_extra_13 \<equiv> case20_can_1\<lparr>days_until_writeoff := 29, borrower_is_postdoc := True\<rparr>"
definition case20_can_extra_14 :: rule20_case where
  "case20_can_extra_14 \<equiv> case20_can_2\<lparr>days_until_writeoff := 1, borrower_is_fudan_staff := True\<rparr>"
definition case20_can_extra_15 :: rule20_case where
  "case20_can_extra_15 \<equiv> case20_can_3\<lparr>days_until_writeoff := 30, borrower_is_leased_personnel_R_or_L := True\<rparr>"
definition case20_can_extra_16 :: rule20_case where
  "case20_can_extra_16 \<equiv> case20_can_1\<lparr>is_nonlocal_settlement := True, days_until_writeoff := 1, has_unwritten_off_loan := True, has_special_reason_for_new_loan := True\<rparr>"
definition case20_can_extra_17 :: rule20_case where
  "case20_can_extra_17 \<equiv> case20_can_2\<lparr>is_same_city_settlement := True, is_nonlocal_settlement := False, days_until_writeoff := 30, has_unwritten_off_loan := False, has_special_reason_for_new_loan := False\<rparr>"
definition case20_cannot_extra_1 :: rule20_case where
  "case20_cannot_extra_1 \<equiv> case20_can_1\<lparr>cannot_get_invoice_in_advance := False\<rparr>"
definition case20_cannot_extra_2 :: rule20_case where
  "case20_cannot_extra_2 \<equiv> case20_can_1\<lparr>is_special_business_for_temp_loan := False\<rparr>"
definition case20_cannot_extra_3 :: rule20_case where
  "case20_cannot_extra_3 \<equiv> case20_can_1\<lparr>borrower_is_fudan_staff := False, borrower_is_leased_personnel_R_or_L := False, borrower_is_postdoc := False\<rparr>"
definition case20_cannot_extra_4 :: rule20_case where
  "case20_cannot_extra_4 \<equiv> case20_can_1\<lparr>borrower_signed_reservation_form := False\<rparr>"
definition case20_cannot_extra_5 :: rule20_case where
  "case20_cannot_extra_5 \<equiv> case20_can_1\<lparr>borrower_is_retired := True\<rparr>"
definition case20_cannot_extra_6 :: rule20_case where
  "case20_cannot_extra_6 \<equiv> case20_can_1\<lparr>borrower_is_student := True\<rparr>"
definition case20_cannot_extra_7 :: rule20_case where
  "case20_cannot_extra_7 \<equiv> case20_can_1\<lparr>borrower_is_external_personnel := True\<rparr>"
definition case20_cannot_extra_8 :: rule20_case where
  "case20_cannot_extra_8 \<equiv> case20_can_1\<lparr>is_same_city_settlement := False, is_nonlocal_settlement := False\<rparr>"
definition case20_cannot_extra_9 :: rule20_case where
  "case20_cannot_extra_9 \<equiv> case20_can_1\<lparr>days_until_writeoff := 31\<rparr>"
definition case20_cannot_extra_10 :: rule20_case where
  "case20_cannot_extra_10 \<equiv> case20_can_2\<lparr>days_until_writeoff := 61\<rparr>"
definition case20_cannot_extra_11 :: rule20_case where
  "case20_cannot_extra_11 \<equiv> case20_can_1\<lparr>is_nonlocal_settlement := True, days_until_writeoff := 40\<rparr>"
definition case20_cannot_extra_12 :: rule20_case where
  "case20_cannot_extra_12 \<equiv> case20_can_2\<lparr>has_special_reason_for_new_loan := False\<rparr>"
definition case20_cannot_extra_13 :: rule20_case where
  "case20_cannot_extra_13 \<equiv> case20_can_1\<lparr>borrower_is_fudan_staff := False, borrower_is_student := True\<rparr>"
definition case20_cannot_extra_14 :: rule20_case where
  "case20_cannot_extra_14 \<equiv> case20_can_1\<lparr>days_until_writeoff := 100\<rparr>"
definition case20_cannot_extra_15 :: rule20_case where
  "case20_cannot_extra_15 \<equiv> case20_can_2\<lparr>days_until_writeoff := 200\<rparr>"
definition case20_cannot_extra_16 :: rule20_case where
  "case20_cannot_extra_16 \<equiv> case20_can_1\<lparr>borrower_is_retired := True, has_unwritten_off_loan := True, has_special_reason_for_new_loan := True\<rparr>"
definition case20_cannot_extra_17 :: rule20_case where
  "case20_cannot_extra_17 \<equiv> case20_can_2\<lparr>borrower_is_external_personnel := True, borrower_signed_reservation_form := False\<rparr>"
(* ===== Global priority gate: Rule 3 (materials) + Rule 4 (invoice) ===== *)
definition mk_claim_case_rule6 :: "rule6_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule6 c \<equiv> \<lparr>cc_claim_type = CTM_Office_or_Printing_Fee, cc_payload = PM6 c\<rparr>"
definition mk_claim_case_rule7 :: "rule7_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule7 c \<equiv> \<lparr>cc_claim_type = CTM_Travel_Fee, cc_payload = PM7 c\<rparr>"
definition mk_claim_case_rule8 :: "rule8_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule8 c \<equiv> \<lparr>cc_claim_type = CTM_Overseas_Fee, cc_payload = PM8 c\<rparr>"
definition mk_claim_case_rule9 :: "rule9_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule9 c \<equiv> \<lparr>cc_claim_type = CTM_Conference_Fee, cc_payload = PM9 c\<rparr>"
definition mk_claim_case_rule10 :: "rule10_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule10 c \<equiv> \<lparr>cc_claim_type = CTM_Training_Fee, cc_payload = PM10 c\<rparr>"
definition mk_claim_case_rule11 :: "rule11_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule11 c \<equiv> \<lparr>cc_claim_type = CTM_Family_Visit_Travel_Fee, cc_payload = PM11 c\<rparr>"
definition mk_claim_case_rule13 :: "rule13_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule13 c \<equiv> \<lparr>cc_claim_type = CTM_Labor_Fee, cc_payload = PM13 c\<rparr>"
definition mk_claim_case_rule14 :: "rule14_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule14 c \<equiv> \<lparr>cc_claim_type = CTM_Engineering_Repair_Fee, cc_payload = PM14 c\<rparr>"
definition mk_claim_case_rule15 :: "rule15_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule15 c \<equiv>
    (case rule15_case.claim_type c of
       Claim_Warranty_Refund \<Rightarrow> \<lparr>cc_claim_type = CTM_Warranty_Fee, cc_payload = PM15_Warranty c\<rparr>
     | Claim_Cost_Review_Fee \<Rightarrow> \<lparr>cc_claim_type = CTM_Cost_Review_Fee, cc_payload = PM15_CostReview c\<rparr>)"
definition mk_claim_case_rule16 :: "rule16_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule16 c \<equiv>
    (case rule16_case.claim_type c of
       Claim_Fixed_Asset \<Rightarrow> \<lparr>cc_claim_type = CTM_Fixed_Asset_Reimbursement, cc_payload = PM16_Fixed c\<rparr>
     | Claim_Intangible_Asset \<Rightarrow> \<lparr>cc_claim_type = CTM_Intangible_Asset_Reimbursement, cc_payload = PM16_Intangible c\<rparr>
     | Claim_Purchased_Material \<Rightarrow> \<lparr>cc_claim_type = CTM_Purchased_Material_Reimbursement, cc_payload = PM16_Material c\<rparr>)"
definition mk_claim_case_rule17 :: "rule17_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule17 c \<equiv> \<lparr>cc_claim_type = CTM_Equipment_Maintenance_Fee, cc_payload = PM17 c\<rparr>"
definition mk_claim_case_rule18 :: "rule18_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule18 c \<equiv> \<lparr>cc_claim_type = CTM_Official_Hospitality_Fee, cc_payload = PM18 c\<rparr>"
definition mk_claim_case_rule19 :: "rule19_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule19 c \<equiv> \<lparr>cc_claim_type = CTM_Visitor_Fee, cc_payload = PM19 c\<rparr>"
definition mk_claim_case_rule20 :: "rule20_case \<Rightarrow> claim_case_main" where
  "mk_claim_case_rule20 c \<equiv> \<lparr>cc_claim_type = CTM_Temporary_Loan, cc_payload = PM20 c\<rparr>"
definition claim_type_ok_rule6 :: "rule6_case \<Rightarrow> bool" where "claim_type_ok_rule6 c \<equiv> claim_case_main_wf (mk_claim_case_rule6 c)"
definition claim_type_ok_rule7 :: "rule7_case \<Rightarrow> bool" where "claim_type_ok_rule7 c \<equiv> claim_case_main_wf (mk_claim_case_rule7 c)"
definition claim_type_ok_rule8 :: "rule8_case \<Rightarrow> bool" where "claim_type_ok_rule8 c \<equiv> claim_case_main_wf (mk_claim_case_rule8 c)"
definition claim_type_ok_rule9 :: "rule9_case \<Rightarrow> bool" where "claim_type_ok_rule9 c \<equiv> claim_case_main_wf (mk_claim_case_rule9 c)"
definition claim_type_ok_rule10 :: "rule10_case \<Rightarrow> bool" where "claim_type_ok_rule10 c \<equiv> claim_case_main_wf (mk_claim_case_rule10 c)"
definition claim_type_ok_rule11 :: "rule11_case \<Rightarrow> bool" where "claim_type_ok_rule11 c \<equiv> claim_case_main_wf (mk_claim_case_rule11 c)"
definition claim_type_ok_rule13 :: "rule13_case \<Rightarrow> bool" where "claim_type_ok_rule13 c \<equiv> claim_case_main_wf (mk_claim_case_rule13 c)"
definition claim_type_ok_rule14 :: "rule14_case \<Rightarrow> bool" where "claim_type_ok_rule14 c \<equiv> claim_case_main_wf (mk_claim_case_rule14 c)"
definition claim_type_ok_rule15 :: "rule15_case \<Rightarrow> bool" where "claim_type_ok_rule15 c \<equiv> claim_case_main_wf (mk_claim_case_rule15 c)"
definition claim_type_ok_rule16 :: "rule16_case \<Rightarrow> bool" where "claim_type_ok_rule16 c \<equiv> claim_case_main_wf (mk_claim_case_rule16 c)"
definition claim_type_ok_rule17 :: "rule17_case \<Rightarrow> bool" where "claim_type_ok_rule17 c \<equiv> claim_case_main_wf (mk_claim_case_rule17 c)"
definition claim_type_ok_rule18 :: "rule18_case \<Rightarrow> bool" where "claim_type_ok_rule18 c \<equiv> claim_case_main_wf (mk_claim_case_rule18 c)"
definition claim_type_ok_rule19 :: "rule19_case \<Rightarrow> bool" where "claim_type_ok_rule19 c \<equiv> claim_case_main_wf (mk_claim_case_rule19 c)"
definition claim_type_ok_rule20 :: "rule20_case \<Rightarrow> bool" where "claim_type_ok_rule20 c \<equiv> claim_case_main_wf (mk_claim_case_rule20 c)"
definition eval_by_claim_type1_rule6 :: "rule6_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule6 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule6 c)"
definition eval_by_claim_type1_rule7 :: "rule7_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule7 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule7 c)"
definition eval_by_claim_type1_rule8 :: "rule8_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule8 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule8 c)"
definition eval_by_claim_type1_rule9 :: "rule9_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule9 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule9 c)"
definition eval_by_claim_type1_rule10 :: "rule10_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule10 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule10 c)"
definition eval_by_claim_type1_rule11 :: "rule11_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule11 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule11 c)"
definition eval_by_claim_type1_rule13 :: "rule13_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule13 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule13 c)"
definition eval_by_claim_type1_rule14 :: "rule14_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule14 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule14 c)"
definition eval_by_claim_type1_rule15 :: "rule15_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule15 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule15 c)"
definition eval_by_claim_type1_rule16 :: "rule16_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule16 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule16 c)"
definition eval_by_claim_type1_rule17 :: "rule17_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule17 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule17 c)"
definition eval_by_claim_type1_rule18 :: "rule18_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule18 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule18 c)"
definition eval_by_claim_type1_rule19 :: "rule19_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule19 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule19 c)"
definition eval_by_claim_type1_rule20 :: "rule20_case \<Rightarrow> global_claim_result" where
  "eval_by_claim_type1_rule20 c \<equiv> evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule20 c)"
value "evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule7 case7_full_1)"
value "evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case (mk_claim_case_rule20 case20_can_1)"
value "rule_13_evaluate_gated_by_claim_type2 default_rule3_gate_case default_rule4_gate_case CT2_R13_Lecture case_full_2"
value "rule_15_evaluate_gated_by_claim_type2 default_rule3_gate_case default_rule4_gate_case Claim_Cost_Review_Fee case15_cost_full_1"
value "rule_16_evaluate_gated_by_claim_type2 default_rule3_gate_case default_rule4_gate_case Claim_Intangible_Asset case16_intangible_full_1"
value "map (\<lambda>r. rule3_to_answer (rule_3_evaluate r))
  [ rule3_case_full_1, rule3_case_full_2, rule3_case_full_3,
    rule3_case_full_extra_1, rule3_case_full_extra_2, rule3_case_full_extra_3, rule3_case_full_extra_4,
    rule3_case_full_extra_5, rule3_case_full_extra_6, rule3_case_full_extra_7, rule3_case_full_extra_8,
    rule3_case_full_extra_9, rule3_case_full_extra_10, rule3_case_full_extra_11, rule3_case_full_extra_12,
    rule3_case_full_extra_13, rule3_case_full_extra_14, rule3_case_full_extra_15, rule3_case_full_extra_16,
    rule3_case_full_extra_17,
    rule3_case_incomplete_1, rule3_case_incomplete_2, rule3_case_incomplete_3,
    rule3_case_incomplete_extra_1, rule3_case_incomplete_extra_2, rule3_case_incomplete_extra_3, rule3_case_incomplete_extra_4,
    rule3_case_incomplete_extra_5, rule3_case_incomplete_extra_6, rule3_case_incomplete_extra_7, rule3_case_incomplete_extra_8,
    rule3_case_incomplete_extra_9, rule3_case_incomplete_extra_10, rule3_case_incomplete_extra_11, rule3_case_incomplete_extra_12,
    rule3_case_incomplete_extra_13, rule3_case_incomplete_extra_14, rule3_case_incomplete_extra_15, rule3_case_incomplete_extra_16,
    rule3_case_incomplete_extra_17 ]"
value "map rule4_to_answer
  [ rule4_case_correct_1,
    rule4_case_error_1, rule4_case_error_2, rule4_case_error_3, rule4_case_error_4,
    rule4_case_error_5, rule4_case_error_6, rule4_case_error_7, rule4_case_error_8,
    rule4_case_error_9, rule4_case_error_10, rule4_case_error_11, rule4_case_error_12,
    rule4_case_error_13, rule4_case_error_14, rule4_case_error_15, rule4_case_error_16,
    rule4_case_error_17, rule4_case_error_18, rule4_case_error_19 ]"
(*rule 4 & rule 6*)
value "map eval_by_claim_type1_rule6 (rule6_approval_cases @ rule6_rejection_cases)"
value "map eval_pair_gated combined_mixed_all_cases"
(*rule 7*)
value "eval_by_claim_type1_rule7 case7_season_qd_full"      (* Full_Approval *)
value "eval_by_claim_type1_rule7 case7_season_ly_full"      (* Full_Approval *)
value "eval_by_claim_type1_rule7 case7_season_xz_partial"   (* Partial_Approval *)
value "eval_by_claim_type1_rule7 case7_full_1"      (* Full_Approval *)
value "eval_by_claim_type1_rule7 case7_full_2"      (* Full_Approval *)
value "eval_by_claim_type1_rule7 case7_full_3"      (* Full_Approval *)
value "eval_by_claim_type1_rule7 case7_reject_1"    (* Rejection *)
value "eval_by_claim_type1_rule7 case7_reject_2"    (* Rejection *)
value "eval_by_claim_type1_rule7 case7_reject_3"    (* Rejection *)
value "eval_by_claim_type1_rule7 case7_partial_1"   (* Partial_Approval *)
value "eval_by_claim_type1_rule7 case7_partial_2"   (* Partial_Approval *)
value "eval_by_claim_type1_rule7 case7_partial_3"   (* Partial_Approval *)
value "map eval_by_claim_type1_rule7 rule7_all_cases"
value "map eval_by_claim_type1_rule7 (rule7_more_full_cases @ rule7_more_reject_cases)"
value "map rule7v2_amount_decision_gated rule7v2_amount_cases"
value "map eval_by_claim_type1_rule8 rule8_all_cases"
value "map eval_by_claim_type1_rule8 (rule8_more_full_cases @ rule8_more_reject_cases)"
value "map eval_by_claim_type1_rule9
 [case9_full_1, case9_full_2, case9_full_3,
  case9_full_extra_1, case9_full_extra_2, case9_full_extra_3, case9_full_extra_4, case9_full_extra_5,
  case9_full_extra_6, case9_full_extra_7, case9_full_extra_8, case9_full_extra_9, case9_full_extra_10,
  case9_full_extra_11, case9_full_extra_12, case9_full_extra_13, case9_full_extra_14, case9_full_extra_15,
  case9_full_extra_16, case9_full_extra_17,
  case9_partial_1, case9_partial_2, case9_partial_3, case9_partial_4, case9_partial_5, case9_partial_6,
  case9_partial_extra_1, case9_partial_extra_2, case9_partial_extra_3, case9_partial_extra_4, case9_partial_extra_5,
  case9_partial_extra_6, case9_partial_extra_7, case9_partial_extra_8, case9_partial_extra_9, case9_partial_extra_10,
  case9_partial_extra_11, case9_partial_extra_12, case9_partial_extra_13, case9_partial_extra_14,
  case9_reject_1, case9_reject_2, case9_reject_3,
  case9_reject_extra_1, case9_reject_extra_2, case9_reject_extra_3, case9_reject_extra_4, case9_reject_extra_5,
  case9_reject_extra_6, case9_reject_extra_7, case9_reject_extra_8, case9_reject_extra_9, case9_reject_extra_10,
  case9_reject_extra_11, case9_reject_extra_12, case9_reject_extra_13, case9_reject_extra_14, case9_reject_extra_15,
  case9_reject_extra_16, case9_reject_extra_17]"

value "map eval_by_claim_type1_rule10
 [full_approval_case1, full_approval_case2, full_approval_case3,
  partial_case1, partial_case2, partial_case3,
  rejection_case1, rejection_case2, rejection_case3,
  rule10_full_extra_1, rule10_full_extra_2,
  rule10_partial_extra_1, rule10_partial_extra_2, rule10_partial_extra_3,
  rule10_partial_extra_4, rule10_partial_extra_5, rule10_partial_extra_6, rule10_partial_extra_7,
  rule10_reject_extra_1, rule10_reject_extra_2]"
value "map eval_by_claim_type1_rule10 (rule10_more_full_cases @ rule10_more_reject_cases)"
value "map rule10v2_amount_decision_gated rule10v2_full_cases_20"
value "map rule10v2_amount_decision_gated rule10v2_partial_cases_20"
value "map eval_by_claim_type1_rule11
 [full_approval_case1_11, full_approval_case2_11, full_approval_case3_11,
  partial_case1_11, partial_case2_11, partial_case3_11,
  rejection_case1_11, rejection_case2_11, rejection_case3_11,
  rule11_full_extra_1, rule11_full_extra_2,
  rule11_partial_extra_1, rule11_partial_extra_2, rule11_partial_extra_3,
  rule11_partial_extra_4, rule11_partial_extra_5, rule11_partial_extra_6, rule11_partial_extra_7,
  rule11_reject_extra_1, rule11_reject_extra_2]"
value "map eval_by_claim_type1_rule11 (rule11_more_full_cases @ rule11_more_reject_cases)"
value "map eval_by_claim_type1_rule13
 [case_full_1, case_full_2, case_full_3,
  case_partial_1, case_partial_2, case_partial_3,
  case_unknown_1, case_unknown_2, case_unknown_3,
  rule13_full_extra_1, rule13_full_extra_2,
  rule13_partial_extra_1, rule13_partial_extra_2, rule13_partial_extra_3,
  rule13_partial_extra_4, rule13_partial_extra_5, rule13_partial_extra_6, rule13_partial_extra_7,
  rule13_unknown_extra_1, rule13_unknown_extra_2]"
value "map eval_by_claim_type1_rule13 (rule13_more_full_cases @ rule13_more_reject_cases)"
value "map rule13v2_amount_decision_gated rule13v2_full_cases_20"
value "map rule13v2_amount_decision_gated rule13v2_partial_cases_20"  
value "map eval_by_claim_type1_rule14
 [case14_full_1, case14_full_2, case14_full_3,
  case14_partial_1, case14_partial_2, case14_partial_3,
  case14_reject_1, case14_reject_2, case14_reject_3,
  rule14_full_extra_1, rule14_full_extra_2,
  rule14_partial_extra_1, rule14_partial_extra_2, rule14_partial_extra_3,
  rule14_partial_extra_4, rule14_partial_extra_5, rule14_partial_extra_6, rule14_partial_extra_7,
  rule14_reject_extra_1, rule14_reject_extra_2]"
value "map eval_by_claim_type1_rule14 (rule14_more_full_cases @ rule14_more_reject_cases)"
value "map eval_by_claim_type1_rule15
 [case15_warranty_full_1, case15_warranty_full_2, case15_warranty_full_3,
  case15_cost_full_1, case15_cost_full_2, case15_cost_full_3,
  case15_warranty_full_extra_1, case15_warranty_full_extra_2, case15_cost_full_extra_1, case15_cost_full_extra_2,
  case15_warranty_reject_1, case15_warranty_reject_2, case15_warranty_reject_3,
  case15_cost_reject_1, case15_cost_reject_2, case15_cost_reject_3,
  case15_warranty_reject_extra_1, case15_warranty_reject_extra_2, case15_cost_reject_extra_1, case15_cost_reject_extra_2]"
value "map eval_by_claim_type1_rule16
 [case16_fixed_full_1, case16_fixed_full_2, case16_intangible_full_1, case16_intangible_full_2, case16_material_full_1, case16_material_full_2,
  case16_fixed_full_extra_1, case16_fixed_full_extra_2, case16_intangible_full_extra_1, case16_material_full_extra_1,
  case16_fixed_reject_1, case16_fixed_reject_2, case16_intangible_reject_1, case16_intangible_reject_2, case16_material_reject_1, case16_material_reject_2,
  case16_fixed_reject_extra_1, case16_fixed_reject_extra_2, case16_intangible_reject_extra_1, case16_material_reject_extra_1]"
value "map (\<lambda>p. combined_eval_4_17_gated (fst p) (snd p))
 [ combined_case_full_1,
   combined_case_reject_1, combined_case_reject_2, combined_case_reject_3, combined_case_reject_4,
   combined_case_reject_5, combined_case_reject_6, combined_case_reject_7, combined_case_reject_8,
   combined_case_reject_9, combined_case_reject_10, combined_case_reject_11, combined_case_reject_12,
   combined_case_reject_13, combined_case_reject_14, combined_case_reject_15, combined_case_reject_16,
   combined_case_reject_17, combined_case_reject_18, combined_case_reject_19, combined_case_reject_20 ]"
value "map eval_by_claim_type1_rule18
  [ case18_full_1, case18_full_2, case18_full_3, case18_full_4, case18_full_5,
    case18_reject_1, case18_reject_2, case18_reject_3, case18_reject_4, case18_reject_5,
    case18_partial_1, case18_partial_2, case18_partial_3, case18_partial_4, case18_partial_5,
    case18_partial_6, case18_partial_7, case18_partial_8, case18_partial_9, case18_partial_10 ]"
value "map eval_by_claim_type1_rule18 (rule18_more_full_cases @ rule18_more_reject_cases)"
value "map eval_by_claim_type1_rule19
 [case19_full_1, case19_full_2, case19_full_3, case19_full_4, case19_full_5,
  case19_full_6, case19_full_7, case19_full_8, case19_full_9, case19_full_10,
  case19_reject_1, case19_rejectpartial_2, case19_reject_3, case19_reject_4, case19_rejectpartial_5,
  case19_rejectpartial_6, case19_rejectpartial_7, case19_reject_8, case19_reject_9, case19_reject_10,
  case19_partial_1, case19_partial_2, case19_partial_3, case19_partial_4, case19_partial_5,
  case19_partial_6, case19_partial_7, case19_partial_8, case19_partial_9, case19_partial_10,
  case19_partial_11, case19_partial_12, case19_partial_13, case19_partial_14, case19_partial_15, case19_partial_16]"
value "map eval_by_claim_type1_rule20
 [case20_can_1, case20_can_2, case20_can_3,
  case20_can_extra_1, case20_can_extra_2, case20_can_extra_3, case20_can_extra_4, case20_can_extra_5, case20_can_extra_6,
  case20_can_extra_7, case20_can_extra_8, case20_can_extra_9, case20_can_extra_10, case20_can_extra_11, case20_can_extra_12,
  case20_can_extra_13, case20_can_extra_14, case20_can_extra_15, case20_can_extra_16, case20_can_extra_17,
  case20_cannot_1, case20_cannot_2, case20_cannot_3,
  case20_cannot_extra_1, case20_cannot_extra_2, case20_cannot_extra_3, case20_cannot_extra_4, case20_cannot_extra_5, case20_cannot_extra_6,
  case20_cannot_extra_7, case20_cannot_extra_8, case20_cannot_extra_9, case20_cannot_extra_10, case20_cannot_extra_11, case20_cannot_extra_12,
  case20_cannot_extra_13, case20_cannot_extra_14, case20_cannot_extra_15, case20_cannot_extra_16, case20_cannot_extra_17]"

(* ===== Mixed-span cases (span=2/3/4/5), return n raw results (no merge judgment) ===== *)
definition rr_of_claim_case_main :: "claim_case_main \<Rightarrow> reimbursement_result" where
  "rr_of_claim_case_main cc \<equiv>
    (case evaluate_claim_case_main default_rule3_gate_case default_rule4_gate_case cc of
       Global_Reimbursement r \<Rightarrow> r
     | Global_Loan _ \<Rightarrow> Rejection
     | Global_ClaimType_Mismatch \<Rightarrow> Rejection)"

definition pick :: "'a list \<Rightarrow> nat \<Rightarrow> 'a" where
  "pick xs i \<equiv> xs ! (i mod length xs)"

definition pick3 :: "'a list \<Rightarrow> 'a list \<Rightarrow> 'a list \<Rightarrow> nat \<Rightarrow> 'a" where
  "pick3 fs ps rs i \<equiv>
    (if i mod 3 = 0 then fs ! (((i div 3)) mod length fs)
     else if i mod 3 = 1 then ps ! (((i div 3)) mod length ps)
     else rs ! (((i div 3)) mod length rs))"

definition pools_full :: "claim_case_main list list" where
  "pools_full \<equiv> [
     map mk_claim_case_rule6 [rule6_case_a_1, rule6_case_a_2, rule6_case_a_3],
     map mk_claim_case_rule7 [case7_full_1, case7_full_2, case7_full_3],
     map mk_claim_case_rule8 [rule8_more_full_1, rule8_more_full_2, rule8_more_full_3],
     map mk_claim_case_rule9 [case9_full_1, case9_full_2, case9_full_3],
     map mk_claim_case_rule10 [full_approval_case1, full_approval_case2, full_approval_case3],
     map mk_claim_case_rule11 [full_approval_case1_11, full_approval_case2_11, full_approval_case3_11],
     map mk_claim_case_rule13 [case_full_1, case_full_2, case_full_3],
     map mk_claim_case_rule14 [case14_full_1, case14_full_2, case14_full_3],
     map mk_claim_case_rule15 [case15_warranty_full_1, case15_warranty_full_2, case15_cost_full_1],
     map mk_claim_case_rule16 [case16_fixed_full_1, case16_intangible_full_1, case16_material_full_1],
     map mk_claim_case_rule17 [case_maint_approval],
     map mk_claim_case_rule18 [case18_full_1, case18_full_2, case18_full_3],
     map mk_claim_case_rule19 [case19_full_1, case19_full_2, case19_full_3]
   ]"

definition pools_part :: "claim_case_main list list" where
  "pools_part \<equiv> [
     map mk_claim_case_rule6 [rule6_case_a_4, rule6_case_a_5, rule6_case_a_6],
     map mk_claim_case_rule7 [case7_partial_1, case7_partial_2, case7_partial_3],
     map mk_claim_case_rule8 [rule8_base_ok\<lparr>travel_by_economy_class_air := False\<rparr>, rule8_base_ok\<lparr>travel_by_hard_seat_rail := False, travel_by_second_class_hsr := False\<rparr>, rule8_base_ok\<lparr>travel_by_third_class_ship := False\<rparr>],
     map mk_claim_case_rule9 [case9_partial_1, case9_partial_2, case9_partial_3],
     map mk_claim_case_rule10 [partial_case1, partial_case2, partial_case3],
     map mk_claim_case_rule11 [partial_case1_11, partial_case2_11, partial_case3_11],
     map mk_claim_case_rule13 [case_partial_1, case_partial_2, case_partial_3],
     map mk_claim_case_rule14 [case14_partial_1, case14_partial_2, case14_partial_3],
     map mk_claim_case_rule15 [case15_warranty_full_3, case15_cost_full_2, case15_cost_full_3],
     map mk_claim_case_rule16 [case16_fixed_full_2, case16_intangible_full_2, case16_material_full_2],
     map mk_claim_case_rule17 [case_maint_approval],
     map mk_claim_case_rule18 [case18_partial_1, case18_partial_2, case18_partial_3],
     map mk_claim_case_rule19 [case19_partial_1, case19_partial_2, case19_partial_3]
   ]"

definition pools_rej :: "claim_case_main list list" where
  "pools_rej \<equiv> [
     map mk_claim_case_rule6 [rule6_case_r_1, rule6_case_r_2, rule6_case_r_3],
     map mk_claim_case_rule7 [case7_reject_1, case7_reject_2, case7_reject_3],
     map mk_claim_case_rule8 [rule8_more_reject_1, rule8_more_reject_2, rule8_more_reject_3],
     map mk_claim_case_rule9 [case9_reject_1, case9_reject_2, case9_reject_3],
     map mk_claim_case_rule10 [rejection_case1, rejection_case2, rejection_case3],
     map mk_claim_case_rule11 [rejection_case1_11, rejection_case2_11, rejection_case3_11],
     map mk_claim_case_rule13 [case_unknown_1, case_unknown_2, case_unknown_3],
     map mk_claim_case_rule14 [case14_reject_1, case14_reject_2, case14_reject_3],
     map mk_claim_case_rule15 [case15_warranty_reject_1, case15_warranty_reject_2, case15_cost_reject_1],
     map mk_claim_case_rule16 [case16_fixed_reject_1, case16_intangible_reject_1, case16_material_reject_1],
     map mk_claim_case_rule17 [case_maint_r1, case_maint_r2, case_maint_r3],
     map mk_claim_case_rule18 [case18_reject_1, case18_reject_2, case18_reject_3],
     map mk_claim_case_rule19 [case19_reject_1, case19_rejectpartial_2, case19_reject_3]
   ]"

definition pick_rule_balanced :: "nat \<Rightarrow> nat \<Rightarrow> claim_case_main" where
  "pick_rule_balanced rid i \<equiv>
    pick3 (pools_full ! (rid mod length pools_full))
          (pools_part ! (rid mod length pools_part))
          (pools_rej ! (rid mod length pools_rej))
          i"


type_synonym span2_case = "claim_case_main * claim_case_main"
type_synonym span3_case = "claim_case_main * claim_case_main * claim_case_main"
type_synonym span4_case = "claim_case_main * claim_case_main * claim_case_main * claim_case_main"
type_synonym span5_case = "claim_case_main * claim_case_main * claim_case_main * claim_case_main * claim_case_main"


datatype mix_rule = MR6 | MR7 | MR8 | MR9 | MR10 | MR11 | MR13 | MR14 | MR15 | MR16 | MR17 | MR18 | MR19

definition mix_rule_id :: "mix_rule \<Rightarrow> nat" where
  "mix_rule_id r \<equiv> (case r of
     MR6 \<Rightarrow> 0 | MR7 \<Rightarrow> 1 | MR8 \<Rightarrow> 2 | MR9 \<Rightarrow> 3 | MR10 \<Rightarrow> 4 | MR11 \<Rightarrow> 5 |
     MR13 \<Rightarrow> 6 | MR14 \<Rightarrow> 7 | MR15 \<Rightarrow> 8 | MR16 \<Rightarrow> 9 | MR17 \<Rightarrow> 10 | MR18 \<Rightarrow> 11 | MR19 \<Rightarrow> 12)"

definition fill_mix_rules :: "mix_rule list" where
  "fill_mix_rules \<equiv> [MR7, MR9, MR10, MR14, MR16, MR18, MR19, MR6, MR8, MR11, MR13, MR15, MR17]"

definition complete_mix_rules :: "nat \<Rightarrow> mix_rule list \<Rightarrow> mix_rule list" where
  "complete_mix_rules n rs \<equiv>
    (let base = remdups rs;
         extras = filter (\<lambda>r. r \<notin> set base) fill_mix_rules
     in take n (base @ extras))"

definition pick_claim_of_mix :: "mix_rule \<Rightarrow> nat \<Rightarrow> claim_case_main" where
  "pick_claim_of_mix r i \<equiv> pick_rule_balanced (mix_rule_id r) i"

definition span2_story_rules_50 :: "mix_rule list list" where
  "span2_story_rules_50 \<equiv> [
    [MR7, MR6],
    [MR9, MR6],
    [MR10, MR7],
    [MR11, MR7],
    [MR8, MR9],
    [MR13, MR9],
    [MR14, MR15],
    [MR16, MR7],
    [MR18, MR9],
    [MR17, MR6],
    [MR19, MR7],
    [MR15, MR14],
    [MR11, MR10],
    [MR8, MR13],
    [MR6, MR6],
    [MR9, MR13],
    [MR7, MR18],
    [MR16, MR17],
    [MR10, MR6],
    [MR19, MR9],
    [MR8, MR7],
    [MR13, MR10],
    [MR14, MR6],
    [MR15, MR15],
    [MR17, MR7],
    [MR11, MR6],
    [MR18, MR13],
    [MR16, MR6],
    [MR9, MR7],
    [MR8, MR10],
    [MR19, MR13],
    [MR14, MR7],
    [MR15, MR7],
    [MR17, MR16],
    [MR17, MR16],
    [MR10, MR11],
    [MR18, MR9],
    [MR8, MR6],
    [MR13, MR6],
    [MR14, MR17],
    [MR19, MR6],
    [MR7, MR11],
    [MR13, MR19],
    [MR9, MR18],
    [MR10, MR17],
    [MR8, MR19],
    [MR15, MR6],
    [MR13, MR7],
    [MR14, MR6],
    [MR6, MR19]
  ]"

definition span3_story_rules_50 :: "mix_rule list list" where
  "span3_story_rules_50 \<equiv> [
    [MR7, MR9, MR6],
    [MR10, MR7, MR6],
    [MR11, MR7, MR13],
    [MR8, MR9, MR16],
    [MR14, MR15, MR6],
    [MR17, MR7, MR18],
    [MR19, MR9, MR6],
    [MR13, MR10, MR7],
    [MR16, MR17, MR6],
    [MR9, MR18, MR13],
    [MR8, MR10, MR6],
    [MR11, MR10, MR6],
    [MR14, MR15, MR15],
    [MR7, MR18, MR6],
    [MR13, MR9, MR6],
    [MR10, MR16, MR7],
    [MR19, MR13, MR18],
    [MR17, MR6, MR7],
    [MR8, MR9, MR13],
    [MR14, MR17, MR6],
    [MR9, MR10, MR6],
    [MR11, MR7, MR13],
    [MR16, MR13, MR7],
    [MR18, MR9, MR6],
    [MR8, MR16, MR7],
    [MR10, MR13, MR6],
    [MR14, MR7, MR6],
    [MR17, MR16, MR13],
    [MR9, MR19, MR7],
    [MR11, MR8, MR6],
    [MR13, MR10, MR18],
    [MR7, MR6, MR6],
    [MR14, MR15, MR17],
    [MR16, MR9, MR7],
    [MR8, MR13, MR6],
    [MR10, MR11, MR6],
    [MR18, MR19, MR13],
    [MR17, MR7, MR6],
    [MR9, MR6, MR13],
    [MR14, MR15, MR7],
    [MR11, MR7, MR9],
    [MR16, MR17, MR13],
    [MR8, MR10, MR9],
    [MR13, MR18, MR7],
    [MR14, MR6, MR6],
    [MR9, MR16, MR6],
    [MR10, MR17, MR7],
    [MR11, MR13, MR6],
    [MR8, MR17, MR7],
    [MR14, MR18, MR13]
  ]"

definition span4_story_rules_50 :: "mix_rule list list" where
  "span4_story_rules_50 \<equiv> [
    [MR7, MR9, MR6, MR6],
    [MR10, MR7, MR13, MR6],
    [MR11, MR7, MR9, MR13],
    [MR8, MR9, MR16, MR6],
    [MR14, MR15, MR6, MR6],
    [MR17, MR7, MR18, MR6],
    [MR19, MR9, MR6, MR13],
    [MR13, MR10, MR7, MR6],
    [MR16, MR17, MR6, MR6],
    [MR9, MR18, MR13, MR7],
    [MR8, MR10, MR6, MR6],
    [MR11, MR10, MR13, MR7],
    [MR14, MR15, MR15, MR6],
    [MR7, MR18, MR6, MR6],
    [MR13, MR9, MR6, MR6],
    [MR10, MR16, MR7, MR6],
    [MR19, MR13, MR18, MR7],
    [MR17, MR6, MR7, MR6],
    [MR8, MR9, MR13, MR6],
    [MR14, MR17, MR6, MR6],
    [MR9, MR10, MR6, MR13],
    [MR11, MR7, MR13, MR6],
    [MR16, MR13, MR7, MR6],
    [MR18, MR9, MR6, MR6],
    [MR8, MR16, MR7, MR6],
    [MR10, MR13, MR6, MR7],
    [MR14, MR7, MR6, MR15],
    [MR17, MR16, MR13, MR6],
    [MR9, MR19, MR7, MR6],
    [MR11, MR8, MR6, MR6],
    [MR13, MR10, MR18, MR7],
    [MR7, MR6, MR6, MR9],
    [MR14, MR15, MR17, MR6],
    [MR16, MR9, MR7, MR13],
    [MR8, MR13, MR6, MR6],
    [MR10, MR11, MR6, MR6],
    [MR18, MR19, MR13, MR7],
    [MR17, MR7, MR6, MR6],
    [MR9, MR6, MR13, MR6],
    [MR14, MR15, MR7, MR6],
    [MR11, MR7, MR9, MR6],
    [MR16, MR17, MR13, MR6],
    [MR8, MR10, MR9, MR13],
    [MR13, MR18, MR7, MR6],
    [MR14, MR6, MR6, MR15],
    [MR9, MR16, MR6, MR7],
    [MR10, MR17, MR7, MR6],
    [MR11, MR13, MR6, MR6],
    [MR8, MR17, MR7, MR6],
    [MR14, MR18, MR13, MR7]
  ]"

definition span5_story_rules_50 :: "mix_rule list list" where
  "span5_story_rules_50 \<equiv> [
    [MR7, MR9, MR6, MR6, MR16],
    [MR10, MR7, MR6, MR6, MR9],
    [MR11, MR7, MR9, MR6, MR6],
    [MR8, MR9, MR16, MR6, MR6],
    [MR14, MR15, MR6, MR6, MR7],
    [MR17, MR7, MR18, MR6, MR6],
    [MR19, MR9, MR6, MR7, MR6],
    [MR10, MR7, MR6, MR6, MR11],
    [MR16, MR17, MR6, MR6, MR7],
    [MR9, MR18, MR7, MR6, MR6],
    [MR8, MR10, MR6, MR6, MR16],
    [MR11, MR10, MR6, MR6, MR7],
    [MR14, MR15, MR15, MR6, MR7],
    [MR7, MR18, MR6, MR6, MR9],
    [MR13, MR9, MR6, MR6, MR6],
    [MR10, MR16, MR7, MR6, MR6],
    [MR19, MR13, MR18, MR7, MR7],
    [MR17, MR6, MR7, MR6, MR9],
    [MR8, MR9, MR13, MR6, MR6],
    [MR14, MR17, MR6, MR6, MR15],
    [MR9, MR10, MR7, MR6, MR6],
    [MR11, MR7, MR13, MR6, MR6],
    [MR16, MR13, MR7, MR6, MR6],
    [MR18, MR9, MR6, MR6, MR7],
    [MR8, MR16, MR7, MR6, MR6],
    [MR10, MR13, MR6, MR7, MR6],
    [MR14, MR7, MR6, MR6, MR15],
    [MR17, MR16, MR7, MR6, MR6],
    [MR9, MR19, MR7, MR6, MR6],
    [MR11, MR8, MR6, MR6, MR7],
    [MR13, MR10, MR18, MR7, MR7],
    [MR7, MR6, MR6, MR9, MR6],
    [MR14, MR15, MR17, MR6, MR6],
    [MR16, MR9, MR7, MR13, MR6],
    [MR8, MR13, MR6, MR6, MR6],
    [MR10, MR11, MR6, MR6, MR6],
    [MR18, MR19, MR13, MR7, MR7],
    [MR17, MR7, MR6, MR6, MR6],
    [MR9, MR6, MR13, MR6, MR6],
    [MR14, MR15, MR7, MR6, MR6],
    [MR11, MR7, MR9, MR6, MR6],
    [MR16, MR17, MR13, MR6, MR6],
    [MR8, MR10, MR9, MR6, MR6],
    [MR16, MR17, MR7, MR6, MR19],
    [MR18, MR9, MR7, MR6, MR6],
    [MR14, MR6, MR6, MR7, MR15],
    [MR10, MR7, MR16, MR6, MR6],
    [MR9, MR19, MR16, MR7, MR6],
    [MR11, MR7, MR9, MR6, MR16],
    [MR8, MR14, MR6, MR6, MR7]
  ]"

definition mk_span2_case_from_story :: "nat \<Rightarrow> mix_rule list \<Rightarrow> span2_case" where
  "mk_span2_case_from_story i rs \<equiv>
    (let cs = complete_mix_rules 2 rs
     in (pick_claim_of_mix (cs ! 0) i,
         pick_claim_of_mix (cs ! 1) (i + 1)))"

definition mk_span3_case_from_story :: "nat \<Rightarrow> mix_rule list \<Rightarrow> span3_case" where
  "mk_span3_case_from_story i rs \<equiv>
    (let cs = complete_mix_rules 3 rs
     in (pick_claim_of_mix (cs ! 0) i,
         pick_claim_of_mix (cs ! 1) (i + 1),
         pick_claim_of_mix (cs ! 2) (i + 2)))"

definition mk_span4_case_from_story :: "nat \<Rightarrow> mix_rule list \<Rightarrow> span4_case" where
  "mk_span4_case_from_story i rs \<equiv>
    (let cs = complete_mix_rules 4 rs
     in (pick_claim_of_mix (cs ! 0) i,
         pick_claim_of_mix (cs ! 1) (i + 1),
         pick_claim_of_mix (cs ! 2) (i + 2),
         pick_claim_of_mix (cs ! 3) (i + 3)))"

definition mk_span5_case_from_story :: "nat \<Rightarrow> mix_rule list \<Rightarrow> span5_case" where
  "mk_span5_case_from_story i rs \<equiv>
    (let cs = complete_mix_rules 5 rs
     in (pick_claim_of_mix (cs ! 0) i,
         pick_claim_of_mix (cs ! 1) (i + 1),
         pick_claim_of_mix (cs ! 2) (i + 2),
         pick_claim_of_mix (cs ! 3) (i + 3),
         pick_claim_of_mix (cs ! 4) (i + 4)))"

definition eval_span2_case :: "span2_case \<Rightarrow> reimbursement_result list" where
  "eval_span2_case c \<equiv>
    [rr_of_claim_case_main (fst c),
     rr_of_claim_case_main (snd c)]"

definition eval_span3_case :: "span3_case \<Rightarrow> reimbursement_result list" where
  "eval_span3_case c \<equiv>
    [rr_of_claim_case_main (fst c),
     rr_of_claim_case_main (fst (snd c)),
     rr_of_claim_case_main (snd (snd c))]"

definition eval_span4_case :: "span4_case \<Rightarrow> reimbursement_result list" where
  "eval_span4_case c \<equiv>
    [rr_of_claim_case_main (fst c),
     rr_of_claim_case_main (fst (snd c)),
     rr_of_claim_case_main (fst (snd (snd c))),
     rr_of_claim_case_main (snd (snd (snd c)))]"

definition eval_span5_case :: "span5_case \<Rightarrow> reimbursement_result list" where
  "eval_span5_case c \<equiv>
    [rr_of_claim_case_main (fst c),
     rr_of_claim_case_main (fst (snd c)),
     rr_of_claim_case_main (fst (snd (snd c))),
     rr_of_claim_case_main (fst (snd (snd (snd c)))),
     rr_of_claim_case_main (snd (snd (snd (snd c))))]"


definition span2_cases_50 :: "span2_case list" where
  "span2_cases_50 \<equiv> map (\<lambda>p. mk_span2_case_from_story (fst p) (snd p)) (zip [0..<50] span2_story_rules_50)"
definition span3_cases_50 :: "span3_case list" where
  "span3_cases_50 \<equiv> map (\<lambda>p. mk_span3_case_from_story (fst p) (snd p)) (zip [0..<50] span3_story_rules_50)"
definition span4_cases_50 :: "span4_case list" where
  "span4_cases_50 \<equiv> map (\<lambda>p. mk_span4_case_from_story (fst p) (snd p)) (zip [0..<50] span4_story_rules_50)"
definition span5_cases_50 :: "span5_case list" where
  "span5_cases_50 \<equiv> map (\<lambda>p. mk_span5_case_from_story (fst p) (snd p)) (zip [0..<50] span5_story_rules_50)"


definition span2_result_map :: "(nat * reimbursement_result list) list" where
  "span2_result_map \<equiv> map (\<lambda>i. (i + 1, eval_span2_case (span2_cases_50 ! i))) [0..<50]"
definition span3_result_map :: "(nat * reimbursement_result list) list" where
  "span3_result_map \<equiv> map (\<lambda>i. (i + 1, eval_span3_case (span3_cases_50 ! i))) [0..<50]"
definition span4_result_map :: "(nat * reimbursement_result list) list" where
  "span4_result_map \<equiv> map (\<lambda>i. (i + 1, eval_span4_case (span4_cases_50 ! i))) [0..<50]"
definition span5_result_map :: "(nat * reimbursement_result list) list" where
  "span5_result_map \<equiv> map (\<lambda>i. (i + 1, eval_span5_case (span5_cases_50 ! i))) [0..<50]"

value "span2_result_map"
value "span3_result_map"
value "span4_result_map"
value "span5_result_map"

(* ===== Rebuilt 200 cases: one-case-one-rule, with 2/3/4/5 distinct identities inside ===== *)

datatype sr_rule = SR7 | SR8 | SR10 | SR13
datatype sr_identity = SID7 rule7_personnel_position | SIDR personnel_role
datatype sr_claim =
    SRC7 rule7_case
  | SRC8 rule8_case
  | SRC10 rule10_case
  | SRC13 rule13_case

record sr_multi_case =
  case_rule :: sr_rule
  case_claims :: "sr_claim list"

definition sr_rule_of_index :: "nat \<Rightarrow> sr_rule" where
  "sr_rule_of_index i \<equiv> [SR7, SR8, SR10, SR13] ! (i mod 4)"

definition sr_rule7_identity_pool :: "rule7_personnel_position list" where
  "sr_rule7_identity_pool \<equiv>
    [ R7P_Academician,
      R7P_DeputySenior_or_Above_ProfTech,
      R7P_Bureau_or_Equivalent_Duty,
      R7P_PostSalaryLevel5_orAbove_ProfTech,
      R7P_Other_Personnel,
      R7P_Major_National_Research_Project_Leader ]"

definition sr_role_identity_pool :: "personnel_role list" where
  "sr_role_identity_pool \<equiv>
    [ Role_Academician,
      Role_National_Mgmt_Post_Level2_OrAbove,
      Role_Bureau_Director_Level,
      Role_Division_Chief_And_Below,
      Role_Major_National_Research_Project_Leader,
      Role_National_ProfTech_Post_Level2 ]"

definition sr_rule10_quota :: "personnel_role \<Rightarrow> int * int * int * int * int" where
  "sr_rule10_quota r \<equiv>
    (case role_to_tier r of
       Tier_A \<Rightarrow> (500, 150, 80, 30, 760)
     | Tier_B \<Rightarrow> (400, 150, 70, 30, 650)
     | Tier_C \<Rightarrow> (340, 130, 50, 30, 550))"

definition sr_rule13_lecture_cap_safe :: "personnel_role \<Rightarrow> int" where
  "sr_rule13_lecture_cap_safe r \<equiv>
    (case role_to_tier r of Tier_A \<Rightarrow> 1200 | Tier_B \<Rightarrow> 900 | Tier_C \<Rightarrow> 450)"

definition sr_rule13_consult_cap_safe :: "personnel_role \<Rightarrow> int" where
  "sr_rule13_consult_cap_safe r \<equiv>
    (if role_to_tier r = Tier_C then 450 else 700)"

definition sr_rule13_consult_cap_exceed :: "personnel_role \<Rightarrow> int" where
  "sr_rule13_consult_cap_exceed r \<equiv>
    (if role_to_tier r = Tier_C then 650 else 1000)"

definition mk_rule7_case_new :: "rule7_personnel_position \<Rightarrow> nat \<Rightarrow> rule7_case" where
  "mk_rule7_case_new pos lane \<equiv>
    (let base = \<lparr>
      has_trip_report_form = True,
      signed_by_unit_head_and_sealed = True,
      unit_head_self_trip_has_other_leader_sign = False,
      is_unit_head_self_trip = False,
      has_intercity_transport_expense = True,
      has_lodging_expense = True,
      has_city_transport_expense = True,
      has_city_transport_receipts = True,
      city_transport_within_budget = True,
      fund_type = Research_Fund,
      person_position = pos,
      chosen_mode = Train,
      chosen_class = Train_First,
      has_contract_specific_transport_rule = False,
      satisfies_contract_transport_rule = False,
      transport_above_standard = False,
      has_transport_special_explanation = False,
      has_project_leader_signature_for_transport_exception = False,
      lodging_rank_of_traveler = Lodging_Bureau,
      lodging_nightly_amount = 520,
      lodging_nights = 2,
      city_key = ''BJ_ALL'',
      travel_month = 5,
      has_intercity_transport_invoice = True,
      has_lodging_invoice = True,
      transport_ticket_unobtainable_in_remote_research = False,
      has_approved_special_explanation_for_transport_no_ticket = False,
      has_other_valid_supporting_docs_for_transport_no_ticket = False,
      lodging_invoice_unobtainable = False,
      has_approved_special_explanation_for_lodging_no_invoice = False,
      has_handwritten_receipt_signed_by_payee = False,
      trip_days_calendar = 3,
      region_type = Other_Region,
      meal_subsidy_claimed_total = 300,
      city_transport_actual_claimed_total = 180,
      city_transport_lump_sum_claimed_total = 0,
      use_city_transport_lump_sum = False,
      intercity_and_lodging_both_paid_by_external_unit = False,
      only_one_of_intercity_or_lodging_paid_by_external_unit = False,
      has_signed_special_explanation_for_partial_external_support = False,
      has_valid_notice_or_invitation_for_partial_external_support = False,
      transport_or_meal_already_paid_by_external_unit = False,
      claimed_transport_or_meal_again_in_school = False,
      uses_self_drive_or_rental = False,
      has_signed_special_explanation_for_self_drive = False,
      rental_fuel_toll_total = 0,
      public_transport_lowest_standard_total = 0,
      is_external_invitee = False,
      external_invitee_transport_lodging_confirmed_by_project_leader = False,
      external_invitee_claims_meal_subsidy = False,
      external_invitee_claims_city_transport_lump_sum = False
    \<rparr>
    in if lane mod 3 = 0 then base
       else if lane mod 3 = 1 then base\<lparr>lodging_nightly_amount := 2000\<rparr>
       else base\<lparr>has_trip_report_form := False\<rparr>)"

definition mk_rule8_case_new :: "personnel_role \<Rightarrow> nat \<Rightarrow> rule8_case" where
  "mk_rule8_case_new r lane \<equiv>
    (let base = \<lparr>
      has_foreign_affairs_office_approval = True,
      has_overseas_expense_statement = True,
      expense_statement_includes_registration_fees = True,
      expense_statement_includes_living_allowance = True,
      expense_statement_includes_incidental_expenses = True,
      expense_statement_includes_transportation = True,
      airfare_expense_with_boarding_pass = True,
      accommodation_expense_with_receipts = True,
      conference_registration_fees_with_receipts = False,
      inter_city_transportation_with_receipts = False,
      visa_fees_with_receipts = True,
      insurance_fees_with_receipts = True,
      reviewed_by_foreign_affairs_travel_center = True,
      signed_by_foreign_affairs_travel_center = True,
      is_research_project_fund = False,
      is_non_research_project_fund = True,
      overseas_traveler_role = r,
      travel_by_first_class_air = False,
      travel_by_business_class_air = False,
      travel_by_economy_class_air = True,
      travel_by_high_grade_soft_sleeper_rail = False,
      travel_by_soft_sleeper_rail = False,
      travel_by_hard_seat_rail = True,
      travel_by_business_class_hsr = False,
      travel_by_first_class_hsr = False,
      travel_by_second_class_hsr = True,
      travel_by_first_class_ship = False,
      travel_by_second_class_ship = False,
      travel_by_third_class_ship = True,
      international_airfare_paid_by_business_card = False,
      international_airfare_paid_by_bank_transfer = True,
      accommodation_paid_by_business_card = False,
      accommodation_paid_by_bank_transfer = True,
      expenses_prepaid_for_future_travel = False,
      reimbursement_completed_after_return = True,
      travel_advance_for_airfare_arranged = False,
      travel_advance_for_accommodation_arranged = False,
      trip_duration_over_one_month = False,
      has_special_circumstances_for_advance = False,
      all_overseas_expenses_reimbursed_together = True,
      books_purchased_overseas = False,
      materials_purchased_overseas = False,
      books_reimbursed_with_overseas_expenses = False,
      materials_reimbursed_with_overseas_expenses = False,
      foreign_website_purchase_without_formal_receipts = False,
      printed_purchase_records_provided = False,
      authenticity_statement_attached = False,
      exclusivity_statement_attached = False,
      foreign_currency_selected_in_appointment = True,
      foreign_currency_converted_by_system = True,
      foreign_currency_converted_manually = False,
      exchange_rate_proof_attached = False,
      multiple_currencies_cannot_be_scheduled = False
    \<rparr>
    in if lane mod 3 = 0 then base
       else if lane mod 3 = 1 then base\<lparr>
         travel_by_economy_class_air := False,
         travel_by_hard_seat_rail := False,
         travel_by_second_class_hsr := False,
         travel_by_third_class_ship := False
       \<rparr>
       else base\<lparr>has_foreign_affairs_office_approval := False\<rparr>)"

definition mk_rule10_case_new :: "personnel_role \<Rightarrow> nat \<Rightarrow> rule10_case" where
  "mk_rule10_case_new r lane \<equiv>
    (let (aq,mq,vq,oq,tq) = sr_rule10_quota r;
         days = 5;
         base = \<lparr>
           training_participant_role = r,
           training_duration_days = days,
           training_exceeds_30_days = False,
           training_days_beyond_30 = 0,
           training_has_instructor_fees = True,
           training_instructor_fees = 1000,
           training_accommodation_expense = aq * days,
           training_meals_expense = mq * days,
           training_venue_materials_transport_expense = vq * days,
           training_other_expense = oq * days,
           training_total_expense = (aq + mq + vq + oq) * days,
           training_accommodation_quota = aq,
           training_meals_quota = mq,
           training_venue_materials_transport_quota = vq,
           training_other_quota = oq,
           training_total_quota = tq,
           has_training_expense_detailed_list = True,
           has_trainee_list_with_contact = True,
           has_training_service_provider_receipts = True,
           instructor_lecture_fees = 1000,
           instructor_accommodation_expense = aq,
           instructor_meals_expense = mq,
           instructor_transportation_expense = 300,
           instructor_from_other_locations = True
         \<rparr>
     in if lane mod 3 = 0 then base
        else if lane mod 3 = 1 then base\<lparr>
          training_other_expense := oq * days + 80,
          training_total_expense := (aq * days) + (mq * days) + (vq * days) + (oq * days + 80)
        \<rparr>
        else base\<lparr>has_training_expense_detailed_list := False\<rparr>)"

definition mk_rule13_case_new :: "personnel_role \<Rightarrow> nat \<Rightarrow> rule13_case" where
  "mk_rule13_case_new r lane \<equiv>
    (let base = \<lparr>
      expense_graduate_thesis_review_defense = False,
      expense_lecture_fees = True,
      expense_expert_consultation_fees = True,
      expense_doctoral_dissertation = False,
      expense_master_thesis = False,
      reviewer_count = 0,
      reviewer_fee_per_person = 0,
      defense_committee_count = 0,
      defense_committee_fee_per_person = 0,
      defense_secretary_count = 0,
      defense_secretary_fee_per_person = 0,
      lecture_fee_is_after_tax = True,
      lecture_speaker_role = r,
      lecture_fee_per_class_hour = sr_rule13_lecture_cap_safe r,
      lecture_class_hours = 4,
      lecture_half_days = 1,
      consultation_participant_role = r,
      consultation_type_in_person = True,
      consultation_type_communication = False,
      consultation_days = 2,
      consultation_fee_per_day = sr_rule13_consult_cap_safe r,
      consultation_fee_per_project = 0
    \<rparr>
    in if lane mod 3 = 0 then base
       else if lane mod 3 = 1 then base\<lparr>consultation_fee_per_day := sr_rule13_consult_cap_exceed r\<rparr>
       else base\<lparr>lecture_fee_is_after_tax := False\<rparr>)"

definition mk_sr_claim_new :: "sr_rule \<Rightarrow> nat \<Rightarrow> sr_claim" where
  "mk_sr_claim_new rr j \<equiv>
    (case rr of
       SR7 \<Rightarrow> SRC7 (mk_rule7_case_new (pick sr_rule7_identity_pool j) (j mod 3))
     | SR8 \<Rightarrow> SRC8 (mk_rule8_case_new (pick sr_role_identity_pool j) (j mod 3))
     | SR10 \<Rightarrow> SRC10 (mk_rule10_case_new (pick sr_role_identity_pool j) (j mod 3))
     | SR13 \<Rightarrow> SRC13 (mk_rule13_case_new (pick sr_role_identity_pool j) (j mod 3)))"

definition mk_sr_multi_case_new :: "nat \<Rightarrow> nat \<Rightarrow> sr_multi_case" where
  "mk_sr_multi_case_new n i \<equiv>
    (let rr = sr_rule_of_index i
     in \<lparr>case_rule = rr, case_claims = map (\<lambda>k. mk_sr_claim_new rr (i + k)) [0..<n]\<rparr>)"

definition eval_sr_claim_new :: "sr_claim \<Rightarrow> reimbursement_result" where
  "eval_sr_claim_new c \<equiv>
    (case c of
       SRC7 x \<Rightarrow> rule_7_evaluate x
     | SRC8 x \<Rightarrow> rule_8_evaluate x
     | SRC10 x \<Rightarrow> rule_10_evaluate x
     | SRC13 x \<Rightarrow> rule_13_evaluate x)"

definition identity_of_sr_claim_new :: "sr_claim \<Rightarrow> sr_identity" where
  "identity_of_sr_claim_new c \<equiv>
    (case c of
       SRC7 x \<Rightarrow> SID7 (person_position x)
     | SRC8 x \<Rightarrow> SIDR (overseas_traveler_role x)
     | SRC10 x \<Rightarrow> SIDR (training_participant_role x)
     | SRC13 x \<Rightarrow> SIDR (lecture_speaker_role x))"

definition eval_sr_multi_case_new :: "sr_multi_case \<Rightarrow> reimbursement_result list" where
  "eval_sr_multi_case_new c \<equiv> map eval_sr_claim_new (case_claims c)"

definition identities_sr_multi_case_new :: "sr_multi_case \<Rightarrow> sr_identity list" where
  "identities_sr_multi_case_new c \<equiv> map identity_of_sr_claim_new (case_claims c)"

definition distinct_identity_count_new :: "sr_multi_case \<Rightarrow> nat" where
  "distinct_identity_count_new c \<equiv> length (remdups (identities_sr_multi_case_new c))"

definition sr_span2_cases_new_50 :: "sr_multi_case list" where
  "sr_span2_cases_new_50 \<equiv> map (mk_sr_multi_case_new 2) [0..<50]"
definition sr_span3_cases_new_50 :: "sr_multi_case list" where
  "sr_span3_cases_new_50 \<equiv> map (mk_sr_multi_case_new 3) [0..<50]"
definition sr_span4_cases_new_50 :: "sr_multi_case list" where
  "sr_span4_cases_new_50 \<equiv> map (mk_sr_multi_case_new 4) [0..<50]"
definition sr_span5_cases_new_50 :: "sr_multi_case list" where
  "sr_span5_cases_new_50 \<equiv> map (mk_sr_multi_case_new 5) [0..<50]"

definition sr_span2_result_map_new :: "(nat * reimbursement_result list) list" where
  "sr_span2_result_map_new \<equiv> map (\<lambda>i. (i + 1, eval_sr_multi_case_new (sr_span2_cases_new_50 ! i))) [0..<50]"
definition sr_span3_result_map_new :: "(nat * reimbursement_result list) list" where
  "sr_span3_result_map_new \<equiv> map (\<lambda>i. (i + 1, eval_sr_multi_case_new (sr_span3_cases_new_50 ! i))) [0..<50]"
definition sr_span4_result_map_new :: "(nat * reimbursement_result list) list" where
  "sr_span4_result_map_new \<equiv> map (\<lambda>i. (i + 1, eval_sr_multi_case_new (sr_span4_cases_new_50 ! i))) [0..<50]"
definition sr_span5_result_map_new :: "(nat * reimbursement_result list) list" where
  "sr_span5_result_map_new \<equiv> map (\<lambda>i. (i + 1, eval_sr_multi_case_new (sr_span5_cases_new_50 ! i))) [0..<50]"

definition sr_span2_identity_map_new :: "(nat * sr_identity list) list" where
  "sr_span2_identity_map_new \<equiv> map (\<lambda>i. (i + 1, identities_sr_multi_case_new (sr_span2_cases_new_50 ! i))) [0..<50]"
definition sr_span3_identity_map_new :: "(nat * sr_identity list) list" where
  "sr_span3_identity_map_new \<equiv> map (\<lambda>i. (i + 1, identities_sr_multi_case_new (sr_span3_cases_new_50 ! i))) [0..<50]"
definition sr_span4_identity_map_new :: "(nat * sr_identity list) list" where
  "sr_span4_identity_map_new \<equiv> map (\<lambda>i. (i + 1, identities_sr_multi_case_new (sr_span4_cases_new_50 ! i))) [0..<50]"
definition sr_span5_identity_map_new :: "(nat * sr_identity list) list" where
  "sr_span5_identity_map_new \<equiv> map (\<lambda>i. (i + 1, identities_sr_multi_case_new (sr_span5_cases_new_50 ! i))) [0..<50]"

definition sr_span_identity_count_check_new :: "(nat * nat list) list" where
  "sr_span_identity_count_check_new \<equiv>
    [ (2, map (\<lambda>c. distinct_identity_count_new c) sr_span2_cases_new_50),
      (3, map (\<lambda>c. distinct_identity_count_new c) sr_span3_cases_new_50),
      (4, map (\<lambda>c. distinct_identity_count_new c) sr_span4_cases_new_50),
      (5, map (\<lambda>c. distinct_identity_count_new c) sr_span5_cases_new_50) ]"

definition count_rr :: "reimbursement_result list \<Rightarrow> reimbursement_result \<Rightarrow> nat" where
  "count_rr xs r \<equiv> length (filter (\<lambda>x. x = r) xs)"

definition sr_span2_result_count_map_new :: "(reimbursement_result * nat) list" where
  "sr_span2_result_count_map_new \<equiv>
    (let xs = concat (map snd sr_span2_result_map_new) in
      [(Full_Approval, count_rr xs Full_Approval),
       (Partial_Approval, count_rr xs Partial_Approval),
       (Rejection, count_rr xs Rejection),
       (Unknown, count_rr xs Unknown)])"
definition sr_span3_result_count_map_new :: "(reimbursement_result * nat) list" where
  "sr_span3_result_count_map_new \<equiv>
    (let xs = concat (map snd sr_span3_result_map_new) in
      [(Full_Approval, count_rr xs Full_Approval),
       (Partial_Approval, count_rr xs Partial_Approval),
       (Rejection, count_rr xs Rejection),
       (Unknown, count_rr xs Unknown)])"
definition sr_span4_result_count_map_new :: "(reimbursement_result * nat) list" where
  "sr_span4_result_count_map_new \<equiv>
    (let xs = concat (map snd sr_span4_result_map_new) in
      [(Full_Approval, count_rr xs Full_Approval),
       (Partial_Approval, count_rr xs Partial_Approval),
       (Rejection, count_rr xs Rejection),
       (Unknown, count_rr xs Unknown)])"
definition sr_span5_result_count_map_new :: "(reimbursement_result * nat) list" where
  "sr_span5_result_count_map_new \<equiv>
    (let xs = concat (map snd sr_span5_result_map_new) in
      [(Full_Approval, count_rr xs Full_Approval),
       (Partial_Approval, count_rr xs Partial_Approval),
       (Rejection, count_rr xs Rejection),
       (Unknown, count_rr xs Unknown)])"

definition sr_span_result_count_summary_map_new :: "(nat * (reimbursement_result * nat) list) list" where
  "sr_span_result_count_summary_map_new \<equiv>
    [ (2, sr_span2_result_count_map_new),
      (3, sr_span3_result_count_map_new),
      (4, sr_span4_result_count_map_new),
      (5, sr_span5_result_count_map_new) ]"

value "sr_span2_result_map_new"
value "sr_span3_result_map_new"
value "sr_span4_result_map_new"
value "sr_span5_result_map_new"
value "sr_span2_identity_map_new"
value "sr_span3_identity_map_new"
value "sr_span4_identity_map_new"
value "sr_span5_identity_map_new"
value "sr_span_identity_count_check_new"
value "sr_span_result_count_summary_map_new"

(* ===== Team-travel amount cases (Rule7 only): 2/3/4/5 persons, 50 each ===== *)

type_synonym r7_team2_case = "rule7v2_amount_case * rule7v2_amount_case"
type_synonym r7_team3_case = "rule7v2_amount_case * rule7v2_amount_case * rule7v2_amount_case"
type_synonym r7_team4_case = "rule7v2_amount_case * rule7v2_amount_case * rule7v2_amount_case * rule7v2_amount_case"
type_synonym r7_team5_case = "rule7v2_amount_case * rule7v2_amount_case * rule7v2_amount_case * rule7v2_amount_case * rule7v2_amount_case"

definition r7_team_position_pool :: "rule7_personnel_position list" where
  "r7_team_position_pool \<equiv>
    [ R7P_Academician,
      R7P_DeputySenior_or_Above_ProfTech,
      R7P_Bureau_or_Equivalent_Duty,
      R7P_PostSalaryLevel5_orAbove_ProfTech,
      R7P_Other_Personnel,
      R7P_Major_National_Research_Project_Leader ]"

definition mk_r7_team_common_base :: "nat \<Rightarrow> rule7_case" where
  "mk_r7_team_common_base i \<equiv> \<lparr>
    has_trip_report_form = True,
    signed_by_unit_head_and_sealed = True,
    unit_head_self_trip_has_other_leader_sign = False,
    is_unit_head_self_trip = False,
    has_intercity_transport_expense = True,
    has_lodging_expense = True,
    has_city_transport_expense = True,
    has_city_transport_receipts = True,
    city_transport_within_budget = True,
    fund_type = Research_Fund,
    person_position = R7P_Other_Personnel,
    chosen_mode = Air,
    chosen_class = Air_Economy,
    has_contract_specific_transport_rule = False,
    satisfies_contract_transport_rule = False,
    transport_above_standard = False,
    has_transport_special_explanation = False,
    has_project_leader_signature_for_transport_exception = False,
    lodging_rank_of_traveler = Lodging_Bureau,
    lodging_nightly_amount = (420 + int ((i mod 4) * 50)),
    lodging_nights = 2,
    city_key = ''BJ_ALL'',
    travel_month = 5,
    has_intercity_transport_invoice = True,
    has_lodging_invoice = True,
    transport_ticket_unobtainable_in_remote_research = False,
    has_approved_special_explanation_for_transport_no_ticket = False,
    has_other_valid_supporting_docs_for_transport_no_ticket = False,
    lodging_invoice_unobtainable = False,
    has_approved_special_explanation_for_lodging_no_invoice = False,
    has_handwritten_receipt_signed_by_payee = False,
    trip_days_calendar = 3,
    region_type = Other_Region,
    meal_subsidy_claimed_total = 300,
    city_transport_actual_claimed_total = 160,
    city_transport_lump_sum_claimed_total = 0,
    use_city_transport_lump_sum = False,
    intercity_and_lodging_both_paid_by_external_unit = False,
    only_one_of_intercity_or_lodging_paid_by_external_unit = False,
    has_signed_special_explanation_for_partial_external_support = False,
    has_valid_notice_or_invitation_for_partial_external_support = False,
    transport_or_meal_already_paid_by_external_unit = False,
    claimed_transport_or_meal_again_in_school = False,
    uses_self_drive_or_rental = False,
    has_signed_special_explanation_for_self_drive = False,
    rental_fuel_toll_total = 0,
    public_transport_lowest_standard_total = 0,
    is_external_invitee = False,
    external_invitee_transport_lodging_confirmed_by_project_leader = False,
    external_invitee_claims_meal_subsidy = False,
    external_invitee_claims_city_transport_lump_sum = False
  \<rparr>"

definition mk_r7_team_member_case :: "nat \<Rightarrow> nat \<Rightarrow> rule7v2_amount_case" where
  "mk_r7_team_member_case i k \<equiv>
    (let j = i + k;
         pos = pick r7_team_position_pool j;
         base0 = mk_r7_team_common_base i;
         base1 = base0\<lparr>
           person_position := pos,
           lodging_nightly_amount := 420 + int ((j mod 4) * 60),
           meal_subsidy_claimed_total := 300 + int ((j mod 2) * 20),
           city_transport_actual_claimed_total := 150 + int ((j mod 3) * 20)
         \<rparr>;
         lane = j mod 3;
         c = (if lane = 0 then base1
              else if lane = 1 then base1\<lparr>
                lodging_nightly_amount := 2000,
                city_transport_actual_claimed_total := 500
              \<rparr>
              else base1\<lparr>has_trip_report_form := False\<rparr>);
         ci = 1200 + int ((j mod 5) * 150);
         cl = (lodging_nightly_amount c) * (lodging_nights c) + (if lane = 1 then 800 else 200)
     in mk_rule7v2_case c ci cl)"

definition mk_r7_team2_case :: "nat \<Rightarrow> r7_team2_case" where
  "mk_r7_team2_case i \<equiv>
    (mk_r7_team_member_case i 0,
     mk_r7_team_member_case i 1)"

definition mk_r7_team3_case :: "nat \<Rightarrow> r7_team3_case" where
  "mk_r7_team3_case i \<equiv>
    (mk_r7_team_member_case i 0,
     mk_r7_team_member_case i 1,
     mk_r7_team_member_case i 2)"

definition mk_r7_team4_case :: "nat \<Rightarrow> r7_team4_case" where
  "mk_r7_team4_case i \<equiv>
    (mk_r7_team_member_case i 0,
     mk_r7_team_member_case i 1,
     mk_r7_team_member_case i 2,
     mk_r7_team_member_case i 3)"

definition mk_r7_team5_case :: "nat \<Rightarrow> r7_team5_case" where
  "mk_r7_team5_case i \<equiv>
    (mk_r7_team_member_case i 0,
     mk_r7_team_member_case i 1,
     mk_r7_team_member_case i 2,
     mk_r7_team_member_case i 3,
     mk_r7_team_member_case i 4)"

definition eval_r7_member_amount :: "rule7v2_amount_case \<Rightarrow> reimbursement_result * int" where
  "eval_r7_member_amount c \<equiv> rule7v2_amount_decision c"

definition eval_r7_team2_case :: "r7_team2_case \<Rightarrow> (reimbursement_result * int) list" where
  "eval_r7_team2_case c \<equiv> [eval_r7_member_amount (fst c), eval_r7_member_amount (snd c)]"

definition eval_r7_team3_case :: "r7_team3_case \<Rightarrow> (reimbursement_result * int) list" where
  "eval_r7_team3_case c \<equiv>
    [eval_r7_member_amount (fst c),
     eval_r7_member_amount (fst (snd c)),
     eval_r7_member_amount (snd (snd c))]"

definition eval_r7_team4_case :: "r7_team4_case \<Rightarrow> (reimbursement_result * int) list" where
  "eval_r7_team4_case c \<equiv>
    [eval_r7_member_amount (fst c),
     eval_r7_member_amount (fst (snd c)),
     eval_r7_member_amount (fst (snd (snd c))),
     eval_r7_member_amount (snd (snd (snd c)))]"

definition eval_r7_team5_case :: "r7_team5_case \<Rightarrow> (reimbursement_result * int) list" where
  "eval_r7_team5_case c \<equiv>
    [eval_r7_member_amount (fst c),
     eval_r7_member_amount (fst (snd c)),
     eval_r7_member_amount (fst (snd (snd c))),
     eval_r7_member_amount (fst (snd (snd (snd c)))),
     eval_r7_member_amount (snd (snd (snd (snd c))))]"

definition sum_amounts :: "(reimbursement_result * int) list \<Rightarrow> int" where
  "sum_amounts xs \<equiv> foldl (\<lambda>acc p. acc + snd p) 0 xs"

definition member_position_of :: "rule7v2_amount_case \<Rightarrow> rule7_personnel_position" where
  "member_position_of c \<equiv> person_position (base7v2 c)"

definition r7_team2_cases_new_50 :: "r7_team2_case list" where
  "r7_team2_cases_new_50 \<equiv> map mk_r7_team2_case [0..<50]"
definition r7_team3_cases_new_50 :: "r7_team3_case list" where
  "r7_team3_cases_new_50 \<equiv> map mk_r7_team3_case [0..<50]"
definition r7_team4_cases_new_50 :: "r7_team4_case list" where
  "r7_team4_cases_new_50 \<equiv> map mk_r7_team4_case [0..<50]"
definition r7_team5_cases_new_50 :: "r7_team5_case list" where
  "r7_team5_cases_new_50 \<equiv> map mk_r7_team5_case [0..<50]"

definition r7_team2_amount_map_new :: "(nat * (reimbursement_result * int) list) list" where
  "r7_team2_amount_map_new \<equiv> map (\<lambda>i. (i + 1, eval_r7_team2_case (r7_team2_cases_new_50 ! i))) [0..<50]"
definition r7_team3_amount_map_new :: "(nat * (reimbursement_result * int) list) list" where
  "r7_team3_amount_map_new \<equiv> map (\<lambda>i. (i + 1, eval_r7_team3_case (r7_team3_cases_new_50 ! i))) [0..<50]"
definition r7_team4_amount_map_new :: "(nat * (reimbursement_result * int) list) list" where
  "r7_team4_amount_map_new \<equiv> map (\<lambda>i. (i + 1, eval_r7_team4_case (r7_team4_cases_new_50 ! i))) [0..<50]"
definition r7_team5_amount_map_new :: "(nat * (reimbursement_result * int) list) list" where
  "r7_team5_amount_map_new \<equiv> map (\<lambda>i. (i + 1, eval_r7_team5_case (r7_team5_cases_new_50 ! i))) [0..<50]"

definition r7_team2_total_amount_map_new :: "(nat * int) list" where
  "r7_team2_total_amount_map_new \<equiv> map (\<lambda>p. (fst p, sum_amounts (snd p))) r7_team2_amount_map_new"
definition r7_team3_total_amount_map_new :: "(nat * int) list" where
  "r7_team3_total_amount_map_new \<equiv> map (\<lambda>p. (fst p, sum_amounts (snd p))) r7_team3_amount_map_new"
definition r7_team4_total_amount_map_new :: "(nat * int) list" where
  "r7_team4_total_amount_map_new \<equiv> map (\<lambda>p. (fst p, sum_amounts (snd p))) r7_team4_amount_map_new"
definition r7_team5_total_amount_map_new :: "(nat * int) list" where
  "r7_team5_total_amount_map_new \<equiv> map (\<lambda>p. (fst p, sum_amounts (snd p))) r7_team5_amount_map_new"

definition r7_team2_identity_map_new :: "(nat * rule7_personnel_position list) list" where
  "r7_team2_identity_map_new \<equiv>
    map (\<lambda>i. (i + 1,
      [ member_position_of (fst (r7_team2_cases_new_50 ! i)),
        member_position_of (snd (r7_team2_cases_new_50 ! i)) ])) [0..<50]"

definition r7_team3_identity_map_new :: "(nat * rule7_personnel_position list) list" where
  "r7_team3_identity_map_new \<equiv>
    map (\<lambda>i. (i + 1,
      [ member_position_of (fst (r7_team3_cases_new_50 ! i)),
        member_position_of (fst (snd (r7_team3_cases_new_50 ! i))),
        member_position_of (snd (snd (r7_team3_cases_new_50 ! i))) ])) [0..<50]"

definition r7_team4_identity_map_new :: "(nat * rule7_personnel_position list) list" where
  "r7_team4_identity_map_new \<equiv>
    map (\<lambda>i. (i + 1,
      [ member_position_of (fst (r7_team4_cases_new_50 ! i)),
        member_position_of (fst (snd (r7_team4_cases_new_50 ! i))),
        member_position_of (fst (snd (snd (r7_team4_cases_new_50 ! i)))),
        member_position_of (snd (snd (snd (r7_team4_cases_new_50 ! i)))) ])) [0..<50]"

definition r7_team5_identity_map_new :: "(nat * rule7_personnel_position list) list" where
  "r7_team5_identity_map_new \<equiv>
    map (\<lambda>i. (i + 1,
      [ member_position_of (fst (r7_team5_cases_new_50 ! i)),
        member_position_of (fst (snd (r7_team5_cases_new_50 ! i))),
        member_position_of (fst (snd (snd (r7_team5_cases_new_50 ! i)))),
        member_position_of (fst (snd (snd (snd (r7_team5_cases_new_50 ! i))))),
        member_position_of (snd (snd (snd (snd (r7_team5_cases_new_50 ! i))))) ])) [0..<50]"

value "r7_team2_amount_map_new"
value "r7_team3_amount_map_new"
value "r7_team4_amount_map_new"
value "r7_team5_amount_map_new"
value "r7_team2_total_amount_map_new"
value "r7_team3_total_amount_map_new"
value "r7_team4_total_amount_map_new"
value "r7_team5_total_amount_map_new"
value "r7_team2_identity_map_new"
value "r7_team3_identity_map_new"
value "r7_team4_identity_map_new"
value "r7_team5_identity_map_new"

(* ===== Team result cases for Rule8 (no amount calculation) ===== *)

definition mk_rule8_team_member_case_new :: "nat \<Rightarrow> nat \<Rightarrow> rule8_case" where
  "mk_rule8_team_member_case_new i k \<equiv>
    (let j = i + k;
         r = pick sr_role_identity_pool j;
         lane = j mod 3;
         base0 = \<lparr>
           has_foreign_affairs_office_approval = True,
           has_overseas_expense_statement = True,
           expense_statement_includes_registration_fees = True,
           expense_statement_includes_living_allowance = True,
           expense_statement_includes_incidental_expenses = True,
           expense_statement_includes_transportation = True,
           airfare_expense_with_boarding_pass = True,
           accommodation_expense_with_receipts = True,
           conference_registration_fees_with_receipts = True,
           inter_city_transportation_with_receipts = False,
           visa_fees_with_receipts = True,
           insurance_fees_with_receipts = True,
           reviewed_by_foreign_affairs_travel_center = True,
           signed_by_foreign_affairs_travel_center = True,
           is_research_project_fund = False,
           is_non_research_project_fund = True,
           overseas_traveler_role = r,
           travel_by_first_class_air = False,
           travel_by_business_class_air = False,
           travel_by_economy_class_air = True,
           travel_by_high_grade_soft_sleeper_rail = False,
           travel_by_soft_sleeper_rail = False,
           travel_by_hard_seat_rail = True,
           travel_by_business_class_hsr = False,
           travel_by_first_class_hsr = False,
           travel_by_second_class_hsr = True,
           travel_by_first_class_ship = False,
           travel_by_second_class_ship = False,
           travel_by_third_class_ship = True,
           international_airfare_paid_by_business_card = False,
           international_airfare_paid_by_bank_transfer = True,
           accommodation_paid_by_business_card = False,
           accommodation_paid_by_bank_transfer = True,
           expenses_prepaid_for_future_travel = False,
           reimbursement_completed_after_return = True,
           travel_advance_for_airfare_arranged = False,
           travel_advance_for_accommodation_arranged = False,
           trip_duration_over_one_month = False,
           has_special_circumstances_for_advance = False,
           all_overseas_expenses_reimbursed_together = True,
           books_purchased_overseas = False,
           materials_purchased_overseas = False,
           books_reimbursed_with_overseas_expenses = False,
           materials_reimbursed_with_overseas_expenses = False,
           foreign_website_purchase_without_formal_receipts = False,
           printed_purchase_records_provided = False,
           authenticity_statement_attached = False,
           exclusivity_statement_attached = False,
           foreign_currency_selected_in_appointment = True,
           foreign_currency_converted_by_system = True,
           foreign_currency_converted_manually = False,
           exchange_rate_proof_attached = False,
           multiple_currencies_cannot_be_scheduled = False
         \<rparr>;
         base1 = (if lane = 0 then base0
                  else if lane = 1 then base0\<lparr>
                    travel_by_economy_class_air := False,
                    travel_by_hard_seat_rail := False,
                    travel_by_second_class_hsr := False,
                    travel_by_third_class_ship := False
                  \<rparr>
                  else base0\<lparr>has_foreign_affairs_office_approval := False\<rparr>)
     in base1)"

definition mk_rule8_team_cases_new :: "nat \<Rightarrow> rule8_case list list" where
  "mk_rule8_team_cases_new n \<equiv> map (\<lambda>i. map (\<lambda>k. mk_rule8_team_member_case_new i k) [0..<n]) [0..<50]"

definition eval_rule8_team_case_new :: "rule8_case list \<Rightarrow> reimbursement_result list" where
  "eval_rule8_team_case_new cs \<equiv> map rule_8_evaluate cs"

definition rule8_team2_cases_new_50 :: "rule8_case list list" where
  "rule8_team2_cases_new_50 \<equiv> mk_rule8_team_cases_new 2"
definition rule8_team3_cases_new_50 :: "rule8_case list list" where
  "rule8_team3_cases_new_50 \<equiv> mk_rule8_team_cases_new 3"
definition rule8_team4_cases_new_50 :: "rule8_case list list" where
  "rule8_team4_cases_new_50 \<equiv> mk_rule8_team_cases_new 4"
definition rule8_team5_cases_new_50 :: "rule8_case list list" where
  "rule8_team5_cases_new_50 \<equiv> mk_rule8_team_cases_new 5"

definition rule8_team2_result_map_new :: "(nat * reimbursement_result list) list" where
  "rule8_team2_result_map_new \<equiv> map (\<lambda>i. (i + 1, eval_rule8_team_case_new (rule8_team2_cases_new_50 ! i))) [0..<50]"
definition rule8_team3_result_map_new :: "(nat * reimbursement_result list) list" where
  "rule8_team3_result_map_new \<equiv> map (\<lambda>i. (i + 1, eval_rule8_team_case_new (rule8_team3_cases_new_50 ! i))) [0..<50]"
definition rule8_team4_result_map_new :: "(nat * reimbursement_result list) list" where
  "rule8_team4_result_map_new \<equiv> map (\<lambda>i. (i + 1, eval_rule8_team_case_new (rule8_team4_cases_new_50 ! i))) [0..<50]"
definition rule8_team5_result_map_new :: "(nat * reimbursement_result list) list" where
  "rule8_team5_result_map_new \<equiv> map (\<lambda>i. (i + 1, eval_rule8_team_case_new (rule8_team5_cases_new_50 ! i))) [0..<50]"

definition rule8_team2_identity_map_new :: "(nat * personnel_role list) list" where
  "rule8_team2_identity_map_new \<equiv> map (\<lambda>i. (i + 1, map overseas_traveler_role (rule8_team2_cases_new_50 ! i))) [0..<50]"
definition rule8_team3_identity_map_new :: "(nat * personnel_role list) list" where
  "rule8_team3_identity_map_new \<equiv> map (\<lambda>i. (i + 1, map overseas_traveler_role (rule8_team3_cases_new_50 ! i))) [0..<50]"
definition rule8_team4_identity_map_new :: "(nat * personnel_role list) list" where
  "rule8_team4_identity_map_new \<equiv> map (\<lambda>i. (i + 1, map overseas_traveler_role (rule8_team4_cases_new_50 ! i))) [0..<50]"
definition rule8_team5_identity_map_new :: "(nat * personnel_role list) list" where
  "rule8_team5_identity_map_new \<equiv> map (\<lambda>i. (i + 1, map overseas_traveler_role (rule8_team5_cases_new_50 ! i))) [0..<50]"

(* ===== Team amount cases for Rule10 ===== *)

definition mk_rule10_team_member_case_new :: "nat \<Rightarrow> nat \<Rightarrow> rule10_case" where
  "mk_rule10_team_member_case_new i k \<equiv>
    (let j = i + k;
         r = pick sr_role_identity_pool j;
         lane = j mod 3;
         (aq,mq,vq,oq,tq) = sr_rule10_quota r;
         days = 5;
         base0 = \<lparr>
           training_participant_role = r,
           training_duration_days = days,
           training_exceeds_30_days = False,
           training_days_beyond_30 = 0,
           training_has_instructor_fees = True,
           training_instructor_fees = 1000,
           training_accommodation_expense = aq * days,
           training_meals_expense = mq * days,
           training_venue_materials_transport_expense = vq * days,
           training_other_expense = oq * days,
           training_total_expense = (aq + mq + vq + oq) * days,
           training_accommodation_quota = aq,
           training_meals_quota = mq,
           training_venue_materials_transport_quota = vq,
           training_other_quota = oq,
           training_total_quota = tq,
           has_training_expense_detailed_list = True,
           has_trainee_list_with_contact = True,
           has_training_service_provider_receipts = True,
           instructor_lecture_fees = 1000,
           instructor_accommodation_expense = aq,
           instructor_meals_expense = mq,
           instructor_transportation_expense = 300,
           instructor_from_other_locations = True
         \<rparr>
     in if lane = 0 then base0
        else if lane = 1 then base0\<lparr>
          training_other_expense := oq * days + 80,
          training_total_expense := (aq * days) + (mq * days) + (vq * days) + (oq * days + 80)
        \<rparr>
        else base0\<lparr>has_training_expense_detailed_list := False\<rparr>)"

definition mk_rule10_team_cases_new :: "nat \<Rightarrow> rule10_case list list" where
  "mk_rule10_team_cases_new n \<equiv> map (\<lambda>i. map (\<lambda>k. mk_rule10_team_member_case_new i k) [0..<n]) [0..<50]"

definition eval_rule10_team_case_new :: "rule10_case list \<Rightarrow> (reimbursement_result * int) list" where
  "eval_rule10_team_case_new cs \<equiv> map rule10v2_amount_decision cs"

definition rule10_team2_cases_new_50 :: "rule10_case list list" where
  "rule10_team2_cases_new_50 \<equiv> mk_rule10_team_cases_new 2"
definition rule10_team3_cases_new_50 :: "rule10_case list list" where
  "rule10_team3_cases_new_50 \<equiv> mk_rule10_team_cases_new 3"
definition rule10_team4_cases_new_50 :: "rule10_case list list" where
  "rule10_team4_cases_new_50 \<equiv> mk_rule10_team_cases_new 4"
definition rule10_team5_cases_new_50 :: "rule10_case list list" where
  "rule10_team5_cases_new_50 \<equiv> mk_rule10_team_cases_new 5"

definition rule10_team2_amount_map_new :: "(nat * (reimbursement_result * int) list) list" where
  "rule10_team2_amount_map_new \<equiv> map (\<lambda>i. (i + 1, eval_rule10_team_case_new (rule10_team2_cases_new_50 ! i))) [0..<50]"
definition rule10_team3_amount_map_new :: "(nat * (reimbursement_result * int) list) list" where
  "rule10_team3_amount_map_new \<equiv> map (\<lambda>i. (i + 1, eval_rule10_team_case_new (rule10_team3_cases_new_50 ! i))) [0..<50]"
definition rule10_team4_amount_map_new :: "(nat * (reimbursement_result * int) list) list" where
  "rule10_team4_amount_map_new \<equiv> map (\<lambda>i. (i + 1, eval_rule10_team_case_new (rule10_team4_cases_new_50 ! i))) [0..<50]"
definition rule10_team5_amount_map_new :: "(nat * (reimbursement_result * int) list) list" where
  "rule10_team5_amount_map_new \<equiv> map (\<lambda>i. (i + 1, eval_rule10_team_case_new (rule10_team5_cases_new_50 ! i))) [0..<50]"

definition rule10_team2_total_amount_map_new :: "(nat * int) list" where
  "rule10_team2_total_amount_map_new \<equiv> map (\<lambda>p. (fst p, sum_amounts (snd p))) rule10_team2_amount_map_new"
definition rule10_team3_total_amount_map_new :: "(nat * int) list" where
  "rule10_team3_total_amount_map_new \<equiv> map (\<lambda>p. (fst p, sum_amounts (snd p))) rule10_team3_amount_map_new"
definition rule10_team4_total_amount_map_new :: "(nat * int) list" where
  "rule10_team4_total_amount_map_new \<equiv> map (\<lambda>p. (fst p, sum_amounts (snd p))) rule10_team4_amount_map_new"
definition rule10_team5_total_amount_map_new :: "(nat * int) list" where
  "rule10_team5_total_amount_map_new \<equiv> map (\<lambda>p. (fst p, sum_amounts (snd p))) rule10_team5_amount_map_new"

definition rule10_team2_identity_map_new :: "(nat * personnel_role list) list" where
  "rule10_team2_identity_map_new \<equiv> map (\<lambda>i. (i + 1, map training_participant_role (rule10_team2_cases_new_50 ! i))) [0..<50]"
definition rule10_team3_identity_map_new :: "(nat * personnel_role list) list" where
  "rule10_team3_identity_map_new \<equiv> map (\<lambda>i. (i + 1, map training_participant_role (rule10_team3_cases_new_50 ! i))) [0..<50]"
definition rule10_team4_identity_map_new :: "(nat * personnel_role list) list" where
  "rule10_team4_identity_map_new \<equiv> map (\<lambda>i. (i + 1, map training_participant_role (rule10_team4_cases_new_50 ! i))) [0..<50]"
definition rule10_team5_identity_map_new :: "(nat * personnel_role list) list" where
  "rule10_team5_identity_map_new \<equiv> map (\<lambda>i. (i + 1, map training_participant_role (rule10_team5_cases_new_50 ! i))) [0..<50]"

(* ===== Team amount cases for Rule13 ===== *)

definition mk_rule13_team_member_case_new :: "nat \<Rightarrow> nat \<Rightarrow> rule13_case" where
  "mk_rule13_team_member_case_new i k \<equiv>
    (let j = i + k;
         r = pick sr_role_identity_pool j;
         lane = j mod 3;
         base0 = \<lparr>
           expense_graduate_thesis_review_defense = False,
           expense_lecture_fees = True,
           expense_expert_consultation_fees = True,
           expense_doctoral_dissertation = False,
           expense_master_thesis = False,
           reviewer_count = 0,
           reviewer_fee_per_person = 0,
           defense_committee_count = 0,
           defense_committee_fee_per_person = 0,
           defense_secretary_count = 0,
           defense_secretary_fee_per_person = 0,
           lecture_fee_is_after_tax = True,
           lecture_speaker_role = r,
           lecture_fee_per_class_hour = sr_rule13_lecture_cap_safe r,
           lecture_class_hours = 4,
           lecture_half_days = 1,
           consultation_participant_role = r,
           consultation_type_in_person = True,
           consultation_type_communication = False,
           consultation_days = 2,
           consultation_fee_per_day = sr_rule13_consult_cap_safe r,
           consultation_fee_per_project = 0
         \<rparr>
     in if lane = 0 then base0
        else if lane = 1 then base0\<lparr>consultation_fee_per_day := sr_rule13_consult_cap_exceed r\<rparr>
        else base0\<lparr>lecture_fee_is_after_tax := False\<rparr>)"

definition mk_rule13_team_cases_new :: "nat \<Rightarrow> rule13_case list list" where
  "mk_rule13_team_cases_new n \<equiv> map (\<lambda>i. map (\<lambda>k. mk_rule13_team_member_case_new i k) [0..<n]) [0..<50]"

definition eval_rule13_team_case_new :: "rule13_case list \<Rightarrow> (reimbursement_result * int) list" where
  "eval_rule13_team_case_new cs \<equiv> map rule13v2_amount_decision cs"

definition rule13_team2_cases_new_50 :: "rule13_case list list" where
  "rule13_team2_cases_new_50 \<equiv> mk_rule13_team_cases_new 2"
definition rule13_team3_cases_new_50 :: "rule13_case list list" where
  "rule13_team3_cases_new_50 \<equiv> mk_rule13_team_cases_new 3"
definition rule13_team4_cases_new_50 :: "rule13_case list list" where
  "rule13_team4_cases_new_50 \<equiv> mk_rule13_team_cases_new 4"
definition rule13_team5_cases_new_50 :: "rule13_case list list" where
  "rule13_team5_cases_new_50 \<equiv> mk_rule13_team_cases_new 5"

definition rule13_team2_amount_map_new :: "(nat * (reimbursement_result * int) list) list" where
  "rule13_team2_amount_map_new \<equiv> map (\<lambda>i. (i + 1, eval_rule13_team_case_new (rule13_team2_cases_new_50 ! i))) [0..<50]"
definition rule13_team3_amount_map_new :: "(nat * (reimbursement_result * int) list) list" where
  "rule13_team3_amount_map_new \<equiv> map (\<lambda>i. (i + 1, eval_rule13_team_case_new (rule13_team3_cases_new_50 ! i))) [0..<50]"
definition rule13_team4_amount_map_new :: "(nat * (reimbursement_result * int) list) list" where
  "rule13_team4_amount_map_new \<equiv> map (\<lambda>i. (i + 1, eval_rule13_team_case_new (rule13_team4_cases_new_50 ! i))) [0..<50]"
definition rule13_team5_amount_map_new :: "(nat * (reimbursement_result * int) list) list" where
  "rule13_team5_amount_map_new \<equiv> map (\<lambda>i. (i + 1, eval_rule13_team_case_new (rule13_team5_cases_new_50 ! i))) [0..<50]"

definition rule13_team2_total_amount_map_new :: "(nat * int) list" where
  "rule13_team2_total_amount_map_new \<equiv> map (\<lambda>p. (fst p, sum_amounts (snd p))) rule13_team2_amount_map_new"
definition rule13_team3_total_amount_map_new :: "(nat * int) list" where
  "rule13_team3_total_amount_map_new \<equiv> map (\<lambda>p. (fst p, sum_amounts (snd p))) rule13_team3_amount_map_new"
definition rule13_team4_total_amount_map_new :: "(nat * int) list" where
  "rule13_team4_total_amount_map_new \<equiv> map (\<lambda>p. (fst p, sum_amounts (snd p))) rule13_team4_amount_map_new"
definition rule13_team5_total_amount_map_new :: "(nat * int) list" where
  "rule13_team5_total_amount_map_new \<equiv> map (\<lambda>p. (fst p, sum_amounts (snd p))) rule13_team5_amount_map_new"

definition rule13_team2_identity_map_new :: "(nat * personnel_role list) list" where
  "rule13_team2_identity_map_new \<equiv> map (\<lambda>i. (i + 1, map lecture_speaker_role (rule13_team2_cases_new_50 ! i))) [0..<50]"
definition rule13_team3_identity_map_new :: "(nat * personnel_role list) list" where
  "rule13_team3_identity_map_new \<equiv> map (\<lambda>i. (i + 1, map lecture_speaker_role (rule13_team3_cases_new_50 ! i))) [0..<50]"
definition rule13_team4_identity_map_new :: "(nat * personnel_role list) list" where
  "rule13_team4_identity_map_new \<equiv> map (\<lambda>i. (i + 1, map lecture_speaker_role (rule13_team4_cases_new_50 ! i))) [0..<50]"
definition rule13_team5_identity_map_new :: "(nat * personnel_role list) list" where
  "rule13_team5_identity_map_new \<equiv> map (\<lambda>i. (i + 1, map lecture_speaker_role (rule13_team5_cases_new_50 ! i))) [0..<50]"

value "rule8_team2_result_map_new"
value "rule8_team3_result_map_new"
value "rule8_team4_result_map_new"
value "rule8_team5_result_map_new"
value "rule8_team2_identity_map_new"
value "rule8_team3_identity_map_new"
value "rule8_team4_identity_map_new"
value "rule8_team5_identity_map_new"

value "rule10_team2_amount_map_new"
value "rule10_team3_amount_map_new"
value "rule10_team4_amount_map_new"
value "rule10_team5_amount_map_new"
value "rule10_team2_total_amount_map_new"
value "rule10_team3_total_amount_map_new"
value "rule10_team4_total_amount_map_new"
value "rule10_team5_total_amount_map_new"
value "rule10_team2_identity_map_new"
value "rule10_team3_identity_map_new"
value "rule10_team4_identity_map_new"
value "rule10_team5_identity_map_new"

value "rule13_team2_amount_map_new"
value "rule13_team3_amount_map_new"
value "rule13_team4_amount_map_new"
value "rule13_team5_amount_map_new"
value "rule13_team2_total_amount_map_new"
value "rule13_team3_total_amount_map_new"
value "rule13_team4_total_amount_map_new"
value "rule13_team5_total_amount_map_new"
value "rule13_team2_identity_map_new"
value "rule13_team3_identity_map_new"
value "rule13_team4_identity_map_new"
value "rule13_team5_identity_map_new"

end