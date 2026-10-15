theory dawe_case_05
  imports Conflict
begin

consts
  actor :: person

axiomatization where
  f1: "unlocks_silent_door actor"
and f2: "follows_echo_stair actor"
and f3: "rewrites_margin_note actor"
and f4: "dream_page_fades actor"
and f5: "carries_repair_bell actor"
and f6: "rings_bell_before_closure actor"
and f7: "moves_page_to_safe_shelf actor"
and f8: "\<not> presents_gray_reader_card actor"
and f9: "\<not> enters_lower_stack actor"
and f10: "\<not> moves_unsealed_dream_page actor"
and f11: "\<not> places_page_under_glass actor"
and f12: "\<not> stamps_repair_slip actor"
and f13: "\<not> night_restorer_badge actor"
and f14: "\<not> logs_repair_at_blue_desk actor"
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
lemma derive_fading_condition: "fading_condition actor"
  using f4
  unfolding fading_condition_def
  by simp
lemma derive_repair_tool_record: "repair_tool_record actor"
  using f5 f6
  unfolding repair_tool_record_def
  by simp
lemma derive_rescue_transfer: "rescue_transfer actor"
  using f4 f7
  unfolding rescue_transfer_def
  by simp
lemma derive_dream_page_intervention_basis: "dream_page_intervention_basis actor"
  using derive_archive_entry derive_record_interference
  unfolding dream_page_intervention_basis_def
  by simp
lemma derive_fading_archive_damage_basis: "fading_archive_damage_basis actor"
  using derive_record_interference derive_fading_condition
  unfolding fading_archive_damage_basis_def
  by simp
lemma derive_emergency_preservation_authorization_basis: "emergency_preservation_authorization_basis actor"
  using derive_rescue_transfer derive_repair_tool_record
  unfolding emergency_preservation_authorization_basis_def
  by simp
lemma trigger_art_dream_page_intervention: "article_triggered Art_Dream_Page_Intervention actor"
  using derive_dream_page_intervention_basis
  by simp
lemma trigger_art_fading_archive_damage: "article_triggered Art_Fading_Archive_Damage actor"
  using derive_fading_archive_damage_basis
  by simp
lemma trigger_art_emergency_preservation_authorization: "article_triggered Art_Emergency_Preservation_Authorization actor"
  using derive_emergency_preservation_authorization_basis
  by simp

lemma overrides_art_fading_archive_damage_art_dream_page_intervention: "overrides Art_Fading_Archive_Damage Art_Dream_Page_Intervention"
  unfolding overrides_def
  by simp
lemma overrides_art_emergency_preservation_authorization_art_dream_page_intervention: "overrides Art_Emergency_Preservation_Authorization Art_Dream_Page_Intervention"
  unfolding overrides_def
  by simp
lemma overrides_art_emergency_preservation_authorization_art_fading_archive_damage: "overrides Art_Emergency_Preservation_Authorization Art_Fading_Archive_Damage"
  unfolding overrides_def
  by simp


lemma not_defeated_art_emergency_preservation_authorization: "\<not> defeated actor Art_Emergency_Preservation_Authorization"
  using trigger_art_emergency_preservation_authorization
  unfolding defeated_def overrides_def
  by (auto split: article.splits)
lemma applicable_art_emergency_preservation_authorization: "applicable actor Art_Emergency_Preservation_Authorization"
  using trigger_art_emergency_preservation_authorization not_defeated_art_emergency_preservation_authorization
  unfolding applicable_def
  by blast
lemma defeated_art_fading_archive_damage: "defeated actor Art_Fading_Archive_Damage"
  using trigger_art_fading_archive_damage trigger_art_emergency_preservation_authorization overrides_art_emergency_preservation_authorization_art_fading_archive_damage
  unfolding defeated_def
  by blast
lemma not_applicable_art_fading_archive_damage: "\<not> applicable actor Art_Fading_Archive_Damage"
  using trigger_art_fading_archive_damage defeated_art_fading_archive_damage
  unfolding applicable_def
  by blast
lemma defeated_art_dream_page_intervention: "defeated actor Art_Dream_Page_Intervention"
  using trigger_art_dream_page_intervention trigger_art_fading_archive_damage overrides_art_fading_archive_damage_art_dream_page_intervention
  unfolding defeated_def
  by blast
lemma not_applicable_art_dream_page_intervention: "\<not> applicable actor Art_Dream_Page_Intervention"
  using trigger_art_dream_page_intervention defeated_art_dream_page_intervention
  unfolding applicable_def
  by blast


theorem final_result_no_liability: "final_no_liability actor"
  using applicable_art_emergency_preservation_authorization
  unfolding final_no_liability_def
  by auto

end
