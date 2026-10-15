theory Middle_concept
  imports Case_kernel
begin

definition airside_access_violation :: "person => bool" where
  "airside_access_violation x =
    (prohibited_airside_entry x \<and> restricted_airside_status x)"

definition runway_drone_interference :: "person => bool" where
  "runway_drone_interference x =
    (airside_access_violation x \<and> runway_drone_operation x \<and> active_runway_risk x)"

definition navigation_signal_interference :: "person => bool" where
  "navigation_signal_interference x =
    (signal_interference_conduct x \<and> aviation_warning_effect x)"

definition compound_airspace_hazard :: "person => bool" where
  "compound_airspace_hazard x =
    (runway_drone_interference x \<and> navigation_signal_interference x)"

definition maintenance_window_authorization :: "person => bool" where
  "maintenance_window_authorization x =
    (airside_access_violation x \<and> maintenance_authorization_records x)"

definition emergency_tarmac_authorization :: "person => bool" where
  "emergency_tarmac_authorization x =
    (airside_access_violation x \<and> emergency_tarmac_records x)"

fun article_triggered :: "article => person => bool" where
  "article_triggered Art_Airside_Access_Breach x =
    airside_access_violation x"
| "article_triggered Art_Runway_Drone_Interference x =
    runway_drone_interference x"
| "article_triggered Art_Navigation_Signal_Interference x =
    navigation_signal_interference x"
| "article_triggered Art_Compound_Airspace_Hazard x =
    compound_airspace_hazard x"
| "article_triggered Art_Maintenance_Window_Authorization x =
    maintenance_window_authorization x"
| "article_triggered Art_Emergency_Tarmac_Authorization x =
    emergency_tarmac_authorization x"

end
