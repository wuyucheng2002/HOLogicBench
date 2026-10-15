theory aswa_case_07
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "enters_airside_gate_without_badge actor"
and f2: "airside_area_marked_restricted actor"
and f3: "launches_drone_near_runway actor"
and f4: "runway_lights_active actor"
and f5: "medical_diversion_announced actor"
and f6: "follows_rescue_controller_route actor"
and f7: "carries_patient_transfer_form actor"
and f8: "\<not> uses_expired_airport_badge actor"
and f9: "\<not> follows_service_vehicle_through_gate actor"
and f10: "\<not> escort_officer_present actor"
and f11: "\<not> pilots_drone_above_service_road actor"
and f12: "\<not> transmits_unlicensed_beacon actor"
and f13: "\<not> jams_tower_channel actor"
and f14: "\<not> pilot_warning_received actor"
and f15: "\<not> has_maintenance_work_order actor"
and f16: "\<not> stays_within_assigned_zone actor"
and f17: "\<not> logs_exit_before_closure actor"

lemma derive_prohibited_airside_entry: "prohibited_airside_entry actor"
  using f1
  unfolding prohibited_airside_entry_def
  by simp
lemma derive_restricted_airside_status: "restricted_airside_status actor"
  using f2 f10
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
lemma derive_emergency_tarmac_records: "emergency_tarmac_records actor"
  using f5 f6 f7
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
lemma derive_emergency_tarmac_authorization: "emergency_tarmac_authorization actor"
  using derive_airside_access_violation derive_emergency_tarmac_records
  unfolding emergency_tarmac_authorization_def
  by simp
lemma trigger_art_airside_access_breach: "article_triggered Art_Airside_Access_Breach actor"
  using derive_airside_access_violation
  by simp
lemma trigger_art_runway_drone_interference: "article_triggered Art_Runway_Drone_Interference actor"
  using derive_runway_drone_interference
  by simp
lemma trigger_art_emergency_tarmac_authorization: "article_triggered Art_Emergency_Tarmac_Authorization actor"
  using derive_emergency_tarmac_authorization
  by simp

lemma overrides_art_runway_drone_interference_art_airside_access_breach: "overrides Art_Runway_Drone_Interference Art_Airside_Access_Breach"
  unfolding overrides_def
  by simp
lemma overrides_art_emergency_tarmac_authorization_art_airside_access_breach: "overrides Art_Emergency_Tarmac_Authorization Art_Airside_Access_Breach"
  unfolding overrides_def
  by simp
lemma overrides_art_emergency_tarmac_authorization_art_runway_drone_interference: "overrides Art_Emergency_Tarmac_Authorization Art_Runway_Drone_Interference"
  unfolding overrides_def
  by simp


lemma defeated_art_runway_drone_interference: "defeated actor Art_Runway_Drone_Interference"
  using trigger_art_runway_drone_interference trigger_art_emergency_tarmac_authorization overrides_art_emergency_tarmac_authorization_art_runway_drone_interference
  unfolding defeated_def
  by blast
lemma not_applicable_art_runway_drone_interference: "\<not> applicable actor Art_Runway_Drone_Interference"
  using trigger_art_runway_drone_interference defeated_art_runway_drone_interference
  unfolding applicable_def
  by blast
lemma defeated_art_airside_access_breach: "defeated actor Art_Airside_Access_Breach"
  using trigger_art_airside_access_breach trigger_art_runway_drone_interference overrides_art_runway_drone_interference_art_airside_access_breach
  unfolding defeated_def
  by blast
lemma not_applicable_art_airside_access_breach: "\<not> applicable actor Art_Airside_Access_Breach"
  using trigger_art_airside_access_breach defeated_art_airside_access_breach
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


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_emergency_tarmac_authorization
  unfolding final_no_liability_def
  by auto

end
