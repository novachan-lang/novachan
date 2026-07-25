# PROJECT_STATE — the ONE live plan (read first, update every commit)

Governed by `OPERATING_MODEL.md`. Every other *_PLAN/*_STATE/*_ROADMAP/*_GAPS doc is REFERENCE or
HISTORICAL — this is the single source of truth for "where are we and what's next."

_Last updated: 2026-07-25._

## Current campaign
Hardening + completing the core toward "ready to use everywhere," marching the remaining real gaps
in dependency order. **The compiler core is genuinely mature** — self-hosting, C-level scalar/struct
perf, sound type system (sound-by-default), working concurrency (N>1 gated), extensive stdlib +
Forge framework. Remaining work is targeted gaps + ecosystem, not foundations.

## Done + verified recently (gated: reconverge + both-mode unless noted)
- 4 root compiler gaps (Result/Option polymorphic sum, Option-import, trait multi-type, module-scope
  let-shadow) + complete high-level `std/core` (seq/list/dict/num/str/sort/result/opt) + README.
- **GAP 5 module-level non-scalar STORAGE** (`ccb70ba6`) — top-level `let cache={}`/`[]`/`channel()`
  is one shared instance readable+mutable by named fns; the green_scale_test N>1 race fixed via
  capture-exclusion. Memory: `project-module-level-storage`.
- **L11 Phase 1 collision detection** (`724dad65`) — two modules exporting the same name → clear
  error (namespace now SOUND). Full mangling (Phase 2) DEFERRED, low ROI; map in `L11_NAMESPACING_MAP.md`.
- **#12 signal SIGHUP-reload** + **#18 file perms/symlinks** (chmod/umask/symlink/readlink) — CI
  gating (commit pending green).
- Perf ground-truth: float arrays are **~1.7×C** (not the stale "160×"); closing to 1.0×C is a
  foundational effort (SSA repr tracking) — parked deliberately.

## Next items — dependency-ordered, VERIFY before starting (grep the live code)
Verdicts from the 2026-07-25 fleet audit (18 agents against live code):

**Do-now, bounded, verifiable on this Windows box:**
- **#26 pkg-manager wiring** — `nova install` flat-downloads direct deps; it must use the (real)
  `pkg_resolve` + write/read `nova.lock` for reproducible installs. Highest ecosystem value.
- **#30 REPL** — mostly done; wire `_test_repl.ps1` into CI (gate-existing). Small.
- **#16 HTTP-client redirects** — 3 bounded sub-cycles (redirect-follow, cookie jar, proxy). Needs a
  loopback test.

**Do-now, high-value, but NOT self-verifiable here (Linux/ARM/OpenSSL runtime):**
- **#9 Windows TLS server** — SChannel server handshake; HTTPS on the dev's own OS. Verifiable on
  Windows, large.
- **#10 Linux epoll wiring** — CVE-class select() FD_SETSIZE stack corruption; the epoll poller is
  already built, needs wiring into the default path. Linux-only to verify.
- **#5 ARM/aarch64 fiber asm** — ~30-40 lines naked asm; can't execute aarch64 here.
- **#8 ALPN server** — OpenSSL `SSL_CTX_set_alpn_select_cb`; loopback test.

**Defer (memory-safe / large / XL — do NOT re-attempt standalone):**
- #1/#2/#3 RC leaks — MEMORY-SAFE (leak-only, never UAF), regression-pinned. Bundle into ONE
  supervised RC-ownership cycle (shared root: drop provably-owned call-arg temporaries; UAF-adjacent).
- #19 unix sockets, #23 IANA tz, #29 profiler, #31 signed installer (needs cert) — large/XL.

**Stale-done (already gated; ledger label was wrong):** #6 (N>1 I/O via single-poller), #21
(casefold/graphemes), #27 (nova doc), #28 (property-test).

## Reference (historical detail — NOT the live plan)
`NEXT_50_EXECUTION_2026_07_22.md` (task table + audit note), `CORE_GAPS_2026_07_03.md`,
`NOVA_MASTER_PLAN_2026_07_10.md`, `L11_NAMESPACING_MAP.md`, memory `MEMORY.md`.
