theory pcwd_case_30
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "takes_property actor"
and f2: "property_belongs_to_another actor"
and f3: "intent_to_keep_unlawfully actor"
and f4: "deception_used actor"
and f5: "victim_transfers_property actor"
and f6: "property_value_large actor"
and f7: "owner_gave_permission actor"
and f8: "\<not> pushes_victim_during_taking actor"
and f9: "\<not> threatens_immediate_harm actor"
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
lemma derive_transferred_property_of_another: "transferred_property_of_another actor"
  using f5 f2
  unfolding transferred_property_of_another_def
  by simp
lemma derive_deception_induced_transfer: "deception_induced_transfer actor"
  using f4 derive_transferred_property_of_another
  unfolding deception_induced_transfer_def
  by simp
lemma derive_high_value_property: "high_value_property actor"
  using f6
  unfolding high_value_property_def
  by simp
lemma derive_owner_authorized_taking: "owner_authorized_taking actor"
  using f1 f7
  unfolding owner_authorized_taking_def
  by simp
lemma derive_theft_conduct: "theft_conduct actor"
  using derive_property_taking derive_unlawful_intent
  unfolding theft_conduct_def
  by simp
lemma derive_fraud_conduct: "fraud_conduct actor"
  using derive_deception_induced_transfer derive_unlawful_intent
  unfolding fraud_conduct_def
  by simp
lemma derive_consent_defense: "consent_defense actor"
  using derive_owner_authorized_taking
  unfolding consent_defense_def
  by simp
lemma trigger_art_theft: "article_triggered Art_Theft actor"
  using derive_theft_conduct
  by simp
lemma trigger_art_fraud: "article_triggered Art_Fraud actor"
  using derive_fraud_conduct
  by simp
lemma trigger_art_aggravated_theft: "article_triggered Art_Aggravated_Theft actor"
  using derive_theft_conduct derive_high_value_property
  by simp
lemma trigger_art_consent_defense: "article_triggered Art_Consent_Defense actor"
  using derive_consent_defense
  by simp

lemma overrides_art_aggravated_theft_art_theft: "overrides Art_Aggravated_Theft Art_Theft"
  unfolding overrides_def
  by simp
lemma overrides_art_fraud_art_theft: "overrides Art_Fraud Art_Theft"
  unfolding overrides_def
  by simp
lemma overrides_art_consent_defense_art_theft: "overrides Art_Consent_Defense Art_Theft"
  unfolding overrides_def
  by simp
lemma overrides_art_consent_defense_art_fraud: "overrides Art_Consent_Defense Art_Fraud"
  unfolding overrides_def
  by simp
lemma overrides_art_consent_defense_art_aggravated_theft: "overrides Art_Consent_Defense Art_Aggravated_Theft"
  unfolding overrides_def
  by simp


lemma not_defeated_art_consent_defense: "\<not> defeated actor Art_Consent_Defense"
  using trigger_art_consent_defense
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_consent_defense: "applicable actor Art_Consent_Defense"
  using trigger_art_consent_defense not_defeated_art_consent_defense
  unfolding applicable_def
  by blast
lemma defeated_art_fraud: "defeated actor Art_Fraud"
  using trigger_art_fraud trigger_art_consent_defense overrides_art_consent_defense_art_fraud
  unfolding defeated_def
  by blast
lemma not_applicable_art_fraud: "\<not> applicable actor Art_Fraud"
  using trigger_art_fraud defeated_art_fraud
  unfolding applicable_def
  by blast
lemma defeated_art_aggravated_theft: "defeated actor Art_Aggravated_Theft"
  using trigger_art_aggravated_theft trigger_art_consent_defense overrides_art_consent_defense_art_aggravated_theft
  unfolding defeated_def
  by blast
lemma not_applicable_art_aggravated_theft: "\<not> applicable actor Art_Aggravated_Theft"
  using trigger_art_aggravated_theft defeated_art_aggravated_theft
  unfolding applicable_def
  by blast
lemma defeated_art_theft: "defeated actor Art_Theft"
  using trigger_art_theft trigger_art_aggravated_theft overrides_art_aggravated_theft_art_theft
  unfolding defeated_def
  by blast
lemma not_applicable_art_theft: "\<not> applicable actor Art_Theft"
  using trigger_art_theft defeated_art_theft
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_consent_defense
  unfolding final_no_liability_def
  by auto

end
