# NOVA — REAL COMPLETION ROADMAP (2026-07-26)

> **Purpose (owner-requested):** an honest, verified, ordered path to *completing* the master plan
> (`NOVA_MASTER_PLAN_2026_07_10.md` + `NEXT_50_EXECUTION_2026_07_22.md`). Status below is **verified against
> live code** (a 5-agent audit fleet, not doc-trust). This is the sequencing spine; per-task ✅ ticking stays
> in the two plan files. Companion tracker: `EXECUTION_STATE.md`.

---

## 0. THE HONEST BOTTOM LINE (read this first)

- **"Lots of things remaining" is partly a tracking illusion.** Phase 0-2 (soundness + stdlib correctness-edge
  + most tooling) is **largely done** — many items were completed but only ticked in the side-tracker, not the
  plan files (now reconciled: TLS-server, REPL, redirects, lockfile, signals, perms, bignum, decimal, argon2,
  pack, xml, sync, L12, L13, L8-index/iter, trait-conformance, enum-payload typing, and tonight's 5 soundness
  fixes).
- **What's genuinely left to COMPLETE the plan is the XL foundational layer + the frameworks:**
  1. **The LOCK-NOW "can't-go-back" decisions** (Phase 3 = the declarative multiplier): **L11 namespacing,
     LOCK-4 sized numerics, LOCK-2 = L1/L2 annotations+comptime, LOCK-5 preemption+kill, LOCK-6 `@cdecl` FFI,
     LOCK-7 constant-time.** These are each M→XL and they GATE the frameworks.
  2. **The 8 unbuilt frameworks** (only Forge exists, ~36%): Ops, Pulse, Sentinel, Prism, Edge, Mesh, Cortex,
     Reactor — each is **weeks** of work, several are hardware-gated (GPU/ARM/MCU).
- **18-day reality:** 18 days is enough to **close the foundational LOCK-NOW layer + the tractable remainders +
  possibly the lightest framework (Pulse/Ops MVP)** — NOT to build all 9 frameworks (that is a multi-month
  effort, as the plan itself states). **The right 18-day goal = finish the "can't-go-back" foundation so no
  framework is ever blocked on a retrofit, plus the ready frameworks (Forge-complete + Ops).**

---

## 1. THE COMPLETION SPINE (dependency-ordered — this is the sequence to drive)

Governing rule (the plan's own): *soundness → correctness-edge → ecosystem → declarative multiplier →
presentation → domain frameworks → numeric-at-scale. Nothing later starts while its blocking gap is open.*

### TIER 1 — Close the foundation (Phase 0 remainder) — do first, unblocks correctness bar
- **Wave-B RC completeness** (#1 push-of-fresh-temp leak → #2 closure-capture → #3 field-reassignment; #4 cycle
  collector is XL/opt-in). Memory-SAFE today (leak-only), so not urgent-blocking — but it's the production bar.
- Tractable stdlib remainders: **S6 unix sockets (#19)**, **D1 IANA tz (#23, XL data)**.

### TIER 2 — The LOCK-NOW critical path (Phase 2-3) — THE heart of "completion", highest leverage
Ordered by how many frameworks each unblocks (blast radius):
1. **LOCK-1 / L11 module namespacing (#32)** — 9/9 frameworks; prerequisite for the annotation system + the
   package registry. *(Phase-1 collision detection done; Phase-2 `@mod__fn` mangling is the XL remainder —
   ~30 resolution sites, threads module context through lowering.)*
2. **LOCK-4 / L7 sized-numerics + f32/f16 (#36)** — **the #1 risk**; unblocks Pulse, Sentinel, Edge, Prism,
   Cortex, Reactor. *(inc1+inc2 done: suffix literals + conversions; inc3 = HM width-propagation + wrapping
   arithmetic + packed sized arrays — the ABI change.)*
3. **LOCK-2 / L1 annotations + L2 comptime (#39/#40, then #41/#42)** — 8/9; **THE #1 DevX lever** — turns
   Forge + all siblings declarative (`@route`/`@service`/`@component`/`@gpu`). Phase-1 built-in hooks deliver
   80%; user-extensible + hygienic macros are the XL tail. *(Needs L11 first.)*
4. **LOCK-5 / safepoint preemption + `kill` (#7)** — 6/9; Mesh supervision + Reactor frame-budget. XL,
   scheduler-deep, supervised.
5. **LOCK-6 / `@cdecl` FFI callbacks** — 5/9; the single widest blocker for Prism-desktop + Edge (also
   Forge-ALPN).
6. **LOCK-7 / constant-time `@ct` + `secure_zero` + `@redact` (Secret<T>)** — Sentinel + Forge's live crypto
   (already `-O2`-vulnerable). S/M effort, high urgency-per-effort.
7. **LOCK-8/9/10/11/12** — GPU-buffer-as-Value + autodiff table + const-generics + struct-by-value FFI + Mesh
   wire-protocol. **Design-lock now, implement later** (Cortex/Reactor/Prism/Mesh, Phase 5-6).

Other Phase-3 ceilings (fold in around the above): L6 immutability (#35), L3 variance (#38), L5 const-generics
(#43), L9 numeric-tower (#44), L10 weak/drop (#45), L4 associated-types (#46, XL).

### TIER 3 — Tooling ecosystem (Phase 2) — parallelizable with Tier 2
T-ABI (#24, S, do first), T-LSP inferer-backed (#25, L, highest DevX), T-Pkg CLI resolver wiring (#26, L),
T-Doc (#27), T-Test property/mocks (#28), T-Profile (#29), T-Install (#31).

### TIER 4 — Frameworks (Phase 4-6) — the multi-month body; readiness-ordered
- **READY after Phase-0 (start these first):** **Forge** (complete it — its locks harden existing paths) ·
  **Ops** (no core blockers — HTTP/cloud/YAML/subprocess/OTP all exist).
- **After LOCK-4:** **Pulse** (lightest — float columns exist; mostly EXTEND) · **Sentinel** (after LOCK-7 +
  LOCK-4; Argon2id done).
- **After LOCK-6 + WASM:** **Prism-web** (the adoption magnet) then **Prism-desktop** · **Edge** (hardest
  platform: freestanding + MCU triples + ARM; sequence last of the platform set).
- **After LOCK-5 + LOCK-12:** **Mesh** (distribution: NodeRef + wire protocol + auth — current `call_by_name`
  is unauthenticated RCE, must be locked before Mesh apps ship).
- **Phase 6, hardware-gated (heaviest, last):** **Cortex** (LOCK-4+8+9+10) · **Reactor** (nearly every lock).
- Wire-protocol clients + F5 image codecs + F9 PDF/XLSX + F10 OTel = cheap pattern-repeats, ship early to
  prove real-world integration.

---

## 2. VERIFIED STATUS (live-code audit, 5 agents, 2026-07-26 — every item probed/grepped, not doc-trusted)

**Scoreboard (the 50-task list + L1-L13 + LOCK-1..12 + 9 frameworks):**

| Block | DONE | PARTIAL | OPEN | The actionable remainder |
|---|---|---|---|---|
| **A · RC completeness** | — | — | #1,#2,#3 (M each), #4 (XL) | 3 memory-SAFE leaks share one root (drop fresh owned call-arg temps at scope-exit + rc_inc closure captures + owning field reads); #4 cycle collector XL |
| **B · platform/transport** | #9 (TLS server) | #10 (Linux epoll), #11 (DB) | #5 (ARM), #7=LOCK-5 (XL), #8 (ALPN server) | #6 STALE-DONE (single-poller). #5/#10 need Linux/ARM hardware. #8 ALPN server is L, Windows-verifiable |
| **C · stdlib** | #12,#13,#14,#15,#17,#18,#20,#21,#22 (9 done) | #16 (proxy only), #23 (17 tz zones done; full tzdb XL) | #19 unix-sockets (Linux) | Nearly complete. Only #16-proxy + #19 + full-tzdb remain |
| **D · tooling** | #30 (REPL) | #26 (lockfile done, resolver unwired), #27 (engine done, no CLI cmd), #28 (no db-rollback), #29 (instrumenting done, no sampling/CLI) | #24 T-ABI (S), #25 T-LSP-inferer (L), #31 installer (needs cert) | Engines mostly exist; the gap is CLI-wiring + inferer-backing |
| **E · language ceilings** | #33 L12, #34 L13 | #36 L7 (inc3), #37 L8 (call-overload), #39 L1a (80%), #40 L2a (int-only), #45 L10 (drop unbuilt) | #32 L11 (M), #35 L6 (M), #38 L3 (L), #41 L1b (XL), #42 L2b (XL), #43 L5 (L), #44 L9 (L), #46 L4 (XL) | THE declarative multiplier — the biggest open block |
| **LOCK-1..12** | LOCK-3 ✅ | LOCK-2 (Phase-1 hooks, wrong point), LOCK-4 (inc1/2 done, core repr OPEN), LOCK-11 (by-val gated off) | LOCK-1, LOCK-5, LOCK-6, LOCK-7, LOCK-8, LOCK-9, LOCK-10, LOCK-12 | Only LOCK-3 fully done; LOCK-4 is the #1 and half-built |
| **F + frameworks** | — | #47 WASM (runtime file missing!), #48 img (BMP ok, PNG stored-only, JPEG absent), #49 Prism-web (PoC only), Forge (~36%), Cortex (inference-only, no autodiff), Mesh (p2p only), Sentinel (primitives, no Secret<T>), Pulse (seed df, any-columns) | #50 Prism-desktop, Ops, Reactor, Edge | Only Forge is meaningfully built. 8 frameworks are seed/greenfield — the multi-month body |

**Three highest-leverage facts from the audit:**
1. **LOCK-4 is half-built and is the gate for 6 frameworks** — inc1/inc2 (suffix literals + conversions) verified working; the CORE (NType has no width/signed field; ints all collapse to i64; `255u8+1=256` not 0; no f32 storage; no packed sized arrays) is inc3, OPEN. Everything downstream (Pulse/Sentinel/Cortex/Edge/Prism/Reactor + LOCK-8/10/11) waits on it.
2. **LOCK-1 (L11 namespacing) is only *collision-detection*, not mangling** — it currently *errors* on two modules with the same fn name instead of letting them coexist. ~4 emit sites. Prereq for LOCK-2 (annotations) + the package registry.
3. **`nova wasm` is silently broken** — depends on `_wasm_runtime.cjs` which is absent from the tree (probe: valid .wasm compiles, then run fails "runtime not found"). Cheap fix, unblocks the whole frontend/Prism path.

---

## 3. THE 18-DAY PLAN — honest scope + concrete order

**Honesty first: 18 days completes the FOUNDATION, not the frameworks.** The 8 unbuilt frameworks (Cortex
autodiff, Reactor engine, Edge MCU, Prism desktop, Mesh distribution, plus Ops/Pulse/Sentinel to real MVP) are
each L-XL and mostly greenfield — that is the *months* the plan itself calls "the loss column." What 18 focused
days CAN do is **close every "can't-go-back" foundational decision + the tractable remainders**, so that when
framework work starts, nothing is ever blocked on a retrofit. That is the highest-value use of 18 days.

**Week 1 — the two hardest locks (foundation the most depends on):**
- **LOCK-4 / L7 inc3 (#36)** — the #1 item. Sub-increments, each gated + ticked: (a) NType gains width/signed;
  HM propagates it. (b) wrapping arithmetic at width (`255u8+1=0`). (c) real f32 storage. (d) packed sized
  arrays (elem_kind by width). This is the widest change — do it first, with care, present for the forks.
- **LOCK-1 / L11 (#32)** — `@mod__fn` mangling at the ~4 emit sites + runtime fn-table + short debug name.
  Unblocks the annotation registry + T-Pkg. (Parallelizable with LOCK-4 — different subsystems.)
- Fold in the free/cheap wins to keep momentum + tick count: **`nova wasm` fix (#47)**, **T-ABI (#24, S)**,
  **L6 immutability (#35)**, **L10 user-`drop` (#45)** — batch these into shared reconverge gates (2-3 total,
  not one-per-fix — the testing-time fix).

**Week 2 — the declarative multiplier + security + tooling:**
- **LOCK-2 / L1-annotations Phase-1 completion (#39/#40)** — move the hook to the typed-AST point; add
  `@service`/`@Entity`/`@column`/`@middleware`. This is THE DevX lever that makes Forge + siblings declarative.
- **LOCK-7 (#—) constant-time `@ct`+`secure_zero`+`@redact`** — M effort, high value (Forge's live crypto is
  `-O2`-vulnerable today). Unblocks Sentinel.
- **RC completeness (#1-#3)** — one supervised cycle (shared root), memory-safe → production bar.
- **Tooling wiring:** T-Pkg resolver (#26), T-Doc CLI (#27), T-Profile sampling+CLI (#29), T-LSP inferer (#25
  if time).

**Week 2.5-3 — design-lock the rest + start the READY frameworks:**
- **Design-lock (no full impl needed in 18 days):** LOCK-5 fiber-entry/kill contract, LOCK-6 `@cdecl` convention,
  LOCK-8/9 addrspace+adjoint-table, LOCK-10/11/12. Locking the *representation* now is the "can't-go-back"
  insurance; implementation follows in the framework phases.
- **Start the two READY frameworks:** **Pulse** (typed columns land the moment LOCK-4 does — lightest) and
  **Ops** (greenfield but no core blockers) — and **complete Forge's** annotation-declarative layer + ALPN.

**Beyond 18 days (the multi-month body, readiness-ordered):** Sentinel (post-LOCK-7) → Prism-web (post-WASM +
LOCK-6) → Mesh (post-LOCK-5/12) → Prism-desktop/Edge (post-LOCK-6/11) → Cortex/Reactor (post-LOCK-8/9, GPU
hardware-gated). Wire-protocol clients + image codecs + PDF/XLSX are cheap pattern-repeats to ship early for
"I can use this for real work" credibility.

**The one-line spine:** *finish LOCK-4 + LOCK-1 → complete the annotation multiplier (LOCK-2) + LOCK-7 → design-
lock the rest → ship the two ready frameworks (Pulse, Ops) + Forge-declarative. Everything else is sequenced
behind its now-closed lock.*
