# NOVA Perf Endgame — Stages 3-5 Execution Plan (Float C-parity → Beat C)

**Created:** 2026-06-11  **Status:** ACTIVE task list for the perf-domination push (~5 work-days).
**Parent plans:** [PERFORMANCE_SPECIALIZATION.md](PERFORMANCE_SPECIALIZATION.md) (the design),
[COMPETITIVE_DOMINATION_PLAN.md](COMPETITIVE_DOMINATION_PLAN.md) (Stage 4 here == that plan's
Tier-1 #4 "stack alloc for small structs", the item flagged as "C-level perf has a visible asterisk
without it").

> **The one principle (not copied — NOVA-original): Representation Inference.**
> Type inference proves WHAT each value is; Representation Inference proves HOW to represent it.
> Where the type is known and the value stays inside the program → native machine form (raw double,
> register struct, native ABI). Only at the genuine knowledge boundary (any / container / channel /
> reflection) → uniform i64/boxed form, with box/unbox coercions placed ONLY at that boundary, exactly
> like SSA places φ-nodes. NOVA beats C because its compiler has whole-program type + escape info that
> C's per-TU compiler never gets. Stages 3-5 are this one region GROWING: 3 through struct fields,
> 4 through whole non-escaping structs (no heap), 5 across function-call boundaries (native ABI).

## DONE (foundation — do not redo)
- **Stage 1** (b36ae32): inferred types → native ops. int struct fields = `mul i64` (true C-parity);
  float struct fields = native `fmul`/`fadd`. Works for unannotated code (inferer threads types).
- **Stage 2** (fbb7b64, SOUND): skip the redundant `nova_rt_unbox` on provably-raw float SSA temps
  (const_float + arith results); rawness NEVER leaks through mutable slots (slot_store guard). Verified:
  `dot` 6→4 unbox, idot pure `mul i64`, nn.ll deterministic, regression 393/393 ×3, converged 731C01F7.

## The measurable end-state (what "done" means — falsifiable)
- `_perf_probe.nova` `dot_typed`/`dot_unann`: **0** `nova_rt_unbox`, **0** `nova_rt_struct_alloc` on the hot
  path → pure `load/fmul/fadd` (or registers). idot already there.
- A `matmul`/`dot`/`physics-step` microbench **≥ 1.0× C** (was 0.99x; target: meet or beat with `-O2`).
- Full parallel regression **393/393**, bootstrap reconverged (gen5.ll==gen6.ll), every run.

---

## STAGE 3 — Raw float struct fields  ·  Day 1  ·  beats: C/Rust (struct math)

**Goal:** remove `dot`'s remaining 4 field-read unboxes → float struct field access becomes `load + bitcast`,
not `load + call nova_rt_unbox`. Headline: float struct math hits C-parity.

**Acceptance (falsifiable):** after the change, `dot_typed`/`dot_unann` contain **0** `nova_rt_unbox`;
EVERY float test stays green (auto_show/eq/json, nested_float, nn, stats, physics2d, math3d, simdx, geox,
tensor); bootstrap reconverges; regression 393/393 ×3.

**Mechanism (verified against code):** fields are stored RAW today for typed args (`const_float` emits raw
IEEE bits, construction `store i64 args[fi]` directly — `_perf_probe.ll` confirmed: `store i64 %r3, %r5.f0`,
no `box_float`), but a field built from an `any` arg (dict/list/generic read) would be BOXED. So the read
can only skip the unbox once EVERY write guarantees raw. The fix is the **narrow coercion** (dual of wbox):
coerce `any`→raw at every float-field WRITE, then skip the unbox at every float-field READ.

**Exact sites (file:line, current):**
- Setup `nova_compiler.nova:15865` — where `frt["@sf@"+Type.field]` is populated. ADD a per-struct
  positional kinds string `frt["@sfkinds@"+Type] = "f.f…"` (`f`=float field, `.`=other), built in field order
  — solves the "make_struct args are positional but field types are by-name" snag.
- Coercion pass `ir_infer_block` (~`13110`, the wbox loop) — ADD an `op == "make_struct"` branch mirroring the
  `call` wbox branch but INVERTED: for each arg whose `@sfkinds@` position is `f` and whose `rt`-type is NOT
  already `"float"` (i.e. boxed/any), push `nova_rt_unbox(arg)` and rewrite the arg to the raw result.
- `field_set` (same pass) — `obj.x = v` where `x` is float: narrow `v` the same way (field type via
  `frt["@sf@"+rt[obj]+"."+field]`). `struct_spread` re-stores via make_struct → already covered.
- IRE `field_get` `nova_compiler.nova:14177` — when the inst type `typ` is float, set
  `e.ire_reg_types[dest] = "float"` so the existing Stage-2 `ire_float_load` emits bitcast-only (skip unbox).

**Soundness requirements (the value-model boundary — get these right):**
1. After the narrow, ALL float fields are raw → `==`/hash/deep_copy (which read slots as i64 and compare/copy
   bits) stay CONSISTENT (no raw-vs-boxed mismatch). This is the property that makes skipping the read unbox safe.
2. Field VALUE → `any` (append to list, return any, reflection) is already boxed by the EXISTING IR-level wbox
   because `field_get` carries `fld_type=float`. Verify, don't assume.
3. int arg → float field: ensure the type checker already converts (sitofp) so the narrow only ever sees
   float/any, never raw-int (else `unbox` would misread int bits as a double). Add a guard if needed.
4. Mark rawness ONLY on the field READ result (SSA temp); it must NOT propagate onto mutable slots
   (Stage-2 slot_store guard already enforces this).

**Sub-tasks (ordered):** (a) build `@sfkinds@` at setup; (b) make_struct narrow; (c) field_set narrow;
(d) field_get mark; (e) precheck dot=0 unbox; (f) bootstrap; (g) regression ×3 + the float-heavy subset.
**Risk:** the float-into-any boundary I hardened earlier this session — the regression's float suite is the oracle;
revert on ANY float-soundness failure. **Effort: ~1 day.**

---

## STAGE 4 — Struct SROA / stack-alloc non-escaping structs  ·  Day 2-3  ·  beats: C, Rust

> **INVESTIGATION FINDINGS (2026-06-11) — READ BEFORE STARTING. Corruption-risk; here is the real surface.**
> - RC is ALREADY elided for local structs: `ir_escape_analysis` returns `local_set` (non-escaping
>   make_struct/list/dict dests, builder ~12107); `local_set` → `e.ire_local_lists` at ~16003/16020/16035.
>   So "no RC" is DONE. 4a reduces to: emit `alloca` instead of `nova_rt_struct_alloc` (IRE make_struct ~14089)
>   when `dest ∈ ire_local_lists`, ptrtoint the alloca to the i64 handle; field_get/set already inttoptr it.
> - **THE NEW RISK = the MemTag.** Heap structs carry a `NovaMemTag` (kind=STRUCT + nslots) packed by
>   `nova_rt_struct_alloc`→`nova_heap_alloc` (runtime 449-456). `==`/hash/deep_copy/generic dispatch read that
>   tag to walk fields. A stack `alloca` has NO such tag → those ops read garbage before the alloca → CORRUPTION.
>   And those ops are NOT escape sites in the EA today (12030-12052 marks only send/spawn/field_set/index_set/
>   return), so a `local_set` struct CAN reach them. **Fix REQUIRED before 4a ships:** either (a) extend the EA
>   to mark a struct that flows to `==`/hash/deep_copy/any-typed-call as escaping (keeps it heap — shrinks the
>   stackable set to pure field-access structs, which covers dot/matmul/physics), or (b) emit a valid static
>   NovaMemTag header on the alloca (non-freeable RC) so tag-readers work. (a) is simpler + safer; do (a) first.
> - 4a (alloca + i64 handle via ptrtoint/inttoptr) removes heap malloc + RC but LLVM will NOT register-promote
>   (address taken). 4b (true SROA → registers) needs the local struct handle to stay an LLVM pointer/aggregate
>   (no ptrtoint), i.e. break uniform-i64 LOCALLY for proven-local structs — bigger, do after 4a measures.
> - Interprocedural caveat: marking a struct passed to a regular `call` as local inherits the SAME envelope as
>   today's RC-elision (a synchronous callee that reads fields is fine; one that persists the handle would be an
>   escape the per-function EA misses — unchanged from current behavior, but verify with the escape stress test).
> - MANDATORY new test: `==`/hash/print on a locally-constructed struct + a struct returned/sent/stored-in-list
>   MUST stay heap. Gate behind `NOVA_SROA=1` for the first bootstrap.

**Goal:** a struct that escape analysis proves NON-escaping is lowered to LLVM SSA values / an `alloca`
aggregate instead of `nova_rt_struct_alloc` + RC. No heap, no RC, registers → LLVM `mem2reg` promotes
`Point{x,y}` to two registers. This is COMPETITIVE_DOMINATION_PLAN Tier-1 #4 — the "C-level perf" asterisk-remover.

**Acceptance (falsifiable):** for a non-escaping `Point` used in a loop, `_probe.ll` shows **0**
`nova_rt_struct_alloc` and **0** RC inc/dec on that struct; matmul/physics microbench ≥ 1.0× C; regression 393/393.

**Mechanism:** Track-8 escape analysis already proves non-escape (`_perf_probe.ll`: `; ESCAPE … allocs=4
escape=0 local=4`). `ir_field_types` maps field→type. What's missing: nothing converts `make_struct`
(IRE ~`14089`, always `nova_rt_struct_alloc`) to an `alloca` (or pure SSA) for EA-proven-local structs.

**Hard dependency:** Stage 3 FIRST. Without raw fields, a stack struct is still `{i64,i64}` with residual
unbox and the SROA win collapses to mere malloc-elision (verified reasoning in the analysis).

**Exact sites:** IRE `make_struct` (`14089` struct_alloc) + `field_get`/`field_set` (`14177`/`14183`) — when the
struct register is EA-local, emit an entry-block `alloca {f0ty,f1ty,…}` (typed per Stage-3 field types) +
`getelementptr`/`store`/`load` on the alloca, and SUPPRESS the RC drop for it. `ire_local_lists`/
`ire_slot_escaped` already track locality for lists — extend the same machinery to structs.

**Soundness requirements:** (1) a false "non-escape" → use-after-return; only stack-alloc when EA is CERTAIN
(conservative). (2) a `ptrtoint`'d stack address must NEVER reach `deep_copy`/RC/channel-send — if the struct
can flow to any of those, it ESCAPES → heap. (3) start NARROW: all-scalar-field (`int`/`float`/`bool`),
≤4 fields, single-function-local, no address-taken. Gate behind `NOVA_SROA=1` for the first bootstrap, then
default-on once the regression + a dedicated escape stress test pass.

**Sub-tasks:** (a) struct-locality flag from EA → IRE; (b) alloca-aggregate emission for local structs;
(c) field get/set on alloca; (d) RC-drop suppression; (e) escape stress test (struct returned / sent / stored
in a list MUST stay heap); (f) bootstrap; (g) regression ×3 + microbench. **Effort: ~2-3 days. The big win.**

---

## ⛔ STAGE 5 — FALSIFIED 2026-06-12 (hand-validated; do NOT build as a standalone stage)

Hand-built the EXACT Stage-5 target IR for `dot(a,b)` over `type V3 {x,y,z: float}` (native-ABI clone
`define internal double @dot(ptr,ptr)`, GEP field reads, `ret double`, call site passing ptr) and measured
vs `clang -O2` (C=59ms, 30M-iter loop):
- i64-ABI (current): **1.20× C**
- native-ABI clone (Stage 5's mechanism): **1.28× C — WORSE** (opt-IR confirms the clone IS inlined: 0 calls,
  12 fmul/fadd in the loop — but it bloats without SROA).
- native call + pass alloca ptr directly (4b+5 combined): **1.15× C** — modest, NOT C-parity.

ROOT: the EA-local stack struct is `alloca [4 x i64]` (header at index 0, fields i64-typed at 1/2/3) and the
handle launders through an i64 slot (`ptrtoint`→store→load→`inttoptr`). BOTH defeat LLVM SROA regardless of
the call ABI, so the struct never reaches registers (C SROAs V3 to 3 xmm regs). Stage 5's design assumption
(native-ABI clone ⇒ ≥1.0× C) is therefore FALSE.

**Beating C needs a COORDINATED value-model overhaul, all three together:** (1) tagless raw-`double` layout for
EA-local structs (not `[4 x i64]`), (2) ptr-typed local struct handles (no ptrtoint/i64-slot laundering = the
old "4b"), (3) native-ABI calls (the old "5"). Partial steps have poor ROI. This is a multi-month
rearchitecture = COMPETITIVE_DOMINATION_PLAN scale, NOT a bounded day-4-5 stage. NOVA at ~1.0-1.2× C with ZERO
annotations + memory-safety is at the CEILING of the uniform-i64 value model; "match C" is delivered. Repro:
test_programs/dotbench{,_native,_combined}.ll, dotbench.c, _dotn.ps1.

---

## STAGE 5 (ORIGINAL PLAN — superseded by the falsification above) — Monomorphic native-ABI specialization

**Goal (slice, not the full multi-month version):** for a provably-monomorphic LEAF function with all-primitive
params (e.g. `dot(a: Point, b: Point) -> float`), emit a SECOND native-ABI clone (`@dot$Point$Point(ptr,ptr)
-> double`, register-passed, no boxing) and route matching call sites to it; keep the i64 body as the universal
fallback for closures/spawn/dyn-dispatch. No function coloring. This is the Julia model done AOT with NOVA's
whole-program view.

**Acceptance (falsifiable):** a monomorphic float-returning leaf fn called in a loop shows the call lowering
to the `$`-mangled native variant (no boxing at the boundary); the i64 fallback still exists and is used by a
deliberately-polymorphic call site; bootstrap reconverges (the HARD part — a dual-ABI emitter must stay
byte-deterministic); regression 393/393.

**Mechanism:** `fpt` (`ir_collect_param_types` ~`13290`) already records per-call-site param types and can
detect monomorphism; today it widens structs to `any` — extend it to TRACK the concrete struct type. Then a
new emission pass adds the specialized `define` and a call-site selection (arg types match the specialization →
call `$`-variant; else → i64 body).

**Why a SLICE, honestly:** the full version (return-type specialization, recursion, higher-order, inlining
integration) is 3-5 months; the dual-ABI bootstrap reconvergence is historically the hardest codegen change.
Day 4-5 delivers the narrow, high-value slice (leaf + primitive/struct params + direct monomorphic call sites)
and PROVES the path; broadening is post-push.

**Soundness requirements:** the specialized variant and the i64 fallback must be OBSERVABLY identical on every
shared call; selection must be conservative (specialize only when arg types provably match); never specialize a
value that can be captured by a closure/spawn as `any` without also keeping the fallback reachable.

**Sub-tasks:** (a) fpt tracks concrete struct types; (b) monomorphism + leaf detection; (c) `$`-mangling; (d)
specialized `define` emission (native param/return types, no box); (e) call-site selection; (f) keep i64
fallback; (g) dual-ABI bootstrap reconvergence (kill-on-timeout); (h) regression ×3 + a polymorphic-call test.
**Effort: ~2 days for the slice. Endgame for the full version.**

---

## 5-DAY SEQUENCING

| Day | Task | Beats | Gate |
|-----|------|-------|------|
| 1 | Stage 3 — raw float fields (dot → 0 unbox) | C/Rust struct math | bootstrap + reg ×3 + float subset |
| 2-3 | Stage 4 — SROA / stack-alloc small structs (dot → 0 heap) | C, Rust | bootstrap + reg ×3 + escape stress + microbench |
| 4-5 | Stage 5 — monomorphic native-ABI slice + beat-C microbench suite (dot/matmul/physics ≥1.0× C) | C++, Rust, Julia | dual-ABI bootstrap + reg ×3 + polymorphic test |

## THE GATE (every task, non-negotiable — from COMPETITIVE_DOMINATION_PLAN)
Edit → precheck (gen3→gen4_check compiles, IR shows the intended change) → gen4 smoke → **bootstrap reconverge
(gen5.ll==gen6.ll, kill-on-timeout)** → full parallel regression 393/393 ×3 → commit. Production-grade always.
Revert immediately on ANY soundness regression (the float suite + escape stress are the oracles). The NOVA way:
genius compiler, zero annotations, one principle (Representation Inference), beat everyone.
