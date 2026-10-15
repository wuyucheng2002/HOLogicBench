theory case_demo
  imports Conflict
begin

consts actor :: person

axiomatization where
  f1: "uses_stolen_password actor"
and f2: "target_system_requires_authorization actor"
and f3: "\<not> owner_permission_for_access actor"
and f4: "downloads_customer_records actor"

lemma demo_access_method: "access_method actor"
  using f1
  unfolding access_method_def
  by simp

lemma demo_protected_system: "protected_system actor"
  using f2 f3
  unfolding protected_system_def
  by simp

lemma demo_intrusion_basis: "intrusion_basis actor"
  using demo_access_method demo_protected_system
  unfolding intrusion_basis_def
  by simp

lemma demo_data_copy_action: "data_copy_action actor"
  using f4
  unfolding data_copy_action_def
  by simp

lemma demo_data_theft: "article_triggered Art_Data_Theft actor"
  using demo_intrusion_basis demo_data_copy_action
  unfolding data_acquisition_basis_def
  by simp

end
