theory mcbr_case_19
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "passes_unlit_mirror_gate actor"
and f2: "border_lantern_turns_blue actor"
and f3: "carries_shadowless_box actor"
and f4: "switches_left_right_labels actor"
and f5: "cargo_moves_after_label_change actor"
and f6: "broken_mirror_alarm_sounds actor"
and f7: "transfers_cargo_for_rescue actor"
and f8: "rescue_logged_at_gate actor"
and f9: "cargo_returned_to_origin actor"
and f10: "return_receipt_issued actor"
and f11: "crate_seal_matches_origin actor"
and f12: "\<not> crosses_without_reflection_stamp actor"
and f13: "\<not> cargo_vanishes_in_mirror actor"
and f14: "\<not> attaches_reversed_crescent_tag actor"
and f15: "\<not> holds_silver_customs_token actor"
and f16: "\<not> customs_clock_records_arrival actor"
and f17: "\<not> mirror_officer_confirms_token actor"

lemma derive_mirror_crossing: "mirror_crossing actor"
  using f2 f1
  unfolding mirror_crossing_def
  by simp
lemma derive_shadow_cargo_irregularity: "shadow_cargo_irregularity actor"
  using f3
  unfolding shadow_cargo_irregularity_def
  by simp
lemma derive_label_inversion: "label_inversion actor"
  using f5 f4
  unfolding label_inversion_def
  by simp
lemma derive_mirror_rescue_transfer: "mirror_rescue_transfer actor"
  using f6 f7 f8
  unfolding mirror_rescue_transfer_def
  by simp
lemma derive_returned_cargo_record: "returned_cargo_record actor"
  using f9 f10 f11
  unfolding returned_cargo_record_def
  by simp
lemma derive_shadow_cargo_irregularity_basis: "shadow_cargo_irregularity_basis actor"
  using derive_mirror_crossing derive_shadow_cargo_irregularity
  unfolding shadow_cargo_irregularity_basis_def
  by simp
lemma derive_label_inversion_basis: "label_inversion_basis actor"
  using derive_shadow_cargo_irregularity derive_label_inversion
  unfolding label_inversion_basis_def
  by simp
lemma derive_mirror_rescue_transfer_basis: "mirror_rescue_transfer_basis actor"
  using derive_mirror_rescue_transfer derive_mirror_crossing
  unfolding mirror_rescue_transfer_basis_def
  by simp
lemma derive_returned_cargo_allowance_basis: "returned_cargo_allowance_basis actor"
  using derive_returned_cargo_record derive_shadow_cargo_irregularity
  unfolding returned_cargo_allowance_basis_def
  by simp
lemma trigger_art_shadow_cargo_irregularity: "article_triggered Art_Shadow_Cargo_Irregularity actor"
  using derive_shadow_cargo_irregularity_basis
  by simp
lemma trigger_art_label_inversion: "article_triggered Art_Label_Inversion actor"
  using derive_label_inversion_basis
  by simp
lemma trigger_art_mirror_rescue_transfer: "article_triggered Art_Mirror_Rescue_Transfer actor"
  using derive_mirror_rescue_transfer_basis
  by simp
lemma trigger_art_returned_cargo_allowance: "article_triggered Art_Returned_Cargo_Allowance actor"
  using derive_returned_cargo_allowance_basis
  by simp

lemma overrides_art_label_inversion_art_shadow_cargo_irregularity: "overrides Art_Label_Inversion Art_Shadow_Cargo_Irregularity"
  unfolding overrides_def
  by simp
lemma overrides_art_mirror_rescue_transfer_art_shadow_cargo_irregularity: "overrides Art_Mirror_Rescue_Transfer Art_Shadow_Cargo_Irregularity"
  unfolding overrides_def
  by simp
lemma overrides_art_mirror_rescue_transfer_art_label_inversion: "overrides Art_Mirror_Rescue_Transfer Art_Label_Inversion"
  unfolding overrides_def
  by simp
lemma overrides_art_returned_cargo_allowance_art_shadow_cargo_irregularity: "overrides Art_Returned_Cargo_Allowance Art_Shadow_Cargo_Irregularity"
  unfolding overrides_def
  by simp


lemma not_defeated_art_mirror_rescue_transfer: "\<not> defeated actor Art_Mirror_Rescue_Transfer"
  using trigger_art_mirror_rescue_transfer
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_mirror_rescue_transfer: "applicable actor Art_Mirror_Rescue_Transfer"
  using trigger_art_mirror_rescue_transfer not_defeated_art_mirror_rescue_transfer
  unfolding applicable_def
  by blast
lemma defeated_art_label_inversion: "defeated actor Art_Label_Inversion"
  using trigger_art_label_inversion trigger_art_mirror_rescue_transfer overrides_art_mirror_rescue_transfer_art_label_inversion
  unfolding defeated_def
  by blast
lemma not_applicable_art_label_inversion: "\<not> applicable actor Art_Label_Inversion"
  using trigger_art_label_inversion defeated_art_label_inversion
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
  using trigger_art_shadow_cargo_irregularity trigger_art_label_inversion overrides_art_label_inversion_art_shadow_cargo_irregularity
  unfolding defeated_def
  by blast
lemma not_applicable_art_shadow_cargo_irregularity: "\<not> applicable actor Art_Shadow_Cargo_Irregularity"
  using trigger_art_shadow_cargo_irregularity defeated_art_shadow_cargo_irregularity
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_mirror_rescue_transfer
  unfolding final_no_liability_def
  by auto

end
