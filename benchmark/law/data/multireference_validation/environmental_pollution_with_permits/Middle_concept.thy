theory Middle_concept
  imports Case_kernel
begin

definition unlawful_release_basis :: "person => bool" where
  "unlawful_release_basis x =
    (pollutant_release x \<and> limit_exceedance x)"

definition hazardous_dumping_basis :: "person => bool" where
  "hazardous_dumping_basis x =
    (hazardous_material x \<and> unprotected_disposal x)"

definition serious_contamination_basis :: "person => bool" where
  "serious_contamination_basis x =
    (unlawful_release_basis x \<and> environmental_harm x)"

definition monitoring_falsification_basis :: "person => bool" where
  "monitoring_falsification_basis x =
    (unlawful_release_basis x \<and> report_manipulation x)"

definition permit_authorization :: "person => bool" where
  "permit_authorization x =
    (unlawful_release_basis x \<and> permit_records x)"

definition emergency_release_authorization :: "person => bool" where
  "emergency_release_authorization x =
    (unlawful_release_basis x \<and> emergency_records x)"

fun article_triggered :: "article => person => bool" where
  "article_triggered Art_Unlawful_Discharge x =
    unlawful_release_basis x"
| "article_triggered Art_Hazardous_Waste_Dumping x =
    hazardous_dumping_basis x"
| "article_triggered Art_Serious_Contamination x =
    serious_contamination_basis x"
| "article_triggered Art_Falsified_Monitoring x =
    monitoring_falsification_basis x"
| "article_triggered Art_Valid_Permit_Defense x =
    permit_authorization x"
| "article_triggered Art_Emergency_Release_Defense x =
    emergency_release_authorization x"

end
