theory Case_kernel
  imports General
begin

consts
  opens_gear_well_cover :: "person => bool"
  opens_service_hatch :: "person => bool"
  pulls_copper_speed_pin :: "person => bool"
  loosens_brass_regulator :: "person => bool"
  releases_uncalibrated_automaton :: "person => bool"
  releases_clockwork_runner :: "person => bool"
  automaton_crosses_public_line :: "person => bool"
  runner_enters_public_square :: "person => bool"
  public_clock_stops :: "person => bool"
  reset_alarm_sounds :: "person => bool"
  wears_maintenance_badge :: "person => bool"
  receives_municipal_order :: "person => bool"
  supervisor_seals_work_ticket :: "person => bool"
  turns_clocktower_reset_wheel :: "person => bool"
  reports_reset_to_clock_desk :: "person => bool"
  fault_flag_raised_before_contact :: "person => bool"
  calibration_panel_records_fault :: "person => bool"

definition restricted_mechanical_access :: "person => bool" where
  "restricted_mechanical_access x =
    ((opens_gear_well_cover x \<or> opens_service_hatch x) \<and>
      (pulls_copper_speed_pin x \<or> loosens_brass_regulator x))"

definition unsafe_automaton_release :: "person => bool" where
  "unsafe_automaton_release x =
    ((releases_uncalibrated_automaton x \<or> releases_clockwork_runner x) \<and>
      (automaton_crosses_public_line x \<or> runner_enters_public_square x))"

definition clock_disruption :: "person => bool" where
  "clock_disruption x =
    (public_clock_stops x \<and> restricted_mechanical_access x)"

definition maintenance_authority :: "person => bool" where
  "maintenance_authority x =
    (wears_maintenance_badge x \<and> receives_municipal_order x \<and> supervisor_seals_work_ticket x)"

definition emergency_reset_action :: "person => bool" where
  "emergency_reset_action x =
    (public_clock_stops x \<and> reset_alarm_sounds x \<and>
      turns_clocktower_reset_wheel x \<and> reports_reset_to_clock_desk x)"

definition calibration_fault_condition :: "person => bool" where
  "calibration_fault_condition x =
    (fault_flag_raised_before_contact x \<and> calibration_panel_records_fault x)"

end
