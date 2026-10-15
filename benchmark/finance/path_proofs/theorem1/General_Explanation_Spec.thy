theory General_Explanation_Spec
  imports Main
begin

text \<open>Arbitrary finite premise lists and finite alternatives, with a
  decreasing height. C is the SAME canonical constructor in both definitions.
  No claim about the faithfulness of a concrete source translator is made.\<close>

fun choices :: "('v \<Rightarrow> 't list) \<Rightarrow> 'v list \<Rightarrow> 't list list" where
  "choices E [] = [[]]"
| "choices E (v # vs) = concat (map (\<lambda>t. map ((#) t) (choices E vs)) (E v))"

lemma choices_exact:
  "ts \<in> set (choices E vs) \<longleftrightarrow>
   list_all2 (\<lambda>v t. t \<in> set (E v)) vs ts"
  by (induction vs arbitrary: ts) (auto simp: list_all2_Cons1)

locale explanation =
  fixes J :: "'v \<Rightarrow> 'v list list"
    and C :: "'v \<Rightarrow> 't list \<Rightarrow> 't"
    and h :: "'v \<Rightarrow> nat"
  assumes decreases: "vs \<in> set (J v) \<Longrightarrow> w \<in> set vs \<Longrightarrow> h w < h v"
begin

inductive derives :: "'v \<Rightarrow> 't \<Rightarrow> bool" where
  step: "vs \<in> set (J v) \<Longrightarrow> list_all2 derives vs ts \<Longrightarrow>
         derives v (C v ts)"

fun enum :: "nat \<Rightarrow> 'v \<Rightarrow> 't list" where
  "enum 0 v = []"
| "enum (Suc n) v = concat (map (\<lambda>vs. map (C v) (choices (enum n) vs)) (J v))"

lemma enum_exact_bounded:
  "h v < n \<Longrightarrow> (t \<in> set (enum n v) \<longleftrightarrow> derives v t)"
proof (induction n arbitrary: v t)
  case 0
  then show ?case by simp
next
  case (Suc n)
  have children: "vs \<in> set (J v) \<Longrightarrow>
      list_all2 (\<lambda>w u. u \<in> set (enum n w)) vs ts = list_all2 derives vs ts"
    for vs ts
    using Suc.IH Suc.prems decreases[of vs v]
    by (auto simp: list_all2_conv_all_nth) (metis nth_mem less_Suc_eq_le less_le_trans)+
  show ?case
  proof
    assume "t \<in> set (enum (Suc n) v)"
    then obtain vs ts where vs: "vs \<in> set (J v)"
      and ts: "ts \<in> set (choices (enum n) vs)" and t: "t = C v ts" by auto
    have "list_all2 derives vs ts" using ts children[OF vs] choices_exact by blast
    then show "derives v t" using derives.step[OF vs] t by blast
  next
    assume "derives v t"
    then obtain vs ts where vs: "vs \<in> set (J v)"
      and ts: "list_all2 derives vs ts" and t: "t = C v ts"
      by (cases rule: derives.cases) blast
    have "ts \<in> set (choices (enum n) vs)"
      using ts children[OF vs] choices_exact by blast
    then show "t \<in> set (enum (Suc n) v)" using vs t by auto
  qed
qed

definition enumerate where "enumerate v = enum (Suc (h v)) v"

theorem enumeration_exact:
  "set (enumerate v) = {t. derives v t}"
  using enum_exact_bounded[where v=v and n="Suc (h v)"]
  by (auto simp only: enumerate_def mem_Collect_eq lessI)

corollary finite_derivations: "finite {t. derives v t}"
  using enumeration_exact by (metis finite_set)

definition minima where
  "minima better S = {t \<in> S. \<not> (\<exists>u \<in> S. better u t)}"

definition enum_min where
  "enum_min better v = (let ts = remdups (enumerate v)
    in filter (\<lambda>t. \<not> list_ex (\<lambda>u. better u t) ts) ts)"

theorem theorem1:
  "set (enum_min better v) = minima better {t. derives v t}"
  unfolding enum_min_def minima_def Let_def
  by (auto simp: list_ex_iff enumeration_exact)

theorem no_duplicates: "distinct (enum_min better v)"
  unfolding enum_min_def Let_def by simp

text \<open>Semantic soundness requires every local rule, including zero-premise
  rules, to preserve validity. This is an explicit assumption, not a result
  about natural language extraction or canonicalization.\<close>

theorem semantic_soundness:
  assumes local_valid: "\<And>v vs. vs \<in> set (J v) \<Longrightarrow>
      (\<And>w. w \<in> set vs \<Longrightarrow> P w) \<Longrightarrow> P v"
      and derivation: "derives v t"
  shows "P v"
  using derivation
proof (induction v arbitrary: t rule: measure_induct_rule[of h])
  case (less v)
  then obtain vs ts where vs: "vs \<in> set (J v)" and ts: "list_all2 derives vs ts"
    by (auto elim: derives.cases)
  have "P w" if "w \<in> set vs" for w
    using less.IH decreases[OF vs that] ts that
    by (auto simp: list_all2_conv_all_nth in_set_conv_nth)
  then show ?case using local_valid vs by blast
qed

end
end
