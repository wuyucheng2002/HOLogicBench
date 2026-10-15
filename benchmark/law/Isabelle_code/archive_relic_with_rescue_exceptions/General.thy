theory General
  imports Main
begin

typedecl person

datatype article =
    Art_Restricted_Shelf_Access
  | Art_Relic_Handling_Breach
  | Art_Catalog_Alteration
  | Art_Vault_Removal
  | Art_Curator_Order_Authorization
  | Art_Flood_Rescue_Authorization

datatype legal_result =
    No_Criminal_Liability
  | archive_warning
  | reading_room_suspension
  | conservation_quarantine
  | permanent_archive_exclusion

fun article_result :: "article => legal_result" where
  "article_result Art_Restricted_Shelf_Access = archive_warning"
| "article_result Art_Relic_Handling_Breach = reading_room_suspension"
| "article_result Art_Catalog_Alteration = conservation_quarantine"
| "article_result Art_Vault_Removal = permanent_archive_exclusion"
| "article_result Art_Curator_Order_Authorization = No_Criminal_Liability"
| "article_result Art_Flood_Rescue_Authorization = No_Criminal_Liability"

end
