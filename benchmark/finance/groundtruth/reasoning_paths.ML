(* Syntax-directed explanation forests. Runs inside the loaded Isabelle theory.
   Values are computed by Isabelle/NBE; this is not a kernel completeness proof. *)
structure Reasoning_Paths =
struct

fun quote s = "\"" ^ String.translate (fn c =>
  if c = #"\"" then "\\\"" else if c = #"\\" then "\\\\"
  else if c = #"\n" then "\\n" else if c = #"\r" then "\\r"
  else if c = #"\t" then "\\t"
  else if Char.ord c < 32 then " " else str c) s ^ "\"";
fun array xs = "[" ^ commas xs ^ "]";
fun obj xs = "{" ^ commas (map (fn (k,v) => quote k ^ ":" ^ v) xs) ^ "}";
fun pretty ctxt t = XML.content_of (YXML.parse_body (Syntax.string_of_term ctxt t));

val shared_evaluator = Unsynchronized.ref (NONE : (term -> term) option);
val shared_values = Synchronized.var "reasoning_values" Termtab.empty;
val output_lock = Synchronized.var "reasoning_output" ();
fun initialize ctxt expressions =
  let val terms = map (Syntax.read_term ctxt) expressions
      val consts = fold Term.add_const_names terms []
  in shared_evaluator := SOME (Nbe.static_value {ctxt=ctxt, consts=consts} ctxt);
     Synchronized.change shared_values (K Termtab.empty) end;

fun export ctxt max_depth name expression =
 let
  val term = Syntax.read_term ctxt expression;
  val evaluate = (case !shared_evaluator of SOME f => f | NONE =>
    Nbe.static_value {ctxt=ctxt, consts=Term.add_const_names term []} ctxt);
  val values = shared_values;
  val memo = Unsynchronized.ref Termtab.empty;
  val nodes = Unsynchronized.ref ([] : string list);
  val issues = Unsynchronized.ref ([] : string list);
  val serial = Unsynchronized.ref 0;
  fun mk_bool b = Const (if b then "HOL.True" else "HOL.False", HOLogic.boolT);
  fun record_type t = is_some (try (Record.get_recT_fields
    (Proof_Context.theory_of ctxt)) (fastype_of t));
  fun rewrite thms t = Thm.term_of (Thm.rhs_of
    (Simplifier.rewrite (put_simpset HOL_basic_ss ctxt addsimps thms)
      (Thm.cterm_of ctxt t)));
  fun domain n = String.isPrefix "baoxiao_rules." n orelse
                 String.isPrefix "baoxiao_cases." n;
  fun selector n args = (case args of [a] =>
    (case try (Record.get_recT_fields (Proof_Context.theory_of ctxt)) (fastype_of a) of
       SOME (fields, _) => exists (fn (field, _) => field = n) fields
     | NONE => false) | _ => false);
  fun backend t =
    (case Exn.capture evaluate t of Exn.Res v => v
      | Exn.Exn exn => if Exn.is_interrupt exn then Exn.reraise exn else
        (case Exn.capture (Nbe.dynamic_value ctxt) t of Exn.Res v => v
        | Exn.Exn exn' => if Exn.is_interrupt exn' then Exn.reraise exn'
          else error ("Evaluation failed for " ^ pretty ctxt t ^ ": " ^ Runtime.exn_message exn')));
  fun eval t = (case Termtab.lookup (Synchronized.value values) t of SOME v => v | NONE =>
    let
      fun boolean a = (case eval a of Const ("HOL.True", _) => true
        | Const ("HOL.False", _) => false | _ => error "Non-ground Boolean")
      val (head,args) = Term.strip_comb t;
      fun general () = (case head of Const (n, _) =>
        if selector n args then
          let val u = head $ eval (hd args)
              val v = Thm.term_of (Thm.rhs_of (Simplifier.rewrite
                (put_simpset (Record.get_simpset (Proof_Context.theory_of ctxt)) ctxt)
                (Thm.cterm_of ctxt u)))
          in if u aconv v then backend t else eval v end
        else if record_type t then backend t
        else (case Ctr_Sugar.ctr_sugar_of_case ctxt n of SOME sugar =>
          let val k = length (#ctrs sugar) in
            if length args = k + 1 then
              eval (rewrite (#case_thms sugar)
                (list_comb (head, take k args @ [eval (nth args k)])))
            else backend t end
        | NONE => (case if domain n then try (Proof_Context.get_thm ctxt) (n ^ "_def") else NONE of
            SOME th => let val u = rewrite [th] t
                       in if u aconv t then backend t else eval u end
          | NONE => backend t))
        | _ => backend t);
      val v = (case (head,args) of
          (Const ("HOL.conj", _), [a,b]) => mk_bool (boolean a andalso boolean b)
        | (Const ("HOL.disj", _), [a,b]) => mk_bool (boolean a orelse boolean b)
        | (Const ("HOL.implies", _), [a,b]) => mk_bool (not (boolean a) orelse boolean b)
        | (Const ("HOL.Not", _), [a]) => mk_bool (not (boolean a))
        | (Const ("HOL.If", _), [g,a,b]) => eval (if boolean g then a else b)
        | (Const ("HOL.Let", _), [a,f]) => eval (Envir.beta_norm (f $ a))
        | _ => general ())
    in Synchronized.change values (Termtab.update (t,v)); v end);
  fun truth t = (case eval t of
      Const ("HOL.True", _) => true
    | Const ("HOL.False", _) => false
    | v => error ("Non-ground Boolean: " ^ pretty ctxt v));
  val records = Unsynchronized.ref Termtab.empty;
  val bindings = Unsynchronized.ref ([] : string list);
  fun compact t =
    if not (Term.is_open t) andalso record_type t then
      let val v = eval t
          val label = (case Termtab.lookup (!records) v of SOME s => s | NONE =>
            let val s = "input_record_" ^ string_of_int (length (!bindings))
                val _ = records := Termtab.update (v,s) (!records)
                val _ = bindings := obj [("name",quote s),
                  ("expression",quote (pretty ctxt t)),
                  ("value",quote (pretty ctxt v))] :: !bindings
            in s end)
      in Free (label, fastype_of t) end
    else (case t of f $ a => compact f $ compact a
         | Abs (s,T,b) => Abs (s,T,compact b) | _ => t);
  fun render t = pretty ctxt (compact t);
  fun add_value kind t value alternatives =
    let val id = !serial
        val _ = serial := id + 1
        val data = obj [("id", string_of_int id), ("kind", quote kind),
          ("expression", quote (render t)),
          ("value", value),
          ("alternatives", array (map (array o map string_of_int) alternatives))]
    in nodes := data :: !nodes; id end;
  fun add kind t alternatives = add_value kind t (quote (render (eval t))) alternatives;
  fun opaque why t = (issues := (why ^ ": " ^ pretty ctxt t) :: !issues;
    add "opaque" t [[]]);
  fun definition n = try (Proof_Context.get_thm ctxt) (n ^ "_def");
  fun walk depth t0 =
    let val t = Envir.beta_eta_contract t0 in
    case Termtab.lookup (!memo) t of SOME id => id | NONE =>
    let
      fun child x = walk (depth + 1) x;
      fun both kind a b = add kind t [[child a, child b]];
      fun choices kind xs = add kind t (map (fn x => [child x]) xs);
      val (head, args) = Term.strip_comb t;
      fun fallback () =
        (case head of Const (n, _) =>
          if selector n args orelse record_type t orelse n = "List.nth"
          then add "fact" t [[]] else
          if member (op =) ["baoxiao_rules.cap_by_rank", "baoxiao_rules.lookup_regular",
                            "baoxiao_rules.lookup_season"] n
          then add ("lookup:" ^ n) t [map (fn a =>
            case fastype_of a of Type ("List.list", _) =>
              add_value "table-reference" a "null" [[]]
            | _ => child a) args]
          else
          (case if domain n andalso is_none (Ctr_Sugar.ctr_sugar_of_case ctxt n)
                then definition n else NONE of
            SOME th => let val u = rewrite [th] t in
              if u aconv t then opaque "Definition did not unfold" t
              else add ("rule:" ^ n) t [[child u]] end
          | NONE =>
            (case Ctr_Sugar.ctr_sugar_of_case ctxt n of
              SOME sugar =>
                let val k = length (#ctrs sugar)
                in if length args = k + 1 then
                  let val input = nth args k
                      val u = rewrite (#case_thms sugar)
                        (list_comb (head, take k args @ [eval input]))
                  in if u aconv t then opaque "Unreduced case" t
                     else add "case" t [[child input, child u]] end
                else opaque "Partial case application" t end
            | NONE =>
              (* Comparisons and arithmetic are explicit calculation boundaries.
                 Explain their ground arguments too, so nested business calls
                 do not disappear behind a True/False or amount value. *)
              if null args then add "literal" t [[]]
              else if exists (fn x => can dest_funT (fastype_of x)) args
                   then opaque "Higher-order application" t
              else if domain n andalso is_some (try (Proof_Context.get_thms ctxt) (n ^ ".simps"))
                   then opaque "Recursive business function" t
              else if domain n then
                (case fastype_of t of Type (ty, _) =>
                  (case Ctr_Sugar.ctr_sugar_of ctxt ty of SOME sugar =>
                    if exists (fn c => fst (dest_Const c) = n) (#ctrs sugar)
                    then add "constructor" t [map child args]
                    else opaque "Unknown business constant" t
                  | NONE => opaque "Unknown business constant" t)
                | _ => opaque "Unknown business constant" t)
              else add "compute" t [map child args]))
        | _ => opaque "Unsupported term" t);
      val id = if depth > max_depth then opaque "Depth limit" t else
        (case (head, args) of
          (Const ("HOL.conj", _), [a,b]) =>
            if truth t then both "and:true" a b
            else choices "and:false" (filter (not o truth) [a,b])
        | (Const ("HOL.disj", _), [a,b]) =>
            if truth t then choices "or:true" (filter truth [a,b])
            else both "or:false" a b
        | (Const ("HOL.implies", _), [a,b]) =>
            if truth t then choices "implies:true"
              ((if truth a then [] else [a]) @ (if truth b then [b] else []))
            else both "implies:false" a b
        | (Const ("HOL.Not", _), [a]) => add "not" t [[child a]]
        | (Const ("HOL.If", _), [g,a,b]) =>
            add (if truth g then "if:then" else "if:else") t
              [[child g, child (if truth g then a else b)]]
        | (Const ("HOL.Let", _), [a,f]) =>
            add "let" t [[child (Envir.beta_norm (f $ a))]]
        | _ => fallback ());
      val _ = memo := Termtab.update (t,id) (!memo)
    in id end end;
  val root = walk 0 term;
  val _ = if eval term aconv backend term then ()
          else error "Root result disagrees with independent Isabelle/NBE evaluation";
 in obj [("case", quote name), ("expression", quote expression),
    ("result", quote (pretty ctxt (eval term))), ("root", string_of_int root),
    ("input_bindings", array (rev (!bindings))),
    ("nodes", array (rev (!nodes))),
    ("issues", array (map quote (distinct (op =) (!issues))))] end;

fun write_case ctxt max_depth path (name, expression) =
  let val result = (case Exn.capture (export ctxt max_depth name) expression of
      Exn.Res value => value
    | Exn.Exn exn => if Exn.is_interrupt exn then Exn.reraise exn else
        obj [("case",quote name), ("expression", quote expression),
             ("error",quote (Runtime.exn_message exn))])
  in Synchronized.change output_lock (fn () => File.append (Path.explode path) (result ^ "\n"));
     writeln ("PATH_CASE_DONE " ^ name) end;
end;
