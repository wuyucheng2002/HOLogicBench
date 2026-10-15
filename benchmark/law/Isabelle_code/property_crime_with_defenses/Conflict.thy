theory Conflict
  imports Middle_concept
begin

fun stronger_than :: "article => article => bool" where
  "stronger_than Art_Robbery Art_Theft = True"
| "stronger_than Art_Aggravated_Theft Art_Theft = True"
| "stronger_than Art_Robbery Art_Aggravated_Theft = True"
| "stronger_than Art_Fraud Art_Theft = True"
| "stronger_than _ _ = False"

fun exception_to :: "article => article => bool" where
  "exception_to Art_Consent_Defense Art_Theft = True"
| "exception_to Art_Consent_Defense Art_Fraud = True"
| "exception_to Art_Consent_Defense Art_Robbery = True"
| "exception_to Art_Consent_Defense Art_Aggravated_Theft = True"
| "exception_to Art_Necessity_Defense Art_Theft = True"
| "exception_to Art_Necessity_Defense Art_Fraud = True"
| "exception_to Art_Necessity_Defense Art_Robbery = True"
| "exception_to Art_Necessity_Defense Art_Aggravated_Theft = True"
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
