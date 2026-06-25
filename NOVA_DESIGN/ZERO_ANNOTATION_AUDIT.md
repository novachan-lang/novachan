# Zero-Annotation + Minimal-Code — Standard, Audit, and the Innovation Path

> **Why this exists.** NOVA's identity is *zero annotations for 95%+ of code, simpler than Python.*
> The compiler (the flagship NOVA program, self-hosted) is currently **annotation-heavy**, and recent
> additions (const-eval interpreter, `nova fmt` reprinter, `__from_dict_list`, typed-DB stdlib) added
> more. That contradicts the vision. This file is (1) the hard standard for new code, (2) the audit of
> the debt, and (3) the analysis of *how* to remove annotations AND boilerplate — including the one
> genuinely novel mechanism that makes NOVA code look new.

---

## The principle (the architect's frame)

**Every type annotation in NOVA source is an admission that the inferer failed there.** The fix is
almost never "annotate" — it is "make the genius compiler infer it." An annotation is a symptom, not
a solution. So the audit does not "strip annotations"; it **classifies each one** as either:
- **(I) inferable-today** — the inferer already resolves it; the annotation is pure noise → remove.
- **(G) inference-gap** — the inferer genuinely can't resolve it yet → it's a *compiler ticket* to
  close the gap, NOT a license to keep annotating. (Some are load-bearing for soundness today — e.g.
  feeding inferred types into the HOF specializer was UNSOUND, per PERFORMANCE_SPECIALIZATION.md — so
  these are removed only *after* the inference is completed soundly.)

## The standard (new code, effective immediately)

1. **No param/return/let annotations** unless an audit ticket proves it's a class-(G) gap.
2. **No boilerplate**: prefer the shortest form that reads like the intent. No ceremony added "to match
   surrounding style" — the surrounding style is the debt, not the bar.
3. When inference *can't* do it, the deliverable is **a compiler change that makes it infer** — filed,
   not annotated around.

---

## The two root causes of the noise (they need DIFFERENT fixes)

The verbose, annotated compiler code has two separable sources. Conflating them is why "just infer more"
isn't the whole answer.

### Cause 1 — Inference gaps  →  Fix: complete the inference (hard, core, not novel but essential)
Annotations like `fn f(x: dict, e: Expr) -> Stmt` exist because the inferer is **partial**: `fpt`
infers a param's type from *direct call sites* only. Higher-order calls (map/filter/pmap), recursion,
cross-module returns, and polymorphic helpers defeat it (documented gaps). The complete fix is
**usage-driven, whole-program inference**:
- **Infer a param from how the body USES it** (structural/row inference): `fn area(s) = s.w * s.h`
  → `s : {w, h : numeric}` — no annotation, no call-site needed. This is the deepest lever, because the
  compiler has the *whole-program view* (it sees every use) — the thing that lets NOVA out-infer Go's
  `:=` and even Hindley-Milner-by-itself.
- **Bidirectional flow**: combine call-site facts (`fpt`), body-usage facts, and return-flow into one
  global solve, with the occurs-check/soundness discipline already in `ti_unify`.
- **Honest hard part**: doing this SOUNDLY is the single hardest thing in the language (the HOF
  unsoundness proves naive type-flow corrupts float-vs-int). It's real research+build, staged, gated.
  But it IS "the compiler is the genius" promise — arguably more central to NOVA than any one feature.

### Cause 2 — Metaprogramming ceremony  →  Fix: QUASI-QUOTATION (the genuinely novel one)
The biggest single source of *boilerplate* in the compiler is hand-built ASTs:
```nova
let lam_body = Expr("call", T + "__from_dict", 0, [Expr("ident", "r", 0, [], [], ln)], [], ln)
let lam = Expr("lambda", "", 0, [lam_body], [Expr("ident", "r", 0, [], [], ln)], ln)
eff = Expr("call", "map", 0, [src, lam], [], ln)
```
That is ~3 lines of positional-constructor noise for *one* expression — and the source of the
"field 6 / int-value-is-`en`" gotcha class. The innovative fix is **hygienic quasi-quotation** (Lisp
`quote`/Elixir `quote`/Template-Haskell, but with NOVA's zero-ceremony surface):
```nova
eff = quote( map($src, fn(r) $T__from_dict(r)) )      // writes the AST FOR you
```
`quote(...)` parses the template once at compile time into AST-construction code; `$x` splices a value;
hygiene auto-freshens binders (no shared-node bug, no manual `ln` threading). This:
- **Collapses 80% of the compiler's verbose code** (and all of what I just added) into readable templates.
- **Kills the positional-field bug class** by construction (you never hand-write `Expr(...)`).
- **Becomes a first-class user feature**: NOVA gets macros/metaprogramming that read like NOVA — beating
  Rust's `macro_rules!` complexity and Lisp's parens. *This is what makes NOVA code look new.*

### Cause 2b — Destructuring ceremony  →  field access over `match Ctor(a,b,c,...)`
`match e { Expr(t, v, n, c, f, l) => ... }` is positional and brittle. With structural inference (Cause
1), simple reads become `e.tag` / `e.children` (the compiler infers `e : Expr` from the access) — `match`
stays only for real sum-type dispatch, not for "I just want one field."

---

## The payoff — what "looks new" means concretely
NOVA code becomes: **write the behavior and the shape; the compiler infers every type, and you
template-write any code-that-writes-code.** No `: type`, no `match Ctor(...)` for field reads, no
hand-built ASTs. It reads like pseudocode. That is a different surface from Java (annotations),
Go (`:=` but explicit signatures), Rust (turbofish + macro_rules), and even Python (no inference,
no hygienic macros). The combination — *complete usage-inference + hygienic quasi-quote + structural
field access* — is the novel thing, and it lands hardest on the compiler itself (the proof program).

---

## Audit ledger (fill as we classify; (I)=remove now, (G)=compiler ticket)
| Site | Annotations | Class | Action |
|---|---|---|---|
| `ce_eval_expr`/`ce_eval_call`/`ce_eval_block` (const-eval) | `: dict`/`: Expr`/`-> CeVal` | TBD | classify each param vs the inferer |
| `fmt_rp_expr`/`fmt_rp_stmt`/`fmt_*` (nova fmt) | `: Expr`/`: dict`/`-> string` | TBD | classify |
| `_make_from_dict_list_method` + the assign-ladder arms | `: string`/`: int`/`-> Stmt` | TBD | classify |
| `db_insert`/`db_delete`/`db_all`/`db_find`/`db_query_named` (stdlib) | `: string`/`-> int` | TBD | classify |
| `eval_expr` (#30) | `: dict`/`: Expr`/`-> any` | TBD | classify |

> Method: compile each function with its annotations removed (one at a time), under the full gate. If
> gen5.ll==gen6.ll holds and the function's test passes → class (I), commit the removal. If inference
> fails/changes behavior → class (G): file the specific inference gap (what the inferer couldn't resolve)
> as a compiler task; keep the minimal annotation until that gap is closed. NEVER strip blindly.

## Sequencing
- **Now:** standard adopted for new code; this audit opened. Current Forge gate finishes + commits
  (its functions are correct; the annotation form is debt, not a bug).
- **Track A (NOVA core, the identity work):** (1) usage-driven structural inference, staged + soundness-
  gated; (2) hygienic `quote`/`$splice`; (3) field-access-over-destructuring. This competes with Forge
  for priority — it is arguably more core (it's the "simpler than Python" proof). User decides the mix.
- **Track B (Forge):** continues; all NEW Forge code is written to the standard from here.

---

## SYNTHESIS — design workflow w60vm6it3 (2026-06-25, 11 agents, code-grounded)

A 4-phase workflow (audit → design → adversarial review → synthesize) settled the path against the REAL compiler code (every claim cites `nova_compiler.nova` file:line).

### The adversarial review KILLED both naive inference designs (we dodged a CVE)
- **use-set-monomorphization**: *needs-work* — premise false (`ti_fn_param_types` is ALREADY `d_fn_type`-sourced + struct-filtered at 12985-13000 / 9921); lambda-hero path structurally broken by the capture-prefix index shift (7204-7212) + the TI/IR phase boundary.
- **structural-bidirectional (unique-field narrowing)**: **UNSOUND / CVE-class** — pinning a param to struct S from a field access emits a NATIVE struct slot-read; if any caller passes a non-struct (`any`/`dict`), that's type-confusion strictly worse than B12. Rejected.

### Honest reframe on the Forge hero
NOVA lambdas take NO annotation today. The load-bearing `req: Request` sits on the named helper (`list_todos(req: Request, pool)`). So making `fn(req) -> ...` work buys **correctness (closes B12) + native dispatch (perf)** — NOT developer-annotation reduction. The hero is already lambda-annotation-free; be transparent about that.

### class-I (strip now — verified byte-identical .ll)
- ALL `: string` params (~209): `+`/`==`/index/`len` dispatch on the operand / `_any` runtime fn, not the annotation.
- `-> string`/`-> bool` returns NOT feeding typed dispatch (~110). EXCLUDE any `-> Struct` return that feeds `let x=f(); x.field`.
- Direct-call `: int`/`: dict`/`: list`/struct params whose callers all pass typed literals/locals (fpt/struct-S1 recovers them). NOT the forwarded helper→helper params.

### class-G (real gaps — compiler tasks; NEVER re-annotate around them)
1. **Lambda param typing** (TI lambda case = `nt_any`, 11934). Solve in the IR layer (captures known), by NAME not positional index.
2. **Cross-fn forwarding of SCALAR params** (tree-walkers `ce_*`/`eval_expr`/`fmt_rp_*`). Sound fix = whole-program use-SET monomorphization (per-instantiation, conflict→`any`). The int/float landmine lives here — naive body-flow FORBIDDEN.
3. **B12 global field-slot collision** — a SYMPTOM of (1)/(2), not independent. Do NOT "fix" with a field→struct reverse map (shared field names body/path/headers = ambiguous/unsound).
4. **Unannotated struct returns** don't flow to caller dispatch (`ir_fn_returns` only from source `-> Type`). Thread the HM-resolved struct name (`ti_to_ir_stype`, preserves names) in.
5. **Metaprogramming boilerplate** — 474 `Expr(` + 248 `Stmt(` construction sites. Not inference; the quasi-quote feature.

### Staged, gated plan (safest first)
- **S0** — strip verified class-I `: string`/`-> string`/`-> bool` (per cluster: .ll-diff byte-identical → reconverge → 588 both modes). Very low risk. **THE SAFE FIRST STEP.**
- **S1** — IR-layer lambda-param struct pinning (the hero): pin by NAME when the body forwards into an already-pinned struct param AND no caller can supply a non-struct; flag `NOVA_LAMBDA_INFER` (default OFF). Gated + `_lambda_param_any_arg` CVE canary + float canaries.
- **S2** — thread HM-resolved struct RETURN names into `ir_fn_returns` (unannotated struct returns flow to caller dispatch). Nominal-only, low-medium.
- **S3** — compiler-internal hygienic `quote(...)`/`$splice` (the "looks new" novelty). Sidesteps the int/float landmine (touches neither `ti_*` nor `fpt`). Must-fixes: name-fragment splice concatenates at REIFY time into `Expr.value`; BEHAVIORAL-equivalence oracle (NOT .ll-identity, due to the `__quote_ln` hoist); parse-phase gensym determinism (protects reconvergence).
- **S4** — sound whole-program use-set monomorphization for SCALAR forwarding (the compiler's perf prize: tree-walkers go native). **HIGH RISK — the documented unsoundness zone.** Defer until S0–S3 + the int-AND-float generic-HOF canary harness are in place. Naive type-flow FORBIDDEN.

### Open questions for the owner
1. The hero (S1) is correctness+perf, not annotation reduction — prioritize it, or chase literal-zero-annotations-everywhere (needs the high-risk S4)?
2. Visible annotation-count reduction first (S0–S3), or accept S4 risk for compiler self-compile speed?
3. `quote(...)` user-facing macro now, or compiler-internal only until the language matures?
4. S2 may fire `E1007 no-field` errors earlier (correct rejections) — acceptable, or strictly additive?
