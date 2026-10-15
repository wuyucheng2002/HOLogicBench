theory epwp_case_05
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "vents_emissions_to_air actor"
and f2: "pollutant_exceeds_limit actor"
and f3: "drinking_water_intake_closed actor"
and f4: "changes_sampling_date actor"
and f5: "\<not> releases_wastewater_to_river actor"
and f6: "\<not> leaks_storage_tank actor"
and f7: "\<not> hazardous_solvent_present actor"
and f8: "\<not> heavy_metal_sludge_present actor"
and f9: "\<not> transports_waste_to_unlined_site actor"
and f10: "\<not> buries_waste_without_liner actor"
and f11: "\<not> fish_kill_observed actor"
and f12: "\<not> soil_contamination_confirmed actor"
and f13: "\<not> monitoring_report_omits_exceedance actor"
and f14: "\<not> disables_sensor_during_release actor"
and f15: "\<not> facility_has_valid_discharge_permit actor"
and f16: "\<not> release_within_permit_scope actor"
and f17: "\<not> required_monitoring_submitted actor"
and f18: "\<not> imminent_equipment_failure actor"
and f19: "\<not> release_needed_to_prevent_explosion actor"
and f20: "\<not> authority_notified_promptly actor"

lemma derive_pollutant_release: "pollutant_release actor"
  using f1
  unfolding pollutant_release_def
  by simp
lemma derive_limit_exceedance: "limit_exceedance actor"
  using f2
  unfolding limit_exceedance_def
  by simp
lemma derive_environmental_harm: "environmental_harm actor"
  using f3
  unfolding environmental_harm_def
  by simp
lemma derive_report_manipulation: "report_manipulation actor"
  using f4
  unfolding report_manipulation_def
  by simp
lemma derive_unlawful_release_basis: "unlawful_release_basis actor"
  using derive_pollutant_release derive_limit_exceedance
  unfolding unlawful_release_basis_def
  by simp
lemma derive_serious_contamination_basis: "serious_contamination_basis actor"
  using derive_unlawful_release_basis derive_environmental_harm
  unfolding serious_contamination_basis_def
  by simp
lemma derive_monitoring_falsification_basis: "monitoring_falsification_basis actor"
  using derive_unlawful_release_basis derive_report_manipulation
  unfolding monitoring_falsification_basis_def
  by simp
lemma trigger_art_unlawful_discharge: "article_triggered Art_Unlawful_Discharge actor"
  using derive_unlawful_release_basis
  by simp
lemma trigger_art_serious_contamination: "article_triggered Art_Serious_Contamination actor"
  using derive_serious_contamination_basis
  by simp
lemma trigger_art_falsified_monitoring: "article_triggered Art_Falsified_Monitoring actor"
  using derive_monitoring_falsification_basis
  by simp

lemma overrides_art_serious_contamination_art_unlawful_discharge: "overrides Art_Serious_Contamination Art_Unlawful_Discharge"
  unfolding overrides_def
  by simp
lemma overrides_art_serious_contamination_art_falsified_monitoring: "overrides Art_Serious_Contamination Art_Falsified_Monitoring"
  unfolding overrides_def
  by simp
lemma overrides_art_falsified_monitoring_art_unlawful_discharge: "overrides Art_Falsified_Monitoring Art_Unlawful_Discharge"
  unfolding overrides_def
  by simp

lemma not_trigger_art_valid_permit_defense: "\<not> article_triggered Art_Valid_Permit_Defense actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20
  unfolding article_triggered.simps permit_authorization_def unlawful_release_basis_def pollutant_release_def limit_exceedance_def permit_records_def
  by simp
lemma not_trigger_art_emergency_release_defense: "\<not> article_triggered Art_Emergency_Release_Defense actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20
  unfolding article_triggered.simps emergency_release_authorization_def unlawful_release_basis_def pollutant_release_def limit_exceedance_def emergency_records_def
  by simp

lemma not_defeated_art_serious_contamination: "\<not> defeated actor Art_Serious_Contamination"
proof
  assume defeated_assm: "defeated actor Art_Serious_Contamination"
  then obtain higher where
    higher_triggered: "article_triggered higher actor"
    and higher_overrides: "overrides higher Art_Serious_Contamination"
    unfolding defeated_def by blast
  then show False
    using not_trigger_art_valid_permit_defense not_trigger_art_emergency_release_defense
    unfolding overrides_def
    by (cases higher) auto
qed
lemma applicable_art_serious_contamination: "applicable actor Art_Serious_Contamination"
  using trigger_art_serious_contamination not_defeated_art_serious_contamination
  unfolding applicable_def
  by blast
lemma defeated_art_falsified_monitoring: "defeated actor Art_Falsified_Monitoring"
  using trigger_art_falsified_monitoring trigger_art_serious_contamination overrides_art_serious_contamination_art_falsified_monitoring
  unfolding defeated_def
  by blast
lemma not_applicable_art_falsified_monitoring: "\<not> applicable actor Art_Falsified_Monitoring"
  using trigger_art_falsified_monitoring defeated_art_falsified_monitoring
  unfolding applicable_def
  by blast
lemma defeated_art_unlawful_discharge: "defeated actor Art_Unlawful_Discharge"
  using trigger_art_unlawful_discharge trigger_art_serious_contamination overrides_art_serious_contamination_art_unlawful_discharge
  unfolding defeated_def
  by blast
lemma not_applicable_art_unlawful_discharge: "\<not> applicable actor Art_Unlawful_Discharge"
  using trigger_art_unlawful_discharge defeated_art_unlawful_discharge
  unfolding applicable_def
  by blast

lemma not_applicable_art_valid_permit_defense: "\<not> applicable actor Art_Valid_Permit_Defense"
  using not_trigger_art_valid_permit_defense
  unfolding applicable_def
  by blast
lemma not_applicable_art_emergency_release_defense: "\<not> applicable actor Art_Emergency_Release_Defense"
  using not_trigger_art_emergency_release_defense
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
    using art_applicable art_result not_applicable_art_valid_permit_defense not_applicable_art_emergency_release_defense
    by (cases art) auto
qed
theorem final_result_liability: "final_legal_result_holds actor imprisonment_between_7_15_years"
  using applicable_art_serious_contamination not_final_no_liability
  unfolding final_legal_result_holds_def
  by auto

end
