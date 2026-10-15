theory case_demo
  imports Conflict
begin

consts actor :: person

axiomatization where
  fact_entry: "enters_airside_gate_without_badge actor" and
  fact_restricted: "airside_area_marked_restricted actor" and
  fact_no_escort: "\<not> escort_officer_present actor" and
  fact_drone: "launches_drone_near_runway actor" and
  fact_runway: "runway_lights_active actor"

lemma trigger_prohibited_airside_entry: "prohibited_airside_entry actor"
  using fact_entry
  unfolding prohibited_airside_entry_def
  by auto

lemma trigger_restricted_airside_status: "restricted_airside_status actor"
  using fact_restricted fact_no_escort
  unfolding restricted_airside_status_def
  by auto

lemma trigger_airside_access_violation: "airside_access_violation actor"
  using trigger_prohibited_airside_entry trigger_restricted_airside_status
  unfolding airside_access_violation_def
  by auto

lemma trigger_runway_drone_operation: "runway_drone_operation actor"
  using fact_drone
  unfolding runway_drone_operation_def
  by auto

lemma trigger_active_runway_risk: "active_runway_risk actor"
  using fact_runway
  unfolding active_runway_risk_def
  by auto

lemma trigger_runway_drone_interference: "runway_drone_interference actor"
  using trigger_airside_access_violation trigger_runway_drone_operation trigger_active_runway_risk
  unfolding runway_drone_interference_def
  by auto

lemma trigger_runway_article: "article_triggered Art_Runway_Drone_Interference actor"
  using trigger_runway_drone_interference
  by auto

end
