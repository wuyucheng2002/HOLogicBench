theory aswa_case_27
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "follows_service_vehicle_through_gate actor"
and f2: "airside_area_marked_restricted actor"
and f3: "launches_drone_near_runway actor"
and f4: "runway_lights_active actor"
and f5: "transmits_unlicensed_beacon actor"
and f6: "pilot_warning_received actor"
and f7: "has_maintenance_work_order actor"
and f8: "stays_within_assigned_zone actor"
and f9: "logs_exit_before_closure actor"
and f10: "medical_diversion_announced actor"
and f11: "follows_rescue_controller_route actor"
and f12: "carries_patient_transfer_form actor"
and f13: "\<not> enters_airside_gate_without_badge actor"
and f14: "\<not> uses_expired_airport_badge actor"
and f15: "\<not> escort_officer_present actor"
and f16: "\<not> pilots_drone_above_service_road actor"
and f17: "\<not> jams_tower_channel actor"

lemma derive_prohibited_airside_entry: "prohibited_airside_entry actor"
  using f1
  unfolding prohibited_airside_entry_def
  by simp
lemma derive_restricted_airside_status: "restricted_airside_status actor"
  using f2 f15
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
lemma derive_maintenance_authorization_records: "maintenance_authorization_records actor"
  using f7 f8 f9
  unfolding maintenance_authorization_records_def
  by simp
lemma derive_emergency_tarmac_records: "emergency_tarmac_records actor"
  using f10 f11 f12
  unfolding emergency_tarmac_records_def
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
lemma derive_maintenance_window_authorization: "maintenance_window_authorization actor"
  using derive_airside_access_violation derive_maintenance_authorization_records
  unfolding maintenance_window_authorization_def
  by simp
lemma derive_emergency_tarmac_authorization: "emergency_tarmac_authorization actor"
  using derive_airside_access_violation derive_emergency_tarmac_records
  unfolding emergency_tarmac_authorization_def
  by simp
lemma trigger_art_runway_drone_interference: "article_triggered Art_Runway_Drone_Interference actor"
  using derive_runway_drone_interference
  by simp
lemma trigger_art_navigation_signal_interference: "article_triggered Art_Navigation_Signal_Interference actor"
  using derive_navigation_signal_interference
  by simp
lemma trigger_art_compound_airspace_hazard: "article_triggered Art_Compound_Airspace_Hazard actor"
  using derive_compound_airspace_hazard
  by simp
lemma trigger_art_maintenance_window_authorization: "article_triggered Art_Maintenance_Window_Authorization actor"
  using derive_maintenance_window_authorization
  by simp
lemma trigger_art_emergency_tarmac_authorization: "article_triggered Art_Emergency_Tarmac_Authorization actor"
  using derive_emergency_tarmac_authorization
  by simp

lemma overrides_art_compound_airspace_hazard_art_runway_drone_interference: "overrides Art_Compound_Airspace_Hazard Art_Runway_Drone_Interference"
  unfolding overrides_def
  by simp
lemma overrides_art_compound_airspace_hazard_art_navigation_signal_interference: "overrides Art_Compound_Airspace_Hazard Art_Navigation_Signal_Interference"
  unfolding overrides_def
  by simp
lemma overrides_art_maintenance_window_authorization_art_runway_drone_interference: "overrides Art_Maintenance_Window_Authorization Art_Runway_Drone_Interference"
  unfolding overrides_def
  by simp
lemma overrides_art_emergency_tarmac_authorization_art_runway_drone_interference: "overrides Art_Emergency_Tarmac_Authorization Art_Runway_Drone_Interference"
  unfolding overrides_def
  by simp
lemma overrides_art_emergency_tarmac_authorization_art_compound_airspace_hazard: "overrides Art_Emergency_Tarmac_Authorization Art_Compound_Airspace_Hazard"
  unfolding overrides_def
  by simp


lemma not_defeated_art_maintenance_window_authorization: "\<not> defeated actor Art_Maintenance_Window_Authorization"
  using trigger_art_maintenance_window_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_maintenance_window_authorization: "applicable actor Art_Maintenance_Window_Authorization"
  using trigger_art_maintenance_window_authorization not_defeated_art_maintenance_window_authorization
  unfolding applicable_def
  by blast
lemma not_defeated_art_emergency_tarmac_authorization: "\<not> defeated actor Art_Emergency_Tarmac_Authorization"
  using trigger_art_emergency_tarmac_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_emergency_tarmac_authorization: "applicable actor Art_Emergency_Tarmac_Authorization"
  using trigger_art_emergency_tarmac_authorization not_defeated_art_emergency_tarmac_authorization
  unfolding applicable_def
  by blast
lemma defeated_art_compound_airspace_hazard: "defeated actor Art_Compound_Airspace_Hazard"
  using trigger_art_compound_airspace_hazard trigger_art_emergency_tarmac_authorization overrides_art_emergency_tarmac_authorization_art_compound_airspace_hazard
  unfolding defeated_def
  by blast
lemma not_applicable_art_compound_airspace_hazard: "\<not> applicable actor Art_Compound_Airspace_Hazard"
  using trigger_art_compound_airspace_hazard defeated_art_compound_airspace_hazard
  unfolding applicable_def
  by blast
lemma defeated_art_runway_drone_interference: "defeated actor Art_Runway_Drone_Interference"
  using trigger_art_runway_drone_interference trigger_art_compound_airspace_hazard overrides_art_compound_airspace_hazard_art_runway_drone_interference
  unfolding defeated_def
  by blast
lemma not_applicable_art_runway_drone_interference: "\<not> applicable actor Art_Runway_Drone_Interference"
  using trigger_art_runway_drone_interference defeated_art_runway_drone_interference
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


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_maintenance_window_authorization
  unfolding final_no_liability_def
  by auto

end
