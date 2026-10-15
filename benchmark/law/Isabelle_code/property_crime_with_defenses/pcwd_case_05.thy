theory pcwd_case_05
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "takes_property actor"
and f2: "property_belongs_to_another actor"
and f3: "intent_to_keep_unlawfully actor"
and f4: "owner_gave_permission actor"
and f5: "\<not> pushes_victim_during_taking actor"
and f6: "\<not> threatens_immediate_harm actor"
and f7: "\<not> deception_used actor"
and f8: "\<not> victim_transfers_property actor"
and f9: "\<not> property_value_large actor"
and f10: "\<not> immediate_danger actor"
and f11: "\<not> taking_necessary_to_avoid_danger actor"

lemma derive_property_taking: "property_taking actor"
  using f1 f2
  unfolding property_taking_def
  by simp
lemma derive_unlawful_intent: "unlawful_intent actor"
  using f3
  unfolding unlawful_intent_def
  by simp
lemma derive_owner_authorized_taking: "owner_authorized_taking actor"
  using f1 f4
  unfolding owner_authorized_taking_def
  by simp
lemma derive_theft_conduct: "theft_conduct actor"
  using derive_property_taking derive_unlawful_intent
  unfolding theft_conduct_def
  by simp
lemma derive_consent_defense: "consent_defense actor"
  using derive_owner_authorized_taking
  unfolding consent_defense_def
  by simp
lemma trigger_art_theft: "article_triggered Art_Theft actor"
  using derive_theft_conduct
  by simp
lemma trigger_art_consent_defense: "article_triggered Art_Consent_Defense actor"
  using derive_consent_defense
  by simp

lemma overrides_art_consent_defense_art_theft: "overrides Art_Consent_Defense Art_Theft"
  unfolding overrides_def
  by simp


lemma defeated_art_theft: "defeated actor Art_Theft"
  using trigger_art_theft trigger_art_consent_defense overrides_art_consent_defense_art_theft
  unfolding defeated_def
  by blast
lemma not_applicable_art_theft: "\<not> applicable actor Art_Theft"
  using trigger_art_theft defeated_art_theft
  unfolding applicable_def
  by blast
lemma not_defeated_art_consent_defense: "\<not> defeated actor Art_Consent_Defense"
  using trigger_art_consent_defense
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_consent_defense: "applicable actor Art_Consent_Defense"
  using trigger_art_consent_defense not_defeated_art_consent_defense
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_consent_defense
  unfolding final_no_liability_def
  by auto

end
