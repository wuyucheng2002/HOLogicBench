theory Middle_concept
  imports Case_kernel
begin

definition unauthorized_signal_change_basis :: "person => bool" where
  "unauthorized_signal_change_basis x \<longleftrightarrow> signal_tampering x"

definition route_misdirection_basis :: "person => bool" where
  "route_misdirection_basis x \<longleftrightarrow> (signal_tampering x \<and> train_rerouting x)"

definition sealed_track_breach_basis :: "person => bool" where
  "sealed_track_breach_basis x \<longleftrightarrow> (seal_breach x \<and> route_misdirection_risk x)"

definition dispatch_order_authorization_basis :: "person => bool" where
  "dispatch_order_authorization_basis x \<longleftrightarrow> (dispatch_authority x \<and> signal_tampering x)"

definition collapse_avoidance_authorization_basis :: "person => bool" where
  "collapse_avoidance_authorization_basis x \<longleftrightarrow> (collapse_avoidance x \<and> signal_tampering x)"

definition sensor_fault_exemption_basis :: "person => bool" where
  "sensor_fault_exemption_basis x \<longleftrightarrow> (sensor_fault_condition x \<and> train_rerouting x)"

fun article_triggered :: "article => person => bool" where
  "article_triggered Art_Unauthorized_Signal_Change x =
    unauthorized_signal_change_basis x"
| "article_triggered Art_Route_Misdirection x =
    route_misdirection_basis x"
| "article_triggered Art_Sealed_Track_Breach x =
    sealed_track_breach_basis x"
| "article_triggered Art_Dispatch_Order_Authorization x =
    dispatch_order_authorization_basis x"
| "article_triggered Art_Collapse_Avoidance_Authorization x =
    collapse_avoidance_authorization_basis x"
| "article_triggered Art_Sensor_Fault_Exemption x =
    sensor_fault_exemption_basis x"

end
