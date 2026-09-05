# prism/obs — observability

**COMPLETE — 5 modules, all KAT-gated.**

| Module | Purpose |
|---|---|
| `prism_obs.nova` | The observability facade over crash/flag/perf/telemetry |
| `prism_telemetry.nova` | Typed analytics events -- a schema change breaks the BUILD (#96) |
| `prism_crash.nova` | Crash reports WITH the replay log attached (#97 #128) |
| `prism_perf.nova` | Per-face invalidation counts, latency profiling (#107) |
| `prism_flag.nova` | Feature flags + A/B, wrapping the existing `forge_flags`/`forge_ab_test` modules (#94 #95) |
