theory Case_kernel
  imports General
begin

consts
  uses_stolen_password :: "person => bool"
  bypasses_login_control :: "person => bool"
  exploits_unpatched_service :: "person => bool"
  target_system_requires_authorization :: "person => bool"
  owner_permission_for_access :: "person => bool"

  downloads_customer_records :: "person => bool"
  copies_authentication_tokens :: "person => bool"
  exports_database_snapshot :: "person => bool"

  deletes_server_files :: "person => bool"
  disables_monitoring_service :: "person => bool"
  floods_service_with_requests :: "person => bool"

  sends_fake_payment_request :: "person => bool"
  redirects_invoice_account :: "person => bool"
  obtains_victim_payment :: "person => bool"

  has_security_testing_contract :: "person => bool"
  stays_within_test_scope :: "person => bool"
  reports_findings_promptly :: "person => bool"

  receives_incident_response_order :: "person => bool"
  limits_actions_to_containment :: "person => bool"
  preserves_activity_logs :: "person => bool"

definition access_method :: "person => bool" where
  "access_method x =
    (uses_stolen_password x
      \<or> bypasses_login_control x
      \<or> exploits_unpatched_service x)"

definition protected_system :: "person => bool" where
  "protected_system x =
    (target_system_requires_authorization x
      \<and> (\<not> owner_permission_for_access x))"

definition data_copy_action :: "person => bool" where
  "data_copy_action x =
    (downloads_customer_records x
      \<or> copies_authentication_tokens x
      \<or> exports_database_snapshot x)"

definition disruptive_action :: "person => bool" where
  "disruptive_action x =
    (deletes_server_files x
      \<or> disables_monitoring_service x
      \<or> floods_service_with_requests x)"

definition deceptive_payment_step :: "person => bool" where
  "deceptive_payment_step x =
    (sends_fake_payment_request x
      \<or> redirects_invoice_account x)"

definition payment_obtained :: "person => bool" where
  "payment_obtained x = obtains_victim_payment x"

definition security_testing_safeguards :: "person => bool" where
  "security_testing_safeguards x =
    (has_security_testing_contract x
      \<and> stays_within_test_scope x
      \<and> reports_findings_promptly x)"

definition incident_response_safeguards :: "person => bool" where
  "incident_response_safeguards x =
    (receives_incident_response_order x
      \<and> limits_actions_to_containment x
      \<and> preserves_activity_logs x)"

end
