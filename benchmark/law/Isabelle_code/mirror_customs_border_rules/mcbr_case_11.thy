theory mcbr_case_11
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "carries_shadowless_box actor"
and f2: "switches_left_right_labels actor"
and f3: "cargo_moves_after_label_change actor"
and f4: "\<not> passes_unlit_mirror_gate actor"
and f5: "\<not> crosses_without_reflection_stamp actor"
and f6: "\<not> border_lantern_turns_blue actor"
and f7: "\<not> cargo_vanishes_in_mirror actor"
and f8: "\<not> attaches_reversed_crescent_tag actor"
and f9: "\<not> holds_silver_customs_token actor"
and f10: "\<not> customs_clock_records_arrival actor"
and f11: "\<not> mirror_officer_confirms_token actor"
and f12: "\<not> broken_mirror_alarm_sounds actor"
and f13: "\<not> transfers_cargo_for_rescue actor"
and f14: "\<not> rescue_logged_at_gate actor"
and f15: "\<not> cargo_returned_to_origin actor"
and f16: "\<not> return_receipt_issued actor"
and f17: "\<not> crate_seal_matches_origin actor"

lemma derive_shadow_cargo_irregularity: "shadow_cargo_irregularity actor"
  using f1
  unfolding shadow_cargo_irregularity_def
  by simp
lemma derive_label_inversion: "label_inversion actor"
  using f3 f2
  unfolding label_inversion_def
  by simp
lemma derive_label_inversion_basis: "label_inversion_basis actor"
  using derive_shadow_cargo_irregularity derive_label_inversion
  unfolding label_inversion_basis_def
  by simp
lemma trigger_art_label_inversion: "article_triggered Art_Label_Inversion actor"
  using derive_label_inversion_basis
  by simp


lemma not_trigger_art_customs_clearance_authorization: "\<not> article_triggered Art_Customs_Clearance_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps customs_clearance_authorization_basis_def customs_clearance_def mirror_crossing_def
  by simp
lemma not_trigger_art_mirror_rescue_transfer: "\<not> article_triggered Art_Mirror_Rescue_Transfer actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps mirror_rescue_transfer_basis_def mirror_rescue_transfer_def mirror_crossing_def
  by simp
lemma not_trigger_art_returned_cargo_allowance: "\<not> article_triggered Art_Returned_Cargo_Allowance actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps returned_cargo_allowance_basis_def returned_cargo_record_def shadow_cargo_irregularity_def
  by simp

lemma not_defeated_art_label_inversion: "\<not> defeated actor Art_Label_Inversion"
proof
  assume defeated_assm: "defeated actor Art_Label_Inversion"
  then obtain higher where
    higher_triggered: "article_triggered higher actor"
    and higher_overrides: "overrides higher Art_Label_Inversion"
    unfolding defeated_def by blast
  then show False
    using not_trigger_art_mirror_rescue_transfer
    unfolding overrides_def
    by (cases higher) auto
qed
lemma applicable_art_label_inversion: "applicable actor Art_Label_Inversion"
  using trigger_art_label_inversion not_defeated_art_label_inversion
  unfolding applicable_def
  by blast

lemma not_applicable_art_customs_clearance_authorization: "\<not> applicable actor Art_Customs_Clearance_Authorization"
  using not_trigger_art_customs_clearance_authorization
  unfolding applicable_def
  by blast
lemma not_applicable_art_mirror_rescue_transfer: "\<not> applicable actor Art_Mirror_Rescue_Transfer"
  using not_trigger_art_mirror_rescue_transfer
  unfolding applicable_def
  by blast
lemma not_applicable_art_returned_cargo_allowance: "\<not> applicable actor Art_Returned_Cargo_Allowance"
  using not_trigger_art_returned_cargo_allowance
  unfolding applicable_def
  by blast

lemma not_final_no_liability: "\<not> final_no_liability actor"
proof
  assume final_no_liability_assm: "final_no_liability actor"
  then obtain art where
    art_applicable: "applicable actor art"
    and art_result: "article_result art = No_Criminal_Liability"
    unfolding final_no_liability_def by blast
  show False
    using art_applicable art_result not_applicable_art_customs_clearance_authorization not_applicable_art_mirror_rescue_transfer not_applicable_art_returned_cargo_allowance
    by (cases art) auto
qed
theorem final_result_liability: "final_legal_result_holds actor inversion_ledger_sealing"
  using applicable_art_label_inversion not_final_no_liability
  unfolding final_legal_result_holds_def
  by auto

end
