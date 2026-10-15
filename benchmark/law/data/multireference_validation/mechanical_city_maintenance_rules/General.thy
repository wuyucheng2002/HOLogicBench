theory General
  imports Main
begin

typedecl person

datatype article =
    Art_Restricted_Gear_Access
  | Art_Unsafe_Automaton_Release
  | Art_Public_Clock_Disruption
  | Art_Maintenance_Order_Authorization
  | Art_Emergency_Reset_Authorization
  | Art_Calibration_Fault_Exemption

datatype legal_result =
    No_Criminal_Liability
  | gear_room_warning
  | automaton_release_suspension
  | clock_tower_lockdown

fun article_result :: "article => legal_result" where
  "article_result Art_Restricted_Gear_Access = gear_room_warning"
| "article_result Art_Unsafe_Automaton_Release = automaton_release_suspension"
| "article_result Art_Public_Clock_Disruption = clock_tower_lockdown"
| "article_result Art_Maintenance_Order_Authorization = No_Criminal_Liability"
| "article_result Art_Emergency_Reset_Authorization = No_Criminal_Liability"
| "article_result Art_Calibration_Fault_Exemption = No_Criminal_Liability"

end
