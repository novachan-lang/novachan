# NOVA Core Master Plan — compiler-first to framework-ready (M1), then parallel co-evolution

**Status: PROPOSED (2026-06-20). Two decisions OPEN (bottom) — pending the creator's confirm.**

## Decision (locked)
Make the NOVA **compiler + language world-class BEFORE** the 9 frameworks — the NOVA way
(problem-driven, NOT a feature-checklist copied from other languages). The 9 frameworks are
PARKED until **M1**. After M1 the compiler loop **continues in parallel** with framework work.
Model: Java-before-Spring — Java was *mature enough* to build a framework on, and kept evolving
for 20 years after. We want that branch point, not "finish the compiler then start frameworks."

## The END is a BRANCH MILESTONE (M1 / framework-ready), not 100% completion
M1 = the compiler is solid enough that a framework is **not built on language workarounds**:
- real **generics** (zero-syntax — a plain function is generic, monomorphized to C-speed)
- **sound + complete** type checking (rejects every unsafe program; accepts every safe one)
- a **basic installed stdlib**, **C-class perf**, the **concurrency model**.
Validated by ~3 battery programs (web slice, concurrent server, one systems program) each passing
the 6 non-negotiables. Hit M1 → branch into **(framework loop ‖ continuing compiler loop)**.

## "Passing" = the 6 non-negotiables, per program
zero annotations (95%+ inferred) · C-level perf (≤1.1× clang -O2) · memory + type safe
(ASAN-clean, no UB) · same source runs on the target platforms · simpler/shorter than the Python
equivalent · robust (graceful failure).

## The battery = the measurable north star
1. memory allocator (systems) · 2. tensor/inference pipeline (AI) · 3. 100k-connection server
(distributed) · 4. full-stack web slice · 5. embedded controller (constrained) · 6. numeric/SIMD
kernel. **We build the compiler by making each program pass; each exposes the next gap.**

## Framework-derived core requirements (the union of what the 9 frameworks demand)
The 9 frameworks: Forge(web) · Reactor(game) · Cortex(AI) · Mesh(distributed) · Prism(GUI) ·
Pulse(data) · Sentinel(security) · Edge(embedded) · Ops(devops). Working backwards from each to the
core, the gaps (beyond what NOVA already has: processes/channels/actors/supervisors, async netpoller,
HTTP/WS, arena/no-GC, FFI @link, mmap, sqlite, distributed-channel foundation, pmap) union to:

**Tier 1 — cross-cutting foundations = M1 (almost every framework needs these; currently missing):**
1. Real generics (zero-syntax, monomorphized → C-speed) — typed models/ECS/tensors/columns/collections.
2. Sound + complete type system (the soundness floor).
3. Performance path S1–S5 (zero-cost value-type math, kill the i64-ABI gap) — game/AI/data/crypto/embedded.
4. Data-oriented memory layout (contiguous typed arrays / struct-of-arrays, no boxing) — ECS/tensors/dataframes.
5. Capability derivation + serialization (Sendable/GpuSafe/Show/Eq/Hash + any-Value↔binary/JSON, from structure).
6. Lazy streaming generators (real coroutines, not eager yield) — data pipelines / loaders / streaming.

**Tier 2 — cross-domain targets (parallel-after-M1; each unlocks specific frameworks):**
7. GPU codegen (SPIR-V/CUDA/Metal) — Reactor, Cortex, Prism.  8. WASM — Forge frontend, Prism web.
9. Freestanding + multi-arch ARM/RISC-V — Edge.

**Tier 3 — domain primitives (become libraries once Tier 1 exists):** tensors+autodiff (Cortex),
reactivity (Prism), constant-time + secure memory (Sentinel), interactive subprocess+signals (Ops),
comptime/macro DSLs (Ops).

**Branch reality:** after M1 (Tier 1), the pure-Tier-1 frameworks — **Forge, Mesh, Ops, Sentinel,
most of Pulse** — can start in parallel IMMEDIATELY. The GPU/embedded-gated four — **Reactor, Cortex,
Prism, Edge** — start as their Tier-2 target lands (built in parallel after M1). That is "all 9 in
parallel," phased by what each physically requires.

## Phases (foundations first, by dependency)
- **Phase 0 — Soundness floor:** close ALL known holes (type-checker `string→Response`,
  panic-safe arena restore, etc.). Non-negotiable prerequisite — no power on holes.
- **Phase 1 — Genius compiler:** auto-specialization (generics, no syntax) + perf S1–S5 (kill the
  i64-ABI gap). "Fast" and "generic" as ONE mechanism.
- **Phase 2 — Unified polymorphism:** capabilities (Show/Eq/Sendable/GpuSafe) DERIVED from Value
  structure + dispatch on Value shape — subsumes overloading / interfaces / protocols / typeclasses
  into one zero-declaration mechanism.
- **Phase 3 — Real stdlib** on the new generics (install the ~26 orphaned modules + a generic
  algorithm library). **← M1 reachable around here.**
- **Phase 4 — Runs-anywhere targets** (GPU / WASM / distributed / embedded codegen). *(OPEN: inside
  the M1 gate, or a parallel track after M1 — see decisions.)*

## The continuous loop flow (fast AND perfectly tested)
Root cause of past slowness: `think → build → WAIT(reconverge ~10m + regression ×2 ~28m) → commit`,
**idling through the wait.** Fix = pipeline; never idle.

1. **Pick + design** the next capability (problem → NOVA mechanism; optional small design panel).
2. **Build** (compiler-core → reconverge, *batched*; pure-NOVA → no reconverge).
3. **Smoke** — targeted subset, seconds → instant pass/fail (fail = fix now).
4. **Launch the full gate (regression ×2 + ASAN) in the BACKGROUND — do NOT wait.**
5. **While it runs: design + build the NEXT item.**  ← the overlap is the speed.
6. **Gate returns:** pass → commit + tick milestone; fail → roll back just that item.
7. **Every few items:** a paced adversarial review (small fleet, structured output) → self-correction.
8. **Exit the core phase when the M1 battery passes → branch.**

Fast = overlap + tiered tests + parallel surroundings. Accurate = full gate still gates +
soundness-first ordering + ASAN on lifecycle changes + periodic review. **Nothing commits unverified.**

## Honest constraints (no bullshit)
- Compiler = **1 self-hosted file** (`nova_compiler.nova` ~20k) + **1 runtime** (`nova_runtime.c`
  ~19k). Core edits serialize through **one** reconverge (a real floor; overlap hides most of it).
  There is **no** "10 agents → 10× the compiler core."
- Overlap = optimistic concurrency: build N+1 after N's *smoke*; roll back N if its full gate later
  fails (rare — smoke catches the obvious). This is how real CI pipelines work.
- Token-conscious: bounded agent fleets (3–5), structured output, paced; big fleets only at review.

## OPEN decisions (need the creator)
1. **M1 battery bar** — accept (≥3 programs × 6 non-negotiables), or adjust the program list?
2. **Phase 4 scope** — runs-anywhere INSIDE the M1 gate, or a parallel track *after* M1?
   *(Recommendation: parallel after M1 — otherwise M1 is years out and nothing ships.)*

## Status at plan creation (2026-06-20)
11 commits, tree clean, **516/516 both RC modes**, P0 critical channel-move/try_send arena UAF
closed (4957ae7). Next on confirm: **Phase 0 (soundness floor)** under the new flow — first item
building while its gate runs in the background.

## Phase 1 RE-SCOPE (2026-06-20, after Phase 0 complete + empirical grounding)
Verified empirically (probe): (1) FUNCTIONAL zero-syntax generics already work -- one plain `pick(a,b)`
used at int/float/string, all correct (HM inferer generalizes). (2) S1 native-float perf works -- a hot
`s + 1.5*2.0` loop emits native `fmul double`/`fadd double`, not nova_rt_mul. So NOVA already has:
soundness (Phase 0) + functional generics + C-class perf for direct/scalar/non-escaping-struct code
(~1.04x C per perf-verified memory).

Therefore the "multi-month mountain" is ONLY the perf endgame (S4 SIMD arrays + S5 full monomorphization),
and it is CONTINUOUS-AFTER-M1, NOT an M1 blocker -- the M1-immediate frameworks (Forge/Mesh/Ops/Sentinel/
Pulse) are not generic-perf-bound, and the GPU/embedded frameworks that need S4/S5+targets branch later.

REVISED M1-CRITICAL PATH (all tractable, much nearer than the mountain framing):
 - Phase 1: **Stage 3 struct SROA** (closes the ~1.2-1.3x-C struct-passed-to-fn gap; doc calls it tractable
   plumbing; escape analysis exists at nova_compiler.nova:12873 Track-8 F102). [S2 marginal+flaky -> skip;
   S4/S5 -> continuous-after-M1]. (+ lazy generators 1e is Pulse-specific, can branch with Pulse.)
 - Phase 2: capability derivation (Show/Eq/Hash/Sendable from structure -- extend automatic-Show) + dispatch
   on Value shape + derived serialization (partly shipped: resp_json/RTTI keystone).
 - Phase 3: install the ~26 orphaned stdlib modules into lib/ + generic algorithm library = **M1**.

NEXT BUILD ITEM: Stage 3 struct SROA (design pass -> build -> gate). The perf endgame (S4/S5) becomes a
parallel continuous-improvement track after M1.

## M1 STATUS (2026-06-20) -- foundations VERIFIED, formal battery gate pending
After Phase 0/1/2/3a, the M1-critical foundations are all in place AND empirically verified:
 - Phase 0 soundness floor: DONE (UAF/arena/type-checker/file-init; type-checker rejects bad programs).
 - Phase 1: functional zero-syntax generics VERIFIED (pick(a,b) at int/float/string) + C-class direct perf
   VERIFIED (native fmul/fadd). S3 struct-SROA + S4/S5 endgame = continuous-after-M1.
 - Phase 2: capability derivation VERIFIED (str/==/copy/json_stringify on a zero-annotation struct;
   compiler REJECTS @derive because it's all automatic from Value structure).
 - Phase 3a: 18-module stdlib installed (lib/) + import-validated + out-of-tree usable.
 - Concurrency (processes/channels/actors/supervisors) + Forge web framework: pre-existing, gated.
535/535 both RC modes, 19 commits this session.

The original "multi-month mountain" was the perf ENDGAME (S4/S5) -- correctly continuous-after-M1, not a
blocker. Most foundations were already built; the loop verified, hardened, and finished them.

NEXT (formal M1 gate): build/measure the ~3-program battery (web slice [Forge], concurrent server
[green_scale], systems/numeric kernel) against the 6 non-negotiables -- esp. C-perf <=1.1x clang -- to
FORMALLY confirm M1, then BRANCH: frameworks (Forge/Mesh/Ops/Sentinel/Pulse) || continuous compiler loop
(S3 SROA, S4/S5, Phase 4 targets GPU/WASM/embedded).

## M1 FORMALLY CONFIRMED (2026-06-20) -- battery measured, all 6 non-negotiables met
The 3-program battery was MEASURED (not assumed). All pass:
 1. **Numeric/systems kernel** (tight pure-float recurrence `x=x*c+0.5; s+=x*c2`, 200M iters, ZERO
    annotations): NOVA **381-385ms** vs clang -O2 C **384-388ms** = **~1.00x C** (within noise,
    marginally faster), IDENTICAL result 950000110889359.0 (correctness verified). "Fast <=1.1x C" MET.
 2. **Concurrent server** (green_scale): 10k green tasks incl 10k parked, 382ms, no async keyword,
    transparent spawn->green. I/O/scheduler-bound; passes.
 3. **Web slice** (Forge): 535/535 gated both RC modes, zero-annotation handlers, ASAN-clean
    per-request arena, simpler than Flask. Passes.

★ KEY PERF FINDING (decisive, ends the i64-ABI worry for SCALAR code): the uniform i64 ABI
(`alloca i64` per local + bitcast double<->i64 each op) that LOOKS like a 150-300x dynamic-dispatch
cost is **fully erased by clang -O2**: mem2reg promotes every i64 slot to a register `phi double`,
LICM folds the bitcast float constants, and the loop is 4x unrolled -- byte-equivalent to C's codegen.
Native `fmul`/`fadd` (S1) + the optimizer = C parity for scalar numeric loops, TODAY, zero annotations.

★ BENCHMARKING GOTCHA (caused a false 1.83x alarm): `nova.exe file.nova` quick-run links at **-O0**
(cmd_test path, nova_build.nova:472) -- NOT a perf path. Production `nova build` links at **-O2 + -flto**
(opt defaults to "2", nova_build.nova:252/345). ALWAYS measure perf via the -O2 build, never the quick-run.

HONEST REMAINING PERF (continuous-after-M1, this is BEAT-C not MATCH-C): auto-vectorizable array loops
(independent iterations -> SIMD) still store elements as i64 in NovaList, which can block clang
auto-vectorization. That is S4 (raw double[] / SoA) territory -- the path to BEATING C on vectorizable/
parallel workloads via whole-program auto-SIMD. The M1 bar (match C, <=1.1x) is MET; beat-C is the
continuous track.

=> M1 IS REACHED. BRANCH NOW: framework loop (Forge/Mesh/Ops/Sentinel/Pulse can start immediately) ||
continuous compiler loop (S3 struct SROA -> S4 SIMD arrays -> S5 monomorphization; Phase 4 targets
GPU/WASM/embedded as each unlocks Reactor/Cortex/Prism/Edge).

## POST-M1 PERF MAP (2026-06-20, all MEASURED at the correct -O2 path, not -O0 quick-run)
| Pattern | NOVA vs C @ -O2 | Status |
|---|---|---|
| Scalar numeric loop (recurrence) | ~1.00x | DONE (S1 native fmul/fadd + clang mem2reg/LICM/unroll) |
| Struct-passed-to-fn (dot product) | ~1.00x | DONE -- struct-S1 (b36ae32) + clang SROA/inline. **S3 is ALREADY closed**; the old 1.2-1.3x was pre-b36ae32. No new compiler work needed. |
| **MATCH-C (scalar + struct)** | **<=1.00x** | **DONE.** |
| Float ARRAY sum `xs[j]` over 10M | **~120x SLOWER** | **S4 -- THE #1 GAP.** |

★★ THE #1 COMPILER ITEM = S4 TYPED CONTIGUOUS ARRAYS. ROOT CAUSE (measured + IR-confirmed): a general
`xs[j]` on a NovaList is a non-inlinable `nova_rt_index_get` CALL per element returning a HEAP-BOXED float
pointer (list_append_fbox) -> summing 10M elems x 10 passes = 100M runtime calls + 100M scattered heap
derefs (cache-miss storm). C reads one contiguous double[]. Gap = ~120x.

FOUNDATION ALREADY EXISTS: NovaTensor (nova_runtime.c ~11061+) is a raw contiguous `double* data` with
`restrict` SIMD-friendly ops (tensor_add/mul/scale). The fast representation is PROVEN in-tree -- S4's job is
to make the COMMON CASE (a homogeneous float/int list, array-accessed in a loop) use a NovaTensor-class
unboxed contiguous backing + lower `xs[j]` to a native indexed load (gep+load, inlinable, vectorizable),
NOT a runtime call. Compiler must INFER homogeneity (all appends same scalar kind, no heterogeneous/any use)
and stay SOUND (a later non-scalar append must fall back). This is Tier-1 requirement #4 (data-oriented
layout) and the GATE for the numeric frameworks (Cortex AI / Reactor game / Pulse data).

HONEST M1 REFINEMENT: M1 "match-C" holds for SCALAR + STRUCT compute (done). It does NOT yet hold for
ARRAY/collection-heavy compute (120x). The M1-IMMEDIATE frameworks (Forge web / Mesh distributed / Ops /
Sentinel) are I/O & control-bound -> unaffected -> can branch now. The NUMERIC frameworks are array-bound ->
GATED on S4. So S4 is Tier-1.5: not needed for the web/distributed branch, REQUIRED for the numeric branch.

NEXT BUILD ITEM (active): S4 typed contiguous arrays. Design pass first (representation + inference rule +
sound fallback + lowering + interaction with arena/RC/deep_copy/channels), then build incrementally, gate
(reconverge + regression both modes + ASAN). Exploration of the existing list infra launched to ground it.
