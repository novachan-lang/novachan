Now I have all the information needed. Let me compose the unified execution plan.

# NOVA EXECUTION PLAN -- Beat Every Language. Forge Beats Every Framework. The Loop Never Stops.

**Status:** CANONICAL. Supersedes all prior separate plans.
**Date:** 2026-06-16
**Author:** Chief Language Architect
**Grounded against:** HEAD aa72279 (436 tests), the real `nova_compiler.nova` (~15.5K lines), `nova_runtime.c` (~15K lines C), `forge.nova` (562 lines), and the 4 analyst maps.

---

## 0. THE WIN THESIS

NOVA does not beat every language by out-grinding 20-year ecosystems feature-by-feature. That is a losing strategy for a solo-built project. NOVA wins through **UNIFICATION + STRUCTURAL MOATS** -- collapsing 80% of the competition into things NOVA does FOR FREE because of its core model, then dominating the remaining 20% through properties the incumbents CANNOT retrofit.

**The unification argument:** A Spring Boot team building a microservice REST API needs: JVM + Maven + Spring Boot + Jackson + Spring Data JPA + HikariCP + Spring Security + spring-boot-starter-actuator + Logback + an application.yml + Dockerfiles + JRE on the target. A NOVA developer needs: `nova build`. One language. One binary. Zero dependencies on the target machine.

This is not a convenience -- it is a structural impossibility for Java/Python/Node/Ruby. They cannot eliminate their runtimes, their package managers, their separate ORMs, their bolted-on async frameworks. NOVA's Values/Processes/Channels model makes ORMs, async runtimes, message brokers, and process managers all FALL OUT of the core primitives. The competition's 100-module ecosystem is NOVA's one binary.

**The moats (properties the incumbents cannot copy):**

1. **Zero-dependency single static binary.** No JVM, no pip, no npm, no runtime to install. `scp myapp server:` and run.
2. **Green M:N concurrency with zero async coloring.** Handlers are straight-line synchronous code. No `async`/`await`, no `Mono<T>`, no callbacks. 10k concurrent connections, proven.
3. **Flat per-request arena memory.** Zero GC pauses. Deterministic p99 latency. Proven: `live_delta 16359 -> 0` over 1000 requests including cycles.
4. **Per-request crash isolation at AOT speed.** Erlang's fault model at C's speed. A panic in a handler returns 500; the server lives. Go/Node/Spring cannot do this.
5. **End-to-end compile-time type safety.** One type definition generates: JSON serializer, DB row mapper, HTML template field access, OpenAPI spec, validation, TypeScript client. A typo in ANY of these is a compile error.
6. **Compile-time DI.** No reflection, no classpath scanning, no 5-second startup. Missing wiring = compile error.
7. **Distributed channels as a language primitive.** Microservices communicate via the same channel model as local code. Circuit-breaker, tracing, and supervision come from the process model, not from bolted-on libraries.
8. **Whole-program optimization.** Framework + app + stdlib compile as one LLVM IR module. Cross-boundary inlining, dead-code elimination, type specialization -- impossible when framework and app are separate compilation units.
9. **The genius compiler, not the genius developer.** Zero type annotations for 95%+ of code. The compiler infers types, ownership, allocation strategy, and execution target.

**The flagship proofs (what "winning" looks like to a developer):**

**Flagship 1: Backend-Only REST API (one file, one binary, zero deps)**
```nova
use forge
use sqlitex

type Note { id: int; title: string; body: string; created_at: string }

fn list_notes(req)
    let notes: list<Note> = forge.query_as(db(), "SELECT * FROM notes ORDER BY id DESC", [])
    forge.json(notes)

fn create_note(req)
    let n: Note = forge.body_as(req)
    if len(n.title) == 0
        return forge.bad_request("title required")
    let id = forge.exec(db(), "INSERT INTO notes(title,body,created_at) VALUES(?,?,?)",
                        [n.title, n.body, now_iso()])
    forge.status(forge.json(Note { id: id, title: n.title, body: n.body, created_at: now_iso() }), 201)

fn main()
    db_exec(db(), "CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMARY KEY, title TEXT, body TEXT, created_at TEXT)")
    let app = forge.app()
    forge.use(app, forge.recover())
    forge.use(app, forge.logger())
    forge.use(app, forge.cors("*"))
    forge.get(app,  "/api/notes",  list_notes)
    forge.post(app, "/api/notes",  create_note)
    forge.serve(app, 8080)
```
Backend + DB + crash isolation + CORS + logging + flat memory. The Spring equivalent: Spring Boot + JPA + Jackson + spring-boot-starter-security + Maven BOM + application.yml + a JVM.

**Flagship 2: Full-Stack Type-Safe App (same backend + HTML views + endgame WASM frontend)**
Same backend as Flagship 1, plus:
- Server-rendered HTML views via NOVA functions (`forge.html(layout("Notes", each(notes, ...)))`) -- a typo in `n.titl` is a compile error, not a blank in output
- Endgame: WASM frontend sharing the same `Note` type with the backend, compile-checked across the wire

---

## 1. TWO TRACKS, INTERLEAVED

### Track A: NOVA CORE -- Beat Every Language

The core language is already competitive-to-dominant on 6 of 9 reference languages. The remaining work is NOT redesign -- it is plumbing, infrastructure, and verification.

#### A1. Beat C Fully (Performance Endgame)

**Current state:** ~1.04x C non-escaping struct math, 1.21-1.32x struct-passed-to-fn. Stage 1 DONE (b36ae32) -- unannotated struct params emit native `fmul`/`fadd`.

**Root cause of remaining gap:** Uniform i64-ABI prevents LLVM SROA and register-passing for construction-heavy code (~3.8x). HM inferer KNOWS the types; they are discarded at the codegen boundary.

| Stage | What | Status | Gate |
|-------|------|--------|------|
| S1 | Plumb HM-inferred types into codegen (direct-call) | DONE (d6462ee) | fmul in `_dot_untyped` |
| S2 | Unbox typed struct float fields | REVERTED (parallel-load flake vs real bug -- needs re-validation) | nn/stats pass 10x isolated + full regression 5x |
| S3 | Struct-field raw floats (unboxed layout for typed structs) | DESIGNED | Mutation-site detection gate |
| S4a | Stack-alloc non-escaping structs (alloca + GEP) | DESIGNED | Zero malloc for non-escaping dot product |
| S4b | Ptr-typed local handle + GEP registers | DESIGNED | LLVM SROA splits struct into registers |
| S5 | Monomorphic native-ABI specialization (the Julia endgame) | DESIGNED | Whole-program use-set detection |

**Effort:** ~5 iterations (S2 re-validate + S3). S4-5 are genuine multi-iteration compiler campaigns.

**Forge pulls this:** Forge throughput benchmarks (TechEmpower-style) require C-class hot-path performance. S2-S3 are the bounded wins; S4-5 are endgame.

#### A2. Beat Rust (Safety + Server Resilience)

**Current state:** Process isolation = memory safety (no data races, no UAF, no null). Arena = flat per-request memory (DONE, b5222b0). Total RC Stage 3 = loop-reassignment leak FIXED (list/dict 2000->1, 82312b0).

**Remaining:** ~41 string temporaries/request leak at scope-exit (not loop-reassignment). The dual-path design is canonical (FULL_TOTAL_RC_DESIGN.md):

| Component | Status | What remains |
|-----------|--------|--------------|
| Per-request arena (hot path) | DONE (b5222b0, 8fc40e2) | Proven flat. Zero per-object RC. |
| Total RC S1 (owned provenance) | DONE (54c463e) | Foundation bit, inert |
| Total RC S2 (alias-gap closure) | DONE (5ff8d72) | Foundation, inert |
| Total RC S3 (reassignment drop) | DONE (82312b0) | list/dict 2000->1 |
| Scope-exit RC (long-lived half) | DESIGNED (SCOPE_EXIT_RC_DESIGN.md) | The remaining leak. Deferred to a fresh session (irreducibly all-or-nothing). |

**Effort:** ~4-5 iterations for scope-exit RC. The arena path is DONE.

**Forge pulls this:** Long-running Forge servers must hold flat memory. Arena is the hot-path answer (proven). Scope-exit RC is the "high-throughput sustainability" answer. Arena ships NOW; scope-exit RC is the upgrade path.

#### A3. Beat Go (Multicore + Fast Compile)

**Current state:** M:N green scheduler exists. N=1 default is PERFECT (all tests pass, byte-identical to pre-M:N). Opt-in `NOVA_CARRIERS=N`. 10k green tasks + 10k parked, 382ms.

**Remaining:** Wire multi-carrier (N>1) into `main_dispatch` as the default. 15 races pre-catalogued in `MN_SCHEDULER_BUILD_PLAN.json` with mitigations. The F1 race (parker vs waker overlap) is highest priority -- the `park_committed` atomic flag + spin-wait is the proven standard (Tokio uses it).

| Step | What | Risk |
|------|------|------|
| 1 | Global-locked run-queue + 2 carriers + `__thread nova_sched_current` | Low (slow but correct) |
| 2 | Per-carrier waiter lists (io/sleep/offload) | Medium (lost-wakeup race) |
| 3 | Per-carrier work-stealing deques | Low (performance win) |
| 4 | cpu_count carriers + NOVA_CARRIERS env var | Low (configuration) |
| 5 | Chase-Lev lock-free deques | Low (optional optimization) |
| 6 | Event-driven idle | Low (optional optimization) |

**Effort:** ~6 iterations. Steps 1-3 are correctness-critical; 4-6 are optimization.

**Forge pulls this:** Any throughput benchmark claim requires multicore. Single-carrier is production-ready for I/O-bound web work (which is the dominant case for Forge); multicore is the "scaling" story.

#### A4. Beat Erlang (Distribution + Millions of Processes)

**Current state:** Supervisors (one_for_one/all/rest_for_one), monitors, remote_* channels (TCP+JSON), cluster membership (G-Set CRDT + gossip + failure detection), cluster_spawn, cluster_pmap -- all REAL, all tested.

**Remaining:**
- Phi-accrual/suspicion failure detector (design exists, unbuilt)
- True millions of processes (32KB fixed-commit fiber stacks -> ~30k/GB vs BEAM's 300 B/proc; stackless coroutines or segmented stacks needed, weeks-long effort)
- Hot code swap (file-watching only; in-flight type-safe swap is separate complexity)

**Effort:** Post-Forge. These are non-blocking for the framework story.

#### A5. Beat Python (Simplicity + REPL)

**Current state:** Zero annotations, faster, no GIL. Comprehensions. Huge stdlib.

**Remaining:** REPL via OrcJIT (designed, P7 in BEAT_EVERY_LANGUAGE_PLAN.md). Effort ~2 iterations for arithmetic + let + print. Not urgent for Forge.

#### A6. Beat JavaScript (Browser Reach via WASM)

**Current state:** WASM m1-m6 proven (dicts/structs run in wasm32, byte-identical to native). `nova wasm <file>` is a first-class CLI command.

**Remaining:** m7 = tagged C-runtime-to-wasm (eliminates untagged JS-runtime ambiguity). DOM bindings. SharedArrayBuffer channels. These are incremental WASM effort, weeks each.

**Forge pulls this:** Crown Jewel 3 (WASM frontend) needs m7+DOM. This is Phase 6, not Phase 1.

#### A7. Type System Depth for Frameworks

The HM inferer + monomorphic instantiation are proven real. The critical question: does let-site type drive generic instantiation for `query_as`/`body_as`? The `forge_keystone_test.nova` already proves `let u: User = from_json(body)` works with typed let-site inference. The struct RTTI keystone (Phase 0a, commits 92423ad through 280fe7e) is **COMPLETE** -- structs erased to `any` now serialize as JSON objects with correct field names, booleans, floats, and nested structs, via hash-keyed runtime metadata.

### Track B: FORGE -- Beat Every Framework

#### How Forge Pulls Core Work (the interleave)

Forge is the PULL side. Core is the PUSH side. The rule:

1. Forge builds Tier-0 against the CURRENT compiler for everything it already supports (routing, middleware, arena serving, HTML-as-function, typed-let query_as/body_as, sessions).
2. When Forge hits something the compiler cannot yet do, that becomes a Core Tier-3 increment: it lands FIRST through the full serial gate (reconverge + regression), installs the new `nova.exe`, and ONLY THEN does Forge consume it.
3. Core leads by one gated step. Forge follows by consumption. Neither track ever waits because Forge always has a compiler-supported backlog.

**Current Forge state (HEAD 6835426):**
- `forge.nova` = 562 lines, working MVP
- Router spine: method + `:param` dispatch, 404/405
- Composable middleware: `use` + `mw_cors`/`mw_header`/`mw_logger`, folded outside-in
- Request-data accessors: `body_json`/`form_decode`/`body_form` + DB row->dict bridge
- Flat per-request arena memory: PROVEN (`live_delta 16359 -> 0`)
- Phase 0a KEYSTONE COMPLETE: struct RTTI (hash-keyed metadata, struct-through-any -> JSON object, show/str, bool+float fields, `json_of` capstone)
- Phase 0b VERIFIED: cross-import extern works (stale gap comment, not a real blocker)
- 448 regression tests passing

---

## 2. THE TOOLCHAIN + DX + FORGE HOME

### Download-and-Go Architecture

The user experience is:

```
1. Download nova-0.1.0-win64.exe (or -linux-x64, or -macos-arm64)
2. nova new myapp --api          # scaffolds a Forge REST backend
3. cd myapp && nova run           # dev server on :8080, hot reload
4. nova build -O2                 # one static binary
5. scp myapp server:~/app/        # deploy. Done.
```

No Docker. No CI/CD for the happy path. No npm. No pip. No JVM.

### The `nova` CLI Commands (v0.1 = 8 core commands)

| Command | What |
|---------|------|
| `nova new <name> --<type>` | Scaffold a project; **type = api / microservice / frontend / fullstack / lib** (separate scaffolds, see below) |
| `nova run [--watch]` | Compile + run; `--watch` recompiles on file change |
| `nova build [-O0/-O2/-O3] [--target <t>]` | Produce one static binary |
| `nova test [--filter <pat>] [--verbose]` | Discover + run `*_test.nova` files |
| `nova fmt` | Format source files |
| `nova check` | Type-check without building |
| `nova get <pkg>[@version]` | Fetch a dependency to `nova_packages/` |
| `nova emit <file>` | Dump generated LLVM IR to stdout |

Additional commands (`nova repl`, `nova debug`, `nova bench`, `nova cov`, `nova profile`) ship in v0.2+.

### Project Types (separate scaffolds — `nova new <name> --<type>`)

Forge supports DISTINCT project creation, not one monolithic template. The creator's explicit
requirement: separate scaffolds for REST API, microservice, frontend, OR full-stack.

| Type | flag | What it scaffolds |
|------|------|-------------------|
| **REST API** | `--api` | A pure REST/JSON backend service (router + typed handlers + `json_of`/`body_as`). No frontend. |
| **Microservice** | `--microservice` | A service node: REST + distributed channels + `/health` + graceful shutdown + supervisor wiring (the distribution moat — ready to join a cluster). |
| **Frontend** | `--frontend` | A frontend-only project: HTML-as-functions / views, compiled to WASM (shares domain types with an API project over the wire). |
| **Full-stack** | `--fullstack` | Backend + frontend in ONE project (server-rendered + optional WASM client, one binary). |
| **Library** | `--lib` | A reusable NOVA module (no `main`, exported API). |

Each is its own scaffold with the right `nova.toml` deps, entry point, and gate test.
Backend-only (`--api` / `--microservice`) is the simplest path and the PRIORITY — it reaches
production-viable (M2) well before full-stack (M4). Frontend + full-stack depend on the WASM
frontend track (Phase 6 / Crown Jewel 3).

### `nova.toml` Dependencies

```toml
[package]
name = "myapp"
version = "0.1.0"

[dependencies]
forge = "0.2"
sqlitex = "0.1"
```

All dependencies compile INTO the binary. `nova_packages/` holds cached dependency sources. Resolution: lazy (fetched on first `nova build`, not on `nova new`).

### The `forge/` Home (Migration Sequence)

**Current state:** `forge.nova` lives in `nova-compiler/test_programs/`. This is correct for the bootstrap phase -- the 448-test regression assumes `test_programs/` as the module search base.

**Migration plan (one atomic commit, zero breakage window):**

1. Create `nova-compiler/forge/` with `src/forge.nova`, `examples/`, `tests/`
2. Update `resolve_module_file` search order: `(base_dir, cwd, [NEW] stdlib/, nova_packages/)`
3. Move `forge.nova` and `forge_*_test.nova` files
4. Update all imports in ~40 demo files
5. Run full 448-test regression -- must pass in the SAME commit
6. Tag as `v0.1-forge-home`

**Timing:** After Phase 1 (typed core) is complete, not during active compiler changes. The migration is safe but touching ~40 files makes it a bad candidate for mid-phase work.

### Honest Gaps in the Toolchain

- **Per-request string-temporary leak (~41 objects/request):** Tolerable for dev + moderate load. Mitigated by `max_keepalive_reqs` cap. Full fix = scope-exit RC.
- **WASM frontend:** Endgame (v0.2+), not v0.1. v0.1 is backend-focused.
- **Cross-platform binary distribution:** Requires building on each OS (Windows, Linux, macOS). Current bootstrap is Windows-primary.
- **Code signing:** Windows SmartScreen + macOS notarization needed for distribution. Deferred to Phase 1 release.

---

## 3. THE FAST/EFFICIENT UNSTOPPABLE LOOP

### The Per-Increment Cycle

```
PICK -> VERIFY -> BUILD -> CHECK -> FIX/HARD-REVERT -> COMMIT -> GUARD -> RECORD -> NEXT
```

**Step 1: PICK** from the ordered frontier:
- (a) Core debt that UNBLOCKS Forge first
- (b) The next Forge consume-item from FORGE_MASTER_PLAN.md that the CURRENT compiler supports
- (c) Additive breadth (pure-NOVA stdlib, runtime hardening)

**Step 2: VERIFY ASSUMPTIONS BY PROBE.** Before treating anything as a blocker, write a 5-line `.nova` or grep `nova_runtime.c` and RUN it with `Invoke-Timed`. Promote stale memory claims to FACT or delete them. (Meta-lesson: 2 of 4 assumed blockers were already working -- implicit-async was "Stage 0 go/no-go" but was essentially built; concurrency was "10% / no runtime" but was real.)

**Step 3: BUILD THE SMALLEST SOUND INCREMENT, ADDITIVE.** Prefer a NEW FIELD over a NEW OP-KIND (DCE keys on `op=="slot_store"`; a renamed op gets deleted -> self-miscompile; a new field is inert until a consumer reads it -> byte-identical). Prefer a new builtin / new `.nova` module / a default-OFF flag. Additive marks can only add leaks, never remove frees -- cannot introduce a UAF.

**Step 4: CHECK** at the correct gate tier (see below).

**Step 5: FIX-OR-HARD-REVERT.** Green-or-revert, never "green-ish." ANY use-after-free under EITHER RC mode, ANY ASAN finding, ANY `gen5.ll != gen6.ll` divergence, ANY regression drop = immediate `git checkout`. Do not debug forward on a red tree.

**Step 6: COMMIT SOURCE ONLY** (`nova_compiler.nova`, `*.nova`, `nova_runtime.c`, `*.ps1`) + ADD A PERMANENT GUARD (a `.nova` test appended to `run_suite.ps1`, or a `_*.ps1` probe). Never commit regenerated `gen*.exe`/`.ll`/`.o` build products.

**Step 7: RECORD** -- update memory + TODOs with new HEAD, the reconverged fixpoint SHA, and what is now PROVEN (not assumed).

**Step 8: NEXT.** No stopping between increments.

### Gate Tiers (the throughput core)

Most increments are NOT compiler changes. The gate tiers ensure the right level of verification without wasting time on unnecessary reconverges.

| Tier | What changes | Gate | Reconverge? | Time |
|------|-------------|------|-------------|------|
| **0** | Pure NOVA (.nova module, Forge feature, test) | Compile + link + run-with-kill + batch regression | NO | ~2 min |
| **1** | Tool-only (nova_build.nova, etc.) | Like Tier 0 | NO (confirmed iter-66) | ~2 min |
| **2** | Runtime-only (nova_runtime.c, no codegen contract change) | clang -c once + relink + regression BOTH RC modes + ASAN + green_scale | ONLY if a codegen-visible contract changed | ~5 min |
| **3** | Compiler change (nova_compiler.nova codegen/inferer/IR) | FULL serial gate: gen3->p1->p2->p3, gen5.ll==gen6.ll, smoke, regression BOTH RC modes, ASAN, green_scale 10k | YES, mandatory | ~10-15 min |

### The Tier-3 Serial Gate (detailed)

1. Run `_bootstrap_reconverge.ps1` (gen3->p1->p2->p3, 450000ms gen3 timeout)
2. Require `gen5.ll == gen6.ll` by SHA256 (compare `.ll` NEVER `.exe` -- clang link is non-deterministic on Windows; this exact false alarm ate a session)
3. Smoke: compile + run `gen4_test.exe` on a quick program
4. Regression in BOTH `NOVA_T8_FULLRC` and `NOVA_T8_DROP` (read the CURRENT pass count from the suite, do not hardcode)
5. ASAN repro
6. `green_scale_test` 10k
7. All green -> install p2 as `gen3_test.exe` + `nova.exe`

### Parallelization Model

**FANS OUT (no shared resource contention):**
- Design/research/review workflows (`deep-think`, `research-problem`, `stress-test`, `devils-advocate`) -- pure thinking, zero build-tree writes
- Independent Tier-0 NOVA modules and Forge features -- each is its own lane; batch verification into ONE regression pass
- The NEXT increment's DESIGN + PROBES while a Tier-2/3 gate runs in the background

**STRICTLY SERIAL (the invariant):**
- The bootstrap reconverge / Tier-3 gate. Exactly one in flight. `_bootstrap_reconverge.ps1` writes `gen3_test.exe` AND `nova.exe` and shares `nova_compiler.ll`/`nova_p*.ll` scratch. Two at once corrupts the compiler.

### What Would STOP the Loop + How Each Is Prevented

| Loop-Stopper | Prevention |
|-------------|------------|
| **Corrupted compiler** from two concurrent reconverges | Single-serial-resource invariant: one reconverge in flight, full stop |
| **Hung binary pinning every core, blocking the OS** | MANDATORY `Invoke-Timed` kill-on-timeout on every spawned binary, no exceptions. Verify loop termination before building. (Physically blocked Windows twice: 2026-05-18, 2026-05-22.) |
| **Silent UAF shipped** | Green-or-HARD-REVERT against BOTH RC modes + ASAN + green_scale. Additive-only increments (new field/builtin/flag) can only add leaks, never frees. |
| **Self-miscompile** from non-byte-identical compiler edit | gen5.ll==gen6.ll fixpoint check (compare .ll not .exe) + new-field-not-new-op rule |
| **Phantom work** on a non-existent blocker | VERIFY-BY-PROBE before building (the 2-of-4 lesson: async and concurrency were both already working) |
| **Committing build products** | Source-only commits; gen*.exe/.ll/.o are regenerated by the gate |
| **RAM pressure** from concurrent heavy compiles | Cap concurrent heavy compiles; design/probe lanes are cheap and can stay wide |
| **Dual RC modes doubling gate cost** | Pre-compile `nova_runtime.o` ONCE; run the three modes' suites in parallel |

---

## 4. ORDERED PHASE ROADMAP WITH MILESTONES

### Phase 0: Compiler Keystones [NEARLY COMPLETE]

**Goal:** Fix compiler blockers so the typed framework can exist.

| Deliverable | Status | Track |
|-------------|--------|-------|
| Phase 0a: Struct RTTI (hash-keyed metadata) | DONE (92423ad) | Core |
| Phase 0a S2: Struct-through-any -> JSON object | DONE (d4f681f) | Core |
| Phase 0a S3: Struct-through-any -> show/str | DONE (285feef) | Core |
| Phase 0a capstone: bool+float fields + json_of | DONE (280fe7e) | Core |
| Phase 0b: Cross-import extern resolution | VERIFIED WORKING (aa72279) | Core |
| Phase 0c: from_json typed-let | DONE (forge_keystone_test proves it) | Core |
| Phase 0d: Keep-alive loop + streaming response | NOT STARTED | Core+Forge [B+FS] |
| Phase 0e: Multi-carrier stabilization (N>1) | NOT STARTED (blocks throughput claims) | Core |

**Gate:** `forge_keystone_test` PASSES. `rtti_json_test` PASSES. `rtti_show_test` PASSES. Bootstrap reconverged. 448/448 regression green.

**Competitive claim unlocked:** "Return a struct, get JSON -- zero annotations."

**Milestone M0:** The struct<->JSON keystone works. Forge can serialize domain types.

### Phase 1: Typed Core (Request/Response/App + Integrated Routing) [B+FS]

**Goal:** Replace the dict-based MVP with typed structs. Close the three named MVP gaps (G1: synchronous accept, G2: handler can't see raw request, G3: no object model).

| # | Deliverable | Tag | Gate |
|---|-------------|-----|------|
| 1 | `Request` struct (method/path/raw_path/params/query/headers/body/state/conn) | B+FS | Typed field access in handler |
| 2 | `Response` struct (status/headers/body/halted) | B+FS | finalize(resp) -> wire string |
| 3 | `App` struct (router/mws/prefix/static_root/not_found/on_panic/db) | B+FS | forge.app() returns typed struct |
| 4 | `_build_request` parse-once (O(1) access, case-insensitive headers, fixes xkey= bug) | B+FS | req.headers["host"] works |
| 5 | `finalize(resp)` -- Response -> wire string, single pre-sized buffer | B+FS | One allocation for wire format |
| 6 | Value-polymorphic response builders (json/text/html/redirect/file) | B+FS | forge.json(struct) returns Response |
| 7 | `_coerce(any) -> Response` for handler return coercion | B+FS | Bare-struct return works |
| 8 | Spawn-per-connection serve (THE fix for G1) | B+FS | 10k concurrent, accept never blocked |
| 9 | Keep-alive loop with `max_keepalive_reqs` cap (leak mitigation) | B+FS | 1000 requests on one connection |
| 10 | `_recv_request_timeout` (Slowloris defense) | B+FS | Slow client cannot starve accept |
| 11 | `forge.recover()` middleware (spawn+monitor per request, panic -> 500) | B+FS | Crash isolation test |
| 12 | `forge.limit_body(maxBytes)` middleware | B+FS | Oversized body = 413 |
| 13 | 405 vs 404 second-pass dispatch + Allow header | B+FS | POST to GET-only route = 405 |
| 14 | `*name` wildcard catch-all | B | `/files/*path` routes |
| 15 | `forge.group(app, prefix)` for route grouping | B+FS | `/api/v1` prefix shared |
| 16 | Traversal-safe `forge.static(app, prefix, root)` | B+FS | `../../../etc/passwd` rejected |
| 17 | Pure test surface: `forge.mock_request` / `forge.dispatch` | B+FS | Socket-free testing |

**Core work:** None beyond Phase 0 (all pure NOVA = Tier 0, no reconverge).

**Gate:** `forge_typed_test` -- full CRUD handler round-trip, bare-struct return producing correct JSON, crash isolation via recover, static serving, route groups, 405/404.

**Competitive claim:** "Flask-simple handlers with Go-class concurrency and Erlang-class crash isolation."

**Milestone M1: BACKEND-USABLE.** The Forge flagship Notes app runs end-to-end on a real socket. One file, one binary. This is the first externally-demoable milestone.

**Effort:** 5-8 iterations. **Parallelizes with:** Core A1 (perf S2-S3), Core A3 (multicore steps 1-3), design work for Phase 2.

### Phase 1.5: Postgres via libpq FFI [B+FS] [PROMOTED]

**Goal:** Enterprise-viable database. SQLite-only is toy-tier for real evaluation.

| # | Deliverable | Tag |
|---|-------------|-----|
| 1 | libpq FFI binding (connect/query/exec/prepare/finish) | B+FS |
| 2 | Connection pool as channel of Postgres handles | B+FS |
| 3 | Postgres tests via Docker | B+FS |

**Core work:** `@link("pq")` FFI pattern (already proven with SQLite).

**Gate:** `query_as<User>` against live Postgres, connection pool under load.

**Effort:** 3-5 iterations. **Parallelizes with:** Phase 2 data-layer design.

### Phase 2: Data Layer + Transactions + Connection Pool [B+FS]

**Goal:** Make Forge database-capable with the simplest, most type-safe data access of any framework.

| # | Deliverable | Tag |
|---|-------------|-----|
| 1 | `forge.query_as<T>(db, sql, params)` -- row -> struct | B+FS |
| 2 | `forge.query_one<T>(db, sql, params)` -> Result<T> | B+FS |
| 3 | `forge.exec(db, sql, params)` -> last_insert_id | B+FS |
| 4 | `forge.body_as<T>(req)` -- JSON -> struct | B+FS |
| 5 | `forge.form_as<T>(req)` -- URL-encoded -> struct | FS |
| 6 | `from_json_safe<T>` -> Result<T, Error> | B+FS |
| 7 | `forge.tx(db, fn(tx) {...})` -- transactions | B+FS |
| 8 | Connection pool as channel (bounded, backpressure) | B+FS |
| 9 | `last_insert_rowid` extern | B+FS |
| 10 | Health endpoint `/health` with DB check | B |
| 11 | Request-ID middleware (UUID per request) | B+FS |
| 12 | Security headers middleware (HSTS/CSP/X-Frame) | B+FS |
| 13 | Rate limiting middleware (owner-actor, lock-free) | B |
| 14 | Response compression middleware (gzip) | B+FS |
| 15 | Graceful shutdown (inflight counter + tcp_close) | B+FS |
| 16 | SSE via streaming response | B |

**Core work:** `last_insert_rowid` extern (one line). Possible small compiler work for row->struct.

**Gate:** Full-stack CRUD app with typed data, transactions, pool, health check, graceful shutdown. Load test: 1000 concurrent, no crash, correct data, arena-flat.

**Competitive claim:** "Simpler than Django ORM: `let users: list<User> = query_as(db, sql, [])` -- done."

**Effort:** 5-8 iterations. **Parallelizes with:** Core A3 (multicore steps 4-6).

### Phase 3: Security + Sessions + Validation + OpenAPI + DevX [B+FS]

**Goal:** Make Forge secure-by-default and API-documentation-complete.

| # | Deliverable | Tag |
|---|-------------|-----|
| 1 | `forge.sessions(secret)` -- HMAC-signed cookie | B+FS |
| 2 | Server-side session store (token -> SQLite) | B+FS |
| 3 | `forge.csrf()` -- double-submit, constant-time | FS |
| 4 | `forge.require_auth(verify_fn)` guard middleware | B+FS |
| 5 | JWT encode/decode/verify (HS256) | B |
| 6 | API key middleware | B |
| 7 | Argon2id password hashing (FFI) | B+FS |
| 8 | Type-driven validation -> `Result<T, ValidationErrors>` | B+FS |
| 9 | OpenAPI 3.x generation at compile time | B |
| 10 | TypeScript client stub generation | B |
| 11 | Named routes + `url_for` (compile-checked) | B+FS |
| 12 | Compiled radix-trie router | B+FS |
| 13 | Hot-reload dev server | B+FS |
| 14 | Dev error pages | B+FS |
| 15 | Prepared statement caching | B+FS |
| 16 | ETag/Cache-Control middleware | B |
| 17 | PubSub channel groups | B+FS |
| 18 | `forge.schedule(cron, fn)` | B |
| 19 | Background job retries (supervisor backoff) | B |

**Core work:** Argon2id FFI. Compile-time route analysis (build-step AST walk).

**Gate:** Secure notes app with sessions, CSRF, JWT, Argon2 passwords, validated input, OpenAPI at `/docs`, TypeScript client compiles.

**Competitive claim:** "FastAPI's auto-OpenAPI, but compile-time (cannot drift). Spring Security's power without the proxy footguns."

**Milestone M2: PRODUCTION-VIABLE (backend-only).** A team can ship a real REST API with auth, validation, OpenAPI, Postgres. This is the adoption-ready milestone for backend teams.

**Effort:** 8-12 iterations. **Parallelizes with:** Core A2 (scope-exit RC).

### Phase 4: Full ORM + Relations + Migrations + Postgres Native [B+FS]

| # | Deliverable | Tag |
|---|-------------|-----|
| 1 | Model relations (has_many/belongs_to/has_one/many_to_many) | B+FS |
| 2 | Eager loading by default | B+FS |
| 3 | Query builder (composable query structs) | B+FS |
| 4 | Auto-generate migrations from model diffs | B+FS |
| 5 | Reversible up/down migrations | B+FS |
| 6 | OAuth2/OIDC social login | B+FS |
| 7 | Content negotiation (JSON/HTML/Accept) | B |
| 8 | Multipart/form-data parsing (file uploads) | B+FS |
| 9 | Static asset fingerprinting + embedding | FS |
| 10 | HTMX-style partial HTML responses | FS |
| 11 | `nova forge new myapp` scaffolding | B+FS |
| 12 | `nova forge generate` generators | B+FS |
| 13 | Dead-letter queue | B |
| 14 | Error tracking (panic -> structured report) | B+FS |

**Core work:** Asset embedding (`embed_file` compile-time directive).

**Gate:** Multi-model app with relations, migrations, eager loading, OAuth, file uploads, Postgres. `nova forge new` works.

**Competitive claim:** "Django ORM ergonomics, Ecto type safety, no Hibernate surprises."

**Milestone M3: FULL-STACK-USABLE.** A team can build a complete Django-parity web application.

**Effort:** 10-15 iterations.

### Phase 5: Distribution + Compile-Time SQL + Advanced [B+FS]

| # | Deliverable | Tag |
|---|-------------|-----|
| 1 | Compile-time SQL validation (schema at build time) | B |
| 2 | N+1 detection (syntactic best-effort lint) | B+FS |
| 3 | Distributed channels + service discovery | B |
| 4 | Distributed cache (no Redis for moderate scale) | B |
| 5 | Presence (CRDT-merged per-node state) | FS |
| 6 | MySQL driver | B+FS |
| 7 | Job dashboard | B |
| 8 | MFA/2FA (TOTP) | B+FS |
| 9 | i18n with compile-time translation checking | FS |
| 10 | Email (SMTP + templated, async) | B+FS |
| 11 | File storage abstraction | B+FS |
| 12 | Load-testing helpers | B+FS |
| 13 | Test factories | B+FS |
| 14 | Fragment caching | FS |
| 15 | Feature flags (compile-time + runtime) | B+FS |

**Core work:** Compile-time SQL validation (build-step schema connection).

**Gate:** Query referencing non-existent column fails build. Loop with nested query warns N+1. Distributed workers on 2 machines.

**Competitive claim:** "Compile-time SQL validation -- the thing sqlx needs a live DB + macros for, Forge does natively."

**Effort:** 12-18 iterations.

### Phase 6: Crown Jewels (Auto-Admin + LiveView + WASM Frontend) [FS]

| # | Deliverable | Tag |
|---|-------------|-----|
| 1 | **Auto-Admin** -- zero-config CRUD UI from types | B+FS |
| 2 | **Server-Driven Real-Time UI** (LiveView model) | FS |
| 3 | **WASM Frontend** (<30KB bundles, same types both sides) | FS |
| 4 | GraphQL endpoint generation | B |
| 5 | gRPC services | B |
| 6 | Durable message channels (Kafka-like) | B |
| 7 | RBAC policy engine | B+FS |

**Core work:** WASM DOM/IO bindings. LiveView diffing engine. Template static/dynamic split.

**Gate:** Auto-admin running on real DB. LiveView counter updating in real-time. WASM frontend <30KB sharing types.

**Competitive claim:** "Django's admin + Phoenix's LiveView + Blazor's WASM -- all at native speed, one language, one binary."

**Milestone M4: FULL-STACK-DOMINANT.** The "why Forge is special" endgame.

**Effort:** 15-25 iterations.

### Phase 6.5: Distributed Microservices Architecture (THE Structural Moat) [B]

| # | Deliverable |
|---|-------------|
| 1 | Location-transparent channels (call process on any node, compiler routes) |
| 2 | Service discovery (process registry + health check) |
| 3 | Circuit-breaker + retry (supervisor + backoff) |
| 4 | Distributed tracing (channel-graph automatic, no manual @WithSpan) |
| 5 | Gateway (route HTTP to internal microservices) |
| 6 | Load balancing (round-robin + least-loaded over process pool) |

**This is where Forge structurally beats Spring Cloud.** Spring needs: config server + Eureka + Hystrix/Resilience4j + Sleuth + Jaeger + Gateway -- 5-7 separate systems. Forge: `./myapp --service-a & ./myapp --service-b & ./myapp --gateway &`. Same binary, feature-flag-selected, full supervision. Tracing follows the channel graph automatically because ALL communication is channels.

**Gate:** Service A calls Service B across network via location-transparent channel. Circuit-breaker activates on failure. Trace shows full path.

### Phase 7: Production Hardening [B+FS]

| # | Deliverable |
|---|-------------|
| 1 | HTTP/2 multiplexing + HPACK |
| 2 | Zero-downtime rolling deploy |
| 3 | Windows TLS server (Schannel) |
| 4 | OWASP Top 10 security audit |
| 5 | Memory campaign (close scope-exit leak via total-RC) |
| 6 | 10 real applications by external developers |
| 7 | TechEmpower-style benchmarks vs Spring/Django/Go/Phoenix |
| 8 | Documentation: getting-started, API reference, cookbook, migration guides |
| 9 | `nova forge console` (REPL with app + DB context) |
| 10 | Edge deployment (WASM to CDN nodes) |
| 11 | HTTP/3 QUIC |

**Milestone M5: 1.0-HARDENED.** `NOVA_T8_FULLRC` + scope-exit RC promoted to DEFAULT-ON. Full regression green in the default config. No opt-in flags carrying load-bearing safety. 10 real apps in production. TechEmpower top-5 results.

---

## 5. COMPETITIVE SCORECARDS

### NOVA vs Languages (Core)

| Language | Its Prime | NOVA Today | Remaining to Win |
|----------|----------|------------|------------------|
| **C** | Raw scalar/float perf | MATCH (1.04x non-escaping, 1.21-1.32x struct-passed) | S2 re-validate, S3 struct-field unbox, S4-5 SROA+native-ABI (endgame) |
| **C++** | Templates, RAII, zero-cost | WIN (RAII=defer+RC, operators=traits, generics+inference, no template/UB complexity) | Monomorphic native-ABI (narrow perf delta) |
| **Rust** | Safety w/o GC | WIN on DX (zero annotations, no borrow-checker fight). MATCH on safety (process isolation) | COW-on-send (perf, not safety). Scope-exit RC for total reclamation |
| **Go** | M:N concurrency, fast compile | WIN (typed channels+select+spawn + supervisors/monitors Go lacks) | Multi-carrier (N>1) wiring. Faster incremental compile (low ROI) |
| **Erlang** | Fault tolerance, millions of procs, distribution | WIN on cluster_spawn/cluster_pmap, supervisors, remote channels | True millions of procs (stackless). Hot code swap. Phi-accrual |
| **Python** | Simplicity, REPL, reach | WIN (zero annotations, 50-100x faster, no GIL) | REPL (OrcJIT). Ecosystem breadth (time, not code) |
| **Java** | Reflection, no-warmup, ecosystem | WIN (AOT > JIT, no GC pauses, no NPE) | Ecosystem (time, not code) |
| **JavaScript** | Browser reach, async | WIN (green scheduler = async w/o coloring, WASM m1-m6 proven) | m7 tagged runtime-to-wasm, DOM bindings |
| **Swift/Kotlin** | Generics, null-safety, multiplatform | WIN (HM generics, sum types, exhaustive match) | -- |

### Forge vs Frameworks

| # | Dimension | Spring Boot | Django | Rails | Phoenix | FastAPI | Axum | Go/Gin | **Forge TODAY** | **Forge PLAN** |
|---|-----------|-------------|--------|-------|---------|---------|------|--------|----------------|---------------|
| 1 | Startup time | 5s | 1s | 2s | 50ms | 500ms | 5ms | 5ms | **<5ms WIN** | **WIN** |
| 2 | Memory baseline | 300MB | 80MB | 100MB | 60MB | 50MB | 5MB | 15MB | **<10MB WIN** | **WIN** |
| 3 | Single binary deploy | NO | NO | NO | NO | NO | YES | YES | **YES WIN** | **WIN** |
| 4 | Handler simplicity | WebFlux coloring | OK | OK | gen_server | async | async fn | OK | **WIN (no coloring)** | **WIN** |
| 5 | 10k concurrent | threads | GIL | MRI | BEAM | GIL | YES | goroutines | **WIN (green)** | **WIN** |
| 6 | Crash isolation | NO | NO | NO | YES | NO | NO | NO | **TIE Phoenix** | **WIN (+AOT speed)** |
| 7 | GC impact on p99 | HIGH | HIGH | HIGH | MEDIUM | HIGH | NONE | MEDIUM | **WIN (arena)** | **WIN** |
| 8 | End-to-end type safety | Java types | NO | NO | NO | hints | Rust | Go | **PARTIAL** | **WIN (+HTML+WASM)** |
| 9 | JSON from domain type | Jackson | DRF | serialize | Jason | Pydantic | Serde derive | manual | **WIN (zero-annot, RTTI)** | **WIN** |
| 10 | ORM ergonomics | JPA | ORM | AR | Ecto | NO | NO | NO | **LOSE (dict)** | **WIN (typed query_as)** |
| 11 | Auto-admin | NO | YES | NO | NO | NO | NO | NO | **LOSE** | **WIN (+real-time)** |
| 12 | Auto OpenAPI | annotations | NO | NO | NO | YES (runtime) | NO | NO | **LOSE** | **WIN (compile-time)** |
| 13 | Real-time (WS/PubSub) | WebFlux | NO | Hotwire | YES | NO | NO | NO | **PARTIAL** | **WIN (native speed)** |
| 14 | WASM frontend | NO | NO | NO | NO | NO | NO | NO | **LOSE** | **WIN (unique)** |
| 15 | Background jobs (no broker) | Quartz+Redis | Celery+Redis | Sidekiq+Redis | OTP | NO | NO | NO | **WIN (spawn)** | **WIN** |
| 16 | Compile-time SQL | NO | NO | NO | NO | NO | sqlx | sqlc | **LOSE** | **WIN (native)** |
| 17 | Compile-time DI | runtime | runtime | runtime | runtime | NO | static | static | **WIN** | **WIN** |
| 18 | Security by default | YES | YES | YES | YES | NO | NO | NO | **LOSE** | **WIN (SQL impossible)** |
| 19 | Scaffolding | Initializr | startproject | rails new | mix new | NO | NO | NO | **LOSE** | **TIE** |
| 20 | Ecosystem maturity | 20yr | 18yr | 20yr | 10yr | 5yr | 3yr | 10yr | **LOSE** | **LOSE (time)** |

**Summary:** Today Forge WINs on 8 of 20, TIEs on 1, LOSEs on 11. The LOSEs are "not built yet," not structural deficiencies. Plan: WIN on 18, TIE on 1, LOSE on 1 (ecosystem maturity -- won by time, not code).

---

## 6. INNOVATIONS (Original, Future-Facing)

These are capabilities NO existing language or framework has. They are not copies of features from other systems -- they are novel mechanisms that emerge from NOVA's Values/Processes/Channels model.

### Innovation 1: Automatic Structural Value Identity
Every struct automatically gets `show`/`==`/`hash`/`clone`/`to_json`/`from_json` -- derived from its structure by the compiler, zero annotations. Rust needs `#[derive(Serialize, Debug, PartialEq)]`. Python needs `@dataclass`. NOVA: just define the type. **SHIPPED** (8915e6f, f0bcf2d, b2cc7ad).

### Innovation 2: Process Isolation as Memory Safety
No borrow checker, no lifetime annotations, no ownership syntax. Processes own their values. Channel sends are deep-copies. Data races are impossible by construction. The developer writes nothing; the compiler enforces everything.

### Innovation 3: Per-Request Arena Memory (Zero GC, Zero RC on the Hot Path)
Request-scoped allocations live in a bump arena. One bulk free at request end. Cycles die with the arena. No GC pauses, no per-object RC traffic on the hot path. **SHIPPED** (b5222b0). p99 latency is bounded by processing + network, never by memory management.

### Innovation 4: Channel-Graph Distributed Tracing
Because ALL communication in NOVA is channels, distributed traces are automatic. The process/channel topology IS the trace. No manual `@WithSpan` annotations. No `TracerProvider` configuration. No Jaeger setup for the common case. A world-first for a compiled language.

### Innovation 5: Compile-Time OpenAPI from Inferred Types
Route signatures + inferred type definitions generate OpenAPI 3.x spec at compile time. Zero runtime cost. Cannot drift from the implementation. FastAPI does this at runtime via reflection; Forge does it at compile time with type-checking. **Phase 3.**

### Innovation 6: Compile-Time SQL Validation Without a Live DB
The compiler reads schema metadata from `nova.toml` (file or connection string) and checks every `query_as`/`exec` call at build time. A column typo is a compile error. Rust's sqlx needs a live database + procedural macros. Go's sqlc needs a separate tool + SQL files. NOVA: just write SQL in your handler. **Phase 5.**

### Innovation 7: The Genius Compiler (Zero-Annotation Type Specialization)
The Julia-style specialization path: the HM inferer types everything; the codegen specializes to native operations where types are monomorphic. The developer writes `a.x * b.x`; the compiler emits `fmul`. No type annotations needed. C requires the programmer to write `double`. Rust requires generics + bounds. NOVA infers and specializes. **Stage 1 SHIPPED** (b36ae32).

### Innovation 8: Location-Transparent Distributed Channels
`remote_connect`/`remote_send`/`remote_recv` make channels work across machines with the same API as local channels. The developer writes the code once; the compiler routes. Combined with cluster_spawn and cluster_pmap, this makes distributed computing a LANGUAGE PRIMITIVE, not a library. **SHIPPED** (f095790, bb10f51, 7d9ec1c).

### Innovation 9: Contracts as Language Primitives
`requires`/`ensures` clauses on functions, evaluated at function entry/exit. `static_assert` evaluated at compile time. Design-by-contract with zero ceremony. Not annotations -- language syntax. **SHIPPED**.

---

## 7. SEQUENCING RATIONALE

### Why Phase 0 first (compiler keystones)

Everything typed depends on structs surviving the `any` boundary. The RTTI keystone (already DONE) unblocks: handler returns, `body_as`, `query_as`, `form_as`, OpenAPI, admin, and the entire "derive from types" thesis. Without it, Forge ships silently wrong JSON -- the one thing worse than shipping nothing.

### Why Phase 1 before Phase 2 (typed core before data)

The four structs (Request/Response/App/Handler) are the API surface everything else composes on. Middleware needs `Response.halted`. Routing needs `Request.params`. Data needs `Request.body`. Without the typed core, every Phase 2+ feature is built on dicts and string surgery.

### Why Postgres promoted to Phase 1.5

SQLite-only is fine for demos but enterprise evaluation (the adoption barrier) requires Postgres. Promoting it early sets the bar at "can build a Heroku/Railway production app" by end of Phase 3.

### Why backend-only wins the race

Backend-only mode (pure REST API / microservice) reaches production-viable (Phase 3) 2-3 phases before full-stack (Phase 6). This aligns with market reality: 80% of API usage is backend-only. Forge's moats (distributed channels, crash isolation, zero-dep binary) are **sharpest for backend-only microservices**, where Spring Cloud's 5-system complexity breaks most visibly.

### Why multicore (A3) parallelizes with Forge Phases 1-2

Multicore is a RUNTIME change (zero compiler touch). It can proceed on a separate track without contending for the bootstrap reconverge resource. The wiring is pre-engineered (15 races catalogued with mitigations). It becomes REQUIRED only for throughput benchmark claims (Phase 7), but is higher-leverage to start early.

### Why scope-exit RC (A2) parallelizes with Phase 3

The per-request arena is PROVEN and sufficient for the hot path. The scope-exit leak (~41 strings/request) is mitigated by `max_keepalive_reqs`. Scope-exit RC is the "production at scale" answer, not the "Forge exists" answer. It is a deep, all-or-nothing compiler change (the iter-88 lesson: you cannot safely drop without counting) that benefits from a dedicated session, not mid-Forge interleaving.

### Why Crown Jewels are Phase 6, not Phase 1

LiveView, WASM frontend, and auto-admin are each significant multi-week subsystems. Forge is competitive and usable for REAL apps after Phase 3 (typed data, sessions, auth, validation, OpenAPI). The Crown Jewels are the "why Forge is special" endgame, not the "why Forge is usable today" bar.

### The dependency graph

```
Phase 0 (NEARLY DONE) -----> Phase 1 (typed core) -----> Phase 2 (data)
                                     |                        |
                                     v                        v
                              Phase 1.5 (Postgres)     Phase 3 (security)
                                                              |
                                                              v
                                                       Phase 4 (ORM)
                                                              |
                                                              v
                                                       Phase 5 (distribution)
                                                              |
                                                              v
                                                    Phase 6 (crown jewels)
                                                              |
                                                              v
                                                    Phase 6.5 (microservices moat)
                                                              |
                                                              v
                                                     Phase 7 (hardening)

PARALLEL TRACKS (no dependency on Forge phases):
  Core A1 (beat-C perf S2-S5) -- pure compiler, Tier-3 gated
  Core A3 (multicore scheduler) -- pure runtime, Tier-2 gated
  Core A2 (scope-exit RC) -- runtime+compiler, Tier-3 gated, dedicated session
  Core A4 (Erlang distribution) -- post-Forge
  Core A5 (REPL) -- post-Forge
  Core A6 (WASM m7+DOM) -- gates Phase 6 Crown Jewel 3
```

### Realistic timeline (solo development)

| Milestone | Phases | Effort | Calendar (solo, gates pass clean) | Calendar (with 1 gate-fail per phase) |
|-----------|--------|--------|----------------------------------|--------------------------------------|
| M0: Keystone | Phase 0 | 3-5 iters | DONE | DONE |
| M1: Backend-usable | Phase 1 | 5-8 iters | 4-6 weeks | 6-8 weeks |
| M2: Production-viable | Phases 1.5, 2, 3 | 16-25 iters | 12-20 weeks | 16-26 weeks |
| M3: Full-stack-usable | Phase 4 | 10-15 iters | 8-12 weeks | 12-16 weeks |
| M4: Full-stack-dominant | Phases 5, 6, 6.5 | 27-43 iters | 20-32 weeks | 28-44 weeks |
| M5: 1.0-hardened | Phase 7 | continuous | -- | -- |

**Realistic 1.0 release (all phases): 18-24 months solo, or 8-14 months with a small team.**

The critical path is Phases 0-3 (M0 -> M2): ~6-10 months solo to production-viable backend-only Forge. This is where the adoption argument becomes credible.

---

## 8. THE LOOP NEVER STOPS

The loop is defined by its invariants, not its end condition:

1. **At most ONE bootstrap reconverge in flight at any instant.** This rule overrides every throughput desire.
2. **Green-or-hard-revert.** A red tree is never debugged forward. Revert, re-probe, re-design.
3. **Verify before building.** No phantom work on stale assumptions.
4. **Additive-only by default.** New field, not new op-kind. Default-OFF, not default-ON.
5. **Source-only commits + permanent guards.** Every fix adds a test. Every bug can never silently return.
6. **Kill-on-timeout mandatory.** No spawned binary ever runs without a timeout.
7. **Record everything.** HEAD, fixpoint SHA, what is proven. Zero context loss.

The loop does not stop because there is always a next increment: a Forge feature to build, a Core plumbing to wire, a performance stage to validate, a guard test to add. The milestones are checkpoints on an infinite road, not destinations.

The commitment: maximal ambition, executed one verified increment at a time, never stopping, never shipping broken, never losing what was built.


---

# PART II â€” ADVERSARIAL CORRECTIONS (binding; overrides Part I where they conflict)

The adversary review (15 issues, 1 FATAL) confirmed Part I is a sound, well-sequenced
roadmap â€” better than 90% of language plans â€” but flagged ONE habit to kill: **promoting
DESIGNED to PROVEN.** Where Part I says "PROVEN / WIN today" for things not yet in shipping
code, Part II is the ground truth. These corrections are binding.

**Ground truth (Part I's header is stale):** HEAD = `aa72279`, regression = **436/436** both
RC modes, fixpoint `81B00D19`. (Part I's "HEAD 6835426 / 448 tests" is wrong â€” corrected.)

## The FATAL correction

**1. Spawn-per-connection is a gated KEYSTONE, not a Phase-1 freebie.** Part I lists it as
Phase 1 #8, Tier-0 "pure NOVA, no reconverge." It is NOT: `forge.nova` has **zero spawn
calls** today, and per-connection green tasks + per-task arena is a serve/scheduler/arena
**rearchitecture** touching the most dangerous subsystems (green scheduler + arena memory +
concurrent tasks). If it stalls, all of Phase 1+ blocks. **Correction:** treat it as its own
carefully-gated item **Phase 1a**, de-risked with a probe FIRST (spawn a task per accept,
arena per task; verify under `green_scale` + ASAN before wiring it into `serve`). Highest-risk
item in Phase 1 â€” dedicated attention, not a one-line table row.

## HIGH corrections

**2. NOVA-core-proven â‰  Forge-exposed.** Part I's "Forge today 8/20 WIN" conflates *core
capability* with *framework exposure*. Reality: only ~4 are real in `forge.nova` code today;
the rest are NOVA-core-proven (arena, crash-isolation primitives, green concurrency) but **not
yet wired into the 562-line MVP**, or DESIGNED. **Correction:** the scorecard's TODAY column =
NOVA-core capability; "Forge-exposed today" is ~4. No "WIN today" for a capability the
framework doesn't yet expose.

**3. Scope-exit RC stays DEFERRED; the interim mitigation must actually be BUILT.** Part I
parallelizes it with Phase 3 at "4â€“5 iters." It has 1 FATAL + 6 HIGH unresolved findings and
previously produced **33 UAFs** â€” it's research-grade, dedicated-session, all-or-nothing, not
bounded Phase-3-parallel work. AND `max_keepalive_reqs`/worker-recycle (the interim leak
mitigation Part I hand-waves) **does not exist** â€” it must be built in Phase 1/2 as the real
interim answer for sustained load.

**4. Phase 1 is NOT "zero compiler changes."** At least the value-polymorphic response
coercion / bare-struct-return path may need a compiler hook, and spawn-per-conn touches the
runtime. **Correction:** re-tier honestly per item; expect some Tier-2/3 work in Phase 1.

**5. Performance Stage 2 is REVERTED and not understood â€” re-diagnose, don't "re-validate."**
**Correction:** treat S2 as an open investigation (real bug vs parallel-load flake) with a
probe, before counting it as a bounded win.

**6. forge/ migration: incremental, never a 40-file atomic commit.** **Correction:** (a) land
the module-resolution change (search order incl. a stdlib/pkg path) FIRST as its own gated
increment; (b) move files in small batches, each gated 436-green; (c) no big-bang.

**7. Adoption/feedback track from EARLY, not Phase 7.** **Correction:** dogfood the flagship
demos from M1 (they ARE the feedback), write getting-started at M1, treat DX friction found
there as loop input.

## MEDIUM corrections

**8. OpenAPI (Phase 3) needs the compiler to expose route/type AST** â€” a real Core feature,
not free. Sequence "reflect route signatures + types" as a Core item before the generator.

**9. Multicore (A3) + Forge-runtime work BOTH touch `nova_runtime.c`** â†’ not truly parallel
through the serial gate. "Parallel" = design/independent-module parallelism; concurrent
`nova_runtime.c` edits are serialized by the Tier-2/3 gate. Sequence them explicitly.

**10. Postgres-via-libpq vs the zero-dep moat.** libpq is a link-time dependency â†’ a
libpq-linked binary is no longer "zero-dep single binary." **Correction:** SQLite (compiled-in)
is the zero-dep default; Postgres is either static-linked libpq (one binary, but a build dep)
or a native wire-protocol driver (later, true zero-dep). State the tradeoff; don't claim
zero-dep for the Postgres build.

**11. Backend-only microservice basics pulled EARLY.** `/health` + graceful shutdown are in
Phase 2; a real microservice needs them near launch â†’ land them in Phase 1/1.5 for the
backend-only milestone (M1/M2).

**12. `remote_spawn` is a STUB â†’ Phase 6.5 distribution needs it built first** as a gated Core
prerequisite. Don't assume it.

**13. Innovation claims labeled honestly.** "Channel-graph tracing (world-first)",
compile-time SQL, and compile-time OpenAPI are **DESIGNED/ASPIRATIONAL**, not shipped. Only
claim "world-first" once it runs. (Innovations 1, 2, 3, 7, 8, 9 are genuinely SHIPPED; 4, 5, 6
are not yet.)

## Net

Part I is the right roadmap. Part II keeps it honest (DESIGNED â‰  PROVEN), reorders the one
fatal mis-scope (spawn-per-conn = a gated keystone), and makes the interim leak mitigation +
adoption feedback real. With these, the loop doesn't stall and the claims survive contact with
reality. Adversary record: `NOVA_EXECUTION_ADVERSARY.json`.

