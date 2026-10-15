theory mcbr_case_28
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "crosses_without_reflection_stamp actor"
and f2: "border_lantern_turns_blue actor"
and f3: "cargo_vanishes_in_mirror actor"
and f4: "attaches_reversed_crescent_tag actor"
and f5: "cargo_moves_after_label_change actor"
and f6: "cargo_returned_to_origin actor"
and f7: "return_receipt_issued actor"
and f8: "crate_seal_matches_origin actor"
and f9: "\<not> passes_unlit_mirror_gate actor"
and f10: "\<not> carries_shadowless_box actor"
and f11: "\<not> switches_left_right_labels actor"
and f12: "\<not> holds_silver_customs_token actor"
and f13: "\<not> customs_clock_records_arrival actor"
and f14: "\<not> mirror_officer_confirms_token actor"
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
lemma derive_label_inversion: "label_inversion actor"
  using f5 f4
  unfolding label_inversion_def
  by simp
lemma derive_returned_cargo_record: "returned_cargo_record actor"
  using f6 f7 f8
  unfolding returned_cargo_record_def
  by simp
lemma derive_unregistered_mirror_crossing_basis: "unregistered_mirror_crossing_basis actor"
  using derive_mirror_crossing
  unfolding unregistered_mirror_crossing_basis_def
  by simp
lemma derive_label_inversion_basis: "label_inversion_basis actor"
  using derive_shadow_cargo_irregularity derive_label_inversion
  unfolding label_inversion_basis_def
  by simp
lemma derive_returned_cargo_allowance_basis: "returned_cargo_allowance_basis actor"
  using derive_returned_cargo_record derive_shadow_cargo_irregularity
  unfolding returned_cargo_allowance_basis_def
  by simp
lemma trigger_art_unregistered_mirror_crossing: "article_triggered Art_Unregistered_Mirror_Crossing actor"
  using derive_unregistered_mirror_crossing_basis
  by simp
lemma trigger_art_label_inversion: "article_triggered Art_Label_Inversion actor"
  using derive_label_inversion_basis
  by simp
lemma trigger_art_returned_cargo_allowance: "article_triggered Art_Returned_Cargo_Allowance actor"
  using derive_returned_cargo_allowance_basis
  by simp

lemma overrides_art_label_inversion_art_unregistered_mirror_crossing: "overrides Art_Label_Inversion Art_Unregistered_Mirror_Crossing"
  unfolding overrides_def
  by simp

lemma not_trigger_art_mirror_rescue_transfer: "\<not> article_triggered Art_Mirror_Rescue_Transfer actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps mirror_rescue_transfer_basis_def mirror_rescue_transfer_def mirror_crossing_def
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
lemma defeated_art_unregistered_mirror_crossing: "defeated actor Art_Unregistered_Mirror_Crossing"
  using trigger_art_unregistered_mirror_crossing trigger_art_label_inversion overrides_art_label_inversion_art_unregistered_mirror_crossing
  unfolding defeated_def
  by blast
lemma not_applicable_art_unregistered_mirror_crossing: "\<not> applicable actor Art_Unregistered_Mirror_Crossing"
  using trigger_art_unregistered_mirror_crossing defeated_art_unregistered_mirror_crossing
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

lemma not_applicable_art_mirror_rescue_transfer: "\<not> applicable actor Art_Mirror_Rescue_Transfer"
  using not_trigger_art_mirror_rescue_transfer
  unfolding applicable_def
  by blast

theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_returned_cargo_allowance
  unfolding final_no_liability_def
  by auto

end
