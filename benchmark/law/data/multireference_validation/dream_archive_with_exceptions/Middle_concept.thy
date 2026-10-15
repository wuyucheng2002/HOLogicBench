theory Middle_concept
  imports Case_kernel
begin

definition unregistered_archive_entry_basis :: "person => bool" where
  "unregistered_archive_entry_basis x \<longleftrightarrow> archive_entry x"

definition dream_page_intervention_basis :: "person => bool" where
  "dream_page_intervention_basis x \<longleftrightarrow> (archive_entry x \<and> record_interference x)"

definition fading_archive_damage_basis :: "person => bool" where
  "fading_archive_damage_basis x \<longleftrightarrow> (record_interference x \<and> fading_condition x)"

definition restorer_route_authorization_basis :: "person => bool" where
  "restorer_route_authorization_basis x \<longleftrightarrow> (restorer_status x \<and> repair_tool_record x)"

definition emergency_preservation_authorization_basis :: "person => bool" where
  "emergency_preservation_authorization_basis x \<longleftrightarrow> (rescue_transfer x \<and> repair_tool_record x)"

definition visitor_escort_allowance_basis :: "person => bool" where
  "visitor_escort_allowance_basis x \<longleftrightarrow> (visitor_assistance x \<and> archive_entry x)"

fun article_triggered :: "article => person => bool" where
  "article_triggered Art_Unregistered_Archive_Entry x =
    unregistered_archive_entry_basis x"
| "article_triggered Art_Dream_Page_Intervention x =
    dream_page_intervention_basis x"
| "article_triggered Art_Fading_Archive_Damage x =
    fading_archive_damage_basis x"
| "article_triggered Art_Restorer_Route_Authorization x =
    restorer_route_authorization_basis x"
| "article_triggered Art_Emergency_Preservation_Authorization x =
    emergency_preservation_authorization_basis x"
| "article_triggered Art_Visitor_Escort_Allowance x =
    visitor_escort_allowance_basis x"

end
