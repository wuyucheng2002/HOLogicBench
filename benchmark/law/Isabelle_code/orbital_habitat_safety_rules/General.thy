theory General
  imports Main
begin

typedecl person

datatype article =
    Art_Restricted_Airlock_Operation
  | Art_Oxygen_System_Interference
  | Art_Corridor_Safety_Obstruction
  | Art_Habitat_Duty_Authorization
  | Art_Salvage_Emergency_Authorization
  | Art_Pressure_Stabilization_Exemption

datatype legal_result =
    No_Criminal_Liability
  | airlock_reprimand
  | oxygen_bay_quarantine
  | corridor_access_suspension

fun article_result :: "article => legal_result" where
  "article_result Art_Restricted_Airlock_Operation = airlock_reprimand"
| "article_result Art_Oxygen_System_Interference = oxygen_bay_quarantine"
| "article_result Art_Corridor_Safety_Obstruction = corridor_access_suspension"
| "article_result Art_Habitat_Duty_Authorization = No_Criminal_Liability"
| "article_result Art_Salvage_Emergency_Authorization = No_Criminal_Liability"
| "article_result Art_Pressure_Stabilization_Exemption = No_Criminal_Liability"

end
