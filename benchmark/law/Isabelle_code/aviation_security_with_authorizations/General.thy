theory General
  imports Main
begin

typedecl person

datatype article =
    Art_Airside_Access_Breach
  | Art_Runway_Drone_Interference
  | Art_Navigation_Signal_Interference
  | Art_Compound_Airspace_Hazard
  | Art_Maintenance_Window_Authorization
  | Art_Emergency_Tarmac_Authorization

datatype legal_result =
    No_Criminal_Liability
  | fine_or_short_detention
  | imprisonment_not_exceeding_3_years
  | imprisonment_between_3_7_years
  | imprisonment_between_7_15_years

fun article_result :: "article => legal_result" where
  "article_result Art_Airside_Access_Breach = fine_or_short_detention"
| "article_result Art_Runway_Drone_Interference = imprisonment_not_exceeding_3_years"
| "article_result Art_Navigation_Signal_Interference = imprisonment_between_3_7_years"
| "article_result Art_Compound_Airspace_Hazard = imprisonment_between_7_15_years"
| "article_result Art_Maintenance_Window_Authorization = No_Criminal_Liability"
| "article_result Art_Emergency_Tarmac_Authorization = No_Criminal_Liability"

end
