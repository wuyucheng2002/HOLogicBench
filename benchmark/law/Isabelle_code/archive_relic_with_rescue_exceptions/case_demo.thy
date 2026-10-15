theory case_demo
  imports Conflict
begin

consts actor :: person

axiomatization where
  fact_entry: "enters_closed_stack actor" and
  fact_restricted: "shelf_marked_restricted actor" and
  fact_no_curator: "\<not> curator_present actor" and
  fact_touch: "touches_relic_without_gloves actor" and
  fact_fragile: "relic_tagged_fragile actor"

lemma trigger_unauthorized_stack_entry: "unauthorized_stack_entry actor"
  using fact_entry
  unfolding unauthorized_stack_entry_def
  by auto

lemma trigger_restricted_shelf_status: "restricted_shelf_status actor"
  using fact_restricted fact_no_curator
  unfolding restricted_shelf_status_def
  by auto

lemma trigger_restricted_shelf_violation: "restricted_shelf_violation actor"
  using trigger_unauthorized_stack_entry trigger_restricted_shelf_status
  unfolding restricted_shelf_violation_def
  by auto

lemma trigger_fragile_relic_handling: "fragile_relic_handling actor"
  using fact_touch fact_fragile
  unfolding fragile_relic_handling_def
  by auto

lemma trigger_relic_handling_violation: "relic_handling_violation actor"
  using trigger_restricted_shelf_violation trigger_fragile_relic_handling
  unfolding relic_handling_violation_def
  by auto

lemma trigger_relic_article: "article_triggered Art_Relic_Handling_Breach actor"
  using trigger_relic_handling_violation
  by auto

end
