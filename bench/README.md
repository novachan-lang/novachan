# NOVA Continuous Benchmarks

This directory tracks compiler performance across commits. Every bench is a small NOVA program that:

1. Does measurable work (so timing is meaningful)
2. Records its own elapsed time and RC stats
3. Prints structured output the harness can parse

## Running

```powershell
# From the repo root
powershell ./bench/run_bench.ps1
```

This compiles each bench in `bench/programs/`, runs it once, and appends a JSON line to `bench/history.jsonl` keyed by the current commit SHA.

## Regression check

```powershell
powershell ./bench/regression_check.ps1
```

This reads the last two entries from `history.jsonl` and exits non-zero if any bench got more than 20% slower. Run this in CI after every push.

## Adding a bench

Create `bench/programs/yourname.nova`. It must:

- Print one line of the form `BENCH yourname elapsed_ms=<n>` to stdout
- Optionally call `rc_stats_dump()` so the harness records RC ops
- Run for ≥ 10 ms but ≤ 5 s (the harness times out at 30 s)

Then add `yourname` to the `$benches` list in `run_bench.ps1`.

## Why JSONL not a database

Cross-platform, diff-friendly, grep-friendly, never corrupts on partial write. If we outgrow it later we can re-index.

## What's recorded

```json
{
  "ts": "2026-05-31T03:00:00Z",
  "commit": "9379af3",
  "bench": "list_push_1m",
  "elapsed_ms": 782,
  "rc_inc": 0,
  "rc_dec": 1000,
  "mode": "default"
}
```

Modes: `default`, `no_track8`, `auto_arena`, `track8_drop`. The harness records the mode it ran in so cross-mode comparisons make sense.
