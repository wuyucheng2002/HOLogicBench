theory arwre_case_18
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "bypasses_reading_room_desk actor"
and f2: "shelf_marked_restricted actor"
and f3: "places_relic_under_lamp actor"
and f4: "relic_tagged_fragile actor"
and f5: "swaps_archive_label actor"
and f6: "catalog_lock_active actor"
and f7: "leaves_building_with_archive_box actor"
and f8: "exit_alarm_active actor"
and f9: "\<not> enters_closed_stack actor"
and f10: "\<not> uses_unregistered_reader_card actor"
and f11: "\<not> curator_present actor"
and f12: "\<not> touches_relic_without_gloves actor"
and f13: "\<not> lifts_relic_from_cradle actor"
and f14: "\<not> changes_catalog_entry actor"
and f15: "\<not> deletes_condition_note actor"
and f16: "\<not> carries_relic_past_blue_line actor"
and f17: "\<not> seals_relic_in_private_case actor"
and f18: "\<not> has_curator_written_order actor"
and f19: "\<not> order_names_relic actor"
and f20: "\<not> logs_handling_time actor"
and f21: "\<not> flood_alarm_sounds actor"
and f22: "\<not> moves_item_to_dry_room actor"
and f23: "\<not> files_rescue_note actor"

lemma derive_unauthorized_stack_entry: "unauthorized_stack_entry actor"
  using f1
  unfolding unauthorized_stack_entry_def
  by simp
lemma derive_restricted_shelf_status: "restricted_shelf_status actor"
  using f2 f11
  unfolding restricted_shelf_status_def
  by simp
lemma derive_fragile_relic_handling: "fragile_relic_handling actor"
  using f4 f3
  unfolding fragile_relic_handling_def
  by simp
lemma derive_catalog_record_interference: "catalog_record_interference actor"
  using f6 f5
  unfolding catalog_record_interference_def
  by simp
lemma derive_vault_exit_step: "vault_exit_step actor"
  using f8 f7
  unfolding vault_exit_step_def
  by simp
lemma derive_restricted_shelf_violation: "restricted_shelf_violation actor"
  using derive_unauthorized_stack_entry derive_restricted_shelf_status
  unfolding restricted_shelf_violation_def
  by simp
lemma derive_relic_handling_violation: "relic_handling_violation actor"
  using derive_restricted_shelf_violation derive_fragile_relic_handling
  unfolding relic_handling_violation_def
  by simp
lemma derive_catalog_alteration_violation: "catalog_alteration_violation actor"
  using derive_restricted_shelf_violation derive_catalog_record_interference
  unfolding catalog_alteration_violation_def
  by simp
lemma derive_vault_removal_basis: "vault_removal_basis actor"
  using derive_relic_handling_violation derive_vault_exit_step
  unfolding vault_removal_basis_def
  by simp
lemma trigger_art_restricted_shelf_access: "article_triggered Art_Restricted_Shelf_Access actor"
  using derive_restricted_shelf_violation
  by simp
lemma trigger_art_catalog_alteration: "article_triggered Art_Catalog_Alteration actor"
  using derive_catalog_alteration_violation
  by simp
lemma trigger_art_vault_removal: "article_triggered Art_Vault_Removal actor"
  using derive_vault_removal_basis
  by simp

lemma overrides_art_catalog_alteration_art_restricted_shelf_access: "overrides Art_Catalog_Alteration Art_Restricted_Shelf_Access"
  unfolding overrides_def
  by simp
lemma overrides_art_vault_removal_art_restricted_shelf_access: "overrides Art_Vault_Removal Art_Restricted_Shelf_Access"
  unfolding overrides_def
  by simp
lemma overrides_art_vault_removal_art_catalog_alteration: "overrides Art_Vault_Removal Art_Catalog_Alteration"
  unfolding overrides_def
  by simp

lemma not_trigger_art_curator_order_authorization: "\<not> article_triggered Art_Curator_Order_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23
  unfolding article_triggered.simps curator_order_authorization_def relic_handling_violation_def restricted_shelf_violation_def unauthorized_stack_entry_def restricted_shelf_status_def fragile_relic_handling_def curator_authorization_records_def
  by simp
lemma not_trigger_art_flood_rescue_authorization: "\<not> article_triggered Art_Flood_Rescue_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23
  unfolding article_triggered.simps flood_rescue_authorization_def restricted_shelf_violation_def unauthorized_stack_entry_def restricted_shelf_status_def flood_rescue_records_def
  by simp

lemma not_defeated_art_vault_removal: "\<not> defeated actor Art_Vault_Removal"
proof
  assume defeated_assm: "defeated actor Art_Vault_Removal"
  then obtain higher where
    higher_triggered: "article_triggered higher actor"
    and higher_overrides: "overrides higher Art_Vault_Removal"
    unfolding defeated_def by blast
  then show False
    using not_trigger_art_flood_rescue_authorization
    unfolding overrides_def
    by (cases higher) auto
qed
lemma applicable_art_vault_removal: "applicable actor Art_Vault_Removal"
  using trigger_art_vault_removal not_defeated_art_vault_removal
  unfolding applicable_def
  by blast
lemma defeated_art_catalog_alteration: "defeated actor Art_Catalog_Alteration"
  using trigger_art_catalog_alteration trigger_art_vault_removal overrides_art_vault_removal_art_catalog_alteration
  unfolding defeated_def
  by blast
lemma not_applicable_art_catalog_alteration: "\<not> applicable actor Art_Catalog_Alteration"
  using trigger_art_catalog_alteration defeated_art_catalog_alteration
  unfolding applicable_def
  by blast
lemma defeated_art_restricted_shelf_access: "defeated actor Art_Restricted_Shelf_Access"
  using trigger_art_restricted_shelf_access trigger_art_catalog_alteration overrides_art_catalog_alteration_art_restricted_shelf_access
  unfolding defeated_def
  by blast
lemma not_applicable_art_restricted_shelf_access: "\<not> applicable actor Art_Restricted_Shelf_Access"
  using trigger_art_restricted_shelf_access defeated_art_restricted_shelf_access
  unfolding applicable_def
  by blast

lemma not_applicable_art_curator_order_authorization: "\<not> applicable actor Art_Curator_Order_Authorization"
  using not_trigger_art_curator_order_authorization
  unfolding applicable_def
  by blast
lemma not_applicable_art_flood_rescue_authorization: "\<not> applicable actor Art_Flood_Rescue_Authorization"
  using not_trigger_art_flood_rescue_authorization
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
    using art_applicable art_result not_applicable_art_curator_order_authorization not_applicable_art_flood_rescue_authorization
    by (cases art) auto
qed
theorem final_result_liability: "final_legal_result_holds actor permanent_archive_exclusion"
  using applicable_art_vault_removal not_final_no_liability
  unfolding final_legal_result_holds_def
  by auto

end
