theory ssdr_case_28
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "flips_black_signal_lever actor"
and f2: "dispatch_board_repaints_route actor"
and f3: "moves_seal_marker actor"
and f4: "enters_sealed_track actor"
and f5: "seal_alarm_rings actor"
and f6: "holds_dispatch_order actor"
and f7: "logs_order_in_signal_book actor"
and f8: "control_room_confirms_order actor"
and f9: "\<not> swaps_blue_signal_tile actor"
and f10: "\<not> lights_reverse_tunnel_lamp actor"
and f11: "\<not> inserts_red_route_key actor"
and f12: "\<not> ghost_train_changes_track actor"
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
lemma derive_route_misdirection_risk: "route_misdirection_risk actor"
  using derive_signal_tampering derive_train_rerouting
  unfolding route_misdirection_risk_def
  by simp
lemma derive_seal_breach: "seal_breach actor"
  using f3 f4 f5
  unfolding seal_breach_def
  by simp
lemma derive_dispatch_authority: "dispatch_authority actor"
  using f6 f7 f8
  unfolding dispatch_authority_def
  by simp
lemma derive_route_misdirection_basis: "route_misdirection_basis actor"
  using derive_signal_tampering derive_train_rerouting
  unfolding route_misdirection_basis_def
  by simp
lemma derive_sealed_track_breach_basis: "sealed_track_breach_basis actor"
  using derive_seal_breach derive_route_misdirection_risk
  unfolding sealed_track_breach_basis_def
  by simp
lemma derive_dispatch_order_authorization_basis: "dispatch_order_authorization_basis actor"
  using derive_dispatch_authority derive_signal_tampering
  unfolding dispatch_order_authorization_basis_def
  by simp
lemma trigger_art_route_misdirection: "article_triggered Art_Route_Misdirection actor"
  using derive_route_misdirection_basis
  by simp
lemma trigger_art_sealed_track_breach: "article_triggered Art_Sealed_Track_Breach actor"
  using derive_sealed_track_breach_basis
  by simp
lemma trigger_art_dispatch_order_authorization: "article_triggered Art_Dispatch_Order_Authorization actor"
  using derive_dispatch_order_authorization_basis
  by simp

lemma overrides_art_sealed_track_breach_art_route_misdirection: "overrides Art_Sealed_Track_Breach Art_Route_Misdirection"
  unfolding overrides_def
  by simp
lemma overrides_art_dispatch_order_authorization_art_route_misdirection: "overrides Art_Dispatch_Order_Authorization Art_Route_Misdirection"
  unfolding overrides_def
  by simp

lemma not_trigger_art_collapse_avoidance_authorization: "\<not> article_triggered Art_Collapse_Avoidance_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18
  unfolding article_triggered.simps collapse_avoidance_authorization_basis_def collapse_avoidance_def signal_tampering_def
  by simp

lemma not_defeated_art_sealed_track_breach: "\<not> defeated actor Art_Sealed_Track_Breach"
proof
  assume defeated_assm: "defeated actor Art_Sealed_Track_Breach"
  then obtain higher where
    higher_triggered: "article_triggered higher actor"
    and higher_overrides: "overrides higher Art_Sealed_Track_Breach"
    unfolding defeated_def by blast
  then show False
    using not_trigger_art_collapse_avoidance_authorization
    unfolding overrides_def
    by (cases higher) auto
qed
lemma applicable_art_sealed_track_breach: "applicable actor Art_Sealed_Track_Breach"
  using trigger_art_sealed_track_breach not_defeated_art_sealed_track_breach
  unfolding applicable_def
  by blast
lemma not_defeated_art_dispatch_order_authorization: "\<not> defeated actor Art_Dispatch_Order_Authorization"
  using trigger_art_dispatch_order_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_dispatch_order_authorization: "applicable actor Art_Dispatch_Order_Authorization"
  using trigger_art_dispatch_order_authorization not_defeated_art_dispatch_order_authorization
  unfolding applicable_def
  by blast
lemma defeated_art_route_misdirection: "defeated actor Art_Route_Misdirection"
  using trigger_art_route_misdirection trigger_art_sealed_track_breach overrides_art_sealed_track_breach_art_route_misdirection
  unfolding defeated_def
  by blast
lemma not_applicable_art_route_misdirection: "\<not> applicable actor Art_Route_Misdirection"
  using trigger_art_route_misdirection defeated_art_route_misdirection
  unfolding applicable_def
  by blast

lemma not_applicable_art_collapse_avoidance_authorization: "\<not> applicable actor Art_Collapse_Avoidance_Authorization"
  using not_trigger_art_collapse_avoidance_authorization
  unfolding applicable_def
  by blast

theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_dispatch_order_authorization
  unfolding final_no_liability_def
  by auto

end
