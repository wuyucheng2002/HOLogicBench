theory ohsr_case_20
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "unlatches_pressure_console actor"
and f2: "airlock_cycle_unlogged actor"
and f3: "turns_off_yellow_corridor_lamp actor"
and f4: "crew_member_crosses_corridor actor"
and f5: "holds_habitat_duty_permit actor"
and f6: "central_log_confirms_permit actor"
and f7: "maintenance_box_drifts_outside actor"
and f8: "rescue_tether_deployed actor"
and f9: "vents_air_temporarily actor"
and f10: "\<not> opens_outer_ring_airlock actor"
and f11: "\<not> skips_cycle_entry actor"
and f12: "\<not> removes_algae_oxygen_filter actor"
and f13: "\<not> removes_backup_oxygen_tab actor"
and f14: "\<not> cabin_pressure_drops actor"
and f15: "\<not> pressure_alarm_sounds actor"
and f16: "\<not> restores_pressure_after_venting actor"
and f17: "\<not> reports_stabilization_to_core actor"

lemma derive_restricted_airlock_operation: "restricted_airlock_operation actor"
  using f1 f2
  unfolding restricted_airlock_operation_def
  by simp
lemma derive_corridor_safety_obstruction: "corridor_safety_obstruction actor"
  using f3 f4
  unfolding corridor_safety_obstruction_def
  by simp
lemma derive_habitat_authority: "habitat_authority actor"
  using f5 f6
  unfolding habitat_authority_def
  by simp
lemma derive_salvage_emergency: "salvage_emergency actor"
  using f7 f8 f9
  unfolding salvage_emergency_def
  by simp
lemma derive_restricted_airlock_operation_basis: "restricted_airlock_operation_basis actor"
  using derive_restricted_airlock_operation
  unfolding restricted_airlock_operation_basis_def
  by simp
lemma derive_corridor_safety_obstruction_basis: "corridor_safety_obstruction_basis actor"
  using derive_restricted_airlock_operation derive_corridor_safety_obstruction
  unfolding corridor_safety_obstruction_basis_def
  by simp
lemma derive_habitat_duty_authorization_basis: "habitat_duty_authorization_basis actor"
  using derive_habitat_authority derive_restricted_airlock_operation
  unfolding habitat_duty_authorization_basis_def
  by simp
lemma derive_salvage_emergency_authorization_basis: "salvage_emergency_authorization_basis actor"
  using derive_salvage_emergency derive_restricted_airlock_operation
  unfolding salvage_emergency_authorization_basis_def
  by simp
lemma trigger_art_restricted_airlock_operation: "article_triggered Art_Restricted_Airlock_Operation actor"
  using derive_restricted_airlock_operation_basis
  by simp
lemma trigger_art_corridor_safety_obstruction: "article_triggered Art_Corridor_Safety_Obstruction actor"
  using derive_corridor_safety_obstruction_basis
  by simp
lemma trigger_art_habitat_duty_authorization: "article_triggered Art_Habitat_Duty_Authorization actor"
  using derive_habitat_duty_authorization_basis
  by simp
lemma trigger_art_salvage_emergency_authorization: "article_triggered Art_Salvage_Emergency_Authorization actor"
  using derive_salvage_emergency_authorization_basis
  by simp

lemma overrides_art_corridor_safety_obstruction_art_restricted_airlock_operation: "overrides Art_Corridor_Safety_Obstruction Art_Restricted_Airlock_Operation"
  unfolding overrides_def
  by simp
lemma overrides_art_habitat_duty_authorization_art_restricted_airlock_operation: "overrides Art_Habitat_Duty_Authorization Art_Restricted_Airlock_Operation"
  unfolding overrides_def
  by simp
lemma overrides_art_habitat_duty_authorization_art_corridor_safety_obstruction: "overrides Art_Habitat_Duty_Authorization Art_Corridor_Safety_Obstruction"
  unfolding overrides_def
  by simp
lemma overrides_art_salvage_emergency_authorization_art_restricted_airlock_operation: "overrides Art_Salvage_Emergency_Authorization Art_Restricted_Airlock_Operation"
  unfolding overrides_def
  by simp


lemma not_defeated_art_habitat_duty_authorization: "\<not> defeated actor Art_Habitat_Duty_Authorization"
  using trigger_art_habitat_duty_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_habitat_duty_authorization: "applicable actor Art_Habitat_Duty_Authorization"
  using trigger_art_habitat_duty_authorization not_defeated_art_habitat_duty_authorization
  unfolding applicable_def
  by blast
lemma defeated_art_corridor_safety_obstruction: "defeated actor Art_Corridor_Safety_Obstruction"
  using trigger_art_corridor_safety_obstruction trigger_art_habitat_duty_authorization overrides_art_habitat_duty_authorization_art_corridor_safety_obstruction
  unfolding defeated_def
  by blast
lemma not_applicable_art_corridor_safety_obstruction: "\<not> applicable actor Art_Corridor_Safety_Obstruction"
  using trigger_art_corridor_safety_obstruction defeated_art_corridor_safety_obstruction
  unfolding applicable_def
  by blast
lemma not_defeated_art_salvage_emergency_authorization: "\<not> defeated actor Art_Salvage_Emergency_Authorization"
  using trigger_art_salvage_emergency_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_salvage_emergency_authorization: "applicable actor Art_Salvage_Emergency_Authorization"
  using trigger_art_salvage_emergency_authorization not_defeated_art_salvage_emergency_authorization
  unfolding applicable_def
  by blast
lemma defeated_art_restricted_airlock_operation: "defeated actor Art_Restricted_Airlock_Operation"
  using trigger_art_restricted_airlock_operation trigger_art_corridor_safety_obstruction overrides_art_corridor_safety_obstruction_art_restricted_airlock_operation
  unfolding defeated_def
  by blast
lemma not_applicable_art_restricted_airlock_operation: "\<not> applicable actor Art_Restricted_Airlock_Operation"
  using trigger_art_restricted_airlock_operation defeated_art_restricted_airlock_operation
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_habitat_duty_authorization
  unfolding final_no_liability_def
  by auto

end
