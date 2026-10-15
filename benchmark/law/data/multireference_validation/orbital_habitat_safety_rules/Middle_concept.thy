theory Middle_concept
  imports Case_kernel
begin

definition restricted_airlock_operation_basis :: "person => bool" where
  "restricted_airlock_operation_basis x \<longleftrightarrow> restricted_airlock_operation x"

definition oxygen_system_interference_basis :: "person => bool" where
  "oxygen_system_interference_basis x \<longleftrightarrow> (restricted_airlock_operation x \<and> oxygen_system_interference x)"

definition corridor_safety_obstruction_basis :: "person => bool" where
  "corridor_safety_obstruction_basis x \<longleftrightarrow> (restricted_airlock_operation x \<and> corridor_safety_obstruction x)"

definition habitat_duty_authorization_basis :: "person => bool" where
  "habitat_duty_authorization_basis x \<longleftrightarrow> (habitat_authority x \<and> restricted_airlock_operation x)"

definition salvage_emergency_authorization_basis :: "person => bool" where
  "salvage_emergency_authorization_basis x \<longleftrightarrow> (salvage_emergency x \<and> restricted_airlock_operation x)"

definition pressure_stabilization_exemption_basis :: "person => bool" where
  "pressure_stabilization_exemption_basis x \<longleftrightarrow> (pressure_stabilization x \<and> oxygen_system_interference x)"

fun article_triggered :: "article => person => bool" where
  "article_triggered Art_Restricted_Airlock_Operation x =
    restricted_airlock_operation_basis x"
| "article_triggered Art_Oxygen_System_Interference x =
    oxygen_system_interference_basis x"
| "article_triggered Art_Corridor_Safety_Obstruction x =
    corridor_safety_obstruction_basis x"
| "article_triggered Art_Habitat_Duty_Authorization x =
    habitat_duty_authorization_basis x"
| "article_triggered Art_Salvage_Emergency_Authorization x =
    salvage_emergency_authorization_basis x"
| "article_triggered Art_Pressure_Stabilization_Exemption x =
    pressure_stabilization_exemption_basis x"

end
