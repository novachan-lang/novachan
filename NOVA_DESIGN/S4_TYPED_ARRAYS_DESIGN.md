# S4 — Typed Contiguous Arrays (the #1 perf item, the NOVA way)

**Status: DESIGN (2026-06-20).** Measured gap: float array sum `xs[j]` = ~120x C. Foundation
(NovaTensor raw `double*`) exists. This doc = the architectural design; infra-specific line refs
filled in from the list-infra exploration.

## The problem (measured + IR-confirmed) — and the KEY asymmetry
| Array kind | NOVA vs C @ -O2 | storage | xs[j] lowering | cause |
|---|---|---|---|---|
| **int** (`intlist`) | **2.3x** (118ms vs 51ms) | RAW int64 inline | **native load (0 runtime calls!)** | only bounds-check + no-SIMD residual |
| **float** (`floatlist`) | **120x** (10.9s vs 91ms) | **HEAP-BOXED** (`append_fbox` -> NovaBox per elem) | unbox path | scattered heap derefs + box alloc |

★★ DECISIVE FINDING (2026-06-20): the fast path ALREADY EXISTS and is PROVEN SOUND for ints. `intlist`
does raw inline storage + native-load lowering today -> 2.3x C. The 120x float gap is a pure ASYMMETRY:
ints are stored raw (an int is its own value, find_tag-safe), but **floats are BOXED solely because a raw
double bit-pattern read as `any` confuses find_tag** (the historic int/float CVE class -- a double's high
bits look like a pointer/large-int). So S4 is NOT a new representation -- it is: **mirror the proven
intlist mechanism for doubles + add a per-list `element_kind` so the `any`-boundary boxes floatlist
elements correctly.** The native-load lowering, the @het@ poison, the floatlist detection, and the "fl"
marker are all already in the compiler (see Existing Infra below). Much lower risk than first framed.

## Existing infra to REUSE (from list-infra exploration, file:line)
- Runtime `NovaList {int64_t* data; int64_t size; int64_t cap;}` (nova_runtime.c:1049) -- NO element-kind
  field yet (the one field to add). `NovaBox {kind; payload}` (644) boxes floats/bools.
- Runtime `NovaTensor {double* data; ...}` (10968) -- the proven raw-double contiguous representation.
- Compiler IR type registry `ir_reg_type` with values `"intlist"`/`"floatlist"`/`"list"`/`@het@` poison
  (13567, 13987-14015, 13817-13862). make_list detects all-int->intlist, all-float->floatlist; append
  promotes/poisons; **@het@ is sticky -> a heterogeneous append demotes to "list" and never re-promotes.**
- index_get specialization (14020-14036): intlist->native int load; floatlist-> "fl" marker -> raw double.
- `fpt` whole-program param typing (ir_collect_param_types, 14488-14530); `ir_list_elem_stype` (struct
  element tracking pattern, 8553-8596) -- the template for tracking a list local's element kind.
- index_get lowered at ir_lower_expr (8035), make_list at (7983), push->nova_rt_list_append at (7593+).

## The float-any soundness problem (THE crux, what the boxing currently buys)
Floats are boxed so that `find_tag`/`any`-dispatch can tell a list element is a float (not int/pointer).
Removing the box requires the runtime to know, PER LIST, that elements are doubles -> `element_kind=2`.
Then: the TYPED read (compiler proved float) returns raw double bits (fast, no box); an ANY read goes
through a runtime op that sees element_kind=2 and BOXES on demand (sound). This is the same box-float->any
discipline already shipped for scalar float-any (the int/float soundness fixes). element_kind makes it
work for list elements.

## The NOVA-way constraint (the hard part)
ZERO annotations. The developer writes `let xs = []`, `push(xs, 1.5)`, `xs[j]` -- no `float64[]` type,
no `Vec<f64>`. The **compiler must INFER** that `xs` is a homogeneous float array and back it with
contiguous unboxed storage + native loads. Harder than Julia/Rust (where the user declares the array
type). This is the genius-compiler bar: the common numeric case must "just be fast," no ceremony.

## Decision: HYBRID (runtime typed storage + compile-time native lowering)
Three approaches considered:
- **A. Pure static** (compiler proves type, emits native load): needs contiguous unboxed storage anyway,
  and needs the runtime to still support boxed for the unprovable case. So the runtime change is required
  regardless.
- **B. Pure runtime typed-list** (NovaList gains elem_kind, index_get fast-paths homogeneous): removes the
  box-deref (120x -> ~10x) but KEEPS the per-element runtime CALL -> still opaque, no vectorization.
  Insufficient for match-C, let alone beat-C.
- **C. HYBRID (CHOSEN)**: runtime gains an unboxed contiguous mode (B's storage) AND when the compiler
  PROVES the element type it lowers `xs[j]` to a native inlined `gep+load` (A's lowering), bypassing the
  call. Unprovable -> runtime call (handles both modes, correct, current speed). Best of both, sound.

## Soundness invariant (the keystone -- a single hole = type-confusion/UAF)
A list is EITHER **fully-compiler-managed-unboxed** (proven homogeneous for its WHOLE lifetime; native
loads valid; runtime NEVER deopts it) OR **fully-runtime-boxed** (current). **No mid-life transition** for
a specialized list. The compiler emits the native unboxed path ONLY when it has proven no heterogeneous
write can ever happen to that list -> the runtime's `elem_kind` is set once at creation and never changes
-> the native load can never read a pointer as a double. Unprovable -> boxed forever (correct, current
speed). This is the same discipline as the total-RC/W5b work: **only ever ADD specialization where provably
safe; a false negative is slow-but-correct, a false positive is unsound -> bias hard to conservative.**

## Inference rule (when is `xs` provably homogeneous-scalar?)
Specialize a list variable to unboxed-double (kind=2) / unboxed-int (kind=1) iff ALL hold:
1. Every WRITE site (list-literal element, `push`, `xs[i]=v`) writes the SAME scalar kind (all float, or
   all int). A float-literal/float-typed value -> kind 2; int-literal/int-typed -> kind 1.
2. NO write of a non-scalar (string/list/struct/bytes/any) anywhere in the list's lifetime.
3. The list does not ESCAPE to a context that could append a different kind or read it as a mutable `any`:
   - returned/stored where its static type is lost to `any` with a possible heterogeneous append -> deopt.
   - passed to a function not proven kind-preserving -> deopt (conservative). (fpt's whole-program call-site
     typing -- `ir_collect_param_types` -- is the analogous existing mechanism; reuse its discipline.)
4. Reads-as-`any` that only OBSERVE (print, to_json, ==, len, send) are FINE -- the runtime path boxes on
   demand. Only writes/mutations-to-different-kind disqualify.
Default when anything is ambiguous: **boxed** (current behavior, correct). Conservative by construction.

## Representation
Reuse the NovaList struct + add `elem_kind` (0=boxed/heterogeneous [current], 1=int64-inline,
2=double-inline). When kind!=0, `data` is a contiguous `int64_t[]`/`double[]` (values inline, NOT boxed
pointers). **find_tag/RTTI UNCHANGED**: a typed list still tags as a LIST; `any`-dispatch goes through the
runtime which is mode-aware (less invasive + safer than a new first-class tag; cf. the NovaBytes tag work,
which was needed there because bytes had no list identity -- here we reuse list identity).

## Every runtime list op becomes mode-aware (the bulk of S4.0)
index_get/index_set, append/push, len, to_str, eq (nova_rt_eq deep compare), deep_copy (kind!=0 ->
single memcpy of the raw buffer -- FASTER), free, sort, contains, slice, channel-send (homogeneous
double[] is trivially Sendable -> memcpy, faster). Default kind=0 -> byte-identical to today.

## Value-model interaction (verified safe)
- **arena/RC**: the raw buffer lives in arena (per-request) or RC heap (long-lived), same as today's
  NovaList backing -- no new lifetime rules.
- **deep_copy / channels**: kind!=0 copies/sends via one memcpy (faster than element-wise boxed copy);
  Sendable trivially (no inner pointers).
- **any-access**: runtime ops box-on-demand for any-consumers; correctness preserved.

## ★★★ FINAL ARCHITECTURE (post-adversary 2026-06-20 — SUPERSEDES "Decision: HYBRID", "Soundness invariant", and the per-variable "param-mutation taint" idea below)
The 12-attack adversarial review found the fatal flaw: **NOVA lists are REFERENCE types** (`let ys = xs`
aliases the same `NovaList*`), the compiler has **no alias analysis**, and my "compiler proves homogeneity ->
native load BYPASSES the runtime" plan lets aliasing/struct-fields/dict-values/escape mutate the shared
buffer heterogeneously while a native load reads it as raw doubles -> type confusion. A compile-time proof
(even with escape/param-mutation taint) CANNOT be made airtight without full alias analysis. So invert it:

**RUNTIME is the single source of truth; the compiler's native load is a GUARDED, hoistable HINT.**
1. **Runtime invariant (authoritative):** NovaList.`elem_kind` in {0=boxed, 1=int64-raw, 2=double-raw}.
   Empty `[]` starts kind=0; the FIRST append sets the kind (int->1, float->2, other->0). Any append/set
   of a CONFLICTING kind **DEOPTS** the list: kind 1->0 is cheap (raw ints are valid boxed elements; just
   box the new non-int, set kind 0); kind 2->0 RE-BOXES all existing doubles (O(n), rare) then sets kind 0.
   Because EVERY write goes through the runtime append/set, **every alias observes the deopt** -> the
   invariant "kind==2 => all data[] are raw doubles" holds under arbitrary aliasing. SOUND by construction.
2. **All list reads are mode-aware:** index_get/len/eq/sort/to_str/deep_copy/concat/repeat/map/filter/... 
   branch on elem_kind. An `any`-returning read of a kind-2 element **boxes the double on the way out**
   (closes the find_tag/int-pointer CVE class). deep_copy/channel-send of kind!=0 = memcpy (never find_tag
   on raw bits). NEVER rc_inc/rc_dec a raw scalar element (kinds 1/2). [adversary attacks 3,5,6,8,11]
3. **Compiler emits a GUARDED native fast-path** (replaces the current UNGUARDED intlist native load that
   the escape probe proved unsound): `xs[j]` -> `k = load xs.elem_kind; if k==<K> { bounds-check; native
   gep+load on xs.data } else { call nova_rt_index_get(xs,j) }`. In a loop that does NOT mutate xs, LLVM
   LICM hoists the `k` load + the `xs.data` base out of the loop and auto-vectorizes the native arm ->
   read-only numeric loops hit ~intlist speed. In a mutating loop, the append is an opaque call that may
   write xs.data/size, so LLVM conservatively re-reads them each iteration -> realloc-safe. [attacks 1,2,4]
   The guard means the compiler's inference is now only a PERF HINT: a wrong guess = slow (runtime path),
   never unsound. Aliasing/polymorphic-helper/struct-field/dict cases all fall to the runtime path safely.

WHY THIS BEATS the compile-time-proof approach: soundness no longer depends on alias analysis NOVA lacks;
the runtime enforces it; the guard is the firewall the native load was missing. The residual cost (one
well-predicted branch on scattered access; hoisted to ~free in hot read loops; rare O(n) float deopt) is
the price of soundness and is acceptable. This ALSO fixes the pre-existing intlist escape bug below.

## ★ IMPLEMENTATION CONSTRAINT (runtime.c:1049-1063) — elem_kind must be APPENDED, not inserted
NovaList `{int64_t* data; int64_t size; int64_t cap;}` (1049) and NovaBytes `{uint8_t* data; size; cap;}`
(1059) share the SAME layout ON PURPOSE: find_tag's structural validation predicate (the int/pointer
soundness hardening) keys off data/size/cap. So: add `int64_t elem_kind;` as the **4th field AFTER cap**
(grows sizeof(NovaList) -> all `nova_heap_alloc(sizeof(NovaList))` sites auto-size; just init elem_kind=0
at each). Read elem_kind ONLY after the RC-header tag == NOVA_MEM_LIST is confirmed (NovaBytes has no 4th
field -> never read elem_kind on a bytes object). The first-3-field structural predicate is UNAFFECTED.
Creation sites to init: nova_rt_list_create (1099), list_create_filled (1108), and any other
`nova_heap_alloc(sizeof(NovaList)` — grep all before editing. deep_copy uses list_create -> covered.

## ★★★ S4.1 RESOLVED DESIGN (2026-06-20, from the recon + the downstream-typing crux)
Recon (workflow wnvmf2az8) mapped ~20 write sites + ~22 read/egress sites + confirmed find_tag safety:
- find_tag reads the RC tag, NOT elem_kind; NovaBytes is intercepted before the &0x7 LIST mask; the
  {data,size,cap} prefix is byte-identical -> reading elem_kind after a confirmed NOVA_MEM_LIST is SOUND.
  **S4.0 foundation independently confirmed safe.**
- The real kind=2 hazard = ~10 sites feed a RAW element word into find_tag (eq:4012, hash:10927,
  contains:2006, index_of:10426, list_to_str:1384, elem_to_str:3701, json_stringify:3381, deep_copy:2339,
  set_*). For kind=1 (raw INT) these are ALREADY SOUND (find_tag correctly rejects a bare int). The CVE
  hazard is specific to kind=2 (raw DOUBLE bits can fake a heap address). => **kind=1 (S4.1) is far safer
  than kind=2 (S4.2).**
- ~20 write sites each need kind-awareness (set-on-first / deopt-on-conflict / skip rc on raw kinds);
  many are easy-to-miss (list_set, insert, remove, pop, concat, reverse, sort, map/map_fbox, filter,
  slice, set_add/has/remove). deep_copy/channel for kind 1/2 = memcpy the block (no find_tag).

★ THE CRUX (downstream-typing tension): a GUARDED read `if elem_kind==K native else runtime` cannot
preserve NATIVE INT ARITHMETIC downstream, because the compiler types xs[j] STATICALLY. If a list can
deopt (kind!=1 at runtime), the element is genuinely not an int, so downstream MUST be the any-path; but
native int arithmetic requires a static `int` type. => the native-int fast path REQUIRES a static proof
the list can never deopt. The runtime guard alone can't give that (aliasing). Two regimes, irreducibly:
  (A) PROVABLY-NON-DEOPTABLE intlist -> unguarded native int read, typed int, native arithmetic. FAST.
  (B) POSSIBLY-DEOPTABLE intlist -> read typed `any`; `if elem_kind==1 raw-int(as any) else index_get`;
      any-arithmetic. CORRECT, slower. (deopt+guard handles aliasing/escape uniformly.)

★ SOUNDNESS NOTE on (A): a compile-time-only proof of "non-deoptable" CANNOT be complete — local
aliasing (`let ys=xs; push(ys, nonint)`) mutates the shared object invisibly to xs's per-slot analysis
(adversary attack 1). So regime (A) is sound ONLY for a list proven SINGLE-REFERENCE: a local used
exclusively as push(xs,_)/xs[i]/xs[i]=_/len(xs), NEVER aliased (RHS of assign), passed to a fn, stored
in a container/struct, or returned. That syntactic linear check is decidable and conservative. Everything
else -> regime (B) (correct via runtime deopt+guard). Read-only escape (sum(xs)) lands in (B) for S4.1
(perf regression vs today's UNSOUND-fast) and is recovered in S4.2 via whole-program param-MUTATION taint
(a fn that never appends a conflicting kind to a param is deopt-safe -> caller keeps regime A/fast).

★ RUNTIME DEOPT (authoritative, needed for regime B + to make the pre-existing bug correct under ALL
aliasing): elem_kind starts 0; set 1 on first proven-int append; a conflicting append (float/bool/str/
ptr) DEOPTS to 0 (kind1->0 is FREE: raw ints are valid kind-0 elements, no rebox). To avoid find_tag in
the hot int-build loop, the compiler emits a DISTINCT append for statically-known ints
(nova_rt_list_append_iknown -> sets/keeps kind 1, no classify); plain nova_rt_list_append (any/unknown)
+ append_fbox/bbox conservatively DEOPT a kind-1 list to 0 (fbox/bbox are known-non-int; plain-any uses
a cheap find_tag-reject-bare-int test, false-positive=safe-slow). kind=2 (raw double) deferred to S4.2
(the ~10 find_tag-egress sites + rebox + RC-skip land together there).

## REVISED STAGING (authoritative)
- **S4.0 (runtime, soundness floor):** add `elem_kind`; first-append sets kind; conflicting append DEOPTS
  (kind1->0 cheap, kind2->0 reboxes); make EVERY list op mode-aware incl. any-read box-on-egress + no
  rc on raw scalars. Default path (kind 0) byte-identical. GATE: full regression both modes + ASAN +
  an adversarial suite (alias, struct-field, dict, deep_copy, sort-negatives, empty-then-hetero-push).
- **S4.1 (compiler, fixes the pre-existing bug):** replace the unguarded intlist native load with the
  GUARDED form; verify _escprobe now prints 1,2,3.5,4 AND `sum(intArray)` stays native+hoisted. RECONVERGE.
- **S4.2 (runtime+compiler):** float kind=2 raw storage path (append_fraw, no box) wired at the existing
  floatlist detection + guarded native double load. GATE: float array-sum 120x -> ~2.3x C. RECONVERGE.
- **S4.3:** coverage (index-set, slice, nested, 2D->NovaTensor) + the full adversarial regression.
- **S4.4 (BEAT-C):** SIMD — close the 2.3x (bounds-check elision where provable + reduction vectorization;
  FP-reduction needs a fast-math `sum` contract; int reductions auto-vec cleanly).

## ★★★ S4.1 SHIPPED (2026-06-20) — index_get-only single-reference gate (scoped subset of the plan)
What actually shipped (smaller than the full regime-A/B plan above, after two regressions forced a
simplification): a compiler single-reference TAINT (`ir_safe_list_use` + `ir_scan_list_taint`:
default-taint-at-use; safe = pos0 of index_get/index_set or a `nova_rt_*` call EXCEPT sort/sort_by which
return-alias) consumed at ONE point — the **index_get gate**: a tainted (escaped/aliased) list's index
READ returns a generic boxed value (via the args[0] @slot@ taint check; `copy` propagates @slot@), WITHOUT
changing the list's TYPE. This fixes the pre-existing intlist-escape bug (`_s4_escbug`) for the index-read
path + the alias/sort-alias cases (`_s4_adv_int`, `_s4_adv_int2`).

WHY NOT the type-demotion design: demoting intlist/floatlist→"list" CASCADED — list_min/max/sum select the
int variant ONLY for exact "intlist" (1 became 1.0; broke track7) and floatlist→list mixed boxed reads
into raw-float math (e-156 garbage; broke math3d). The index_get gate avoids the cascade entirely.

SCOPE LIMIT (deferred to S4.2 runtime deopt): print_intlist / list_min/max/sum / floatlist READS of a list
that ACTUALLY went heterogeneous via escape remain unsound — not exercised by any test; the proper fix is
the runtime elem_kind deopt + box-on-egress (the authoritative design above). S4.2 supersedes this gate.
Gate: reconverged gen5==gen6 594A7BBE; NORMAL 540/540; FULLRC 539/540 (1 = a transient parallel-run
contention crash of the non-concurrent _s4_adv_test, 8/8 stable in isolation).

## ★★ PRE-EXISTING SOUNDNESS HOLE FOUND (2026-06-20) — fixed by S4.0+S4.1 above (kept for the record)
EMPIRICAL (current shipped compiler, _escprobe): an `intlist` (raw int64 storage + native load, ALREADY
shipped) that ESCAPES to a function which appends a non-int is CORRUPTED. Repro:
```
fn addfloat(lst)   push(lst, 3.5)
fn main()
    let xs = []   push(xs,1)  push(xs,2)   addfloat(xs)   push(xs,4)
    # read back -> prints 1, 2, 2659068203608, 4   (element 3 = a BOX POINTER read as raw int)
```
ROOT CAUSE: main marks xs `intlist` and never demotes on escape; fpt types addfloat's param `intlist`;
addfloat boxes the float (append_fbox) INTO the raw int64 array; main reads xs[2] as a native raw int ->
reads the box pointer as an integer. This is the int/pointer CVE class (project-int-pointer-soundness).
Today it is a wrong-answer; it becomes a CRASH if that value flows to any-dispatch/find_tag, and S4's
raw-DOUBLE storage would make it FLOAT corruption (string escape-appended into a raw double[]).

THE SOUND FIX (S4.0, also fixes the pre-existing bug): a typed list (intlist/floatlist) must be DEMOTED to
generic boxed in the CALLER if it is passed to a function that could make it heterogeneous. NOT "any escape"
(that kills the common read-only `sum(xs)`/`dot(xs)` pattern). The condition = whole-program param-MUTATION
taint: a list param that is appended-to with a CONFLICTING kind (transitively) taints the caller's list ->
demote to boxed. Read-only params (sum/mean/dot/map-source -- the vast majority of array-consuming fns)
stay fast. fpt already walks all functions per call site; extend it with a per-param "append-taint" fixpoint
over the call graph. Conservative bias: if unsure whether a callee mutates the param's kind -> demote (slow
but correct). VERIFY: _escprobe prints 1,2,3.5,4 after the fix; the common `sum(intArray)` stays native.

## Staging (REFRAMED: intlist already does raw-storage+native-load @ 2.3x C; bring floatlist to parity)
- **S4.0 (SOUNDNESS FLOOR, do FIRST):** close the escape hole above (param-mutation taint -> demote). GATE:
  _escprobe correct + regression both modes + ASAN. This is a pre-existing-bug fix; it must land before any
  raw-float storage. Adversary review in flight may add sibling vectors to cover together.
- **S4.0** runtime: add `element_kind` (0=boxed[current], 1=int64-raw, 2=double-raw) to NovaList; make every
  list op mode-aware; for kind=2, data[] holds RAW double bits; an ANY/find_tag read of a kind=2 element
  BOXES on demand (the soundness keystone). Default 0 -> byte-identical. ASAN + full regression both modes.
- **S4.1** runtime: float fast paths -- `list_append_fraw` (store raw bits, no box) + kind-2 index returning
  raw double; deep_copy/channel-send of kind-2 = single memcpy; eq/to_str/sort kind-2-aware.
- **S4.2** compiler: at the EXISTING floatlist creation/append, emit the kind=2 raw path instead of
  append_fbox; the @het@/escape guard must be sound for the STORAGE switch (not just the read marker) --
  the soundness-critical step under adversary review.
- **S4.3** compiler: lower floatlist `xs[j]` to a native raw-double load (mirror the intlist native load
  that already emits 0 runtime calls). GATE: float array-sum 120x -> ~2.3x C (intlist parity); regression
  both modes + ASAN; RECONVERGE.
- **S4.4** coverage: index-set, slice, nested lists; 2D+ reuse NovaTensor.
- **S4.5 (BEAT-C)** SIMD: close the residual 2.3x (BOTH int & float) = bounds-check + no auto-vec. C
  auto-vectorizes the reduction; NOVA's bounds-checked load loop does not. FP-reduction reassoc caveat:
  strict IEEE sum won't auto-vec without fast-math -> beat-C needs a reduction decision (vector reduction
  intrinsic, or a NOVA fast-math `sum` contract). Int reductions auto-vec cleanly (assoc). S4.0-4.4 =
  floatlist reaches intlist parity (2.3x); S4.5 = both -> ~1x (match) and beat-C on SIMD.

## Falsification (what would prove this WRONG)
- If the inference can't be made conservative without rejecting the common `let xs=[]; push; xs[j]` loop
  (i.e., the common case escapes in a way we must deopt) -> the win evaporates. MUST verify the canonical
  numeric loop is provable.
- If making every runtime list op mode-aware regresses the boxed path measurably -> tax on existing code.
- If find_tag-reuse lets an any-typed heterogeneous read mis-read an unboxed buffer -> UAF. The whole-
  lifetime proof must close this; ASAN + an adversarial any-read-of-typed-list test is the guard.

## ★★★ S4.2 ESCAPE-SURVIVAL — DESIGN (2026-07-07, grounded by measurement + codegen recon)

**The gap (re-measured 2026-07-07, current compiler):** `_fa_bench.nova` (push-built float array, sum
loop, no escape) = **176 ms ≈ C (171 ms)**. `_fa_bench_boxed.nova` = the SAME loop but with one
`let _ = touch(xs)` (a callee that only does `return len(ys)`) = **27390 ms = 160×C**. So the
non-escaping float path is already at C-parity; the ENTIRE remaining gap is the escape cliff. Any float
code that passes an array to any function hits it → this is THE #1 perf gap (blocks Cortex/Pulse AI).

**Root cause = compiler TYPING, not runtime.** The runtime `elem_kind` (0=boxed/heterogeneous,
1=int-raw, 2=double-raw) is a SOUND homogeneity invariant that SURVIVES escape: any conflicting write
`nova_list_deopt`s kind 2→0, and because the list is shared by reference every alias observes it. So a
list still at `elem_kind==2` after `touch(xs)` is *provably* all raw doubles. The builtins
(`nova_rt_sum/min/max`) already check `elem_kind==2` and stay fast post-escape. The ONLY slow thing is
the MANUAL `xs[j]` read loop: escape (a) demotes the register type floatlist→val and (b) sets a slot
taint flag (`nova_compiler.nova:14827-14831`), so the read at `:14836` misses the `floatlist` fast case
and emits boxed `nova_rt_index_get` → the accumulator becomes boxed → per-iteration `nova_rt_add`
(2× `find_tag` + box ALLOCATION) → 160×.

**Proven: there is NO sound read-level fix.** The fast read's dest is typed `float` (feeds `fadd`); the
boxed read's dest is `any` (feeds `nova_rt_add`). They can't be unified at the read site. And the boxed
fallback CANNOT be replaced by "coerce to double" because `nova_rt_add(float, non-numeric)` has DEFINED
observable semantics — `float + string` = **string concat** (`nova_rt_add` runtime). A was-floatlist can
hold a non-numeric after a mutating escape, so forcing `to_double` would corrupt semantics. Therefore the
two paths must be separated at the **LOOP** level, each with its own accumulator (loop-versioning).

**The design (Tier-0-safe by construction — the runtime guard cannot be "incomplete"):** for a
qualifying loop, emit
```
if nova_rt_list_is_kind2(xs):        // runtime: xs->elem_kind == 2 ? 1 : 0  (loop-invariant guard)
    let xs = _floatlist_view(xs)     // NEW: identity at runtime, result TYPED "floatlist" (fresh, untainted)
    <the loop, unchanged>            //  -> xs[j] now hits :14836 fast path -> list_get_f + native fadd
else:
    <the loop, unchanged>            // original boxed semantics, byte-identical to today
```
The `_floatlist_view` shadow is the key trick: it re-establishes `floatlist` typing on a FRESH register
(so the taint doesn't apply), and it is SOUND because it runs only inside the `elem_kind==2` guard.
Two tiny new builtins: `nova_rt_list_is_kind2` (trivial) and `_floatlist_view` (runtime identity; compiler
special-cases its result type to `"floatlist"`, like the existing floatlist cases at `:14812`).

**THE CRUX / open question the implementation must resolve first (cheap gen4 experiment):** is the
accumulator `s` typed FLOW-SENSITIVELY (float inside the fast branch, `any` after the merge) or
SLOT-UNIFIED (one slot typed `any` across both branches)? If flow-sensitive → the shadow alone works and
this is TRACTABLE. If slot-unified → the fast branch needs a separate native-float temp accumulator +
reconcile-to-`s` at branch exit (identify accumulators = float vars written in the loop & live after),
which is the fiddly part. **Validate empirically before building the auto-transform:** add the 2
builtins, hand-write the transformed source above as a probe, build gen4, and check whether the loop
emits `list_get_f`+`fadd` (fast) — measures both the shadow trick AND the accumulator behavior.

**Qualification (bail → original, byte-identical, for anything unhandled → low blast radius):** single
float accumulator; reads `xs[idx]` where `xs` is a was-floatlist tainted local and `idx` is a simple
int; the loop body does NOT mutate `xs` (no `push`/`index_set` on it — else kind could change mid-loop);
no nested capture of `xs`. Everything else uses the current path unchanged.

**Staging:** (1) 2 builtins + gen4 shadow-probe to resolve the crux. (2) auto-transform for the
single-accumulator qualifying loop. (3) generalize to N accumulators + `for` loops. (4) reconverge +
both-mode regression + perf gate (bench must go ~160×→~1×C, and EVERY non-applicable program must stay
byte-identical). Iterate stages 1-3 on gen4 (cheap ~10 min build); reconverge ONCE at the end.
Injection point = `nova_compiler.nova` while-lowering `:9181` (guard+shadow wrap) + the call-result
type special-case in the infer pass.

## Competitive check
- C: contiguous double[] -- S4.0-4.4 matches (native load), S4.5 (SIMD) beats only with reduction reassoc.
- Rust Vec<f64>: same machine code after S4.3, but NOVA needs ZERO annotation (Rust declares the type) -> NOVA wins on ergonomics at equal speed.
- Julia: typed arrays but user-declared / dynamic-dispatch fallback warmup; NOVA infers + AOT, no warmup.
- NumPy/Python: NOVA's loop is native; NumPy needs vectorized C calls to be fast (loses on scalar loops).
- Go: []float64 native but no auto-SIMD reduction either; NOVA ties at S4.4, can beat at S4.5.
