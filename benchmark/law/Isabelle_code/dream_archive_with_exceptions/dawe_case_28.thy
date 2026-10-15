theory dawe_case_28
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "presents_gray_reader_card actor"
and f2: "enters_lower_stack actor"
and f3: "dream_page_fades actor"
and f4: "carries_repair_bell actor"
and f5: "stamps_repair_slip actor"
and f6: "night_restorer_badge actor"
and f7: "logs_repair_at_blue_desk actor"
and f8: "covers_page_with_sleep_cloth actor"
and f9: "guides_lost_visitor_out actor"
and f10: "carries_visitor_rope actor"
and f11: "\<not> unlocks_silent_door actor"
and f12: "\<not> follows_echo_stair actor"
and f13: "\<not> moves_unsealed_dream_page actor"
and f14: "\<not> rewrites_margin_note actor"
and f15: "\<not> places_page_under_glass actor"
and f16: "\<not> rings_bell_before_closure actor"
and f17: "\<not> moves_page_to_safe_shelf actor"

lemma derive_archive_entry: "archive_entry actor"
  using f1 f2
  unfolding archive_entry_def
  by simp
lemma derive_repair_tool_record: "repair_tool_record actor"
  using f4 f5
  unfolding repair_tool_record_def
  by simp
lemma derive_restorer_status: "restorer_status actor"
  using f6 f7
  unfolding restorer_status_def
  by simp
lemma derive_rescue_transfer: "rescue_transfer actor"
  using f3 f8
  unfolding rescue_transfer_def
  by simp
lemma derive_visitor_assistance: "visitor_assistance actor"
  using f9 f10
  unfolding visitor_assistance_def
  by simp
lemma derive_unregistered_archive_entry_basis: "unregistered_archive_entry_basis actor"
  using derive_archive_entry
  unfolding unregistered_archive_entry_basis_def
  by simp
lemma derive_restorer_route_authorization_basis: "restorer_route_authorization_basis actor"
  using derive_restorer_status derive_repair_tool_record
  unfolding restorer_route_authorization_basis_def
  by simp
lemma derive_emergency_preservation_authorization_basis: "emergency_preservation_authorization_basis actor"
  using derive_rescue_transfer derive_repair_tool_record
  unfolding emergency_preservation_authorization_basis_def
  by simp
lemma derive_visitor_escort_allowance_basis: "visitor_escort_allowance_basis actor"
  using derive_visitor_assistance derive_archive_entry
  unfolding visitor_escort_allowance_basis_def
  by simp
lemma trigger_art_unregistered_archive_entry: "article_triggered Art_Unregistered_Archive_Entry actor"
  using derive_unregistered_archive_entry_basis
  by simp
lemma trigger_art_restorer_route_authorization: "article_triggered Art_Restorer_Route_Authorization actor"
  using derive_restorer_route_authorization_basis
  by simp
lemma trigger_art_emergency_preservation_authorization: "article_triggered Art_Emergency_Preservation_Authorization actor"
  using derive_emergency_preservation_authorization_basis
  by simp
lemma trigger_art_visitor_escort_allowance: "article_triggered Art_Visitor_Escort_Allowance actor"
  using derive_visitor_escort_allowance_basis
  by simp

lemma overrides_art_restorer_route_authorization_art_unregistered_archive_entry: "overrides Art_Restorer_Route_Authorization Art_Unregistered_Archive_Entry"
  unfolding overrides_def
  by simp
lemma overrides_art_visitor_escort_allowance_art_unregistered_archive_entry: "overrides Art_Visitor_Escort_Allowance Art_Unregistered_Archive_Entry"
  unfolding overrides_def
  by simp


lemma not_defeated_art_restorer_route_authorization: "\<not> defeated actor Art_Restorer_Route_Authorization"
  using trigger_art_restorer_route_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_restorer_route_authorization: "applicable actor Art_Restorer_Route_Authorization"
  using trigger_art_restorer_route_authorization not_defeated_art_restorer_route_authorization
  unfolding applicable_def
  by blast
lemma not_defeated_art_emergency_preservation_authorization: "\<not> defeated actor Art_Emergency_Preservation_Authorization"
  using trigger_art_emergency_preservation_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_emergency_preservation_authorization: "applicable actor Art_Emergency_Preservation_Authorization"
  using trigger_art_emergency_preservation_authorization not_defeated_art_emergency_preservation_authorization
  unfolding applicable_def
  by blast
lemma not_defeated_art_visitor_escort_allowance: "\<not> defeated actor Art_Visitor_Escort_Allowance"
  using trigger_art_visitor_escort_allowance
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_visitor_escort_allowance: "applicable actor Art_Visitor_Escort_Allowance"
  using trigger_art_visitor_escort_allowance not_defeated_art_visitor_escort_allowance
  unfolding applicable_def
  by blast
lemma defeated_art_unregistered_archive_entry: "defeated actor Art_Unregistered_Archive_Entry"
  using trigger_art_unregistered_archive_entry trigger_art_restorer_route_authorization overrides_art_restorer_route_authorization_art_unregistered_archive_entry
  unfolding defeated_def
  by blast
lemma not_applicable_art_unregistered_archive_entry: "\<not> applicable actor Art_Unregistered_Archive_Entry"
  using trigger_art_unregistered_archive_entry defeated_art_unregistered_archive_entry
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_restorer_route_authorization
  unfolding final_no_liability_def
  by auto

end
