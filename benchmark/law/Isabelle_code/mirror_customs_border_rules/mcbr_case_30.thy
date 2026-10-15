theory mcbr_case_30
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "crosses_without_reflection_stamp actor"
and f2: "border_lantern_turns_blue actor"
and f3: "cargo_vanishes_in_mirror actor"
and f4: "broken_mirror_alarm_sounds actor"
and f5: "transfers_cargo_for_rescue actor"
and f6: "rescue_logged_at_gate actor"
and f7: "\<not> passes_unlit_mirror_gate actor"
and f8: "\<not> carries_shadowless_box actor"
and f9: "\<not> switches_left_right_labels actor"
and f10: "\<not> attaches_reversed_crescent_tag actor"
and f11: "\<not> cargo_moves_after_label_change actor"
and f12: "\<not> holds_silver_customs_token actor"
and f13: "\<not> customs_clock_records_arrival actor"
and f14: "\<not> mirror_officer_confirms_token actor"
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
lemma derive_mirror_rescue_transfer: "mirror_rescue_transfer actor"
  using f4 f5 f6
  unfolding mirror_rescue_transfer_def
  by simp
lemma derive_shadow_cargo_irregularity_basis: "shadow_cargo_irregularity_basis actor"
  using derive_mirror_crossing derive_shadow_cargo_irregularity
  unfolding shadow_cargo_irregularity_basis_def
  by simp
lemma derive_mirror_rescue_transfer_basis: "mirror_rescue_transfer_basis actor"
  using derive_mirror_rescue_transfer derive_mirror_crossing
  unfolding mirror_rescue_transfer_basis_def
  by simp
lemma trigger_art_shadow_cargo_irregularity: "article_triggered Art_Shadow_Cargo_Irregularity actor"
  using derive_shadow_cargo_irregularity_basis
  by simp
lemma trigger_art_mirror_rescue_transfer: "article_triggered Art_Mirror_Rescue_Transfer actor"
  using derive_mirror_rescue_transfer_basis
  by simp

lemma overrides_art_mirror_rescue_transfer_art_shadow_cargo_irregularity: "overrides Art_Mirror_Rescue_Transfer Art_Shadow_Cargo_Irregularity"
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
lemma defeated_art_shadow_cargo_irregularity: "defeated actor Art_Shadow_Cargo_Irregularity"
  using trigger_art_shadow_cargo_irregularity trigger_art_mirror_rescue_transfer overrides_art_mirror_rescue_transfer_art_shadow_cargo_irregularity
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
