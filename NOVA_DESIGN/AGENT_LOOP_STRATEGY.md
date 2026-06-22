# NOVA Multi-Agent Loop — Execution Strategy

How we execute CORE_COMPLETION_BACKLOG.md (40 items, priority order 1→40) with a multi-agent loop that is
FAST, CORRECT, low-waiting, and token-aware — without ever breaking NOVA or risking the OS.

## The governing fact (read this first)
NOVA's validation **gate is a single, serial, expensive, shared resource on one 16GB Windows machine**:
`edit → reconverge (gen5.ll==gen6.ll) → 551 regression ×2 modes → ASAN → commit` (~30–55 min today).
Almost every item edits ONE of two shared files: `nova_compiler.nova` (~20k lines) or `nova_runtime.c` (~19k lines).

Consequences (why naive "6 agents in parallel on the same work" is WRONG):
- You cannot validate two divergent versions of the compiler independently — the gate validates the WHOLE thing.
- You cannot run multiple heavy `clang -O2` builds + regression suites at once: CPU/RAM thrash → **OS crash risk**
  (Windows already crash-locked TWICE this project). Standing safety rule: never risk the OS.
- Multi-agent is inherently token-heavy; "many agents continuously" vs "few tokens" partially conflict — minimize, don't pretend.

So the speed win is NOT "more agents". It is: (1) make the gate FAST, (2) overlap the gate with design/leaf-work,
(3) parallelize only GENUINELY INDEPENDENT work, (4) split models (Sonnet grunt / Opus design+orchestrate).

## Roles
- **Opus 4.8 — Orchestrator/Architect (the main loop).** Owns the serial spine: sequences 1→40, designs hard
  items, adversarially reviews the XL rocks, runs the gate, commits, REVERTS on red, updates the board.
- **Sonnet 4.6 — Workers.** Implement well-specified items from a TIGHT spec; write tests/probes; do parallel
  leaves. Cheaper + fast; kept on rails by an exact spec (which also keeps tokens down).
- **Specialists** (devils-advocate, runtime-designer, compiler-architect) — adversarial DESIGN of the XL rocks
  BEFORE any code (the scheduler + OOB fixes worked because of this). Opus model.

## The loop shape: SERIAL SPINE + PARALLEL LEAVES, gate-clocked
**Spine (one at a time, gate-required):** anything touching the compiler/runtime core. Cycle per item:
1. Opus designs the item (for XL: spawn devils-advocate + runtime-designer first; vet; only then code).
2. Implement — Opus if delicate codegen; else hand a precise spec to a Sonnet worker.
3. Precheck (compiler compiles itself) → kick the **gate in the BACKGROUND**.
4. **While the gate runs (no waiting):** Opus designs item N+1, and/or dispatches parallel-leaf agents.
5. Gate GREEN → commit + update TASK_BOARD + memory → next item. Gate RED → REVERT, diagnose, retry. Never ship red.

**Leaves (fan out 2–4 Sonnet agents, safe):** work that does NOT touch the core and does NOT each need a reconverge —
new stdlib files (each crypto primitive as its own .c/.nova), docs, installer scripts, negative-test authoring,
probes/benchmarks. Run in worktrees so edits never collide. Their output is reviewed by Opus before commit.

**The gate is the loop's clock.** One spine change through it at a time; everything else overlaps it.

## Coordination — the shared brain
Subagents do NOT share memory. Coordination = a committed **`NOVA_DESIGN/TASK_BOARD.md`**, the single source of truth:
- Columns: item # · title · owner (opus/sonnet-N/specialist) · status (designing/coding/gating/blocked/done/reverted)
  · touches (compiler? runtime? leaf-file?) · blocked-by · last-update.
- EVERY agent reads the board first and writes its status. Opus reconciles it each cycle.
- LOCK rule: at most ONE in-flight change touching `nova_compiler.nova`, and at most one touching `nova_runtime.c`,
  at any time (the board records who holds each). Leaves are lock-free (disjoint files).

## Phase 0 — sharpen the gate BEFORE grinding the 40 (compounding speedup)
Do these first; they make EVERY later item gate ~5× faster (this beats adding agents):
- **#25 cached runtime `.o` + `-O0` dev link** (builds 5.8s → 0.3s).
- **#34 parallel test runner** (regression ~55min → ~10min) + **#8 CI + perf-regression gate**.
- Create `TASK_BOARD.md`.
Only then start the priority spine.

## Token discipline (honor "don't burn lots of tokens")
- Workers get EXACT specs (file, function, change, expected output) — never "go explore".
- Sonnet for all grunt implementation; Opus reserved for design/orchestration/delicate codegen.
- Background the gate; NEVER poll (the harness re-invokes on completion).
- Fan out ONLY for disjoint leaves; never duplicate the spine.
- Reuse cached agent results; resume workflows rather than re-run.

## Non-negotiables (the "don't break NOVA" rule, enforced)
- Soundness is #1. Nothing commits unless the gate is GREEN in BOTH modes + ASAN-clean. RED → revert, no exceptions.
- N=1 production path stays byte-identical unless an item explicitly changes it (then re-prove it).
- Kill-on-timeout MANDATORY on every run (Invoke-Timed / _safe_scale_run.ps1). Never risk the OS.
- XL rocks (#1 default-memory, #4 interfaces, perf S4/S5, distribution) get adversarial design FIRST; they are the
  ones most likely to regress — treat like the scheduler fix.

## Honest expectation
This is meaningfully FASTER than solo serial work (gate overlapped, leaves parallel, gate itself sped up) and
SAFE (one gate at a time, no OS risk) and CORRECT (gate-guarded). It is NOT "40 items in a weekend" — the XL rocks
(#1, #4, perf, distribution) are months of careful work each. The loop's job is to remove the WAITING and the
grunt-work latency, not to make hard compiler problems easy.
