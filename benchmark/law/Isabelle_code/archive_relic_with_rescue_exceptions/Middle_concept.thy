theory Middle_concept
  imports Case_kernel
begin

definition restricted_shelf_violation :: "person => bool" where
  "restricted_shelf_violation x =
    (unauthorized_stack_entry x \<and> restricted_shelf_status x)"

definition relic_handling_violation :: "person => bool" where
  "relic_handling_violation x =
    (restricted_shelf_violation x \<and> fragile_relic_handling x)"

definition catalog_alteration_violation :: "person => bool" where
  "catalog_alteration_violation x =
    (restricted_shelf_violation x \<and> catalog_record_interference x)"

definition vault_removal_basis :: "person => bool" where
  "vault_removal_basis x =
    (relic_handling_violation x \<and> vault_exit_step x)"

definition curator_order_authorization :: "person => bool" where
  "curator_order_authorization x =
    (relic_handling_violation x \<and> curator_authorization_records x)"

definition flood_rescue_authorization :: "person => bool" where
  "flood_rescue_authorization x =
    (restricted_shelf_violation x \<and> flood_rescue_records x)"

fun article_triggered :: "article => person => bool" where
  "article_triggered Art_Restricted_Shelf_Access x =
    restricted_shelf_violation x"
| "article_triggered Art_Relic_Handling_Breach x =
    relic_handling_violation x"
| "article_triggered Art_Catalog_Alteration x =
    catalog_alteration_violation x"
| "article_triggered Art_Vault_Removal x =
    vault_removal_basis x"
| "article_triggered Art_Curator_Order_Authorization x =
    curator_order_authorization x"
| "article_triggered Art_Flood_Rescue_Authorization x =
    flood_rescue_authorization x"

end
