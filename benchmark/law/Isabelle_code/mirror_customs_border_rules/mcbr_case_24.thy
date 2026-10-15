theory mcbr_case_24
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
and f6: "holds_silver_customs_token actor"
and f7: "customs_clock_records_arrival actor"
and f8: "mirror_officer_confirms_token actor"
and f9: "\<not> passes_unlit_mirror_gate actor"
and f10: "\<not> carries_shadowless_box actor"
and f11: "\<not> switches_left_right_labels actor"
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
lemma derive_label_inversion: "label_inversion actor"
  using f5 f4
  unfolding label_inversion_def
  by simp
lemma derive_customs_clearance: "customs_clearance actor"
  using f6 f7 f8
  unfolding customs_clearance_def
  by simp
lemma derive_shadow_cargo_irregularity_basis: "shadow_cargo_irregularity_basis actor"
  using derive_mirror_crossing derive_shadow_cargo_irregularity
  unfolding shadow_cargo_irregularity_basis_def
  by simp
lemma derive_label_inversion_basis: "label_inversion_basis actor"
  using derive_shadow_cargo_irregularity derive_label_inversion
  unfolding label_inversion_basis_def
  by simp
lemma derive_customs_clearance_authorization_basis: "customs_clearance_authorization_basis actor"
  using derive_customs_clearance derive_mirror_crossing
  unfolding customs_clearance_authorization_basis_def
  by simp
lemma trigger_art_shadow_cargo_irregularity: "article_triggered Art_Shadow_Cargo_Irregularity actor"
  using derive_shadow_cargo_irregularity_basis
  by simp
lemma trigger_art_label_inversion: "article_triggered Art_Label_Inversion actor"
  using derive_label_inversion_basis
  by simp
lemma trigger_art_customs_clearance_authorization: "article_triggered Art_Customs_Clearance_Authorization actor"
  using derive_customs_clearance_authorization_basis
  by simp

lemma overrides_art_label_inversion_art_shadow_cargo_irregularity: "overrides Art_Label_Inversion Art_Shadow_Cargo_Irregularity"
  unfolding overrides_def
  by simp
lemma overrides_art_customs_clearance_authorization_art_shadow_cargo_irregularity: "overrides Art_Customs_Clearance_Authorization Art_Shadow_Cargo_Irregularity"
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
lemma not_defeated_art_customs_clearance_authorization: "\<not> defeated actor Art_Customs_Clearance_Authorization"
  using trigger_art_customs_clearance_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_customs_clearance_authorization: "applicable actor Art_Customs_Clearance_Authorization"
  using trigger_art_customs_clearance_authorization not_defeated_art_customs_clearance_authorization
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

lemma not_applicable_art_mirror_rescue_transfer: "\<not> applicable actor Art_Mirror_Rescue_Transfer"
  using not_trigger_art_mirror_rescue_transfer
  unfolding applicable_def
  by blast

theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_customs_clearance_authorization
  unfolding final_no_liability_def
  by auto

end
