theory ciwa_case_03
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "exploits_unpatched_service actor"
and f2: "target_system_requires_authorization actor"
and f3: "floods_service_with_requests actor"
and f4: "\<not> uses_stolen_password actor"
and f5: "\<not> bypasses_login_control actor"
and f6: "\<not> owner_permission_for_access actor"
and f7: "\<not> downloads_customer_records actor"
and f8: "\<not> copies_authentication_tokens actor"
and f9: "\<not> exports_database_snapshot actor"
and f10: "\<not> deletes_server_files actor"
and f11: "\<not> disables_monitoring_service actor"
and f12: "\<not> sends_fake_payment_request actor"
and f13: "\<not> redirects_invoice_account actor"
and f14: "\<not> obtains_victim_payment actor"
and f15: "\<not> has_security_testing_contract actor"
and f16: "\<not> stays_within_test_scope actor"
and f17: "\<not> reports_findings_promptly actor"
and f18: "\<not> receives_incident_response_order actor"
and f19: "\<not> limits_actions_to_containment actor"
and f20: "\<not> preserves_activity_logs actor"

lemma derive_access_method: "access_method actor"
  using f1
  unfolding access_method_def
  by simp
lemma derive_protected_system: "protected_system actor"
  using f2 f6
  unfolding protected_system_def
  by simp
lemma derive_disruptive_action: "disruptive_action actor"
  using f3
  unfolding disruptive_action_def
  by simp
lemma derive_intrusion_basis: "intrusion_basis actor"
  using derive_access_method derive_protected_system
  unfolding intrusion_basis_def
  by simp
lemma derive_service_interference_basis: "service_interference_basis actor"
  using derive_intrusion_basis derive_disruptive_action
  unfolding service_interference_basis_def
  by simp
lemma trigger_art_unauthorized_access: "article_triggered Art_Unauthorized_Access actor"
  using derive_intrusion_basis
  by simp
lemma trigger_art_system_disruption: "article_triggered Art_System_Disruption actor"
  using derive_service_interference_basis
  by simp

lemma overrides_art_system_disruption_art_unauthorized_access: "overrides Art_System_Disruption Art_Unauthorized_Access"
  unfolding overrides_def
  by simp

lemma not_trigger_art_security_testing_authorization: "\<not> article_triggered Art_Security_Testing_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20
  unfolding article_triggered.simps intrusion_basis_def access_method_def protected_system_def testing_authorization_def security_testing_safeguards_def
  by simp
lemma not_trigger_art_incident_response_authorization: "\<not> article_triggered Art_Incident_Response_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20
  unfolding article_triggered.simps intrusion_basis_def access_method_def protected_system_def response_authorization_def incident_response_safeguards_def
  by simp

lemma not_defeated_art_system_disruption: "\<not> defeated actor Art_System_Disruption"
proof
  assume defeated_assm: "defeated actor Art_System_Disruption"
  then obtain higher where
    higher_triggered: "article_triggered higher actor"
    and higher_overrides: "overrides higher Art_System_Disruption"
    unfolding defeated_def by blast
  then show False
    using not_trigger_art_security_testing_authorization not_trigger_art_incident_response_authorization
    unfolding overrides_def
    by (cases higher) auto
qed
lemma applicable_art_system_disruption: "applicable actor Art_System_Disruption"
  using trigger_art_system_disruption not_defeated_art_system_disruption
  unfolding applicable_def
  by blast
lemma defeated_art_unauthorized_access: "defeated actor Art_Unauthorized_Access"
  using trigger_art_unauthorized_access trigger_art_system_disruption overrides_art_system_disruption_art_unauthorized_access
  unfolding defeated_def
  by blast
lemma not_applicable_art_unauthorized_access: "\<not> applicable actor Art_Unauthorized_Access"
  using trigger_art_unauthorized_access defeated_art_unauthorized_access
  unfolding applicable_def
  by blast

lemma not_applicable_art_security_testing_authorization: "\<not> applicable actor Art_Security_Testing_Authorization"
  using not_trigger_art_security_testing_authorization
  unfolding applicable_def
  by blast
lemma not_applicable_art_incident_response_authorization: "\<not> applicable actor Art_Incident_Response_Authorization"
  using not_trigger_art_incident_response_authorization
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
    using art_applicable art_result not_applicable_art_security_testing_authorization not_applicable_art_incident_response_authorization
    by (cases art) auto
qed
theorem final_result_liability: "final_legal_result_holds actor imprisonment_between_3_7_years"
  using applicable_art_system_disruption not_final_no_liability
  unfolding final_legal_result_holds_def
  by auto

end
