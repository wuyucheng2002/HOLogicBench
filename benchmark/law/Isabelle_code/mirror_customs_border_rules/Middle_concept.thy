theory Middle_concept
  imports Case_kernel
begin

definition unregistered_mirror_crossing_basis :: "person => bool" where
  "unregistered_mirror_crossing_basis x \<longleftrightarrow> mirror_crossing x"

definition shadow_cargo_irregularity_basis :: "person => bool" where
  "shadow_cargo_irregularity_basis x \<longleftrightarrow> (mirror_crossing x \<and> shadow_cargo_irregularity x)"

definition label_inversion_basis :: "person => bool" where
  "label_inversion_basis x \<longleftrightarrow> (shadow_cargo_irregularity x \<and> label_inversion x)"

definition customs_clearance_authorization_basis :: "person => bool" where
  "customs_clearance_authorization_basis x \<longleftrightarrow> (customs_clearance x \<and> mirror_crossing x)"

definition mirror_rescue_transfer_basis :: "person => bool" where
  "mirror_rescue_transfer_basis x \<longleftrightarrow> (mirror_rescue_transfer x \<and> mirror_crossing x)"

definition returned_cargo_allowance_basis :: "person => bool" where
  "returned_cargo_allowance_basis x \<longleftrightarrow> (returned_cargo_record x \<and> shadow_cargo_irregularity x)"

fun article_triggered :: "article => person => bool" where
  "article_triggered Art_Unregistered_Mirror_Crossing x =
    unregistered_mirror_crossing_basis x"
| "article_triggered Art_Shadow_Cargo_Irregularity x =
    shadow_cargo_irregularity_basis x"
| "article_triggered Art_Label_Inversion x =
    label_inversion_basis x"
| "article_triggered Art_Customs_Clearance_Authorization x =
    customs_clearance_authorization_basis x"
| "article_triggered Art_Mirror_Rescue_Transfer x =
    mirror_rescue_transfer_basis x"
| "article_triggered Art_Returned_Cargo_Allowance x =
    returned_cargo_allowance_basis x"

end
