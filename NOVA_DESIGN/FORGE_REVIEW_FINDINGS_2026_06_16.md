# Forge Competitive + Adversarial Review — 2026-06-16 (workflow w6vnsvm0t, 12 agents)

7 competitor lenses (Spring/Django/Rails/Phoenix/Express/FastAPI/Axum) + 3 adversary passes
reading the real forge.nova / nova_new.nova. Verdict: **the moats are real and ahead of the
field** (one static binary + zero deps, no-GC per-request arena, spawn-per-conn green tasks with
no async coloring, per-request crash isolation, struct-RTTI auto-JSON, typed middleware,
distributed channels). The gaps are REACH, HARDENING, and the INBOUND type story — not the core.

## FIX FIRST — HIGH-severity correctness/security (empirically confirmed; undermine the moats)

1. **CRLF header injection / response splitting** (HIGH, confirmed). redirect() concatenates the
   caller `url` into `Location: <url>\r\n` (no validation); finalize/resp_set_header/_fr_add_header/
   with_cors/mw_cors_origin build `name + ": " + value` with zero CRLF checks; parse_path slices on
   spaces only (CRLF survives into req.path/query); trim() leaves bare LF. `redirect(302,
   "/next\r\nSet-Cookie: pwned=1")` emitted the injected Set-Cookie. FIX: one `_safe_header(name,
   value)` that rejects/strips CR/LF/NUL, funnel finalize()+redirect() through it; truncate the
   request-line URI at first CR/LF in parse_path; drop header lines with bare CR/LF/NUL.
2. **Duplicate reserved headers in finalize()** (HIGH, confirmed). Loops ALL user headers then
   UNCONDITIONALLY appends Content-Length/Connection/Server -> two copies if a handler set them;
   duplicate Content-Length = request-smuggling. Acute once keep-alive sets Connection. FIX: make
   resp.headers the single source of truth (skip reserved names in the loop / write them into the
   dict first -> one emission point).
3. **json_obj() invalid JSON** (HIGH, confirmed). Concatenates `"k":"v"` with NO escaping; a quote/
   backslash/control char breaks it; forces all values to quoted strings. FIX: serialize via the
   runtime json_stringify (the keystone), or delete the dead dict-router string builders so
   resp_json/json_stringify is the ONE serializer.
4. **recv_request Content-Length** (HIGH, confirmed). Case-sensitive `find("Content-Length:")` over
   the WHOLE request; matches `X-Foo-Content-Length:`; lowercase `content-length:` -> cl=0 -> body
   truncated; atoll clamps absurd values; ignores Transfer-Encoding: chunked (smuggling). FIX: parse
   case-insensitively, header-region only, anchored to a line boundary (reuse _headers_dict); reject
   (400) on multiple Content-Length or any Transfer-Encoding; validate numeric within MAX_BODY_BYTES.
5. **No request-size limit / read timeout** (HIGH, DoS). recv_request loops with no cap (O(n^2)
   realloc) then reads to attacker Content-Length; slow client parks a fiber forever; spawn-per-conn
   amplifies. FIX: MAX_HEADER_BYTES (431) + MAX_BODY_BYTES (413) in the recv loop; netpoller read
   deadline -> 408. Defaults on, overridable via typed Config.

## MEDIUM correctness (cheap, real)

- **static() symlink escape** — the "cannot be misconfigured into a CVE" claim is FALSE with a
  symlink inside root (textual whitelist never resolves). FIX: realpath-canonicalise fpath and verify
  it is a prefix of the canonical root; soften the claim until then.
- **:param matches empty segment** — `/users/:id` matches `/users/` binding id="". FIX: require
  len(vp)>0 before binding -> clean 404. Also: static prefix not segment-anchored (`/app` matches
  `/application`); trailing-slash sensitivity; query_get false-negative when an earlier value has `=`.
- **HEAD returns a body** (_try_static serves GET|HEAD with full body) — FIX: blank body for HEAD
  after computing Content-Length. Binary static truncates at NUL (strlen) + single send() no
  partial-write loop — proper fix = a length-delimited bytes Value (also unblocks uploads/PG binary).
- **Percent-decoding absent** in query/form/static-sanitizer — `José`->`Jos%C3%A9`, `%2e%2e%2f` not
  normalised. FIX: bundle url_decode (pure NOVA in urlx) into lib/, wire into form_decode/query_get/
  _query_dict/_safe_subpath (decode FIRST then reject); '+'->space for form bodies, not path.
- **_status_line labels every unmapped status 'OK'** (503->'503 OK', 422->'422 OK'). header_get
  case-sensitive (vs case-insensitive req_header). FIX: add real reasons (303/307/308/409/413/415/
  422/429/502/503), empty fallback reason; make header_get case-insensitive or deprecate.
- **App `a` shared BY REFERENCE into green tasks** (sched_spawn, not deep-copied). Safe at N=1
  (default); under NOVA_CARRIERS>1 a handler mutating `a` is a data race. FIX: document/enforce `a`
  immutable after setup; per-app mutable state via channel/owner process.

## PRIORITIZED NEXT INCREMENTS (after the security fixes)

1. **Wire `nova new <name> [--api|--microservice|--frontend|--fullstack|--lib]` to the Forge
   scaffolder; default=--api (CRITICAL, verified).** Today nova_compiler.nova L18690-18695 routes
   `nova new` to nova_pkg_new() = a `print("Hello")` stub; the 5 Forge templates in nova_new.nova
   are unreachable. CLAUDE.md's defining promise is literally unreachable. Converge ONE nova.toml
   schema; --check exit-code contract (status>=400 -> exit 1); emit .gitignore; add a POST handler
   demoing `let t: Todo = from_json(req.body)`; scaffold a handler test; read $PORT; Dockerfile.
   **Cross-cutting prereq: bundled lib/ has ONLY forge.nova** — url_decode/hmac_sha256/sqlitex are
   pure NOVA but unreachable. Decide what ships in $NOVA_HOME/lib (gates sessions/data/percent-decode).
2. **HTTP/1.1 keep-alive** — per-request-arena loop inside the per-connection green task; stop
   hardcoding `Connection: close`. Pure-NOVA loop on the spawn-per-conn + arena moats. Needs rank-4
   read timeout to avoid pinned fibers.
3. **Cookies + HMAC-signed sessions** as ONE middleware over req.state (all 7 competitors). finalize
   must emit MULTIPLE Set-Cookie lines (headers is one-value-per-name today). Bundle hmac_sha256.
4. **Request hardening** (= fix-first #5; promoted to launch blocker).
5. **Typed request extraction**: forge.body_as<T>/query_as<T> -> Result, Err -> automatic 422 (the
   inbound half of "return your type"). ONE let-site->callee specialization compiler hook ALSO
   unlocks config + DB row mapping. SAFE from_json returning Result<T>. Mass-assignment safety falls
   out free (the input struct IS the whitelist).
6. **Data layer**: query_as<T> over sqlitex + connection-pool channel + tx-rollback-on-panic.
   Prereq: bundle sqlitex; the pool is a long-lived NON-arena owner (atomic-RC half — not free).
7. **Typed config** forge.config<Config>() from env+file, validated at startup (reuses #5 hook).
8. **Graceful shutdown + built-in /health, /ready** via shutdown-channel + inflight-drain.

Full result: tasks/w6vnsvm0t.output.

## AUTONOMOUS FOLLOW-UP FINDING (2026-06-16) — from_json is UNSAFE on incomplete input (HIGH)

A scoping probe (`let x: T = from_json(s)` on missing-field / malformed input) found that from_json
SEGFAULTS (0xC0000005) when the JSON omits a struct field: well-formed `{"id":7,"name":"ada"}`
worked, but `{"id":7}` (missing `name`) crashed the process. The field is left unpopulated ->
accessing it dereferences garbage.

IMPACT (raises rank-5 from ergonomics to SOUNDNESS): the shipped `--api` scaffold's create_todo
does `let t: Todo = from_json(req.body)` and serves via serve_req (NOT crash-isolated), so a client
POSTing incomplete JSON to a scaffolded API SEGFAULTS the server -- a remote DoS in generated code.

This confirms rank-5 ("safe typed extraction") cannot be a Tier-0 forge wrapper -- the crash is in
the from_json builtin itself. Proper fix options (next phase, do carefully -- a C-level soundness
fix, not a hurried patch):
  1. Harden nova_rt_from_json to DEFAULT-FILL missing fields (0 / "" / false) instead of leaving
     them unpopulated -> never produces an unsafe struct (runtime-only, Tier-2: recompile + both-
     mode regression + ASAN, likely no reconverge since the codegen contract is unchanged). This is
     the minimal soundness fix and should come FIRST, independent of the ergonomic body_as<T> work.
  2. A Result-returning safe variant (from_json_safe -> Ok/Err) wired into _coerce as Err->422, so
     a bad body is a clean 422 not a 500/crash (the full rank-5).
  3. Interim mitigation: the scaffold could serve via serve_safe_req so a body crash -> 500 + server
     lives (a scaffold/template change -> reconverge); secondary to fixing the builtin.

Diagnosis depth still owed: confirm whether the crash is in from_json's parse/fill or at the
later field read (decides exactly where the default-fill goes). Probe was deleted (scratch).
