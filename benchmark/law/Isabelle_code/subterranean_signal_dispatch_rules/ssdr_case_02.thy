theory ssdr_case_02
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "lights_reverse_tunnel_lamp actor"
and f2: "dispatch_board_repaints_route actor"
and f3: "\<not> swaps_blue_signal_tile actor"
and f4: "\<not> inserts_red_route_key actor"
and f5: "\<not> flips_black_signal_lever actor"
and f6: "\<not> ghost_train_changes_track actor"
and f7: "\<not> moves_seal_marker actor"
and f8: "\<not> enters_sealed_track actor"
and f9: "\<not> seal_alarm_rings actor"
and f10: "\<not> holds_dispatch_order actor"
and f11: "\<not> logs_order_in_signal_book actor"
and f12: "\<not> control_room_confirms_order actor"
and f13: "\<not> detects_ceiling_collapse actor"
and f14: "\<not> ground_sonar_marks_collapse actor"
and f15: "\<not> redirects_lamp_temporarily actor"
and f16: "\<not> reports_change_to_control_room actor"
and f17: "\<not> sensor_reports_fault actor"
and f18: "\<not> panel_record_shows_no_hand_switch actor"

lemma derive_signal_tampering: "signal_tampering actor"
  using f1
  unfolding signal_tampering_def
  by simp
lemma derive_train_rerouting: "train_rerouting actor"
  using f2
  unfolding train_rerouting_def
  by simp
lemma derive_unauthorized_signal_change_basis: "unauthorized_signal_change_basis actor"
  using derive_signal_tampering
  unfolding unauthorized_signal_change_basis_def
  by simp
lemma derive_route_misdirection_basis: "route_misdirection_basis actor"
  using derive_signal_tampering derive_train_rerouting
  unfolding route_misdirection_basis_def
  by simp
lemma trigger_art_unauthorized_signal_change: "article_triggered Art_Unauthorized_Signal_Change actor"
  using derive_unauthorized_signal_change_basis
  by simp
lemma trigger_art_route_misdirection: "article_triggered Art_Route_Misdirection actor"
  using derive_route_misdirection_basis
  by simp

lemma overrides_art_route_misdirection_art_unauthorized_signal_change: "overrides Art_Route_Misdirection Art_Unauthorized_Signal_Change"
  unfolding overrides_def
  by simp

lemma not_trigger_art_sealed_track_breach: "\<not> article_triggered Art_Sealed_Track_Breach actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18
  unfolding article_triggered.simps sealed_track_breach_basis_def seal_breach_def route_misdirection_risk_def signal_tampering_def train_rerouting_def
  by simp
lemma not_trigger_art_dispatch_order_authorization: "\<not> article_triggered Art_Dispatch_Order_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18
  unfolding article_triggered.simps dispatch_order_authorization_basis_def dispatch_authority_def signal_tampering_def
  by simp
lemma not_trigger_art_collapse_avoidance_authorization: "\<not> article_triggered Art_Collapse_Avoidance_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18
  unfolding article_triggered.simps collapse_avoidance_authorization_basis_def collapse_avoidance_def signal_tampering_def
  by simp
lemma not_trigger_art_sensor_fault_exemption: "\<not> article_triggered Art_Sensor_Fault_Exemption actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18
  unfolding article_triggered.simps sensor_fault_exemption_basis_def sensor_fault_condition_def train_rerouting_def
  by simp

lemma not_defeated_art_route_misdirection: "\<not> defeated actor Art_Route_Misdirection"
proof
  assume defeated_assm: "defeated actor Art_Route_Misdirection"
  then obtain higher where
    higher_triggered: "article_triggered higher actor"
    and higher_overrides: "overrides higher Art_Route_Misdirection"
    unfolding defeated_def by blast
  then show False
    using not_trigger_art_sealed_track_breach not_trigger_art_dispatch_order_authorization not_trigger_art_collapse_avoidance_authorization not_trigger_art_sensor_fault_exemption
    unfolding overrides_def
    by (cases higher) auto
qed
lemma applicable_art_route_misdirection: "applicable actor Art_Route_Misdirection"
  using trigger_art_route_misdirection not_defeated_art_route_misdirection
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

lemma not_applicable_art_dispatch_order_authorization: "\<not> applicable actor Art_Dispatch_Order_Authorization"
  using not_trigger_art_dispatch_order_authorization
  unfolding applicable_def
  by blast
lemma not_applicable_art_collapse_avoidance_authorization: "\<not> applicable actor Art_Collapse_Avoidance_Authorization"
  using not_trigger_art_collapse_avoidance_authorization
  unfolding applicable_def
  by blast
lemma not_applicable_art_sensor_fault_exemption: "\<not> applicable actor Art_Sensor_Fault_Exemption"
  using not_trigger_art_sensor_fault_exemption
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
    using art_applicable art_result not_applicable_art_dispatch_order_authorization not_applicable_art_collapse_avoidance_authorization not_applicable_art_sensor_fault_exemption
    by (cases art) auto
qed
theorem final_result_liability: "final_legal_result_holds actor route_suspension"
  using applicable_art_route_misdirection not_final_no_liability
  unfolding final_legal_result_holds_def
  by auto

end
