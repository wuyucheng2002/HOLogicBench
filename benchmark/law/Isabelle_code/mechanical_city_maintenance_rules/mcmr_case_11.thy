theory mcmr_case_11
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "opens_gear_well_cover actor"
and f2: "loosens_brass_regulator actor"
and f3: "releases_uncalibrated_automaton actor"
and f4: "runner_enters_public_square actor"
and f5: "\<not> opens_service_hatch actor"
and f6: "\<not> pulls_copper_speed_pin actor"
and f7: "\<not> releases_clockwork_runner actor"
and f8: "\<not> automaton_crosses_public_line actor"
and f9: "\<not> public_clock_stops actor"
and f10: "\<not> reset_alarm_sounds actor"
and f11: "\<not> wears_maintenance_badge actor"
and f12: "\<not> receives_municipal_order actor"
and f13: "\<not> supervisor_seals_work_ticket actor"
and f14: "\<not> turns_clocktower_reset_wheel actor"
and f15: "\<not> reports_reset_to_clock_desk actor"
and f16: "\<not> fault_flag_raised_before_contact actor"
and f17: "\<not> calibration_panel_records_fault actor"

lemma derive_restricted_mechanical_access: "restricted_mechanical_access actor"
  using f1 f2
  unfolding restricted_mechanical_access_def
  by simp
lemma derive_unsafe_automaton_release: "unsafe_automaton_release actor"
  using f3 f4
  unfolding unsafe_automaton_release_def
  by simp
lemma derive_unsafe_automaton_release_basis: "unsafe_automaton_release_basis actor"
  using derive_restricted_mechanical_access derive_unsafe_automaton_release
  unfolding unsafe_automaton_release_basis_def
  by simp
lemma trigger_art_unsafe_automaton_release: "article_triggered Art_Unsafe_Automaton_Release actor"
  using derive_unsafe_automaton_release_basis
  by simp


lemma not_trigger_art_public_clock_disruption: "\<not> article_triggered Art_Public_Clock_Disruption actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps public_clock_disruption_basis_def clock_disruption_def restricted_mechanical_access_def
  by simp
lemma not_trigger_art_maintenance_order_authorization: "\<not> article_triggered Art_Maintenance_Order_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps maintenance_order_authorization_basis_def maintenance_authority_def restricted_mechanical_access_def
  by simp
lemma not_trigger_art_emergency_reset_authorization: "\<not> article_triggered Art_Emergency_Reset_Authorization actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps emergency_reset_authorization_basis_def emergency_reset_action_def clock_disruption_def restricted_mechanical_access_def
  by simp
lemma not_trigger_art_calibration_fault_exemption: "\<not> article_triggered Art_Calibration_Fault_Exemption actor"
  using f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17
  unfolding article_triggered.simps calibration_fault_exemption_basis_def calibration_fault_condition_def clock_disruption_def restricted_mechanical_access_def
  by simp

lemma not_defeated_art_unsafe_automaton_release: "\<not> defeated actor Art_Unsafe_Automaton_Release"
proof
  assume defeated_assm: "defeated actor Art_Unsafe_Automaton_Release"
  then obtain higher where
    higher_triggered: "article_triggered higher actor"
    and higher_overrides: "overrides higher Art_Unsafe_Automaton_Release"
    unfolding defeated_def by blast
  then show False
    using not_trigger_art_public_clock_disruption not_trigger_art_maintenance_order_authorization
    unfolding overrides_def
    by (cases higher) auto
qed
lemma applicable_art_unsafe_automaton_release: "applicable actor Art_Unsafe_Automaton_Release"
  using trigger_art_unsafe_automaton_release not_defeated_art_unsafe_automaton_release
  unfolding applicable_def
  by blast

lemma not_applicable_art_maintenance_order_authorization: "\<not> applicable actor Art_Maintenance_Order_Authorization"
  using not_trigger_art_maintenance_order_authorization
  unfolding applicable_def
  by blast
lemma not_applicable_art_emergency_reset_authorization: "\<not> applicable actor Art_Emergency_Reset_Authorization"
  using not_trigger_art_emergency_reset_authorization
  unfolding applicable_def
  by blast
lemma not_applicable_art_calibration_fault_exemption: "\<not> applicable actor Art_Calibration_Fault_Exemption"
  using not_trigger_art_calibration_fault_exemption
  unfolding applicable_def
  by blast

lemma not_final_no_liability: "\<not> final_no_liability actor"
proof
  assume final_no_liability_assm: "final_no_liability actor"
  then obtain art where
    art_applicable: "applicable actor art"
    and art_result: "article_result art = No_Criminal_Liability"
    unfolding final_no_liability_def by blast
  show False
    using art_applicable art_result not_applicable_art_maintenance_order_authorization not_applicable_art_emergency_reset_authorization not_applicable_art_calibration_fault_exemption
    by (cases art) auto
qed
theorem final_result_liability: "final_legal_result_holds actor automaton_release_suspension"
  using applicable_art_unsafe_automaton_release not_final_no_liability
  unfolding final_legal_result_holds_def
  by auto

end
