theory pcwd_case_15
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
and f7: "\<not> pushes_victim_during_taking actor"
and f8: "\<not> threatens_immediate_harm actor"
and f9: "\<not> owner_gave_permission actor"
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
lemma derive_theft_conduct: "theft_conduct actor"
  using derive_property_taking derive_unlawful_intent
  unfolding theft_conduct_def
  by simp
lemma derive_fraud_conduct: "fraud_conduct actor"
  using derive_deception_induced_transfer derive_unlawful_intent
  unfolding fraud_conduct_def
  by simp
lemma trigger_art_fraud: "article_triggered Art_Fraud actor"
  using derive_fraud_conduct
  by simp
lemma trigger_art_aggravated_theft: "article_triggered Art_Aggravated_Theft actor"
  using derive_theft_conduct derive_high_value_property
  by simp


lemma not_trigger_art_robbery: "\<not> article_triggered Art_Robbery actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11
  unfolding article_triggered.simps theft_conduct_def property_taking_def unlawful_intent_def force_or_threat_during_taking_def
  by simp
lemma not_trigger_art_consent_defense: "\<not> article_triggered Art_Consent_Defense actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11
  unfolding article_triggered.simps consent_defense_def owner_authorized_taking_def
  by simp
lemma not_trigger_art_necessity_defense: "\<not> article_triggered Art_Necessity_Defense actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11
  unfolding article_triggered.simps necessity_defense_def emergency_property_taking_def
  by simp

lemma not_defeated_art_fraud: "\<not> defeated actor Art_Fraud"
proof
  assume defeated_assm: "defeated actor Art_Fraud"
  then obtain higher where
    higher_triggered: "article_triggered higher actor"
    and higher_overrides: "overrides higher Art_Fraud"
    unfolding defeated_def by blast
  then show False
    using not_trigger_art_consent_defense not_trigger_art_necessity_defense
    unfolding overrides_def
    by (cases higher) auto
qed
lemma applicable_art_fraud: "applicable actor Art_Fraud"
  using trigger_art_fraud not_defeated_art_fraud
  unfolding applicable_def
  by blast
lemma not_defeated_art_aggravated_theft: "\<not> defeated actor Art_Aggravated_Theft"
proof
  assume defeated_assm: "defeated actor Art_Aggravated_Theft"
  then obtain higher where
    higher_triggered: "article_triggered higher actor"
    and higher_overrides: "overrides higher Art_Aggravated_Theft"
    unfolding defeated_def by blast
  then show False
    using not_trigger_art_robbery not_trigger_art_consent_defense not_trigger_art_necessity_defense
    unfolding overrides_def
    by (cases higher) auto
qed
lemma applicable_art_aggravated_theft: "applicable actor Art_Aggravated_Theft"
  using trigger_art_aggravated_theft not_defeated_art_aggravated_theft
  unfolding applicable_def
  by blast

lemma not_applicable_art_consent_defense: "\<not> applicable actor Art_Consent_Defense"
  using not_trigger_art_consent_defense
  unfolding applicable_def
  by blast
lemma not_applicable_art_necessity_defense: "\<not> applicable actor Art_Necessity_Defense"
  using not_trigger_art_necessity_defense
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
    using art_applicable art_result not_applicable_art_consent_defense not_applicable_art_necessity_defense
    by (cases art) auto
qed
theorem final_result_liability: "final_legal_result_holds actor imprisonment_not_exceeding_3_years"
  using applicable_art_fraud not_final_no_liability
  unfolding final_legal_result_holds_def
  by auto

end
