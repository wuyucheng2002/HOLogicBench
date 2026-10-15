theory Case_kernel
  imports General
begin

consts
  passes_unlit_mirror_gate :: "person => bool"
  crosses_without_reflection_stamp :: "person => bool"
  carries_shadowless_box :: "person => bool"
  cargo_vanishes_in_mirror :: "person => bool"
  switches_left_right_labels :: "person => bool"
  attaches_reversed_crescent_tag :: "person => bool"
  cargo_moves_after_label_change :: "person => bool"
  holds_silver_customs_token :: "person => bool"
  customs_clock_records_arrival :: "person => bool"
  mirror_officer_confirms_token :: "person => bool"
  broken_mirror_alarm_sounds :: "person => bool"
  transfers_cargo_for_rescue :: "person => bool"
  rescue_logged_at_gate :: "person => bool"
  cargo_returned_to_origin :: "person => bool"
  return_receipt_issued :: "person => bool"
  crate_seal_matches_origin :: "person => bool"
  border_lantern_turns_blue :: "person => bool"

definition mirror_crossing :: "person => bool" where
  "mirror_crossing x =
    ((passes_unlit_mirror_gate x \<or> crosses_without_reflection_stamp x) \<and>
      border_lantern_turns_blue x)"

definition shadow_cargo_irregularity :: "person => bool" where
  "shadow_cargo_irregularity x =
    (carries_shadowless_box x \<or> cargo_vanishes_in_mirror x)"

definition label_inversion :: "person => bool" where
  "label_inversion x =
    ((switches_left_right_labels x \<or> attaches_reversed_crescent_tag x) \<and>
      cargo_moves_after_label_change x)"

definition customs_clearance :: "person => bool" where
  "customs_clearance x =
    (holds_silver_customs_token x \<and> customs_clock_records_arrival x \<and> mirror_officer_confirms_token x)"

definition mirror_rescue_transfer :: "person => bool" where
  "mirror_rescue_transfer x =
    (broken_mirror_alarm_sounds x \<and> transfers_cargo_for_rescue x \<and> rescue_logged_at_gate x)"

definition returned_cargo_record :: "person => bool" where
  "returned_cargo_record x =
    (cargo_returned_to_origin x \<and> return_receipt_issued x \<and> crate_seal_matches_origin x)"

end
