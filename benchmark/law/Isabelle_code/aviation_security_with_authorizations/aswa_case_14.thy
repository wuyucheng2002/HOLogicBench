theory aswa_case_14
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "uses_expired_airport_badge actor"
and f2: "airside_area_marked_restricted actor"
and f3: "pilots_drone_above_service_road actor"
and f4: "runway_lights_active actor"
and f5: "jams_tower_channel actor"
and f6: "pilot_warning_received actor"
and f7: "\<not> enters_airside_gate_without_badge actor"
and f8: "\<not> follows_service_vehicle_through_gate actor"
and f9: "\<not> escort_officer_present actor"
and f10: "\<not> launches_drone_near_runway actor"
and f11: "\<not> transmits_unlicensed_beacon actor"
and f12: "\<not> has_maintenance_work_order actor"
and f13: "\<not> stays_within_assigned_zone actor"
and f14: "\<not> logs_exit_before_closure actor"
and f15: "\<not> medical_diversion_announced actor"
and f16: "\<not> follows_rescue_controller_route actor"
and f17: "\<not> carries_patient_transfer_form actor"

lemma derive_prohibited_airside_entry: "prohibited_airside_entry actor"
  using f1
  unfolding prohibited_airside_entry_def
  by simp
lemma derive_restricted_airside_status: "restricted_airside_status actor"
  using f2 f9
  unfolding restricted_airside_status_def
  by simp
lemma derive_runway_drone_operation: "runway_drone_operation actor"
  using f3
  unfolding runway_drone_operation_def
  by simp
lemma derive_active_runway_risk: "active_runway_risk actor"
  using f4
  unfolding active_runway_risk_def
  by simp
lemma derive_signal_interference_conduct: "signal_interference_conduct actor"
  using f5
  unfolding signal_interference_conduct_def
  by simp
lemma derive_aviation_warning_effect: "aviation_warning_effect actor"
  using f6
  unfolding aviation_warning_effect_def
  by simp
lemma derive_airside_access_violation: "airside_access_violation actor"
  using derive_prohibited_airside_entry derive_restricted_airside_status
  unfolding airside_access_violation_def
  by simp
lemma derive_runway_drone_interference: "runway_drone_interference actor"
  using derive_airside_access_violation derive_runway_drone_operation derive_active_runway_risk
  unfolding runway_drone_interference_def
  by simp
lemma derive_navigation_signal_interference: "navigation_signal_interference actor"
  using derive_signal_interference_conduct derive_aviation_warning_effect
  unfolding navigation_signal_interference_def
  by simp
lemma derive_compound_airspace_hazard: "compound_airspace_hazard actor"
  using derive_runway_drone_interference derive_navigation_signal_interference
  unfolding compound_airspace_hazard_def
  by simp
lemma trigger_art_navigation_signal_interference: "article_triggered Art_Navigation_Signal_Interference actor"
  using derive_navigation_signal_interference
  by simp
lemma trigger_art_compound_airspace_hazard: "article_triggered Art_Compound_Airspace_Hazard actor"
  using derive_compound_airspace_hazard
  by simp

lemma overrides_art_compound_airspace_hazard_art_navigation_signal_interference: "overrides Art_Compound_Airspace_Hazard Art_Navigation_Signal_Interference"
  unfolding overrides_def
  by simp

lemma not_trigger_art_maintenance_window_authorization: "\<not> article_triggered Art_Maintenance_Window_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps maintenance_window_authorization_def airside_access_violation_def prohibited_airside_entry_def restricted_airside_status_def maintenance_authorization_records_def
  by simp
lemma not_trigger_art_emergency_tarmac_authorization: "\<not> article_triggered Art_Emergency_Tarmac_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps emergency_tarmac_authorization_def airside_access_violation_def prohibited_airside_entry_def restricted_airside_status_def emergency_tarmac_records_def
  by simp

lemma not_defeated_art_compound_airspace_hazard: "\<not> defeated actor Art_Compound_Airspace_Hazard"
proof
  assume defeated_assm: "defeated actor Art_Compound_Airspace_Hazard"
  then obtain higher where
    higher_triggered: "article_triggered higher actor"
    and higher_overrides: "overrides higher Art_Compound_Airspace_Hazard"
    unfolding defeated_def by blast
  then show False
    using not_trigger_art_emergency_tarmac_authorization
    unfolding overrides_def
    by (cases higher) auto
qed
lemma applicable_art_compound_airspace_hazard: "applicable actor Art_Compound_Airspace_Hazard"
  using trigger_art_compound_airspace_hazard not_defeated_art_compound_airspace_hazard
  unfolding applicable_def
  by blast
lemma defeated_art_navigation_signal_interference: "defeated actor Art_Navigation_Signal_Interference"
  using trigger_art_navigation_signal_interference trigger_art_compound_airspace_hazard overrides_art_compound_airspace_hazard_art_navigation_signal_interference
  unfolding defeated_def
  by blast
lemma not_applicable_art_navigation_signal_interference: "\<not> applicable actor Art_Navigation_Signal_Interference"
  using trigger_art_navigation_signal_interference defeated_art_navigation_signal_interference
  unfolding applicable_def
  by blast

lemma not_applicable_art_maintenance_window_authorization: "\<not> applicable actor Art_Maintenance_Window_Authorization"
  using not_trigger_art_maintenance_window_authorization
  unfolding applicable_def
  by blast
lemma not_applicable_art_emergency_tarmac_authorization: "\<not> applicable actor Art_Emergency_Tarmac_Authorization"
  using not_trigger_art_emergency_tarmac_authorization
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
    using art_applicable art_result not_applicable_art_maintenance_window_authorization not_applicable_art_emergency_tarmac_authorization
    by (cases art) auto
qed
theorem final_result_liability: "final_legal_result_holds actor imprisonment_between_7_15_years"
  using applicable_art_compound_airspace_hazard not_final_no_liability
  unfolding final_legal_result_holds_def
  by auto

end
