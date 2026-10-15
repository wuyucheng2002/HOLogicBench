theory Conflict
  imports Middle_concept
begin

fun stronger_than :: "article => article => bool" where
  "stronger_than Art_Route_Misdirection Art_Unauthorized_Signal_Change = True"
| "stronger_than Art_Sealed_Track_Breach Art_Unauthorized_Signal_Change = True"
| "stronger_than Art_Sealed_Track_Breach Art_Route_Misdirection = True"
| "stronger_than _ _ = False"

fun exception_to :: "article => article => bool" where
  "exception_to Art_Dispatch_Order_Authorization Art_Unauthorized_Signal_Change = True"
| "exception_to Art_Dispatch_Order_Authorization Art_Route_Misdirection = True"
| "exception_to Art_Collapse_Avoidance_Authorization Art_Unauthorized_Signal_Change = True"
| "exception_to Art_Collapse_Avoidance_Authorization Art_Route_Misdirection = True"
| "exception_to Art_Collapse_Avoidance_Authorization Art_Sealed_Track_Breach = True"
| "exception_to Art_Sensor_Fault_Exemption Art_Route_Misdirection = True"
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
