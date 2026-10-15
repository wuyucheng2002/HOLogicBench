theory General
  imports Main
begin

typedecl person

datatype article =
    Art_Theft
  | Art_Fraud
  | Art_Robbery
  | Art_Aggravated_Theft
  | Art_Consent_Defense
  | Art_Necessity_Defense

datatype legal_result =
    No_Criminal_Liability
  | imprisonment_not_exceeding_3_years
  | imprisonment_between_3_10_years

fun article_result :: "article => legal_result" where
  "article_result Art_Theft = imprisonment_not_exceeding_3_years"
| "article_result Art_Fraud = imprisonment_not_exceeding_3_years"
| "article_result Art_Robbery = imprisonment_between_3_10_years"
| "article_result Art_Aggravated_Theft = imprisonment_between_3_10_years"
| "article_result Art_Consent_Defense = No_Criminal_Liability"
| "article_result Art_Necessity_Defense = No_Criminal_Liability"

end
