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
