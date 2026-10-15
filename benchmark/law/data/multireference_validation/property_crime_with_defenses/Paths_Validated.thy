theory Paths_Validated imports Conflict begin
lemma ex_article: "(\<exists>a::article. P a) = (P Art_Theft \<or> P Art_Fraud \<or> P Art_Robbery \<or> P Art_Aggravated_Theft \<or> P Art_Consent_Defense \<or> P Art_Necessity_Defense)"
  by (metis article.exhaust)
lemma pcwd_case_01_support_0:
  assumes "(\<not> deception_used x)" and "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "(\<not> property_value_large x)" and "(\<not> pushes_victim_during_taking x)" and "takes_property x" and "(\<not> threatens_immediate_harm x)"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_01_support_1:
  assumes "(\<not> deception_used x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "(\<not> property_value_large x)" and "(\<not> pushes_victim_during_taking x)" and "takes_property x" and "(\<not> taking_necessary_to_avoid_danger x)" and "(\<not> threatens_immediate_harm x)"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_01_support_2:
  assumes "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "(\<not> property_value_large x)" and "(\<not> pushes_victim_during_taking x)" and "takes_property x" and "(\<not> threatens_immediate_harm x)" and "(\<not> victim_transfers_property x)"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_01_support_3:
  assumes "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "(\<not> property_value_large x)" and "(\<not> pushes_victim_during_taking x)" and "takes_property x" and "(\<not> taking_necessary_to_avoid_danger x)" and "(\<not> threatens_immediate_harm x)" and "(\<not> victim_transfers_property x)"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_02_support_0:
  assumes "deception_used x" and "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_02_support_1:
  assumes "deception_used x" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "(\<not> taking_necessary_to_avoid_danger x)" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_02_support_2:
  assumes "deception_used x" and "intent_to_keep_unlawfully x" and "property_belongs_to_another x" and "(\<not> takes_property x)" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_03_support_0:
  assumes "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "pushes_victim_during_taking x" and "takes_property x"
  shows "final_legal_result_holds x imprisonment_between_3_10_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_03_support_1:
  assumes "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "pushes_victim_during_taking x" and "takes_property x" and "(\<not> taking_necessary_to_avoid_danger x)"
  shows "final_legal_result_holds x imprisonment_between_3_10_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_04_support_0:
  assumes "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "property_value_large x" and "(\<not> pushes_victim_during_taking x)" and "takes_property x" and "(\<not> threatens_immediate_harm x)"
  shows "final_legal_result_holds x imprisonment_between_3_10_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_04_support_1:
  assumes "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "property_value_large x" and "(\<not> pushes_victim_during_taking x)" and "takes_property x" and "(\<not> taking_necessary_to_avoid_danger x)" and "(\<not> threatens_immediate_harm x)"
  shows "final_legal_result_holds x imprisonment_between_3_10_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_05_support_0:
  assumes "owner_gave_permission x" and "takes_property x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_06_support_0:
  assumes "immediate_danger x" and "takes_property x" and "taking_necessary_to_avoid_danger x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_07_support_0:
  assumes "owner_gave_permission x" and "takes_property x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_08_support_0:
  assumes "owner_gave_permission x" and "takes_property x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_09_support_0:
  assumes "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "pushes_victim_during_taking x" and "takes_property x"
  shows "final_legal_result_holds x imprisonment_between_3_10_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_09_support_1:
  assumes "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "pushes_victim_during_taking x" and "takes_property x" and "(\<not> taking_necessary_to_avoid_danger x)"
  shows "final_legal_result_holds x imprisonment_between_3_10_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_10_support_0:
  assumes "immediate_danger x" and "takes_property x" and "taking_necessary_to_avoid_danger x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_11_support_0:
  assumes "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "property_value_large x" and "(\<not> pushes_victim_during_taking x)" and "takes_property x" and "(\<not> threatens_immediate_harm x)"
  shows "final_legal_result_holds x imprisonment_between_3_10_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_11_support_1:
  assumes "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "property_value_large x" and "(\<not> pushes_victim_during_taking x)" and "takes_property x" and "(\<not> taking_necessary_to_avoid_danger x)" and "(\<not> threatens_immediate_harm x)"
  shows "final_legal_result_holds x imprisonment_between_3_10_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_12_support_0:
  assumes "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "takes_property x" and "threatens_immediate_harm x"
  shows "final_legal_result_holds x imprisonment_between_3_10_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_12_support_1:
  assumes "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "takes_property x" and "(\<not> taking_necessary_to_avoid_danger x)" and "threatens_immediate_harm x"
  shows "final_legal_result_holds x imprisonment_between_3_10_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_13_support_0:
  assumes "deception_used x" and "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_13_support_1:
  assumes "deception_used x" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "(\<not> taking_necessary_to_avoid_danger x)" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_14_support_0:
  assumes "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "takes_property x" and "threatens_immediate_harm x"
  shows "final_legal_result_holds x imprisonment_between_3_10_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_14_support_1:
  assumes "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "takes_property x" and "(\<not> taking_necessary_to_avoid_danger x)" and "threatens_immediate_harm x"
  shows "final_legal_result_holds x imprisonment_between_3_10_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_15_support_0:
  assumes "deception_used x" and "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_15_support_1:
  assumes "deception_used x" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "(\<not> taking_necessary_to_avoid_danger x)" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_16_support_0:
  assumes "deception_used x" and "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_16_support_1:
  assumes "deception_used x" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "(\<not> taking_necessary_to_avoid_danger x)" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_17_support_0:
  assumes "deception_used x" and "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_17_support_1:
  assumes "deception_used x" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "(\<not> taking_necessary_to_avoid_danger x)" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_18_support_0:
  assumes "deception_used x" and "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_18_support_1:
  assumes "deception_used x" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "(\<not> taking_necessary_to_avoid_danger x)" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_19_support_0:
  assumes "deception_used x" and "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_19_support_1:
  assumes "deception_used x" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "(\<not> taking_necessary_to_avoid_danger x)" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_20_support_0:
  assumes "deception_used x" and "(\<not> immediate_danger x)" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_20_support_1:
  assumes "deception_used x" and "intent_to_keep_unlawfully x" and "(\<not> owner_gave_permission x)" and "property_belongs_to_another x" and "(\<not> taking_necessary_to_avoid_danger x)" and "victim_transfers_property x"
  shows "final_legal_result_holds x imprisonment_not_exceeding_3_years"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_21_support_0:
  assumes "immediate_danger x" and "takes_property x" and "taking_necessary_to_avoid_danger x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_21_support_1:
  assumes "owner_gave_permission x" and "takes_property x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_22_support_0:
  assumes "immediate_danger x" and "takes_property x" and "taking_necessary_to_avoid_danger x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_22_support_1:
  assumes "owner_gave_permission x" and "takes_property x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_23_support_0:
  assumes "immediate_danger x" and "takes_property x" and "taking_necessary_to_avoid_danger x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_23_support_1:
  assumes "owner_gave_permission x" and "takes_property x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_24_support_0:
  assumes "immediate_danger x" and "takes_property x" and "taking_necessary_to_avoid_danger x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_24_support_1:
  assumes "owner_gave_permission x" and "takes_property x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_25_support_0:
  assumes "owner_gave_permission x" and "takes_property x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_26_support_0:
  assumes "immediate_danger x" and "takes_property x" and "taking_necessary_to_avoid_danger x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_27_support_0:
  assumes "immediate_danger x" and "takes_property x" and "taking_necessary_to_avoid_danger x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_27_support_1:
  assumes "owner_gave_permission x" and "takes_property x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_28_support_0:
  assumes "owner_gave_permission x" and "takes_property x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_29_support_0:
  assumes "immediate_danger x" and "takes_property x" and "taking_necessary_to_avoid_danger x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_29_support_1:
  assumes "owner_gave_permission x" and "takes_property x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
lemma pcwd_case_30_support_0:
  assumes "owner_gave_permission x" and "takes_property x"
  shows "final_no_liability x"
  using assms by (auto simp: property_taking_def unlawful_intent_def force_or_threat_during_taking_def transferred_property_of_another_def deception_induced_transfer_def high_value_property_def owner_authorized_taking_def emergency_property_taking_def theft_conduct_def fraud_conduct_def consent_defense_def necessity_defense_def defeated_def applicable_def overrides_def final_no_liability_def final_legal_result_holds_def ex_article)
end
