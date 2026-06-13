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
| **C** | raw scalar/float perf | float math **matches/beats C** (hardware intrinsics, sound, 1495bd3); scalar/int = native; non-escaping structs stack-alloc'd (4a); **struct-math-via-fn-call = 1.009× C (parity, P1 done)** | construction-heavy loops ~3.8× (per-iter struct alloc + i64-handle ABI → Stage-5/floatlist-raw); SIMD on float arrays |
| **C++** | templates, RAII, zero-cost | RAII=`defer`+RC; operators=traits; generics+inference; **no template/UB/45-min-compile complexity** | monomorphic native-ABI specialization (narrow perf) |
| **Rust** | safety w/o GC | process isolation = same safety (no data races/UAF/null), **zero annotations**, no borrow-checker fight | COW-on-send (cut deep-copy cost) — perf, not safety |
| **Go** | M:N concurrency, fast compile | M:N work-stealing scheduler; typed channels+select+spawn; **+supervisors/monitors Go lacks** | faster incremental compile; growable stacks |
| **Erlang/Elixir** | fault tolerance, millions of procs, distribution | supervisor **one_for_one/all/rest_for_one** (cfacc52), monitor, let-it-crash; green sched 10k/382ms; remote_* channels real | distribution (`remote_spawn`+clustering); growable stacks (millions); hot code swap |
| **Python** | simplicity, REPL | as readable, **zero annotations, 50-100× faster**; comprehensions; huge stdlib | REPL (OrcJIT) |
| **Java** | reflection, no-warmup JIT | reflection (field_names/types/type_name) done; **AOT > JIT (no warmup), no NPE (Option)** | — (ecosystem is not a language gap) |
| **JavaScript** | browser reach, async | green scheduler = async with **no colored functions**; typed channels > promises | **WASM target** (real f64/calls/memory runtime) |

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

**[P2] floatlist-raw + auto-vectorization (beat C on array math / SIMD).**
- *Problem:* `intlist` is a raw `i64[]` C-array (fast); `floatlist` is BOXED → no SIMD. NOVA emits no
  vectorize hints (past 693×-unroll incident).
- *NOVA way:* a raw `double[]` backing for homogeneous float lists (NovaList element-kind tag), + safe
  `align`/`!noalias`/`!tbaa` metadata on typed-array loads so LLVM's loop vectorizer fires WITHOUT
  manual unroll hints. The compiler auto-vectorizes loops the dev never annotated.
- *Where:* NovaList struct + element-kind tag (runtime); floatlist creation/index_get/append; the
  for-over-list lowering; array load emission.
- *Verify:* a float-array sum/map loop vectorizes (asm shows `addpd`/`mulpd`) + beats serial C; no
  unroll bloat; 403; reconverge. Effort L.

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

**[P4] `remote_spawn` + node clustering (beat Erlang distribution).**
- *Problem:* remote_* channels (TCP+JSON, green-aware) are REAL; `remote_spawn` is a type-stub
  (blocked by no function-by-name lookup).
- *NOVA way:* a function registry (name→fn ptr) so a closure can be sent + resolved remotely;
  `remote_spawn(node, fn, args) -> channel` over the existing transport; node discovery + reconnection/
  heartbeat; process isolation holds across the wire (deep-copied args, channels shared).
- *Where:* remote_* runtime fns; make_closure/trampoline; spawn lowering; a registered-fn table.
- *Verify:* a 2-node round-trip spawning a remote task; remote_* tests still pass; 403. Effort L.

**[P5] Const-eval expansion (beat Zig/C comptime).**
- *Problem:* const-eval is integer-only, intra-block. LLVM already folds simple const arithmetic, so
  the NOVA win is compile-time evaluation of things LLVM can't: build a `const` lookup table by
  running a NOVA fn at compile time.
- *NOVA way:* a small AST interpreter over `const` blocks (literals/arithmetic/const-fn-calls) →
  bake the result as a literal/array. NOT C++ constexpr complexity — "if it's all-const, evaluate now."
- *Where:* `ti_const_eval` (~10641) + a const-block lowering that emits the computed literal.
- *Verify:* a const lookup table has zero runtime construction cost; 403. Effort M.

### Tier 3 — reach (beat JS browser, Python REPL) — biggest, last

**[P6] WASM target — real wasm32 (beat JS / browser).**
- *Problem:* WASM backend emits correct IR/datalayout but the runtime is an i32-only interpreter
  (no calls/linear-memory/f64).
- *NOVA way:* NOVA → LLVM IR → wasm32 (LLVM backend) + a WASM runtime shim (RC heap in linear memory,
  channels→SharedArrayBuffer+Atomics, file IO→WASI, threads→Web Workers). `nova build --target wasm`.
- *First milestone:* run a real **f64 + function-call** NOVA program in wasmtime/browser. Effort XL —
  decompose into milestones; do NOT attempt whole thing at once.

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
