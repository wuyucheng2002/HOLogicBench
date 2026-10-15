theory Case_kernel
  imports General
begin

consts
  takes_property :: "person => bool"
  property_belongs_to_another :: "person => bool"
  intent_to_keep_unlawfully :: "person => bool"
  pushes_victim_during_taking :: "person => bool"
  threatens_immediate_harm :: "person => bool"
  deception_used :: "person => bool"
  victim_transfers_property :: "person => bool"
  property_value_large :: "person => bool"
  owner_gave_permission :: "person => bool"
  immediate_danger :: "person => bool"
  taking_necessary_to_avoid_danger :: "person => bool"

definition property_taking :: "person => bool" where
  "property_taking x =
    (takes_property x
      \<and> property_belongs_to_another x)"

definition unlawful_intent :: "person => bool" where
  "unlawful_intent x = intent_to_keep_unlawfully x"

definition force_or_threat_during_taking :: "person => bool" where
  "force_or_threat_during_taking x =
    (pushes_victim_during_taking x \<or> threatens_immediate_harm x)"

definition transferred_property_of_another :: "person => bool" where
  "transferred_property_of_another x =
    (victim_transfers_property x
      \<and> property_belongs_to_another x)"

definition deception_induced_transfer :: "person => bool" where
  "deception_induced_transfer x =
    (deception_used x
      \<and> transferred_property_of_another x)"

definition high_value_property :: "person => bool" where
  "high_value_property x = property_value_large x"

definition owner_authorized_taking :: "person => bool" where
  "owner_authorized_taking x =
    (takes_property x \<and> owner_gave_permission x)"

definition emergency_property_taking :: "person => bool" where
  "emergency_property_taking x =
    (takes_property x
      \<and> immediate_danger x
      \<and> taking_necessary_to_avoid_danger x)"

end
