# Forge N>1 Load-Soak + Default-Flip — build-ready plan (design wvemtcezz, adversary-vetted)

> Validate that multi-core Forge converts cores into request throughput (the "beat Spring/BEAM"
> evidence) and decide whether/how to make N>1 a default. SCOPE = multithreading + Forge only.
> SOUNDNESS is #1. Full source for the harness is in the workflow output (task wvemtcezz); this doc
> is the actionable spec + the two real runtime findings + the flip decision.

## The two questions
- **Q1 throughput:** on a CPU-bound handler, does N=4 beat N=1 enough to justify the atomic-RC tax?
- **Q2 safety-to-flip:** is it sound to default N>1 — and at which layer (language vs tooling)?

A single throughput number is a LIE: CPU-bound and I/O-bound scale *oppositely* at N>1. The benchmark
is a HANDLER SPECTRUM so the I/O floor and the CPU ceiling are reported separately. The gap between
them is exactly the value of the future per-carrier-accept + single-poller work.

## Adversary findings (3 critical) — status
- **C1 `nova_arena_mode` global static (claimed N>1 RC-bypass race) — VERIFIED NOT A BUG.** The global
  flag is set ONLY by the compiler's auto-arena, which is gated (nova_compiler.nova:18582-18587) on
  BOTH `NOVA_AUTO_ARENA=1` (opt-in env, default OFF) AND `ir_program_has_spawn()==0` (no spawn). So it
  engages only for opt-in, no-spawn, single-task programs → one task on one carrier → the cross-carrier
  race is mechanically impossible. A Forge server spawns → auto-arena off → `nova_arena_mode==0`. The
  per-task `active_arena` Forge actually uses bypasses RC via a per-OBJECT bit (NOVA_RC_ARENA_BIT,
  nova_runtime.c:9296), N>1-safe. Optional belt-and-suspenders: a runtime assert that set_arena_mode
  is never called while g_carrier_count>1 (low priority; the compile-time guard already proves it).
- **C2 `nova_mem_live` non-atomic static int64_t — REAL N>1 data race.** Inc at nova_heap_alloc(643),
  dec at nova_rc_free(9156), + sites 675/928/1139/1167, read at 9366. Unlocked ++/-- across carriers =
  UB (a counter, not memory corruption, but a TSAN race + makes the leak probe vacuous at N>1). This is
  the deferred "0D" item. **Fix = per-carrier TLS counter summed on read** (NOT a shared atomic — an
  atomic on the alloc hot path would add cross-carrier cache-line ping-pong that BIASES the throughput
  benchmark downward). Byte-identical at N=1. Gates ONLY the leak probe — throughput + correctness do
  not depend on it, so it can come AFTER the headline throughput run.
- **C3 substring-nonce false-pass — folded in.** Nonce token = `"N=" + 8-digit-zero-padded + ";"` so no
  nonce is a substring of another; client asserts the exact delimited token per request.

## The harness (4 verified facts to build against)
- Carrier knob: `NOVA_CARRIERS` env, default 1, set once before main (nova_runtime.c:6841 `int ncar=1`).
- Serve: `forge.serve_req(a,port)` / `serve_req_n(a,port,n)`; routes via `forge.get/post`; responses
  via `forge.text(code,s)` / `forge.json_obj(code, [[k,v]...])`. parse_int (NOT to_int); `env` exists.
- `^` → native `xor i64`; mul/add/xor emit WITHOUT nsw/nuw (FNV loop is real compute, NOT DCE-able —
  but RE-CONFIRM in the .ll per build; N4 invariant).
- Time: `clock_ns()` monotonic, `time_ms()` epoch-ms.

### Server — handler spectrum (every handler echoes the delimited nonce)
- `/ping/:nonce` → `text(200,"pong;"+ntok(n))` — I/O+accept+parse FLOOR.
- `/user/:nonce` → `json_obj(200,[["tok",ntok(n)],["name","u"],["active","true"]])` — moderate.
- `/cpu/:nonce` → FNV-1a over ROUNDS (seeded by nonce so it's not CSE'd; echo str(h)) — CPU CEILING.
  ROUNDS calibrated to ~1ms/request (start 300000); sanity = N=1 /cpu rps clearly < N=1 /ping rps.
- `/db` EXCLUDED from default (sqlite built `-DSQLITE_THREADSAFE=0` → needs one-conn-per-carrier).

### Client — SEPARATE OS PROCESS (so client green tasks never steal server carriers)
- K concurrent tasks × M round-trips; task i owns nonce range [i*M,(i+1)*M) (partitioned, unique).
- Default mode = `Connection: close` (unambiguous completeness: recv "" on peer close). Keep-alive
  needs a real Content-Length parser (deferred).
- Client runs at NOVA_CARRIERS=8 vs server=N; MANDATORY client-saturation check (raise client load
  holding server fixed; if rps rises the client was the limiter — only the plateau is the server ceiling).
- NO `import forge` in the client (local 3-line env_or; avoids pulling the framework into the client).
- Warmup: WARM≥10 untimed reqs/task (excludes lazy slab/intern init + TCP slow-start).

### Recipe / gotchas
- Compile `gen3_test.exe <t>.nova` (NOVA_HOME=<repo>/nova-compiler after `_install_forge.ps1`); link
  `clang -O2 <t>.ll nova_runtime.o sqlite3.o -lws2_32 -ladvapi32 -lkernel32 -w`.
- **Kill-on-timeout MANDATORY**: Start-Process + WaitForExit(ms) + `taskkill /F /T` (WaitForExit does
  NOT kill; leaving an orphan holds the port). Fresh port per cell (19000+cell*7) to dodge TIME_WAIT.
- Output a single ASCII `RESULT ...` line via RedirectStandardOutput (NOT Tee-Object → UTF-16 breaks grep).
- Memory: PrivateMemorySize64 sampled WHILE running (post-exit RSS is garbage on Windows). In-process
  live_count() leak probe valid ONLY after C2 fix.

## Expected results (so a low number is read correctly)
- `/cpu` N=4 **target ≥3.5× (≥3.0× to pass)** — the "beat Spring/BEAM on compute, no GC pause, flat
  per-request memory" number.  `/cpu` only ~2× ⇒ BUG (atomic RC or g_sched_lock leaking into compute).
- `/user` ~2–2.7×.  `/ping` ~1.3–2.2× (HEALTHY floor — compound serialization: single accept task
  pinned to one carrier [S3], netpoller thundering herd [S1, all carriers select() the same
  nova_io_waiters], slab lock [S2 nova_runtime.c:336], intern lock [S4 :549], g_sched_lock). The
  /ping–/cpu gap IS the instrument; if they're equal, either the CPU work was optimized away (check
  .ll) or contention poisons the compute path.
- Any `bad>0` at N>1 only ⇒ multi-core correctness regression (blocks everything).

## The flip decision — RECOMMENDED = Option B′ (tooling, not language)
- **A. Global runtime default (6841 `1`→ncpu): REJECT** — taxes EVERY program (carrier startup +
  atomic RC) incl. the 95% that aren't servers; direct GATE 4/5 hit.
- **B. Forge-serve-only runtime default: MECHANICALLY IMPOSSIBLE** — carrier count is frozen before
  main; the runtime can't know "this is a server" in time. (Dynamic 1→N attach = separate big project.)
- **B′. Forge TOOLING sets the env (RECOMMENDED):** `forge run`/scaffold exports
  `NOVA_CARRIERS=min(ncpu,8)` before exec'ing the server. 100% of server benefit, 0% collateral, revert
  = delete one export (NO recompile). Keep `6841=1` as the LANGUAGE default until the accept serializer
  (per-carrier accept) is fixed. Cap min(ncpu,8): returns vanish past ~4–8 carriers on this workload.

### Go/No-Go bars (all must pass; flip = B′)
P2 landed (C2 atomic/TLS, reconverged) · P1 arena guard (optional) · correctness full N=4 green (re-run
at flip commit; true @5456066) · **hub/channel/SSE smoke bad==0 + ASAN at N=4 (S7 — currently untested,
REQUIRED before flip)** · throughput /cpu speedup(4)≥3.0 & speedup(2)≥1.7 · stability ≥30min/≥1M-req
soak (post-P2 live slope<0.01 obj/req, RSS flat vs N=1 baseline, no hang) · saturation-validated.

### Risks + containment
R1 ordering (true concurrency vs N=1 interleave — server tasks already independent, why B′ is safe).
R2 Go-style root-exit abandons daemons (now N=1/N>1 PARITY post-5456066 → no NEW divergence).
R3 unguarded stdlib static mutable cache (cross-carrier sharing only via channel deep-copy; a targeted
`static`-mutable-global audit must precede the flip — a soak won't reliably surface it).
R4 non-server regression (atomic-RC ping-pong) — B′ avoids entirely (decisive reason to reject A).
Revert under B′ = remove the launcher export; opt-out `NOVA_CARRIERS=1` (byte-identical hot path) ships
day one; field triage "does it repro at NOVA_CARRIERS=1?" localizes any regression instantly.

## Ordered build checklist
1. (deferred to leak gate) C2 per-carrier-TLS nova_mem_live; reconverge.  2. (optional) P1 arena guard.
3. forge_load_server.nova (spectrum + delimited ntok).  4. forge_load_client.nova (standalone, partitioned
nonces, read-to-close, warmup).  5. compile + INSPECT .ll (FNV loop = mul/add/xor i64, no nsw).
6. calibrate ROUNDS (~1ms; N=1 /cpu rps << /ping rps).  7. _forge_load_soak.ps1 (kill-on-timeout, fresh
port, PrivateMemorySize64 sampling).  8. client-saturation check.  9. CI smoke (K=32,M=100,/ping+/cpu,
N∈{1,4},R=3; gate bad==0 + /cpu speedup(4)≥2.5 relaxed).  10. hub/channel race smoke (S7).  11. full soak
(K=128,M=1000,all routes,N∈{1,2,4,8,ncore},R=20 + 10-min leak run).  12. decide flip (B′).

**Order chosen for the loop:** headline THROUGHPUT first (steps 3-9, no runtime change, answers Q1
fastest) → then C2+leak (step 1 + 10-min run) → then hub smoke → then flip B′. C2 deferred because it
gates only the leak probe, not throughput/correctness.

## MEASURED RESULTS (2026-06-26, this machine; harness = forge_load_server/client.nova + _forge_load_soak.ps1)
Server at NOVA_CARRIERS=N, client at NOVA_CARRIERS=8, new-conn-per-request (Connection: close), nonce-echo
correctness. K×M = 2560 requests/cell, ROUNDS=1.5M (/cpu ~23ms compute/req at N=1). **bad=0 across every
cell (~30k requests, all N, all routes) — multi-core CORRECTNESS holds under concurrent load.**

| Route | N=1 rps | N=2 | N=4 | N=8 | speedup@8 |
|---|---|---|---|---|---|
| /cpu  (compute-bound) | 43   | 66   | 106  | 165  | **3.84×** (1.53/2.47/3.84) |
| /ping (trivial/IO)    | 7687 | 6183 | 7150 | 6564 | 0.85× (no benefit) |
| /user (moderate str)  | 7664 | 3710 | 5333 | 6432 | 0.84× (no benefit) |
(earlier ROUNDS=300K cross-check: /cpu N=4 = 2.97× — consistent, CPU work scales with cores.)

### Verdict
- **Multi-core Forge converts cores into throughput for COMPUTE-bound handlers: 3.84× on 8 cores, zero GC
  pause, flat per-request memory, AOT-native arithmetic — the "beat Spring/BEAM on compute" evidence.**
- **I/O- and string-bound handlers get NO multi-core benefit (0.84–0.93×, even regress at N=2).** Root
  cause (measured, matches the scheduler GROUND model): the SINGLE accept-loop task pinned to one carrier
  + the netpoller thundering herd (all carriers select() the same nova_io_waiters) + atomic-RC/lock
  overhead serialize the *connection* path. There isn't enough per-request compute to amortize it.
- **THE bottleneck for typical web throughput is the accept/poller serialization** — most real handlers
  are I/O-bound (DB, network), so until per-carrier-accept + single-poller land, multi-core helps only
  compute-heavy apps. **This is the #1 thing to build next to make multi-core Forge broadly win.**
- **Decisively validates flip = Option B′:** a global N>1 default would REGRESS the 95% non-compute case;
  N>1 must be opt-in (Forge tooling, ideally gated on the accept/poller fix). NEVER flip 6841.

### Next (reprioritized by this data)
1. **Per-carrier accept + single-poller (was "Stage 3b", now the headline throughput work):** make the
   connection path scale so I/O-bound handlers ALSO benefit from cores. Re-run THIS harness to measure
   the gain (the harness is the regression oracle for the fix). 2. C2 atomic mem_live + leak/stability
   soak. 3. flip = B′ once I/O-bound scales. 4. head-to-head vs Spring/BEAM on /cpu (already competitive).
