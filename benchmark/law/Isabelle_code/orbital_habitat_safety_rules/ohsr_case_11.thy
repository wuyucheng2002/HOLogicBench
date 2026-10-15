theory ohsr_case_11
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
and f6: "\<not> unlatches_pressure_console actor"
and f7: "\<not> airlock_cycle_unlogged actor"
and f8: "\<not> removes_backup_oxygen_tab actor"
and f9: "\<not> turns_off_yellow_corridor_lamp actor"
and f10: "\<not> crew_member_crosses_corridor actor"
and f11: "\<not> holds_habitat_duty_permit actor"
and f12: "\<not> central_log_confirms_permit actor"
and f13: "\<not> maintenance_box_drifts_outside actor"
and f14: "\<not> rescue_tether_deployed actor"
and f15: "\<not> vents_air_temporarily actor"
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
lemma derive_oxygen_system_interference_basis: "oxygen_system_interference_basis actor"
  using derive_restricted_airlock_operation derive_oxygen_system_interference
  unfolding oxygen_system_interference_basis_def
  by simp
lemma trigger_art_oxygen_system_interference: "article_triggered Art_Oxygen_System_Interference actor"
  using derive_oxygen_system_interference_basis
  by simp


lemma not_trigger_art_habitat_duty_authorization: "\<not> article_triggered Art_Habitat_Duty_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps habitat_duty_authorization_basis_def habitat_authority_def restricted_airlock_operation_def
  by simp
lemma not_trigger_art_salvage_emergency_authorization: "\<not> article_triggered Art_Salvage_Emergency_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps salvage_emergency_authorization_basis_def salvage_emergency_def restricted_airlock_operation_def
  by simp
lemma not_trigger_art_pressure_stabilization_exemption: "\<not> article_triggered Art_Pressure_Stabilization_Exemption actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps pressure_stabilization_exemption_basis_def pressure_stabilization_def oxygen_system_interference_def
  by simp

lemma not_defeated_art_oxygen_system_interference: "\<not> defeated actor Art_Oxygen_System_Interference"
proof
  assume defeated_assm: "defeated actor Art_Oxygen_System_Interference"
  then obtain higher where
    higher_triggered: "article_triggered higher actor"
    and higher_overrides: "overrides higher Art_Oxygen_System_Interference"
    unfolding defeated_def by blast
  then show False
    using not_trigger_art_salvage_emergency_authorization not_trigger_art_pressure_stabilization_exemption
    unfolding overrides_def
    by (cases higher) auto
qed
lemma applicable_art_oxygen_system_interference: "applicable actor Art_Oxygen_System_Interference"
  using trigger_art_oxygen_system_interference not_defeated_art_oxygen_system_interference
  unfolding applicable_def
  by blast

lemma not_applicable_art_habitat_duty_authorization: "\<not> applicable actor Art_Habitat_Duty_Authorization"
  using not_trigger_art_habitat_duty_authorization
  unfolding applicable_def
  by blast
lemma not_applicable_art_salvage_emergency_authorization: "\<not> applicable actor Art_Salvage_Emergency_Authorization"
  using not_trigger_art_salvage_emergency_authorization
  unfolding applicable_def
  by blast
lemma not_applicable_art_pressure_stabilization_exemption: "\<not> applicable actor Art_Pressure_Stabilization_Exemption"
  using not_trigger_art_pressure_stabilization_exemption
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
    using art_applicable art_result not_applicable_art_habitat_duty_authorization not_applicable_art_salvage_emergency_authorization not_applicable_art_pressure_stabilization_exemption
    by (cases art) auto
qed
theorem final_result_liability: "final_legal_result_holds actor oxygen_bay_quarantine"
  using applicable_art_oxygen_system_interference not_final_no_liability
  unfolding final_legal_result_holds_def
  by auto

end
