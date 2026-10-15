theory baoxiao_rules
  imports Main
begin

record input_case =
  a :: bool
  b :: bool
  c :: bool

definition yes :: input_case where
  "yes = \<lparr>a=True, b=True, c=True\<rparr>"
definition no :: input_case where
  "no = \<lparr>a=False, b=False, c=False\<rparr>"
definition middle :: input_case where
  "middle = \<lparr>a=True, b=False, c=False\<rparr>"

definition route :: "input_case \<Rightarrow> nat" where
  "route x = (if \<not> a x then 0 else if \<not> (b x \<or> c x) then 1 else 2)"

definition alternative :: "input_case \<Rightarrow> bool" where
  "alternative x = (a x \<or> (a x \<and> b x))"

datatype category = C1 | C2
datatype payload = P1 input_case | P2 input_case
record wrapped_case =
  category :: category
  payload :: payload

definition category_of :: "payload \<Rightarrow> category" where
  "category_of p = (case p of P1 _ \<Rightarrow> C1 | P2 _ \<Rightarrow> C2)"
definition wrap :: "input_case \<Rightarrow> wrapped_case" where
  "wrap x = \<lparr>category=C1, payload=P1 x\<rparr>"
definition dispatch :: "wrapped_case \<Rightarrow> nat" where
  "dispatch x = (if category x = category_of (payload x)
     then (case payload x of P1 y \<Rightarrow> route y | P2 y \<Rightarrow> route y) else 3)"
definition routed :: "input_case \<Rightarrow> nat" where
  "routed x = dispatch (wrap x)"

end
