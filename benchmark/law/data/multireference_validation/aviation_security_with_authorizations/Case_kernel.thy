theory Case_kernel
  imports General
begin

consts
  enters_airside_gate_without_badge :: "person => bool"
  uses_expired_airport_badge :: "person => bool"
  follows_service_vehicle_through_gate :: "person => bool"
  airside_area_marked_restricted :: "person => bool"
  escort_officer_present :: "person => bool"
  launches_drone_near_runway :: "person => bool"
  pilots_drone_above_service_road :: "person => bool"
  runway_lights_active :: "person => bool"
  transmits_unlicensed_beacon :: "person => bool"
  jams_tower_channel :: "person => bool"
  pilot_warning_received :: "person => bool"
  has_maintenance_work_order :: "person => bool"
  stays_within_assigned_zone :: "person => bool"
  logs_exit_before_closure :: "person => bool"
  medical_diversion_announced :: "person => bool"
  follows_rescue_controller_route :: "person => bool"
  carries_patient_transfer_form :: "person => bool"

definition prohibited_airside_entry :: "person => bool" where
  "prohibited_airside_entry x =
    (enters_airside_gate_without_badge x \<or> uses_expired_airport_badge x \<or> follows_service_vehicle_through_gate x)"

definition restricted_airside_status :: "person => bool" where
  "restricted_airside_status x =
    (airside_area_marked_restricted x \<and> \<not> escort_officer_present x)"

definition runway_drone_operation :: "person => bool" where
  "runway_drone_operation x =
    (launches_drone_near_runway x \<or> pilots_drone_above_service_road x)"

definition active_runway_risk :: "person => bool" where
  "active_runway_risk x = runway_lights_active x"

definition signal_interference_conduct :: "person => bool" where
  "signal_interference_conduct x =
    (transmits_unlicensed_beacon x \<or> jams_tower_channel x)"

definition aviation_warning_effect :: "person => bool" where
  "aviation_warning_effect x = pilot_warning_received x"

definition maintenance_authorization_records :: "person => bool" where
  "maintenance_authorization_records x =
    (has_maintenance_work_order x \<and> stays_within_assigned_zone x \<and> logs_exit_before_closure x)"

definition emergency_tarmac_records :: "person => bool" where
  "emergency_tarmac_records x =
    (medical_diversion_announced x \<and> follows_rescue_controller_route x \<and> carries_patient_transfer_form x)"

end
