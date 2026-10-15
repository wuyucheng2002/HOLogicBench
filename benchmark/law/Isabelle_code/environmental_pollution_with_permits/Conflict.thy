theory Conflict
  imports Middle_concept
begin

fun stronger_than :: "article => article => bool" where
  "stronger_than Art_Serious_Contamination Art_Unlawful_Discharge = True"
| "stronger_than Art_Serious_Contamination Art_Hazardous_Waste_Dumping = True"
| "stronger_than Art_Serious_Contamination Art_Falsified_Monitoring = True"
| "stronger_than Art_Falsified_Monitoring Art_Unlawful_Discharge = True"
| "stronger_than Art_Hazardous_Waste_Dumping Art_Unlawful_Discharge = True"
| "stronger_than _ _ = False"

fun exception_to :: "article => article => bool" where
  "exception_to Art_Valid_Permit_Defense Art_Unlawful_Discharge = True"
| "exception_to Art_Valid_Permit_Defense Art_Serious_Contamination = True"
| "exception_to Art_Emergency_Release_Defense Art_Unlawful_Discharge = True"
| "exception_to Art_Emergency_Release_Defense Art_Serious_Contamination = True"
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
