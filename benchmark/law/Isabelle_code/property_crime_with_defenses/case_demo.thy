theory case_demo
  imports Conflict
begin

consts actor :: person

axiomatization where
  f1: "takes_property actor"
and f2: "property_belongs_to_another actor"
and f3: "intent_to_keep_unlawfully actor"
and f4: "pushes_victim_during_taking actor"

lemma demo_property_taking: "property_taking actor"
  using f1 f2
  unfolding property_taking_def
  by simp

lemma demo_unlawful_intent: "unlawful_intent actor"
  using f3
  unfolding unlawful_intent_def
  by simp

lemma demo_force_or_threat: "force_or_threat_during_taking actor"
  using f4
  unfolding force_or_threat_during_taking_def
  by simp

lemma demo_theft_conduct: "theft_conduct actor"
  using demo_property_taking demo_unlawful_intent
  unfolding theft_conduct_def
  by simp

lemma demo_robbery_triggered: "article_triggered Art_Robbery actor"
  using demo_theft_conduct demo_force_or_threat
  by simp

end
