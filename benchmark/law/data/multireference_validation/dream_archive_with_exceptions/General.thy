theory General
  imports Main
begin

typedecl person

datatype article =
    Art_Unregistered_Archive_Entry
  | Art_Dream_Page_Intervention
  | Art_Fading_Archive_Damage
  | Art_Restorer_Route_Authorization
  | Art_Emergency_Preservation_Authorization
  | Art_Visitor_Escort_Allowance

datatype legal_result =
    No_Criminal_Liability
  | quiet_room_warning
  | page_quarantine_order
  | memory_shelf_sealing

fun article_result :: "article => legal_result" where
  "article_result Art_Unregistered_Archive_Entry = quiet_room_warning"
| "article_result Art_Dream_Page_Intervention = page_quarantine_order"
| "article_result Art_Fading_Archive_Damage = memory_shelf_sealing"
| "article_result Art_Restorer_Route_Authorization = No_Criminal_Liability"
| "article_result Art_Emergency_Preservation_Authorization = No_Criminal_Liability"
| "article_result Art_Visitor_Escort_Allowance = No_Criminal_Liability"

end
