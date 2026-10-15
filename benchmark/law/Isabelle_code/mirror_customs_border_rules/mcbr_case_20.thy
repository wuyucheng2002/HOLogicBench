theory mcbr_case_20
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "crosses_without_reflection_stamp actor"
and f2: "border_lantern_turns_blue actor"
and f3: "cargo_vanishes_in_mirror actor"
and f4: "holds_silver_customs_token actor"
and f5: "customs_clock_records_arrival actor"
and f6: "mirror_officer_confirms_token actor"
and f7: "cargo_returned_to_origin actor"
and f8: "return_receipt_issued actor"
and f9: "crate_seal_matches_origin actor"
and f10: "\<not> passes_unlit_mirror_gate actor"
and f11: "\<not> carries_shadowless_box actor"
and f12: "\<not> switches_left_right_labels actor"
and f13: "\<not> attaches_reversed_crescent_tag actor"
and f14: "\<not> cargo_moves_after_label_change actor"
and f15: "\<not> broken_mirror_alarm_sounds actor"
and f16: "\<not> transfers_cargo_for_rescue actor"
and f17: "\<not> rescue_logged_at_gate actor"

lemma derive_mirror_crossing: "mirror_crossing actor"
  using f2 f1
  unfolding mirror_crossing_def
  by simp
lemma derive_shadow_cargo_irregularity: "shadow_cargo_irregularity actor"
  using f3
  unfolding shadow_cargo_irregularity_def
  by simp
lemma derive_customs_clearance: "customs_clearance actor"
  using f4 f5 f6
  unfolding customs_clearance_def
  by simp
lemma derive_returned_cargo_record: "returned_cargo_record actor"
  using f7 f8 f9
  unfolding returned_cargo_record_def
  by simp
lemma derive_unregistered_mirror_crossing_basis: "unregistered_mirror_crossing_basis actor"
  using derive_mirror_crossing
  unfolding unregistered_mirror_crossing_basis_def
  by simp
lemma derive_shadow_cargo_irregularity_basis: "shadow_cargo_irregularity_basis actor"
  using derive_mirror_crossing derive_shadow_cargo_irregularity
  unfolding shadow_cargo_irregularity_basis_def
  by simp
lemma derive_customs_clearance_authorization_basis: "customs_clearance_authorization_basis actor"
  using derive_customs_clearance derive_mirror_crossing
  unfolding customs_clearance_authorization_basis_def
  by simp
lemma derive_returned_cargo_allowance_basis: "returned_cargo_allowance_basis actor"
  using derive_returned_cargo_record derive_shadow_cargo_irregularity
  unfolding returned_cargo_allowance_basis_def
  by simp
lemma trigger_art_unregistered_mirror_crossing: "article_triggered Art_Unregistered_Mirror_Crossing actor"
  using derive_unregistered_mirror_crossing_basis
  by simp
lemma trigger_art_shadow_cargo_irregularity: "article_triggered Art_Shadow_Cargo_Irregularity actor"
  using derive_shadow_cargo_irregularity_basis
  by simp
lemma trigger_art_customs_clearance_authorization: "article_triggered Art_Customs_Clearance_Authorization actor"
  using derive_customs_clearance_authorization_basis
  by simp
lemma trigger_art_returned_cargo_allowance: "article_triggered Art_Returned_Cargo_Allowance actor"
  using derive_returned_cargo_allowance_basis
  by simp

lemma overrides_art_shadow_cargo_irregularity_art_unregistered_mirror_crossing: "overrides Art_Shadow_Cargo_Irregularity Art_Unregistered_Mirror_Crossing"
  unfolding overrides_def
  by simp
lemma overrides_art_customs_clearance_authorization_art_unregistered_mirror_crossing: "overrides Art_Customs_Clearance_Authorization Art_Unregistered_Mirror_Crossing"
  unfolding overrides_def
  by simp
lemma overrides_art_customs_clearance_authorization_art_shadow_cargo_irregularity: "overrides Art_Customs_Clearance_Authorization Art_Shadow_Cargo_Irregularity"
  unfolding overrides_def
  by simp
lemma overrides_art_returned_cargo_allowance_art_shadow_cargo_irregularity: "overrides Art_Returned_Cargo_Allowance Art_Shadow_Cargo_Irregularity"
  unfolding overrides_def
  by simp


lemma not_defeated_art_customs_clearance_authorization: "\<not> defeated actor Art_Customs_Clearance_Authorization"
  using trigger_art_customs_clearance_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_customs_clearance_authorization: "applicable actor Art_Customs_Clearance_Authorization"
  using trigger_art_customs_clearance_authorization not_defeated_art_customs_clearance_authorization
  unfolding applicable_def
  by blast
lemma not_defeated_art_returned_cargo_allowance: "\<not> defeated actor Art_Returned_Cargo_Allowance"
  using trigger_art_returned_cargo_allowance
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_returned_cargo_allowance: "applicable actor Art_Returned_Cargo_Allowance"
  using trigger_art_returned_cargo_allowance not_defeated_art_returned_cargo_allowance
  unfolding applicable_def
  by blast
lemma defeated_art_shadow_cargo_irregularity: "defeated actor Art_Shadow_Cargo_Irregularity"
  using trigger_art_shadow_cargo_irregularity trigger_art_customs_clearance_authorization overrides_art_customs_clearance_authorization_art_shadow_cargo_irregularity
  unfolding defeated_def
  by blast
lemma not_applicable_art_shadow_cargo_irregularity: "\<not> applicable actor Art_Shadow_Cargo_Irregularity"
  using trigger_art_shadow_cargo_irregularity defeated_art_shadow_cargo_irregularity
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


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_customs_clearance_authorization
  unfolding final_no_liability_def
  by auto

end
