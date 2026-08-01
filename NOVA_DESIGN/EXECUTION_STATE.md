# NOVA — EXECUTION STATE (live dashboard)

> **Goal:** complete CORE NOVA per `NOVA_MASTER_PLAN_2026_07_10.md` — every language feature + a full
> standard library, competitive with C/C++/Java/Python/Go/Erlang/Elixir/Rust (parity or ~1× beat), to
> JDK-scale (~200k+ lines) — BEFORE any framework work. Update this file in EVERY commit. Resume from here.
>
> **The gate (every change):** edit → precheck → build → **reconverge gen5==gen6 (compiler changes)** →
> regression BOTH modes → ASAN on risk surface → commit. Kill-on-timeout always. No cracked foundations.

## Two streams
- **Stream 1 — Opus (compiler/runtime foundation)** — `nova_compiler.nova` + `nova_runtime.c`. Sequential,
  reconverge-gated. Soundness FIRST, then language ceilings, runtime builtins, backend/FFI.
- **Stream 2 — Sonnet fleet (stdlib breadth)** — pure-NOVA modules in `std/`. Parallel, KAT-gated, one
  commit/module, NO reconverge. Independent libs start now; feature-dependent libs wait for Stream 1.

## ⏱ EXECUTION RHYTHM (OWNER RULE — do NOT violate)
- **UPDATED 2026-07-13: ~100 plan tasks IN ORDER, THEN one full arc** (owner raised 30→100 for the autonomous run;
  "just check syntax/compile and go ahead" per task; end-of-100 testing must be done very correctly). FULL AUTONOMY —
  do NOT stop or ask; decide independently. Sonnet-fleet builds / Opus verifies + commits.
- **Complete ~100 plan tasks IN ORDER, THEN one full arc.** NOT an arc every few commits (that was the mistake).
- Between tasks: FAST check only — gen4-probe / KAT / standalone-run. **Pure-NOVA stdlib (Stream 2) needs NO reconverge.**
- The full arc (per ~30 tasks) = reconverge gen5==gen6 IF the compiler/runtime was touched + full nova_ci BOTH modes.
- Tick ✅ in THIS file + the master plan as each task lands. `std/`=stdlib home; `forge/`=framework only. Production-grade always.
- Anti-dup: NEVER shadow a NATIVE builtin (deque/pq/lru/ringbuf/…); forge-overlap is OK (std/ is the canonical stdlib home).

## Current focus — UPDATED 2026-08-01 (rapid-dev: BUILTIN SOUNDNESS CAMPAIGN)

**⚠️ READ FIRST — the builtin mass-production era is OVER; it was shipping broken code.**

Adding ~1300 builtins by modelling each new function on its neighbour propagated defects
wholesale. A 3-lens audit fleet + measured before/after proof found them. Status: ✅ ALL FIXED.

- ✅ `08b03d37` **dense-dict iteration — 59 builtins read uninitialized heap.** `NovaDict` is DENSE
  (`keys/vals[0..size-1]`, compacted); 59 builtins iterated `i < d->cap` using `hashes[i] != 0` as an
  occupancy sentinel. Reads uninit memory + treats garbage as live entries; and the sentinel is
  invalid anyway (FNV-1a/`nova_rt_hash` can return 0 → drops a live entry). Now bound by `d->size`.
- ✅ `e25932b1` **duplicate LLVM `declare` — EVERY compiled program failed to link.** 10 duplicates
  across both backends; LLVM rejects a redeclared function and the declare block goes into every
  emitted program. `nova_rt_to_float` had CONFLICTING attributes (`nounwind` vs `nounwind readnone`).
  **Hidden for weeks by dev-mode's deferred reconverge.** Also hardened `_bootstrap_reconverge.ps1`,
  which checked only `Test-Path` after linking — a failed link left a STALE exe in place and let the
  next pass run the WRONG compiler, reporting a bogus "DIVERGED" instead of the real error.
- ✅ `e67ee810` **builtin soundness sweep — 8 of 10 probe classes SEGFAULTED before it.** Measured
  with an isolated probe per case against pre-fix vs post-fix runtime:
  `flatten_map([1,2,3])` CRASH139→ok (elements read as ptrs 0x1/0x2/0x3) · `truncate_ellipsis(s,-5)`
  CRASH127→ok (`buf[-5]=0` heap **underflow**) · `str_mul`/`repeat_each` CRASH139→ok (`len*n` wrapped
  size_t) · `dict_to_query_string` 9KB key CRASH139→ok · `pad_both(null,null)` CRASH139→ok ·
  `list_sum_int(42)`, `max_by_abs("str")` CRASH139→ok (wrong-type handle).
  Root cause: all 173 `nova_mem_find_tag` checks sit before line ~19765; the builtin region (24000+)
  had **ZERO** across 239 functions, using a NULL-only guard that stops a literal null but not a
  valid handle of the wrong type. Fixed via checked accessors (`nova_as_list`/`nova_as_dict`) +
  `nova_str_safe` over 511 casts, plus 14 arithmetic fixes (overflow-checked sizing, clamped negative
  lengths, `INT64_MIN` negation UB in gcd/lcm/max_by_abs/min_by_abs).
  **NEW STANDING GATE:** `_run_builtin_soundness.ps1` — links straight against the runtime, needs no
  compiler, so it runs even mid-reconverge. Run after touching any builtin.
- ✅ `92e91cd5`/`541ac463` builtin batches 27-28 (16 new, **1305 total**)

**RULE GOING FORWARD:** builtin count is NOT a goal. Every new builtin must verify the accessor +
size-arithmetic contract against the actual struct definition, never against the adjacent function.
See memory `[[builtin-needs-type-tag-check]]`, `[[novadict-dense-layout]]`,
`[[duplicate-declare-breaks-all-links]]`.

**MASTER-PLAN WORK LANDED (2026-08-01, after the soundness campaign):**
- ✅ `f88e622a` **RECONVERGE CERTIFIED gen5==gen6 byte-identical** — new bootstrap installed
  (1.77 MB → 2.34 MB, all 1305 builtins). This ALSO unblocked the "gen3 truncation" backlog:
  the old Jul-26 gen3 silently dropped newly-added compiler code, which is why several
  source-done features were dead.
- ✅ `4f524b26` **LOCK-4 / L7 #36 inc3c-part2 — sized numerics are now USABLE.** `let x: u8 = <expr>`
  wraps, including RUNTIME-valued vars (loop accumulators, fn results, reassignment) that
  const-fold cannot forward. 4 hooks: `_lock4_ann_width`, the annotation bridge at typed-let
  lowering, `copy` honouring a builder-seeded width, and SLOT WIDTH FLOW (slot_store records /
  slot_load restores). **Why it no longer hangs:** the slot width is a MONOTONIC lattice
  (absent → `<width>` → `""` conflicted/absorbing), so each slot changes state at most twice and
  `ir_infer_types`' fixpoint always terminates; the earlier attempt oscillated. KAT 11/11,
  default int verified byte-identical-behaviour.
- ✅ `7e9b4e11` **GAP-1 labeled break/continue CLOSED — it now actually works.** Codegen had been
  in tree since `9aee01e4` but the parser rejected every labeled loop as "empty body": the label
  branch went through `parse_stmt(pos+2)`, so the loop parsers took their body-indent reference
  from the KEYWORD's column, which sits right of the label. Gave the loop parsers an explicit
  `ref_col`, split out `parse_loop_stmt`, and dispatch labeled loops via `_ll_parse_loop`.
- ✅ `3e56c6e1` **CYCLE 3-G CLOSED — `sum()` over a comprehension returned a float.** A comprehension
  desugars to `map()`, typed plain "list"; the dispatch treated every non-`intlist` as float, i.e.
  read "unknown" as "float". Now only a KNOWN float type takes the float variant; unknown routes to
  `nova_rt_sum_any`, which decides from `elem_kind` at runtime and returns a self-describing value
  (raw int, or BOXED float). Float comprehensions still correctly yield floats.
- ✅ `2a720dd6` **CYCLE 3-G part 2 — `min()`/`max()` over a comprehension had the same bug** (1.0/5.0
  instead of 1/5). Same root, same fix: `nova_rt_list_min_any`/`nova_rt_list_max_any`.
- ✅ `2cbb8688` (certified `bd8dc1dd`) **comparisons yield BOOL — `print(x == y)` printed `1`, not `true`.**
  Found by dogfooding; a direct Python-parity failure given NOVA's "simpler than Python" bar. Only bool
  LITERALS rendered correctly. TWO independent paths both needed fixing: (1) `ir_infer_one` typed the
  RESULT register of eq/neq/lt/le/gt/ge and not/and/or as "int" — the instruction's own IrType is the
  OPERAND type (it picks the float/str/int compare variant) and is unchanged; only `rt[dest]` moved to
  "bool". (2) const-folded literal comparisons never reach inference, so 7 `ir_const_fold` sites now emit
  a bool-typed constant. Also fixed a latent LOCK-4 interaction: the int/int compare propagated the
  operand WIDTH (`@w@`) onto its result, so a `u8` operand would have made the backend mask a boolean.
  SCOPE GUARD: `neg`/`bitnot` stay INTS (an initial mis-patch made `neg` bool; the probe caught it and
  the KAT now pins it). KAT `_kat_bool_render` covers folded + runtime + the neg/bitnot guard.
- 🔄 **L8 call-overload — root cause identified, partially working.** `obj(args)` → `Struct__call`
  works when the callee's type is already resolved (`let d: Doubler = ...`, a param, a field).
  It does NOT work for `let d = Doubler(3)` because at constrain time the callee is still an
  unresolved type VARIABLE (measured: `kind=var`) — constraint solving is deferred, and the
  "expected Doubler" in the error is the type printed after later zonking. Also fixed the guard to
  consult `ti_type_methods` (`ti_has_name` never carries `Type__method` entries, so the redirect
  could never fire at all). Full fix needs the call constraint DEFERRED until fn_t resolves
  (the `ti_bound_checks` pattern) — inferrer-deep, tracked with an in-code limitation note.

**OBSERVATION (owner's call, NOT changed unilaterally):** `slice()` is typed string-only
(`(string,int,int) -> string`), so `slice(myList, 1, 3)` is a type error. List slicing works via
`xs[1:3]` and `list_slice(xs,1,3)`, so nothing is broken — but Python slices uniformly, and a
split surface is a wart against the "simpler than Python" bar. Making `slice` polymorphic would be
additive (no existing code breaks) but it is a public-API design decision, so it is left for the owner.

**DOGFOOD SWEEP (clean):** HOF (map/filter/lambda), dict keys/values/contains, join, string repeat,
INT64_MAX, shifts, negative int division, nested dicts, list slicing, negative indexing, sort over
keys, and all list ops over comprehension results — all verified correct.

**BATCH 2 — BACKLOG ITEMS LANDED (2026-08-01, certified `gen5==gen6` `721e5369`):**
- ✅ `3f851358` **FD_SETSIZE guard — POSIX `select()` had a STACK BUFFER OVERFLOW above 1024 FDs.**
  Windows `fd_set` is `{count, array[FD_SETSIZE]}` so the `#define FD_SETSIZE 4096` genuinely resizes
  it; POSIX `fd_set` is a FIXED BITMAP indexed BY DESCRIPTOR NUMBER that glibc pins at 1024 regardless.
  `FD_SET(fd,...)` with fd>=1024 wrote past a stack object — reachable from any server accepting >1024
  concurrent connections, i.e. ordinary load. Now: never FD_SET an out-of-range fd, cap the wait to 1ms,
  and wake those waiters so they retry (a spurious wake is harmless; skipping them would park forever).
  Mitigation, not the end state — POSIX >1024 wants poll()/epoll(), still open.
- ✅ `58a7a6a3` **ALPN server** — `tls_listen_alpn(s, "h2,http/1.1")` on BOTH SChannel (blob as a 3rd
  input buffer to AcceptSecurityContext + SECPKG_ATTR_APPLICATION_PROTOCOL query) and OpenSSL
  (`SSL_CTX_set_alpn_select_cb`, server preference wins). Fail-open by design.
- ✅ `4861b196` **CYCLE 2 PARTIAL** — float HOF callbacks box at the trampoline. FIXED: `map(named_fn)`
  and `map(fn(x) named_fn(x))`. STILL OPEN: `map(fn(x) x.price)` — measured at IR level, `frt` for the
  lambda is not "float" because `ir_analyze_return_type` doesn't resolve a bare struct-field read.
  Making it do so is what the in-code note at ~20408 records as "tried and REVERTED (perturbs the S4
  fixpoint)", so it was NOT bolted on.
- ✅ `808342ca` **LOCK-6 Phase 2 `@cdecl` — PROVEN FROM A REAL C HOST.** A C program with its own main
  called NOVA with NO prior init (`event(21)=42`) and used a NOVA fn as a genuine `qsort` comparator
  (`sorted: 1 2 3 5 7 9`). Root enabler: `nova_rt_init()` is NOT idempotent (critical sections + signal
  handlers), so added `nova_rt_ensure_init()` (InitOnceExecuteOnce / pthread_once) and routed
  `nova_rt_init_args` through it too. Composes with `@export`. **LOCK-6 no longer blocks Prism/Edge/Reactor.**
- ✅ `0496cd60` **LOCK-5 `kill()` — safepoint termination.** `kill(pid)` / `kill_pending()`. The target
  unwinds through its OWN fault_buf, i.e. the exact path a panic takes, so teardown is the proven one.
  Cooperative by design (BEAM's reduction-boundary trade): async teardown would free RC objects still in
  use and could abandon a held lock. **LOCK-5 no longer leaves Mesh supervision "fiction".**
  OPEN: a task parked forever on a channel is not force-unlinked (needs per-list locked removal);
  signal-based involuntary preemption remains post-v1.

- ✅ `c6ca9ad7` **Wave-B #6 (part 1) — fresh owned TEMPORARIES are now dropped. Targeted leak
  HALVED 2000 -> 1000, ASAN-clean in BOTH modes.** The pinned test's model was WRONG: the leak is
  not the insert-inc but a TEMP-ARG LIFETIME gap — in `"row-" + str(i)` the INTERMEDIATE `str(i)`
  allocation goes to `str_concat`, which reads it and allocates a NEW string, retaining nothing,
  and nobody dropped the +1.
  **Soundness (dropping a BORROW is CORE_GAP 0.10 = UAF):** a register is dropped only if ALL of
  (a) produced by a whitelisted FRESH-ALLOCATION call — a borrow can never qualify, (b) used
  EXACTLY ONCE in the whole function — which is what makes it sound with no liveness analysis,
  since one use cannot be live after its consumer, (c) that use is an arg to a whitelisted
  NON-RETAINING consumer. Whitelists verified by READING the runtime. Retaining consumers are
  excluded (that is MOVE-on-insert, separate + riskier). `nova_rc_dec` is pointer-validated as a
  backstop and `find_tag` rejects the `int_to_str` small-int CACHE range, so the one producer that
  can return a non-owned pointer degrades to a no-op.
  **Gotcha that cost two cycles:** string `+` is IR op `"add"` with a str-typed result, NOT a
  `"call"` — the EMITTER turns it into `nova_rt_str_concat`.
  KAT `_kat_w6_uaf_guard` pins what must NOT be dropped (two-use temp still readable, stored
  results readable, chains, container-retained values). `_kat_w6_temp_drop` measures the delta.
- ✅ `23af36ca` **Wave-B #6 part 2 — fresh strings are OWNED. Slot-rebind leak 1000 -> 1.**
  Wave-B #6 is CLOSED for the string-temp class: the original 2000-per-1000-iteration leak now
  measures **1** (the final live value). ASAN-clean, 14 KATs green under FULLRC.
    part 1 `c6ca9ad7`  temp-arg leak     2000 -> 1000
    part 2 `23af36ca`  slot-rebind leak  1000 -> 1
  Root: the FULLRC slot-drop pass's owned-set was CONTAINER-ONLY (make_list/dict/struct/closure
  + channel_create), so a slot holding a fresh STRING was never droppable. Added the same verified
  producer whitelist plus the `add`-with-str-result form (how string `+` is represented).
  Safe because widening the owned-set only adds CANDIDATES — the escape guard (a value passed at
  arg index > 0 of a call marks its slot escaped) and the all-stores-owned rule (a string LITERAL
  is neither a call nor an add, so such a slot stays non-droppable) both still apply. KAT
  `_kat_w6_slot_string` pins the escape guard: 5 pushed strings remain readable after the loop.
  **STILL OPEN:** `_move6_insert_leak_test` reports its 2001 baseline unchanged — ITS leak is the
  retained-INSERT case (MOVE-on-insert), which neither part touches.

- ✅ `f74454c1` (certified `a4c72825`) **Wave-B #6 part 3 — MOVE-on-insert. The gated test itself now
  prints `CONCAT/DICTSET INSERT LEAK CLOSED`.** concat 2001 -> 2, dictset 2001 -> 2. ASAN-clean.
  **Why it is safe NOW when the earlier attempt was not:** a container insert universally RETAINS —
  `list_append_no_rc`'s elision was DISABLED as unsound by CORE_GAP 0.10 (ASAN caught the UAF), so
  both variants take their own +1. The temp's ORIGINAL +1 was simply never released; dropping it
  makes the container sole owner, i.e. the RC invariant restored.
  POSITION IS ENFORCED: only the RETAINED VALUE slot is a candidate (append arg 1, dict_set arg 2,
  index_set arg 2) — dropping arg 0 would free a live container.
  Two discoveries, both from reading emitted IR: (1) a string concat RESULT is itself a fresh
  allocation and is the value most often inserted — it was a consumer but not a PRODUCER; (2)
  `d[k] = v` is IR op `index_set` which has **no dest**, and marking was keyed on the consuming
  instruction's dest, silently excluding every dict assignment. Marking is now keyed on the VALUE
  REGISTER, which also removed the multi-temp joining logic.

**WAVE-B #6 SCOREBOARD (per 1000 iterations):**
| part | class | before | after |
|---|---|---|---|
| 1 `c6ca9ad7` | temp-arg | 2000 | 1000 |
| 2 `23af36ca` | slot-rebind strings | 1000 | 1 |
| 3 `f74454c1` | MOVE-on-insert | concat 2001 / dictset 2001 | 2 / 2 |

**STILL OPEN:** the pinned test's `call` column stays 2001 — inserting the result of a USER
function call. Closing it needs the producer whitelist to cover user fns, which requires PROVING
a callee returns a fresh allocation rather than a borrow (a borrow would be CORE_GAP 0.10). Not
guessed at.

- ✅ `c9659065` (certified `046943b4`) **Wave-B #6 part 4 — fresh-return PROOF. The last column falls:
  `call` 2001 -> 2. ALL THREE columns now read `concat=2 call=2 dictset=2`.**
  To MOVE a user call's result the caller must know the callee returned a +1 it OWNS, not a BORROW
  (a fn returning `xs[0]`/`self.name` hands back a pointer its container still owns — dropping that
  is CORE_GAP 0.10 UAF). So it is PROVEN, whole-program and fail-closed, exactly like the existing
  `_s1` struct-return prover: a fn qualifies ONLY if EVERY return hands back a register whose
  defining instruction is itself a proven fresh allocation. Param / slot_load / index_get /
  field_get / unproven call / constant all disqualify. No fixpoint over call chains.
  **Why it silently didn't fire at first:** `all_fns` holds PRE-INFERENCE IR, where a string `+` is
  an untyped `add` — the str type that marks it fresh is assigned by `ir_infer_types`. So
  `return "item-" + str(i)` looked like a plain add and was rejected. The prover now types each fn
  first. The failure mode was SAFE (fail-closed -> no drops emitted, leak simply stayed), which is
  exactly why it was invisible without a diagnostic.
  **Safety pinned by `_kat_w6_fresh_proof`:** PROVEN = make_fresh; REJECTED = borrow_elem (`xs[0]`),
  borrow_field (`bx.b_name`), borrow_param, mixed (one fresh path + one borrow path). After
  inserting those borrowed values the originals are verified intact. ASAN-clean, 18 KATs green.

**WAVE-B #6 FINAL SCOREBOARD (per 1000 iterations) — CLOSED:**
| part | class | before | after |
|---|---|---|---|
| 1 `c6ca9ad7` | temp-arg | 2000 | 1000 |
| 2 `23af36ca` | slot-rebind strings | 1000 | 1 |
| 3 `f74454c1` | MOVE-on-insert | 2001 | 2 |
| 4 `c9659065` | insert of user call | 2001 | 2 |

**LOCK-4 inc3d (packed sized arrays) — MEASURED BLOCKER, deferred with evidence.** inc3d changes the
LAYOUT of `NovaList.data` (packed by width instead of 8 bytes per element). Measured in
`nova_runtime.c`: **575 raw `->data[` accesses vs only 34 `elem_kind` guards** — i.e. ~541 sites read
`l->data[i]` assuming 8-byte elements. Under a packed layout every one of those becomes a
WRONG-WIDTH read: silent memory corruption, not a clean failure. Landing this safely needs either a
width-guard audit of all 575 sites, or a proof that no unguarded entry point can ever observe a
packed list (the S4 deopt discipline generalised). That is a design + audit job, and a PARTIAL
implementation is strictly worse than none here. NOT attempted — this is the "widest runtime change"
the plan calls it, and the failure mode is exactly the uninitialized/wrong-width read class this
session spent its time eliminating.

- ✅ `6bd9416d` (certified `f0421911`) **explicit SIMD path** — 7 builtins: `simd_add/sub/mul`,
  `simd_scale`, `simd_dot/sum`, `simd_ready`. REAL vectorization, verified not assumed: clang reports
  *"vectorized loop (vectorization width: 4, interleaved count: 4)"* = 4-wide AVX doubles. A raw
  float list (elem_kind 2) is literally a contiguous `double[]`, so a plain loop over it vectorizes —
  better than intrinsics here because one portable source covers SSE/AVX/NEON and the width follows
  `-march`. SOUNDNESS: a boxed list holds POINTERS, so every kernel REFUSES unless both operands are
  genuine raw float lists (empty list / 0.0 on refusal, never a garbage buffer); length mismatch uses
  the SHORTER operand. `_kat_simd` pins that an int list AND a boxed float literal are both refused.
  Also typed `simd_dot`/`simd_sum` float-returning in both whitelists — without that they returned
  correct bits that `str()` printed as an integer (the CYCLE 3-G result-vs-operand-type class again).
  KNOWN LIMITATION: a float LITERAL builds boxed, so it is not SIMD-ready; raw mode comes from
  pushing floats. Making literals build raw is a separate list-literal-construction change.

**MONOTONIC TYPE-ID VTABLES — MEASURED AND SPECIFIED (was a hunch, now has numbers).**
Dynamic method dispatch currently emits a LINEAR chain of `eq` + `branch`, one arm per
implementation, over `nova_rt_type_hash(recv)`. Benchmarked with the SAME 2.4M total dispatches
at each width (`_bench_dispatch` / `_bench_control`):

| impls | time | per dispatch |
|---|---|---|
| 2 | 55.8 ms | 23 ns |
| 4 | 89.6 ms | 37 ns |
| 12 | 176.9 ms | 74 ns |
| 24 | 350.2 ms | 146 ns |

Monomorphic control (identical loop shape, one type -> static call): **0.098 ms**. The cost is
almost perfectly LINEAR in the number of implementations — doubling N doubles the time — so the
COMPARE CHAIN is the dominant term, not `find_tag`. (Removing `IsBadReadPtr` from `find_tag`
bought ~10%: `b6debe3e`. That was worth doing but is not the main cost.)
**This validates the backlog item with data.** The cheapest correct fix needs NO new runtime and
NO struct-layout change: sort the implementations by hash and emit a BALANCED COMPARISON TREE
instead of a linear chain, using only the existing `eq`/`lt`/`branch` ops -> O(log N). At N=24
that is ~5 compares instead of 24. A true jump-table vtable would need DENSE type ids, which means
changing what struct slot 0 holds — a much wider change for a smaller marginal gain over O(log N).

- ✅ `789a4246` + `b6debe3e` (certified) **"monotonic type-id vtables" CLOSED — as a MEASURED HYBRID,
  not the framing the item assumed.** Shipped result is faster at EVERY width with no regression:

  | impls | linear (was) | tree-only | **hybrid (shipped)** |
  |---|---|---|---|
  | 2 | 55.8 ms | 69.3 ms | **53.4 ms** |
  | 4 | 89.6 ms | 104.2 ms | **82.4 ms** |
  | 12 | 176.9 ms | 171.7 ms | **167.9 ms** |
  | 24 | 350.2 ms | 209.6 ms | **218.9 ms (-37%)** |

  **A blanket binary search would have REGRESSED the common case 16-24%** — it costs an extra `lt`
  + branch per level, and most methods have 2-4 impls. So the crossover sits where the data puts it
  (>= 8 impls). Uses ONLY existing eq/lt/branch ops: no new IR op, no runtime change, and NO dense
  type-id scheme (that would mean changing what struct slot 0 holds — far wider, smaller marginal
  gain over log N). Both paths converge on one `dyn_miss`, so the #8 S8.0 loud-panic fallback is
  unchanged. Correctness pinned by `_kat_dispatch` (7 types, each must reach ITS OWN impl + a sum
  check, since a mis-built tree would silently call the wrong method).
  Also `b6debe3e`: `find_tag` — the soundness backbone behind every checked accessor and RC op —
  was calling Windows `IsBadReadPtr` (deprecated, drives exception machinery) on every call. It is
  redundant when the heap extent is known, since the range check above already proves the bound
  without dereferencing. ~10% win; soundness gate PASS.

**NEXT (resume here):** LOCK-4 inc3d (BLOCKED, see above) ·
LOCK-1 full `@mod__fn` mangling · const generics · RC cycle collector · monotonic type-id vtables ·
explicit SIMD · ARM aarch64 fibers · GPU lowering — **ATTENDED ONLY** (XL RC-lifetime work; a mistake
introduces a UAF, and the leak itself is memory-SAFE, so it is not an overnight task) ·
LOCK-6 Phase 2 (`@cdecl`, XL ABI) · LOCK-5 (safepoint+kill, XL scheduler) · L8 deferred-constraint
fix · CYCLE 2 map/HOF float boxing (explicitly "needs a focused session").

---

## Previous focus — 2026-07-31 (rapid-dev session: language ceilings + gaps)
**Where we are:** Phase 0-A soundness ✅ DONE. Stdlib breadth ✅. Phase 3 **language ceilings** making rapid
progress — L6, L1a Phase-1, L2a Phase-1+2 all DONE. All 4 appendix gaps CLOSED (for-in-channel, labeled
break/continue [deferred gen3], numeric separators [already existed], unicode escapes).

**This session (rapid-dev branch, batch reconverge deferred):**
- `1a65d7c0` L6 `let mut` syntax + L1a `@entity`/`@service` annotations
- `55d3fb7e` L2a comptime-fn Phase 1 (compile-time evaluation)
- `fea32392` L1a `@middleware`/`@inject` annotations
- `216183e2` L1a `@deprecated` annotation with runtime warnings
- `de63bcae` L1a batch 2 (`@validate`/`@builder`/`@log`/`@retry`/`@timeout`/`@singleton`)
- `e099c1ac` L1a batch 3 (`@observable`/`@async`/`@cache`/`@event`) + `str_repeat` builtin
- `b7a5e1ca` L2a comptime Phase 2 + `\u{XXXX}` unicode escapes (GAP-4 closed)
- `9c81807c` for-in-channel iteration (GAP-2 closed: `for val in ch` drains until close)
- `9aee01e4` labeled break/continue parser+codegen (GAP-1 DEFERRED: gen3 truncation)
- `a6355d99` docs: tick plan files — L6/L1a/L2a DONE, all 4 appendix gaps CLOSED
- `c488cace` docs: comprehensive plan audit — tick 25+ items verified against live code
- `d50fcf1d` pack float support + model loaders (ONNX/GGUF/SafeTensors) + AWS SQS/SNS — 7 modules, all KAT-verified
- `b218a912` enhanced @test runner: per-test PASS/FAIL output, NOVA_TEST_FILTER env var, auto-call when no main(). Self-compile verified.
- `01aa11b5` safetensors_loader: 5 missing dtypes (U16/U32/U64/F8_E4M3/F8_E5M2)
- `7fcf7444` stdlib fleet: uritemplate RFC 6570 + cli + phonetics (tseries removed as duplicate `42e9c73f`)
- `42e9c73f` L8 call-overload: type inference + IR dispatch source-done (blocked by gen3 truncation)
- `4fca2ed3` plan file updates
- `43b49e88` docs: update EXECUTION_STATE — tick L1a/L2a/L6/L8 + add session commits
- `0ead6771` 6 stdlib fleet batches — 55 new modules + 6 KATs
- `ca390a5f` compiler from_json_safe + max/min float + 3 fleet batches (ops/ml/crypto)
- `2c3fd004` fix(compiler): call-arg ")" no longer breaks parsing
- `a44b8303` parser bracket-depth fix + 6 str builtins + std/core expansion + image/game/ui fleet (22 files)
- `92917ea4` 4 new string builtins — str_reverse, str_chars, str_count_char, str_replace_first
- `0ead6771` feat(std): 6 stdlib batches — sync(12)/os(12)/inetproto(12)/ordmap(9)/smtp(10)/subtitles-bugfix — 55 modules, 6 KATs, all Opus-verified
- `e6c37455` fleet 4: 6 stdlib modules (102 KAT) + runtime C bug fix
- `b20fbb62` fn_ptr("name") compiler intrinsic (LOCK-6 Phase 1) + fleet 5 (6 modules, 96 KAT) + 17 builtins (1099 total)

**Last done (overnight dogfood-driven 0-A soundness campaign — 5 fixes across 4 gated batches):**
`3f867230` interpolation float/bool/format-spec · `b5860bd6` Result/Option float payload + multi-arg generic
annotation comma-drop · `4009d0eb` inline `catch e =>` · batch 4 (gating) closure-float-capture (R2 #13) + `T?`
in struct-field/let (R2 #3). Two dogfooding fleets ran (round 1 = the float-boxing cluster; round 2 =
generics/traits/closures/text/recursion/ADTs — see `project_dogfood_round2_gaps` memory). Unifying root of the
float class = a raw float at an `any`-widen point that fails to box; the specific trap = `ir_collect_param_types`
gives any-storing runtime fns a concrete-`float` fpt entry → the boxing branch wrongly skips them.
**DEFERRED (delicate, fully diagnosed, NOT rushed — need focused sessions):** map/HOF lambda float corruption
(root: untyped HOF lambda param → field_get typ=any; `ir_list_elem_struct` is the missing piece) + sum + the
round-2 delicate cluster (enum/ADT unify, match-codegen soundness #7/#8, two runtime crashes #19/#20, trait-as-
param #11). **STRATEGIC (owner's call): LOCK-4 sized/unsigned + f32/f16** — still the #1 plan item, XL.

**DOGFOOD CAMPAIGN (active) — the same root recurs at several widen points; fixing in cycles:**
- ✅ CYCLE 1: interpolation `any_to_str`/`format_one` (DONE `3f867230`).
- ✅ CYCLE 3-F: `Result`/`Option` float payload — `ok()`/`err()`/`some()` stored the payload unboxed; the fpt-boxing
  branch skipped it under the "concrete-float ⇒ callee reads raw bits" mis-assumption (context-sensitive: a 2nd
  Result fn merged the fpt entry to `any` and "fixed" it). Fix (batch 2): exclude ok/err/some from that branch +
  the combined boxing branch boxes their raw-float payload. KAT `_kat_result_float`.
- ✅ CLUSTER B: `Result<int,string>`/`dict<K,V>` param/ret/alias annotations dropped the comma (tokenized `COMMA`
  but the 3 generic-capture loops checked `DELIM`; sites 2582/2638/2763). Fix (batch 2): 3× `DELIM`→`COMMA` (the
  downstream `ti_split_type_args` already split on the comma). KAT `_kat_generic_annot`.
- ⬜ CYCLE 2: map/HOF — ATTEMPTED + REVERTED (delicate; ROOT fully diagnosed, see memory
  `project_dogfood_float_widen_boxing`). box-at-trampoline (gated on `frt[target]=="float"`) FIXES the named-fn
  case D (`map(gp)`), but NOT the lambda case C (`map(fn(x) x.price)`): MEASURED `frt["__lambda_0"]=ABSENT` —
  the untyped lambda param makes `x.price` a typ="any" field_get at lowering (index resolves globally, type is
  lost), so the return analyzes "any". REAL FIX (scoped, invasive): type the HOF lambda param to the list element
  struct type. KAT `_kat_hof_float.nova` written+kept (unregistered). NOT rushed overnight — needs a focused session.
- ⬜ CYCLE 3-G: `sum([..for..])` over a comprehension returns a float / garbage-int (separate root, sum() typing).
- ✅ CLUSTER C **CLOSED** `793bf3c8` — the remaining "bare multi-line catch as a fn's final statement
  swallows the next fn" is fixed. Root (measured): the catch handler loop skips newlines while scanning
  for its next handler statement, so on exit the cursor sits DIRECTLY on the following token instead of
  on a NEWLINE like every other statement — and that adjacent `fn` was handed to NOVA's trailing-lambda
  parser (`process(xs) fn(x) ...`), which ate the next DECLARATION. fn-specific (a following `type`/`let`
  parsed fine). Fix: `_tf_is_trailing` — a trailing fn must be indented PAST the statement column.
  Trailing-fn verified unaffected (byte-identical IR). KAT `_kat_catch_bare_final`.
- (historical) CLUSTER C: catch parser. INLINE `EXPR catch e => handler` FIXED (batch 3) — the parser never consumed the
  `=>` ("unexpected FAT_ARROW"); now consumes the optional FAT_ARROW in the inline handler path. KAT `_kat_catch`
  (inline / multi-line / return+inline). REMAINS: bare multi-line catch as a function's implicit-return final
  statement swallows the next fn (subtle fn-body/indent-block interaction) — narrow, deferred (use let/return).

**Next — the honest decision (strategic vs tactical):**
- **STRATEGIC (the plan's real heart — LOCK-NOW, blocks frameworks):** **LOCK-4 sized/unsigned + f32/f16** (the
  "#1 risk", unblocks 6 frameworks — the widest ABI/type change, do before the frameworks need it) · LOCK-5
  safepoint preemption+kill · LOCK-7 constant-time crypto · LOCK-1 full `@mod__fn` mangling (detection done).
- **TACTICAL 0-C leftovers:** ALPN server · FD_SETSIZE (Linux) · ARM fibers · TLS netpoller-for-concurrency.
- **0-B RC completeness:** Wave-B #6/#7/#8 leaks — memory-SAFE, so lower urgency; UAF-adjacent = attended/supervised cycle.

**RECOMMENDATION:** the plan's foundation-first doctrine says do the **LOCK-NOW** decisions before more breadth —
**LOCK-4 sized numerics** is the highest-leverage next (most frameworks unblocked). Tactical 0-C items are useful
but not the strategic bottleneck.

*(historical) Stream 2 std/ breadth + Wave-B #6 were the prior focus.*

## Stream 1 — compiler/runtime (Opus) — status
| Item | Phase | Tier | Status | Commit |
|---|---|---|---|---|
| 0.8 struct-field-leak | 0-A | A | ✅ DONE | fb1167cf |
| 0.11 float-return-uninit | 0-A | A | ✅ DONE + RE-VERIFIED (stddev=1.4142; `bfc55fba`+`29e380c1`) | 29e380c1 |
| abs(float) mistypes return -> i64/pointer | 0-A | A | ✅ DONE (compiler types abs-of-any 'any' + runtime nova_rt_abs re-boxes) | 058cbea5 |
| is_dict/is_list/is_* return 0 on any-typed | 0-A | A | ✅ DONE (new nova_rt_type_pred; compiler emits runtime check for undecidable case) | 441819d6 |
| type_of() returned "int" for float/bool/null (can't discriminate scalars) | 0-A | C | ✅ DONE `38927788` (compile-time fold _eval_type_of for static types + runtime NOVA_MEM_BOX kind-check for any-boxed float/null; reconverged, both-mode 1531/0. RESIDUAL: any-bool stays "int" — bools stored raw in containers, low-sev) | 38927788 |
| HOF float-ABI: typed-float arg to a fn-VALUE (dyn_call) transmitted RAW → misread as int (ap_f(dblf,3.5)=9.23e18) | 0-A | B | ✅ DONE `687f41d4` (box float args at dyn_call in ir_infer_block; reconverged gen5==gen6, both-mode 1530/0). This was the "int-from-list-elem→corrupt-float" (#1 braille) root; that + #9/#10 HOF reports resolved. Other ~8 fleet-reported "bugs" = FALSE ALARMS (repro-first triage, see [[project_codegen_bugs_from_stdlib_fleet]]) | 687f41d4 |
| **DOGFOOD C1: float/bool/format-spec string interpolation → raw int64 bits** | 0-A | A | ✅ DONE (reconverged gen5==gen6, both-mode, KAT `_kat_interp_float`) — `"{150.0}"`→4639481672377565184, `"{f:.2f}"`, `"{true}"`→1 all silently wrong. Interpolation is an `any`-widen point that didn't box the raw float/bool. Fix: specialize `any_to_str(float)`→`float_to_str` + `(bool)`→`bool_to_str` in `ir_infer_one` (zero-alloc, mirrors str()/print()); box the float for `format_one` in `ir_infer_block` + **exclude `format_one` from the fpt-boxing branch** (it had recorded `fpt["nova_rt_format_one"]["0"]="float"` and wrongly skipped boxing under the "concrete-float ⇒ reads-raw-bits" rule — the same trap that hits `ok`/`err`). | (dogfood c1) |
| **DOGFOOD C3-F: `ok`/`err`/`some` float payload stored unboxed → match reads raw int64 bits** | 0-A | A | ✅ DONE (batch 2; reconverge + both-mode + KAT `_kat_result_float`) — `ok(9.99)` payload read as 4621813488089437307; context-sensitive (a 2nd Result fn conflict-merged `fpt["nova_rt_ok"]` to `any` and hid it). Fix: exclude ok/err/some from the fpt-boxing branch + box their raw-float payload in the combined any-store branch (same trap as `format_one`). | (batch 2) |
| **DOGFOOD Cluster-B: multi-arg generic annotations drop the comma** | 0-A | C | ✅ DONE (batch 2; KAT `_kat_generic_annot`) — `Result<int,string>`→`Result<intstring>` ("expected intstring"), `dict<string,int>`→`dict<stringint>`. Comma tokenized `COMMA` but param(2582)/ret(2638)/alias(2763) generic-capture loops checked `DELIM` and dropped it; `Result<int>` (no comma) worked. Fix: 3× `DELIM`→`COMMA` (`ti_split_type_args` already split on the restored comma). | (batch 2) |
| **DOGFOOD Cluster-C: inline `EXPR catch e => handler` fails to parse** | 0-A | C | ✅ DONE (batch 3; KAT `_kat_catch`) — the Pratt-parser inline-handler path never consumed the `=>` → "unexpected FAT_ARROW '=>'". Fix: consume the optional FAT_ARROW before parsing the handler (additive; `catch e handler` without arrow still works). Reconverge-safe. REMAINS: bare multi-line catch as implicit-return (deferred, narrow). | (batch 3) |
| **DOGFOOD R2 #13: closure capturing a scalar FLOAT → raw int64 bits** | 0-A | A | ✅ DONE (batch 4; KAT `_kat_closure_float`) — `let rate=1.5; fn() rate` → 4609434218613702656. Captures are stored `any` + read back untyped inside the closure (same widen-point class). Fix: box a float capture at `make_closure` (~8688, guarded `ir_locals[cap]=="float"`; struct/int/string/list captures unchanged). Reconverge-safe. | (batch 4) |
| **DOGFOOD R2 #3: `T?` optional sugar rejected in struct-field / `let` annotation** | 0-A | C | ✅ DONE (batch 4; KAT `_kat_opt_sugar`) — only param/return positions handled `?`; `x: int?` / `let x: int? = some(5)` gave spurious 'missing closing )'. Fix: capture the `?` suffix in the field-type (2 branches) + let-type parsers (mirrors param ~2594; `ti_ann_to_type_g`→Option). The `T?` path works e2e (does NOT hit the separate explicit-`Option<int>` unify bug, R2 #4). | (batch 4) |
| module-level NON-scalar/non-literal/MUTABLE globals still per-fn copies | 0-A | B(XL) | ✅ DONE `ccb70ba6` (GAP 5) — self-contained top-level `let cache={}`/`[]`/`channel()` baked into the const-store (const_set prologue, const_get at every use — named fns/lambdas/nova_main); capture-exclusion fixed the green_scale_test N>1 race. Reconverged, both-mode 0-FAIL, N>1 clean. | ccb70ba6 |
| ~~floor()/ceil() boxed-float corrupts layout~~ | 0-A | — | ❌ NOT A BUG — nova_rt_floor returns clean `(int64_t)floor(x)`, typed int. Agent misdiagnosed; float_to_int helped an unrelated float-slot issue. | |
| multi-line list/dict literal in module body silently aborts module parse | 0-A | B | ✅ FIXED `a44b8303` (sync_to_stmt bracket-depth tracking prevents error recovery from skipping closing brackets) | a44b8303 |
| trait-conformance sig type-check (LOCK-3) | 0-A | A | ✅ DONE (gen4-verified; reconverge at arc) | (batch 1) |
| user-enum payload typing | 0-A | A | ✅ DONE (gen4-verified; reconverge at arc) | (batch 1) |
| **enum float-payload unbox** (codegen) | 0-A | A | ✅ FIXED + CERTIFIED (gen5==gen6, 1155/0 both modes) | (task 5) |
| `==` NFC/NFD helper | 0-A | C | ❌ DROPPED — not a gap (byte-equality is correct; matches Python/Rust/Go — NFC-by-default would be *wrong*) | |
| `1<<64` shift guard | 0-A | C | ✅ DONE (gen4-verified; reconverge at batch arc) | (batch 1) |
| lexer: numeric separators | 0-A | C | ✅ ALREADY DONE (decimal/hex/binary all strip `_`; audit stale) | |
| lexer: `\u{}` escapes / labeled break | 0-A | C | ⏸ DEFERRED (low-value: `from_codepoint` covers `\u`; labeled-break is involved, not a quick win) | |
| RC: push/closure/reassign leaks (MOVE-on-insert) | 0-B | A | ✅ **CLOSED 2026-08-01** — all 3 columns 2001->2 (`c6ca9ad7`+`23af36ca`+`f74454c1`+`c9659065`, certified `046943b4`); ASAN-clean; the gated test itself prints CONCAT/DICTSET INSERT LEAK CLOSED. (was: leak CONFIRMED 2001; gated `_move6_insert_leak_test` 83650843; design=MOVE owned-temps only, borrow-builtins stay rc-inc=the 0.10 UAF) | |
| RC cycle collector | 0-B | A(XL) | ⬜ **MEASURED + DESIGN CORRECTED 2026-08-01.** Cycles DO leak and it is reproducible: two mutually-referencing structs over 1000 iterations leak 2000 objects (`_kat_rc_cycle_leak`, delta = 2000). **The plan's premise is only half-right:** it says the collector can reuse "the existing per-type child enumeration" — that part IS there (`nova_struct_bitmap_for_hash` gives a managed-slot bitmap and `rc_free` already walks only pointer slots). But trial deletion ALSO needs to enumerate EVERY LIVE OBJECT to form the candidate set, and **no such registry exists** — the runtime has only counters (`nova_mem_live`) and range bounds (`heap_base`/`heap_top`, `g_box_lo`/`g_box_hi`); `nova_mem_find_tag` is a pointer VALIDATOR (range/align/magic/structural), not an iterable index. Adding object tracking touches the hottest path in the runtime (every alloc AND free), which directly conflicts with the C-level perf promise. **Refined design:** make tracking OPT-IN (`NOVA_GC=1`) so the default path costs at most one predictable branch, and track only CYCLE-CAPABLE objects (structs with managed slots, lists, dicts — never strings/bytes/boxes, which cannot form cycles), which also shrinks the candidate set. Then: gc_refs = rc, subtract internal refs via the child enumeration, mark from the externally-reachable roots, free the unmarked set. **Do the DETECTION half first** (report the unreachable set, free nothing) — it is the bulk of the algorithm with ZERO risk of freeing a live object, which is the failure mode that matters here. Plan rates this XL + SUPERVISED; the free half should stay supervised. | |
| ARM aarch64 fibers | 0-C | B | ⬜ | |
| N>1 per-carrier I/O | 0-C | B | 🔄 **MEASURED 2026-08-02 — the "goal met" claim is CORRECT; the perf gate PASSES.** Correctness: an 8-worker spawn+channel workload gives an IDENTICAL total at N=1/2/4/8 and under FULLRC (deterministic, no races). Scaling (`_bench_mn_scaling`, best-of-5 — this is a 15W mobile i7-1165G7 with **4 PHYSICAL cores** / 8 logical, so single runs swing widely with turbo/thermal): N=1 52.12 ms → N=2 29.05 (1.79x) → **N=4 16.25 (3.21x)** → N=8 16.19 (3.22x). **3.21x on 4 physical cores is ~80% efficiency and clears the plan's >1.8x @ 4-worker gate comfortably.** N=8 adding nothing over N=4 is expected — hyperthreading does not help a purely CPU-bound loop. *(Correction: an earlier entry today reported ~37% efficiency and a gate miss. That was WRONG — it divided by LOGICAL cores and used single noisy runs on a throttling mobile part. Recorded here because the mistake is instructive: always check physical vs logical before judging parallel efficiency.)* REMAINS as a pure OPTIMISATION, not a gate failure: the per-carrier deque's POP side exists but **Stage B (the push side) was never done** — `nova_rq_pop`'s own comment says the local deque is "empty until Stage B pushes to it, so today this always falls through to the global injector", i.e. every dispatch still takes `g_sched_lock`. `nova_carrier_enqueue` (the MPSC push) already exists, so Stage B is routing work, not new machinery. Worth doing for high task-churn workloads; not needed for the gate. | |
| **Windows TLS server** (of "ALPN + Windows TLS server") | 0-C | B | ✅ DONE `3c1f746d` — SChannel server: PFX cert load (dyn crypt32) + INBOUND cred + AcceptSecurityContext handshake + encrypted I/O; `tls_connect_insecure` (curl -k). Verified encrypted round-trip (gate [CI 2e3]). FOLLOW-ON: netpoller integration for concurrent HTTPS (blocking I/O today = sequential). | 3c1f746d |
| **ALPN server** (of "ALPN + Windows TLS server") | 0-C | B | ✅ **CLOSED 2026-08-01** `58a7a6a3` — `tls_listen_alpn` on BOTH SChannel and OpenSSL, fail-open by design. (was: pass SEC_APPLICATION_PROTOCOLS into AcceptSecurityContext + query negotiated proto (client ALPN already done `69c74b27`). Low-leverage until an h2 server consumes it. | |
| **S1 signal handling** (SIGINT/SIGTERM/SIGHUP) | 0-C | B | ✅ DONE `2ce90c6d` — shutdown already existed; added SIGHUP reload channel (`reload_requested`). | 2ce90c6d |
| **S5 file perms/symlinks** (chmod/umask/symlink/readlink) | 0-C | B | ✅ DONE `2ce90c6d` — runtime builtins, POSIX-primary. KAT `_kat_perms`. | 2ce90c6d |
| **S2 HTTP-client redirects+cookies** | 0-C(forge) | B | ✅ DONE `e11935a3`+ — http_get_follow (301/302/303/307/308 + relative-Location) + cookie jar (http_get_session). | e11935a3 |
| **T-Pkg lockfile** (reproducible installs) | toolchain | B | ✅ DONE `dcd8fae8` — nova install honors+writes nova.lock. | dcd8fae8 |
| **T-REPL** (broken by compiler relocation) | toolchain | B | ✅ FIXED+GATED `2543df3c` — stale runtime path repaired; `_test_repl.ps1` in CI. | 2543df3c |
| FD_SETSIZE Linux guard | 0-C | B | ✅ **CLOSED 2026-08-01** `3f851358` — POSIX `select()` was a STACK BUFFER OVERFLOW above 1024 FDs (fd_set is a fixed 1024-bit bitmap indexed by descriptor number). Now never FD_SETs an out-of-range fd and wakes those waiters to retry. (Linux-only; not runnable on this Windows box) | |
| safepoint preemption + kill (LOCK-5) | 0-C | A(XL) | ✅ **CLOSED 2026-08-01** `0496cd60` — safepoint `kill()` + `kill_pending()`; the target unwinds via its OWN fault_buf (the panic path), cooperative like BEAM's reduction boundary. OPEN: force-unlinking a channel-parked task; signal-based preemption stays post-v1 | |
| constant-time `@ct` + `Secret<T>` (LOCK-7) | 0-C | A | ✅ `secure_zero` + `ct_eq` DONE `bab9fa57` (C runtime + compiler 4 sites + 5 callsites; `@redact`/`Secret<T>` = Phase 2) | bab9fa57 |
| sized/unsigned numerics + f32/f16 (LOCK-4) | ceil | A(XL) | 🔄 inc3c-part2 ✅ DONE `4f524b26` (slot width flow + annotation bridge — sized numerics are USABLE); **inc3d BLOCKED with evidence: 575 raw `->data[` reads vs 34 elem_kind guards, so a packed layout = silent wrong-width corruption**. Prior: inc1+inc2+inc3a+inc3b+inc3c-part1a DONE (`bc5acb27`..`fe6177a6`); inc3c-part2 (slot-flow for runtime-valued sized vars) ATTEMPTED but gen3 hangs — DEFERRED for deep investigation | |
| module namespacing `@mod__fn` (LOCK-1) | ceil | A | 🔄 Phase-1 collision DETECTION done `724dad65` (two modules same-name → clear error); full mangling deferred (map in L11_NAMESPACING_MAP.md). | 724dad65 |
| annotations→codegen (LOCK-2) | ceil | A(XL) | ✅ Phase-1 DONE: 15 annotation types (`1a65d7c0`..`e099c1ac`). Phase-2 user-extensible = OPEN (L1b, XL) | 1a65d7c0 |
| macros/comptime | ceil | A(XL) | ✅ Phase-1+2 DONE `55d3fb7e`+`b7a5e1ca` (comptime eval + unicode escapes). Phase-3 quasi-quote = OPEN (L2b, XL) | b7a5e1ca |
| const generics · variance · assoc types | ceil | A | ✅ **CLOSED** — const generics `2ada8425` (LOCK-10/L5): a shape mismatch is now a COMPILE error naming both extents. ✅ **variance + assoc types DONE `91ef48b5`** — both were specified as INFERRED, not new syntax, and the inference already delivers them; now PINNED. Assoc types: a trait method's element type infers from the IMPLEMENTATION with no `type Item =` (IntBox.first()->int, StrBox.first()->string, each used at its own type). Variance: list<int> passes where list<any> is expected (co) and a fn taking `any` passes where one taking int is expected (contra) — invisible, as designed. Also fixed a real bug: `f: fn` PARSED but fell through to nt_struct("fn") — a struct named "fn" that can never be called — so every use failed with the self-contradictory "expected fn, found (int) -> ?T". **This row is now fully CLOSED.** | |
| custom index/iter/call operators (L8) | ceil | A | ✅ index+iter DONE `49f28f4f`; call-overload source-done `42e9c73f` (type inference + IR dispatch in nova_compiler.nova; blocked by gen3 truncation until reconverge) | 49f28f4f 42e9c73f |
| enforced immutability `let mut` | ceil | A | ✅ DONE `1a65d7c0` (parser accepts `let mut`; existing `let` = immutable) | 1a65d7c0 |
| `@cdecl` FFI callbacks (LOCK-6) + struct-by-value | ceil | A | ✅ **Phase 2 DONE `808342ca`** — NOVA fns callable FROM C, PROVEN from a real C host (qsort comparator + no-prior-init entry); `nova_rt_ensure_init` added because `nova_rt_init` is NOT idempotent. REMAINS: struct-by-value (LOCK-11) + an exact-prototype signature on the annotation. Phase 1 was `b20fbb62` (`fn_ptr("name")` intrinsic → ptrtoint ptr @name to i64). Phase 2 (@cdecl annotation + C calling convention + trampoline) = OPEN | b20fbb62 |
| monotonic type-id vtables | ceil | A | ✅ **CLOSED `789a4246`** — shipped as a MEASURED hybrid: dispatch was O(N) (23ns@2 impls -> 146ns@24); a blanket binary search would have REGRESSED the common 2-4 impl case 16-24%, so the crossover sits at >=8. Faster at every width, -37% at N=24. Plus `b6debe3e` (IsBadReadPtr off the find_tag hot path, ~10%) | |
| explicit SIMD path | ceil | A | ✅ **CLOSED `6bd9416d`** — 7 kernels over raw float lists; clang confirms 4-wide AVX ("vectorization width: 4"). Refusal-guarded: a boxed list holds POINTERS, so non-raw operands are rejected, never misread as doubles | |
| runtime builtins: math (D11) | rt | C | ✅ DONE (isnan/isinf/clamp/copysign/fma/nextafter/lgamma/erf; reconverge pending) | (batch 2) |
| runtime builtins: PRNG (D8) | rt | C | ✅ DONE (xoshiro256** seedable: rng_new/next/int/float; reconverge pending) | (batch 2) |
| runtime builtins: signals/sockets/glob/sync/pack | rt | B/C | ✅ MOSTLY DONE (signals=builtins; sync=std/sync/; pack=std/encoding/pack; glob=std/os/glob; sockets=TCP builtins) | |
| regex capture-group engine (D3) | rt | B | ✅ DONE (regex_captures + regex_named_captures + regex_find_all + regex_replace_all — all wired) | (pre-existing) |
| GPU lowering (SPIR-V/PTX) · MCU triples | backend | A(XL) | ⬜ | |

## Stream 2 — std/ stdlib (Sonnet fleet) — status
| Module | Category | Needs (Stream 1) | Status | Commit |
|---|---|---|---|---|
| forge_xmlparse (D5 XML parser) | data | — | ✅ DONE (ACCEPT) | a051c26a |
| forge_signum (D4 signed bignum) | numeric | — | ✅ DONE (fixed INT_MIN) | d708af6f |
| forge_blake2b (RFC 7693 hash) | crypto | — | ✅ DONE (fixed validation) | d708af6f |
| forge_hamt (D7 persistent map) | collections | — | ✅ DONE (fixed real-trie) | d708af6f |
| **JDK-SCALE BREADTH — 199 modules (cyc1-5; cyc5 arc ALL GREEN both modes, 1344 tests)** | (all) | — | ✅ DONE (each KAT-gated + independently re-verified; ONE full-CI both-mode arc per cycle) | cyc1 b80b7e24·3dc1086d·b4641598·2f5fba65 · cyc2 85fa62b2·d29951ec·fd4d82bc·d0699a19 · cyc3 01d9214e·ac7f0287·febd7584·753a5256 · cyc4 bce96075·5c57e071·2537a25c·30b1f453 · **cyc5 [30] 7119ba60·d4fb830a·f64fa588·2ab40967 (arc green)** |
|   ↳ cyc5 adds (io/* gap + algos) | platform·httpheaders·httprequest·crc16·summary·idgen·wraphard·xmlbuild·primes·mimetype·multiset·trie·graph·soundex·cookie·polynomial·bytebuffer·linereader·textwriter·jsonpath·ngram·tokenize·fixedpoint·varint·checkdigit·radix·consistent·shuffle·csvdict·sample | (all) | — | ✅ | |
|   ↳ **PHASE-2 real-task LIBRARIES (2026-07-13, owner: task=library not module)** — compress(cdac0a6b)·finance(f8a20eb3)·color(bf7b7c05)·automata(9e0cfc5d)=**48 modules CERTIFIED both-mode 1579/0 incl FULLRC**; validation building. Prior: compiler bugs #8 (687f41d4 HOF float-ABI) + #2 (38927788 type_of) FIXED+reconverged. Wave B #6 deep-diagnosed+deferred ([[project_waveb6_rc_leak_real_diagnosis]]). | (all) | — | ✅ | |
|   ↳ cyc6 (100-task) DONE — **104 modules** (b21-b29), ~303 std/ total | b21 33ba6e97 hash+numth · b22 f6ac45c5 numth2 · b23 b33ab525 collections(12 data-structs) · b24 9840524d encoding+data · b25 d10eea58 text-NLP+data · b26 757e1b29 time+numeric+math · b27 ddc4575e os+config+io+random · b28 76cddc5e util+math+spatial+crc32 · b29 0951a00c util+math+data+text | (all) | — | ✅ **CERTIFIED: both-mode arc ALL GREEN (1430 PASS, 0 FAIL, 20 SKIP in NORMAL and FULLRC leak-check)**. First arc's lone FAIL was a transient https_client net timeout; re-run clean. 104 new modules leak-clean. | |
|   ↳ cyc4 adds | logging·httpdate·wcwidth·btreemap·useragent·roundmode·proplist·typename·stats_ext·env·flatten·frozendict·iprange·hexdump·shellquote·combinations·query·worddiff·whitespace·normaldist·schema·ipclass·morse·acronym·percent·pigify·reverse_words·pipe·gcd_list·netmask | (all) | — | ✅ | |
|   ↳ cyc3 adds | http_status·similarity·sequences·base64·indexmap·box·enumflags·graycode·color·ipv6·geo·ratelimiter·banner·cron·damerau·jsonmerge·url·orderedset·rot13·metaphone·latin1·deepcopy·highlight·titlecase·mime·humanize_number·uuencode·introot·frozenlist·portname | (all) | — | ✅ | |
|   ↳ collections | unionfind·ordereddict·bloomfilter·sortedlist·bimap·trie·graph·multimap·fenwick·rangeset·defaultdict·segmenttree | — | ✅ | |
|   ↳ text | distance·format·tablefmt·shlex·roman·ordinal·pluralize·soundex·ansi·diff·wordcount·lorem·truncate·naturalsort | — | ✅ | |
|   ↳ math | numtheory·geometry2d·combinatorics·bits·quaternion·easing·polynomial·regression·angle·primesieve | — | ✅ | |
|   ↳ encoding/data | inifmt·properties·jsonpointer·ascii85·quotedprintable·ndjson·tsv | — | ✅ | |
|   ↳ util/net/time/other | itertools·func·hash/noncrypto·cli/args·random/dist·querystring·mac·cookie·stopwatch·humanize·calendar·retry·nanoid·humansize·ulid·validate·dotenv | — | ✅ | |
| forge_decimal (D2 BigDecimal) | numeric | signum | ✅ DONE `4ae0d3cf` + std/numeric/decimal | |
| forge_argon2id (KDF) | crypto | blake2b | ✅ DONE (std/crypto/argon2id) | |
| forge_unicode (D6 casefold/graphemes) | text | — | ✅ DONE `ee5dafbf` (std/text/casefold + grapheme) | |
| S2 HTTP-client redirects/cookies | net | — | ✅ DONE `e11935a3` (redirects + cookie jar + relative-resolve `94d566e4`) | |

*(Wave-1 = 4/4 landed, each KAT-gated + adversarially verified; the verify pass forced fixes to hamt/signum/blake2b before accept.)*

## Batch log (what we did per task; full-arc runs after ~10 tasks)
### Batch 1 (Phase-0 foundation) — ✅ FULL-ARC CERTIFIED (2026-07-11)
**Arc result:** `nova_ci.ps1` ALL GREEN — reconverge **gen5 == gen6 byte-identical** (gen5 installed as
gen3_test.exe/nova.exe), all feature gates PASS, negative gate PASS (incl. the 3 new Wave-A negatives),
**regression 1154 PASS / 0 FAIL / 2 SKIP in BOTH NORMAL and FULLRC modes**. The 4 new positive guards
(_shift64_guard / _trait_sig_ok / _enum_payload_ok / _floatret_uninit) run green in both modes. The 3
compiler changes (1<<64, trait-conformance, enum-payload) preserve the self-hosting fixpoint. Wave A
soundness = DONE. Next: task 5 (float-payload codegen, empirical) then the breadth phase.
1. **0.11 float-return-uninit → GUARDED.** Investigated: does NOT reproduce on the current post-0.8 compiler
   (correct at -O0 and -O2). Root: the garbage-uninit path is closed — every local slot (incl. all float
   locals) gets `store i64 0` zero-init at fn entry, and complex float returns (`sqrt(variance(xs))`) lower
   to pure SSA (no uninit temp). Action: tightened `_floatret_uninit_test.nova` from CI-safe (always exit 0)
   to a HARD ASSERT on stddev≈√2 + pearson≈0.7746, so any future layout shift that re-triggers it fails LOUD
   with a live repro. Test-only change (no compiler edit → no reconverge). *Next arc validates.*
2. **`1<<64` shift-UB guard -> DONE.** LLVM `shl`/`ashr` by >= bit-width is POISON (the `1<<64 -> garbage`
   bug). Fixed the ire emitter (nova_compiler.nova ~16462): mask the amount `& 63` for a valid shift +
   `select` the defined big-shift result (NOVA wraps: `shl`>=64 = 0; `ashr`>=64 = sign-ext). LLVM -O2
   constant-folds the guard away for constant amounts (zero cost); variable amounts keep it. gen4 built
   (compiler self-compiles with the new codegen) + `_shift64_guard_test` PASS (13/13). Compiler-only. Reconverge at arc.
3. **lexer scan (no code change):** numeric separators ALREADY done; `==`NFC/NFD is NOT a gap (byte-eq
   matches Python/Rust/Go); `\u{}` + labeled-break deferred (low-value; `from_codepoint` covers `\u`).
4. **trait-conformance signature TYPE check (LOCK-3) -> DONE.** Prior state checked name + arity only; a
   same-name/same-arity impl with WRONG param/return types was silently accepted -> unsound under DYNAMIC
   dispatch (runtime returns/consumes the impl's value AS the trait's declared type = type confusion).
   Fix: record self-excluded param type annotations + return type for trait methods AND impls (4 new TiState
   dicts), then compare in ti_check_trait_conformance. Conservative `_sig_type_compatible`: fires ONLY on
   provably-distinct primitives (int/float/bool/string/bytes); unannotated/`any`/user-type/generic slots
   pass (no false positives — inference + call-site unification guard those). New E1006 message. gen4-verified:
   OK impl compiles+runs; bad-return + bad-param REJECTED with precise messages; dyn_trait/bounds compile
   (no false positive); conformance_test still errors correctly. (phase75_default is a PRE-EXISTING failure,
   identical under old gen3 — unrelated from_json_safe orphan.) Compiler-only. *Reconverge at arc; wire the 2
   negatives into the neg-test gate at arc.*
5. **user-enum payload TYPING -> DONE.** Matching a USER enum variant `Circle(r)` bound payload vars to a
   fresh type var (untyped) — unlike the built-in Ok/Err/Some/None path — so payload misuse went uncaught
   (a float payload used as a string unified to `string` -> the runtime treated float bits as a string
   pointer = type confusion). Fix: record ordered payload field type annotations per variant (new TiState
   `ti_variant_ptypes`, populated in the enum pre-pass), and at match bind each positional binder to the
   DECLARED type. Conservative — concrete types only (empty/generic/`var` -> fresh, no regression).
   gen4-verified: bad test (float payload -> needs_string) COMPILED on old gen3 (unsound) but is REJECTED on
   gen4 (hole closed); int-payload OK test runs (move sum=7, wait=10); existing enum tests byte-identical
   gen3/gen4 (no regression). Compiler-only. *Reconverge at arc.*
   **DISCOVERED (task 5, separate pre-existing CODEGEN bug):** a FLOAT enum payload extracts as its raw
   IEEE-754 i64 bit-pattern (garbage, e.g. `str(r)`=4617315517961601024 for 5.0) instead of unboxing to a
   float — happens for the single-field float variant (`Circle`) routed through an `any`-typed fn param; the
   2-field `Rect` and direct single-variant `F(x:float)` unbox fine. Identical on gen3 -> NOT my change;
   boxed-float-through-any-variant unbox class. High-value (enums with float data are common). Next task.

   **FULL DIAGNOSIS (for the fix, do empirically after the arc):** The match-arm payload binder codegen at
   nova_compiler.nova ~8531-8544 (`m_pt == "pat_ctor"` loop) emits `field_get m_fd ir_type_any() [subject]
   m_fpv m_fi` and then sets the binder's codegen type via `ir_match_ok_payload_stype` — which returns a
   type ONLY for built-in Ok/Some (7479). For a USER variant it returns "" -> `b.ir_locals[m_fpv] = 1`
   (the any/default code). So the binder's static type is lost. Consumer = `ir_expr_struct_type` (8738-41):
   for an ident it returns `b.ir_locals[ev]` when that is a struct name OR a builtin-type name
   (`_is_builtin_type_name` @8702 = int/float/string/list/dict/bool). So the ENCODING to set is the
   declared type STRING ("float"), not `1`. The variant's ordered field types are already available as
   `b.ir_sdefs[m_pv]` = list of `Param(name, type, _)` (populated @18082). FIX TEMPLATE (mirror the struct
   field-access path @8316-8333): for each payload position m_fi, read `b.ir_sdefs[m_pv][m_fi-1]` -> field
   ann; set the `field_get` result type (float/int/str) like @8324-8329 AND set `b.ir_locals[m_fpv]` to that
   ann string. CAVEAT/why empirically: `Circle`(1 field) corrupts but `Rect`(2 fields, same enum) works —
   so the raw-vs-boxed representation of variant scalar payloads may differ by arity; setting ir_locals=
   "float" on an already-correct (Rect) path could BREAK it. MUST build gen4 + test Circle AND Rect AND F
   AND existing enum_test/enum_full_test, iterate. Also 3 match codegen sites exist (~8503, ~9406, ~9676) —
   check which the repro hits. DEFERRED to a focused build-test loop right after the Wave-A arc.

### Batch 2 (breadth + runtime builtins) — reconverge in progress
- **task 5 float-enum-payload** → FIXED + CERTIFIED (`29e380c1`). See Stream-1 table + memory.
- **Breadth Wave-1 (Stream-2 fleet, 4/4 landed):** forge_xmlparse (`a051c26a`), forge_signum + forge_blake2b
  + forge_hamt (`d708af6f`). Each KAT-gated by an impl agent + ADVERSARIALLY VERIFIED by a second agent that
  independently recomputed the KATs — the verify pass caught + forced fixes to: hamt (was a flat 32-bucket
  table, not a trie → real leaf/internal split, maxdepth 3-4 at scale), signum (sn_from_int(INT_MIN) double-
  minus corruption → parse str(i)), blake2b (missing out_len/key validation). Pure-NOVA LEAF modules → no
  reconverge; canonical import tests in the manifest.
- **D11 extended math** (isnan/isinf/clamp/copysign/fma/nextafter/lgamma/erf) + **D8 seedable PRNG**
  (xoshiro256** over a 32-byte NOVA-managed bytes state: rng_new/rng_next/rng_int/rng_float). Runtime +
  compiler (name-map, type schemes, 2× LLVM declares, raw-double lists). gen4-tested: D11 14/14, D8 5/5
  (determinism/seed-independence/range/reproducibility). Reconverge (gen5==gen6) + full both-mode regression
  running now — validates D11 + D8 AND re-certifies the 4 breadth modules. Commit after green.
