theory Case_kernel
  imports General
begin

consts
  unlocks_silent_door :: "person => bool"
  enters_lower_stack :: "person => bool"
  presents_gray_reader_card :: "person => bool"
  follows_echo_stair :: "person => bool"
  moves_unsealed_dream_page :: "person => bool"
  rewrites_margin_note :: "person => bool"
  places_page_under_glass :: "person => bool"
  dream_page_fades :: "person => bool"
  carries_repair_bell :: "person => bool"
  rings_bell_before_closure :: "person => bool"
  stamps_repair_slip :: "person => bool"
  night_restorer_badge :: "person => bool"
  logs_repair_at_blue_desk :: "person => bool"
  moves_page_to_safe_shelf :: "person => bool"
  covers_page_with_sleep_cloth :: "person => bool"
  guides_lost_visitor_out :: "person => bool"
  carries_visitor_rope :: "person => bool"

definition archive_entry :: "person => bool" where
  "archive_entry x =
    ((unlocks_silent_door x \<or> presents_gray_reader_card x) \<and>
      (enters_lower_stack x \<or> follows_echo_stair x))"

definition record_interference :: "person => bool" where
  "record_interference x =
    (moves_unsealed_dream_page x \<or> rewrites_margin_note x \<or> places_page_under_glass x)"

definition fading_condition :: "person => bool" where
  "fading_condition x =
    dream_page_fades x"

definition repair_tool_record :: "person => bool" where
  "repair_tool_record x =
    (carries_repair_bell x \<and> (rings_bell_before_closure x \<or> stamps_repair_slip x))"

definition restorer_status :: "person => bool" where
  "restorer_status x =
    (night_restorer_badge x \<and> logs_repair_at_blue_desk x)"

definition rescue_transfer :: "person => bool" where
  "rescue_transfer x =
    (dream_page_fades x \<and> (moves_page_to_safe_shelf x \<or> covers_page_with_sleep_cloth x))"

definition visitor_assistance :: "person => bool" where
  "visitor_assistance x =
    (guides_lost_visitor_out x \<and> carries_visitor_rope x)"

end
