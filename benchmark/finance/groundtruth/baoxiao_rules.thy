theory baoxiao_rules
  imports Main
begin

datatype reimbursement_result = 
  Full_Approval
  | Partial_Approval
  | Rejection 
  | Unknown

(* Rule 3: Required Documents for Reimbursement *)
record rule3_case =
  appointment_form_printed :: bool
  fund_ledger_entry_submitted :: bool
  appointment_form_signed_by_project_leader :: bool
  appointment_form_signed_by_handler :: bool
  project_leader_matches_system :: bool
  project_leader_authorization_letter_filed :: bool
  original_receipts_signed_by_project_leader :: bool
  original_receipts_signed_by_handler :: bool
  has_single_pen_approval_for_university_funds :: bool
  has_research_project_leader_signature :: bool
  has_department_approval_for_special_transactions :: bool
  electronic_invoice_verified_in_system :: bool
  electronic_invoice_selected_in_form :: bool
  has_travel_approval :: bool
  has_overseas_travel_approval :: bool
  has_conference_approval :: bool
  has_equipment_purchase_approval :: bool
  has_research_fund_transfer_approval :: bool
  payment_amount_ge_30000 :: bool
  has_signed_contract :: bool
  contract_stamped_with_university_seal :: bool
  has_contract_for_construction :: bool
  payment_amount_gt_50000 :: bool
  has_large_sum_payment_application :: bool
  large_sum_form_signed_by_leader :: bool
  large_sum_form_stamped :: bool

definition rule_3_appointment_form_requirements :: "rule3_case \<Rightarrow> bool" where 
  "rule_3_appointment_form_requirements c \<equiv> 
    appointment_form_printed c \<and> 
    fund_ledger_entry_submitted c \<and> 
    appointment_form_signed_by_project_leader c \<and> 
    appointment_form_signed_by_handler c"

definition rule_3_project_leader_verification :: "rule3_case \<Rightarrow> bool" where 
  "rule_3_project_leader_verification c \<equiv> 
    (appointment_form_signed_by_project_leader c \<longrightarrow> project_leader_matches_system c) \<and>
    (\<not> appointment_form_signed_by_project_leader c \<longrightarrow> 
      (project_leader_authorization_letter_filed c \<and> 
       appointment_form_signed_by_handler c))"

definition rule_3_original_receipts_signatures :: "rule3_case \<Rightarrow> bool" where 
  "rule_3_original_receipts_signatures c \<equiv> 
    original_receipts_signed_by_project_leader c \<and> 
    original_receipts_signed_by_handler c"

definition rule_3_fund_type_approval :: "rule3_case \<Rightarrow> bool" where 
  "rule_3_fund_type_approval c \<equiv> 
    (has_single_pen_approval_for_university_funds c \<or> has_research_project_leader_signature c) \<and>
    (has_department_approval_for_special_transactions c \<longrightarrow> 
      (has_travel_approval c \<or> has_overseas_travel_approval c \<or> 
       has_conference_approval c \<or> has_equipment_purchase_approval c \<or> 
       has_research_fund_transfer_approval c))"

definition rule_3_electronic_invoice_handling :: "rule3_case \<Rightarrow> bool" where 
  "rule_3_electronic_invoice_handling c \<equiv> 
    electronic_invoice_verified_in_system c \<longrightarrow> electronic_invoice_selected_in_form c"

definition rule_3_contract_requirements :: "rule3_case \<Rightarrow> bool" where 
  "rule_3_contract_requirements c \<equiv> 
    (payment_amount_ge_30000 c \<or> has_contract_for_construction c) \<longrightarrow> 
      (has_signed_contract c \<and> contract_stamped_with_university_seal c)"

definition rule_3_large_sum_payment_requirements :: "rule3_case \<Rightarrow> bool" where 
  "rule_3_large_sum_payment_requirements c \<equiv> 
    payment_amount_gt_50000 c \<longrightarrow> 
      (has_large_sum_payment_application c \<and> 
       large_sum_form_signed_by_leader c \<and> 
       large_sum_form_stamped c)"

definition rule_3_special_approval_requirements :: "rule3_case \<Rightarrow> bool" where 
  "rule_3_special_approval_requirements c \<equiv> 
    (has_travel_approval c \<or> has_overseas_travel_approval c \<or> 
     has_conference_approval c \<or> has_equipment_purchase_approval c \<or> 
     has_research_fund_transfer_approval c) \<longrightarrow> has_department_approval_for_special_transactions c"

(* Rule 3: Required Documents *)
definition rule_3_evaluate :: "rule3_case \<Rightarrow> reimbursement_result" where 
  "rule_3_evaluate c \<equiv>
    if \<not> (rule_3_appointment_form_requirements c \<and> 
          rule_3_original_receipts_signatures c)
    then Rejection
    else if \<not> (rule_3_project_leader_verification c \<and> 
               rule_3_fund_type_approval c \<and> 
               rule_3_electronic_invoice_handling c \<and> 
               rule_3_contract_requirements c \<and> 
               rule_3_large_sum_payment_requirements c \<and> 
               rule_3_special_approval_requirements c)
    then Partial_Approval
    else Full_Approval"

datatype rule3_answer = Material_Complete | Material_Incomplete


definition rule3_to_answer :: "reimbursement_result \<Rightarrow> rule3_answer" where
"rule3_to_answer r \<equiv>
  case r of
    Full_Approval \<Rightarrow> Material_Complete
  | Partial_Approval \<Rightarrow> Material_Incomplete
  | Rejection \<Rightarrow> Material_Incomplete"


record rule4_case =
  invoice_lacks_supervision_seal :: bool
  invoice_scope_mismatch :: bool
  invoice_content_incomplete :: bool
  invoice_missing_date :: bool
  invoice_missing_quantity :: bool
  invoice_missing_unit_price :: bool
  invoice_missing_amount :: bool
  invoice_missing_description :: bool
  invoice_missing_payee_seal :: bool
  invoice_amount_figures_words_inconsistent :: bool
  invoice_altered :: bool
  invoice_forged :: bool
  invoice_fraudulent :: bool
  taxi_receipts_consecutive_numbers :: bool
  taxi_receipts_large_quantity_same_taxi :: bool
  reimbursement_procedure_incomplete :: bool

definition rule_4_negative_invoice_condition :: "rule4_case \<Rightarrow> bool" where 
  "rule_4_negative_invoice_condition c \<equiv> 
    invoice_lacks_supervision_seal c \<or> 
    invoice_scope_mismatch c \<or> 
    invoice_content_incomplete c \<or> 
    invoice_missing_date c \<or> 
    invoice_missing_quantity c \<or> 
    invoice_missing_unit_price c \<or> 
    invoice_missing_amount c \<or> 
    invoice_missing_description c \<or> 
    invoice_missing_payee_seal c \<or> 
    invoice_amount_figures_words_inconsistent c \<or> 
    invoice_altered c \<or> 
    invoice_forged c \<or> 
    invoice_fraudulent c \<or> 
    taxi_receipts_consecutive_numbers c \<or> 
    taxi_receipts_large_quantity_same_taxi c \<or> 
    reimbursement_procedure_incomplete c"

definition rule_4_reimbursement_rejected :: "rule4_case \<Rightarrow> bool" where 
  "rule_4_reimbursement_rejected c \<equiv> 
    rule_4_negative_invoice_condition c"

definition rule_4_invoice_valid :: "rule4_case \<Rightarrow> bool" where 
  "rule_4_invoice_valid c \<equiv> 
    \<not> rule_4_negative_invoice_condition c"

(* Rule 4: Negative List *)
definition rule_4_evaluate :: "rule4_case \<Rightarrow> reimbursement_result" where 
  "rule_4_evaluate c \<equiv>
    if invoice_fraudulent c \<or> invoice_forged c \<or> rule_4_negative_invoice_condition c
    then Rejection
    else Full_Approval"
datatype rule4_answer = Invoice_Correct | Invoice_Error
(* Rule 4: Negative List *)
definition rule4_to_answer :: "rule4_case \<Rightarrow> rule4_answer" where 
  "rule4_to_answer c \<equiv>
    if invoice_fraudulent c \<or> invoice_forged c \<or> rule_4_negative_invoice_condition c
    then Invoice_Error
    else Invoice_Correct"

record rule6_case =
  expense_office_stationery :: bool
  expense_computer_accessories :: bool
  expense_office_furniture :: bool
  expense_books :: bool
  expense_newspapers :: bool
  expense_magazines :: bool
  expense_cleaning_supplies :: bool
  expense_drinking_water :: bool
  is_low_value_consumable :: bool
  is_asset_management_office_review_required :: bool
  has_external_purchase_inventory_review_form :: bool
  has_seller_goods_list :: bool
  has_online_shopping_transaction_record :: bool
  book_expense_has_detailed_list :: bool
  single_book_value_ge_1000 :: bool
  book_registered_with_library :: bool
  has_fixed_asset_addition_slip :: bool
  expense_printing_materials :: bool
  expense_papers :: bool
  expense_exam_papers :: bool
  expense_promotional_materials :: bool
  expense_search_fees :: bool
  expense_retrieval_fees :: bool
  expense_paper_review_fees :: bool
  expense_publication_fees :: bool
  expense_page_charges :: bool
  expense_monograph_publication_subsidy :: bool
  single_invoice_over_1000_for_printing :: bool
  multiple_invoices_around_same_time_over_1000 :: bool
  has_detailed_list_for_printing :: bool
  artificially_split_invoice_amounts :: bool
  monograph_publication_has_contract :: bool
  contract_party_is_individual_or_department :: bool
  contract_approved_by_project_fund_admin :: bool

definition rule_6_office_expenses_classification :: "rule6_case \<Rightarrow> bool" where 
  "rule_6_office_expenses_classification c \<equiv> 
    (expense_office_stationery c \<or> expense_computer_accessories c \<or> expense_office_furniture c \<or>
     expense_books c \<or> expense_newspapers c \<or> expense_magazines c \<or> expense_cleaning_supplies c \<or>
     expense_drinking_water c) \<longrightarrow> is_low_value_consumable c"

definition rule_6_asset_management_review :: "rule6_case \<Rightarrow> bool" where 
  "rule_6_asset_management_review c \<equiv> 
    is_asset_management_office_review_required c \<longrightarrow> has_external_purchase_inventory_review_form c"

definition rule_6_office_supplies_attachment :: "rule6_case \<Rightarrow> bool" where 
  "rule_6_office_supplies_attachment c \<equiv> 
    (expense_office_stationery c \<or> expense_cleaning_supplies c) \<and> 
    \<not> is_asset_management_office_review_required c \<longrightarrow> 
      (has_seller_goods_list c \<or> has_online_shopping_transaction_record c)"

definition rule_6_book_expense_requirements :: "rule6_case \<Rightarrow> bool" where 
  "rule_6_book_expense_requirements c \<equiv> 
    expense_books c \<longrightarrow> book_expense_has_detailed_list c"

definition rule_6_high_value_book_registration :: "rule6_case \<Rightarrow> bool" where 
  "rule_6_high_value_book_registration c \<equiv> 
    expense_books c \<and> single_book_value_ge_1000 c \<longrightarrow> 
      (book_registered_with_library c \<and> has_fixed_asset_addition_slip c)"

definition rule_6_printing_expenses_classification :: "rule6_case \<Rightarrow> bool" where 
  "rule_6_printing_expenses_classification c \<equiv> 
    (expense_printing_materials c \<or> expense_papers c \<or> expense_exam_papers c \<or>
     expense_promotional_materials c \<or> expense_search_fees c \<or> expense_retrieval_fees c \<or>
     expense_paper_review_fees c \<or> expense_publication_fees c \<or> expense_page_charges c \<or>
     expense_monograph_publication_subsidy c) \<longrightarrow> True"

definition rule_6_printing_detailed_list :: "rule6_case \<Rightarrow> bool" where 
  "rule_6_printing_detailed_list c \<equiv> 
    (single_invoice_over_1000_for_printing c \<or> multiple_invoices_around_same_time_over_1000 c) \<longrightarrow> 
      has_detailed_list_for_printing c"

definition rule_6_no_artificial_splitting :: "rule6_case \<Rightarrow> bool" where 
  "rule_6_no_artificial_splitting c \<equiv> 
    artificially_split_invoice_amounts c \<longrightarrow> False"

definition rule_6_monograph_contract_requirements :: "rule6_case \<Rightarrow> bool" where 
  "rule_6_monograph_contract_requirements c \<equiv> 
    expense_monograph_publication_subsidy c \<longrightarrow> monograph_publication_has_contract c"

definition rule_6_monograph_contract_approval :: "rule6_case \<Rightarrow> bool" where 
  "rule_6_monograph_contract_approval c \<equiv> 
    expense_monograph_publication_subsidy c \<and> monograph_publication_has_contract c \<and>
    contract_party_is_individual_or_department c \<longrightarrow> contract_approved_by_project_fund_admin c"

(* ===== Rule 6: only Full / Rejection ===== *)

definition rule_6_requirements :: "rule6_case \<Rightarrow> bool" where
  "rule_6_requirements c \<equiv>
    rule_6_no_artificial_splitting c \<and>
    rule_6_office_expenses_classification c \<and>
    rule_6_asset_management_review c \<and>
    rule_6_office_supplies_attachment c \<and>
    rule_6_book_expense_requirements c \<and>
    rule_6_high_value_book_registration c \<and>
    rule_6_printing_expenses_classification c \<and>
    rule_6_printing_detailed_list c \<and>
    rule_6_monograph_contract_requirements c \<and>
    rule_6_monograph_contract_approval c"

definition rule_6_evaluate :: "rule6_case \<Rightarrow> reimbursement_result" where
  "rule_6_evaluate c \<equiv>
    if rule_6_requirements c then Full_Approval else Rejection"


definition rule4_ok :: rule4_case where
"rule4_ok \<equiv> \<lparr>
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

definition rule6_base_ok :: rule6_case where
"rule6_base_ok \<equiv> \<lparr>
  expense_office_stationery = True,
  expense_computer_accessories = False,
  expense_office_furniture = False,
  expense_books = False,
  expense_newspapers = False,
  expense_magazines = False,
  expense_cleaning_supplies = False,
  expense_drinking_water = False,
  is_low_value_consumable = True,
  is_asset_management_office_review_required = False,
  has_external_purchase_inventory_review_form = False,
  has_seller_goods_list = True,
  has_online_shopping_transaction_record = False,
  book_expense_has_detailed_list = False,
  single_book_value_ge_1000 = False,
  book_registered_with_library = False,
  has_fixed_asset_addition_slip = False,
  expense_printing_materials = False,
  expense_papers = False,
  expense_exam_papers = False,
  expense_promotional_materials = False,
  expense_search_fees = False,
  expense_retrieval_fees = False,
  expense_paper_review_fees = False,
  expense_publication_fees = False,
  expense_page_charges = False,
  expense_monograph_publication_subsidy = False,
  single_invoice_over_1000_for_printing = False,
  multiple_invoices_around_same_time_over_1000 = False,
  has_detailed_list_for_printing = False,
  artificially_split_invoice_amounts = False,
  monograph_publication_has_contract = False,
  contract_party_is_individual_or_department = False,
  contract_approved_by_project_fund_admin = False
\<rparr>"

(* ===== Rule6-only 20 Approval + 20 Rejection ===== *)

definition combined_evaluate :: "rule4_case \<Rightarrow> rule6_case \<Rightarrow> reimbursement_result" where
"combined_evaluate c4 c6 \<equiv>
  (case (rule_4_evaluate c4, rule_6_evaluate c6) of
     (Full_Approval, Full_Approval) \<Rightarrow> Full_Approval
   | _ \<Rightarrow> Rejection)"

definition eval_pair :: "(rule4_case * rule6_case) \<Rightarrow> reimbursement_result" where
"eval_pair p \<equiv> combined_evaluate (fst p) (snd p)"

definition rule4_bad_1  :: rule4_case where "rule4_bad_1  \<equiv> rule4_ok\<lparr>invoice_lacks_supervision_seal := True\<rparr>"
definition rule4_bad_2  :: rule4_case where "rule4_bad_2  \<equiv> rule4_ok\<lparr>invoice_scope_mismatch := True\<rparr>"
definition rule4_bad_3  :: rule4_case where "rule4_bad_3  \<equiv> rule4_ok\<lparr>invoice_content_incomplete := True\<rparr>"
definition rule4_bad_4  :: rule4_case where "rule4_bad_4  \<equiv> rule4_ok\<lparr>invoice_missing_date := True\<rparr>"
definition rule4_bad_5  :: rule4_case where "rule4_bad_5  \<equiv> rule4_ok\<lparr>invoice_missing_quantity := True\<rparr>"
definition rule4_bad_6  :: rule4_case where "rule4_bad_6  \<equiv> rule4_ok\<lparr>invoice_missing_unit_price := True\<rparr>"
definition rule4_bad_7  :: rule4_case where "rule4_bad_7  \<equiv> rule4_ok\<lparr>invoice_missing_amount := True\<rparr>"
definition rule4_bad_8  :: rule4_case where "rule4_bad_8  \<equiv> rule4_ok\<lparr>invoice_missing_description := True\<rparr>"
definition rule4_bad_9  :: rule4_case where "rule4_bad_9  \<equiv> rule4_ok\<lparr>invoice_missing_payee_seal := True\<rparr>"
definition rule4_bad_10 :: rule4_case where "rule4_bad_10 \<equiv> rule4_ok\<lparr>invoice_amount_figures_words_inconsistent := True\<rparr>"

datatype fund_source =
    Research_Fund
  | NonResearch_Fund
  | Horizontal_Research_Fund

datatype traveler_tier =
    Tier_A
  | Tier_B 
  | Tier_C

datatype personnel_role =
    Role_Academician
  | Role_Senior_Arts_Professor
  | Role_Equivalent_Academician_Scholar
  | Role_National_Mgmt_Post_Level2_OrAbove
  | Role_Changjiang_or_National_Distinguished_Young
  | Role_Major_National_Research_Project_Leader
  | Role_National_ProfTech_Post_Level2
  | Role_Bureau_Director_Level
  | Role_Division_Chief_And_Below

datatype lodging_rank = Lodging_Ministerial | Lodging_Bureau | Lodging_Other

datatype transport_mode = Air | Train | Ship | Other_Mode
datatype ticket_class =
    Air_First | Air_Business | Air_Economy
  | Train_Business | Train_First | Train_Second | Train_SoftSleeper | Train_HardSleeper | Train_HardSeat
  | Ship_First | Ship_Second | Ship_Third
  | Other_Class

datatype region_group = Xinjiang_Qinghai_Tibet | Other_Region

datatype rule7_personnel_position =
    R7P_Academician
  | R7P_Senior_Arts_Distinguished_Professor
  | R7P_Equivalent_Academician_Scholar
  | R7P_National_Mgmt_Post_Level2_OrAbove
  | R7P_Changjiang_or_National_Distinguished_Young
  | R7P_Major_National_Research_Project_Leader
  | R7P_National_ProfTech_Post_Level2
  | R7P_Ministerial_or_Equivalent_Duty
  | R7P_DeputySenior_or_Above_ProfTech
  | R7P_DeputyDivision_or_Above_Mgmt
  | R7P_Bureau_or_Equivalent_Duty
  | R7P_PostSalaryLevel5_orAbove_ProfTech
  | R7P_Other_Personnel

record rule7_case =

  has_trip_report_form :: bool
  signed_by_unit_head_and_sealed :: bool
  unit_head_self_trip_has_other_leader_sign :: bool

  is_unit_head_self_trip :: bool

  has_intercity_transport_expense :: bool
  has_lodging_expense :: bool

  has_city_transport_expense :: bool
  has_city_transport_receipts :: bool
  city_transport_within_budget :: bool

  fund_type :: fund_source
  person_position :: rule7_personnel_position
  chosen_mode :: transport_mode
  chosen_class :: ticket_class
  has_contract_specific_transport_rule :: bool
  satisfies_contract_transport_rule :: bool
  transport_above_standard :: bool
  has_transport_special_explanation :: bool
  has_project_leader_signature_for_transport_exception :: bool


  lodging_rank_of_traveler :: lodging_rank
  lodging_nightly_amount :: int
  lodging_nights :: int
  city_key :: string
  travel_month :: int


  has_intercity_transport_invoice :: bool
  has_lodging_invoice :: bool
  transport_ticket_unobtainable_in_remote_research :: bool
  has_approved_special_explanation_for_transport_no_ticket :: bool
  has_other_valid_supporting_docs_for_transport_no_ticket :: bool
  lodging_invoice_unobtainable :: bool
  has_approved_special_explanation_for_lodging_no_invoice :: bool
  has_handwritten_receipt_signed_by_payee :: bool


  trip_days_calendar :: int
  region_type :: region_group
  meal_subsidy_claimed_total :: int
  city_transport_actual_claimed_total :: int
  city_transport_lump_sum_claimed_total :: int
  use_city_transport_lump_sum :: bool
  intercity_and_lodging_both_paid_by_external_unit :: bool
  only_one_of_intercity_or_lodging_paid_by_external_unit :: bool
  has_signed_special_explanation_for_partial_external_support :: bool
  has_valid_notice_or_invitation_for_partial_external_support :: bool
  transport_or_meal_already_paid_by_external_unit :: bool
  claimed_transport_or_meal_again_in_school :: bool

  uses_self_drive_or_rental :: bool
  has_signed_special_explanation_for_self_drive :: bool
  rental_fuel_toll_total :: int
  public_transport_lowest_standard_total :: int

  is_external_invitee :: bool
  external_invitee_transport_lodging_confirmed_by_project_leader :: bool
  external_invitee_claims_meal_subsidy :: bool
  external_invitee_claims_city_transport_lump_sum :: bool

(* ===== Rule7 lodging cap lookup ===== *)

type_synonym cap_triple = "int * int * int"
type_synonym cap_row = "string * cap_triple"
type_synonym season_row = "string * int set * cap_triple"

fun cap_by_rank :: "cap_triple \<Rightarrow> lodging_rank \<Rightarrow> int" where
  "cap_by_rank (m,b,ot) Lodging_Ministerial = m"
| "cap_by_rank (m,b,ot) Lodging_Bureau = b"
| "cap_by_rank (m,b,ot) Lodging_Other = ot"

fun lookup_regular :: "string \<Rightarrow> cap_row list \<Rightarrow> cap_triple option" where
  "lookup_regular k [] = None"
| "lookup_regular k ((k2,v)#xs) = (if k = k2 then Some v else lookup_regular k xs)"

fun lookup_season :: "string \<Rightarrow> int \<Rightarrow> season_row list \<Rightarrow> cap_triple option" where
  "lookup_season k mon [] = None"
| "lookup_season k mon ((k2,mons,v)#xs) =
    (if k = k2 \<and> mon \<in> mons then Some v else lookup_season k mon xs)"

definition regular_lodging_table :: "cap_row list" where
  "regular_lodging_table = [
    (''BJ_ALL'', (1100,650,500)),
    (''TJ_CORE'', (800,480,380)), (''TJ_NINGHE'', (600,350,320)),
    (''HEB_MAIN'', (800,450,350)), (''HEB_OTHER'', (800,450,310)),
    (''SX_TY_DT_JC'', (800,480,350)), (''SX_LF'', (800,480,330)),
    (''SX_YQ_CZ_JZ'', (800,480,310)), (''SX_OTHER'', (800,400,240)),
    (''NMG_HHHT'', (800,460,350)), (''NMG_OTHER'', (800,460,320)),
    (''LN_SY'', (800,480,350)), (''LN_OTHER'', (800,480,330)),
    (''DL_ALL'', (800,490,350)),
    (''JL_CORE'', (800,450,350)), (''JL_OTHER'', (750,400,300)),
    (''HLJ_HRB'', (800,450,350)), (''HLJ_OTHER'', (750,450,300)),
    (''SH_ALL'', (1100,600,500)),
    (''JS_CORE'', (900,490,380)), (''JS_OTHER'', (900,490,360)),
    (''ZJ_HZ'', (900,500,400)), (''ZJ_OTHER'', (800,490,340)),
    (''NB_ALL'', (800,450,350)),
    (''AH_ALL'', (800,460,350)),
    (''FJ_CORE'', (900,480,380)), (''FJ_OTHER'', (900,480,350)),
    (''XM_ALL'', (900,500,400)),
    (''JX_ALL'', (800,470,350)),
    (''SD_CORE'', (800,480,380)), (''SD_OTHER'', (800,460,360)),
    (''QD_ALL'', (800,490,380)),
    (''HEN_ZZ'', (900,480,380)), (''HEN_OTHER'', (800,480,330)),
    (''HUB_WH'', (800,480,350)), (''HUB_OTHER'', (800,480,320)),
    (''HUN_CS'', (800,450,350)), (''HUN_OTHER'', (800,450,330)),
    (''GD_CORE'', (900,550,450)), (''GD_OTHER'', (850,530,420)),
    (''SZ_ALL'', (900,550,450)),
    (''GX_NN'', (800,470,350)), (''GX_OTHER'', (800,470,330)),
    (''HN_CORE'', (800,500,350)), (''HN_SY'', (1000,600,400)),
    (''CQ_CORE'', (800,480,370)), (''CQ_OTHER'', (770,450,300)),
    (''SC_CD'', (900,470,370)), (''SC_AB_GZ'', (800,430,330)),
    (''SC_MY_LS_YA'', (800,430,320)), (''SC_YB'', (800,430,300)),
    (''SC_LS'', (750,430,330)), (''SC_DY_SN_BZ'', (750,430,310)),
    (''SC_OTHER'', (750,430,300)),
    (''GZ_GY'', (800,470,370)), (''GZ_OTHER'', (750,450,300)),
    (''YN_CORE'', (900,480,380)), (''YN_OTHER'', (900,480,330)),
    (''XZ_LS'', (800,500,350)), (''XZ_OTHER'', (500,400,300)),
    (''SN_XA'', (800,460,350)), (''SN_YL_YA'', (680,350,300)),
    (''SN_YLQ'', (680,320,260)), (''SN_XY_BJ'', (600,320,260)),
    (''SN_WN_HC'', (600,300,260)), (''SN_OTHER'', (600,300,230)),
    (''GS_LZ'', (800,470,350)), (''GS_OTHER'', (700,450,310)),
    (''QH_XN'', (800,500,350)), (''QH_YS_GL'', (600,350,300)),
    (''QH_HB_HN'', (600,350,250)), (''QH_HD_HNZ'', (600,300,250)),
    (''QH_HX'', (600,300,200)),
    (''NX_YC'', (800,470,350)), (''NX_OTHER'', (800,430,330)),
    (''XJ_WLMQ'', (800,480,350)), (''XJ_MAIN'', (800,480,340)),
    (''XJ_KZ'', (800,480,320)), (''XJ_KS'', (780,480,300)),
    (''XJ_AKS'', (700,450,300)), (''XJ_TC'', (700,400,300))
  ]"

definition season_lodging_table :: "season_row list" where
  "season_lodging_table = [
    (''HEB_ZJK'', {1,2,3,7,8,9,11,12}, (1200,675,525)),
    (''HEB_QHD'', {7,8}, (1200,680,500)),
    (''HEB_CD'', {7,8,9}, (1000,580,580)),
    (''NMG_HLBE_MZL_AS'', {7,8,9}, (1200,690,480)),
    (''NMG_ELHT'', {7,8,9}, (1000,580,400)),
    (''NMG_EJNQ'', {9,10}, (1200,690,480)),
    (''DL_ALL'', {7,8,9}, (960,590,420)),
    (''JL_CORE'', {7,8,9}, (960,540,420)),
    (''HLJ_HRB'', {7,8,9}, (960,540,420)),
    (''HLJ_MDJ_YC_DXAL_HH_JMS'', {6,7,8}, (900,540,360)),
    (''SD_YT_WH_RZ'', {7,8,9}, (960,570,450)),
    (''QD_ALL'', {7,8,9}, (960,590,450)),
    (''HEN_LY'', {4,5}, (1200,720,500)),
    (''GX_GL_BH'', {1,2,7,8,9}, (1040,610,430)),
    (''HN_HK_WC_CM'', {1,2,11,12}, (1040,650,450)),
    (''HN_QH'', {1,2,3,11,12}, (1040,650,450)),
    (''HN_SY'', {1,2,3,4,10,11,12}, (1200,720,480)),
    (''XZ_LS'', {6,7,8,9}, (1200,750,530)),
    (''XZ_OTHER'', {6,7,8,9}, (800,500,350)),
    (''QH_XN'', {6,7,8,9}, (1200,750,530)),
    (''QH_YS_GL'', {5,6,7,8,9}, (900,525,450)),
    (''QH_HB_HN'', {5,6,7,8,9}, (900,525,375)),
    (''QH_HD_HNZ'', {5,6,7,8,9}, (900,450,375)),
    (''QH_HX'', {5,6,7,8,9}, (900,450,300))
  ]"


definition allowed_ticket :: "fund_source \<Rightarrow> traveler_tier \<Rightarrow> transport_mode \<Rightarrow> ticket_class set" where
  "allowed_ticket f t m \<equiv>
    (case (t, m) of
       (Tier_A, Air)   \<Rightarrow> {Air_First, Air_Business}
     | (Tier_A, Train) \<Rightarrow> {Train_SoftSleeper, Train_First, Train_Business}
     | (Tier_A, Ship)  \<Rightarrow> {Ship_First}
     | (Tier_A, Other_Mode) \<Rightarrow> {Other_Class}

     | (Tier_B, Air)   \<Rightarrow> {Air_Economy}
     | (Tier_B, Train) \<Rightarrow> {Train_SoftSleeper, Train_First}
     | (Tier_B, Ship)  \<Rightarrow> {Ship_Second}
     | (Tier_B, Other_Mode) \<Rightarrow> {Other_Class}

     | (Tier_C, Air)   \<Rightarrow> {Air_Economy}
     | (Tier_C, Train) \<Rightarrow> {Train_HardSeat, Train_HardSleeper, Train_Second}
     | (Tier_C, Ship)  \<Rightarrow> {Ship_Third}
     | (Tier_C, Other_Mode) \<Rightarrow> {Other_Class})"

definition role_to_tier :: "personnel_role \<Rightarrow> traveler_tier" where
  "role_to_tier r \<equiv>
    (case r of
       Role_Academician \<Rightarrow> Tier_A
     | Role_Senior_Arts_Professor \<Rightarrow> Tier_A
     | Role_Equivalent_Academician_Scholar \<Rightarrow> Tier_A
     | Role_National_Mgmt_Post_Level2_OrAbove \<Rightarrow> Tier_A
     | Role_Changjiang_or_National_Distinguished_Young \<Rightarrow> Tier_A
     | Role_Major_National_Research_Project_Leader \<Rightarrow> Tier_A
     | Role_National_ProfTech_Post_Level2 \<Rightarrow> Tier_A
     | Role_Bureau_Director_Level \<Rightarrow> Tier_B
     | Role_Division_Chief_And_Below \<Rightarrow> Tier_C)"

definition rule7_position_to_tier :: "fund_source \<Rightarrow> rule7_personnel_position \<Rightarrow> traveler_tier" where
  "rule7_position_to_tier f p \<equiv>
    (case f of
       Research_Fund \<Rightarrow>
         (if p = R7P_Academician \<or>
             p = R7P_Senior_Arts_Distinguished_Professor \<or>
             p = R7P_Equivalent_Academician_Scholar \<or>
             p = R7P_National_Mgmt_Post_Level2_OrAbove \<or>
             p = R7P_Changjiang_or_National_Distinguished_Young \<or>
             p = R7P_Major_National_Research_Project_Leader \<or>
             p = R7P_National_ProfTech_Post_Level2
          then Tier_A
          else if p = R7P_DeputySenior_or_Above_ProfTech \<or>
                  p = R7P_DeputyDivision_or_Above_Mgmt \<or>
                  p = R7P_Bureau_or_Equivalent_Duty
               then Tier_B
               else Tier_C)
     | Horizontal_Research_Fund \<Rightarrow>
         (if p = R7P_Academician \<or>
             p = R7P_Senior_Arts_Distinguished_Professor \<or>
             p = R7P_Equivalent_Academician_Scholar \<or>
             p = R7P_National_Mgmt_Post_Level2_OrAbove \<or>
             p = R7P_Changjiang_or_National_Distinguished_Young \<or>
             p = R7P_Major_National_Research_Project_Leader \<or>
             p = R7P_National_ProfTech_Post_Level2
          then Tier_A
          else if p = R7P_DeputySenior_or_Above_ProfTech \<or>
                  p = R7P_DeputyDivision_or_Above_Mgmt \<or>
                  p = R7P_Bureau_or_Equivalent_Duty
               then Tier_B
               else Tier_C)
     | NonResearch_Fund \<Rightarrow>
         (if p = R7P_Ministerial_or_Equivalent_Duty \<or>
             p = R7P_Academician \<or>
             p = R7P_Senior_Arts_Distinguished_Professor
          then Tier_A
          else if p = R7P_Bureau_or_Equivalent_Duty \<or>
                  p = R7P_PostSalaryLevel5_orAbove_ProfTech \<or>
                  p = R7P_DeputySenior_or_Above_ProfTech \<or>
                  p = R7P_DeputyDivision_or_Above_Mgmt
               then Tier_B
               else Tier_C))"

definition meal_cap_per_day :: "region_group \<Rightarrow> int" where
  "meal_cap_per_day r \<equiv> (case r of Xinjiang_Qinghai_Tibet \<Rightarrow> 120 | Other_Region \<Rightarrow> 100)"


definition rule7_1_basic_docs_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7_1_basic_docs_ok c \<equiv>
    has_trip_report_form c \<and>
    signed_by_unit_head_and_sealed c \<and>
    (is_unit_head_self_trip c \<longrightarrow> unit_head_self_trip_has_other_leader_sign c)"


definition rule7_2_transport_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7_2_transport_ok c \<equiv>
    (if has_contract_specific_transport_rule c then
       satisfies_contract_transport_rule c
     else
       ((chosen_class c \<in> allowed_ticket (fund_type c) (rule7_position_to_tier (fund_type c) (person_position c)) (chosen_mode c)) \<or>
        (transport_above_standard c \<and>
         has_transport_special_explanation c \<and>
         has_project_leader_signature_for_transport_exception c)))"

definition lodging_cap_lookup :: "string \<Rightarrow> int \<Rightarrow> lodging_rank \<Rightarrow> int option" where
  "lodging_cap_lookup k mon rk \<equiv>
    (case lookup_season k mon season_lodging_table of
       Some cap \<Rightarrow> Some (cap_by_rank cap rk)
     | None \<Rightarrow> (case lookup_regular k regular_lodging_table of
                 Some cap2 \<Rightarrow> Some (cap_by_rank cap2 rk)
               | None \<Rightarrow> None))"

definition rule7_3_lodging_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7_3_lodging_ok c \<equiv>
    (case lodging_cap_lookup (city_key c) (travel_month c) (lodging_rank_of_traveler c) of
       Some cap \<Rightarrow> lodging_nightly_amount c \<le> cap
     | None \<Rightarrow> False)"

definition rule7_4_invoice_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7_4_invoice_ok c \<equiv>
    (has_intercity_transport_expense c \<longrightarrow>
      ((has_intercity_transport_invoice c) \<or>
       (transport_ticket_unobtainable_in_remote_research c \<and>
        has_approved_special_explanation_for_transport_no_ticket c \<and>
        has_other_valid_supporting_docs_for_transport_no_ticket c))) \<and>
    (has_lodging_expense c \<longrightarrow>
      ((has_lodging_invoice c) \<or>
       (lodging_invoice_unobtainable c \<and>
        has_approved_special_explanation_for_lodging_no_invoice c \<and>
        has_handwritten_receipt_signed_by_payee c)))"

definition rule7_6_subsidy_eligibility_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7_6_subsidy_eligibility_ok c \<equiv>
    (intercity_and_lodging_both_paid_by_external_unit c \<longrightarrow>
      meal_subsidy_claimed_total c = 0 \<and>
      city_transport_actual_claimed_total c = 0 \<and>
      city_transport_lump_sum_claimed_total c = 0) \<and>
    (only_one_of_intercity_or_lodging_paid_by_external_unit c \<longrightarrow>
      has_signed_special_explanation_for_partial_external_support c \<and>
      has_valid_notice_or_invitation_for_partial_external_support c)"

definition rule7_7_self_drive_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7_7_self_drive_ok c \<equiv>
    (uses_self_drive_or_rental c \<longrightarrow>
      has_signed_special_explanation_for_self_drive c \<and>
      rental_fuel_toll_total c \<le> public_transport_lowest_standard_total c)"

definition rule7_8_meal_amount_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7_8_meal_amount_ok c \<equiv>
    meal_subsidy_claimed_total c \<le> trip_days_calendar c * meal_cap_per_day (region_type c)"


definition rule7_9_city_transport_amount_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7_9_city_transport_amount_ok c \<equiv>
    (use_city_transport_lump_sum c \<longrightarrow>
      city_transport_lump_sum_claimed_total c \<le> trip_days_calendar c * 80) \<and>
    (\<not> use_city_transport_lump_sum c \<and> has_city_transport_expense c \<longrightarrow>
      has_city_transport_receipts c \<and> city_transport_within_budget c)"


definition rule7_10_no_duplicate_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7_10_no_duplicate_ok c \<equiv>
    \<not> (transport_or_meal_already_paid_by_external_unit c \<and> claimed_transport_or_meal_again_in_school c) \<and>
    (uses_self_drive_or_rental c \<longrightarrow>
      city_transport_lump_sum_claimed_total c = 0 \<and>
      city_transport_actual_claimed_total c = 0)"

definition rule7_11_external_invitee_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7_11_external_invitee_ok c \<equiv>
    (is_external_invitee c \<longrightarrow>
      external_invitee_transport_lodging_confirmed_by_project_leader c \<and>
      \<not> external_invitee_claims_meal_subsidy c \<and>
      \<not> external_invitee_claims_city_transport_lump_sum c)"

definition rule7_hard_constraints_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7_hard_constraints_ok c \<equiv>
    rule7_1_basic_docs_ok c \<and>
    rule7_4_invoice_ok c \<and>
    rule7_6_subsidy_eligibility_ok c \<and>
    rule7_7_self_drive_ok c \<and>
    rule7_10_no_duplicate_ok c \<and>
    rule7_11_external_invitee_ok c"

definition rule7_standard_constraints_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7_standard_constraints_ok c \<equiv>
    rule7_2_transport_ok c \<and>
    rule7_3_lodging_ok c \<and>
    rule7_8_meal_amount_ok c \<and>
    rule7_9_city_transport_amount_ok c"


definition rule_7_evaluate :: "rule7_case \<Rightarrow> reimbursement_result" where
  "rule_7_evaluate c \<equiv>
    if \<not> rule7_hard_constraints_ok c then Rejection
    else if \<not> rule7_standard_constraints_ok c then Partial_Approval
    else Full_Approval"


record rule7v2_amount_case =
  base7v2 :: rule7_case
  claimed_intercity_total_v2 :: int
  claimed_lodging_total_v2 :: int

definition rule7v2_intercity_doc_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7v2_intercity_doc_ok c \<equiv>
    has_intercity_transport_invoice c \<or>
    (transport_ticket_unobtainable_in_remote_research c \<and>
     has_approved_special_explanation_for_transport_no_ticket c \<and>
     has_other_valid_supporting_docs_for_transport_no_ticket c)"

definition rule7v2_lodging_doc_ok :: "rule7_case \<Rightarrow> bool" where
  "rule7v2_lodging_doc_ok c \<equiv>
    has_lodging_invoice c \<or>
    (lodging_invoice_unobtainable c \<and>
     has_approved_special_explanation_for_lodging_no_invoice c \<and>
     has_handwritten_receipt_signed_by_payee c)"

definition rule7v2_lodging_cap_total :: "rule7_case \<Rightarrow> int" where
  "rule7v2_lodging_cap_total c \<equiv>
    (case lodging_cap_lookup (city_key c) (travel_month c) (lodging_rank_of_traveler c) of
       Some cap \<Rightarrow> cap * lodging_nights c
     | None \<Rightarrow> 0)"

definition rule7v2_reimbursable_amount :: "rule7v2_amount_case \<Rightarrow> int" where
  "rule7v2_reimbursable_amount ac \<equiv>
    (let c = base7v2 ac in
     if rule_7_evaluate c = Rejection then 0 else
       (let
          intercity_amt =
            (if has_intercity_transport_expense c \<and> rule7v2_intercity_doc_ok c \<and> rule7_2_transport_ok c
             then max 0 (claimed_intercity_total_v2 ac) else 0);

          lodging_amt =
            (if has_lodging_expense c \<and> rule7v2_lodging_doc_ok c
             then min (max 0 (claimed_lodging_total_v2 ac)) (max 0 (rule7v2_lodging_cap_total c))
             else 0);

          meal_cap = trip_days_calendar c * meal_cap_per_day (region_type c);
          meal_amt =
            (if intercity_and_lodging_both_paid_by_external_unit c \<or> is_external_invitee c then 0
             else min (max 0 (meal_subsidy_claimed_total c)) (max 0 meal_cap));

          city_amt =
            (if uses_self_drive_or_rental c then 0
             else if use_city_transport_lump_sum c then
                    min (max 0 (city_transport_lump_sum_claimed_total c))
                        (max 0 (trip_days_calendar c * 80))
                  else if has_city_transport_expense c \<and> has_city_transport_receipts c \<and> city_transport_within_budget c
                       then max 0 (city_transport_actual_claimed_total c)
                       else 0);

          self_drive_amt =
            (if uses_self_drive_or_rental c \<and> has_signed_special_explanation_for_self_drive c
             then min (max 0 (rental_fuel_toll_total c)) (max 0 (public_transport_lowest_standard_total c))
             else 0)
        in intercity_amt + lodging_amt + meal_amt + city_amt + self_drive_amt))"

definition rule7v2_amount_decision :: "rule7v2_amount_case \<Rightarrow> reimbursement_result * int" where
  "rule7v2_amount_decision ac \<equiv> (rule_7_evaluate (base7v2 ac), rule7v2_reimbursable_amount ac)"

definition mk_rule7v2_case :: "rule7_case \<Rightarrow> int \<Rightarrow> int \<Rightarrow> rule7v2_amount_case" where
  "mk_rule7v2_case c i l \<equiv> \<lparr>base7v2 = c, claimed_intercity_total_v2 = i, claimed_lodging_total_v2 = l\<rparr>"


(* ===== 20 Full ===== *)
record rule8_case =
  (* Rule 8.1: *)
  has_foreign_affairs_office_approval :: bool
  has_overseas_expense_statement :: bool
  expense_statement_includes_registration_fees :: bool
  expense_statement_includes_living_allowance :: bool
  expense_statement_includes_incidental_expenses :: bool
  expense_statement_includes_transportation :: bool

  (* Rule 8.2: *)
  airfare_expense_with_boarding_pass :: bool
  accommodation_expense_with_receipts :: bool
  conference_registration_fees_with_receipts :: bool
  inter_city_transportation_with_receipts :: bool
  visa_fees_with_receipts :: bool
  insurance_fees_with_receipts :: bool
  reviewed_by_foreign_affairs_travel_center :: bool
  signed_by_foreign_affairs_travel_center :: bool
  is_research_project_fund :: bool
  is_non_research_project_fund :: bool

  (* Rule 8.3: *)
  overseas_traveler_role :: personnel_role

  (* Rule 8.3: *)
  travel_by_first_class_air :: bool
  travel_by_business_class_air :: bool
  travel_by_economy_class_air :: bool
  travel_by_high_grade_soft_sleeper_rail :: bool
  travel_by_soft_sleeper_rail :: bool 
  travel_by_hard_seat_rail :: bool
  travel_by_business_class_hsr :: bool
  travel_by_first_class_hsr :: bool
  travel_by_second_class_hsr :: bool
  travel_by_first_class_ship :: bool  
  travel_by_second_class_ship :: bool
  travel_by_third_class_ship :: bool

  (* Rule 8.4: *)
  international_airfare_paid_by_business_card :: bool
  international_airfare_paid_by_bank_transfer :: bool
  accommodation_paid_by_business_card :: bool
  accommodation_paid_by_bank_transfer :: bool
  expenses_prepaid_for_future_travel :: bool 
  reimbursement_completed_after_return :: bool 
  travel_advance_for_airfare_arranged :: bool
  travel_advance_for_accommodation_arranged :: bool 
  trip_duration_over_one_month :: bool 
  has_special_circumstances_for_advance :: bool

  (* Rule 8.5: *)
  all_overseas_expenses_reimbursed_together :: bool
  books_purchased_overseas :: bool
  materials_purchased_overseas :: bool
  books_reimbursed_with_overseas_expenses :: bool
  materials_reimbursed_with_overseas_expenses :: bool
  foreign_website_purchase_without_formal_receipts :: bool
  printed_purchase_records_provided :: bool
  authenticity_statement_attached :: bool
  exclusivity_statement_attached :: bool

  (* Rule 8.6: *)
  foreign_currency_selected_in_appointment :: bool
  foreign_currency_converted_by_system :: bool
  foreign_currency_converted_manually :: bool 
  exchange_rate_proof_attached :: bool 
  multiple_currencies_cannot_be_scheduled :: bool

(* Rule 8.1 *)
definition rule8_1 :: "rule8_case \<Rightarrow> bool" where 
"rule8_1 r \<equiv>
  has_foreign_affairs_office_approval r \<and>
  has_overseas_expense_statement r \<and>
  expense_statement_includes_registration_fees r \<and>
  expense_statement_includes_living_allowance r \<and>
  expense_statement_includes_incidental_expenses r \<and>
  expense_statement_includes_transportation r"

(* Rule 8.2:  *)
definition rule8_2 :: "rule8_case \<Rightarrow> bool" where 
"rule8_2 r \<equiv>
  ((airfare_expense_with_boarding_pass r \<or>
    accommodation_expense_with_receipts r \<or>
    conference_registration_fees_with_receipts r \<or>
    inter_city_transportation_with_receipts r \<or>
    visa_fees_with_receipts r \<or>
    insurance_fees_with_receipts r) \<longrightarrow>
   (reviewed_by_foreign_affairs_travel_center r \<and>
    signed_by_foreign_affairs_travel_center r))"

(* Rule 8.3 *)
definition rule8_3 :: "rule8_case \<Rightarrow> bool" where 
"rule8_3 r \<equiv>
  (is_research_project_fund r \<longrightarrow> True) \<and>
  (is_non_research_project_fund r \<longrightarrow>
    (let t = role_to_tier (overseas_traveler_role r) in
      if t = Tier_A then True
      else if t = Tier_B then
        (\<not> travel_by_first_class_air r) \<and>
        (\<not> travel_by_high_grade_soft_sleeper_rail r) \<and>
        (\<not> travel_by_business_class_hsr r) \<and>
        (\<not> travel_by_first_class_ship r)
      else
        (travel_by_economy_class_air r) \<and>
        (travel_by_hard_seat_rail r \<or> travel_by_second_class_hsr r) \<and>
        (travel_by_third_class_ship r)))"

(* Rule 8.4 *)
definition rule8_4 :: "rule8_case \<Rightarrow> bool" where 
"rule8_4 r \<equiv>
  ((international_airfare_paid_by_business_card r \<or> international_airfare_paid_by_bank_transfer r) \<and>
   (accommodation_paid_by_business_card r \<or> accommodation_paid_by_bank_transfer r)) \<and>
  (expenses_prepaid_for_future_travel r \<longrightarrow> \<not> reimbursement_completed_after_return r) \<and>
  (reimbursement_completed_after_return r \<longrightarrow> \<not> expenses_prepaid_for_future_travel r) \<and>
  ((travel_advance_for_airfare_arranged r \<or> travel_advance_for_accommodation_arranged r) \<longrightarrow>
   (trip_duration_over_one_month r \<or> has_special_circumstances_for_advance r))"

(* Rule 8.5 *)
definition rule8_5 :: "rule8_case \<Rightarrow> bool" where 
"rule8_5 r \<equiv>
  all_overseas_expenses_reimbursed_together r \<and>
  ((books_purchased_overseas r \<or> materials_purchased_overseas r) \<longrightarrow>
   (books_reimbursed_with_overseas_expenses r \<and> materials_reimbursed_with_overseas_expenses r)) \<and>
  (foreign_website_purchase_without_formal_receipts r \<longrightarrow>
   (printed_purchase_records_provided r \<and>
    authenticity_statement_attached r \<and>
    exclusivity_statement_attached r))"

(* Rule 8.6 *)
definition rule8_6 :: "rule8_case \<Rightarrow> bool" where 
"rule8_6 r \<equiv>
  (foreign_currency_selected_in_appointment r \<longrightarrow>
   (foreign_currency_converted_by_system r \<or>
    (multiple_currencies_cannot_be_scheduled r \<and>
     foreign_currency_converted_manually r \<and>
     exchange_rate_proof_attached r)))"

(* Rule 8: Overseas Travel *)
definition rule_8_evaluate :: "rule8_case \<Rightarrow> reimbursement_result" where 
  "rule_8_evaluate c \<equiv>
    if \<not> (rule8_1 c \<and> rule8_2 c \<and> rule8_4 c \<and> rule8_5 c \<and> rule8_6 c)
    then Rejection
    else if \<not> (rule8_3 c)
    then Partial_Approval
    else Full_Approval"


datatype rule9_fund_type = R9_Research | R9_NonResearch
datatype rule9_conf_scope = R9_Domestic_Business | R9_Domestic_Management | R9_International_In_China
datatype rule9_domestic_class = R9_Class1 | R9_Class2 | R9_Class34
datatype rule9_intl_class = R9_Intl1 | R9_Intl2 | R9_Intl3

type_synonym quota4 = "int * int * int * int"

record rule9_case =
  fund_type :: rule9_fund_type
  conf_scope :: rule9_conf_scope
  domestic_class :: rule9_domestic_class
  intl_class :: rule9_intl_class 


  attendee_count :: int
  conference_days :: int
  has_lodging_arranged :: bool
  has_meal_arranged :: bool

  actual_lodging_ppd :: int
  actual_meal_ppd :: int
  actual_other_ppd :: int
  actual_total_ppd :: int


  excluded_items_within_budget :: bool

  has_notice_and_agenda :: bool
  has_budget_form :: bool
  has_expense_detail_list :: bool
  has_signin_sheet_with_org :: bool
  has_service_invoices :: bool
  has_original_supporting_docs :: bool
  has_e_settlement_docs :: bool
  has_contract_or_agreement :: bool

  reimbursed_in_single_batch :: bool
  split_reimbursement_needed_by_channel :: bool
  each_channel_reimbursed_once :: bool
  previous_channel_details_listed :: bool

  is_regular_work_meeting_or_seminar :: bool
  has_work_meal :: bool
  has_work_meal_attendee_list_and_detail :: bool
  work_meal_standard_pp :: int


  has_advance_payment :: bool
  advance_ratio_percent :: int
  advance_has_notice_and_agenda :: bool
  advance_has_budget_form :: bool
  advance_has_related_contract :: bool
  advance_has_intl_approval_if_intl :: bool


  has_foreign_guests_in_domestic_conf :: bool
  approved_by_foreign_affairs_office :: bool


  duration_days :: int

  in_shanghai_attendee_ratio_percent :: int
  held_outside_shanghai :: bool
  held_in_prohibited_scenic_area :: bool


  venue_rent_ppd :: int
  equipment_rent_ppd :: int
  cold_meal_pp_once :: int
  staff_count :: int
  resident_staff_count :: int
  staff_board_ppd :: int
  volunteer_subsidy_ppd :: int
  interpretation_labor_ppd :: int
  interpretation_is_un_language :: bool
  written_translation_per_thousand :: int
  sim_interpret_and_office_rent_ppd :: int
  bus_cost_per_vehicle_day :: int
  bus_seats :: int
  other_service_ppd :: int

definition r9_quota_research :: "rule9_conf_scope => quota4" where
  "r9_quota_research s \<equiv>
    (case s of
      R9_Domestic_Business => (500,150,100,750)
    | R9_Domestic_Management => (340,130,80,550)
    | R9_International_In_China => (700,200,300,1200))"

definition r9_quota_nonresearch_domestic :: "rule9_domestic_class => quota4" where
  "r9_quota_nonresearch_domestic c \<equiv>
    (case c of
      R9_Class1 => (500,150,110,760)
    | R9_Class2 => (400,150,100,650)
    | R9_Class34 => (340,130,80,550))"

definition r9_effective_total_cap_ppd :: "rule9_case \<Rightarrow> int" where
  "r9_effective_total_cap_ppd c \<equiv>
    (let q :: quota4 =
       (if fund_type c = R9_Research
        then r9_quota_research (conf_scope c)
        else if conf_scope c = R9_International_In_China
             then (0,0,0,0)
             else r9_quota_nonresearch_domestic (domestic_class c));
       lod :: int = fst q;
       meal :: int = fst (snd q);
       oth :: int = fst (snd (snd q));
       tot :: int = snd (snd (snd q))
     in if conf_scope c = R9_International_In_China \<and> fund_type c = R9_NonResearch
        then 0
        else tot
             - (if has_lodging_arranged c then 0 else lod)
             - (if has_meal_arranged c then 0 else meal))"

definition r9_1_quota_ok :: "rule9_case => bool" where
  "r9_1_quota_ok c \<equiv>
    actual_total_ppd c = actual_lodging_ppd c + actual_meal_ppd c + actual_other_ppd c \<and>
    (if conf_scope c = R9_International_In_China \<and> fund_type c = R9_NonResearch
     then True
     else actual_total_ppd c <= r9_effective_total_cap_ppd c) \<and>
    excluded_items_within_budget c"

definition r9_2_docs_ok :: "rule9_case => bool" where
  "r9_2_docs_ok c \<equiv>
    has_notice_and_agenda c \<and>
    has_budget_form c \<and>
    has_expense_detail_list c \<and>
    has_signin_sheet_with_org c \<and>
    has_service_invoices c \<and>
    has_original_supporting_docs c \<and>
    has_e_settlement_docs c \<and>
    has_contract_or_agreement c"

definition r9_3_batch_ok :: "rule9_case => bool" where
  "r9_3_batch_ok c \<equiv>
    (reimbursed_in_single_batch c \<or>
     (split_reimbursement_needed_by_channel c \<and>
      each_channel_reimbursed_once c \<and>
      previous_channel_details_listed c))"

definition r9_4_regular_meal_ok :: "rule9_case => bool" where
  "r9_4_regular_meal_ok c \<equiv>
    (is_regular_work_meeting_or_seminar c \<and> has_work_meal c) \<longrightarrow>
      has_work_meal_attendee_list_and_detail c \<and>
      work_meal_standard_pp c <= 50"

definition r9_5_advance_ok :: "rule9_case => bool" where
  "r9_5_advance_ok c \<equiv>
    has_advance_payment c \<longrightarrow>
      advance_ratio_percent c >= 20 \<and> advance_ratio_percent c <= 30 \<and>
      advance_has_notice_and_agenda c \<and>
      advance_has_budget_form c \<and>
      advance_has_related_contract c \<and>
      (conf_scope c = R9_International_In_China \<longrightarrow> advance_has_intl_approval_if_intl c)"

definition r9_6_foreign_guest_ok :: "rule9_case => bool" where
  "r9_6_foreign_guest_ok c \<equiv>
    (has_foreign_guests_in_domestic_conf c \<and> conf_scope c \<noteq> R9_International_In_China)
      \<longrightarrow> approved_by_foreign_affairs_office c"

definition r9_7_duration_ok :: "rule9_case => bool" where
  "r9_7_duration_ok c \<equiv>
    (conf_scope c = R9_Domestic_Business \<longrightarrow> conference_days c <= 2) \<and>
    (conf_scope c = R9_International_In_China \<longrightarrow> conference_days c <= 2) \<and>
    (conf_scope c = R9_Domestic_Management \<longrightarrow> conference_days c <= 1)"


definition r9_8_location_ok :: "rule9_case => bool" where
  "r9_8_location_ok c \<equiv>
    \<not> held_in_prohibited_scenic_area c \<and>
    ((in_shanghai_attendee_ratio_percent c > 50) \<longrightarrow> \<not> held_outside_shanghai c)"

definition r9_intl_nonresearch_item_caps_ok :: "rule9_case => bool" where
  "r9_intl_nonresearch_item_caps_ok c \<equiv>
    if conf_scope c = R9_International_In_China \<and> fund_type c = R9_NonResearch then
      ((intl_class c = R9_Intl1 \<longrightarrow> venue_rent_ppd c <= 300) \<and>
       (intl_class c = R9_Intl2 \<longrightarrow> venue_rent_ppd c <= 200) \<and>
       (intl_class c = R9_Intl3 \<longrightarrow> venue_rent_ppd c <= 150) \<and>
       equipment_rent_ppd c <= 100 \<and>
       ((intl_class c = R9_Intl1 \<or> intl_class c = R9_Intl2) \<longrightarrow> cold_meal_pp_once c <= 220) \<and>
       (intl_class c = R9_Intl3 \<longrightarrow> cold_meal_pp_once c <= 180) \<and>
       staff_count c * 10 <= attendee_count c \<and>
       resident_staff_count c * 2 <= staff_count c \<and>
       staff_board_ppd c <= 450 \<and>
       volunteer_subsidy_ppd c <= 100 \<and>
       (interpretation_is_un_language c \<longrightarrow> interpretation_labor_ppd c <= 5000) \<and>
       (\<not> interpretation_is_un_language c \<longrightarrow> interpretation_labor_ppd c <= 6000) \<and>
       written_translation_per_thousand c <= 200 \<and>
       sim_interpret_and_office_rent_ppd c <= 100 \<and>
       ((bus_seats c > 25) \<longrightarrow> bus_cost_per_vehicle_day c <= 1500) \<and>
       ((bus_seats c > 5 \<and> bus_seats c <= 25) \<longrightarrow> bus_cost_per_vehicle_day c <= 1000) \<and>
       ((bus_seats c <= 5) \<longrightarrow> bus_cost_per_vehicle_day c <= 800) \<and>
       other_service_ppd c <= 100)
    else True"

definition r9_0_basic_numbers_ok :: "rule9_case => bool" where
  "r9_0_basic_numbers_ok c \<equiv>
    attendee_count c > 0 \<and>
    conference_days c > 0 \<and>
    duration_days c = conference_days c \<and>
    actual_lodging_ppd c >= 0 \<and>
    actual_meal_ppd c >= 0 \<and>
    actual_other_ppd c >= 0 \<and>
    actual_total_ppd c >= 0"
definition rule9_hard_constraints_ok :: "rule9_case => bool" where
  "rule9_hard_constraints_ok c \<equiv>
    r9_0_basic_numbers_ok c \<and>
    r9_2_docs_ok c \<and>
    r9_3_batch_ok c \<and>
    r9_4_regular_meal_ok c \<and>
    r9_5_advance_ok c \<and>
    r9_6_foreign_guest_ok c \<and>
    r9_7_duration_ok c \<and>
    r9_8_location_ok c"

definition rule9_standard_constraints_ok :: "rule9_case => bool" where
  "rule9_standard_constraints_ok c \<equiv>
    r9_1_quota_ok c \<and>
    r9_intl_nonresearch_item_caps_ok c"

definition rule9_research_fund_scope :: "rule9_case => bool" where
  "rule9_research_fund_scope c \<equiv> fund_type c = R9_Research"

definition rule9_nonresearch_fund_scope :: "rule9_case => bool" where
  "rule9_nonresearch_fund_scope c \<equiv> fund_type c = R9_NonResearch"

definition rule9_research_standard_constraints_ok :: "rule9_case => bool" where
  "rule9_research_standard_constraints_ok c \<equiv>
    r9_1_quota_ok c"

definition rule9_nonresearch_standard_constraints_ok :: "rule9_case => bool" where
  "rule9_nonresearch_standard_constraints_ok c \<equiv>
    r9_1_quota_ok c \<and>
    r9_intl_nonresearch_item_caps_ok c"

definition rule_9_evaluate :: "rule9_case => reimbursement_result" where
  "rule_9_evaluate c \<equiv>
    if \<not> rule9_hard_constraints_ok c then Rejection
    else if rule9_research_fund_scope c then
           (if \<not> rule9_research_standard_constraints_ok c then Partial_Approval else Full_Approval)
    else if rule9_nonresearch_fund_scope c then
           (if \<not> rule9_nonresearch_standard_constraints_ok c then Partial_Approval else Full_Approval)
    else Rejection"


record rule10_case =
  training_participant_role :: personnel_role
  training_duration_days :: int
  training_exceeds_30_days :: bool
  training_days_beyond_30 :: int
  training_has_instructor_fees :: bool
  training_instructor_fees :: int
  training_accommodation_expense :: int
  training_meals_expense :: int
  training_venue_materials_transport_expense :: int
  training_other_expense :: int
  training_total_expense :: int
  training_accommodation_quota :: int
  training_meals_quota :: int
  training_venue_materials_transport_quota :: int
  training_other_quota :: int
  training_total_quota :: int
  has_training_expense_detailed_list :: bool
  has_trainee_list_with_contact :: bool
  has_training_service_provider_receipts :: bool
  instructor_lecture_fees :: int
  instructor_accommodation_expense :: int
  instructor_meals_expense :: int
  instructor_transportation_expense :: int
  instructor_from_other_locations :: bool

definition rule10_1_comprehensive_quota :: "rule10_case \<Rightarrow> bool" where 
  "rule10_1_comprehensive_quota c \<equiv> 
    (case role_to_tier (training_participant_role c) of
       Tier_A \<Rightarrow>
         training_accommodation_quota c = 500 \<and> training_meals_quota c = 150 \<and>
         training_venue_materials_transport_quota c = 80 \<and> training_other_quota c = 30 \<and>
         training_total_quota c = 760
     | Tier_B \<Rightarrow>
         training_accommodation_quota c = 400 \<and> training_meals_quota c = 150 \<and>
         training_venue_materials_transport_quota c = 70 \<and> training_other_quota c = 30 \<and>
         training_total_quota c = 650
     | Tier_C \<Rightarrow>
         training_accommodation_quota c = 340 \<and> training_meals_quota c = 130 \<and>
         training_venue_materials_transport_quota c = 50 \<and> training_other_quota c = 30 \<and>
         training_total_quota c = 550)"

definition rule10_2_duration_adjustment :: "rule10_case \<Rightarrow> bool" where 
  "rule10_2_duration_adjustment c \<equiv> 
    (\<not> training_exceeds_30_days c \<longrightarrow> 
       training_accommodation_expense c \<le> training_accommodation_quota c * training_duration_days c \<and>
       training_meals_expense c \<le> training_meals_quota c * training_duration_days c \<and>
       training_venue_materials_transport_expense c \<le> training_venue_materials_transport_quota c * training_duration_days c \<and>
       training_other_expense c \<le> training_other_quota c * training_duration_days c) \<and>
    (training_exceeds_30_days c \<longrightarrow> 
       (let days_beyond = training_days_beyond_30 c in
        training_accommodation_expense c \<le> (training_accommodation_quota c * 30) + (training_accommodation_quota c * days_beyond * 70 div 100) \<and>
        training_meals_expense c \<le> (training_meals_quota c * 30) + (training_meals_quota c * days_beyond * 70 div 100) \<and>
        training_venue_materials_transport_expense c \<le> (training_venue_materials_transport_quota c * 30) + (training_venue_materials_transport_quota c * days_beyond * 70 div 100) \<and>
        training_other_expense c \<le> (training_other_quota c * 30) + (training_other_quota c * days_beyond * 70 div 100)))"

definition rule10_3_required_documents :: "rule10_case \<Rightarrow> bool" where 
  "rule10_3_required_documents c \<equiv> 
    has_training_expense_detailed_list c \<and> has_trainee_list_with_contact c \<and>
    has_training_service_provider_receipts c"

definition rule10_4_instructor_fees :: "rule10_case \<Rightarrow> bool" where 
  "rule10_4_instructor_fees c \<equiv> 
    training_has_instructor_fees c \<longrightarrow>
      instructor_lecture_fees c \<ge> 0 \<and>
      (instructor_accommodation_expense c \<le> training_accommodation_quota c * 1) \<and>
      (instructor_meals_expense c \<le> training_meals_quota c * 1) \<and>
      (instructor_transportation_expense c \<ge> 0)"

(* Rule 10: Training Fees *)
definition rule_10_evaluate :: "rule10_case \<Rightarrow> reimbursement_result" where 
  "rule_10_evaluate c \<equiv>
    if \<not> (rule10_3_required_documents c)
    then Rejection
    else if \<not> (rule10_1_comprehensive_quota c \<and> 
               rule10_2_duration_adjustment c \<and> 
               rule10_4_instructor_fees c)
    then Partial_Approval
    else Full_Approval"

definition rule10v2_cat_cap :: "rule10_case \<Rightarrow> int \<Rightarrow> int" where
  "rule10v2_cat_cap c q \<equiv>
    (if training_exceeds_30_days c
     then q * 30 + q * (max 0 (training_days_beyond_30 c)) * 70 div 100
     else q * max 0 (training_duration_days c))"

definition rule10v2_training_core_amount :: "rule10_case \<Rightarrow> int" where
  "rule10v2_training_core_amount c \<equiv>
    (let
      ac = min (max 0 (training_accommodation_expense c)) (max 0 (rule10v2_cat_cap c (training_accommodation_quota c)));
      me = min (max 0 (training_meals_expense c)) (max 0 (rule10v2_cat_cap c (training_meals_quota c)));
      vm = min (max 0 (training_venue_materials_transport_expense c)) (max 0 (rule10v2_cat_cap c (training_venue_materials_transport_quota c)));
      ot = min (max 0 (training_other_expense c)) (max 0 (rule10v2_cat_cap c (training_other_quota c)))
     in ac + me + vm + ot)"

definition rule10v2_instructor_amount :: "rule10_case \<Rightarrow> int" where
  "rule10v2_instructor_amount c \<equiv>
    (if training_has_instructor_fees c
     then
       max 0 (instructor_lecture_fees c) +
       min (max 0 (instructor_accommodation_expense c)) (max 0 (training_accommodation_quota c)) +
       min (max 0 (instructor_meals_expense c)) (max 0 (training_meals_quota c)) +
       max 0 (instructor_transportation_expense c)
     else 0)"

definition rule10v2_reimbursable_amount :: "rule10_case \<Rightarrow> int" where
  "rule10v2_reimbursable_amount c \<equiv>
    (if rule_10_evaluate c = Rejection then 0
     else min (rule10v2_training_core_amount c + rule10v2_instructor_amount c)
              (max 0 (training_total_expense c)))"

definition rule10v2_amount_decision :: "rule10_case \<Rightarrow> reimbursement_result * int" where
  "rule10v2_amount_decision c \<equiv> (rule_10_evaluate c, rule10v2_reimbursable_amount c)"


record rule11_case =
  staff_unmarried_visiting_parents :: bool
  staff_married_visiting_spouse :: bool
  staff_married_visiting_parents :: bool
  family_visit_round_trip_once_per_year :: bool
  family_visit_once_every_four_years :: bool
  monthly_base_salary :: int
  travel_expense_total :: int
  travel_expense_reimbursable :: int
  has_inter_city_transportation_costs :: bool
  has_local_transportation_costs :: bool
  travel_by_air :: bool
  equivalent_train_fare :: int
  has_family_visit_application_form :: bool
  form_approved_by_department :: bool
  form_stamped_by_hr :: bool

definition rule11_1_unmarried_staff :: "rule11_case \<Rightarrow> bool" where 
  "rule11_1_unmarried_staff c \<equiv> 
    staff_unmarried_visiting_parents c \<longrightarrow> family_visit_round_trip_once_per_year c"

definition rule11_2_married_staff_spouse :: "rule11_case \<Rightarrow> bool" where 
  "rule11_2_married_staff_spouse c \<equiv> 
    staff_married_visiting_spouse c \<longrightarrow> family_visit_round_trip_once_per_year c"

definition rule11_3_married_staff_parents :: "rule11_case \<Rightarrow> bool" where 
  "rule11_3_married_staff_parents c \<equiv> 
    staff_married_visiting_parents c \<longrightarrow> 
      family_visit_once_every_four_years c \<and>
      travel_expense_reimbursable c = max 0 (travel_expense_total c - (30 * monthly_base_salary c div 100))"

definition rule11_4_reimbursable_expenses :: "rule11_case \<Rightarrow> bool" where 
  "rule11_4_reimbursable_expenses c \<equiv> 
    has_inter_city_transportation_costs c \<and> \<not> has_local_transportation_costs c \<and>
    (travel_by_air c \<longrightarrow> travel_expense_reimbursable c \<le> equivalent_train_fare c)"

definition rule11_5_application_requirements :: "rule11_case \<Rightarrow> bool" where 
  "rule11_5_application_requirements c \<equiv> 
    has_family_visit_application_form c \<and> form_approved_by_department c \<and> form_stamped_by_hr c"

(* Rule 11: Family Visit Travel *)
definition rule_11_evaluate :: "rule11_case \<Rightarrow> reimbursement_result" where 
  "rule_11_evaluate c \<equiv>
    if \<not> (rule11_5_application_requirements c)
    then Rejection
    else if \<not> (rule11_1_unmarried_staff c \<and> 
               rule11_2_married_staff_spouse c \<and>
               rule11_3_married_staff_parents c \<and> 
               rule11_4_reimbursable_expenses c)
    then Partial_Approval
    else Full_Approval"


record rule13_case =
  expense_graduate_thesis_review_defense :: bool
  expense_lecture_fees :: bool
  expense_expert_consultation_fees :: bool

  expense_doctoral_dissertation :: bool
  expense_master_thesis :: bool

  reviewer_count :: int
  reviewer_fee_per_person :: int
  defense_committee_count :: int
  defense_committee_fee_per_person :: int
  defense_secretary_count :: int
  defense_secretary_fee_per_person :: int

  lecture_fee_is_after_tax :: bool
  lecture_speaker_role :: personnel_role
  lecture_fee_per_class_hour :: int
  lecture_class_hours :: int
  lecture_half_days :: int

  consultation_participant_role :: personnel_role
  consultation_type_in_person :: bool
  consultation_type_communication :: bool
  consultation_days :: int
  consultation_fee_per_day :: int
  consultation_fee_per_project :: int

definition rule13_lecture_hour_cap_by_role :: "personnel_role \<Rightarrow> int" where
  "rule13_lecture_hour_cap_by_role r \<equiv>
    (case role_to_tier r of Tier_A \<Rightarrow> 1500 | Tier_B \<Rightarrow> 1000 | Tier_C \<Rightarrow> 500)"

definition rule13_consult_is_senior_role :: "personnel_role \<Rightarrow> bool" where
  "rule13_consult_is_senior_role r \<equiv> role_to_tier r \<noteq> Tier_C"

definition rule13_a_review_defense_within_cap :: "rule13_case \<Rightarrow> bool" where
  "rule13_a_review_defense_within_cap c \<equiv>
    (\<not> expense_graduate_thesis_review_defense c) \<or>
    ((expense_doctoral_dissertation c \<longrightarrow>
        reviewer_count c \<le> 8 \<and> reviewer_fee_per_person c \<le> 500 \<and>
        defense_committee_count c \<le> 7 \<and> defense_committee_fee_per_person c \<le> 500 \<and>
        defense_secretary_count c \<le> 1 \<and> defense_secretary_fee_per_person c \<le> 150) \<and>
     (expense_master_thesis c \<longrightarrow>
        reviewer_count c \<le> 3 \<and> reviewer_fee_per_person c \<le> 300 \<and>
        defense_committee_count c \<le> 5 \<and> defense_committee_fee_per_person c \<le> 300 \<and>
        defense_secretary_count c \<le> 1 \<and> defense_secretary_fee_per_person c \<le> 100))"

definition rule13_b_lecture_known_and_within_cap :: "rule13_case \<Rightarrow> bool" where
  "rule13_b_lecture_known_and_within_cap c \<equiv>
    (\<not> expense_lecture_fees c) \<or>
    (lecture_fee_is_after_tax c \<and>
     lecture_fee_per_class_hour c \<le> rule13_lecture_hour_cap_by_role (lecture_speaker_role c) \<and>
     lecture_class_hours c \<le> 4 * lecture_half_days c)"

definition rule13_c_consultation_within_cap :: "rule13_case \<Rightarrow> bool" where
  "rule13_c_consultation_within_cap c \<equiv>
    (\<not> expense_expert_consultation_fees c) \<or>
    ((rule13_consult_is_senior_role (consultation_participant_role c) \<and> consultation_type_in_person c \<and> consultation_days c \<le> 2 \<longrightarrow>
        consultation_fee_per_day c \<le> 800) \<and>
     (rule13_consult_is_senior_role (consultation_participant_role c) \<and> consultation_type_in_person c \<and> consultation_days c \<ge> 3 \<longrightarrow>
        consultation_fee_per_day c \<le> 400) \<and>
     (rule13_consult_is_senior_role (consultation_participant_role c) \<and> consultation_type_communication c \<longrightarrow>
        consultation_fee_per_project c \<le> 100) \<and>
     (\<not> rule13_consult_is_senior_role (consultation_participant_role c) \<and> consultation_type_in_person c \<and> consultation_days c \<le> 2 \<longrightarrow>
        consultation_fee_per_day c \<le> 500) \<and>
     (\<not> rule13_consult_is_senior_role (consultation_participant_role c) \<and> consultation_type_in_person c \<and> consultation_days c \<ge> 3 \<longrightarrow>
        consultation_fee_per_day c \<le> 300) \<and>
     (\<not> rule13_consult_is_senior_role (consultation_participant_role c) \<and> consultation_type_communication c \<longrightarrow>
        consultation_fee_per_project c \<le> 80))"

definition rule13_lecture_unknown :: "rule13_case \<Rightarrow> bool" where
  "rule13_lecture_unknown c \<equiv>
    expense_lecture_fees c \<and> \<not> lecture_fee_is_after_tax c"

definition rule_13_evaluate :: "rule13_case \<Rightarrow> reimbursement_result" where
  "rule_13_evaluate c \<equiv>
    if rule13_lecture_unknown c then Unknown
    else if \<not> (rule13_a_review_defense_within_cap c \<and>
               rule13_b_lecture_known_and_within_cap c \<and>
               rule13_c_consultation_within_cap c)
         then Partial_Approval
         else Full_Approval"

(* 3 Full_Approval cases *)

definition rule13v2_review_amount :: "rule13_case \<Rightarrow> int" where
  "rule13v2_review_amount c \<equiv>
    (if \<not> expense_graduate_thesis_review_defense c then 0
     else if expense_doctoral_dissertation c then
       min (max 0 (reviewer_count c)) 8 * min (max 0 (reviewer_fee_per_person c)) 500 +
       min (max 0 (defense_committee_count c)) 7 * min (max 0 (defense_committee_fee_per_person c)) 500 +
       min (max 0 (defense_secretary_count c)) 1 * min (max 0 (defense_secretary_fee_per_person c)) 150
     else if expense_master_thesis c then
       min (max 0 (reviewer_count c)) 3 * min (max 0 (reviewer_fee_per_person c)) 300 +
       min (max 0 (defense_committee_count c)) 5 * min (max 0 (defense_committee_fee_per_person c)) 300 +
       min (max 0 (defense_secretary_count c)) 1 * min (max 0 (defense_secretary_fee_per_person c)) 100
     else 0)"

definition rule13v2_lecture_hour_cap :: "rule13_case \<Rightarrow> int" where
  "rule13v2_lecture_hour_cap c \<equiv>
    rule13_lecture_hour_cap_by_role (lecture_speaker_role c)"

definition rule13v2_lecture_amount :: "rule13_case \<Rightarrow> int" where
  "rule13v2_lecture_amount c \<equiv>
    (if \<not> expense_lecture_fees c \<or> \<not> lecture_fee_is_after_tax c then 0
     else min (max 0 (lecture_fee_per_class_hour c)) (rule13v2_lecture_hour_cap c) *
          min (max 0 (lecture_class_hours c)) (4 * max 0 (lecture_half_days c)))"

definition rule13v2_consult_amount :: "rule13_case \<Rightarrow> int" where
  "rule13v2_consult_amount c \<equiv>
    (if \<not> expense_expert_consultation_fees c then 0
     else if rule13_consult_is_senior_role (consultation_participant_role c) \<and> consultation_type_in_person c then
            min (max 0 (consultation_fee_per_day c))
                (if consultation_days c <= 2 then 800 else 400) * max 0 (consultation_days c)
          else if rule13_consult_is_senior_role (consultation_participant_role c) \<and> consultation_type_communication c then
            min (max 0 (consultation_fee_per_project c)) 100
          else if \<not> rule13_consult_is_senior_role (consultation_participant_role c) \<and> consultation_type_in_person c then
            min (max 0 (consultation_fee_per_day c))
                (if consultation_days c <= 2 then 500 else 300) * max 0 (consultation_days c)
          else if \<not> rule13_consult_is_senior_role (consultation_participant_role c) \<and> consultation_type_communication c then
            min (max 0 (consultation_fee_per_project c)) 80
          else 0)"

definition rule13v2_reimbursable_amount :: "rule13_case \<Rightarrow> int" where
  "rule13v2_reimbursable_amount c \<equiv>
    (case rule_13_evaluate c of
       Unknown \<Rightarrow> 0
     | _ \<Rightarrow> rule13v2_review_amount c + rule13v2_lecture_amount c + rule13v2_consult_amount c)"

definition rule13v2_amount_decision :: "rule13_case \<Rightarrow> reimbursement_result * int" where
  "rule13v2_amount_decision c \<equiv> (rule_13_evaluate c, rule13v2_reimbursable_amount c)"


record rule14_case =
  approval_form_original_provided :: bool
  approval_form_stamped_infra_official_seal :: bool
  approval_form_stamped_renovation_review_seal :: bool
  project_amount_over_100k :: bool
  approval_signed_by_infra_director :: bool
  approval_signed_by_vice_president :: bool


  payment_follows_contract_amount :: bool
  payment_follows_contract_progress :: bool
  not_overpayment :: bool
  not_advance_payment_across_progress :: bool


  is_first_payment :: bool
  construction_contract_original_provided :: bool
  first_payment_exceeds_contract_ratio_or_amount :: bool


  is_final_settlement_payment :: bool
  cost_review_opinion_original_provided :: bool
  filing_form_original_provided :: bool
  opinion_stamped_by_cost_company :: bool
  opinion_stamped_by_infra_process :: bool
  filing_form_signed_by_engineering_department :: bool
  filing_form_signed_and_commented_by_audit_office :: bool
  final_payment_based_on_approved_settlement_total :: bool
  final_payment_exceeds_contract_price :: bool

definition rule14_1_approval_requirements :: "rule14_case \<Rightarrow> bool" where
  "rule14_1_approval_requirements c \<equiv>
    approval_form_original_provided c \<and>
    approval_form_stamped_infra_official_seal c \<and>
    approval_form_stamped_renovation_review_seal c \<and>
    (project_amount_over_100k c \<longrightarrow>
      approval_signed_by_infra_director c \<and> approval_signed_by_vice_president c)"

definition rule14_2_payment_discipline :: "rule14_case \<Rightarrow> bool" where
  "rule14_2_payment_discipline c \<equiv>
    payment_follows_contract_amount c \<and>
    payment_follows_contract_progress c \<and>
    not_overpayment c \<and>
    not_advance_payment_across_progress c"

definition rule14_3_first_payment_required_docs :: "rule14_case \<Rightarrow> bool" where
  "rule14_3_first_payment_required_docs c \<equiv>
    is_first_payment c \<longrightarrow> construction_contract_original_provided c"

definition rule14_4_final_settlement_required_docs :: "rule14_case \<Rightarrow> bool" where
  "rule14_4_final_settlement_required_docs c \<equiv>
    is_final_settlement_payment c \<longrightarrow>
      cost_review_opinion_original_provided c \<and>
      filing_form_original_provided c \<and>
      opinion_stamped_by_cost_company c \<and>
      opinion_stamped_by_infra_process c \<and>
      filing_form_signed_by_engineering_department c \<and>
      filing_form_signed_and_commented_by_audit_office c \<and>
      final_payment_based_on_approved_settlement_total c"

definition rule14_3_first_payment_partial_trigger :: "rule14_case \<Rightarrow> bool" where
  "rule14_3_first_payment_partial_trigger c \<equiv>
    is_first_payment c \<and> first_payment_exceeds_contract_ratio_or_amount c"

definition rule14_4_final_settlement_partial_trigger :: "rule14_case \<Rightarrow> bool" where
  "rule14_4_final_settlement_partial_trigger c \<equiv>
    is_final_settlement_payment c \<and> final_payment_exceeds_contract_price c"

definition rule_14_evaluate :: "rule14_case \<Rightarrow> reimbursement_result" where
  "rule_14_evaluate c \<equiv>
    if \<not> (rule14_1_approval_requirements c \<and>
          rule14_2_payment_discipline c \<and>
          rule14_3_first_payment_required_docs c \<and>
          rule14_4_final_settlement_required_docs c)
    then Rejection
    else if rule14_3_first_payment_partial_trigger c \<or>
            rule14_4_final_settlement_partial_trigger c
    then Partial_Approval
    else Full_Approval"


datatype rule15_claim_type =
  Claim_Warranty_Refund |
  Claim_Cost_Review_Fee

record rule15_case =
  claim_type :: rule15_claim_type

  has_engineering_or_equipment_invoice :: bool
  invoice_issued_in_full_amount_including_warranty :: bool
  warranty_receipt_issued_by_finance :: bool
  warranty_period_expired :: bool
  no_quality_dispute_within_warranty_period :: bool
  warranty_receipt_provided_for_refund :: bool
  department_head_signed_for_refund :: bool

  has_cost_review_opinion :: bool
  claimed_amount_matches_school_share_in_opinion :: bool
  contractor_share_exists :: bool
  contractor_invoice_copy_provided :: bool

definition rule15_1_warranty_refund :: "rule15_case \<Rightarrow> bool" where
  "rule15_1_warranty_refund c \<equiv>
    has_engineering_or_equipment_invoice c \<and>
    invoice_issued_in_full_amount_including_warranty c \<and>
    warranty_receipt_issued_by_finance c \<and>
    warranty_period_expired c \<and>
    no_quality_dispute_within_warranty_period c \<and>
    warranty_receipt_provided_for_refund c \<and>
    department_head_signed_for_refund c"

definition rule15_2_cost_review_fee :: "rule15_case \<Rightarrow> bool" where
  "rule15_2_cost_review_fee c \<equiv>
    has_cost_review_opinion c \<and>
    claimed_amount_matches_school_share_in_opinion c \<and>
    (contractor_share_exists c \<longrightarrow> contractor_invoice_copy_provided c)"

definition rule_15_evaluate :: "rule15_case \<Rightarrow> reimbursement_result" where
  "rule_15_evaluate c \<equiv>
    (case claim_type c of
       Claim_Warranty_Refund =>
         (if rule15_1_warranty_refund c then Full_Approval else Rejection)
     | Claim_Cost_Review_Fee =>
         (if rule15_2_cost_review_fee c then Full_Approval else Rejection))"


datatype rule16_claim_type =
  Claim_Fixed_Asset |
  Claim_Intangible_Asset |
  Claim_Purchased_Material

record rule16_case =
  claim_type :: rule16_claim_type

  has_physical_form_goods :: bool
  unit_price_over_1000 :: bool
  useful_life_over_1_year :: bool
  is_bulk_same_kind_materials :: bool
  has_fixed_asset_reimbursement_slip_second_copy :: bool
  is_book :: bool
  fixed_asset_registered_at_asset_management_office :: bool
  fixed_asset_registered_at_library :: bool

  is_application_software :: bool
  intangible_value_at_least_2000 :: bool
  not_indispensable_hardware_component :: bool
  has_intangible_asset_reimbursement_slip_second_copy :: bool

  not_meet_fixed_asset_standard :: bool
  not_meet_intangible_asset_standard :: bool
  has_purchased_inventory_confirmation_form :: bool

definition rule16_1_fixed_asset :: "rule16_case \<Rightarrow> bool" where
  "rule16_1_fixed_asset c \<equiv>
    ((has_physical_form_goods c \<and> unit_price_over_1000 c) \<or>
     (useful_life_over_1_year c \<and> is_bulk_same_kind_materials c)) \<and>
    has_fixed_asset_reimbursement_slip_second_copy c \<and>
    (is_book c \<longrightarrow> fixed_asset_registered_at_library c) \<and>
    (\<not> is_book c \<longrightarrow> fixed_asset_registered_at_asset_management_office c)"

definition rule16_2_intangible_asset :: "rule16_case \<Rightarrow> bool" where
  "rule16_2_intangible_asset c \<equiv>
    is_application_software c \<and>
    intangible_value_at_least_2000 c \<and>
    not_indispensable_hardware_component c \<and>
    has_intangible_asset_reimbursement_slip_second_copy c"

definition rule16_3_purchased_material :: "rule16_case \<Rightarrow> bool" where
  "rule16_3_purchased_material c \<equiv>
    not_meet_fixed_asset_standard c \<and>
    not_meet_intangible_asset_standard c \<and>
    has_purchased_inventory_confirmation_form c"


definition rule_16_evaluate :: "rule16_case \<Rightarrow> reimbursement_result" where
  "rule_16_evaluate c \<equiv>
    (case claim_type c of
       Claim_Fixed_Asset =>
         (if rule16_1_fixed_asset c then Full_Approval else Rejection)
     | Claim_Intangible_Asset =>
         (if rule16_2_intangible_asset c then Full_Approval else Rejection)
     | Claim_Purchased_Material =>
         (if rule16_3_purchased_material c then Full_Approval else Rejection))"


record rule17_case =
  is_equipment_maintenance_fee :: bool
  has_application_in_asset_management_system :: bool
  has_maintenance_application_form :: bool
  maintenance_form_signed_by_relevant_personnel :: bool
  maintenance_form_stamped_by_unit :: bool
  has_original_invoices :: bool

definition rule17_1_maintenance_requirements :: "rule17_case \<Rightarrow> bool" where 
  "rule17_1_maintenance_requirements c \<equiv> 
    is_equipment_maintenance_fee c \<longrightarrow>
      has_application_in_asset_management_system c \<and>
      has_maintenance_application_form c \<and>
      maintenance_form_signed_by_relevant_personnel c \<and>
      maintenance_form_stamped_by_unit c \<and>
      has_original_invoices c"


definition rule_17_evaluate :: "rule17_case \<Rightarrow> reimbursement_result" where
  "rule_17_evaluate c \<equiv>
    if is_equipment_maintenance_fee c \<and> rule17_1_maintenance_requirements c
    then Full_Approval
    else Rejection"
definition combined_eval_4_17 :: "rule4_case \<Rightarrow> rule17_case \<Rightarrow> reimbursement_result" where
  "combined_eval_4_17 c4 c17 \<equiv>
    (let r4 = rule_4_evaluate c4;
         r17 = rule_17_evaluate c17
     in if r4 = Rejection \<or> r17 = Rejection then Rejection else Full_Approval)"


record rule18_case =
  is_domestic_official_hospitality :: bool
  processed_per_event :: bool
  has_financial_invoices :: bool
  has_official_letter_from_sending_unit :: bool
  official_letter_includes_purpose :: bool
  official_letter_includes_agenda :: bool
  official_letter_includes_visitor_list :: bool
  has_hospitality_list_form :: bool
  has_hospitality_approval_form :: bool
  has_accommodation_expense_claimed :: bool
  accommodation_arranged_for_visitors :: bool
  visitor_level_provincial_ministerial :: bool
  accommodation_arranged_in_standard_room :: bool
  accommodation_arranged_in_suite_for_provincial_level :: bool
  is_local_shanghai_unit_visit :: bool
  accommodation_arranged_for_local_visit :: bool
  is_working_meal_necessary :: bool
  meal_type_boxed_lunch_or_buffet :: bool
  daily_meal_standard_per_person :: int
  daily_meal_standard_exceeds_100 :: bool
  has_one_formal_meal :: bool
  formal_meal_standard_per_person :: int
  formal_meal_standard_exceeds_150 :: bool
  visitor_count :: int
  accompanying_person_count :: int
  accompanying_person_controlled :: bool
  accompanying_staff_simple_meal_standard :: int
  accompanying_staff_simple_meal_exceeds_50 :: bool
  group_transportation_arranged :: bool
  vehicle_selection_reasonable :: bool
  accompanying_vehicles_controlled :: bool

definition rule18_1_basic_requirements :: "rule18_case \<Rightarrow> bool" where 
  "rule18_1_basic_requirements c \<equiv> 
    is_domestic_official_hospitality c \<and> processed_per_event c \<and>
    has_financial_invoices c \<and> has_official_letter_from_sending_unit c \<and>
    official_letter_includes_purpose c \<and> official_letter_includes_agenda c \<and>
    official_letter_includes_visitor_list c \<and> has_hospitality_list_form c \<and>
    has_hospitality_approval_form c"

definition rule18_2_accommodation_rules :: "rule18_case \<Rightarrow> bool" where 
  "rule18_2_accommodation_rules c \<equiv> 
    \<not> has_accommodation_expense_claimed c \<and>
    (accommodation_arranged_for_visitors c \<longrightarrow>
      (accommodation_arranged_in_standard_room c \<or>
       (visitor_level_provincial_ministerial c \<longrightarrow> accommodation_arranged_in_suite_for_provincial_level c))) \<and>
    (is_local_shanghai_unit_visit c \<longrightarrow> \<not> accommodation_arranged_for_local_visit c)"

definition rule18_3_meal_standards :: "rule18_case \<Rightarrow> bool" where 
  "rule18_3_meal_standards c \<equiv> 
    is_working_meal_necessary c \<longrightarrow>
      (meal_type_boxed_lunch_or_buffet c \<and>
       daily_meal_standard_per_person c \<le> 100 \<and>
       (has_one_formal_meal c \<longrightarrow> formal_meal_standard_per_person c \<le> 150) \<and>
       (visitor_count c \<le> 10 \<longrightarrow> accompanying_person_count c \<le> 3) \<and>
       (visitor_count c > 10 \<longrightarrow> accompanying_person_count c \<le> visitor_count c div 3) \<and>
       (accompanying_staff_simple_meal_standard c \<le> 50))"

definition rule18_4_transportation_rules :: "rule18_case \<Rightarrow> bool" where 
  "rule18_4_transportation_rules c \<equiv> 
    group_transportation_arranged c \<and>
    vehicle_selection_reasonable c \<and>
    accompanying_vehicles_controlled c"

(* Rule 18: Official Hospitality *)
definition rule_18_evaluate :: "rule18_case \<Rightarrow> reimbursement_result" where 
  "rule_18_evaluate c \<equiv>
    if \<not> (rule18_1_basic_requirements c)
    then Rejection
    else if \<not> (rule18_2_accommodation_rules c \<and> 
               rule18_3_meal_standards c \<and> 
               rule18_4_transportation_rules c)
    then Partial_Approval
    else Full_Approval"


datatype rule19_guest_level =
    R19_HeadState
  | R19_VicePremier_or_ParliamentLevel
  | R19_Ministerial_or_ViceMinisterial
  | R19_Other

datatype rule19_banquet_type =
    R19_Formal_Banquet
  | R19_Cold_Meal
  | R19_Cocktail
  | R19_Tea

datatype rule19_gift_target_level =
    R19_Gift_Ministerial_or_ViceMinisterial
  | R19_Gift_Bureau
  | R19_Gift_Other

datatype rule19_visit_scope =
    R19_Domestic_Visit
  | R19_Overseas_Visit

record rule19_case =
  visit_scope :: rule19_visit_scope

  has_truthful_filing_to_foreign_affairs_office :: bool
  has_fudan_overseas_expert_fund_report :: bool
  signed_by_responsible_person :: bool
  signed_by_handler :: bool

  has_domestic_reception_list :: bool
  domestic_list_signed_by_responsible_person :: bool
  domestic_list_has_visitor_org :: bool
  domestic_list_has_visitor_name :: bool
  domestic_list_has_visit_reason :: bool

  claims_lodging :: bool
  claims_intercity_transport :: bool
  claims_daily_meal :: bool
  claims_banquet :: bool
  claims_local_transport :: bool
  claims_gift :: bool
  claims_staff_mismeal_subsidy :: bool

  delegation_led_by_vice_minister_or_above :: bool
  hotel_star :: int

  guest_level :: rule19_guest_level
  daily_meal_ppd :: int

  banquet_type :: rule19_banquet_type
  banquet_host_is_ministerial_or_vice :: bool
  banquet_pp_once :: int

  local_transport_compliant_with_level_standard :: bool

  gift_target_level :: rule19_gift_target_level
  gift_pp_once :: int
  gift_is_small_souvenir_for_other :: bool

  is_major_diplomatic_event_for_head_state :: bool
  arranged_by_protocol_requirement :: bool
  foreign_guest_count :: int
  our_accompany_count :: int

  staff_mismeal_subsidy_pp_once :: int

  is_conference_related_visit :: bool
  conference_has_lodging_or_meal_expense :: bool
  linked_rule9_case :: rule9_case
  linked_rule7_case :: rule7_case

definition r19_daily_meal_cap :: "rule19_guest_level \<Rightarrow> int" where
  "r19_daily_meal_cap g \<equiv>
    (case g of
       R19_HeadState => 600
     | R19_VicePremier_or_ParliamentLevel => 550
     | R19_Ministerial_or_ViceMinisterial => 500
     | R19_Other => 300)"

definition r19_banquet_cap :: "rule19_banquet_type \<Rightarrow> bool \<Rightarrow> int" where
  "r19_banquet_cap t host_high \<equiv>
    (case t of
       R19_Formal_Banquet => (if host_high then 400 else 300)
     | R19_Cold_Meal => 150
     | R19_Cocktail => 100
     | R19_Tea => 60)"

definition r19_1_basic_docs_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_1_basic_docs_ok c \<equiv>
    has_truthful_filing_to_foreign_affairs_office c \<and>
    has_fudan_overseas_expert_fund_report c \<and>
    signed_by_responsible_person c \<and>
    signed_by_handler c"

definition r19_0_scope_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_0_scope_ok c \<equiv>
    (visit_scope c = R19_Domestic_Visit \<or> visit_scope c = R19_Overseas_Visit)"

definition r19_1b_domestic_visit_docs_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_1b_domestic_visit_docs_ok c \<equiv>
    (visit_scope c = R19_Domestic_Visit \<longrightarrow>
      has_domestic_reception_list c \<and>
      domestic_list_signed_by_responsible_person c \<and>
      domestic_list_has_visitor_org c \<and>
      domestic_list_has_visitor_name c \<and>
      domestic_list_has_visit_reason c)"

definition r19_1c_domestic_trip_link_rule7_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_1c_domestic_trip_link_rule7_ok c \<equiv>
    (visit_scope c = R19_Domestic_Visit \<and> (claims_intercity_transport c \<or> claims_lodging c))
      \<longrightarrow> (rule_7_evaluate (linked_rule7_case c) \<noteq> Rejection)"

definition r19_2_lodging_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_2_lodging_ok c \<equiv>
    claims_lodging c \<longrightarrow>
      (if delegation_led_by_vice_minister_or_above c
       then hotel_star c \<le> 5 \<and> hotel_star c \<ge> 4
       else hotel_star c \<le> 4)"

definition r19_3_daily_meal_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_3_daily_meal_ok c \<equiv>
    claims_daily_meal c \<longrightarrow> daily_meal_ppd c \<le> r19_daily_meal_cap (guest_level c)"

definition r19_4_banquet_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_4_banquet_ok c \<equiv>
    claims_banquet c \<longrightarrow>
      banquet_pp_once c \<le> r19_banquet_cap (banquet_type c) (banquet_host_is_ministerial_or_vice c)"

definition r19_5_transport_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_5_transport_ok c \<equiv>
    claims_local_transport c \<longrightarrow> local_transport_compliant_with_level_standard c"

definition r19_6_gift_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_6_gift_ok c \<equiv>
    claims_gift c \<longrightarrow>
      (case gift_target_level c of
         R19_Gift_Ministerial_or_ViceMinisterial => gift_pp_once c \<le> 400
       | R19_Gift_Bureau => gift_pp_once c \<le> 200
       | R19_Gift_Other => gift_is_small_souvenir_for_other c)"

definition r19_7_companion_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_7_companion_ok c \<equiv>
    foreign_guest_count c \<ge> 0 \<and> our_accompany_count c \<ge> 0 \<and>
    (if is_major_diplomatic_event_for_head_state c
     then arranged_by_protocol_requirement c
     else
       (if foreign_guest_count c \<le> 5
        then our_accompany_count c \<le> foreign_guest_count c
        else our_accompany_count c \<le> 5 + 2 * (foreign_guest_count c - 5)))"

definition r19_8_staff_mismeal_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_8_staff_mismeal_ok c \<equiv>
    claims_staff_mismeal_subsidy c \<longrightarrow> staff_mismeal_subsidy_pp_once c \<le> 50"

(* 删掉旧的 r19_rule9_subset_ok *)

definition r19_rule9_hard_link_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_rule9_hard_link_ok c \<equiv>
    (is_conference_related_visit c \<and> conference_has_lodging_or_meal_expense c) \<longrightarrow>
      (rule_9_evaluate (linked_rule9_case c) \<noteq> Rejection)"

definition r19_rule9_standard_link_ok :: "rule19_case \<Rightarrow> bool" where
  "r19_rule9_standard_link_ok c \<equiv>
    (is_conference_related_visit c \<and> conference_has_lodging_or_meal_expense c) \<longrightarrow>
      (rule_9_evaluate (linked_rule9_case c) = Full_Approval)"

definition rule19_hard_constraints_ok :: "rule19_case \<Rightarrow> bool" where
  "rule19_hard_constraints_ok c \<equiv>
    r19_0_scope_ok c \<and>
    r19_1_basic_docs_ok c \<and>
    r19_1b_domestic_visit_docs_ok c \<and>
    r19_1c_domestic_trip_link_rule7_ok c \<and>
    r19_rule9_hard_link_ok c"

definition rule19_standard_constraints_ok :: "rule19_case \<Rightarrow> bool" where
  "rule19_standard_constraints_ok c \<equiv>
    r19_2_lodging_ok c \<and>
    r19_3_daily_meal_ok c \<and>
    r19_4_banquet_ok c \<and>
    r19_5_transport_ok c \<and>
    r19_6_gift_ok c \<and>
    r19_7_companion_ok c \<and>
    r19_8_staff_mismeal_ok c \<and>
    r19_rule9_standard_link_ok c"


definition rule_19_evaluate :: "rule19_case \<Rightarrow> reimbursement_result" where
  "rule_19_evaluate c \<equiv>
    if \<not> rule19_hard_constraints_ok c then Rejection
    else if \<not> rule19_standard_constraints_ok c then Partial_Approval
    else Full_Approval"


(* ===== Rule19: 9 cases (3 Full / 3 Partial / 3 Rejection) ===== *)
datatype rule20_answer = Can_Borrow | Cannot_Borrow

record rule20_case =
  is_special_business_for_temp_loan :: bool
  cannot_get_invoice_in_advance :: bool

  borrower_is_fudan_staff :: bool
  borrower_is_leased_personnel_R_or_L :: bool
  borrower_is_postdoc :: bool
  borrower_signed_reservation_form :: bool

  borrower_is_retired :: bool
  borrower_is_student :: bool
  borrower_is_external_personnel :: bool

  is_same_city_settlement :: bool
  is_nonlocal_settlement :: bool
  days_until_writeoff :: int

  has_unwritten_off_loan :: bool
  has_special_reason_for_new_loan :: bool


definition rule20_1_special_business :: "rule20_case \<Rightarrow> bool" where
  "rule20_1_special_business c \<equiv>
    is_special_business_for_temp_loan c \<and>
    cannot_get_invoice_in_advance c"

definition rule20_2_borrower_eligibility :: "rule20_case \<Rightarrow> bool" where
  "rule20_2_borrower_eligibility c \<equiv>
    (borrower_is_fudan_staff c \<or>
     borrower_is_leased_personnel_R_or_L c \<or>
     borrower_is_postdoc c) \<and>
    borrower_signed_reservation_form c"

definition rule20_3_borrower_exclusion :: "rule20_case \<Rightarrow> bool" where
  "rule20_3_borrower_exclusion c \<equiv>
    \<not> borrower_is_retired c \<and>
    \<not> borrower_is_student c \<and>
    \<not> borrower_is_external_personnel c"

definition rule20_4_writeoff_deadline :: "rule20_case \<Rightarrow> bool" where
  "rule20_4_writeoff_deadline c \<equiv>
    (is_same_city_settlement c \<or> is_nonlocal_settlement c) \<and>
    (is_same_city_settlement c \<longrightarrow> days_until_writeoff c \<le> 30) \<and>
    (is_nonlocal_settlement c \<longrightarrow> days_until_writeoff c \<le> 60)"

definition rule20_5_outstanding_loan_control :: "rule20_case \<Rightarrow> bool" where
  "rule20_5_outstanding_loan_control c \<equiv>
    has_unwritten_off_loan c \<longrightarrow> has_special_reason_for_new_loan c"

definition rule_20_evaluate :: "rule20_case \<Rightarrow> rule20_answer" where
  "rule_20_evaluate c \<equiv>
    if rule20_1_special_business c \<and>
       rule20_2_borrower_eligibility c \<and>
       rule20_3_borrower_exclusion c \<and>
       rule20_4_writeoff_deadline c \<and>
       rule20_5_outstanding_loan_control c
    then Can_Borrow
    else Cannot_Borrow"


(* 3 cases: Can_Borrow *)

definition rule34_global_ok :: "rule3_case \<Rightarrow> rule4_case \<Rightarrow> bool" where
  "rule34_global_ok c3 c4 \<equiv>
    (rule_3_evaluate c3 \<noteq> Rejection) \<and> (rule_4_evaluate c4 \<noteq> Rejection)"

definition gate_reimbursement_result ::
  "rule3_case \<Rightarrow> rule4_case \<Rightarrow> reimbursement_result \<Rightarrow> reimbursement_result" where
  "gate_reimbursement_result c3 c4 r \<equiv>
    if rule34_global_ok c3 c4 then r else Rejection"

definition default_rule3_gate_case :: rule3_case where
  "default_rule3_gate_case \<equiv> \<lparr>
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

definition default_rule4_gate_case :: rule4_case where
  "default_rule4_gate_case \<equiv> \<lparr>
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

definition rule_6_evaluate_gated :: "rule6_case \<Rightarrow> reimbursement_result" where
  "rule_6_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_6_evaluate c)"

definition rule_7_evaluate_gated :: "rule7_case \<Rightarrow> reimbursement_result" where
  "rule_7_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_7_evaluate c)"

definition rule_8_evaluate_gated :: "rule8_case \<Rightarrow> reimbursement_result" where
  "rule_8_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_8_evaluate c)"

definition rule_9_evaluate_gated :: "rule9_case \<Rightarrow> reimbursement_result" where
  "rule_9_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_9_evaluate c)"

definition rule_10_evaluate_gated :: "rule10_case \<Rightarrow> reimbursement_result" where
  "rule_10_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_10_evaluate c)"

definition rule_11_evaluate_gated :: "rule11_case \<Rightarrow> reimbursement_result" where
  "rule_11_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_11_evaluate c)"

definition rule_13_evaluate_gated :: "rule13_case \<Rightarrow> reimbursement_result" where
  "rule_13_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_13_evaluate c)"

definition rule_14_evaluate_gated :: "rule14_case \<Rightarrow> reimbursement_result" where
  "rule_14_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_14_evaluate c)"

definition rule_15_evaluate_gated :: "rule15_case \<Rightarrow> reimbursement_result" where
  "rule_15_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_15_evaluate c)"

definition rule_16_evaluate_gated :: "rule16_case \<Rightarrow> reimbursement_result" where
  "rule_16_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_16_evaluate c)"

definition rule_17_evaluate_gated :: "rule17_case \<Rightarrow> reimbursement_result" where
  "rule_17_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_17_evaluate c)"

definition rule_18_evaluate_gated :: "rule18_case \<Rightarrow> reimbursement_result" where
  "rule_18_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_18_evaluate c)"

definition rule_19_evaluate_gated :: "rule19_case \<Rightarrow> reimbursement_result" where
  "rule_19_evaluate_gated c \<equiv>
    gate_reimbursement_result default_rule3_gate_case default_rule4_gate_case (rule_19_evaluate c)"

definition rule_20_evaluate_gated :: "rule20_case \<Rightarrow> rule20_answer" where
  "rule_20_evaluate_gated c \<equiv>
    rule_20_evaluate c"

definition combined_evaluate_gated :: "rule4_case \<Rightarrow> rule6_case \<Rightarrow> reimbursement_result" where
  "combined_evaluate_gated c4 c6 \<equiv>
    if rule34_global_ok default_rule3_gate_case c4
    then combined_evaluate c4 c6
    else Rejection"

definition eval_pair_gated :: "(rule4_case * rule6_case) \<Rightarrow> reimbursement_result" where
  "eval_pair_gated p \<equiv> combined_evaluate_gated (fst p) (snd p)"

definition combined_eval_4_17_gated :: "rule4_case \<Rightarrow> rule17_case \<Rightarrow> reimbursement_result" where
  "combined_eval_4_17_gated c4 c17 \<equiv>
    if rule34_global_ok default_rule3_gate_case c4
    then combined_eval_4_17 c4 c17
    else Rejection"

definition rule7v2_amount_decision_gated :: "rule7v2_amount_case \<Rightarrow> reimbursement_result * int" where
  "rule7v2_amount_decision_gated ac \<equiv>
    (let r = rule_7_evaluate_gated (base7v2 ac)
     in (r, if r = Rejection then 0 else rule7v2_reimbursable_amount ac))"

definition rule10v2_amount_decision_gated :: "rule10_case \<Rightarrow> reimbursement_result * int" where
  "rule10v2_amount_decision_gated c \<equiv>
    (let r = rule_10_evaluate_gated c
     in (r, if r = Rejection then 0 else rule10v2_reimbursable_amount c))"

definition rule13v2_amount_decision_gated :: "rule13_case \<Rightarrow> reimbursement_result * int" where
  "rule13v2_amount_decision_gated c \<equiv>
    (let r = rule_13_evaluate_gated c
     in (r, if r = Rejection \<or> r = Unknown then 0
             else rule13v2_review_amount c + rule13v2_lecture_amount c + rule13v2_consult_amount c))"

(* ===== Global optimization: claim_type1 first, then rule dispatch ===== *)

datatype claim_type1 =
  CT1_Rule6 | CT1_Rule7 | CT1_Rule8 | CT1_Rule9 | CT1_Rule10 | CT1_Rule11 |
  CT1_Rule13 | CT1_Rule14 | CT1_Rule15 | CT1_Rule16 | CT1_Rule17 | CT1_Rule18 |
  CT1_Rule19 | CT1_Rule20

datatype claim_payload1 =
  Payload6 rule6_case
  | Payload7 rule7_case
  | Payload8 rule8_case
  | Payload9 rule9_case
  | Payload10 rule10_case
  | Payload11 rule11_case
  | Payload13 rule13_case
  | Payload14 rule14_case
  | Payload15 rule15_case
  | Payload16 rule16_case
  | Payload17 rule17_case
  | Payload18 rule18_case
  | Payload19 rule19_case
  | Payload20 rule20_case

datatype global_claim_result =
  Global_Reimbursement reimbursement_result
  | Global_Loan rule20_answer
  | Global_ClaimType_Mismatch

definition claim_type1_of_payload :: "claim_payload1 \<Rightarrow> claim_type1" where
  "claim_type1_of_payload p \<equiv>
    (case p of
       Payload6 _ \<Rightarrow> CT1_Rule6
     | Payload7 _ \<Rightarrow> CT1_Rule7
     | Payload8 _ \<Rightarrow> CT1_Rule8
     | Payload9 _ \<Rightarrow> CT1_Rule9
     | Payload10 _ \<Rightarrow> CT1_Rule10
     | Payload11 _ \<Rightarrow> CT1_Rule11
     | Payload13 _ \<Rightarrow> CT1_Rule13
     | Payload14 _ \<Rightarrow> CT1_Rule14
     | Payload15 _ \<Rightarrow> CT1_Rule15
     | Payload16 _ \<Rightarrow> CT1_Rule16
     | Payload17 _ \<Rightarrow> CT1_Rule17
     | Payload18 _ \<Rightarrow> CT1_Rule18
     | Payload19 _ \<Rightarrow> CT1_Rule19
     | Payload20 _ \<Rightarrow> CT1_Rule20)"

definition global_evaluate_by_claim_type1 ::
  "rule3_case \<Rightarrow> rule4_case \<Rightarrow> claim_type1 \<Rightarrow> claim_payload1 \<Rightarrow> global_claim_result" where
  "global_evaluate_by_claim_type1 c3 c4 ct p \<equiv>
    (if ct \<noteq> claim_type1_of_payload p then Global_ClaimType_Mismatch
     else
       (case p of
          Payload6 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_6_evaluate c))
        | Payload7 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_7_evaluate c))
        | Payload8 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_8_evaluate c))
        | Payload9 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_9_evaluate c))
        | Payload10 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_10_evaluate c))
        | Payload11 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_11_evaluate c))
        | Payload13 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_13_evaluate c))
        | Payload14 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_14_evaluate c))
        | Payload15 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_15_evaluate c))
        | Payload16 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_16_evaluate c))
        | Payload17 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_17_evaluate c))
        | Payload18 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_18_evaluate c))
         | Payload19 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_19_evaluate c))
         | Payload20 c \<Rightarrow> Global_Loan (rule_20_evaluate c)))"

(* ===== Business claim_type dispatch (semantic categories) ===== *)

datatype claim_type_main =
  CTM_Office_or_Printing_Fee
  | CTM_Travel_Fee
  | CTM_Overseas_Fee
  | CTM_Conference_Fee
  | CTM_Training_Fee
  | CTM_Family_Visit_Travel_Fee
  | CTM_Labor_Fee
  | CTM_Engineering_Repair_Fee
  | CTM_Warranty_Fee
  | CTM_Cost_Review_Fee
  | CTM_Fixed_Asset_Reimbursement
  | CTM_Intangible_Asset_Reimbursement
  | CTM_Purchased_Material_Reimbursement
  | CTM_Equipment_Maintenance_Fee
  | CTM_Official_Hospitality_Fee
  | CTM_Visitor_Fee
  | CTM_Temporary_Loan

datatype claim_payload_main =
  PM6 rule6_case
  | PM7 rule7_case
  | PM8 rule8_case
  | PM9 rule9_case
  | PM10 rule10_case
  | PM11 rule11_case
  | PM13 rule13_case
  | PM14 rule14_case
  | PM15_Warranty rule15_case
  | PM15_CostReview rule15_case
  | PM16_Fixed rule16_case
  | PM16_Intangible rule16_case
  | PM16_Material rule16_case
  | PM17 rule17_case
  | PM18 rule18_case
  | PM19 rule19_case
  | PM20 rule20_case

definition claim_type_main_of_payload :: "claim_payload_main \<Rightarrow> claim_type_main" where
  "claim_type_main_of_payload p \<equiv>
    (case p of
       PM6 _ \<Rightarrow> CTM_Office_or_Printing_Fee
     | PM7 _ \<Rightarrow> CTM_Travel_Fee
     | PM8 _ \<Rightarrow> CTM_Overseas_Fee
     | PM9 _ \<Rightarrow> CTM_Conference_Fee
     | PM10 _ \<Rightarrow> CTM_Training_Fee
     | PM11 _ \<Rightarrow> CTM_Family_Visit_Travel_Fee
     | PM13 _ \<Rightarrow> CTM_Labor_Fee
     | PM14 _ \<Rightarrow> CTM_Engineering_Repair_Fee
     | PM15_Warranty _ \<Rightarrow> CTM_Warranty_Fee
     | PM15_CostReview _ \<Rightarrow> CTM_Cost_Review_Fee
     | PM16_Fixed _ \<Rightarrow> CTM_Fixed_Asset_Reimbursement
     | PM16_Intangible _ \<Rightarrow> CTM_Intangible_Asset_Reimbursement
     | PM16_Material _ \<Rightarrow> CTM_Purchased_Material_Reimbursement
     | PM17 _ \<Rightarrow> CTM_Equipment_Maintenance_Fee
     | PM18 _ \<Rightarrow> CTM_Official_Hospitality_Fee
     | PM19 _ \<Rightarrow> CTM_Visitor_Fee
     | PM20 _ \<Rightarrow> CTM_Temporary_Loan)"

definition global_evaluate_by_claim_type_main ::
  "rule3_case \<Rightarrow> rule4_case \<Rightarrow> claim_type_main \<Rightarrow> claim_payload_main \<Rightarrow> global_claim_result" where
  "global_evaluate_by_claim_type_main c3 c4 ct p \<equiv>
    (if ct \<noteq> claim_type_main_of_payload p then Global_ClaimType_Mismatch
     else
       (case p of
          PM6 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_6_evaluate c))
        | PM7 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_7_evaluate c))
        | PM8 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_8_evaluate c))
        | PM9 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_9_evaluate c))
        | PM10 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_10_evaluate c))
        | PM11 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_11_evaluate c))
        | PM13 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_13_evaluate c))
        | PM14 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_14_evaluate c))
        | PM15_Warranty c \<Rightarrow>
            Global_Reimbursement (gate_reimbursement_result c3 c4
              (if rule15_case.claim_type c = Claim_Warranty_Refund then rule_15_evaluate c else Rejection))
        | PM15_CostReview c \<Rightarrow>
            Global_Reimbursement (gate_reimbursement_result c3 c4
              (if rule15_case.claim_type c = Claim_Cost_Review_Fee then rule_15_evaluate c else Rejection))
        | PM16_Fixed c \<Rightarrow>
            Global_Reimbursement (gate_reimbursement_result c3 c4
              (if rule16_case.claim_type c = Claim_Fixed_Asset then rule_16_evaluate c else Rejection))
        | PM16_Intangible c \<Rightarrow>
            Global_Reimbursement (gate_reimbursement_result c3 c4
              (if rule16_case.claim_type c = Claim_Intangible_Asset then rule_16_evaluate c else Rejection))
        | PM16_Material c \<Rightarrow>
            Global_Reimbursement (gate_reimbursement_result c3 c4
              (if rule16_case.claim_type c = Claim_Purchased_Material then rule_16_evaluate c else Rejection))
        | PM17 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_17_evaluate c))
        | PM18 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_18_evaluate c))
        | PM19 c \<Rightarrow> Global_Reimbursement (gate_reimbursement_result c3 c4 (rule_19_evaluate c))
        | PM20 c \<Rightarrow> Global_Loan (rule_20_evaluate c)))"

record claim_case_main =
  cc_claim_type :: claim_type_main
  cc_payload :: claim_payload_main

definition claim_case_main_wf :: "claim_case_main \<Rightarrow> bool" where
  "claim_case_main_wf cc \<equiv>
    cc_claim_type cc = claim_type_main_of_payload (cc_payload cc)"

definition evaluate_claim_case_main ::
  "rule3_case \<Rightarrow> rule4_case \<Rightarrow> claim_case_main \<Rightarrow> global_claim_result" where
  "evaluate_claim_case_main c3 c4 cc \<equiv>
    if claim_case_main_wf cc
    then global_evaluate_by_claim_type_main c3 c4 (cc_claim_type cc) (cc_payload cc)
    else Global_ClaimType_Mismatch"

(* ===== Small optimization for Rule 13/15/16: claim_type2 dispatch ===== *)

datatype rule13_claim_type2 =
  CT2_R13_ReviewDefense
  | CT2_R13_Lecture
  | CT2_R13_Consultation

definition rule_13_evaluate_by_claim_type2 ::
  "rule13_claim_type2 \<Rightarrow> rule13_case \<Rightarrow> reimbursement_result" where
  "rule_13_evaluate_by_claim_type2 ct c \<equiv>
    (case ct of
       CT2_R13_ReviewDefense \<Rightarrow>
         (if rule13_a_review_defense_within_cap c then Full_Approval else Partial_Approval)
     | CT2_R13_Lecture \<Rightarrow>
         (if rule13_lecture_unknown c then Unknown
          else if rule13_b_lecture_known_and_within_cap c then Full_Approval else Partial_Approval)
     | CT2_R13_Consultation \<Rightarrow>
         (if rule13_c_consultation_within_cap c then Full_Approval else Partial_Approval))"

type_synonym rule15_claim_type2 = rule15_claim_type
type_synonym rule16_claim_type2 = rule16_claim_type

definition rule_15_evaluate_by_claim_type2 ::
  "rule15_claim_type2 \<Rightarrow> rule15_case \<Rightarrow> reimbursement_result" where
  "rule_15_evaluate_by_claim_type2 ct c \<equiv>
    (case ct of
       Claim_Warranty_Refund =>
         (if rule15_1_warranty_refund c then Full_Approval else Rejection)
     | Claim_Cost_Review_Fee =>
         (if rule15_2_cost_review_fee c then Full_Approval else Rejection))"

definition rule_16_evaluate_by_claim_type2 ::
  "rule16_claim_type2 \<Rightarrow> rule16_case \<Rightarrow> reimbursement_result" where
  "rule_16_evaluate_by_claim_type2 ct c \<equiv>
    (case ct of
       Claim_Fixed_Asset =>
         (if rule16_1_fixed_asset c then Full_Approval else Rejection)
     | Claim_Intangible_Asset =>
         (if rule16_2_intangible_asset c then Full_Approval else Rejection)
     | Claim_Purchased_Material =>
         (if rule16_3_purchased_material c then Full_Approval else Rejection))"

definition rule_13_evaluate_gated_by_claim_type2 ::
  "rule3_case \<Rightarrow> rule4_case \<Rightarrow> rule13_claim_type2 \<Rightarrow> rule13_case \<Rightarrow> reimbursement_result" where
  "rule_13_evaluate_gated_by_claim_type2 c3 c4 ct c \<equiv>
    gate_reimbursement_result c3 c4 (rule_13_evaluate_by_claim_type2 ct c)"

definition rule_15_evaluate_gated_by_claim_type2 ::
  "rule3_case \<Rightarrow> rule4_case \<Rightarrow> rule15_claim_type2 \<Rightarrow> rule15_case \<Rightarrow> reimbursement_result" where
  "rule_15_evaluate_gated_by_claim_type2 c3 c4 ct c \<equiv>
    gate_reimbursement_result c3 c4 (rule_15_evaluate_by_claim_type2 ct c)"

definition rule_16_evaluate_gated_by_claim_type2 ::
  "rule3_case \<Rightarrow> rule4_case \<Rightarrow> rule16_claim_type2 \<Rightarrow> rule16_case \<Rightarrow> reimbursement_result" where
  "rule_16_evaluate_gated_by_claim_type2 c3 c4 ct c \<equiv>
    gate_reimbursement_result c3 c4 (rule_16_evaluate_by_claim_type2 ct c)"

end
