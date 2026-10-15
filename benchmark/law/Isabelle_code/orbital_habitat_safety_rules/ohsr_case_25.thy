theory ohsr_case_25
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "opens_outer_ring_airlock actor"
and f2: "skips_cycle_entry actor"
and f3: "removes_algae_oxygen_filter actor"
and f4: "cabin_pressure_drops actor"
and f5: "pressure_alarm_sounds actor"
and f6: "maintenance_box_drifts_outside actor"
and f7: "rescue_tether_deployed actor"
and f8: "vents_air_temporarily actor"
and f9: "\<not> unlatches_pressure_console actor"
and f10: "\<not> airlock_cycle_unlogged actor"
and f11: "\<not> removes_backup_oxygen_tab actor"
and f12: "\<not> turns_off_yellow_corridor_lamp actor"
and f13: "\<not> crew_member_crosses_corridor actor"
and f14: "\<not> holds_habitat_duty_permit actor"
and f15: "\<not> central_log_confirms_permit actor"
and f16: "\<not> restores_pressure_after_venting actor"
and f17: "\<not> reports_stabilization_to_core actor"

lemma derive_restricted_airlock_operation: "restricted_airlock_operation actor"
  using f1 f2
  unfolding restricted_airlock_operation_def
  by simp
lemma derive_oxygen_system_interference: "oxygen_system_interference actor"
  using f4 f5 f3
  unfolding oxygen_system_interference_def
  by simp
lemma derive_salvage_emergency: "salvage_emergency actor"
  using f6 f7 f8
  unfolding salvage_emergency_def
  by simp
lemma derive_restricted_airlock_operation_basis: "restricted_airlock_operation_basis actor"
  using derive_restricted_airlock_operation
  unfolding restricted_airlock_operation_basis_def
  by simp
lemma derive_oxygen_system_interference_basis: "oxygen_system_interference_basis actor"
  using derive_restricted_airlock_operation derive_oxygen_system_interference
  unfolding oxygen_system_interference_basis_def
  by simp
lemma derive_salvage_emergency_authorization_basis: "salvage_emergency_authorization_basis actor"
  using derive_salvage_emergency derive_restricted_airlock_operation
  unfolding salvage_emergency_authorization_basis_def
  by simp
lemma trigger_art_restricted_airlock_operation: "article_triggered Art_Restricted_Airlock_Operation actor"
  using derive_restricted_airlock_operation_basis
  by simp
lemma trigger_art_oxygen_system_interference: "article_triggered Art_Oxygen_System_Interference actor"
  using derive_oxygen_system_interference_basis
  by simp
lemma trigger_art_salvage_emergency_authorization: "article_triggered Art_Salvage_Emergency_Authorization actor"
  using derive_salvage_emergency_authorization_basis
  by simp

lemma overrides_art_oxygen_system_interference_art_restricted_airlock_operation: "overrides Art_Oxygen_System_Interference Art_Restricted_Airlock_Operation"
  unfolding overrides_def
  by simp
lemma overrides_art_salvage_emergency_authorization_art_restricted_airlock_operation: "overrides Art_Salvage_Emergency_Authorization Art_Restricted_Airlock_Operation"
  unfolding overrides_def
  by simp
lemma overrides_art_salvage_emergency_authorization_art_oxygen_system_interference: "overrides Art_Salvage_Emergency_Authorization Art_Oxygen_System_Interference"
  unfolding overrides_def
  by simp


lemma not_defeated_art_salvage_emergency_authorization: "\<not> defeated actor Art_Salvage_Emergency_Authorization"
  using trigger_art_salvage_emergency_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_salvage_emergency_authorization: "applicable actor Art_Salvage_Emergency_Authorization"
  using trigger_art_salvage_emergency_authorization not_defeated_art_salvage_emergency_authorization
  unfolding applicable_def
  by blast
lemma defeated_art_oxygen_system_interference: "defeated actor Art_Oxygen_System_Interference"
  using trigger_art_oxygen_system_interference trigger_art_salvage_emergency_authorization overrides_art_salvage_emergency_authorization_art_oxygen_system_interference
  unfolding defeated_def
  by blast
lemma not_applicable_art_oxygen_system_interference: "\<not> applicable actor Art_Oxygen_System_Interference"
  using trigger_art_oxygen_system_interference defeated_art_oxygen_system_interference
  unfolding applicable_def
  by blast
lemma defeated_art_restricted_airlock_operation: "defeated actor Art_Restricted_Airlock_Operation"
  using trigger_art_restricted_airlock_operation trigger_art_oxygen_system_interference overrides_art_oxygen_system_interference_art_restricted_airlock_operation
  unfolding defeated_def
  by blast
lemma not_applicable_art_restricted_airlock_operation: "\<not> applicable actor Art_Restricted_Airlock_Operation"
  using trigger_art_restricted_airlock_operation defeated_art_restricted_airlock_operation
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_salvage_emergency_authorization
  unfolding final_no_liability_def
  by auto

end
