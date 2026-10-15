theory Conflict
  imports Middle_concept
begin

fun stronger_than :: "article => article => bool" where
  "stronger_than Art_Relic_Handling_Breach Art_Restricted_Shelf_Access = True"
| "stronger_than Art_Catalog_Alteration Art_Restricted_Shelf_Access = True"
| "stronger_than Art_Vault_Removal Art_Restricted_Shelf_Access = True"
| "stronger_than Art_Vault_Removal Art_Relic_Handling_Breach = True"
| "stronger_than Art_Vault_Removal Art_Catalog_Alteration = True"
| "stronger_than _ _ = False"

fun exception_to :: "article => article => bool" where
  "exception_to Art_Curator_Order_Authorization Art_Restricted_Shelf_Access = True"
| "exception_to Art_Curator_Order_Authorization Art_Relic_Handling_Breach = True"
| "exception_to Art_Curator_Order_Authorization Art_Catalog_Alteration = True"
| "exception_to Art_Flood_Rescue_Authorization Art_Restricted_Shelf_Access = True"
| "exception_to Art_Flood_Rescue_Authorization Art_Relic_Handling_Breach = True"
| "exception_to Art_Flood_Rescue_Authorization Art_Vault_Removal = True"
| "exception_to _ _ = False"

definition overrides :: "article => article => bool" where
  "overrides higher lower \<equiv>
    (stronger_than higher lower \<or> exception_to higher lower)"

definition defeated :: "person => article => bool" where
  "defeated x art \<equiv>
    (article_triggered art x
      \<and> (\<exists>higher. article_triggered higher x \<and> overrides higher art))"

definition applicable :: "person => article => bool" where
  "applicable x art \<equiv>
    (article_triggered art x \<and> \<not> defeated x art)"

definition final_no_liability :: "person => bool" where
  "final_no_liability x \<equiv>
    (\<exists>art. applicable x art \<and> article_result art = No_Criminal_Liability)"

definition final_legal_result_holds :: "person => legal_result => bool" where
  "final_legal_result_holds x j \<equiv>
  (\<not> final_no_liability x) \<and> (\<exists>art. applicable x art \<and> article_result art = j)"

end
