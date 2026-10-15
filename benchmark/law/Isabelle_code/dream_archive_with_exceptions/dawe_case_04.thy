theory dawe_case_04
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "presents_gray_reader_card actor"
and f2: "enters_lower_stack actor"
and f3: "moves_unsealed_dream_page actor"
and f4: "carries_repair_bell actor"
and f5: "stamps_repair_slip actor"
and f6: "night_restorer_badge actor"
and f7: "logs_repair_at_blue_desk actor"
and f8: "\<not> unlocks_silent_door actor"
and f9: "\<not> follows_echo_stair actor"
and f10: "\<not> rewrites_margin_note actor"
and f11: "\<not> places_page_under_glass actor"
and f12: "\<not> dream_page_fades actor"
and f13: "\<not> rings_bell_before_closure actor"
and f14: "\<not> moves_page_to_safe_shelf actor"
and f15: "\<not> covers_page_with_sleep_cloth actor"
and f16: "\<not> guides_lost_visitor_out actor"
and f17: "\<not> carries_visitor_rope actor"

lemma derive_archive_entry: "archive_entry actor"
  using f1 f2
  unfolding archive_entry_def
  by simp
lemma derive_record_interference: "record_interference actor"
  using f3
  unfolding record_interference_def
  by simp
lemma derive_repair_tool_record: "repair_tool_record actor"
  using f4 f5
  unfolding repair_tool_record_def
  by simp
lemma derive_restorer_status: "restorer_status actor"
  using f6 f7
  unfolding restorer_status_def
  by simp
lemma derive_unregistered_archive_entry_basis: "unregistered_archive_entry_basis actor"
  using derive_archive_entry
  unfolding unregistered_archive_entry_basis_def
  by simp
lemma derive_dream_page_intervention_basis: "dream_page_intervention_basis actor"
  using derive_archive_entry derive_record_interference
  unfolding dream_page_intervention_basis_def
  by simp
lemma derive_restorer_route_authorization_basis: "restorer_route_authorization_basis actor"
  using derive_restorer_status derive_repair_tool_record
  unfolding restorer_route_authorization_basis_def
  by simp
lemma trigger_art_unregistered_archive_entry: "article_triggered Art_Unregistered_Archive_Entry actor"
  using derive_unregistered_archive_entry_basis
  by simp
lemma trigger_art_dream_page_intervention: "article_triggered Art_Dream_Page_Intervention actor"
  using derive_dream_page_intervention_basis
  by simp
lemma trigger_art_restorer_route_authorization: "article_triggered Art_Restorer_Route_Authorization actor"
  using derive_restorer_route_authorization_basis
  by simp

lemma overrides_art_dream_page_intervention_art_unregistered_archive_entry: "overrides Art_Dream_Page_Intervention Art_Unregistered_Archive_Entry"
  unfolding overrides_def
  by simp
lemma overrides_art_restorer_route_authorization_art_unregistered_archive_entry: "overrides Art_Restorer_Route_Authorization Art_Unregistered_Archive_Entry"
  unfolding overrides_def
  by simp
lemma overrides_art_restorer_route_authorization_art_dream_page_intervention: "overrides Art_Restorer_Route_Authorization Art_Dream_Page_Intervention"
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
lemma defeated_art_dream_page_intervention: "defeated actor Art_Dream_Page_Intervention"
  using trigger_art_dream_page_intervention trigger_art_restorer_route_authorization overrides_art_restorer_route_authorization_art_dream_page_intervention
  unfolding defeated_def
  by blast
lemma not_applicable_art_dream_page_intervention: "\<not> applicable actor Art_Dream_Page_Intervention"
  using trigger_art_dream_page_intervention defeated_art_dream_page_intervention
  unfolding applicable_def
  by blast
lemma defeated_art_unregistered_archive_entry: "defeated actor Art_Unregistered_Archive_Entry"
  using trigger_art_unregistered_archive_entry trigger_art_dream_page_intervention overrides_art_dream_page_intervention_art_unregistered_archive_entry
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
