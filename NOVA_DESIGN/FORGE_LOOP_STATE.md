# FORGE LOOP — Live Resume State (read this FIRST on any new session)

> The 24/7 build loop's "where are we / where do we resume" doc. Git-tracked, updated at every task
> boundary. If a connection drops: read THIS, then `FORGE_STATUS.md` (what/why) + `FORGE_BUILD_PLAN.md`
> (how/when), then `git log --oneline -20`, then continue the CURRENT TASK below.

## The mission
Build **Forge** — the framework where one developer, one language builds the whole system. **Forge is the
future: the goal is that everyone reaches for Forge for their projects.** It must **beat Spring Boot,
Django, Erlang/Elixir, Phoenix** — each at its own strength. Forge wins by *promoting* NOVA's already-
Erlang-shaped runtime primitives into clean APIs (see FORGE_STATUS §1, §6). Core NOVA (the language)
beats C/Rust/Go/Python at the language level; Forge beats the web frameworks on top of it.

**★ THIS IS ONE CONTINUOUS LOOP — NOT SEPARATE TASKS.** The Forge plan is COMPLETE (FORGE_STATUS +
FORGE_BUILD_PLAN); this is EXECUTION, not more planning. Core-NOVA work (N>1 multi-core, inference)
and Forge features are ALL threads of the SAME loop toward the SAME vision — deeply connected (N>1
powers Forge's multi-core throughput; inference cleans ALL NOVA code; one runtime under everything).
**Scope = multithreading + Forge. NOT the Reactor/game-engine plan.** The "phases" below are the FLOW/ORDER within the one loop, never
walls between projects. DESIGN only the genuinely-hard, soundness-critical core pieces (lightly, in the
loop); BUILD everything else against the existing plan. No re-planning, no stop-start — flow.

## How we work (the loop protocol)
- **Model strategy:** Opus 4.8 = every architectural decision + every NOVA compiler/runtime change + new
  language feature + hard/complex task. Sonnet 4.6 = ongoing/mechanical implementation, ALWAYS under an
  Opus-written spec + Opus review + the full gate before commit. Soundness is never delegated.
- **Divert rule:** the loop is Forge, but when a Forge feature needs a core-NOVA change, DIVERT to NOVA
  (Opus designs it, gated), then RETURN to the Forge loop.
- **Per-task cycle:** design (Opus; workflow + adversarial review for anything hard/soundness-critical)
  → build (Sonnet under spec, or Opus for NOVA-core) → GATE → commit → update THIS doc.
- **The gate (mandatory):** compiler/runtime change → `nova_ci.ps1` (reconverge gen5.ll==gen6.ll, NEVER
  exe SHA; perf gate; 588 regression in NORMAL + NOVA_T8_FULLRC). Stdlib/Forge-only → regression
  (-SkipReconverge ok). Kill-on-timeout MANDATORY. New code is zero-annotation + minimal (the 95/5 law).
- **PERMISSION GATE (owner rule):** design/analysis (workflows, code reads) runs freely — but NEVER
  start a BUILD (any NOVA runtime/compiler change OR Forge code) without the owner's explicit "go."
  **Propose → approve → build.** Nothing irreversible without the owner's word.

## The sequencing plan (beat Spring/Django/Erlang/Elixir)
- **Phase A — FOUNDATION (core-NOVA divert): N>1 multi-core production-grade.** NOVA is concurrent
  (green tasks/netpoller, 10k proven) but runs N=1 (single core) by default. N>1 exists but has OPEN
  RACES (channel lost-wakeup, netpoller M:N coordination, fiber-reclaim memory, B8 limiter-owner, B11
  app-object race — FORGE_STATUS §11 F7). **A single-core server can't out-throughput Spring (thread-
  per-request multicore) or BEAM (scheduler-per-core). Closing N>1 is THE foundation for the beat
  claim.** Must stay N=1-byte-identical + gated. **FOR FORGE — multithreading + Forge ONLY (NOT the
  Reactor/game-engine plan).** Make N>1 race-free so Forge handles requests across every core and
  out-throughputs Spring (thread-per-request) / BEAM (scheduler-per-core). Correctness (races) first;
  then ensure requests load-balance across cores so no core sits idle under load.
- **Phase B — the cheap moats:** L4 OTP declarative API (forge.supervisor + child specs; GenServer
  call/cast/**on_info**/timeout/terminate) = beat Erlang's ergonomics on its own substrate; L8
  observability (/metrics, /healthz, JSON logs + trace-id) + L3 auth pipeline = beat Spring; L5 channel
  join-authorization + presence (⟸ GenServer on_info).
- **Phase C — the big infra:** interfaces #8 (FATAL holes first) → HTTP/2 (⟸ TLS+ALPN) → gRPC; L5
  LiveView (only the render-differ is new); L2 Postgres + query DSL + migrations; L9 distribution;
  L10 auto-admin + WASM frontend.

## WHERE WE ARE (update every task)
- **Done & committed:** Forge M1 hero runs (typed CRUD over the router, `forge_hero_test`, 3dda37b).
  Typed-DB stdlib (db.all/find/insert/delete, 85c8bda). Inference S0+S1 (nominal struct-return,
  flag NOVA_STRUCT_RET default-OFF, gate ALL GREEN, 0f0b86c). Designs saved: quasi-quote (deferred),
  ZERO_ANNOTATION_AUDIT.md, SOUND_INFERENCE_PLAN.md.
- **Deferred (opportunistic, non-blocking):** inference S2 lambda-pinning (drops the hero's one
  `req: Request`); quasi-quote v1; flag-ON enablement of NOVA_STRUCT_RET.
- **CURRENT TASK:** Phase A foundation — **N>1 multi-core design COMPLETE** (NOVA_DESIGN/
  N1_MULTICORE_PLAN.md; design wzr6brjer, adversary-vetted — the race-hunt caught 7 FATAL/MAJOR holes,
  ALL folded in; goNoGo=revise = build the revised stages). It IS the complete multithreading-for-Forge
  design: **Stages 0-5, ending at Stage 5 = flip N>1 default → Forge on all cores** (that IS the
  parallelism; work-stealing folded to optional-later, NOT needed for v1 — the global-injector-claim
  model already balances new connections across idle cores). **AWAITING OWNER GO** to build **Stage 0A**
  (nova_track_heap_bounds monotonic CAS, gated). N=1 invariant = TWO oracles (reconverge for the
  compiler + 588 at N=1 both modes for the runtime) + N>1 stress (green_scale + channel-soak +
  fiber-reclaim/netpoll). Build order 0→1→2→3→4→5, each gated; a stage failing any oracle is REVERTED,
  not patched forward.

## Resume checklist
1. Read this doc + FORGE_STATUS.md §11 F7/B8/B11 (the N>1 races) + the N>1 design output when it lands.
2. `git log --oneline -15` — confirm last commit.
3. Continue the CURRENT TASK. If mid-build: check the gate state; never commit ungated compiler changes.
