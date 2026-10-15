theory Reasoning_Tree_Completeness
  imports Main
begin

text \<open>Finite, unfolded business-tree grammars. Choice is meta-level
  alternative explanation, not a business rule. Labels must identify the
  expression, value and rule application. Premises are ordered at this layer.
  Neither source extraction nor the production Python implementation is assumed
  to be verified by the following theorems.\<close>

datatype 'a tree = Tip 'a | Unary 'a "'a tree" | Binary 'a "'a tree" "'a tree"
datatype 'a grammar = Fact 'a | Step 'a "'a grammar"
  | Together 'a "'a grammar" "'a grammar" | Alternative "'a grammar" "'a grammar"

inductive derives :: "'a grammar \<Rightarrow> 'a tree \<Rightarrow> bool" where
  fact: "derives (Fact a) (Tip a)"
| step: "derives g t \<Longrightarrow> derives (Step a g) (Unary a t)"
| together: "derives g t \<Longrightarrow> derives h u \<Longrightarrow>
    derives (Together a g h) (Binary a t u)"
| left: "derives g t \<Longrightarrow> derives (Alternative g h) t"
| right: "derives h t \<Longrightarrow> derives (Alternative g h) t"

fun enumerate :: "'a grammar \<Rightarrow> 'a tree list" where
  "enumerate (Fact a) = [Tip a]"
| "enumerate (Step a g) = map (Unary a) (enumerate g)"
| "enumerate (Together a g h) =
    concat (map (\<lambda>t. map (Binary a t) (enumerate h)) (enumerate g))"
| "enumerate (Alternative g h) = enumerate g @ enumerate h"

theorem enumeration_sound:
  "t \<in> set (enumerate g) \<Longrightarrow> derives g t"
  by (induction g arbitrary: t) (auto intro: derives.intros)

theorem enumeration_complete:
  "derives g t \<Longrightarrow> t \<in> set (enumerate g)"
  by (induction rule: derives.induct) auto

theorem enumeration_exact:
  "set (enumerate g) = {t. derives g t}"
  using enumeration_sound enumeration_complete by blast

corollary finitely_many_derivations: "finite {t. derives g t}"
  by (simp only: enumeration_exact[symmetric] finite_set)

text \<open>Semantic soundness is conditional on local rule validity. This is
  the explicit interface that a source-to-grammar translation must discharge.\<close>

fun conclusion :: "'a tree \<Rightarrow> 'a" where
  "conclusion (Tip a) = a"
| "conclusion (Unary a t) = a"
| "conclusion (Binary a t u) = a"

fun safe :: "('a \<Rightarrow> bool) \<Rightarrow> 'a grammar \<Rightarrow> bool" where
  "safe P (Fact a) = P a"
| "safe P (Step a g) = (safe P g \<and>
    (\<forall>t. derives g t \<longrightarrow> P (conclusion t) \<longrightarrow> P a))"
| "safe P (Together a g h) = (safe P g \<and> safe P h \<and>
    (\<forall>t u. derives g t \<longrightarrow> derives h u \<longrightarrow>
      P (conclusion t) \<longrightarrow> P (conclusion u) \<longrightarrow> P a))"
| "safe P (Alternative g h) = (safe P g \<and> safe P h)"

lemma derivation_semantically_sound:
  "derives g t \<Longrightarrow> safe P g \<Longrightarrow> P (conclusion t)"
  by (induction rule: derives.induct) auto

theorem enumeration_semantically_sound:
  "safe P g \<Longrightarrow> t \<in> set (enumerate g) \<Longrightarrow> P (conclusion t)"
  using enumeration_sound derivation_semantically_sound by blast

text \<open>Ordered branches: the guard explanation remains a premise, and
  no tree from the inactive branch is enumerated. Guard truth itself is an
  obligation of the source translation, not a trusted Boolean certificate.\<close>

definition branch where
  "branch b label guard yes no =
    Together label guard (if b then yes else no)"

theorem branch_exact:
  "derives (branch b a c yes no) t \<longleftrightarrow>
    (\<exists>u v. t = Binary a u v \<and> derives c u \<and>
      derives (if b then yes else no) v)"
  unfolding branch_def
  by (auto intro: derives.intros elim: derives.cases)

text \<open>Global minimization, performed only AFTER exhaustive enumeration.
  'better u t' means u strictly dominates t under the chosen business criterion.
  An arbitrary canonicalization function explicitly determines tree identity.\<close>

definition minimal_spec where
  "minimal_spec canon better g =
    {t \<in> canon ` {u. derives g u}. \<not> (\<exists>u \<in> canon ` {u. derives g u}. better u t)}"

definition minimal_enum where
  "minimal_enum canon better g =
    (let ts = remdups (map canon (enumerate g))
     in filter (\<lambda>t. \<not> list_ex (\<lambda>u. better u t) ts) ts)"

theorem minimal_enumeration_exact:
  "set (minimal_enum canon better g) = minimal_spec canon better g"
  unfolding minimal_enum_def minimal_spec_def Let_def
  by (auto simp: enumeration_exact list_ex_iff)

theorem minimal_enumeration_no_duplicates:
  "distinct (minimal_enum canon better g)"
  unfolding minimal_enum_def Let_def by simp

text \<open>This dominance relation mirrors the documented evidence/rule/size
  policy, but is applied globally. The metric functions remain parameters.\<close>

definition dominates where
  "dominates rules evidence cost u t \<longleftrightarrow>
    rules u = rules t \<and>
    (evidence u \<subset> evidence t \<or>
      (evidence u = evidence t \<and> cost u < (cost t :: nat)))"

lemma dominates_irreflexive: "\<not> dominates rules evidence cost t t"
  by (simp add: dominates_def)

lemma dominates_transitive:
  "dominates rules evidence cost a b \<Longrightarrow>
   dominates rules evidence cost b c \<Longrightarrow>
   dominates rules evidence cost a c"
  unfolding dominates_def by auto

corollary business_minimal_enumeration_exact:
  "set (minimal_enum canon (dominates rules evidence cost) g) =
    minimal_spec canon (dominates rules evidence cost) g"
  by (rule minimal_enumeration_exact)

end
