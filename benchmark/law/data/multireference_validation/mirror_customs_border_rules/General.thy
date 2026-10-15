theory General
  imports Main
begin

typedecl person

datatype article =
    Art_Unregistered_Mirror_Crossing
  | Art_Shadow_Cargo_Irregularity
  | Art_Label_Inversion
  | Art_Customs_Clearance_Authorization
  | Art_Mirror_Rescue_Transfer
  | Art_Returned_Cargo_Allowance

datatype legal_result =
    No_Criminal_Liability
  | mirror_gate_warning
  | shadow_cargo_hold
  | inversion_ledger_sealing

fun article_result :: "article => legal_result" where
  "article_result Art_Unregistered_Mirror_Crossing = mirror_gate_warning"
| "article_result Art_Shadow_Cargo_Irregularity = shadow_cargo_hold"
| "article_result Art_Label_Inversion = inversion_ledger_sealing"
| "article_result Art_Customs_Clearance_Authorization = No_Criminal_Liability"
| "article_result Art_Mirror_Rescue_Transfer = No_Criminal_Liability"
| "article_result Art_Returned_Cargo_Allowance = No_Criminal_Liability"

end
