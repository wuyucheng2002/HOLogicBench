theory ssdr_case_23
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "inserts_red_route_key actor"
and f2: "ghost_train_changes_track actor"
and f3: "detects_ceiling_collapse actor"
and f4: "redirects_lamp_temporarily actor"
and f5: "reports_change_to_control_room actor"
and f6: "sensor_reports_fault actor"
and f7: "panel_record_shows_no_hand_switch actor"
and f8: "\<not> swaps_blue_signal_tile actor"
and f9: "\<not> lights_reverse_tunnel_lamp actor"
and f10: "\<not> flips_black_signal_lever actor"
and f11: "\<not> dispatch_board_repaints_route actor"
and f12: "\<not> moves_seal_marker actor"
and f13: "\<not> enters_sealed_track actor"
and f14: "\<not> seal_alarm_rings actor"
and f15: "\<not> holds_dispatch_order actor"
and f16: "\<not> logs_order_in_signal_book actor"
and f17: "\<not> control_room_confirms_order actor"
and f18: "\<not> ground_sonar_marks_collapse actor"

lemma derive_signal_tampering: "signal_tampering actor"
  using f1
  unfolding signal_tampering_def
  by simp
lemma derive_train_rerouting: "train_rerouting actor"
  using f2
  unfolding train_rerouting_def
  by simp
lemma derive_collapse_avoidance: "collapse_avoidance actor"
  using f4 f5 f3
  unfolding collapse_avoidance_def
  by simp
lemma derive_sensor_fault_condition: "sensor_fault_condition actor"
  using f6 f7
  unfolding sensor_fault_condition_def
  by simp
lemma derive_unauthorized_signal_change_basis: "unauthorized_signal_change_basis actor"
  using derive_signal_tampering
  unfolding unauthorized_signal_change_basis_def
  by simp
lemma derive_route_misdirection_basis: "route_misdirection_basis actor"
  using derive_signal_tampering derive_train_rerouting
  unfolding route_misdirection_basis_def
  by simp
lemma derive_collapse_avoidance_authorization_basis: "collapse_avoidance_authorization_basis actor"
  using derive_collapse_avoidance derive_signal_tampering
  unfolding collapse_avoidance_authorization_basis_def
  by simp
lemma derive_sensor_fault_exemption_basis: "sensor_fault_exemption_basis actor"
  using derive_sensor_fault_condition derive_train_rerouting
  unfolding sensor_fault_exemption_basis_def
  by simp
lemma trigger_art_unauthorized_signal_change: "article_triggered Art_Unauthorized_Signal_Change actor"
  using derive_unauthorized_signal_change_basis
  by simp
lemma trigger_art_route_misdirection: "article_triggered Art_Route_Misdirection actor"
  using derive_route_misdirection_basis
  by simp
lemma trigger_art_collapse_avoidance_authorization: "article_triggered Art_Collapse_Avoidance_Authorization actor"
  using derive_collapse_avoidance_authorization_basis
  by simp
lemma trigger_art_sensor_fault_exemption: "article_triggered Art_Sensor_Fault_Exemption actor"
  using derive_sensor_fault_exemption_basis
  by simp

lemma overrides_art_route_misdirection_art_unauthorized_signal_change: "overrides Art_Route_Misdirection Art_Unauthorized_Signal_Change"
  unfolding overrides_def
  by simp
lemma overrides_art_collapse_avoidance_authorization_art_unauthorized_signal_change: "overrides Art_Collapse_Avoidance_Authorization Art_Unauthorized_Signal_Change"
  unfolding overrides_def
  by simp
lemma overrides_art_collapse_avoidance_authorization_art_route_misdirection: "overrides Art_Collapse_Avoidance_Authorization Art_Route_Misdirection"
  unfolding overrides_def
  by simp
lemma overrides_art_sensor_fault_exemption_art_route_misdirection: "overrides Art_Sensor_Fault_Exemption Art_Route_Misdirection"
  unfolding overrides_def
  by simp


lemma not_defeated_art_collapse_avoidance_authorization: "\<not> defeated actor Art_Collapse_Avoidance_Authorization"
  using trigger_art_collapse_avoidance_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_collapse_avoidance_authorization: "applicable actor Art_Collapse_Avoidance_Authorization"
  using trigger_art_collapse_avoidance_authorization not_defeated_art_collapse_avoidance_authorization
  unfolding applicable_def
  by blast
lemma not_defeated_art_sensor_fault_exemption: "\<not> defeated actor Art_Sensor_Fault_Exemption"
  using trigger_art_sensor_fault_exemption
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_sensor_fault_exemption: "applicable actor Art_Sensor_Fault_Exemption"
  using trigger_art_sensor_fault_exemption not_defeated_art_sensor_fault_exemption
  unfolding applicable_def
  by blast
lemma defeated_art_route_misdirection: "defeated actor Art_Route_Misdirection"
  using trigger_art_route_misdirection trigger_art_collapse_avoidance_authorization overrides_art_collapse_avoidance_authorization_art_route_misdirection
  unfolding defeated_def
  by blast
lemma not_applicable_art_route_misdirection: "\<not> applicable actor Art_Route_Misdirection"
  using trigger_art_route_misdirection defeated_art_route_misdirection
  unfolding applicable_def
  by blast
lemma defeated_art_unauthorized_signal_change: "defeated actor Art_Unauthorized_Signal_Change"
  using trigger_art_unauthorized_signal_change trigger_art_route_misdirection overrides_art_route_misdirection_art_unauthorized_signal_change
  unfolding defeated_def
  by blast
lemma not_applicable_art_unauthorized_signal_change: "\<not> applicable actor Art_Unauthorized_Signal_Change"
  using trigger_art_unauthorized_signal_change defeated_art_unauthorized_signal_change
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_collapse_avoidance_authorization
  unfolding final_no_liability_def
  by auto

end
