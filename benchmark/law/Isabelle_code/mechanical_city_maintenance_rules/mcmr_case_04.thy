theory mcmr_case_04
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "opens_service_hatch actor"
and f2: "pulls_copper_speed_pin actor"
and f3: "wears_maintenance_badge actor"
and f4: "receives_municipal_order actor"
and f5: "supervisor_seals_work_ticket actor"
and f6: "\<not> opens_gear_well_cover actor"
and f7: "\<not> loosens_brass_regulator actor"
and f8: "\<not> releases_uncalibrated_automaton actor"
and f9: "\<not> releases_clockwork_runner actor"
and f10: "\<not> automaton_crosses_public_line actor"
and f11: "\<not> runner_enters_public_square actor"
and f12: "\<not> public_clock_stops actor"
and f13: "\<not> reset_alarm_sounds actor"
and f14: "\<not> turns_clocktower_reset_wheel actor"
and f15: "\<not> reports_reset_to_clock_desk actor"
and f16: "\<not> fault_flag_raised_before_contact actor"
and f17: "\<not> calibration_panel_records_fault actor"

lemma derive_restricted_mechanical_access: "restricted_mechanical_access actor"
  using f1 f2
  unfolding restricted_mechanical_access_def
  by simp
lemma derive_maintenance_authority: "maintenance_authority actor"
  using f3 f4 f5
  unfolding maintenance_authority_def
  by simp
lemma derive_restricted_gear_access_basis: "restricted_gear_access_basis actor"
  using derive_restricted_mechanical_access
  unfolding restricted_gear_access_basis_def
  by simp
lemma derive_maintenance_order_authorization_basis: "maintenance_order_authorization_basis actor"
  using derive_maintenance_authority derive_restricted_mechanical_access
  unfolding maintenance_order_authorization_basis_def
  by simp
lemma trigger_art_restricted_gear_access: "article_triggered Art_Restricted_Gear_Access actor"
  using derive_restricted_gear_access_basis
  by simp
lemma trigger_art_maintenance_order_authorization: "article_triggered Art_Maintenance_Order_Authorization actor"
  using derive_maintenance_order_authorization_basis
  by simp

lemma overrides_art_maintenance_order_authorization_art_restricted_gear_access: "overrides Art_Maintenance_Order_Authorization Art_Restricted_Gear_Access"
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
lemma defeated_art_restricted_gear_access: "defeated actor Art_Restricted_Gear_Access"
  using trigger_art_restricted_gear_access trigger_art_maintenance_order_authorization overrides_art_maintenance_order_authorization_art_restricted_gear_access
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
