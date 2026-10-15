theory General
  imports Main
begin

typedecl person

datatype article =
    Art_Unauthorized_Access
  | Art_Data_Theft
  | Art_System_Disruption
  | Art_Financial_Cyber_Fraud
  | Art_Security_Testing_Authorization
  | Art_Incident_Response_Authorization

datatype legal_result =
    No_Criminal_Liability
  | fine_or_short_detention
  | imprisonment_not_exceeding_3_years
  | imprisonment_between_3_7_years
  | imprisonment_between_7_15_years

fun article_result :: "article => legal_result" where
  "article_result Art_Unauthorized_Access = fine_or_short_detention"
| "article_result Art_Data_Theft = imprisonment_not_exceeding_3_years"
| "article_result Art_System_Disruption = imprisonment_between_3_7_years"
| "article_result Art_Financial_Cyber_Fraud = imprisonment_between_7_15_years"
| "article_result Art_Security_Testing_Authorization = No_Criminal_Liability"
| "article_result Art_Incident_Response_Authorization = No_Criminal_Liability"

end
