theory Case_kernel
  imports General
begin

consts
  opens_outer_ring_airlock :: "person => bool"
  unlatches_pressure_console :: "person => bool"
  airlock_cycle_unlogged :: "person => bool"
  skips_cycle_entry :: "person => bool"
  removes_algae_oxygen_filter :: "person => bool"
  removes_backup_oxygen_tab :: "person => bool"
  cabin_pressure_drops :: "person => bool"
  pressure_alarm_sounds :: "person => bool"
  turns_off_yellow_corridor_lamp :: "person => bool"
  crew_member_crosses_corridor :: "person => bool"
  holds_habitat_duty_permit :: "person => bool"
  central_log_confirms_permit :: "person => bool"
  maintenance_box_drifts_outside :: "person => bool"
  rescue_tether_deployed :: "person => bool"
  vents_air_temporarily :: "person => bool"
  restores_pressure_after_venting :: "person => bool"
  reports_stabilization_to_core :: "person => bool"

definition restricted_airlock_operation :: "person => bool" where
  "restricted_airlock_operation x =
    ((opens_outer_ring_airlock x \<or> unlatches_pressure_console x) \<and>
      (airlock_cycle_unlogged x \<or> skips_cycle_entry x))"

definition oxygen_system_interference :: "person => bool" where
  "oxygen_system_interference x =
    ((removes_algae_oxygen_filter x \<or> removes_backup_oxygen_tab x) \<and>
      cabin_pressure_drops x \<and> pressure_alarm_sounds x)"

definition corridor_safety_obstruction :: "person => bool" where
  "corridor_safety_obstruction x =
    (turns_off_yellow_corridor_lamp x \<and> crew_member_crosses_corridor x)"

definition habitat_authority :: "person => bool" where
  "habitat_authority x =
    (holds_habitat_duty_permit x \<and> central_log_confirms_permit x)"

definition salvage_emergency :: "person => bool" where
  "salvage_emergency x =
    (maintenance_box_drifts_outside x \<and> rescue_tether_deployed x \<and> vents_air_temporarily x)"

definition pressure_stabilization :: "person => bool" where
  "pressure_stabilization x =
    (cabin_pressure_drops x \<and> restores_pressure_after_venting x \<and> reports_stabilization_to_core x)"

end
