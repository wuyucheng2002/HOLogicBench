theory Middle_concept
  imports Case_kernel
begin

definition theft_conduct :: "person => bool" where
  "theft_conduct x =
    (property_taking x \<and> unlawful_intent x)"

definition fraud_conduct :: "person => bool" where
  "fraud_conduct x =
    (deception_induced_transfer x \<and> unlawful_intent x)"

definition consent_defense :: "person => bool" where
  "consent_defense x = owner_authorized_taking x"

definition necessity_defense :: "person => bool" where
  "necessity_defense x = emergency_property_taking x"

fun article_triggered :: "article => person => bool" where
  "article_triggered Art_Theft x = theft_conduct x"
| "article_triggered Art_Fraud x = fraud_conduct x"
| "article_triggered Art_Robbery x = (theft_conduct x \<and> force_or_threat_during_taking x)"
| "article_triggered Art_Aggravated_Theft x = (theft_conduct x \<and> high_value_property x)"
| "article_triggered Art_Consent_Defense x = consent_defense x"
| "article_triggered Art_Necessity_Defense x = necessity_defense x"

end
