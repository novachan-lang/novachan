# Typed Extraction Design (workflow wia6qxvo7, 8 agents, Opus design/adversary + Sonnet research)

Vetted, adversarially-reviewed plan for Forge typed inbound extraction: `from_json_safe<T>`,
`query_as<T>`, `form_as<T>` (and `body_as` as a doc-alias over the proven `from_json`). The
inbound half of "return your type". Implement AFTER the non-dict from_json soundness fix lands.

## The sound mechanism (avoids the unsound-spec trap)

A SYNTACTIC let-site rewrite keyed on the EXPLICIT annotation string `fj_pt` (NOT inference). Each
generated `<T>__from_*` method is MONOMORPHIC (one declared concrete param type, called from exactly
one synthesized site) -> `ir_collect_param_types`/fpt has no conflicting sites to mis-merge and
`d_fn_type` is never consulted to pick T (T is the literal annotation). Byte-for-byte the same posture
as the shipping `from_json` rewrite (nova_compiler.nova ~L8438). DO NOT route through
ti_fn_param_types/fpt (the documented "expected 4 got 1.97e-323" trap).

## Int/float boxing closed two ways
- JSON float field: change `_make_from_json_method` float-field read from bare `d[f]` to `float(d[f])`
  (nova_rt_to_float L7894 is box-aware AND i2f's a raw int) so `{"price":5}` into `price:float` -> 5.0.
- String-mode float coercion: a `coerce_float(s):float` builtin (raw double bits, float-typed in HM) so
  the make_struct narrow is skipped (raw stays raw, read via nova_float_arg). Use SEPARATE
  coerce_int(s):int / coerce_float(s):float / coerce_bool(s):int builtins (precise HM return types)
  rather than one tagged coerce_str (whose `any` return would re-trigger the boxing bug).

## Implementation steps (from the synthesis)
- STEP 0 (runtime, BOTH nova_runtime.c copies): `nova_rt_json_decode_checked(s)` -> Result. Clear the
  PER-TASK error_flag on entry (nova_cur()->error_flag=0; reuse existing nova_rt_take_error_flag L94 --
  do NOT add a second flag), parse, require FULL consumption (pos==len after trailing ws) AND top-level
  find_tag==NOVA_MEM_DICT, else Err. (This is what makes from_json_safe a real validity gate -- and the
  same non-dict guard the unsafe from_json now applies inline.)
- STEP 1 (runtime, both copies): coerce_int/coerce_float/coerce_bool (string->typed; NULL-safe; DB rows
  trusted so atoll silent-0 is acceptable + documented). Declare at BOTH `declare i64 @nova_rt_*` emit sites.
- STEP 2 (compiler ~L4500 name-map + builtin reg): map json_decode_checked + coerce_* to the runtime fns.
  Do NOT register from_json_safe/query_as/form_as as ordinary builtins (they are consumed by the rewrite).
- STEP 3 (compiler, near _fj_default): `_coerce_field(ftype, str_expr, ln)` AST helper (int/float/bool/string).
- STEP 4 (compiler, next to _make_from_json_method): `_make_from_json_safe_method` (wraps __from_json on Ok),
  `_make_from_row_method` (POSITIONAL, length-guarded, per-field _coerce_field), `_make_from_form_method`
  (name-keyed dict, per-field _coerce_field). Plus the float(d[f]) surgical fix to _make_from_json_method.
- STEP 5 (compiler, registration loop ~L3691): push the three generators per struct, dead-strippable.
- STEP 6 (compiler, typed-let rewrite ~L8425): strip Result<T>/list<T> inner name BEFORE the ir_sdefs gate;
  add arms: from_json_safe -> <T>__from_json_safe (leave slot SUM-typed -- do NOT write inner into
  ir_locals, ti_ann_to_type collapses Result<T>->T and would mistype it); form_as -> <T>__from_form;
  query_as -> map(pool_query(...), fn(row) <T>__from_row(row)) + set ir_list_elem_stype.
- STEP 7 (forge, Err->422): the developer writes `match r { Ok(t)=>resp_json(201,t), Err(e)=>resp_error(422,e) }`.
  resp_error already exists. NO compiler involvement; do NOT touch _coerce.
- STEP 8 (forge): body_as = a doc-alias over `let t: T = from_json(req.body)` (a lib fn loses the let-site
  keystone, so it MUST stay a documented pattern, not a fn).

## Gate
gen4-verify: happy JSON; INT-INTO-FLOAT (price:float from `{"price":5}` -> 5.0 via assert_near);
TRAP-REPRO non-dict from_json_safe("42"/"[1,2]"/"\"hi\""/"true") -> Err not crash; trailing-garbage -> Err;
stale-flag (failing op then good -> Ok); query_as coercion; form_as; FPT-TRAP GUARD (a poly helper at
int+float ALONGSIDE the extractors -> no mis-specialization); Err->422 status line. THEN reconverge
gen5.ll==gen6.ll (the generators are no-ops for the compiler's own source -> byte-identical). THEN
regression BOTH modes (the float(d[f]) change is the risk surface -- from_json_test must cover {"price":5}
AND {"price":5.0}).

## Risks (tracked)
- float(d[f]) touches the proven from_json path -- cover both int + float literals in from_json_test.
- query_as POSITIONAL (SELECT col order == field order) is a silent-corruption footgun; offer a name-keyed
  `query_as_named(pool,sql,params,cols)` over pool_query_dicts (forge_db L40) as the safer wide-struct form.
- form_as/query_as use atoll (silent-0), so they are COERCERS not validators; document; a form_as_safe ->
  Result<T,list<FieldError>> (Pydantic-style) is the principled follow-up.
- EDIT BOTH runtime copies + BOTH declare sites (the classic two-copy/two-site footgun).
- from_json_safe slot must stay SUM-typed (STEP 6) or the match dispatch breaks -- permanent guard test.

## ALREADY FIXED (this session, the non-dict soundness hole the adversary found)
`_make_from_json_method` now coerces a non-dict `d` to `{}` up front (`if type_name(d)!="dict": d={}`),
so the UNSAFE from_json no longer wild-derefs on `from_json("42")` etc. (contains on a bare int was a
remote-crash hole via the scaffold's `from_json(req.body)`). from_json_safe's json_decode_checked is
the typed/validating counterpart (Err instead of silent-default).
