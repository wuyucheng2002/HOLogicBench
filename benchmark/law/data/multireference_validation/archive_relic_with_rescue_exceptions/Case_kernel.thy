theory Case_kernel
  imports General
begin

consts
  enters_closed_stack :: "person => bool"
  uses_unregistered_reader_card :: "person => bool"
  bypasses_reading_room_desk :: "person => bool"
  shelf_marked_restricted :: "person => bool"
  curator_present :: "person => bool"
  touches_relic_without_gloves :: "person => bool"
  lifts_relic_from_cradle :: "person => bool"
  places_relic_under_lamp :: "person => bool"
  relic_tagged_fragile :: "person => bool"
  changes_catalog_entry :: "person => bool"
  deletes_condition_note :: "person => bool"
  swaps_archive_label :: "person => bool"
  catalog_lock_active :: "person => bool"
  carries_relic_past_blue_line :: "person => bool"
  seals_relic_in_private_case :: "person => bool"
  leaves_building_with_archive_box :: "person => bool"
  exit_alarm_active :: "person => bool"
  has_curator_written_order :: "person => bool"
  order_names_relic :: "person => bool"
  logs_handling_time :: "person => bool"
  flood_alarm_sounds :: "person => bool"
  moves_item_to_dry_room :: "person => bool"
  files_rescue_note :: "person => bool"

definition unauthorized_stack_entry :: "person => bool" where
  "unauthorized_stack_entry x =
    (enters_closed_stack x \<or> uses_unregistered_reader_card x \<or> bypasses_reading_room_desk x)"

definition restricted_shelf_status :: "person => bool" where
  "restricted_shelf_status x =
    (shelf_marked_restricted x \<and> \<not> curator_present x)"

definition fragile_relic_handling :: "person => bool" where
  "fragile_relic_handling x =
    ((touches_relic_without_gloves x \<or> lifts_relic_from_cradle x \<or> places_relic_under_lamp x)
      \<and> relic_tagged_fragile x)"

definition catalog_record_interference :: "person => bool" where
  "catalog_record_interference x =
    ((changes_catalog_entry x \<or> deletes_condition_note x \<or> swaps_archive_label x)
      \<and> catalog_lock_active x)"

definition vault_exit_step :: "person => bool" where
  "vault_exit_step x =
    ((carries_relic_past_blue_line x \<or> seals_relic_in_private_case x \<or> leaves_building_with_archive_box x)
      \<and> exit_alarm_active x)"

definition curator_authorization_records :: "person => bool" where
  "curator_authorization_records x =
    (has_curator_written_order x \<and> order_names_relic x \<and> logs_handling_time x)"

definition flood_rescue_records :: "person => bool" where
  "flood_rescue_records x =
    (flood_alarm_sounds x \<and> moves_item_to_dry_room x \<and> files_rescue_note x)"

end
