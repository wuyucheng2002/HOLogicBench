theory mcmr_case_16
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "opens_service_hatch actor"
and f2: "pulls_copper_speed_pin actor"
and f3: "public_clock_stops actor"
and f4: "reset_alarm_sounds actor"
and f5: "wears_maintenance_badge actor"
and f6: "receives_municipal_order actor"
and f7: "supervisor_seals_work_ticket actor"
and f8: "turns_clocktower_reset_wheel actor"
and f9: "reports_reset_to_clock_desk actor"
and f10: "fault_flag_raised_before_contact actor"
and f11: "calibration_panel_records_fault actor"
and f12: "\<not> opens_gear_well_cover actor"
and f13: "\<not> loosens_brass_regulator actor"
and f14: "\<not> releases_uncalibrated_automaton actor"
and f15: "\<not> releases_clockwork_runner actor"
and f16: "\<not> automaton_crosses_public_line actor"
and f17: "\<not> runner_enters_public_square actor"

lemma derive_restricted_mechanical_access: "restricted_mechanical_access actor"
  using f1 f2
  unfolding restricted_mechanical_access_def
  by simp
lemma derive_clock_disruption: "clock_disruption actor"
  using f3 derive_restricted_mechanical_access
  unfolding clock_disruption_def
  by simp
lemma derive_maintenance_authority: "maintenance_authority actor"
  using f5 f6 f7
  unfolding maintenance_authority_def
  by simp
lemma derive_emergency_reset_action: "emergency_reset_action actor"
  using f3 f4 f8 f9
  unfolding emergency_reset_action_def
  by simp
lemma derive_calibration_fault_condition: "calibration_fault_condition actor"
  using f10 f11
  unfolding calibration_fault_condition_def
  by simp
lemma derive_restricted_gear_access_basis: "restricted_gear_access_basis actor"
  using derive_restricted_mechanical_access
  unfolding restricted_gear_access_basis_def
  by simp
lemma derive_public_clock_disruption_basis: "public_clock_disruption_basis actor"
  using derive_clock_disruption derive_restricted_mechanical_access
  unfolding public_clock_disruption_basis_def
  by simp
lemma derive_maintenance_order_authorization_basis: "maintenance_order_authorization_basis actor"
  using derive_maintenance_authority derive_restricted_mechanical_access
  unfolding maintenance_order_authorization_basis_def
  by simp
lemma derive_emergency_reset_authorization_basis: "emergency_reset_authorization_basis actor"
  using derive_emergency_reset_action derive_clock_disruption
  unfolding emergency_reset_authorization_basis_def
  by simp
lemma derive_calibration_fault_exemption_basis: "calibration_fault_exemption_basis actor"
  using derive_calibration_fault_condition derive_clock_disruption
  unfolding calibration_fault_exemption_basis_def
  by simp
lemma trigger_art_restricted_gear_access: "article_triggered Art_Restricted_Gear_Access actor"
  using derive_restricted_gear_access_basis
  by simp
lemma trigger_art_public_clock_disruption: "article_triggered Art_Public_Clock_Disruption actor"
  using derive_public_clock_disruption_basis
  by simp
lemma trigger_art_maintenance_order_authorization: "article_triggered Art_Maintenance_Order_Authorization actor"
  using derive_maintenance_order_authorization_basis
  by simp
lemma trigger_art_emergency_reset_authorization: "article_triggered Art_Emergency_Reset_Authorization actor"
  using derive_emergency_reset_authorization_basis
  by simp
lemma trigger_art_calibration_fault_exemption: "article_triggered Art_Calibration_Fault_Exemption actor"
  using derive_calibration_fault_exemption_basis
  by simp

lemma overrides_art_public_clock_disruption_art_restricted_gear_access: "overrides Art_Public_Clock_Disruption Art_Restricted_Gear_Access"
  unfolding overrides_def
  by simp
lemma overrides_art_maintenance_order_authorization_art_restricted_gear_access: "overrides Art_Maintenance_Order_Authorization Art_Restricted_Gear_Access"
  unfolding overrides_def
  by simp
lemma overrides_art_emergency_reset_authorization_art_restricted_gear_access: "overrides Art_Emergency_Reset_Authorization Art_Restricted_Gear_Access"
  unfolding overrides_def
  by simp
lemma overrides_art_emergency_reset_authorization_art_public_clock_disruption: "overrides Art_Emergency_Reset_Authorization Art_Public_Clock_Disruption"
  unfolding overrides_def
  by simp
lemma overrides_art_calibration_fault_exemption_art_public_clock_disruption: "overrides Art_Calibration_Fault_Exemption Art_Public_Clock_Disruption"
  unfolding overrides_def
  by simp


lemma not_defeated_art_maintenance_order_authorization: "\<not> defeated actor Art_Maintenance_Order_Authorization"
  using trigger_art_maintenance_order_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_maintenance_order_authorization: "applicable actor Art_Maintenance_Order_Authorization"
  using trigger_art_maintenance_order_authorization not_defeated_art_maintenance_order_authorization
  unfolding applicable_def
  by blast
lemma not_defeated_art_emergency_reset_authorization: "\<not> defeated actor Art_Emergency_Reset_Authorization"
  using trigger_art_emergency_reset_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_emergency_reset_authorization: "applicable actor Art_Emergency_Reset_Authorization"
  using trigger_art_emergency_reset_authorization not_defeated_art_emergency_reset_authorization
  unfolding applicable_def
  by blast
lemma not_defeated_art_calibration_fault_exemption: "\<not> defeated actor Art_Calibration_Fault_Exemption"
  using trigger_art_calibration_fault_exemption
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_calibration_fault_exemption: "applicable actor Art_Calibration_Fault_Exemption"
  using trigger_art_calibration_fault_exemption not_defeated_art_calibration_fault_exemption
  unfolding applicable_def
  by blast
lemma defeated_art_public_clock_disruption: "defeated actor Art_Public_Clock_Disruption"
  using trigger_art_public_clock_disruption trigger_art_emergency_reset_authorization overrides_art_emergency_reset_authorization_art_public_clock_disruption
  unfolding defeated_def
  by blast
lemma not_applicable_art_public_clock_disruption: "\<not> applicable actor Art_Public_Clock_Disruption"
  using trigger_art_public_clock_disruption defeated_art_public_clock_disruption
  unfolding applicable_def
  by blast
lemma defeated_art_restricted_gear_access: "defeated actor Art_Restricted_Gear_Access"
  using trigger_art_restricted_gear_access trigger_art_public_clock_disruption overrides_art_public_clock_disruption_art_restricted_gear_access
  unfolding defeated_def
  by blast
lemma not_applicable_art_restricted_gear_access: "\<not> applicable actor Art_Restricted_Gear_Access"
  using trigger_art_restricted_gear_access defeated_art_restricted_gear_access
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_maintenance_order_authorization
  unfolding final_no_liability_def
  by auto

end
