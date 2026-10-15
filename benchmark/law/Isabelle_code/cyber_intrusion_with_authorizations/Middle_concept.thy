theory Middle_concept
  imports Case_kernel
begin

definition intrusion_basis :: "person => bool" where
  "intrusion_basis x =
    (access_method x \<and> protected_system x)"

definition data_acquisition_basis :: "person => bool" where
  "data_acquisition_basis x =
    (intrusion_basis x \<and> data_copy_action x)"

definition service_interference_basis :: "person => bool" where
  "service_interference_basis x =
    (intrusion_basis x \<and> disruptive_action x)"

definition payment_fraud_basis :: "person => bool" where
  "payment_fraud_basis x =
    (intrusion_basis x \<and> deceptive_payment_step x \<and> payment_obtained x)"

definition testing_authorization :: "person => bool" where
  "testing_authorization x = security_testing_safeguards x"

definition response_authorization :: "person => bool" where
  "response_authorization x = incident_response_safeguards x"

fun article_triggered :: "article => person => bool" where
  "article_triggered Art_Unauthorized_Access x =
    intrusion_basis x"
| "article_triggered Art_Data_Theft x =
    data_acquisition_basis x"
| "article_triggered Art_System_Disruption x =
    service_interference_basis x"
| "article_triggered Art_Financial_Cyber_Fraud x =
    payment_fraud_basis x"
| "article_triggered Art_Security_Testing_Authorization x =
    (intrusion_basis x \<and> testing_authorization x)"
| "article_triggered Art_Incident_Response_Authorization x =
    (intrusion_basis x \<and> response_authorization x)"

end
