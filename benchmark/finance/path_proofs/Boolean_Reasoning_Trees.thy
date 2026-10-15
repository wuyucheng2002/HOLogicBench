theory Boolean_Reasoning_Trees
  imports Reasoning_Tree_Completeness
begin

datatype expr = Atom nat | Conj expr expr | Disj expr expr
  | Neg expr | Impl expr expr | IfThen expr expr expr

fun "value" :: "(nat \<Rightarrow> bool) \<Rightarrow> expr \<Rightarrow> bool" where
  "value env (Atom n) = env n"
| "value env (Conj a b) = (value env a \<and> value env b)"
| "value env (Disj a b) = (value env a \<or> value env b)"
| "value env (Neg a) = (\<not> value env a)"
| "value env (Impl a b) = (value env a \<longrightarrow> value env b)"
| "value env (IfThen c a b) = (if value env c then value env a else value env b)"

type_synonym proof_tree = "(expr \<times> bool) tree"

text \<open>Independent declarative rules for sufficient-reason trees. False
  conjunctions and true disjunctions/implications admit all sufficient reasons.
  IfThen always includes the guard and only the selected branch.\<close>

inductive proves :: "(nat \<Rightarrow> bool) \<Rightarrow> expr \<Rightarrow> bool \<Rightarrow> proof_tree \<Rightarrow> bool" where
  atom: "proves env (Atom n) (env n) (Tip (Atom n, env n))"
| conjT: "proves env a True t \<Longrightarrow> proves env b True u \<Longrightarrow>
    proves env (Conj a b) True (Binary (Conj a b, True) t u)"
| conjL: "proves env a False t \<Longrightarrow>
    proves env (Conj a b) False (Unary (Conj a b, False) t)"
| conjR: "proves env b False t \<Longrightarrow>
    proves env (Conj a b) False (Unary (Conj a b, False) t)"
| disjL: "proves env a True t \<Longrightarrow>
    proves env (Disj a b) True (Unary (Disj a b, True) t)"
| disjR: "proves env b True t \<Longrightarrow>
    proves env (Disj a b) True (Unary (Disj a b, True) t)"
| disjF: "proves env a False t \<Longrightarrow> proves env b False u \<Longrightarrow>
    proves env (Disj a b) False (Binary (Disj a b, False) t u)"
| neg: "proves env a v t \<Longrightarrow>
    proves env (Neg a) (\<not> v) (Unary (Neg a, \<not> v) t)"
| implL: "proves env a False t \<Longrightarrow>
    proves env (Impl a b) True (Unary (Impl a b, True) t)"
| implR: "proves env b True t \<Longrightarrow>
    proves env (Impl a b) True (Unary (Impl a b, True) t)"
| implF: "proves env a True t \<Longrightarrow> proves env b False u \<Longrightarrow>
    proves env (Impl a b) False (Binary (Impl a b, False) t u)"
| ifT: "proves env c True t \<Longrightarrow> proves env a v u \<Longrightarrow>
    proves env (IfThen c a b) v (Binary (IfThen c a b, v) t u)"
| ifF: "proves env c False t \<Longrightarrow> proves env b v u \<Longrightarrow>
    proves env (IfThen c a b) v (Binary (IfThen c a b, v) t u)"

theorem proves_value:
  "proves env e v t \<Longrightarrow> v = value env e"
  by (induction rule: proves.induct) auto

definition pair_trees where
  "pair_trees label xs ys = concat (map (\<lambda>t. map (Binary label t) ys) xs)"

lemma set_pair_trees [simp]:
  "set (pair_trees label xs ys) = {Binary label t u |t u. t \<in> set xs \<and> u \<in> set ys}"
  by (auto simp: pair_trees_def)

fun enum_bool :: "(nat \<Rightarrow> bool) \<Rightarrow> expr \<Rightarrow> proof_tree list" where
  "enum_bool env (Atom n) = [Tip (Atom n, env n)]"
| "enum_bool env (Conj a b) =
    (if value env a \<and> value env b then
       pair_trees (Conj a b, True) (enum_bool env a) (enum_bool env b)
     else (if value env a then [] else map (Unary (Conj a b, False)) (enum_bool env a)) @
          (if value env b then [] else map (Unary (Conj a b, False)) (enum_bool env b)))"
| "enum_bool env (Disj a b) =
    (if value env a \<or> value env b then
       (if value env a then map (Unary (Disj a b, True)) (enum_bool env a) else []) @
       (if value env b then map (Unary (Disj a b, True)) (enum_bool env b) else [])
     else pair_trees (Disj a b, False) (enum_bool env a) (enum_bool env b))"
| "enum_bool env (Neg a) = map (Unary (Neg a, \<not> value env a)) (enum_bool env a)"
| "enum_bool env (Impl a b) =
    (if value env a \<and> \<not> value env b then
       pair_trees (Impl a b, False) (enum_bool env a) (enum_bool env b)
     else (if value env a then [] else map (Unary (Impl a b, True)) (enum_bool env a)) @
          (if value env b then map (Unary (Impl a b, True)) (enum_bool env b) else []))"
| "enum_bool env (IfThen c a b) =
    (if value env c then pair_trees (IfThen c a b, value env a) (enum_bool env c) (enum_bool env a)
     else pair_trees (IfThen c a b, value env b) (enum_bool env c) (enum_bool env b))"

theorem bool_enumeration_sound:
  "t \<in> set (enum_bool env e) \<Longrightarrow> proves env e (value env e) t"
  by (induction e arbitrary: t) (auto split: if_splits intro: proves.intros)

theorem bool_enumeration_complete:
  "proves env e v t \<Longrightarrow> t \<in> set (enum_bool env e)"
  by (induction rule: proves.induct)
     (auto dest: proves_value)

theorem bool_enumeration_exact:
  "set (enum_bool env e) = {t. proves env e (value env e) t}"
  using bool_enumeration_sound bool_enumeration_complete by blast

definition minimal_bool where
  "minimal_bool canon better env e =
    (let ts = remdups (map canon (enum_bool env e))
     in filter (\<lambda>t. \<not> list_ex (\<lambda>u. better u t) ts) ts)"

theorem minimal_bool_exact:
  "set (minimal_bool canon better env e) =
    {t \<in> canon ` {u. proves env e (value env e) u}.
      \<not> (\<exists>u \<in> canon ` {u. proves env e (value env e) u}. better u t)}"
  unfolding minimal_bool_def Let_def
  by (auto simp: bool_enumeration_exact list_ex_iff)

end
