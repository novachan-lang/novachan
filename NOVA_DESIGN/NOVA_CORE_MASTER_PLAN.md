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
