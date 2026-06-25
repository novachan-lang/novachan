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
  model already balances new connections across idle cores). **LOOP RUNNING (owner GO, full autonomy to the Forge end).**
  **STAGE 0 COMPLETE (value-model N>1-safety, all gated + ALL-GREEN):** 0A heap-bounds CAS (commit
  b7b4063), 0B intern-table lock + 0C box-bounds CAS (commit bd33455). Each: reconverge gen5.ll==gen6.ll
  + 590-591/N PASS both RC modes + N>1 stress (_n1_heapbounds_test, _n1_box_test) 25/25 + ASAN at N=4.
  DEFERRED (tracked, CLOSE BEFORE STAGE 5 FLIP): 0D mem counters (diagnostic, racy-but-benign at N>1,
  TSAN-follow-on); 0E @memo cache (nova_rt_memo_cache returns a per-fn cache dict the GENERATED @memo
  code races on — needs @memo codegen locking, not just a registry lock; @memo is N=1-correct today).
  **REORDER (soundness order, not feature order):** Stage 1 (B11 app-freeze + B8 limiter) is DEFENSIVE
  (handlers only READ the app dict in correct use; limiter not on the hot path) — do it BEFORE the
  Stage-5 flip. Tackle the ACTIVE N>1 bugs first: **PROGRESS (verified by reading the runtime): N>1 CORRECTNESS is essentially COMPLETE.**
  Stage 0 ✅ value-model; CHANNELS ✅ correct (park+wake under ch->lock, NO lost-wakeup — so the planned
  Stage 2 deferred-wake is PERF, not correctness); STAGE 3a ✅ status-overwrite HANG fixed (status=2
  moved INSIDE the publish lock in park_io/park_io_timeout/park_sleep/offload_run — was after the unlock
  so a poll/check_offload could set status=0 then get clobbered -> enqueued-but-parked HANG); NETPOLLER
  ✅ correct (poll mutates nova_io_waiters under g_sched_lock + F1 park_committed spin -> no double-wake;
  Stage 3b single-poller is PERF). Stage 3a IMPLEMENTED (5 reorder edits, byte-identical N=1); N>1
  sleep-park stress 30/30 + 8/8 ASAN at N=4; guard _n1_park_test added; N=1 gate running.
  **STAGE 4 ✅ DONE (gating): fiber-reclaim leak fixed as a ONE-LINE guard removal, NOT an RCU mechanism.**
  Careful reading showed the RCU/epoch design was solving a non-problem: pinning (commit 71a651d) means a
  CLAIMED task only ever runs on its home carrier (no migration), and the watchdog derefs st->fiber ONLY
  for g_carrier_spin tasks (parked-being-woken, never finishing) — so a FINISHED fiber is touched only by
  its home carrier; immediate free is race-free. Changed `if (g_carrier_count<=1) reclaim` -> always
  reclaim (N=1 unchanged — it already reclaimed). ASAN 6/6 + 10/10 churn at N=4. (The old `N<=1 only`
  guard was stale PRE-pinning conservatism.)
  **STAGE 1 (defensive) LARGELY DISSOLVES (verified by audit):** every `a[...] =` write in forge.nova is
  in a SETUP/registration fn; the serve/dispatch path only READS `a` and handlers get `req` not `a` -> the
  app dict is ALREADY read-only post-setup -> concurrent reads at N>1 are safe -> **B11 freeze unnecessary**
  (would add hot-path cost to defend an already-safe invariant). B8 limiter is NOT wired into serve -> not
  raced -> its owner-actor is a future-when-wired concern.
  **REAL REMAINING:** (1) **validate Forge ITSELF at N>1** (run forge_* tests at NOVA_CARRIERS=4 -> proves
  multi-core Forge works + surfaces any real-path issue) — LOW risk, HIGH value, DO NEXT. (2) **0E memo**
  (@memo per-fn cache races at N>1 — close before flip IF @memo is used; needs @memo codegen lock).
  (3) **Stage 2/3b PERF** (channel de-convoy + single-poller — for throughput vs Spring/BEAM; Stage 2 is
  the risky wake-refactor). (4) **Stage 5 flip** N>1 default (high blast-radius; opt-in-prod-ready +
  soak first). 0D counters = TSAN-follow-on (diagnostic, benign). N=1 invariant = TWO oracles (reconverge for the
  compiler + 588 at N=1 both modes for the runtime) + N>1 stress (green_scale + channel-soak +
  fiber-reclaim/netpoll). Build order 0→1→2→3→4→5, each gated; a stage failing any oracle is REVERTED,
  not patched forward.

## Resume checklist
1. Read this doc + FORGE_STATUS.md §11 F7/B8/B11 (the N>1 races) + the N>1 design output when it lands.
2. `git log --oneline -15` — confirm last commit.
3. Continue the CURRENT TASK. If mid-build: check the gate state; never commit ungated compiler changes.
