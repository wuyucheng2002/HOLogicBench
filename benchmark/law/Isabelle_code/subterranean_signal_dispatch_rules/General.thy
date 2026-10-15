theory General
  imports Main
begin

typedecl person

datatype article =
    Art_Unauthorized_Signal_Change
  | Art_Route_Misdirection
  | Art_Sealed_Track_Breach
  | Art_Dispatch_Order_Authorization
  | Art_Collapse_Avoidance_Authorization
  | Art_Sensor_Fault_Exemption

datatype legal_result =
    No_Criminal_Liability
  | signal_reprimand
  | route_suspension
  | tunnel_access_ban

fun article_result :: "article => legal_result" where
  "article_result Art_Unauthorized_Signal_Change = signal_reprimand"
| "article_result Art_Route_Misdirection = route_suspension"
| "article_result Art_Sealed_Track_Breach = tunnel_access_ban"
| "article_result Art_Dispatch_Order_Authorization = No_Criminal_Liability"
| "article_result Art_Collapse_Avoidance_Authorization = No_Criminal_Liability"
| "article_result Art_Sensor_Fault_Exemption = No_Criminal_Liability"

end
