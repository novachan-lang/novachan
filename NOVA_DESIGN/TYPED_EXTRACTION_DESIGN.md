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

## from_json_safe DONE (pure-NOVA, deviated from STEP 0's json_decode_checked runtime plan)
Implemented WITHOUT a runtime edit (lower risk): `_make_from_json_safe_method` emits a NOVA fn
`<T>__from_json_safe(s)` = `let d=json_decode(s); if type_name(d)!="dict": return err(...);
ok(<T>__from_json(d))`. json_decode returns a dict ONLY for objects (probed: int->int, arr->list,
str->string, empty/garbage->int), so `type_name(d)!="dict"` is a real validity gate (only brace-started
malformed `{bad`->empty dict->ok(defaults) slips; documented v1 gap). Typed-let rewrite at ~L8460
(`let r: Result<T> = from_json_safe(s)` -> `<T>__from_json_safe(s)`, slot forced SUM-typed via
fj_force_any=1). Required TWO inferer fixes: (1) registered `from_json_safe` builtin returning
nt_sum(T,string); (2) ti_ann_to_type_g `Result<T>` was COLLAPSING to inner T (latent bug, zero real
annotations relied on it) -> now nt_sum(T,string), aligned with the `T?` Option sugar. GATE: generation
is SKIPPED when the unit user-shadows `ok`/`err` (shadow_test defines `fn ok` -> the generated body's
`ok(...)`/`err(...)` would bind the wrong fn; caught by the full regression). Guards: from_json_safe_test
+ from_json_safe_forge_test (422-on-bad-body end-to-end).

## query_as / form_as -- REVISED after adversary workflow wa0y0jben (verdict was unsafe-redesign)
The 8-agent design (sqlx/Pydantic/Ecto + Opus synthesis + Opus adversary) overturned the STEP-1/4 plan:
- DECISION (kept): NAME-KEYED only, never positional (positional is THE silent-corruption footgun -- a
  mid-table migration shifts every field). Both query_as<T> & form_as<T> consume a {col:string} dict and
  bind by `d[field_name]`. DECISION (kept): bad value -> Err with field name; missing key -> type-correct
  default (absence != malformed); strict-on-missing is opt-in (query_as_strict).
- ADVERSARY FATAL (empirically PROVEN on this machine): binding a float via
  `match parse_float_safe(raw) { Ok(v) => local = v }` LOSES the float static type -> `bal="3.14159"`
  reads back as `4614256650576692846` (raw IEEE bits printed as int). The "Ok(v) carries float type
  end-to-end" claim is FALSE. to_json MASKS it (struct-meta render) so a happy-path test ships green.
  FIX: re-establish float typing at the bind site with `float(<ok payload>)` (mirror the WORKING
  from_json path). MUST-HAVE regression: str(field)==input AND field*2 correct AND to_json correct.
- PIVOT (risk-killer): make query_as/form_as ENTIRELY PURE-NOVA -- NO runtime edit, NO parse_bool_safe
  (the adversary found 5+ runtime copies, not 2; the two-copy plan was factually wrong). Field binding:
  int->parse_int_safe (exists), float->float(parse_float_safe ok) (exists + the fix), bool->INLINE NOVA
  string compare (true/1/t/yes/on vs false/0/f/no/off -> else Err), string->passthrough,
  struct-><F>__from_json_safe (exists). Gated on no ok/err shadow, like from_json_safe.
- ADVERSARY HIGH (NULL): SQLITE_NULL -> cstr_to_string(NULL)="" -> PRESENT key "" -> parse_int_safe("")
  -> Err -> the whole row fails. NULL is indistinguishable from "" at the dict layer. FIX: empty-string
  -> type-correct default for NON-STRING fields in BOTH from_row & from_form (consistent, total; nullable
  columns are THE common shape). Loses loud-"" detection; correct tradeoff.
- ADVERSARY MEDIUM (harden): row_dict/pool_query_dicts zip `while i<len(cols) and i<len(row)` silently
  omits keys on a short row -> name-keying drift one layer up. FIX: error (or do not silently omit) on
  len(row)!=len(cols).
- TRACKED pre-existing (NOT introduced here, affect from_json too): cstr_to_string strlen-truncates at
  embedded NUL; parse_float_safe strtod is LC_NUMERIC-locale-dependent. Note as known-limitations.
- Code-location drift: the design's line numbers were stale; re-verify against real source (row_dict is
  forge.nova ~L685-693; forge.nova/forge_db.nova exist in forge/, nova-compiler/lib/, _nh_home/lib/).
