theory arwre_case_07
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "enters_closed_stack actor"
and f2: "shelf_marked_restricted actor"
and f3: "touches_relic_without_gloves actor"
and f4: "relic_tagged_fragile actor"
and f5: "carries_relic_past_blue_line actor"
and f6: "exit_alarm_active actor"
and f7: "flood_alarm_sounds actor"
and f8: "moves_item_to_dry_room actor"
and f9: "files_rescue_note actor"
and f10: "\<not> uses_unregistered_reader_card actor"
and f11: "\<not> bypasses_reading_room_desk actor"
and f12: "\<not> curator_present actor"
and f13: "\<not> lifts_relic_from_cradle actor"
and f14: "\<not> places_relic_under_lamp actor"
and f15: "\<not> changes_catalog_entry actor"
and f16: "\<not> deletes_condition_note actor"
and f17: "\<not> swaps_archive_label actor"
and f18: "\<not> catalog_lock_active actor"
and f19: "\<not> seals_relic_in_private_case actor"
and f20: "\<not> leaves_building_with_archive_box actor"
and f21: "\<not> has_curator_written_order actor"
and f22: "\<not> order_names_relic actor"
and f23: "\<not> logs_handling_time actor"

lemma derive_unauthorized_stack_entry: "unauthorized_stack_entry actor"
  using f1
  unfolding unauthorized_stack_entry_def
  by simp
lemma derive_restricted_shelf_status: "restricted_shelf_status actor"
  using f2 f12
  unfolding restricted_shelf_status_def
  by simp
lemma derive_fragile_relic_handling: "fragile_relic_handling actor"
  using f4 f3
  unfolding fragile_relic_handling_def
  by simp
lemma derive_vault_exit_step: "vault_exit_step actor"
  using f6 f5
  unfolding vault_exit_step_def
  by simp
lemma derive_flood_rescue_records: "flood_rescue_records actor"
  using f7 f8 f9
  unfolding flood_rescue_records_def
  by simp
lemma derive_restricted_shelf_violation: "restricted_shelf_violation actor"
  using derive_unauthorized_stack_entry derive_restricted_shelf_status
  unfolding restricted_shelf_violation_def
  by simp
lemma derive_relic_handling_violation: "relic_handling_violation actor"
  using derive_restricted_shelf_violation derive_fragile_relic_handling
  unfolding relic_handling_violation_def
  by simp
lemma derive_vault_removal_basis: "vault_removal_basis actor"
  using derive_relic_handling_violation derive_vault_exit_step
  unfolding vault_removal_basis_def
  by simp
lemma derive_flood_rescue_authorization: "flood_rescue_authorization actor"
  using derive_restricted_shelf_violation derive_flood_rescue_records
  unfolding flood_rescue_authorization_def
  by simp
lemma trigger_art_restricted_shelf_access: "article_triggered Art_Restricted_Shelf_Access actor"
  using derive_restricted_shelf_violation
  by simp
lemma trigger_art_relic_handling_breach: "article_triggered Art_Relic_Handling_Breach actor"
  using derive_relic_handling_violation
  by simp
lemma trigger_art_vault_removal: "article_triggered Art_Vault_Removal actor"
  using derive_vault_removal_basis
  by simp
lemma trigger_art_flood_rescue_authorization: "article_triggered Art_Flood_Rescue_Authorization actor"
  using derive_flood_rescue_authorization
  by simp

lemma overrides_art_relic_handling_breach_art_restricted_shelf_access: "overrides Art_Relic_Handling_Breach Art_Restricted_Shelf_Access"
  unfolding overrides_def
  by simp
lemma overrides_art_vault_removal_art_restricted_shelf_access: "overrides Art_Vault_Removal Art_Restricted_Shelf_Access"
  unfolding overrides_def
  by simp
lemma overrides_art_vault_removal_art_relic_handling_breach: "overrides Art_Vault_Removal Art_Relic_Handling_Breach"
  unfolding overrides_def
  by simp
lemma overrides_art_flood_rescue_authorization_art_restricted_shelf_access: "overrides Art_Flood_Rescue_Authorization Art_Restricted_Shelf_Access"
  unfolding overrides_def
  by simp
lemma overrides_art_flood_rescue_authorization_art_relic_handling_breach: "overrides Art_Flood_Rescue_Authorization Art_Relic_Handling_Breach"
  unfolding overrides_def
  by simp
lemma overrides_art_flood_rescue_authorization_art_vault_removal: "overrides Art_Flood_Rescue_Authorization Art_Vault_Removal"
  unfolding overrides_def
  by simp


lemma defeated_art_vault_removal: "defeated actor Art_Vault_Removal"
  using trigger_art_vault_removal trigger_art_flood_rescue_authorization overrides_art_flood_rescue_authorization_art_vault_removal
  unfolding defeated_def
  by blast
lemma not_applicable_art_vault_removal: "\<not> applicable actor Art_Vault_Removal"
  using trigger_art_vault_removal defeated_art_vault_removal
  unfolding applicable_def
  by blast
lemma defeated_art_relic_handling_breach: "defeated actor Art_Relic_Handling_Breach"
  using trigger_art_relic_handling_breach trigger_art_vault_removal overrides_art_vault_removal_art_relic_handling_breach
  unfolding defeated_def
  by blast
lemma not_applicable_art_relic_handling_breach: "\<not> applicable actor Art_Relic_Handling_Breach"
  using trigger_art_relic_handling_breach defeated_art_relic_handling_breach
  unfolding applicable_def
  by blast
lemma defeated_art_restricted_shelf_access: "defeated actor Art_Restricted_Shelf_Access"
  using trigger_art_restricted_shelf_access trigger_art_relic_handling_breach overrides_art_relic_handling_breach_art_restricted_shelf_access
  unfolding defeated_def
  by blast
lemma not_applicable_art_restricted_shelf_access: "\<not> applicable actor Art_Restricted_Shelf_Access"
  using trigger_art_restricted_shelf_access defeated_art_restricted_shelf_access
  unfolding applicable_def
  by blast
lemma not_defeated_art_flood_rescue_authorization: "\<not> defeated actor Art_Flood_Rescue_Authorization"
  using trigger_art_flood_rescue_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_flood_rescue_authorization: "applicable actor Art_Flood_Rescue_Authorization"
  using trigger_art_flood_rescue_authorization not_defeated_art_flood_rescue_authorization
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_flood_rescue_authorization
  unfolding final_no_liability_def
  by auto

end
