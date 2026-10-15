theory mcbr_case_02
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "crosses_without_reflection_stamp actor"
and f2: "border_lantern_turns_blue actor"
and f3: "cargo_vanishes_in_mirror actor"
and f4: "\<not> passes_unlit_mirror_gate actor"
and f5: "\<not> carries_shadowless_box actor"
and f6: "\<not> switches_left_right_labels actor"
and f7: "\<not> attaches_reversed_crescent_tag actor"
and f8: "\<not> cargo_moves_after_label_change actor"
and f9: "\<not> holds_silver_customs_token actor"
and f10: "\<not> customs_clock_records_arrival actor"
and f11: "\<not> mirror_officer_confirms_token actor"
and f12: "\<not> broken_mirror_alarm_sounds actor"
and f13: "\<not> transfers_cargo_for_rescue actor"
and f14: "\<not> rescue_logged_at_gate actor"
and f15: "\<not> cargo_returned_to_origin actor"
and f16: "\<not> return_receipt_issued actor"
and f17: "\<not> crate_seal_matches_origin actor"

lemma derive_mirror_crossing: "mirror_crossing actor"
  using f2 f1
  unfolding mirror_crossing_def
  by simp
lemma derive_shadow_cargo_irregularity: "shadow_cargo_irregularity actor"
  using f3
  unfolding shadow_cargo_irregularity_def
  by simp
lemma derive_unregistered_mirror_crossing_basis: "unregistered_mirror_crossing_basis actor"
  using derive_mirror_crossing
  unfolding unregistered_mirror_crossing_basis_def
  by simp
lemma derive_shadow_cargo_irregularity_basis: "shadow_cargo_irregularity_basis actor"
  using derive_mirror_crossing derive_shadow_cargo_irregularity
  unfolding shadow_cargo_irregularity_basis_def
  by simp
lemma trigger_art_unregistered_mirror_crossing: "article_triggered Art_Unregistered_Mirror_Crossing actor"
  using derive_unregistered_mirror_crossing_basis
  by simp
lemma trigger_art_shadow_cargo_irregularity: "article_triggered Art_Shadow_Cargo_Irregularity actor"
  using derive_shadow_cargo_irregularity_basis
  by simp

lemma overrides_art_shadow_cargo_irregularity_art_unregistered_mirror_crossing: "overrides Art_Shadow_Cargo_Irregularity Art_Unregistered_Mirror_Crossing"
  unfolding overrides_def
  by simp

lemma not_trigger_art_label_inversion: "\<not> article_triggered Art_Label_Inversion actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps label_inversion_basis_def shadow_cargo_irregularity_def label_inversion_def
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

lemma not_defeated_art_shadow_cargo_irregularity: "\<not> defeated actor Art_Shadow_Cargo_Irregularity"
proof
  assume defeated_assm: "defeated actor Art_Shadow_Cargo_Irregularity"
  then obtain higher where
    higher_triggered: "article_triggered higher actor"
    and higher_overrides: "overrides higher Art_Shadow_Cargo_Irregularity"
    unfolding defeated_def by blast
  then show False
    using not_trigger_art_label_inversion not_trigger_art_customs_clearance_authorization not_trigger_art_mirror_rescue_transfer not_trigger_art_returned_cargo_allowance
    unfolding overrides_def
    by (cases higher) auto
qed
lemma applicable_art_shadow_cargo_irregularity: "applicable actor Art_Shadow_Cargo_Irregularity"
  using trigger_art_shadow_cargo_irregularity not_defeated_art_shadow_cargo_irregularity
  unfolding applicable_def
  by blast
lemma defeated_art_unregistered_mirror_crossing: "defeated actor Art_Unregistered_Mirror_Crossing"
  using trigger_art_unregistered_mirror_crossing trigger_art_shadow_cargo_irregularity overrides_art_shadow_cargo_irregularity_art_unregistered_mirror_crossing
  unfolding defeated_def
  by blast
lemma not_applicable_art_unregistered_mirror_crossing: "\<not> applicable actor Art_Unregistered_Mirror_Crossing"
  using trigger_art_unregistered_mirror_crossing defeated_art_unregistered_mirror_crossing
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
theorem final_result_liability: "final_legal_result_holds actor shadow_cargo_hold"
  using applicable_art_shadow_cargo_irregularity not_final_no_liability
  unfolding final_legal_result_holds_def
  by auto

end
