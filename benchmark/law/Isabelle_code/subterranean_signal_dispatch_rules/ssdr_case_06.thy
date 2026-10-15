theory ssdr_case_06
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "lights_reverse_tunnel_lamp actor"
and f2: "dispatch_board_repaints_route actor"
and f3: "sensor_reports_fault actor"
and f4: "panel_record_shows_no_hand_switch actor"
and f5: "\<not> swaps_blue_signal_tile actor"
and f6: "\<not> inserts_red_route_key actor"
and f7: "\<not> flips_black_signal_lever actor"
and f8: "\<not> ghost_train_changes_track actor"
and f9: "\<not> moves_seal_marker actor"
and f10: "\<not> enters_sealed_track actor"
and f11: "\<not> seal_alarm_rings actor"
and f12: "\<not> holds_dispatch_order actor"
and f13: "\<not> logs_order_in_signal_book actor"
and f14: "\<not> control_room_confirms_order actor"
and f15: "\<not> detects_ceiling_collapse actor"
and f16: "\<not> ground_sonar_marks_collapse actor"
and f17: "\<not> redirects_lamp_temporarily actor"
and f18: "\<not> reports_change_to_control_room actor"

lemma derive_signal_tampering: "signal_tampering actor"
  using f1
  unfolding signal_tampering_def
  by simp
lemma derive_train_rerouting: "train_rerouting actor"
  using f2
  unfolding train_rerouting_def
  by simp
lemma derive_sensor_fault_condition: "sensor_fault_condition actor"
  using f3 f4
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
lemma trigger_art_sensor_fault_exemption: "article_triggered Art_Sensor_Fault_Exemption actor"
  using derive_sensor_fault_exemption_basis
  by simp

lemma overrides_art_route_misdirection_art_unauthorized_signal_change: "overrides Art_Route_Misdirection Art_Unauthorized_Signal_Change"
  unfolding overrides_def
  by simp
lemma overrides_art_sensor_fault_exemption_art_route_misdirection: "overrides Art_Sensor_Fault_Exemption Art_Route_Misdirection"
  unfolding overrides_def
  by simp


lemma not_defeated_art_sensor_fault_exemption: "\<not> defeated actor Art_Sensor_Fault_Exemption"
  using trigger_art_sensor_fault_exemption
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_sensor_fault_exemption: "applicable actor Art_Sensor_Fault_Exemption"
  using trigger_art_sensor_fault_exemption not_defeated_art_sensor_fault_exemption
  unfolding applicable_def
  by blast
lemma defeated_art_route_misdirection: "defeated actor Art_Route_Misdirection"
  using trigger_art_route_misdirection trigger_art_sensor_fault_exemption overrides_art_sensor_fault_exemption_art_route_misdirection
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
  using applicable_art_sensor_fault_exemption
  unfolding final_no_liability_def
  by auto

end
