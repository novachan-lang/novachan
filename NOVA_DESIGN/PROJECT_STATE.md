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
- **#12 signal SIGHUP-reload** + **#18 file perms/symlinks** (chmod/umask/symlink/readlink) — DONE,
  gated (reconverge + both-mode + N>1 all green). KATs `_kat_signals` / `_kat_perms`.
- Perf ground-truth: float arrays are **~1.7×C** (not the stale "160×"); closing to 1.0×C is a
  foundational effort (SSA repr tracking) — parked deliberately.
- **#26 pkg-manager lockfile** — `nova install` now honors `nova.lock` (reproducible, npm-ci-style)
  + writes it otherwise, via real `lockfile_read/write`. Gated (reconverge + both-mode). KAT `_kat_pkg_lock`.
- **`NOVA_LANGUAGE_FEATURES.md`** — the authoritative high-level feature reference (137 features,
  verified). THIS is the coding standard: write NOVA from it (interpolation, comprehensions, pipe,
  HOF, `match`, `Result`/`?`/`??`, UFCS) — not hand-rolled loops. Referenced from OPERATING_MODEL §9.

## Next items — dependency-ordered, VERIFY before starting (grep the live code)
Verdicts from the 2026-07-25 fleet audit (18 agents against live code):

**Do-now, bounded, verifiable on this Windows box:**
- **#16 HTTP-client redirects** — sub-cycle 1 (redirect-FOLLOW) DONE: `http_get_follow(url, max)` +
  `is_redirect` in forge/forge_http_client.nova (follows 301/302/303/307/308 via Location, budget
  guard); KAT `_kat_http_redirect` (loopback 302→200). REMAINING: sub-cycle 2 cookie jar, sub-cycle 3
  proxy/CONNECT, + relative-Location resolution. ← NEXT (sub-cycle 2)
- (#26 pkg-lock — DONE. #30 REPL — DONE: verify-before-act found it was BROKEN, not gate-existing —
  a stale `output/nova_runtime.c` link path from the compiler relocation; fixed with robust
  resolution in `repl.nova` + wired `_test_repl.ps1` into nova_ci as gate `[CI 2e2/3]`.)
- **#16 HTTP-client redirects** — 3 bounded sub-cycles (redirect-follow, cookie jar, proxy). Needs a
  loopback test.

**Bounded quick-wins: ALL MARCHED this session** (#12/#18/#26/#30/#16). Remaining = large cohesive
efforts (below) — each a focused multi-hour deliverable, not a quick win. Do them one focused push at
a time to the FULL-ARC gate; do NOT fragment/rush (esp. crypto).

**#9 Windows TLS server — NEXT focused push (highest value, verifiable on Windows).** Precise scope
(one cohesive deliverable): (1) `nova_load_server_cert(pfx_path, password)` -> PCCERT_CONTEXT via
PFXImportCertStore + find-cert-with-private-key; (2) `tls_listen(port, pfx, pass)` -> listen socket +
AcquireCredentialsHandle SECPKG_CRED_INBOUND with the cert (mirror the client at nova_runtime.c:19436
but INBOUND + paCred); (3) `tls_accept` -> accept TCP + server AcceptSecurityContext handshake loop
(server variant of nova_tls_handshake); (4) reuse tls_send/recv (context-based); (5) integration test:
PowerShell New-SelfSignedCertificate -> Export-PfxCertificate, spawn NOVA TLS server, tls_connect
client, verify a byte round-trips. RED arc (runtime C -> reconverge + both-mode + ASAN).
**CRITICAL DESIGN (verified 2026-07-25):** the cert APIs (PFXImportCertStore, CertEnumCertificatesInStore,
CertGetCertificateContextProperty, CertDuplicateCertificateContext, CertCloseStore, CertFreeCertificateContext)
live in crypt32.lib, which is NOT linked at ANY of the ~339 link sites (all link -lws2_32/-ladvapi32/
-lkernel32 only). DO NOT add -lcrypt32 (339-site cross-cutting change) — instead LoadLibrary("crypt32.dll")
+ GetProcAddress the ~6 cert fns at tls_listen time, keeping #9 a SELF-CONTAINED nova_runtime.c change
(zero build-script edits). Server conn's NovaTlsConn.cred stays zeroed (srv owns the INBOUND cred) — check
tls_close handles a zeroed CredHandle. Handshake mirror = nova_tls_handshake @19349 but AcceptSecurityContextA.
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
