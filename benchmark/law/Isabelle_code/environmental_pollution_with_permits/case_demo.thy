theory case_demo
  imports Conflict
begin

consts actor :: person

axiomatization where
  fact_release: "releases_wastewater_to_river actor" and
  fact_exceedance: "pollutant_exceeds_limit actor" and
  fact_fish: "fish_kill_observed actor"

lemma trigger_pollutant_release: "pollutant_release actor"
  using fact_release
  unfolding pollutant_release_def
  by auto

lemma trigger_limit_exceedance: "limit_exceedance actor"
  using fact_exceedance
  unfolding limit_exceedance_def
  by auto

lemma trigger_unlawful_release_basis: "unlawful_release_basis actor"
  using trigger_pollutant_release trigger_limit_exceedance
  unfolding unlawful_release_basis_def
  by auto

lemma trigger_environmental_harm: "environmental_harm actor"
  using fact_fish
  unfolding environmental_harm_def
  by auto

lemma trigger_serious_contamination_basis: "serious_contamination_basis actor"
  using trigger_unlawful_release_basis trigger_environmental_harm
  unfolding serious_contamination_basis_def
  by auto

lemma trigger_serious_contamination: "article_triggered Art_Serious_Contamination actor"
  using trigger_serious_contamination_basis
  by auto

end
