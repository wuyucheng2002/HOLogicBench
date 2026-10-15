theory Middle_concept
  imports Case_kernel
begin

definition restricted_gear_access_basis :: "person => bool" where
  "restricted_gear_access_basis x \<longleftrightarrow> restricted_mechanical_access x"

definition unsafe_automaton_release_basis :: "person => bool" where
  "unsafe_automaton_release_basis x \<longleftrightarrow> (restricted_mechanical_access x \<and> unsafe_automaton_release x)"

definition public_clock_disruption_basis :: "person => bool" where
  "public_clock_disruption_basis x \<longleftrightarrow> (clock_disruption x \<and> restricted_mechanical_access x)"

definition maintenance_order_authorization_basis :: "person => bool" where
  "maintenance_order_authorization_basis x \<longleftrightarrow> (maintenance_authority x \<and> restricted_mechanical_access x)"

definition emergency_reset_authorization_basis :: "person => bool" where
  "emergency_reset_authorization_basis x \<longleftrightarrow> (emergency_reset_action x \<and> clock_disruption x)"

definition calibration_fault_exemption_basis :: "person => bool" where
  "calibration_fault_exemption_basis x \<longleftrightarrow> (calibration_fault_condition x \<and> clock_disruption x)"

fun article_triggered :: "article => person => bool" where
  "article_triggered Art_Restricted_Gear_Access x =
    restricted_gear_access_basis x"
| "article_triggered Art_Unsafe_Automaton_Release x =
    unsafe_automaton_release_basis x"
| "article_triggered Art_Public_Clock_Disruption x =
    public_clock_disruption_basis x"
| "article_triggered Art_Maintenance_Order_Authorization x =
    maintenance_order_authorization_basis x"
| "article_triggered Art_Emergency_Reset_Authorization x =
    emergency_reset_authorization_basis x"
| "article_triggered Art_Calibration_Fault_Exemption x =
    calibration_fault_exemption_basis x"

end
