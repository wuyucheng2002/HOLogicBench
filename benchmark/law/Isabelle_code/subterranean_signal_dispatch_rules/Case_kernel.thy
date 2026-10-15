theory Case_kernel
  imports General
begin

consts
  swaps_blue_signal_tile :: "person => bool"
  lights_reverse_tunnel_lamp :: "person => bool"
  inserts_red_route_key :: "person => bool"
  flips_black_signal_lever :: "person => bool"
  ghost_train_changes_track :: "person => bool"
  dispatch_board_repaints_route :: "person => bool"
  moves_seal_marker :: "person => bool"
  enters_sealed_track :: "person => bool"
  seal_alarm_rings :: "person => bool"
  holds_dispatch_order :: "person => bool"
  logs_order_in_signal_book :: "person => bool"
  control_room_confirms_order :: "person => bool"
  detects_ceiling_collapse :: "person => bool"
  ground_sonar_marks_collapse :: "person => bool"
  redirects_lamp_temporarily :: "person => bool"
  reports_change_to_control_room :: "person => bool"
  sensor_reports_fault :: "person => bool"
  panel_record_shows_no_hand_switch :: "person => bool"

definition signal_tampering :: "person => bool" where
  "signal_tampering x =
    (swaps_blue_signal_tile x \<or> lights_reverse_tunnel_lamp x \<or>
      inserts_red_route_key x \<or> flips_black_signal_lever x)"

definition train_rerouting :: "person => bool" where
  "train_rerouting x =
    (ghost_train_changes_track x \<or> dispatch_board_repaints_route x)"

definition route_misdirection_risk :: "person => bool" where
  "route_misdirection_risk x =
    (signal_tampering x \<and> train_rerouting x)"

definition seal_breach :: "person => bool" where
  "seal_breach x =
    (moves_seal_marker x \<and> enters_sealed_track x \<and> seal_alarm_rings x)"

definition dispatch_authority :: "person => bool" where
  "dispatch_authority x =
    (holds_dispatch_order x \<and> logs_order_in_signal_book x \<and> control_room_confirms_order x)"

definition collapse_avoidance :: "person => bool" where
  "collapse_avoidance x =
    ((detects_ceiling_collapse x \<or> ground_sonar_marks_collapse x) \<and>
      redirects_lamp_temporarily x \<and> reports_change_to_control_room x)"

definition sensor_fault_condition :: "person => bool" where
  "sensor_fault_condition x =
    (sensor_reports_fault x \<and> panel_record_shows_no_hand_switch x)"

end
