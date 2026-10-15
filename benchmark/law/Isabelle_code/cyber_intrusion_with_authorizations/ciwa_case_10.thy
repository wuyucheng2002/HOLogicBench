theory ciwa_case_10
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "uses_stolen_password actor"
and f2: "target_system_requires_authorization actor"
and f3: "downloads_customer_records actor"
and f4: "deletes_server_files actor"
and f5: "redirects_invoice_account actor"
and f6: "obtains_victim_payment actor"
and f7: "receives_incident_response_order actor"
and f8: "limits_actions_to_containment actor"
and f9: "preserves_activity_logs actor"
and f10: "\<not> bypasses_login_control actor"
and f11: "\<not> exploits_unpatched_service actor"
and f12: "\<not> owner_permission_for_access actor"
and f13: "\<not> copies_authentication_tokens actor"
and f14: "\<not> exports_database_snapshot actor"
and f15: "\<not> disables_monitoring_service actor"
and f16: "\<not> floods_service_with_requests actor"
and f17: "\<not> sends_fake_payment_request actor"
and f18: "\<not> has_security_testing_contract actor"
and f19: "\<not> stays_within_test_scope actor"
and f20: "\<not> reports_findings_promptly actor"

lemma derive_access_method: "access_method actor"
  using f1
  unfolding access_method_def
  by simp
lemma derive_protected_system: "protected_system actor"
  using f2 f12
  unfolding protected_system_def
  by simp
lemma derive_data_copy_action: "data_copy_action actor"
  using f3
  unfolding data_copy_action_def
  by simp
lemma derive_disruptive_action: "disruptive_action actor"
  using f4
  unfolding disruptive_action_def
  by simp
lemma derive_deceptive_payment_step: "deceptive_payment_step actor"
  using f5
  unfolding deceptive_payment_step_def
  by simp
lemma derive_payment_obtained: "payment_obtained actor"
  using f6
  unfolding payment_obtained_def
  by simp
lemma derive_incident_response_safeguards: "incident_response_safeguards actor"
  using f7 f8 f9
  unfolding incident_response_safeguards_def
  by simp
lemma derive_intrusion_basis: "intrusion_basis actor"
  using derive_access_method derive_protected_system
  unfolding intrusion_basis_def
  by simp
lemma derive_data_acquisition_basis: "data_acquisition_basis actor"
  using derive_intrusion_basis derive_data_copy_action
  unfolding data_acquisition_basis_def
  by simp
lemma derive_service_interference_basis: "service_interference_basis actor"
  using derive_intrusion_basis derive_disruptive_action
  unfolding service_interference_basis_def
  by simp
lemma derive_payment_fraud_basis: "payment_fraud_basis actor"
  using derive_intrusion_basis derive_deceptive_payment_step derive_payment_obtained
  unfolding payment_fraud_basis_def
  by simp
lemma derive_response_authorization: "response_authorization actor"
  using derive_incident_response_safeguards
  unfolding response_authorization_def
  by simp
lemma trigger_art_unauthorized_access: "article_triggered Art_Unauthorized_Access actor"
  using derive_intrusion_basis
  by simp
lemma trigger_art_data_theft: "article_triggered Art_Data_Theft actor"
  using derive_data_acquisition_basis
  by simp
lemma trigger_art_system_disruption: "article_triggered Art_System_Disruption actor"
  using derive_service_interference_basis
  by simp
lemma trigger_art_financial_cyber_fraud: "article_triggered Art_Financial_Cyber_Fraud actor"
  using derive_payment_fraud_basis
  by simp
lemma trigger_art_incident_response_authorization: "article_triggered Art_Incident_Response_Authorization actor"
  using derive_intrusion_basis derive_response_authorization
  by simp

lemma overrides_art_data_theft_art_unauthorized_access: "overrides Art_Data_Theft Art_Unauthorized_Access"
  unfolding overrides_def
  by simp
lemma overrides_art_system_disruption_art_unauthorized_access: "overrides Art_System_Disruption Art_Unauthorized_Access"
  unfolding overrides_def
  by simp
lemma overrides_art_financial_cyber_fraud_art_unauthorized_access: "overrides Art_Financial_Cyber_Fraud Art_Unauthorized_Access"
  unfolding overrides_def
  by simp
lemma overrides_art_financial_cyber_fraud_art_data_theft: "overrides Art_Financial_Cyber_Fraud Art_Data_Theft"
  unfolding overrides_def
  by simp
lemma overrides_art_system_disruption_art_data_theft: "overrides Art_System_Disruption Art_Data_Theft"
  unfolding overrides_def
  by simp
lemma overrides_art_incident_response_authorization_art_unauthorized_access: "overrides Art_Incident_Response_Authorization Art_Unauthorized_Access"
  unfolding overrides_def
  by simp
lemma overrides_art_incident_response_authorization_art_data_theft: "overrides Art_Incident_Response_Authorization Art_Data_Theft"
  unfolding overrides_def
  by simp
lemma overrides_art_incident_response_authorization_art_system_disruption: "overrides Art_Incident_Response_Authorization Art_System_Disruption"
  unfolding overrides_def
  by simp
lemma overrides_art_incident_response_authorization_art_financial_cyber_fraud: "overrides Art_Incident_Response_Authorization Art_Financial_Cyber_Fraud"
  unfolding overrides_def
  by simp


lemma defeated_art_financial_cyber_fraud: "defeated actor Art_Financial_Cyber_Fraud"
  using trigger_art_financial_cyber_fraud trigger_art_incident_response_authorization overrides_art_incident_response_authorization_art_financial_cyber_fraud
  unfolding defeated_def
  by blast
lemma not_applicable_art_financial_cyber_fraud: "\<not> applicable actor Art_Financial_Cyber_Fraud"
  using trigger_art_financial_cyber_fraud defeated_art_financial_cyber_fraud
  unfolding applicable_def
  by blast
lemma defeated_art_system_disruption: "defeated actor Art_System_Disruption"
  using trigger_art_system_disruption trigger_art_incident_response_authorization overrides_art_incident_response_authorization_art_system_disruption
  unfolding defeated_def
  by blast
lemma not_applicable_art_system_disruption: "\<not> applicable actor Art_System_Disruption"
  using trigger_art_system_disruption defeated_art_system_disruption
  unfolding applicable_def
  by blast
lemma defeated_art_data_theft: "defeated actor Art_Data_Theft"
  using trigger_art_data_theft trigger_art_financial_cyber_fraud overrides_art_financial_cyber_fraud_art_data_theft
  unfolding defeated_def
  by blast
lemma not_applicable_art_data_theft: "\<not> applicable actor Art_Data_Theft"
  using trigger_art_data_theft defeated_art_data_theft
  unfolding applicable_def
  by blast
lemma defeated_art_unauthorized_access: "defeated actor Art_Unauthorized_Access"
  using trigger_art_unauthorized_access trigger_art_data_theft overrides_art_data_theft_art_unauthorized_access
  unfolding defeated_def
  by blast
lemma not_applicable_art_unauthorized_access: "\<not> applicable actor Art_Unauthorized_Access"
  using trigger_art_unauthorized_access defeated_art_unauthorized_access
  unfolding applicable_def
  by blast
lemma not_defeated_art_incident_response_authorization: "\<not> defeated actor Art_Incident_Response_Authorization"
  using trigger_art_incident_response_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_incident_response_authorization: "applicable actor Art_Incident_Response_Authorization"
  using trigger_art_incident_response_authorization not_defeated_art_incident_response_authorization
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_incident_response_authorization
  unfolding final_no_liability_def
  by auto

end
