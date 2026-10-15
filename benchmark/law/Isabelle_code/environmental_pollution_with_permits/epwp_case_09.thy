theory epwp_case_09
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "leaks_storage_tank actor"
and f2: "pollutant_exceeds_limit actor"
and f3: "soil_contamination_confirmed actor"
and f4: "imminent_equipment_failure actor"
and f5: "release_needed_to_prevent_explosion actor"
and f6: "authority_notified_promptly actor"
and f7: "\<not> releases_wastewater_to_river actor"
and f8: "\<not> vents_emissions_to_air actor"
and f9: "\<not> hazardous_solvent_present actor"
and f10: "\<not> heavy_metal_sludge_present actor"
and f11: "\<not> transports_waste_to_unlined_site actor"
and f12: "\<not> buries_waste_without_liner actor"
and f13: "\<not> fish_kill_observed actor"
and f14: "\<not> drinking_water_intake_closed actor"
and f15: "\<not> monitoring_report_omits_exceedance actor"
and f16: "\<not> changes_sampling_date actor"
and f17: "\<not> disables_sensor_during_release actor"
and f18: "\<not> facility_has_valid_discharge_permit actor"
and f19: "\<not> release_within_permit_scope actor"
and f20: "\<not> required_monitoring_submitted actor"

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
lemma derive_emergency_records: "emergency_records actor"
  using f4 f5 f6
  unfolding emergency_records_def
  by simp
lemma derive_unlawful_release_basis: "unlawful_release_basis actor"
  using derive_pollutant_release derive_limit_exceedance
  unfolding unlawful_release_basis_def
  by simp
lemma derive_serious_contamination_basis: "serious_contamination_basis actor"
  using derive_unlawful_release_basis derive_environmental_harm
  unfolding serious_contamination_basis_def
  by simp
lemma derive_emergency_release_authorization: "emergency_release_authorization actor"
  using derive_unlawful_release_basis derive_emergency_records
  unfolding emergency_release_authorization_def
  by simp
lemma trigger_art_unlawful_discharge: "article_triggered Art_Unlawful_Discharge actor"
  using derive_unlawful_release_basis
  by simp
lemma trigger_art_serious_contamination: "article_triggered Art_Serious_Contamination actor"
  using derive_serious_contamination_basis
  by simp
lemma trigger_art_emergency_release_defense: "article_triggered Art_Emergency_Release_Defense actor"
  using derive_emergency_release_authorization
  by simp

lemma overrides_art_serious_contamination_art_unlawful_discharge: "overrides Art_Serious_Contamination Art_Unlawful_Discharge"
  unfolding overrides_def
  by simp
lemma overrides_art_emergency_release_defense_art_unlawful_discharge: "overrides Art_Emergency_Release_Defense Art_Unlawful_Discharge"
  unfolding overrides_def
  by simp
lemma overrides_art_emergency_release_defense_art_serious_contamination: "overrides Art_Emergency_Release_Defense Art_Serious_Contamination"
  unfolding overrides_def
  by simp


lemma defeated_art_serious_contamination: "defeated actor Art_Serious_Contamination"
  using trigger_art_serious_contamination trigger_art_emergency_release_defense overrides_art_emergency_release_defense_art_serious_contamination
  unfolding defeated_def
  by blast
lemma not_applicable_art_serious_contamination: "\<not> applicable actor Art_Serious_Contamination"
  using trigger_art_serious_contamination defeated_art_serious_contamination
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
lemma not_defeated_art_emergency_release_defense: "\<not> defeated actor Art_Emergency_Release_Defense"
  using trigger_art_emergency_release_defense
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_emergency_release_defense: "applicable actor Art_Emergency_Release_Defense"
  using trigger_art_emergency_release_defense not_defeated_art_emergency_release_defense
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_emergency_release_defense
  unfolding final_no_liability_def
  by auto

end
