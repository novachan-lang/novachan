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
| 4 | In-proc cache (beat Spring @Cacheable / Django cache) | forge_cache.nova (leaf) | grep:cache_new | cache_new/put/get/delete/clear/stop + cache_get_or; single-owner actor (N>1-safe); [val] present / [] tombstone; get on missing/deleted→err("cache: miss") | untested (syntax✓) |
| 5 | Service discovery + client-side round-robin LB (beat Eureka+Ribbon) | forge_discovery.nova (leaf) | grep:discovery_new | register(svc,ep)/resolve(round-robin advances per-service)/list/stop; unknown service→""; 2 endpoints→idx 0,1,0,... | untested (syntax✓) |
| 6 | Saga orchestration (local txns + compensations; beat 2PC / hand-rolled rollback) | forge_saga.nova (leaf) | grep:saga_run | saga_new/step/run; steps run in order threading ctx; a failing step compensates completed steps in REVERSE; ok(final ctx) on full success, err on failure; fn-values stored in step lists + called | untested (syntax✓) |
| 7 | Message broker + DLQ (beat Kafka/Rabbit/NATS single-node infra) | forge_mq.nova (leaf) | grep:mq_new | mq_new/publish/consume(FIFO head-index)/depth/dead_letter/dlq/stop; publish 2→depth 2; consume→ok(o1) FIFO; drained→err("mq: empty"); dead_letter→dlq list | untested (syntax✓) |
| 8 | BFF/gateway fan-out (http_get_all) | forge_http_client.nova (leaf) | grep:http_get_all | http_get_all([urls]) returns a list of Result<HttpResponse>, one per URL in order (list comprehension); loopback: 2 URLs→2 results | untested (syntax✓) |
| 9 | Deadline/budget propagation (the resilience pattern teams botch) | forge.nova | grep:deadline_in | deadline_in(5000)→abs ms; deadline_remaining decreases, floors at 0 when past; deadline_exceeded flips true past the deadline | untested (syntax✓) |
| 10 | Bulkhead: outbound concurrency cap (beat Resilience4j Bulkhead) | forge_bulkhead.nova (leaf) | grep:bulkhead_new | bulkhead_new(2); try_acquire→1,1 then 0 at cap; release frees one; available count; actor N>1-safe | untested (syntax✓) |
| 11 | Runtime feature flags + A/B variants (beat hard-coded conditionals / LaunchDarkly-simple) | forge_flags.nova (leaf) | grep:flags_new | flag_set/enable/disable/value/on; enable→flag_on true; unset→"" + flag_on false; variant strings via flag_value | untested (syntax✓) |
| 12 | REST status helpers (201 Created+Location / 202 / 204) | forge.nova | grep:resp_created | resp_created(loc,body)→201 + Location header; resp_accepted→202; resp_no_content→204 empty | untested (syntax✓) |
| 13 | Protobuf wire codec (gRPC message substrate; no .proto) | forge_protobuf.nova (leaf) | grep:pb_encode_varint | varint 300→[172,2] + decode; zigzag(-1)→1,(-2)→3, decode(3)→-2; tag(1,0)→8,(2,2)→18; field varint/bytes encoders | untested (syntax✓) |
| 14 | Composable query DSL (HIGH-LEVEL NOVA: comprehensions+join; beat Ecto macros/JPA Criteria) | forge_query.nova (leaf) | grep:q_build | q_qualify("u",[id,name])→[u.id,u.name]; q_eq_conds→[f = ?]; q_where_all AND-joins; q_in(id,3)→id IN (?, ?, ?); q_build assembles SELECT...FROM...WHERE...ORDER BY...LIMIT; params bound (injection-safe) | untested (syntax✓) |
