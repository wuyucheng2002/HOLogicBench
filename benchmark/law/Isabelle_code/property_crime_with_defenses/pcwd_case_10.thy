theory pcwd_case_10
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "takes_property actor"
and f2: "property_belongs_to_another actor"
and f3: "intent_to_keep_unlawfully actor"
and f4: "threatens_immediate_harm actor"
and f5: "property_value_large actor"
and f6: "immediate_danger actor"
and f7: "taking_necessary_to_avoid_danger actor"
and f8: "\<not> pushes_victim_during_taking actor"
and f9: "\<not> deception_used actor"
and f10: "\<not> victim_transfers_property actor"
and f11: "\<not> owner_gave_permission actor"

lemma derive_property_taking: "property_taking actor"
  using f1 f2
  unfolding property_taking_def
  by simp
lemma derive_unlawful_intent: "unlawful_intent actor"
  using f3
  unfolding unlawful_intent_def
  by simp
lemma derive_force_or_threat_during_taking: "force_or_threat_during_taking actor"
  using f4
  unfolding force_or_threat_during_taking_def
  by simp
lemma derive_high_value_property: "high_value_property actor"
  using f5
  unfolding high_value_property_def
  by simp
lemma derive_emergency_property_taking: "emergency_property_taking actor"
  using f1 f6 f7
  unfolding emergency_property_taking_def
  by simp
lemma derive_theft_conduct: "theft_conduct actor"
  using derive_property_taking derive_unlawful_intent
  unfolding theft_conduct_def
  by simp
lemma derive_necessity_defense: "necessity_defense actor"
  using derive_emergency_property_taking
  unfolding necessity_defense_def
  by simp
lemma trigger_art_theft: "article_triggered Art_Theft actor"
  using derive_theft_conduct
  by simp
lemma trigger_art_robbery: "article_triggered Art_Robbery actor"
  using derive_theft_conduct derive_force_or_threat_during_taking
  by simp
lemma trigger_art_aggravated_theft: "article_triggered Art_Aggravated_Theft actor"
  using derive_theft_conduct derive_high_value_property
  by simp
lemma trigger_art_necessity_defense: "article_triggered Art_Necessity_Defense actor"
  using derive_necessity_defense
  by simp

lemma overrides_art_robbery_art_theft: "overrides Art_Robbery Art_Theft"
  unfolding overrides_def
  by simp
lemma overrides_art_aggravated_theft_art_theft: "overrides Art_Aggravated_Theft Art_Theft"
  unfolding overrides_def
  by simp
lemma overrides_art_robbery_art_aggravated_theft: "overrides Art_Robbery Art_Aggravated_Theft"
  unfolding overrides_def
  by simp
lemma overrides_art_necessity_defense_art_theft: "overrides Art_Necessity_Defense Art_Theft"
  unfolding overrides_def
  by simp
lemma overrides_art_necessity_defense_art_robbery: "overrides Art_Necessity_Defense Art_Robbery"
  unfolding overrides_def
  by simp
lemma overrides_art_necessity_defense_art_aggravated_theft: "overrides Art_Necessity_Defense Art_Aggravated_Theft"
  unfolding overrides_def
  by simp


lemma defeated_art_robbery: "defeated actor Art_Robbery"
  using trigger_art_robbery trigger_art_necessity_defense overrides_art_necessity_defense_art_robbery
  unfolding defeated_def
  by blast
lemma not_applicable_art_robbery: "\<not> applicable actor Art_Robbery"
  using trigger_art_robbery defeated_art_robbery
  unfolding applicable_def
  by blast
lemma defeated_art_aggravated_theft: "defeated actor Art_Aggravated_Theft"
  using trigger_art_aggravated_theft trigger_art_robbery overrides_art_robbery_art_aggravated_theft
  unfolding defeated_def
  by blast
lemma not_applicable_art_aggravated_theft: "\<not> applicable actor Art_Aggravated_Theft"
  using trigger_art_aggravated_theft defeated_art_aggravated_theft
  unfolding applicable_def
  by blast
lemma defeated_art_theft: "defeated actor Art_Theft"
  using trigger_art_theft trigger_art_robbery overrides_art_robbery_art_theft
  unfolding defeated_def
  by blast
lemma not_applicable_art_theft: "\<not> applicable actor Art_Theft"
  using trigger_art_theft defeated_art_theft
  unfolding applicable_def
  by blast
lemma not_defeated_art_necessity_defense: "\<not> defeated actor Art_Necessity_Defense"
  using trigger_art_necessity_defense
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_necessity_defense: "applicable actor Art_Necessity_Defense"
  using trigger_art_necessity_defense not_defeated_art_necessity_defense
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_necessity_defense
  unfolding final_no_liability_def
  by auto

end
