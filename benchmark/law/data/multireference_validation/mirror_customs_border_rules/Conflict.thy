theory Conflict
  imports Middle_concept
begin

fun stronger_than :: "article => article => bool" where
  "stronger_than Art_Shadow_Cargo_Irregularity Art_Unregistered_Mirror_Crossing = True"
| "stronger_than Art_Label_Inversion Art_Unregistered_Mirror_Crossing = True"
| "stronger_than Art_Label_Inversion Art_Shadow_Cargo_Irregularity = True"
| "stronger_than _ _ = False"

fun exception_to :: "article => article => bool" where
  "exception_to Art_Customs_Clearance_Authorization Art_Unregistered_Mirror_Crossing = True"
| "exception_to Art_Customs_Clearance_Authorization Art_Shadow_Cargo_Irregularity = True"
| "exception_to Art_Mirror_Rescue_Transfer Art_Unregistered_Mirror_Crossing = True"
| "exception_to Art_Mirror_Rescue_Transfer Art_Shadow_Cargo_Irregularity = True"
| "exception_to Art_Mirror_Rescue_Transfer Art_Label_Inversion = True"
| "exception_to Art_Returned_Cargo_Allowance Art_Shadow_Cargo_Irregularity = True"
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
