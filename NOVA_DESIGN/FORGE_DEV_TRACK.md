# FORGE DEV TRACK — rapid-dev phase (functional testing deferred to the end)

> **Baseline:** clean gate 621 PASS / 0 FAIL both RC modes (2026-07-02). From here we DEVELOP every remaining
> Forge feature to beat Spring Boot / Django / Phoenix, WITHOUT per-feature functional testing — to move
> fast. Each feature is written to a high NOVA standard, **double-checked** (correct? will it break anything
> downstream? blast-radius?), **syntax/compile-checked** (gen3 build, no run — NOT a functional test), and
> committed with a row below. At the end we run the **track-driven test pass**: go top-to-bottom, test each
> row, flip Status `untested` → `tested` (or `FIXED <commit>` if a bug is found + fixed).

## Rules
1. **Correctness twice.** Before every commit: is it correct per NOVA semantics, and does it break any
   existing feature? forge.nova / runtime / compiler edits (high blast-radius) = Opus, extra-careful; new
   LEAF modules = Sonnet 4.6 under an Opus spec + Opus review.
2. **Syntax check every no-test commit** (compile a minimal importer via gen3, no run). A parse error in a
   shared module cascades — never commit a non-compiling change.
3. **One row per feature** here, with the commit hash + exactly what the final test pass must verify.
4. NOVA gotchas to honor (hardened this session): `type Name`+indented fields (NOT `struct` unless brace
   form); NO multi-line list literals (build via push); indent-significant (mind copy/paste indent);
   closures capture BY VALUE (no shared-mutable via capture); dynamic-key dicts must be born in the loop;
   `\r\n` are literal escapes in source; unused `let` is a COMPILE ERROR; `1<<64` is broken; reserved word
   `unsafe`; extern string-RETURN unproven (return int, compare in C).

## Track table

| # | Feature (competitor beat) | Module | Commit | What the test pass must verify | Status |
|---|---|---|---|---|---|
| 0 | Baseline (rapid-dev phase begins) | — | 8a2eee4 | full gate was 621/0 before phase | ✅ gated |
| 1 | RFC 9457 problem+json (beat Spring @ControllerAdvice) | forge.nova | 72c8ff4 | problem(404,"x")→status 404 + Content-Type application/problem+json + body {type,title,status,detail}; problem_full adds instance when non-empty; _problem_title maps common codes | untested (syntax✓) |
| 2 | File/blob storage abstraction (beat Django storages / Spring Resource) | forge_storage.nova (leaf) | 72c8ff4 | storage_local(root); put/get/exists/delete round-trip on local disk; storage_url→/storage/key; _storage_safe_key strips traversal ("../../etc/x"→"etc/x", "a//b"→"a/b", ".."→"") | untested (syntax✓) |
| 3 | Cursor (keyset) pagination (beat OFFSET pagination) | forge.nova | grep:page_build | cursor_encode/decode round-trip (base64url); page_build(limit+1 rows, limit, last_key)→has_more=true+next_cursor+drops sentinel; ≤limit rows→has_more=false, cursor "" | untested (syntax✓) |
