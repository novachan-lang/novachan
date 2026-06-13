# NOVA — Beat Every Language at Its Prime (the Core-Domination Loop)

**Status:** ACTIVE roadmap, authored 2026-06-13 from a code-grounded audit. This is the work-list
for the autonomous loop: pick the top open item, implement the NOVA way, pass the verified gate
(edit → reconverge `gen5.ll==gen6.ll` → 403-test regression → commit; kill-on-timeout mandatory),
mark done, repeat. Goal: NOVA's CORE out-powers C/C++/Java/Python/Go/Rust/Erlang/Elixir/JS — then
frameworks. Principle: never copy the other language's mechanism; solve the underlying PROBLEM the
NOVA way (genius compiler, zero annotations, process isolation, typed channels, one i64 value model).

---

## Scorecard — where NOVA stands TODAY (verified against the real compiler/runtime)

| Language | Its prime | NOVA status | Remaining to dominate |
|---|---|---|---|
| **C** | raw scalar/float perf | float math **matches/beats C** (hardware intrinsics, sound, 1495bd3); scalar/int = native; non-escaping structs stack-alloc'd (4a); **struct-math-via-fn-call = 1.009× C (P1)**; **tensor elementwise SIMD already auto-vectorized; tensor_matmul now SIMD = 1.15× C (abe354b)** | construction-heavy loops ~3.8× (i64-handle ABI → Stage-5); SIMD on `[float]` **lists** (the staged P2 — tensors already done) |
| **C++** | templates, RAII, zero-cost | RAII=`defer`+RC; operators=traits; generics+inference; **no template/UB/45-min-compile complexity** | monomorphic native-ABI specialization (narrow perf) |
| **Rust** | safety w/o GC | process isolation = same safety (no data races/UAF/null), **zero annotations**, no borrow-checker fight | COW-on-send (cut deep-copy cost) — perf, not safety |
| **Go** | M:N concurrency, fast compile | M:N work-stealing scheduler; typed channels+select+spawn; **+supervisors/monitors Go lacks** | faster incremental compile; growable stacks |
| **Erlang/Elixir** | fault tolerance, millions of procs, distribution | supervisor **one_for_one/all/rest_for_one** (cfacc52), monitor, let-it-crash; green sched 10k/382ms; remote_* channels real; **remote_spawn + function-by-name registry done (51d7d76)** | node clustering/discovery (multi-node); growable stacks (millions); hot code swap |
| **Python** | simplicity, REPL | as readable, **zero annotations, 50-100× faster**; comprehensions; huge stdlib | REPL (OrcJIT) |
| **Java** | reflection, no-warmup JIT | reflection (field_names/types/type_name) done; **AOT > JIT (no warmup), no NPE (Option)** | — (ecosystem is not a language gap) |
| **JavaScript** | browser reach, async | green scheduler = async with **no colored functions**; typed channels > promises; **WASM m1+m2 done: NOVA f64+call AND static-string+print run in wasm32 in Node** (real codegen + linear memory + I/O, not the i32 interpreter) | WASM m3+: RC heap in linear memory (dynamic strings/lists, str()->print); then channels/DOM |

**Bottom line:** the core is already competitive-to-dominant on 6 of 9; the open frontiers are
**perf endgame (C struct-passing + SIMD), distribution+scale (Erlang), and WASM (JS browser).**

---

## The loop work-list (priority = impact ÷ risk, each behind the verified gate)

### Tier 1 — perf endgame (beat C fully) + scale (beat Erlang)

**[P1] ✅ DONE — "returns raw double" summary → extend unbox-removal to user fns (beat-C struct math).**
- *Problem:* a `-> float` user fn returns EITHER raw double bits (`dot` = a float `add`) OR a BOX
  (`c_re(z)=z[0]` over a boxed-float list → a generic `index_get`). `frt==float` does not distinguish
  them; the blanket version bitcast `c_re`'s box pointer as a double → 2.6e-311 (why bc6b21f scoped
  unbox-removal to builtins only).
- *NOVA way (sound, no coercion needed):* a `@raw@<fn>` summary in `frt` — set iff EVERY return value
  is float-typed AND defined by a raw-producer op (float-arith binop / const_float / float field_get /
  floatlist index_get / hardware-math builtin / call to another `@raw@` fn), never a slot_load or a
  generic/box-returning call. Mirrors the emitter's `ire_proven_float` exactly. `ir_infer_one` then
  types a call to a `@raw@` fn `float` → the emitter reads the result via bitcast, dropping the
  defensive `nova_rt_unbox`. `dot`→`@raw@` (win); `c_re`→not (keeps the defensive path; sound).
- *Built:* `ir_reg_is_raw_double` + `ir_returns_raw_double` (sibling of `ir_analyze_return_type`),
  a monotonic `@raw@` fixpoint after the frt fixpoint, and the `_rawfloat` gate in `ir_infer_one`.
- *Result (measured, -O2):* isolated struct-math-via-fn-call (field-mutate + `dot` per iter) =
  **NOVA 234ms vs C 232ms = 1.009× C** (was ~1.23×); IR confirms the call result is bitcast not
  unboxed; complexnum/math3d/nn/stats pass (no hang); **403/403; reconverged gen5.ll==gen6.ll**.
- *Note:* construction-heavy loops (reconstruct structs each iter) are still ~3.8× C — that is the
  separate per-iter-alloc + i64-handle ABI gap (floatlist-raw P2 / Stage-5 native-ABI), NOT P1.

**[P2] floatlist-raw + auto-vectorization (beat C on array math / SIMD). ⚠️ DEFERRED — value-model-overhaul-class, must be STAGED (do NOT rush in one iteration).**
- *Problem:* `intlist` is a raw `i64[]` C-array (fast); `floatlist` is BOXED → no SIMD. NOVA emits no
  vectorize hints (past 693×-unroll incident).
- *Why deferred (2026-06-13 audit):* the runtime invariant is **"a float in ANY collection is always
  BOXED"** — `nova_rt_unbox_elem` keeps floats boxed precisely so a list is valid as `any` everywhere
  (the slow generic path degrades to correct-but-slow, never corruption). A raw `double[]` backing
  BREAKS that invariant across **147 `->data[i]` element-read sites**, and there is **NO runtime
  element-kind tag today** (intlist needs none — a raw i64 is also a valid `any` int; a raw double is
  NOT a valid `any` float). So raw-f64 storage requires a runtime tag that EVERY generic reader
  consults (box-on-read for f64) — changing a load-bearing value-model invariant. Rushing it risks
  silent corruption that passes 403 but is a latent CVE. This is the SAME class as the int/float
  value-model fix that was explicitly staged A/B with the regression as oracle.
- *NOVA way (sound STAGED design for the dedicated effort):*
  - *Stage A:* add an element-kind tag to `NovaList` (append `tag@+24` AFTER `data@0/size@+8/cap@+16`
    so `nova_mem_find_tag`'s structural offset reads are unchanged); default tag = current behavior;
    NO behavior change. Reconverge + 403 (proves the field is inert).
  - *Stage B:* floatlist creation sets tag=RAW_F64 + a `double[]` backing; the SINGLE generic-read
    choke-points (`nova_rt_index_get`, and the value-extraction used by ops) **box-on-read** when the
    list is RAW_F64 (so all 147 sites stay correct — slow generic path boxes, never corrupts). Movers
    (slice/reverse/concat/copy) just relocate bits + propagate the tag. Append stores raw double for a
    float, else PROMOTES the list to boxed. The hard part is the per-site audit: every site that
    *interprets* (not just moves) an element must respect the tag.
  - *Stage C:* fast typed path — the emitter's floatlist `index_get` / `for`-over-floatlist reads raw
    `double` directly (no box) with `align`/`!noalias`/`!tbaa` so LLVM's loop vectorizer auto-fires
    (NEVER add unroll.enable/vectorize.enable — the 693× incident). asm shows `addpd`/`mulpd`.
- *Verify (per stage):* reconverge `gen5.ll==gen6.ll` + 403 each stage; final = a float-array sum/map
  loop beats serial C with no unroll bloat. Effort L (multi-iteration). Soundness-sensitive.

**[P3] Growable/segmented fiber stacks (beat Erlang/Go on process scale).**
- *Problem:* fixed 32KB fiber stacks → ~30k tasks/GB (BEAM ~300 B/proc). "Millions of processes" not
  yet real.
- *NOVA way:* start small (4-8KB), grow on demand via guard-page fault + segment/realloc, transparent
  to the developer (`spawn` just scales).
- *Where:* fiber creation + stack alloc in nova_runtime.c (Win CreateFiber stack size / POSIX
  ucontext+asm); scheduler resume; must stay safe under M:N migration.
- *Verify:* a 1M-spawn test fits in far less RAM; green tests still pass; 403. Effort L (Win fiber
  stack-size constraints may force the POSIX-style custom-stack path even on Win). Soundness-sensitive.

### Tier 2 — distribution (beat Erlang) + comptime (beat Zig/C)

**[P4] ✅ DONE (51d7d76) — `remote_spawn` + function-by-name registry (beat Erlang distribution, core).**
- *Was:* remote_* channels (TCP+JSON, green-aware) REAL; `remote_spawn` a type-stub (no function-by-name
  lookup).
- *NOVA way (shipped):* a function registry (name→fn ptr+arity) built once at @main init, single-
  threaded before the scheduler → IMMUTABLE after → lock-free reads. `nova_rt_call_by_name(name, args)`
  resolves + unboxes args + applies via an all-i64 arity switch (0..8); names work as literal (raw .str)
  or JSON-decoded fat string (strcmp). `remote_spawn(conn, name, args)` sends `[name, args]` over the
  existing transport (JSON = deep-copy → process isolation across the wire), returns the reply channel;
  the peer's dispatch loop is plain NOVA (`call_by_name(req[0], req[1])`). Registration is gated on
  `ire_uses_byname` so non-distributed programs (incl. the compiler) pay nothing / no needless address-
  taking.
- *Verified:* call_by_name_test (registry + dynamic apply 0/1/2) + remote_spawn_test (localhost round-
  trip: requester → remote_spawn → server resolves `add` by name → 42). 405/405; reconverged 2B051F29.
- *Remaining for full Erlang-class distribution (future):* multi-node clustering / discovery /
  reconnection-heartbeat; arity > 8; float-arg ABI nuance (args unboxed → raw double bits, fine for
  raw-float params).

**[P5] ✅ DONE (733a707) — const-aggregate baking (beat the Zig/C comptime gap NOVA was losing).**
- *Shipped:* a top-level `const` list literal of pure literals is now built ONCE in the `@nova_main`
  prologue and cached (runtime g_const_cache + `nova_rt_const_set`/`nova_rt_const_get` [readonly]),
  instead of being re-lowered/rebuilt at every use (and per loop iteration). Reused P4's gated-prologue
  + runtime-cache pattern. Shared immutable handle is sound (M:N RC is atomic, like a channel; permanent
  cache ref). `ir_const_bakeable` gates on non-empty list-of-literals (no inter-const dependency).
- *Verified:* const_bake_test (TABLE used 5×+loop → built ONCE in IR) + const_test unchanged; 406/406;
  reconverged 520326D8. Follow-ups: dict-literal consts, scalar-const-ref elements, typed const_get
  result (currently generic index_get — correct, slightly slower).

**[P5-orig] (superseded by the above) Const-eval expansion notes. [SCOPED 2026-06-13.]**
- *Problem (confirmed in IR):* scalar consts (`const TAU = PI*2`) already fold via inline-expr +
  LLVM. But a `const` AGGREGATE is stored as an expr (`b.ir_consts[name]=expr`) and **re-lowered at
  EVERY use** (ir_lower_expr at ~L7027) — so `const TABLE=[1,4,9,16,25]` is REBUILT from scratch on
  every reference (verified: use1 builds it, use2 rebuilds it; in a hot loop it rebuilds per
  iteration). Where C/Zig/Rust bake the table into `.rodata`, NOVA reconstructs it every time.
- *NOVA way:* bake a const aggregate ONCE. NOVA has **no cross-function value globals today** (consts
  use inline-expr precisely because there's no global slot), so this needs NEW infra:
  (1) a module global `@nova.const.N = internal global i64 0`; (2) build each bakeable const once in
  the `@nova_main` prologue (single-threaded, before any `spawn` → race-free, no lazy-init race);
  (3) a `global_load` IR op (type = the const's type, pure) so use-sites load the global instead of
  re-lowering. Restrict v1 to consts whose elements are non-aggregate const exprs (avoids
  aggregate-of-aggregate init ordering).
- *Where:* const-decl collection (~L15534) flags bakeable aggregates; ir_lower_expr const-ident
  resolution (~L7027) emits `global_load`; new IR op threaded through infer/fold/optimizer/emitter;
  main-prologue init + global decls in the emitter. Effort M, broad-but-shallow surface.
- *Verify:* a const table built once (IR shows ONE list_create across all uses) + a hot loop over it
  doesn't rebuild; 403; reconverge. NOTE: lower-impact than the reach/scale items — Zig-comptime is
  niche and NOVA already has scalar const folding.

### Tier 3 — reach (beat JS browser, Python REPL) — biggest, last

**[P6] WASM target — real wasm32 (beat JS / browser). [Milestones 1+2 ✅ DONE.]**
- *Milestone 1 (DONE 8821467):* a real **f64 + function-call** NOVA program runs in Node's WebAssembly
  (compute(1.5,2.5)=5.25). Pure SSA, 1 import (nova_rt_unbox).
- *Milestone 2 (DONE 4264586):* a NOVA program with a **static string + print** runs in wasm32
  ("hello from wasm") — adds the linear-memory + I/O path. print(literal) → load the data-section
  string ptr → nova_rt_print_str(ptr); the Node shim reads the null-terminated bytes from
  exports.memory and logs them. 1 import. Both verified by _wasm_milestone.ps1.
- *Milestone 3+ (next):* a minimal RC heap in wasm linear memory (malloc + the string/list element
  ops) so **dynamic** strings/lists + str(x)→print work — a larger runtime port: #ifdef the OS-only
  parts (sockets/threads/fibers stay native; stub/omit under wasm) and provide malloc (dlmalloc or a
  bump allocator) + an imported write. Then `nova build --target wasm` tooling, then channels→
  SharedArrayBuffer+Atomics, threads→Web Workers, DOM. Effort XL — keep decomposing.

**[P7] REPL via OrcJIT (beat Python adoption).**
- *NOVA way:* `nova repl` JIT-compiles each line via LLVM OrcJIT (NOT a 2nd interpreter); state
  (bindings/types/fns) persists by re-declaring priors as externals each line.
- *First milestone:* evaluate arithmetic + `let` + `print` across lines. Effort L.

### Tier 4 — nice-to-have (diminishing returns)
COW-on-send (Rust zero-copy); monomorphic native-ABI struct passing (the deep Stage-5; narrow);
in-flight hot code swap (blue-green covers 99%); explicit SIMD intrinsics (auto-vec covers 90%).

---

## Hard-won soundness rules (do NOT relearn the hard way)
- **`ire_reg_types` float-marking is UNRELIABLE for gating** (flat, control-flow-insensitive; slot_load
  propagates it). Use `ire_proven_float` (float-PRODUCING SSA sites only) to gate any raw-double bitcast.
- **`frt==float` does NOT imply the fn returns raw double** — a `-> float` fn can return a raw int
  (annotation lie). Need float-return coercion (P1) before trusting it.
- **int/string discrimination has no sound content heuristic** — value identity (header/module) only.
- **Bootstrap convergence = `gen5.ll==gen6.ll` (.ll SHA, NEVER exe SHA)**; clang -O2 link is
  non-deterministic on Windows.
- **`env NOVA_NO_CACHE=1`** (bash prefix, not `$env:`); kill-on-timeout MANDATORY for every binary.

## After the core dominates → frameworks
Only once the core beats everyone (the table above all green): full-stack identity — backend (HTTP/
router/DB/auth), frontend (via WASM/DOM), AI (tensor/inference), deploy — all in NOVA. The core's
power (perf + concurrency + safety + reach) is what makes the frameworks trivial. Core first.
