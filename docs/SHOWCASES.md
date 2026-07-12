# NOVA Showcases — real programs, and what they revealed

These are substantial, self-verifying programs built to **use** NOVA the way a real developer would —
not unit tests of one feature, but whole small applications. They double as worked examples and as a
map of where the language is production-solid versus where it still has sharp edges. Each lives in
`nova-compiler/test_programs/` and is wired into the regression suite.

## The programs

| Showcase | Domain / subsystems exercised | Result |
|---|---|---|
| [`showcase_taskflow_test.nova`](../nova-compiler/test_programs/showcase_taskflow_test.nova) ([walkthrough](SHOWCASE_TASKFLOW.md)) | REST service: routing + path/query params + auth middleware + typed JSON + SQLite + validation + pagination + aggregation | ✅ passes — **found + fixed CORE_GAP 0.9** |
| [`showcase_report_test.nova`](../nova-compiler/test_programs/showcase_report_test.nova) | CLI analytics: CSV parse + dict aggregation + ranking + aligned table + JSON | ✅ passes — **found CORE_GAP 0.10** (worked around) |
| [`showcase_stats_test.nova`](../nova-compiler/test_programs/showcase_stats_test.nova) | Numerics: descriptive stats + OLS linear regression + R² over float arrays | ✅ passes — **found CORE_GAP 0.11** (worked around) |
| [`showcase_sudoku_test.nova`](../nova-compiler/test_programs/showcase_sudoku_test.nova) | Backtracking solver: deep recursion + integer grid + in-place integer mutation | ✅ passes clean |
| [`showcase_parallel_test.nova`](../nova-compiler/test_programs/showcase_parallel_test.nova) | Concurrency: spawn + channels + map-reduce + deep-copy isolation (+ multi-core) | ✅ passes clean (incl. `NOVA_CARRIERS=4`) |
| [`showcase_calc_test.nova`](../nova-compiler/test_programs/showcase_calc_test.nova) | Recursive-descent expression evaluator: tokenizing + mutual recursion + precedence + error handling | ✅ passes clean (valid exprs + all malformed rejected) |
| [`showcase_life_test.nova`](../nova-compiler/test_programs/showcase_life_test.nova) | Conway's Game of Life: 2D grid, double-buffered generations, neighbor rules | ✅ passes clean (still-life + oscillator verified) |
| [`showcase_graph_test.nova`](../nova-compiler/test_programs/showcase_graph_test.nova) | BFS shortest paths over an adjacency list-of-lists, integer nodes + queue | ✅ passes clean |
| [`showcase_hex_test.nova`](../nova-compiler/test_programs/showcase_hex_test.nova) | Binary codec: bytes↔hex + byte-wise XOR (bytes value type + bit ops) | ✅ passes clean (round-trip + OTP identity) |
| [`showcase_bst_test.nova`](../nova-compiler/test_programs/showcase_bst_test.nova) | Binary search tree: recursive struct nodes + mutable child links + insert/search/traversal | ✅ passes clean (in-order = sorted) |
| [`showcase_rpn_test.nova`](../nova-compiler/test_programs/showcase_rpn_test.nova) | RPN calculator returning `Result` (ok/err) with `match`-based error handling over a stack | ✅ passes clean (valid + all error cases) |
| [`showcase_hof_test.nova`](../nova-compiler/test_programs/showcase_hof_test.nova) | Functional pipeline: map/filter/reduce with `x => expr` lambdas, capturing closures, a closure factory | ✅ passes clean |
| [`showcase_kvstore_test.nova`](../nova-compiler/test_programs/showcase_kvstore_test.nova) | Mini Redis-like key-value DB: command parsing + dict store + INCR/DECR/APPEND/DEL + error handling | ✅ passes clean (scripted session) |
| [`showcase_date_test.nova`](../nova-compiler/test_programs/showcase_date_test.nova) | Calendar math: leap years, day-of-year, days-between, day-of-week (Zeller's congruence) | ✅ passes clean (verified vs known dates) |
| [`showcase_sieve_test.nova`](../nova-compiler/test_programs/showcase_sieve_test.nova) | Sieve of Eratosthenes at **scale** (100k-element array + nested loops), verified vs π(n) | ✅ passes clean (π(100000)=9592) |
| [`showcase_vm_test.nova`](../nova-compiler/test_programs/showcase_vm_test.nova) | A bytecode VM: operand stack + registers + jumps → real loops (runs factorial + sum programs) | ✅ passes clean (an interpreter in NOVA) |
| [`showcase_mandelbrot_test.nova`](../nova-compiler/test_programs/showcase_mandelbrot_test.nova) | ASCII Mandelbrot fractal: float escape-time iteration `z=z²+c` in tight loops, rendered + verified | ✅ passes clean (renders the set) |
| [`showcase_timeline_test.nova`](../nova-compiler/test_programs/showcase_timeline_test.nova) | Project-timeline reporter **integrating 5 `std/` modules**: `std/time/datetime` (ISO parse + calendar + weekday + day arithmetic) + `std/text/pad` (aligned columns) + `std/math/stats` (gap mean/min/max) + `std/text/template` (`{{key}}` header) + `std/text/wrap` (footer reflow) | ✅ passes clean (dates verified vs known calendar; first cross-`std/` integration test) |
| [`showcase_physics_test.nova`](../nova-compiler/test_programs/showcase_physics_test.nova) | 2D particle sim: `std/math/vector` + `std/math/interp` — 4 particles × 50 steps (200 `vec_add`/`vec_scale` calls), damped + undamped | ✅ passes clean — **stress-validated: no float-return-uninit, no drift** in float-array loops |
| [`showcase_subnet_test.nova`](../nova-compiler/test_programs/showcase_subnet_test.nova) | IPv4 subnet planner: `std/net/ip` — CIDR parse (`/0`../`/32`), network/broadcast/host-count, membership on high-bit blocks (200.x, 255.255.255.255) | ✅ passes clean — **stress-validated: `>>` arithmetic-shift correctly masked**, high-bit (≥2³¹) IPs round-trip |
| [`showcase_codec_roundtrip_test.nova`](../nova-compiler/test_programs/showcase_codec_roundtrip_test.nova) | Binary round-trip through 6 codecs: `std/encoding/{hex,base32,base45,base58,z85,percent}` over bytes with embedded `0x00` + `0xFF` | ✅ passes clean — **stress-validated: all 6 codecs binary-safe (no NUL-truncation)** |
| [`showcase_schedule_test.nova`](../nova-compiler/test_programs/showcase_schedule_test.nova) | Recurring-event scheduler: `std/time/datetime` + `std/time/duration` — weekly occurrences w/ month rollover + **negative-epoch** (1969) round-trip | ✅ passes clean — **stress-validated: `_fdiv`/`_fmod` floor-division correct for pre-1970 epochs** |
| [`showcase_analytics_test.nova`](../nova-compiler/test_programs/showcase_analytics_test.nova) | Descriptive-stats pipeline: `std/math/stats` — mean/median/variance/stddev/percentile over a textbook set + histogram + IQR outliers | ✅ passes clean — **stress-validated: float-array stats + percentile interpolation exact** |
| [`showcase_concurrency_test.nova`](../nova-compiler/test_programs/showcase_concurrency_test.nova) | Concurrency stress: `spawn` + channels + `std/sync/semaphore` — 8 workers × 500 increments on a channel-serialized counter + a permit-guarded critical section | ✅ passes clean at **N=1 and multi-core `NOVA_CARRIERS=4/8`** (gated in `_n_carriers_ci`): **counter=4000 no lost updates**, semaphore ceiling never exceeded |
| [`showcase_metrics_test.nova`](../nova-compiler/test_programs/showcase_metrics_test.nova) | **Capstone integration: the Forge web framework + `std/` together** — a metrics API (`GET /health`, `GET /api/stats`) dispatched in-process, computing `std/math/stats` results + a `std/time/datetime` timestamp, returned as forge JSON | ✅ passes clean — **framework + stdlib compose into one self-verifying service** (routing, 404, float JSON serialization all correct) |

Run any of them (Windows, kill-on-timeout runner) from `nova-compiler/test_programs`:

```powershell
powershell -NoProfile -File .\_run1.ps1   -Test showcase_sudoku_test      # pure-NOVA
powershell -NoProfile -File .\_run1db.ps1 -Test showcase_taskflow_test    # links SQLite
```

## What five real programs revealed about the core

**Two whole subsystems are production-solid** — validated by clean, first-try programs:

- **Integer / recursion / arrays / control flow** — the Sudoku solver's backtracking, flat integer
  grid, and in-place integer mutation are flawless in both RC modes.
- **Concurrency** — the parallel map-reduce (spawn, channels, send/receive, deep-copy isolation) is
  correct and stable single-threaded, in FULLRC, and under true multi-core (`NOVA_CARRIERS=4`).

**The sharp edges are concentrated in three specific paths** (see `NOVA_DESIGN/CORE_GAPS_2026_07_03.md`
for full detail and repros):

1. **Dynamic-type comparisons** — `any == string` / `!= string` used to segfault when the dynamic
   value held a non-string (e.g. `dict["missing"]` → int 0). **CORE_GAP 0.9 — FIXED** (box-aware
   `nova_rt_eq`/`nova_rt_neq`; reconverged byte-identical).
2. **Heap-string refcount ownership under aliasing** — a string that is both a dict key and a list
   element is prematurely freed when the list is mutated in place (**0.10**, use-after-free), and
   struct/closure heap fields leak on drop outside arenas (**0.8**). Both are the same RC-ownership
   area. *Workaround:* don't mutate a list of dict-key strings in place; build a fresh ranked list by
   selection instead.
3. **Float-return codegen** — a float-returning helper can read an uninitialized float slot and
   return garbage, layout-dependently (**0.11**). *Workaround:* avoid `sqrt` inside a float-returning
   helper; e.g. compute R² = cov²/(vₓ·v_y) rather than Pearson r.

## The takeaway for building in NOVA today

NOVA is already trustworthy for integer/logic/recursion/concurrency work — you can build real
backends, solvers, and parallel pipelines on it now. When you work heavily with **mutating lists of
heap strings that are also dict keys** or with **float-returning helpers**, use the workarounds above
until CORE_GAP 0.10 (RC-string ownership) and 0.11 (float-ABI codegen) get their dedicated fixes —
the two highest-value core-correctness projects, each with a precise repro already captured.

*Method note:* every one of these gaps was found by **using** the language, not by auditing it. The
audit-built gap ledger is one layer; building real programs surfaces the equally-real bugs that
ordinary code actually hits. Five programs in an afternoon found three.
