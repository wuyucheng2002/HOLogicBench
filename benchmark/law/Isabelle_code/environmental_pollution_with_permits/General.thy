theory General
  imports Main
begin

typedecl person

datatype article =
    Art_Unlawful_Discharge
  | Art_Hazardous_Waste_Dumping
  | Art_Serious_Contamination
  | Art_Falsified_Monitoring
  | Art_Valid_Permit_Defense
  | Art_Emergency_Release_Defense

datatype legal_result =
    No_Criminal_Liability
  | fine_or_short_detention
  | imprisonment_not_exceeding_3_years
  | imprisonment_between_3_7_years
  | imprisonment_between_7_15_years

fun article_result :: "article => legal_result" where
  "article_result Art_Unlawful_Discharge = fine_or_short_detention"
| "article_result Art_Hazardous_Waste_Dumping = imprisonment_not_exceeding_3_years"
| "article_result Art_Serious_Contamination = imprisonment_between_7_15_years"
| "article_result Art_Falsified_Monitoring = imprisonment_between_3_7_years"
| "article_result Art_Valid_Permit_Defense = No_Criminal_Liability"
| "article_result Art_Emergency_Release_Defense = No_Criminal_Liability"

end
