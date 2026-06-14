# NOVA — Beat Every Language at Its Prime (the Core-Domination Loop)

**Status:** ACTIVE roadmap, authored 2026-06-13 from a code-grounded audit. This is the work-list
for the autonomous loop: pick the top open item, implement the NOVA way, pass the verified gate
(edit → reconverge `gen5.ll==gen6.ll` → 403-test regression → commit; kill-on-timeout mandatory),
mark done, repeat. Goal: NOVA's CORE out-powers C/C++/Java/Python/Go/Rust/Erlang/Elixir/JS — then
frameworks. Principle: never copy the other language's mechanism; solve the underlying PROBLEM the
NOVA way (genius compiler, zero annotations, process isolation, typed channels, one i64 value model).

---

## ★ VERIFIED MID-TIER QUEUE (iter-35 grounded re-audit, 2026-06-14) — ship these next

A 6-language re-audit (each gap grep-verified absent against the real compiler/runtime) found the
mid-tier is NOT exhausted. These are additive, low-risk (reconverge-safe — the compiler doesn't use
them), shippable in ~1 iteration each via the standard builtin pattern (reg + LLVM declare +
name→runtime map + runtime fn + test + reconverge):

1. ~~`select_timeout(channels..., timeout_ms)`~~ ✅ DONE (b9aed16, reconverged 317C63E8) — variadic
   `select_timeout(ch.., timeout_ms)` -> `[index, value]` or `[-1, 0]` on timeout; green-task safe;
   closes Go `select + time.After` AND Erlang `receive...after`.
2. ~~list mutation `pop` / `insert` / `remove`~~ ✅ DONE (0dd080b, reconverged 881C52BD) — fn + UFCS;
   pop transfers ownership (no double-free), remove rc_dec's, insert rc_inc's; RC-stress-tested.
3. ~~`get(dict, key, default)`~~ ✅ DONE (0dd080b) — value or default; fn + UFCS.
4. ~~`try_recv(ch)` / `try_send(ch, v)`~~ ✅ DONE (d776a8b, reconverged 217A15CE) — non-blocking;
   try_recv -> `[got, value]` (reuses the `channel_try_recv` static); try_send -> 1 if sent, 0 if
   full/closed (deep-copies; frees on reject). fn + UFCS. 200k struct deep-copy-and-free stress clean.
   Completes Go's channel ergonomics (select/select_timeout/try_recv/try_send).
5. ~~char-class builtins~~ ✅ DONE (5ad65d3, reconverged FA9B6979) — all SIX shipped
   (`is_space`/`is_upper`/`is_lower`/`is_digit`/`is_alpha`/`is_alnum`), fn + UFCS. The shadowing
   question (the compiler defines its own `is_digit`/`is_alpha`/`is_alnum`/`is_ws`) was settled by
   READING call-lowering (~L7438-7441): `rt_name` defaults to `fn_name`, only falls to
   `resolve_runtime_fn` when the name is NOT a user fn → the compiler's local fns win at its own call
   sites (.ll unchanged), user code with no such fn gets the builtin. Inference can't conflict (dup
   check uses only `seen_fns`; `ti_define` overwrites). PROVEN by byte-identical reconverge.

QUEUE STATUS: ★ 5/5 DONE — the iter-35 verified mid-tier queue is EXHAUSTED.

---

## ★★ FRESH GROUNDED RE-AUDIT (iter-39 post, 2026-06-14) — 8 lenses + adversarial refutation

A 15-agent workflow (8 language lenses grep-verifying gaps against the real compiler+runtime →
synthesis → 6 adversarial refuters). Verdict: the additive well is NOT quite dry — there is ONE
more HIGH-leverage additive batch, and uniquely it fixes **correctness bugs**, not ergonomics.
The refuters REFUTED one stale gap (select_try/default — already ships as `select_timeout(ch.., 0)`),
which is the trap working. Confirmed survivors:

**C-correctness batch, split into two clean ships (soundness-first):**
1. ★ ~~Unsigned / logical ops~~ ✅ DONE (f082232, reconverged A55FDCC5) — `>>` lowered to `ashr`
   (arithmetic), so `(1<<63) >> 1` sign-extended to `0xC000…` instead of the logical `0x4000…` →
   silently WRONG crypto/hash/PRNG. Shipped `ushr/ult/ugt/ule/uge/udiv/urem` as runtime-fn builtins
   (fn + UFCS), NOT the `>>>` lexer token (strictly safer, same fix). All total/no-UB: ushr masks &63,
   udiv/urem guard ÷0, compares treat i64 as u64. uint_ops_test PROVES the fix (logical vs ashr
   contrast). 419/419, reconverged byte-identical. The `>>>` infix sugar is deferred ergonomics.
2. ~~Typed-width raw memory~~ ✅ DONE (8b25dd8, reconverged 897AE00F) — `ptr_read/write_{u8,i8,u16,
   i16,u32,i32,u64,f32,f64}` + `offheap_get_f64/set_f64` (17 builtins, fn + UFCS). memcpy-based
   (unaligned + strict-aliasing safe), null-guarded, offheap bounds-checked; float ABI = i64-bits via
   f2i/nova_float_arg matching nova_rt_sqrt. ptr_width_test PROVES native-width access (adjacent-u32
   boundary, no 8-byte over-read) + sign-extension + unaligned + f64/f32 round-trip. 420/420.

★ BOTH HIGH-leverage C-correctness batches DONE. Remaining additive = LOW-MED paper-cuts only.

**Paper-cut sweep (LOW-MED, follow-up additive pass, each has a workaround):**
- ~~splitlines/partition/rpartition/rsplit~~ ✅ DONE (3878d74, reconverged 7AF1AF49) — RC-correct via
  a shared nova_str_slice helper mirroring split's element alloc; fn + UFCS; 421/421.
- DEFERRED (low-value, revisit opportunistically): keyed min/max/sorted(key,reverse); timer/ticker
  channels + set_timeout/interval; ws_connect client; struct-field defaults; slice patterns.

★ STRATEGIC PIVOT (iter-43+): the high-value additive correctness work is DONE and the rest of the
additive tail is low-value with workarounds. Turning to the DEEP FRONTIER — the real path to "core
complete / first-user full-stack identity works." Starting with the audit's #1: JSON-native value
model, DESIGNED + adversarially stress-tested via a workflow BEFORE any compiler surgery.

**THEN additive is GENUINELY exhausted → DEEP FRONTIER (audit-ranked, all HIGH):**
1. **JSON-native tagged value model** — #1 deep pick. A first-class value mixing null/bool/number/
   string/array/object. Unlocks the web-backend identity + WASM/DOM frontend + remote-package reach
   (one root cause). firstStep: NaN-boxed (or 3-bit-tagged) `Any` behind a flag, routed ONLY through
   json_decode/encode + literal container-stores, with a json_oracle_test (bool/null/mixed round-trip).
2. **Sized integer types** (u8/u16/u32/i32/u64 with real width+wrap) — the DEEP version of iter-40's
   additive ops. firstStep: `nt_int_w(bits)` refining nt_int (default 64 = no change), lower only
   explicit-width sites. Bit-exact crypto + faithful C-struct layout.
3. **WASM host/DOM interop** (js_import/extern-js bridge + callback table) — the FRONTEND half.
4. **Per-process mailbox + selective receive + addressable PIDs** — Erlang's prime (gen_server).
5. **REPL via OrcJIT** (persisted top-level state + incremental type env) — Python's #1 adoption surface.
6. context-style transitive cancellation + panic recover/try (MED) — do it NOVA-way (scope-based).

The recurring root gap STILL underlies the deep tier: codegen has only a deferred-types heuristic
(`ir_expr_struct_type`), not the inferer's real types — gates beat-C Stage-5 native-ABI HOF
specialization (PERFORMANCE_SPECIALIZATION.md) + collection serialization + total-RC. iter-33 shipped
the first safe slice. Deep-perf frontier: beat-C Stage-5, struct-SROA ABI, total-RC (RC_COMPLETENESS.md).

---

EXCLUDED (high-risk): the redundant `nova_rt_unbox` in mixed int/float `+=` hot loops — the prior
Stage-2 fix was REVERTED for nn/stats parallel-load failures; needs per-block type tracking (deep).
DEEP frontier unchanged (beat-C Stage-5 HOF, struct-SROA ABI, total-RC, WASM, REPL, stackless).

---

## Scorecard — where NOVA stands TODAY (verified against the real compiler/runtime)

| Language | Its prime | NOVA status | Remaining to dominate |
|---|---|---|---|
| **C** | raw scalar/float perf | float math **matches/beats C** (intrinsics, 1495bd3); scalar/int native; non-escaping structs stack-alloc'd (4a); **struct-math-via-fn-call 1.009× C (P1)**; tensor elementwise SIMD auto-vectorized; **tensor_matmul SIMD + AUTO-PARALLEL + CACHE-BLOCKED (2D i/j tiling) = BEATS C 1.45× @512² / 1.72× @1024² (f4ff85c, 8 cores, zero user effort, bit-identical)** | construction-heavy loops ~3.8× (i64-handle ABI → Stage-5); SIMD on `[float]` **lists** (staged P2); larger matmul scaling (k-panel packing / per-platform tile tuning) |
| **C++** | templates, RAII, zero-cost | RAII=`defer`+RC; operators=traits; generics+inference; **no template/UB/45-min-compile complexity** | monomorphic native-ABI specialization (narrow perf) |
| **Rust** | safety w/o GC | process isolation = same safety (no data races/UAF/null), **zero annotations**, no borrow-checker fight | COW-on-send (cut deep-copy cost) — perf, not safety |
| **Go** | M:N concurrency, fast compile | M:N work-stealing scheduler; typed channels+select+spawn; **+supervisors/monitors Go lacks**; **small-commit auto-grow fiber stacks (86b8b4d): contained overflow + 2.37× task density** | faster incremental compile |
| **Erlang/Elixir** | fault tolerance, millions of procs, distribution | supervisor **one_for_one/all/rest_for_one** (cfacc52), monitor, let-it-crash; green sched 10k/382ms; remote_* channels real; **remote_spawn + function-by-name registry done (51d7d76)**; **fiber overflow = contained crash (fb73d6e) + 52.6k parked tasks/GB (86b8b4d)**; **multi-node cluster membership: G-Set CRDT, seed-join + gossip, 3 nodes converge (3367cfa)**; **cluster failure-detection: gossip-as-heartbeat + last-seen, kill-one-detect-down 4/4, 0 false-positives (c7c6edc)**; **cluster graceful leave: cluster_leave broadcasts departure → peers mark down immediately, crash-control-verified (f320c9d)**; **cluster_spawn: distributed task placement — run a fn on a LIVE peer via the fn registry, no-peer/dead-peer return gracefully (bb10f51)**; **cluster_pmap: distributed scatter-gather — round-robin across live peers, concurrent, ordered, partial-failure-tolerant + FIXED a netpoller select()-missing-exceptfds hang (refused connect parked forever on Windows in ALL distributed code) (7d9ec1c)**; **carrier-safe http_get + a real green HTTP server stack (4d8a964/e87170e)** | phi-accrual/suspicion detector (incr 6); cluster_spawn/pmap recv-timeout (hung-but-alive peer); stackless coroutines for true millions (~300 B/proc); hot code swap |
| **Python** | simplicity, REPL | as readable, **zero annotations, 50-100× faster**; comprehensions; huge stdlib | REPL (OrcJIT) |
| **Java** | reflection, no-warmup JIT | reflection (field_names/types/type_name) done; **AOT > JIT (no warmup), no NPE (Option)** | — (ecosystem is not a language gap) |
| **JavaScript** | browser reach, async | green scheduler = async with **no colored functions**; typed channels > promises; WASM m1–m5 (f64/string/list/float programs run in wasm32, output byte-identical to native, reusable runtime); **`nova wasm <file>` is now a FIRST-CLASS CLI command (c93fbfa)**; **m6 (08794a5): dicts + structs run in wasm32 byte-identical to native (struct_alloc + full dict ops via FNV-1a matching native + index_get dict-dispatch) — real dict/struct/word-count programs run in the browser** | m7 = the TAGGED C-runtime-to-wasm path (eliminates the untagged JS-runtime int/pointer ambiguity for medium ints through polymorphic ops — the documented m6 boundary); channels→SharedArrayBuffer; DOM bindings |

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

**[P3] Growable fiber stacks (beat Erlang/Go on scale). Stage 0 DONE (fb73d6e) + Stage 1 DONE (86b8b4d).**
- *Problem:* fibers committed a full 32KB up front → ~22k parked tasks/GB of commit (BEAM ~300 B/proc).
  "Millions of processes" capped by commit charge.
- *Iter-13 workflow finding (num_clean=0, severity major):* the obvious win (Win CreateFiberEx
  small-commit/large-reserve → ~4× more tasks/GB committed) was NOT soundly landable because the overflow
  backstop was BROKEN: the Win VEH did `longjmp` (UB), POSIX had no SIGSEGV handler, and the deep_copy
  depth guard was mis-sized (10000 >> the ~150-300 a 32KB stack holds → a deep channel-send OVERFLOWED).
- ✅ **Stage 0 DONE — iter 16 (fb73d6e), overflow safety SOUND on Windows:** Win VEH neutralized to a
  no-op `CONTINUE_SEARCH`; real recovery is `__try/__except(EXCEPTION_STACK_OVERFLOW)` around the user-fn
  call in `nova_fiber_entry` + `_resetstkoflw` (empirically verified to recover from a real 32KB overflow
  and to unwind through NOVA `uwtable` frames; software longjmp inside `__try` still lands at setjmp). The
  deep_copy guard is now CONTEXT-AWARE — 64 on a fiber / 10000 on the main OS stack, by FIBER IDENTITY
  (`nova_current_fiber != carrier`, immune to `nova_rt_stack_set_max()` which the adversary showed breaks
  a `stack_max` heuristic) — and PANICS (contained) instead of the old share-on-overflow (an isolation
  hole). VEH install made atomic. Both vectors are now clean contained crashes (carrier survives). Guard:
  `overflow_recovery_test` (a recursion-overflow task + a deep-copy-overflow task both contained while 5
  workers complete; exit 0). 408/408, reconverged 24CE520B.
  - **Still deferred (own iteration):** POSIX `sigaltstack`+SIGSEGV recovery — cannot be runtime-verified
    on the Windows build and needs the adversary's fixes (cache page size out of the handler; widen the
    guard-fault range for large stack frames; atomic install; macOS SIGBUS). POSIX overflow stays defined
    process-death until then. Iterative (unbounded-depth) `nova_deep_copy_rec` is a separate hardening.
- ✅ **Stage 1 DONE — iter 17 (86b8b4d), the density win:** `CreateFiber(32768)` → `CreateFiberEx(4096
  commit, 0 reserve, ...)`. KEY: `CreateFiber`'s arg was the COMMIT (reserve defaulted to the PE header,
  ~16MB) — so the iter-13 adversary was right that an explicit small reserve REGRESSES the cap. Passing
  reserve=`0` (PE default) keeps the SAME ~16MB usable stack (verified == `CreateFiber(32768)`; an explicit
  32768 reserve gave only ~765KB and overflowed the self-hosted compiler in bootstrap pass 2 — caught + fixed)
  while the 4KB commit + Windows auto-grow means a fiber commits only what it touches. The iter-16 SEH backstop
  makes the small commit safe (overflow still faults at the reserve → `__except` contains it; verified). MEASURED:
  commit/parked-task **48.5KB → 20.4KB = 2.37×** (22k → **52.6k parked tasks/GB** of commit charge). green_scale
  10k N=1 wall-time unchanged (+0.3%, noise — auto-grow soft faults are free). POSIX already demand-zero (mmap)
  → Windows-only change. 408/408, reconverged 24CE520B. BEAM's 300 B/proc needs stackless coroutines — a
  separate, much larger effort (the remaining gap to true millions).
- *Verify:* induce a green-task stack overflow → clean recovery (DONE); green tests + green_scale still
  pass (DONE); 408; for Stage 1, a commit-charge measurement (spawn N tasks, read PrivateMemorySize)
  shows the reduction. Effort L, soundness-CRITICAL.

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
- *Multi-node clustering SHIPPED (pure NOVA over remote_*):* G-Set CRDT membership + seed-join/gossip
  convergence (3367cfa); failure detection = gossip-as-heartbeat + last-seen + cluster_alive/status,
  kill-one-detect-down 4/4 with 0 false-positives (c7c6edc); graceful leave = cluster_leave broadcasts
  departure → peers mark down immediately, crash-control-verified that the verdict is the broadcast not a
  timeout coincidence (f320c9d); cluster_spawn = distributed task placement — pick a LIVE member from
  cluster_alive, send {"type":"spawn","fn","args"}, peer resolves via the fn registry (call_by_name) and
  replies; no-live-peer + dead-peer (connect-fail / socket-EOF) return a graceful error, never block
  (bb10f51). cluster_pmap = distributed scatter-gather: round-robin a batch over the live peers, run
  concurrently (each spawn its own green task), gather IN ORDER, per-task ok/err so a dead peer errors
  only its slot (7d9ec1c). Cluster now does WORK, not just membership.
- *Runtime soundness fix (7d9ec1c):* the green netpoller's select() passed NULL exceptfds → a
  remote_connect to a refused/dead peer parked FOREVER on Windows (failed non-blocking connect is
  signaled only in exceptfds there) → a silent hang in ALL distributed code against an unreachable
  peer. Now watches POLL_WRITE waiters in exceptfds (+ the non-green nova_remote_io fallback). Verified
  by a 3-lens adversarial review (0 blockers) + a kill-a-worker-mid-batch pmap test (the permanent guard).
- *Remaining for full Erlang-class distribution (future):* phi-accrual/suspicion detector (incr 6);
  cluster_spawn/pmap recv-timeout for a hung-but-alive peer — EXPLORED + REVERTED in iter 28: a pure-NOVA
  timeout needs a per-call channel to race recv vs timer, but channels are never RC-freed (see KNOWN
  RUNTIME ISSUE below), so it would leak a channel per RPC → OOM; the sound paths are (a) fix channel-free
  first, or (b) a runtime recv-deadline (park-with-deadline, no per-call channel). connect to an
  unreachable/firewalled host still waits the OS SYN timeout; arity > 8; float-arg ABI nuance.
- *★ KNOWN RUNTIME ISSUE (chars. iter 29 — see NOVA_DESIGN/RC_COMPLETENESS.md): NOVA's RC is a PARTIAL
  count.* It tracks container membership (rc_inc only in list_append/dict_set/deep_copy-share/list_set), NOT
  total references — slot_store never rc_dec's the old value, so reassigned/loop-local heap values of EVERY
  type leak ~1 struct/iter (probe: list/dict/chan all 2000/2001 over 2000 iters, identical with
  NOVA_T8_DROP=1). NOT channel-specific (iter-28's framing corrected). A reassignment-drop is UNSAFE (the
  for-in BORROWED element via index_get has no rc_inc → dropping the loop-var overwrite = UAF) and not
  separable from the W5b bootstrap-self-compile gap. The sound fix = total reference counting (Swift/CPython
  ARC), staged S0-S4 in RC_COMPLETENESS.md (S0 oracle leak_baseline_test DONE). Tolerable for short-lived
  processes; the real debt is long-running servers. The 2 channel-destructor fixes (rc_dec buffered items +
  pthread_cond_destroy not_full) land with S3.

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
- *Milestone 3 (DONE e29b7aa):* a real NOVA program runs in wasm32 — a **while loop** summing 1..10=55
  (real control flow + int arithmetic in wasm) + a **DYNAMIC** string str(s) printed → "55". The key is
  the **runtime-call bridge**: print(str(s)) → int_to_str → print_str (the only 2 imports). Rather than
  port the C runtime to linear memory, runtime services are **JS-hosted** (host imports manage strings
  via opaque i64 handles) — the pragmatic browser architecture (NOVA logic in wasm, runtime+DOM in JS
  glue). So NOVA programs that USE THE RUNTIME now run in wasm given host-provided nova_rt_* services.
- *Milestone 4 (DONE 9f006cc):* a real **list-using** NOVA program — Sieve of Eratosthenes, n=1000 →
  168 primes — runs in wasm32 (output == native). Lists need a real heap in linear memory (index
  get/set are inlined wasm reads/writes), so this added a **JS-managed linear-memory runtime**
  (_wasm_sieve_run.cjs): a bump allocator over `instance.exports.memory` + the 5 import fns
  (list_create, list_append_no_rc with array growth, unbox_elem, int_to_str, print_str), matching
  NOVA's wasm32 NovaList layout (data@0 i32 / size@8 / cap@16, i64 elems). Workflow-designed +
  adversarially verified (severity minor). n=1000 is past clang's unroll threshold → genuine
  in-wasm computation + ~7 list growths. All 4 milestones in _wasm_milestone.ps1.
- *Milestone 5 (DONE a54a87d):* a REUSABLE JS-managed linear-memory runtime (_wasm_runtime.cjs) so
  MULTIPLE real programs run in wasm32 — a LIST sieve, a STRING program (reverse + concat-in-loop +
  len), and a FLOAT program (harmonic series + average) — each cross-checked BYTE-IDENTICAL to native.
  Bump heap @ __heap_base (--export=__heap_base; fixes m4's hardcoded-offset fragility); covers
  list/str/float/print builtins; float-to-str = %.15g matching nova_runtime.c. _wasm_load.cjs generic
  loader; _wasm_milestone.ps1 verifies all 6. Workflow-designed + adversary-verified (severity minor:
  len/index string-only, bump never frees — demo-grade limits).
- *Milestone 5.5 (DONE c93fbfa):* `nova wasm <file>` is a FIRST-CLASS CLI subcommand — compiles to a
  runnable bundle (`<base>.wasm` + `<base>.run.cjs` loader + `_wasm_runtime.cjs` copied alongside);
  one clang call drives wasm-ld; `<base>.wasm.ll` intermediate avoids cache-poisoning; clear named
  error on an uncovered builtin. Verified end-to-end == native for sieve/strs/floats; 407/407;
  reconverged. (Gated by `cmd=="wasm"` → native untouched.)
- *Milestone 6+ (next):* compile NOVA's **C memory-runtime to wasm** (one source of truth → correct
  layouts, free/dicts/structs, FULL builtin coverage, no JS layout-replication) via #ifdef'ing the OS
  parts + a wasm malloc; then channels→SharedArrayBuffer+Atomics, threads→Web Workers, DOM. Effort XL.

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

---

## ★★ iter-52 GROUNDED RE-AUDIT (2026-06-14) — COURSE CORRECTION: the first-download floor is broken

A 6-agent grounded re-audit (state-grounder + 4 vision lenses + synthesis) after the JSON-native +
WASM frontier deliveries. **stateTruth:** NOVA's compiler/runtime/concurrency/distributed/perf core is
genuinely real + verified, BUT the two halves of its own first-download identity are BROKEN:
1. ⛔ **A fresh user cannot `nova run` a project.** REPRODUCED: `nova new p; cd p; nova run` →
   `clang: no such file or directory: 'nova_runtime.c'`. Setting `NOVA_HOME` makes the SAME project
   print "Hello from p!" → skeleton/codegen/runtime/link are all CORRECT; **runtime auto-discovery is
   the ONLY blocker.** Root cause: `nova_find_runtime()` (nova_compiler.nova ~L17450-17474) is env-var +
   cwd-relative only; no self-exe-path primitive exists (grep GetModuleFileName/proc/self/exe = 0).
2. **Long-running backend leaks ~1 heap value/iter** (the known partial-RC debt; total-RC = the real
   but XL/design-first fix).

**SEQUENCE (by leverage × tractability × reconverge-safety):**
- **C NOW (iter-53): fix runtime auto-discovery.** Add `nova_rt_self_exe_path()` (~15 lines C:
  GetModuleFileNameW / readlink("/proc/self/exe"), both paths), plumbed like env()/getcwd(); in
  nova_find_runtime() probe `<exe_dir>/output/nova_runtime.c` then `<exe_dir>/nova_runtime.c` after the
  env checks. This EDITS the compiler (nova_find_runtime) → a NEW-fixpoint reconverge (not byte-identical
  — normal for a compiler change, like iters 36-42), CLI-driver path so OFF the value-model/CVE surface.
  Oracle (already reproduced): `nova new p; cd p; nova run` works with NO env var from any cwd + `nova test`
  links. THE first-download experience, fixed.
- **B NEXT: flagship full-stack demo** (NOVA WASM frontend fetches JSON from a NOVA backend, from_json's
  it, renders to DOM on click) — needs a WASM **fetch import** (verified absent: _wasm_runtime_browser.mjs
  has 6 DOM ops, no HTTP-data fetch) + a real **web bundler** as a `nova` subcommand (verified: `nova wasm`
  at ~L18471 emits .wasm + a Node loader, never the browser .mjs/index.html). Both tractable + low-risk
  (string-emit + copy + the proven on_click export-name callback). Sits on C (can't host a project) → after C.
- **A LATER: total RC** (the real long-term capability frontier; fixes the per-iter leak) — XL, HIGH
  reconverge risk, NOT separable from the deferred W5b escape analysis (RC_COMPLETENESS.md S1-S4) →
  needs its own design workflow first. The better-tractability capability is AI tensor activations
  (softmax/exp/transpose/reshape — additive runtime fns on NovaTensor double*, low risk) if a capability
  campaign is wanted before A.

★ LESSON: two frontier deliveries (JSON, WASM) were built while the basic `nova run`-a-fresh-project
floor was broken. The re-audit's "what fails for a REAL first user" check caught it. Fix the floor (C)
before proving the story (B).


**iter-53 UPDATE:** ✅ Option C DONE (79072b4, reconverged 15D5A9D5) -- runtime auto-discovery fixed via nova_rt_self_exe_path() + install-relative probes in nova_find_runtime(); `nova run` works for a fresh user from any cwd with NO env (ONBOARDING_OK vs shipped nova.exe; _onboarding_test.ps1 = permanent guard). Two-phase bootstrap (first builtin the compiler calls on itself). The first-download FLOOR is FIXED. NEXT = B (flagship full-stack demo).
