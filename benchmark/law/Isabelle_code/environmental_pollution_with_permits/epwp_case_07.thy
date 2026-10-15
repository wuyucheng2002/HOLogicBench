theory epwp_case_07
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "releases_wastewater_to_river actor"
and f2: "pollutant_exceeds_limit actor"
and f3: "facility_has_valid_discharge_permit actor"
and f4: "release_within_permit_scope actor"
and f5: "required_monitoring_submitted actor"
and f6: "\<not> vents_emissions_to_air actor"
and f7: "\<not> leaks_storage_tank actor"
and f8: "\<not> hazardous_solvent_present actor"
and f9: "\<not> heavy_metal_sludge_present actor"
and f10: "\<not> transports_waste_to_unlined_site actor"
and f11: "\<not> buries_waste_without_liner actor"
and f12: "\<not> fish_kill_observed actor"
and f13: "\<not> drinking_water_intake_closed actor"
and f14: "\<not> soil_contamination_confirmed actor"
and f15: "\<not> monitoring_report_omits_exceedance actor"
and f16: "\<not> changes_sampling_date actor"
and f17: "\<not> disables_sensor_during_release actor"
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
lemma derive_permit_records: "permit_records actor"
  using f3 f4 f5
  unfolding permit_records_def
  by simp
lemma derive_unlawful_release_basis: "unlawful_release_basis actor"
  using derive_pollutant_release derive_limit_exceedance
  unfolding unlawful_release_basis_def
  by simp
lemma derive_permit_authorization: "permit_authorization actor"
  using derive_unlawful_release_basis derive_permit_records
  unfolding permit_authorization_def
  by simp
lemma trigger_art_unlawful_discharge: "article_triggered Art_Unlawful_Discharge actor"
  using derive_unlawful_release_basis
  by simp
lemma trigger_art_valid_permit_defense: "article_triggered Art_Valid_Permit_Defense actor"
  using derive_permit_authorization
  by simp

lemma overrides_art_valid_permit_defense_art_unlawful_discharge: "overrides Art_Valid_Permit_Defense Art_Unlawful_Discharge"
  unfolding overrides_def
  by simp


lemma defeated_art_unlawful_discharge: "defeated actor Art_Unlawful_Discharge"
  using trigger_art_unlawful_discharge trigger_art_valid_permit_defense overrides_art_valid_permit_defense_art_unlawful_discharge
  unfolding defeated_def
  by blast
lemma not_applicable_art_unlawful_discharge: "\<not> applicable actor Art_Unlawful_Discharge"
  using trigger_art_unlawful_discharge defeated_art_unlawful_discharge
  unfolding applicable_def
  by blast
lemma not_defeated_art_valid_permit_defense: "\<not> defeated actor Art_Valid_Permit_Defense"
  using trigger_art_valid_permit_defense
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_valid_permit_defense: "applicable actor Art_Valid_Permit_Defense"
  using trigger_art_valid_permit_defense not_defeated_art_valid_permit_defense
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_valid_permit_defense
  unfolding final_no_liability_def
  by auto

end
