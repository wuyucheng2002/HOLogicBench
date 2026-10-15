theory aswa_case_17
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "uses_expired_airport_badge actor"
and f2: "airside_area_marked_restricted actor"
and f3: "launches_drone_near_runway actor"
and f4: "runway_lights_active actor"
and f5: "transmits_unlicensed_beacon actor"
and f6: "pilot_warning_received actor"
and f7: "\<not> enters_airside_gate_without_badge actor"
and f8: "\<not> follows_service_vehicle_through_gate actor"
and f9: "\<not> escort_officer_present actor"
and f10: "\<not> pilots_drone_above_service_road actor"
and f11: "\<not> jams_tower_channel actor"
and f12: "\<not> has_maintenance_work_order actor"
and f13: "\<not> stays_within_assigned_zone actor"
and f14: "\<not> logs_exit_before_closure actor"
and f15: "\<not> medical_diversion_announced actor"
and f16: "\<not> follows_rescue_controller_route actor"
and f17: "\<not> carries_patient_transfer_form actor"

lemma ex_article: "(\<exists>a::article. P a) = (P Art_Airside_Access_Breach \<or> P Art_Runway_Drone_Interference \<or> P Art_Navigation_Signal_Interference \<or> P Art_Compound_Airspace_Hazard \<or> P Art_Maintenance_Window_Authorization \<or> P Art_Emergency_Tarmac_Authorization)"
  by (metis article.exhaust)
theorem final_result_liability: "final_legal_result_holds actor imprisonment_between_7_15_years"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  by (auto simp: prohibited_airside_entry_def restricted_airside_status_def runway_drone_operation_def active_runway_risk_def signal_interference_conduct_def aviation_warning_effect_def maintenance_authorization_records_def emergency_tarmac_records_def airside_access_violation_def runway_drone_interference_def navigation_signal_interference_def compound_airspace_hazard_def maintenance_window_authorization_def emergency_tarmac_authorization_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
end
