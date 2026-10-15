theory Case_kernel
  imports General
begin

consts
  releases_wastewater_to_river :: "person => bool"
  vents_emissions_to_air :: "person => bool"
  leaks_storage_tank :: "person => bool"
  pollutant_exceeds_limit :: "person => bool"
  hazardous_solvent_present :: "person => bool"
  heavy_metal_sludge_present :: "person => bool"
  transports_waste_to_unlined_site :: "person => bool"
  buries_waste_without_liner :: "person => bool"
  fish_kill_observed :: "person => bool"
  drinking_water_intake_closed :: "person => bool"
  soil_contamination_confirmed :: "person => bool"
  monitoring_report_omits_exceedance :: "person => bool"
  changes_sampling_date :: "person => bool"
  disables_sensor_during_release :: "person => bool"
  facility_has_valid_discharge_permit :: "person => bool"
  release_within_permit_scope :: "person => bool"
  required_monitoring_submitted :: "person => bool"
  imminent_equipment_failure :: "person => bool"
  release_needed_to_prevent_explosion :: "person => bool"
  authority_notified_promptly :: "person => bool"

definition pollutant_release :: "person => bool" where
  "pollutant_release x =
    (releases_wastewater_to_river x \<or> vents_emissions_to_air x \<or> leaks_storage_tank x)"

definition limit_exceedance :: "person => bool" where
  "limit_exceedance x = pollutant_exceeds_limit x"

definition hazardous_material :: "person => bool" where
  "hazardous_material x =
    (hazardous_solvent_present x \<or> heavy_metal_sludge_present x)"

definition unprotected_disposal :: "person => bool" where
  "unprotected_disposal x =
    (transports_waste_to_unlined_site x \<or> buries_waste_without_liner x)"

definition environmental_harm :: "person => bool" where
  "environmental_harm x =
    (fish_kill_observed x \<or> drinking_water_intake_closed x \<or> soil_contamination_confirmed x)"

definition report_manipulation :: "person => bool" where
  "report_manipulation x =
    (monitoring_report_omits_exceedance x \<or> changes_sampling_date x \<or> disables_sensor_during_release x)"

definition permit_records :: "person => bool" where
  "permit_records x =
    (facility_has_valid_discharge_permit x \<and> release_within_permit_scope x \<and> required_monitoring_submitted x)"

definition emergency_records :: "person => bool" where
  "emergency_records x =
    (imminent_equipment_failure x \<and> release_needed_to_prevent_explosion x \<and> authority_notified_promptly x)"

end
