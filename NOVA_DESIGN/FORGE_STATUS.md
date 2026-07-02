# FORGE — Status & Master Design

> **The one source of truth for NOVA's web/services framework.** Supersedes every prior FORGE_STATUS revision (the old "~15% complete, 8 blocking bugs" version was measured against a stale snapshot — most of those "bugs" are fixed and tested today; see *§4 Corrections*).
>
> **Last reconciled against ground truth:** `forge/forge.nova` (3,816 lines) + `forge_db.nova`/`forge_html.nova`/`forge_compress.nova`, the 62 `forge_*_test.nova` regression tests, `nova_runtime.c` (19,757 lines), and the OTP library set (`otp.nova`, `supx.nova`, `actorx.nova`, `pubsubx.nova`, `workerx.nova`, `nurseryx.nova`, `futurex.nova`, `clusterx.nova`, `lockx.nova`).
>
> **Citation discipline:** every `:NNNN` / `~LNNNN` line reference below is tagged either **(verified)** = re-checked against the current source this revision, or **(VERIFY)** = carried from a prior revision and NOT re-confirmed against the current 19,757-line runtime / moved compiler. Treat **(VERIFY)** as "the behavior is real, the exact line may have drifted." A stale line number must never be read as a stale claim — but it must also never be trusted as exact until re-checked. Re-verifying every tag is tracked as a doc-maintenance task (§11 G3).

---

## 0. RECENT PROGRESS — reconciliation 2026-07-01 (read this first; the sections below predate it)

The tables in §2–§6 were last reconciled *before* the 2026-06/07 Forge sprint. The following items they still show as ⬜ / 🟡 / open-bug are **shipped, tested, and committed** since — treat §0 as the override where it conflicts with a later section. (Each is gated `nova_ci`/`_forge_ci` both RC modes.)

**Data layer — the big one the old tables miss entirely:**
- **Universal ORM (`forge_orm`)** — DB-agnostic typed layer proven LIVE on **SQLite + PostgreSQL 16 + MySQL** with the *same* code: typed `orm_all<T>`/`orm_one<T>`, struct CRUD, count/exists/agg, fluent query builder (`.where/.inner_join/.left_join/.order_by/.paginate`), SQL-free repository, relations, schema-from-struct migrations. Advances "Data / ORM 🟡" (§2) and much of §5 **Layer 2** well past the doc.
- **Pure-NOVA PostgreSQL driver (`forge_pg`)** — over TCP+TLS, no libpq: SCRAM-SHA-256, parameterized (injection-safe), TLS verify-full, pool + transactions. Live vs local PG16. (§5 L2 "PostgreSQL driver + pool" was ⬜.)
- **Pure-NOVA MySQL driver (`forge_mysql`)** — raw TCP, no libmysqlclient: handshake + `mysql_native_password` + `caching_sha2` fast-path + COM_QUERY. Live vs MySQL 5.7/8.4.

**Auth (Sprint S4 / Layer 3) — now ~complete:**
- **JWT external interop (B6) → FIXED** (`53f7f84`): signature is now standard base64url(**raw** HMAC-SHA256 bytes) — KAT matches jwt.io / jsonwebtoken / PyJWT. The "Forge-internal hex mac" caveat in §2/§3/§4-B6 is closed.
- **OAuth2 resource-server → SHIPPED**: `mw_oauth2(secret, audience, scope)` bearer validation (RFC 7519 aud/scope). (§2 "OAuth/OIDC ⬜" → 🟡 resource-server.)
- **`mw_auth` pipeline, route `requires(role)`, persisted users, PBKDF2 password hashing** (native `nova_rt_pbkdf2_sha256`, ~30ms) — all shipped (Day-1 auth sweep).
- **Rate limiter, N>1-correct** — `forge_limits` promoted to a shipped **leaf lib** with the single-owner `rate_limiter` **actor** + new `conn_guard` **actor** (accept-storm backpressure primitive, B4). The §3/§4-B8 "single-carrier only" caveat is closed at the primitive level (serve-loop *wiring* = T1.6, next).

**Real-time (Sprint S5 / Layer 5):**
- **Channel join-authorization → SHIPPED** (`ea301b1`): **pre-101** WS handshake authz (`ws_guard` + `ws_default_deny` secure-by-default + `ws_require_bearer`/`ws_require_session`) — an unauthorized client never gets an open socket. Closes the §2 "WS/SSE channel auth ⬜", §5 L5 "Channel join authorization", and §6 "no join-auth" gaps.
- **PubSub + presence + socket assigns** (`pubsub`/`pubsub_sub`/`pub`/`unsub`, `ws_assign`/`ws_get`, `presence`) — shipped (Day-1 real-time sweep).

**Static hardening (Sprint S0 / Layer 1):**
- **Symlink/realpath containment (B7) → FIXED** (`f79e47b`): new runtime `nova_rt_path_within` (POSIX `realpath` / Windows `GetFinalPathNameByHandle`, fail-closed) + `path_within` re-check in the static serve path — a symlink escaping the mount is 404'd (proven live with a junction). The §3/§4-B7 caveat is closed.

**OTP (Sprint S2 / Layer 4):** `one_for_all` + `rest_for_one` strategies + `on_terminate` shipped (`forge_otp`); a GenServer `server(initial_state, handler)` primitive exists (`forge_otp`).

**ALSO already built — verified present 2026-07-01 (the old §3/§4/§5 tables miss these; each has source + a test file, full per-item re-gate is the §11 G3 doc task):**
- **S0/L1 production floor is largely DONE, not open:** read/idle timeout **B1 CLOSED** (`recv_request_bin` enforces a netpoller-parked wall-clock deadline, default 30s, via `_wait_or_timeout` — a slow client is dropped); route-param percent-decode **B2 CLOSED** (`_fr_match` `_pct_decode`s `:param` + `*catch`; `forge_pctdecode_test`); accept-storm cap **B4 CLOSED** (`_conn_sem`/`_acceptor`/`_handle_req_capped` channel-semaphore parks excess accepts — backpressure, not 503-drop; default 10k); explicit **413** (`mw_limit_body` + `_max_body`); graceful drain (listener-close → acceptor exits).
- **Observability (S3/L8) present** (`forge_obs`): Prometheus `/metrics` (`metrics_registry`/`metrics_prometheus`), `/healthz` + `/readyz` (`obs_routes`/`readyz_route`), `log_json`.
- **LiveView (S5/L5) present** (`live_ws`/`live_conn`/`_live_frame_pump`; `forge_live_conn_test`, `forge_live_client_test`) — the S5 crown-jewel substrate is further along than the doc's ⬜.
- **Background jobs (S2/L4)** (`forge_jobs_test`); **lexical-ish transactions** via `with_tx(pool, body_fn)` (`forge_db`) + `pg_with_tx` (`forge_pg`) — the *function* form (the `with tx {}` compiler sugar is the only remainder).
- **Outbound HTTP(S) client (D7r.1) NEW this session** (`forge_http_client`): methods/headers/body, https verify-full, chunked de-framing, loopback GET+POST proven (`forge_http_client_test`). Unlocks the P3 resilience chain.

**UPDATE 2026-07-02 — RAPID-DEV batch shipped (syntax-checked; functional test = the tracked FINAL pass, [FORGE_DEV_TRACK.md](FORGE_DEV_TRACK.md) rows 1–27).** These move from "open" to shipped-at-primitive-level: **P3 resilience** now COMPLETE (`forge_circuit` breaker + `forge_retry` backoff join the shipped bulkhead + ratelimit); **gRPC** (`forge_grpc`: framing + routing + unary dispatch) and **GraphQL** (`forge_graphql`: parser + executor + depth/complexity DoS limits) — the S8 message/execution layers exist (only the HTTP/2 multiplex *transport* wiring remains, gated); **message queues** (`forge_mq` + `forge_outbox`); **auto-admin** (`admin_resource_model` — struct-derived columns + UPDATE); **W3C trace-context propagation**; plus `forge_jsonrpc`, `forge_protobuf`, media-type negotiation, CSV/NDJSON, and supporting libs (cache/discovery/saga/flags/storage/query-DSL). Method: Opus architecture+review, Sonnet leaf impl; each gen3 compile-only checked. Flagged gaps carried to the test pass: `grpc_deframe` bounds check; GraphQL v1 = queries only.

**Still genuinely open (accurate, post-batch):** the `with tx {}` compiler sugar, migrations polish, `nova new` scaffold *wiring* (B9 — templates exist, the CLI route is the gated one-liner); LiveView render-differ completeness + GenServer `on_info`; distributed real-time (cluster pubsub); and the XL **compiler/runtime** frontier that this rapid-dev (syntax-only) mode intentionally DEFERS to a gated pass — interfaces #8 (S6), HTTP/2 ALPN-TLS + multiplex + HPACK Huffman (S7), distribution/`remote_spawn`-prod + mesh (S11), WASM frontend (S13). gRPC/GraphQL/MQ (S8/S10) are no longer wholesale-open (see the 2026-07-02 update above); their remaining piece is the HTTP/2 transport (S7) they ride on.

---

## 1. Vision

**Forge is the framework where one developer, in one language, builds the whole system — REST API, real-time UI, background jobs, microservices, and the cluster they run on — and the framework gets fault tolerance, distribution, and universal communication *for free* because NOVA's runtime is already Erlang-shaped underneath it.**

The thesis in one sentence: **every incumbent's hardest feature is a wrapper around a NOVA primitive that already exists.** Phoenix Channels = `hub()` + `ws_room` (shipped). OTP supervision = `monitor()` + `spawn` + crash isolation (shipped). Celery jobs = green tasks + bounded channels (shipped). gRPC's four call shapes = NOVA channel directionality (the channel runtime is shipped; only HTTP/2 framing is new). Spring's resilience zoo = decorators over a channel (the channel is shipped). Forge's job is **promotion** — turning proven runtime primitives into clean framework APIs — far more than invention.

Four structural advantages no incumbent can copy without changing languages:

1. **One channel type, every transport.** A function call, a WebSocket, a gRPC bidi stream, a Kafka topic, and a remote node link are *all* `Channel<T>`. The transport is inference/config, **never** in the developer's type. Go channels are local-only; Erlang's are mailbox-only; gRPC streams aren't your language's channels. NOVA already ships channels-over-TCP (`remote_*`, commit f095790) — every other transport is a backend behind the same type.
2. **Process isolation IS the serialization boundary — and it is zero-copy when local.** Channel send already deep-copies (ownership transfer); that is *exactly* where you serialize for the wire. But when a channel is **local**, the boundary is a *move*, not a codec — zero serialization cost. The *identical* service call, made over the network, serializes at exactly the same boundary and pays exactly the wire cost. There is no dual API: no "is this a local bean or a Feign client?" decision (Spring's actual pain), no `.proto`-vs-direct-call fork. **The boundary is the codec when remote and free when local — one source, two costs, zero developer choice.**
3. **No function coloring.** A handler is just a function. There is no `async`/`await` infection, no reactive fork (Spring WebFlux), no `database_sync_to_async` (Django Channels). The runtime *parks* a blocked task on the netpoller and resumes it — the developer never colors a function, never picks a reactive variant, never bridges two worlds. This is one of the single biggest beats vs both Spring (sync MVC vs reactive WebFlux are two stacks) and Django (sync ORM in async views needs a thread-pool bridge).
4. **The mesh is a library, not a sidecar.** Sidecars (Envoy/Istio) exist *only* because polyglot fleets can't share a library. A pure-NOVA fleet gets mTLS/retry/tracing/LB in-process, typed, with zero extra network hop. NOVA was built to delete the fragmentation tax that sidecars are a workaround for.

A second-order beat that falls out of advantage #2: **inbound bulkheading is the default, not a library.** Because every connection is a spawned, crash-isolated green task (`serve_safe_req`, *shipped*), one poisoned request cannot take down others *by construction*. Spring needs Resilience4j bulkheads to approximate this; NOVA has it on the server side for free.

### The "one file beats them all" hero

```nova
import forge

struct Todo { id: int, title: string, done: bool }

let db = forge.db("todos.db")
let app = forge.app()

app.get("/todos",        fn(req) -> db.all<Todo>())
app.post("/todos",       fn(req) -> db.insert(req.body_as<Todo>()))
app.get("/todos/:id",    fn(req) -> db.find<Todo>(req.param("id")))
app.delete("/todos/:id", fn(req) -> db.delete<Todo>(req.param("id")))

app.serve(8080)
```

22 lines, zero annotations. No `settings.py`, no `application.yml`, no `urls.py` + `views.py` + `serializers.py` + `admin.py`, no DI container, no ORM session, no migration files to babysit. Structs are the schema; the return value is the JSON; the param is typed.

**NOW-vs-GOAL honesty for the hero:** the keystone the example sits on (struct→JSON via RTTI) is **shipped and tested**. But this example does **not** run today — it needs the *entire* typed-DB ergonomic layer (Layer 2, ~25% done): `db.all<T>`, `db.find<T>`, `db.insert`, `db.delete<T>`, **and** `body_as<T>`. That is the marquee frontier (§5 L2, §10), not a single missing wrapper. The *shipped* equivalent today is the same routes written with explicit `from_json_safe<T>` + `forge_db` pool calls and a `resp_json` return — more verbose, fully working.

---

## 2. Competitor matrix — honest NOW vs GOAL

Legend: ✅ shipped & tested · 🟡 partial / substrate-exists · ⬜ not built · ★ structural beat (NOVA can win, not just tie).

| Capability | Forge **NOW** | Forge **GOAL** | Spring Boot | Django+DRF | Phoenix |
|---|---|---|---|---|---|
| REST routing + typed handlers | ✅ router, `:param`, `*catch`, groups, 404/405 | ✅ + typed param converters, compile-checked route↔handler | ✅ `@GetMapping` | ✅ `urls.py`/DRF | ✅ router DSL |
| JSON in/out (auto, correct) | ✅ struct→JSON via RTTI (2-layer); native-float-field egress sound (19ca6cd) | ★ zero-annotation, no Jackson zoo, no lazy-load traps | 🟡 Jackson (annotation-heavy) | 🟡 serializers | ✅ Jason |
| Validation | ✅ `validate`/`validate_typed`, 422, fail-closed | ★ ONE system for body+query+model; clean default errors | 🟡 ~3 systems of pain | 🟡 Forms ≠ Serializers ≠ model | ✅ changesets |
| Centralized errors | 🟡 `errors_response` | ★ `Result`-typed → RFC 9457 problem+json default | 🟡 `@ControllerAdvice` | 🟡 hand-rolled | 🟡 fallback |
| Data / ORM | 🟡 SQLite pool, params-safe, dict/positional rows | ★ typed `query_as<T>`, query DSL, compile-time N+1 defense, Postgres | ✅ JPA/Hibernate (heaviest pain) | ✅ ORM (the moat) | ✅ Ecto |
| Migrations | ⬜ | 🟡 derive-from-struct + **rename hint** (see §11 F6) | 🟡 Flyway/Liquibase | 🟡 makemigrations hell | 🟡 Ecto migrations |
| Auth (sessions/JWT) | ✅ signed sessions, JWT HS256 (Forge-internal mac), cookies, CSRF | ★ explicit pipeline, no 12-filter "why 403" maze | 🟡 Spring Security (most-cursed) | ✅ contrib.auth | 🟡 add-on |
| OAuth/OIDC | ⬜ | 🟡 resource-server early, full OIDC later | ✅ 3 starters | ⬜ (allauth) | ⬜ |
| Real-time (WS/SSE/PubSub) | ✅ RFC 6455 WS, rooms, hub, SSE, presence (local) | ★ same lang/runtime/deploy; cluster PubSub later; **WS/SSE outbound client** | ⬜ | 🟡 Channels (needs Redis+ASGI) | ✅ Channels |
| WS/SSE channel auth (join authorization) | ⬜ | ★ per-topic `authorize` join hook + socket assigns | ⬜ | 🟡 (manual) | ✅ `Channel.join/3` |
| LiveView-style server UI | ⬜ (every dependency shipped except render-differ + GenServer-`info`) | ★ per-conn process + WS + HTML-as-fn + diff | ⬜ | ⬜ | ✅ LiveView (crown jewel) |
| Background jobs | 🟡 `workerx`, `nurseryx`, `futurex` (local, in-mem) | ★ zero-infra jobs + cron; durable (⟸ DB) → distributed (⟸ L9) | 🟡 `@Async`/`@Scheduled` | 🟡 Celery (broker+worker+beat sprawl) | ✅ Task/Oban |
| Cache (in-proc / distributed) | ⬜ | 🟡 in-proc now via Agent/atomic cell; distributed via hub later | ✅ `@Cacheable` | ✅ cache framework | ✅ `:persistent_term`/Cachex |
| Email / SMTP | ⬜ | 🟡 `send_mail` over outbound client + SMTP codec | ✅ JavaMailSender | ✅ `send_mail` | ✅ Swoosh |
| File / blob storage | ⬜ (uploads parse but persist nowhere) | 🟡 storage abstraction (local→S3/GCS backends) | ✅ `Resource` | ✅ storages | 🟡 (libs) |
| Fault tolerance / OTP | 🟡 crash isolation ✅, 1-for-1 supervise ✅, monitors ✅; **declarative API ⬜** | ★ full supervisor trees, GenServer API, "let it crash" | ⬜ (Resilience4j bolt-on) | ⬜ | ✅ OTP (the moat) |
| gRPC | ⬜ (channel runtime shipped; needs HTTP/2 **+ interfaces #8**) | ★ service-from-types, no `.proto`, streams=channels | 🟡 2 competing starters | ⬜ | 🟡 add-on |
| GraphQL | ⬜ (subscriptions transport shipped) | 🟡 schema-from-types, DataLoader on arena, **depth/complexity limit** | 🟡 add-on | 🟡 graphene | 🟡 Absinthe |
| Messaging (Kafka/NATS/Rabbit) | ⬜ (channels are the substrate) | ★ one publish/consume API + outbox + DLQ | 🟡 Cloud Stream | 🟡 (Celery broker) | 🟡 Broadway |
| Microservice resilience | 🟡 rate-limit (single-carrier) | ★ composable channel decorators (CB/retry/bulkhead) | ✅ Resilience4j | ⬜ | 🟡 manual |
| Distribution / clustering | 🟡 `remote_*` channels p2p ✅; **`remote_spawn` = stub** | 🟡 mesh, global registry, cluster PubSub (LAST) | 🟡 Cloud (Eureka+Config = 3 svcs) | ⬜ | ✅ dist-Erlang |
| Observability | 🟡 `logx`, request-id, access-log | ★ auto OTel propagation + OTLP exporter + sampler + /metrics | ✅ Actuator+Micrometer | 🟡 add-on | ✅ Telemetry |
| Deployment / graceful shutdown | 🟡 SIGINT/SIGTERM + `shutdown_requested()` | 🟡 + drain in-flight, single-binary release | ✅ graceful + jar | 🟡 collectstatic gap | ✅ releases |
| OpenAPI | ✅ v1 sample-based + Swagger UI | ★ true no-drift from typed handlers | 🟡 springdoc (drifts) | 🟡 spectacular | 🟡 add-on |
| Auto-admin from types | ⬜ | ★ register struct → CRUD UI (inline edit, actions, audit) | ⬜ | ✅ admin (the moat) | ⬜ |
| Beginner-friendliness | 🟡 1-file app, no scaffold yet | ★ `forge new` → 1 file, no project/app split | ⬜ (heaviest stack) | 🟡 ~10 files day-one | 🟡 mix gen |
| WASM frontend (same lang) | ⬜ (WASM target is a stub) | ★ full-stack one language | ⬜ | ⬜ | 🟡 (JS) |

**Where Forge already wins:** real-time (no Redis/ASGI fork), and — the four structural levers from §1 — **no function coloring**, **zero-copy-local / wire-cost-remote at the same boundary with one API**, **one channel type across every transport**, and **the mesh-as-library**. The sharpest *unbuilt-but-owned* structural beat: **one `service` block is simultaneously the REST routes, the gRPC service, the OpenAPI spec, and the typed client — from a single source of truth.** Spring/Phoenix cannot do this (separate `.proto`, separate controllers, separate spec annotations). **Where the incumbents still win:** ORM/admin (Django), the resilience+observability batteries (Spring), and battle-tested distribution (Phoenix/BEAM). Those are the roadmap.

---

## 3. ✅ DONE — accurate inventory (every item has a passing `forge_*_test.nova`)

### Server / serve loops
- `serve` / `serve_n` (legacy blocking, deterministic-N) · `serve_arena` / `serve_n_arena` (per-request arena) · `serve_app` / `serve_app_n` (dict router).
- **`serve_req` / `serve_req_n`** — typed, **spawn-per-connection** (green task per conn, keep-alive). *`forge_spawn_test`.*
- **`serve_safe_req` / `serve_safe_req_n`** — spawn-per-conn **+ crash isolation** (monitored sub-process per handler; panic→500, server lives). This is **inbound bulkheading by default** (§1). *`forge_recover_test`.*

### Routing & request/response
- `app()` + `get/post/put/delete/patch`; `:param`, `*catch-all`, `group(prefix)`, `on_not_found`; 404/405 with `Allow`. *`forge_typed_dispatch_test`, `forge_routing_correctness_test`, `forge_routing2_test`, `forge_group_test`.*
- Typed `Request{method,path,raw_path,params,query,headers,body,state,conn,raw_body}` + `build_request`/`mock_request`; case-insensitive `req_header`, `req_query`, `content_type`, `req_form`, `body_json`, `body_form`, `cookie_get`; content negotiation `accepts`/`wants_json`/`wants_html`. *`forge_negotiate_test`.*
- Typed `Response{status,headers,body,halted,cookies}` + `resp_new/text/html/json/bytes/error`, `resp_set_header`, `resp_set_cookie`, `resp_redirect`; `file(path)` content-type-by-ext; single serialization boundary `_finalize2` (framework headers once, HEAD-aware, binary-aware).
- **Return coercion (`_coerce`):** a handler may return a `Response`, `string`, `bytes`, or **any struct/list/dict/scalar → 200 JSON**. *`forge_coerce_test`.*
- Multipart uploads `uploads(req) -> list<Part>` (parses into memory; **no persistence backend yet** — see §5 L6 file/blob storage). *`forge_multipart_test`.*
- **Chunked streaming:** `stream` / `send_chunk` / `send_chunk_bin` (Transfer-Encoding: chunked, RFC 7230). *`forge_chunked_test`.*
- **Testing surface (socketless):** `mock_request` / `dispatch_test` / `status_of` / `body_of`, plus the dispatch families `dispatch_req`/`dispatch_safe`/`dispatch`. *`forge_testsurface_test`.*

### Legacy raw-parser surface (v0.1/v0.2)
- The pre-router raw parser used by the `demo_forge_*` programs: `parse_method`/`parse_path`/`parse_path_clean`/`parse_body`/`query_get`/`header_get`/`recv_request`. Still present and exercised by the demos. **Caveat:** `query_get`/`header_get` carry the `xkey=` false-match bug + case-sensitivity bugs tracked in §4 (B15/B16). Prefer the typed `Request` accessors (`req_query`/`req_header`) for new code.

### ⭐ Struct → JSON keystone — **WORKS** (the old doc's "Bug #1: broken" is FALSE)
A **two-layer dispatch**, not the bare C runtime:
1. **Static-typed call:** codegen (`nova_compiler.nova` ~L7902 **(VERIFY)**) rewrites `json_stringify(structExpr)` into the compiler-derived `<Type>__to_json` (built by `_make_to_json_method` ~L3371 **(VERIFY)**) whenever `ir_expr_struct_type` resolves the type — emits a true `{"field":value,...}` object, recursing into nested structs **and `list<struct>`**.
2. **Through-`any`:** when a struct is erased to `any` (the `forge.json_of(status,value)` / `resp_json` case), codegen (~L7936 **(VERIFY)**) reads the **runtime struct-meta registry** (the RTTI keystone — `field_names`/`field_types`/`field_get` through `any`) and serializes the object.

> **Known recursion limit on the through-`any` path (annotate, don't overclaim):** the *static* path (layer 1) fully recurses through nested `struct`, `list<struct>`, and `dict<string,struct>`. The *through-`any`* path (layer 2) walks the top-level field-meta and re-dispatches per field; **a `Response.body` typed `any` that *contains* a `list<Order>` or `dict<string,Order>` is the common Forge case and must be confirmed to recurse element-by-element, not stringify the inner container opaquely.** Status: top-level field walk verified by `forge_keystone_test`; nested-collection-through-`any` recursion is **(VERIFY)** — if it does not recurse, the fix is to have the per-field re-dispatch detect container element types via the same struct-meta registry. Until re-confirmed, prefer returning a *statically-typed* `list<Order>` (layer 1, fully recursive) over an `any`-erased one.

The bare C `nova_rt_json_stringify` (runtime L1750 **(VERIFY)**) only handles dict/list/string/int/bool — *which is exactly why the dispatch lives in the compiler layer.* `forge_keystone_test` asserts `"id":7`, `"name":"ada"`, `"active":true` all present → **the keystone is real, committed, and tested.** *There is no JSON keystone blocker. Do not re-report it.*

**Float soundness scope (tie to the specific fix, don't say "float-sound" unqualified):** float-through-`any` was a long, CVE-class arc. **Native-float-*field* egress is fixed** (struct/`any`/`val` float fields unbox correctly into JSON/format — commit 19ca6cd; guarded by S1 raw-float-egress oracle 3b0f042 and S2 int/float-mixing canary a20c20a). **Residual:** the dynamic boxed-float-*index* path (an `any`-typed value read through a numeric index, entangled with backlog #9; S2 gated promotion still in progress). For JSON-of-structs (the Forge case) the egress fix is the relevant one and it holds; raw dynamic float-index containers in a response body are the residual to watch.

### Concurrency & crash isolation
- Spawn-per-connection + N concurrent clients + per-task arena (flat per-request memory, `live_delta→0`). *`forge_spawn_test`.*
- Crash isolation: handler panic → 500, server survives, concurrent. *`forge_recover_test`.*

### Real-time
- **WebSocket (RFC 6455, pure NOVA):** `ws`, `ws_room`, `ws_room_ex` (on_join/on_msg/on_leave — a presence primitive), `ws_keepalive`; verbs `ws_emit`/`ws_emit_bin`/`ws_open`/`ws_done`; SHA-1/base64 handshake, frame codec, validation, 16 MB cap, single-writer broadcast, per-message arena. **Note:** there is **no per-topic join-authorization hook yet** — `ws_room` is an open subscribe; per-topic `authorize` gating is a Layer-5 gap (§5 L5, §11 A1). *`forge_ws_*`, `forge_hub_test`, presence test.*
- **SSE** `sse`/`sse_every`/`sse_send`; **chunked** `stream`/`send_chunk`; **Hub** `hub()`/`hub_sub`/`hub_pub`/`hub_unsub`/`hub_count`/`room_say`. *`forge_sse_test`, `forge_chunked_test`.*
- **WS frame codec (public):** `ws_try_decode` / `ws_encode_frame` — result carries `.status`/`.payload`/`.opcode`/`.consumed`; negative-status convention (`-1002` for oversize / fragmented-control / reserved-opcode / RSV1). *`forge_security_fixes_test`.*
- **Local Presence (working today):** `ws_room_ex` on_join/on_msg/on_leave + `hub_count` live in a *serving* room, no deadlock. *`forge_ws_presence_test`, `forge_ws_lifecycle_test`.*
- Static **Range/206** partial content. *`forge_range_test`.*

### Security
- **CSRF** session-bound double-submit, CSPRNG nonce, Origin check, cookie-shadow reject, constant-time. *`forge_csrf_test`* (adversary-reviewed).
- **JWT HS256** `jwt_encode`/`jwt_verify`→Result, strict `alg` allowlist, exp/nbf, constant-time. *`forge_jwt_test`.* **Caveat (B6):** signature is base64url(**HEX** mac) — verifies inside Forge but **not** byte-compatible with external HS256 verifiers (raw-byte variant tracked).
- **Signed stateless sessions** `session_set`/`session_get` (HMAC-SHA256). *`forge_session_test`.* Cookies/flash (POST-redirect-GET). *`forge_cookie_test`, `forge_flash_test`.*
- **Header-injection defense** `_safe_header` strips CR/LF/NUL at serialization; `_cut_at_crlf` on parsed URIs. *`forge_header_security_test`.* **Request smuggling** `_content_length` refuses dup Content-Length / any Transfer-Encoding. *`forge_recv_security_test`.*
- Security headers, CORS, rate-limit, request-id, access-log. *`forge_secheaders_test`, `forge_cors_test`, `forge_ratelimit_test`, `forge_reqid_test`, `forge_accesslog_test`.* CORS exists under both names: `mw_cors` and `mw_cors_origin` (aliases).
- **`mw_require_auth(secret)`** → verifies the bearer/session token and sets `req.state["user"]`. *`forge_jwt_test`.*
- **`forge_limits` DoS-primitive module:** `rate_new`/`rate_allow` (token-bucket refill+burst), `conn_acquire` (conn-guard floors at 0), `limit_body_ok` (size caps). *`forge_limits_lib_test`.* **NOTE: the logic is verified in isolation but NOT yet wired into serve's accept/parse path** — the wiring is a tracked S0 task.
- Bounds: `_max_header`=64 KiB, `_max_body`=8 MiB, `_max_keepalive`=100; `mw_limit_body`.

### Data, projection, docs, static, compression
- **DB pool** (`forge_db`, separate import): `pool_open`/`acquire`/`release`/`query`/`query_dicts`/`insert`/`exec`/`tx`/`close`; all parameterized → injection-safe. Pool semantics today: **SQLite, fixed-size connection set, blocking acquire/release** (no Postgres, no async acquire-park yet — both tracked in §5 L2). *`forge_db_test`.*
- **DB bridge helpers** `row_dict` / `rows_dicts` — map `(cols, rows)` → named dicts (the composition bridge to typed-by-`form_as`). *`_forge_data_test`.*
- **`resp_model`/`resp_model_list`** whitelist projection. *`forge_resp_model_test`, `forge_model_route_test`.* **REAL contract (don't overclaim):** the projection is **FLAT-fields-only**. A *nested* struct field serializes **whole** and will **leak its secret** unless a subset nested model is declared for it. Lists, `bytes`, and computed fields are **out of scope**. The drift guard is a **RUNTIME fail-closed (500)**, not a build-time check (B10).
- **Validation** + `validate_typed` (RTTI walk, fail-closed). *`forge_validate_test`, `forge_validate_typed_test`.*
- **OpenAPI 3.0** `*_doc` + `openapi`/`enable_docs` → `/openapi.json` + Swagger `/docs`. *`forge_openapi_test`.* Caveat: sample type is developer-asserted, not compiler-bound (no-drift = Path-C follow-up).
- **Static** traversal-safe (`_safe_subpath` segment whitelist), text+ETag/304, binary+Range. **Caveat (B7):** textual segment whitelist only — no `realpath`/symlink containment. *`forge_static_test`, `forge_file_test`, `forge_binary_serve_test`.*
- **Compression** (`forge_compress`): `mw_compress` gzip ≥1024 B (pure-NOVA DEFLATE). *`forge_gzip_test`.*
- ETag/conditional/cache/compose/hardening. *`forge_etag_test`, `forge_conditional_test`, `forge_cache_test`, `forge_compose_test`, `forge_hardening_test`, `forge_security_fixes_test`.*

### HTML (`forge_html`)
- `esc`/`raw`, element builders (`div`/`form`/`table`/...), `page(title,head,body)`, scheme-allowlisted `link`; attribute values always escaped, `raw()` the only unescaped path.

**Bottom line:** Phase-0 keystone + Phase-1 typed core + concurrency + crash isolation are **done and tested**, plus a large security/validation/OpenAPI/real-time surface. Forge is *far* past the stale "15%."

---

## 4. 🐛 REAL BUGS / GAPS (only the genuinely-remaining ones)

> The stale doc's Bugs #1–#8 are **already fixed** — do not re-report struct→JSON-array, single-threaded, per-request leak, CRLF injection, `from_json` crash, `json_obj` unescaped, percent-decode-missing (query/form/static). Verified below.

| # | Issue | Severity | Detail |
|---|---|---|---|
| B1 | **No read/idle timeout** on connections | **High** | Only size caps (`_max_header`/`_max_body`). Slowloris is *bounded by size, not wall-clock*. A slow client can hold a connection open indefinitely below the byte cap. Needs a per-connection read deadline in `_serve_conn` (substrate: `select_timeout`, shipped). |
| B2 | **Path `:param` not percent-decoded** | Medium | `_fr_match` does **not** `_pct_decode` route params — though query (`_query_dict`), form (`form_decode`), and static path (`_safe_subpath`) all do. A `:id` containing `%2F`/`%20` arrives raw. Narrow but real correctness gap. |
| B3 | **Per-request memory escape contract** | Medium | `_serve_conn` brackets each request in `arena_enter`/`arena_exit` (flat memory ✅). The **invariant** for any value that *escapes* the request into a long-lived hub/cache: it is **deep-copied to the RC heap at channel send** (`nova_rt_deep_copy` materializes arena strings/boxes; spawn clears `active_arena`) — the exact arena-escape UAF class **closed in commit 0e8cdce**. So escape is *sound*, not hand-waved. **The open part:** long-lived shared state still leans on **atomic cells**, not first-class scope-exit RC (the dual-path long-lived RC half is DEFERRED). Memory growth for genuinely long-lived caches is bounded by that deferral, not by a safety hole. |
| B4 | **No accept backpressure / connection cap** | Medium | Each connection = a green task. Validated at 10k green tasks, but there is **no global connection cap** — an accept storm spawns unboundedly. Needs an accept-side semaphore (a `lockx` channel of N permits). |
| B5 | **`from_json` safe-path routing** | **High** | `from_json_safe<T>` (compiler-generated `<T>__from_json_safe` → Result) is the **safe** path and works. Raw `from_json` is the keystone path. The wrapper `body_as<T>` (Layer 2) **must default to the safe path**; ensure handlers never route untrusted bodies through raw `from_json`. *(The underlying crash is split out as B5a.)* |
| B5a | raw `from_json` on incomplete input | ✅ **VERIFIED-FIXED (2026, do NOT re-report)** | The "SEGFAULT on a missing field" was a STALE finding. `_make_from_dict_method`/`_make_from_json_method` already (a) coerce a non-dict `d` to `{}` up front and (b) default every missing field. **Tested:** a partial body missing the nested-struct, float, and list fields returns a defaulted struct (`name=""`, `score=0.0`), exit 0, **no segfault**. The build-plan's T2.9 is therefore already satisfied. |
| B6 | **JWT external interop** | ✅ **FIXED (`53f7f84`, do NOT re-report)** | Signature is now standard base64url(**raw** HMAC-SHA256 bytes) — KAT byte-matches jwt.io / jsonwebtoken / PyJWT. Achieved diamond-import-safe (forge-native hex-decode of `hmac_sha256` + `ws_b64_bytes`, no `forge_crypto` import). alg pinned pre-crypto, kid rejected, constant-time compare, exp/nbf retained. |
| B7 | **Static symlink containment** | ✅ **FIXED (`f79e47b`, do NOT re-report)** | New runtime `nova_rt_path_within` (POSIX `realpath` / Windows `GetFinalPathNameByHandle`, fail-closed) + `path_within` re-check in the static serve path; a symlink/junction escaping the mount is 404'd (proven live). The over-claim is no longer falsified. |
| B8 | **Rate-limit / SSE-disconnect under N>1 carriers** | Low | Single-carrier-correct today (frameworks run N=1). N>1 needs an owner-actor for the limiter; SSE idle-timeout tracked. |
| B9 | **`nova new` routes to a STUB — Forge templates unreachable** | Low | `nova new` routes to `nova_pkg_new`, a `print("Hello")` **STUB**; the 5 Forge templates in `nova_new.nova` are **UNREACHABLE**, so CLAUDE.md's "download NOVA → build full-stack app" promise can't be met. Fix = one-line route change + lib bundling. |
| B9a | **bundled `$NOVA_HOME/lib` ships ONLY `forge.nova`** | Low | `url_decode`/`hmac_sha256`/`sqlitex`/`forge_db`/`forge_html`/`forge_compress` are **unreachable from a scaffolded app** — gates sessions/data/percent-decode/compression. Fix = bundle the full lib set with the distribution. |
| B10 | **`resp_model` nested-secret leak (flat-only projection)** | Medium | Whitelist projection is FLAT-only; a nested struct field serializes whole and leaks its secret unless a subset nested model is declared. Drift guard is runtime fail-closed (500), not build-time. (See §3 `resp_model` contract.) |
| B11 | **app object `a` shared BY REFERENCE into green tasks** | Medium | N=1 safe, but a handler mutating `a` under `NOVA_CARRIERS>1` is a **data race** — `sched_spawn` does **not** deep-copy `a`. Enforce **immutable-after-setup** for the app object. |
| B12 | **TRACK-A: unannotated cross-module struct-return loses IR type** | Low-Med | An unannotated cross-module call returning a struct doesn't set the `let`'s IR type → `x.field` falls back to the global `ir_fmap` (last-registered wins) → **wrong slot on shared field names**. `ir_fn_returns` is only populated for the main module. |
| B13 | **content-negotiation is POSITION-based** | Low | `accepts`/`wants_*` is position-based, not true q-value parsing. A client's `q=` weights are ignored. |
| B14 | **`count(*)` returns a STRING not int** | Low | `count(*)` comes back as a string from `forge_db`, not an int — caller must coerce. |
| B15 | **legacy `query_get` `xkey=` false-match** | Low | The v0.1/v0.2 raw `query_get`/`header_get` match a key as a substring (`xkey=` matches `key=`) — only the legacy `demo_forge_*` path; typed `req_query`/`req_header` are correct. |
| B16 | **legacy `header_get` case-sensitivity** | Low | Legacy `header_get` is case-sensitive (HTTP headers are case-insensitive); only the legacy raw-parser path. Typed `req_header` is case-insensitive. |
| B9 (install) | **`NOVA_HOME` / install UX** | Low | `import forge` resolves from `$NOVA_HOME/lib/forge.nova`; `_install_forge.ps1` copies `forge/forge.nova`→`lib/`; harness auto-syncs. But a fresh user must know to set `NOVA_HOME` and install — no `forge new` / no packaged distribution yet. |
| — | **`json_obj` escaping** | ✅ FIXED | Now routes through `json_stringify` (proper escaping). Listed only to mark it closed. |

**Verified-fixed (do NOT re-report):** struct→JSON object ✅ · spawn-per-conn ✅ · per-request arena ✅ · `_safe_header` CRLF ✅ · `from_json_safe` ✅ · `json_obj` escaping ✅ · percent-decode in query/form/static ✅ (route-param decode is the residual B2).

---

## 5. ❌ MISSING — ROADMAP (10 layers)

Each layer notes **WHY** it matters and **complexity** (S/M/L/XL). The defining insight is the **Substrate** column: *most OTP/Phoenix/protocol features are cheap because the runtime primitive already exists and is tested.* Every new **ingress** carries a **default safe limit** so the "secure by default" law is verifiable, not asserted (the per-layer security posture is collected in §11 G2).

### Layer 1 — Core HTTP & routing hardening
*WHY:* table stakes; a framework that drops requests or DoS's on a slow client isn't credible.

| Item | Cmplx | Substrate | Notes |
|---|---|---|---|
| Read/idle timeout (Slowloris) | S | `select_timeout` ✅ | Per-connection wall-clock deadline in `_serve_conn`. Closes B1. **Default safe limit: read header within 10s, body within 30s.** |
| Accept-side backpressure cap | S | channel-as-semaphore (`lockx`) ✅ | N-permit channel; closes B4. **Default safe limit: cap = bounded (e.g. 10k); excess accepts park.** |
| Route-param percent-decode | S | `_pct_decode` ✅ | One call in `_fr_match`. Closes B2. |
| Keep-alive idle close | S | shipped | Already `_max_keepalive`=100; add idle close. |
| HTTP/2 stack (h2/HPACK/flow-control) | XL | netpoller ✅; **ALPN over TLS = 🟡** | **Gates gRPC**, upgrades REST. Biggest single infra lift. **Depends on real ALPN-capable TLS** (HTTPS/OpenSSL is 🟡, not ✅ — see §11 C5); h2 cannot ship before TLS+ALPN is solid. |
| Graceful drain (stop-accept + await in-flight) | M | `shutdown_requested()` ✅ | Wire drain into serve loop. |

### Layer 2 — Typed data + ORM (beat Django ORM + admin)
*WHY:* the largest gap vs Spring Data JPA / Django ORM — and Django's ORM+admin is *the* reason orgs pick Django.

| Item | Cmplx | Substrate | Notes |
|---|---|---|---|
| `body_as<T>` / `query_as<T>` wrappers | M | keystone `from_json_safe<T>` ✅ | Needs let-site→callee specialization (Phase 0c). **The marquee ergonomic gap.** Must default to the **safe** Result path (B5). |
| `db.all<T>` / `db.find<T>` / `db.insert<T>` typed rows | M | `forge_db` pool ✅, RTTI ✅ | Map positional/dict rows → struct via field-meta. |
| Connection-pool semantics (async acquire-park, sizing) | M | netpoller ✅, `lockx` ✅ | Today: SQLite, fixed-size, blocking acquire. Make acquire **park** a green task (not block a carrier); size + timeout config. Prereq for Postgres pool below. |
| Composable, type-checked query DSL | L | sqlitex ✅ | **★ Beat Ecto's cryptic macros:** type-check `where(o.total > 100)` against struct fields. |
| **Compile-time N+1 defense** (research item — see §11 F1) | L | whole-program compiler view | **★ Unique-IF-buildable.** Mechanism, not hand-wave: (a) the ORM relation accessor must lower to a *recognizable IR call* (a tagged `relation_load`); (b) loop-nest detection in the IR; (c) escape/alias check that the same parameterized query repeats per iteration → emit a **compile-warning** (not silent rewrite) suggesting a batched/`preload` form. **False-positive story:** if (c) can't prove repetition (dynamic query shape), stay silent — never auto-rewrite query semantics. Status downgraded from "weapon" to **research item** until the IR tagging + loop detection is prototyped. |
| Cache abstraction (in-proc now, distributed later) | M | atomic cell ✅ / `hub()` ✅ | `@Cacheable`-equivalent: keyed memo backed by an Agent (in-proc), promotable to a hub-backed distributed cache (⟸ L9). |
| Migrations (derive-from-struct + **rename hint**) | L | RTTI ✅ | A struct diff **cannot** tell "renamed column" from "drop+add" without intent (this is *why* Django prompts). Mechanism: zero-annotation for add/drop/type-change; **renames require an explicit `@renamed_from("old")` hint** on the field. This is a *bounded, opt-in* annotation only for the genuinely ambiguous case — everything else stays zero-annotation. Without it, a bare rename would **data-loss**; with it, migrations are deterministic and non-interactive. (See §11 F6.) |
| File / blob storage abstraction (local → S3/GCS) | M | bytes ✅, outbound client (L7) | Uploads parse today but persist nowhere. `storage.put/get/url`; local backend first, cloud backends behind the same interface (Django `storages` / Spring `Resource` parity). |
| PostgreSQL driver + pool | L | FFI/`@link` ✅, pool semantics above | SQLite-only today. |
| Lexical `with tx { }` transactions | S | `tx()` ✅ | **★ No proxy/self-invocation trap** (Spring's `@Transactional` footgun). |

### Layer 3 — Auth & security (beat Spring Security)
*WHY:* Spring Security (the 12-filter "why is this 403?" maze) is the most-hated part of Spring — the single biggest beat opportunity.

| Item | Cmplx | Substrate | Notes |
|---|---|---|---|
| One-line `mw_auth` pipeline (explicit, debuggable) | S | middleware ✅, JWT ✅, CSRF ✅ | **★** Middleware chain, not opaque filter chain. |
| Built-in users/groups/permissions model | M | structs + db ✅ | Django-parity; user model *not* a day-one irreversible decision. |
| Password hashing (Argon2/PBKDF2 + upgrade-on-login) | S | crypto (OpenSSL) 🟡 | Tied to core backlog #11. |
| Route-level `requires(role)` | S | middleware ✅ | Declarative, checked explicitly. |
| OAuth2 resource-server (validate) early; full OIDC later | M→L | JWT ✅ | Login-with-Google in a few lines (Django punts to allauth). |
| Rate limit — **local** | S | atomics ✅ | Single-node, owner-actor for limiter state. **NEXT.** |
| Rate limit — **distributed** | M | atomics ✅, `remote_*` 🟡 | Shared-store variant. **Gated on Layer 9.** |

### Layer 4 — OTP / Fault tolerance (the cheap moat)
*WHY:* "let it crash" is **sound by construction** in NOVA — process isolation + deep-copy-on-send + contained panics are all real and tested. The substrate IS Erlang; only the declarative API is missing. **Honest precondition (see §11 F5):** supervised restart only helps if the restarted process can **rebuild its state from outside itself** — DB/Agent/cache. An in-memory-only GenServer loses its data on restart. The OTP story therefore assumes state is **externalized**; this is a stated design rule, not a silent gap.

| Item | Cmplx | Substrate | Notes |
|---|---|---|---|
| `forge.supervisor` + trees (one_for_one/all/rest_for_one/dynamic) + **child specs** (restart: permanent/transient/temporary, shutdown timeout) | M | `monitor` ✅, `spawn` ✅, crash-isolation ✅, `supervise` ✅ | **#1 highest leverage.** Strategies are pure supervisor-task logic over `monitor`. Child specs are required to express "restart only on abnormal exit" (transient) — without them the API is simpler-than-OTP only by being *less capable*. `green_supervisor_test`/`supcrash_test` already restart real panicking children. |
| GenServer / Agent / Task first-class API — **incl. `on_info` and `terminate`** | M | `otp.nova` (gen_start/call/cast) **= primitive ✅, API ⬜** | Promote `actorx`/`otp.nova`; add call/cast/**info**/timeout + terminate. **`on_info` is load-bearing:** without out-of-band message handling a GenServer cannot subscribe to PubSub or receive monitor DOWN signals — which **breaks LiveView and Presence built on top.** `terminate` is the cleanup hook. |
| Registry (local name→handle) + Application root | S | `registry_start` ✅ | Done locally; expose cleanly + lifecycle. |
| Background jobs — **local** (in-mem queue + retries + cron) | M | `workerx` ✅, `nurseryx` ✅, `futurex` ✅, bounded chans ✅ | **★ Beat Celery's broker+worker+beat+flower sprawl** for the 90% single-node case, zero-infra. **NEXT.** |
| Background jobs — **durable** (survive restart) | M | bounded chans ✅, **⟸ `tx()`/DB (L2)** | Durability needs persistent storage — **depends on the DB layer.** SQLite-backed queue for single-node; **DLQ on exhausted retries** (default safe limit). |
| Worker pools / structured concurrency | S | `workerx`/`nurseryx` ✅ | Already shipped libraries; promote to API. |
| Restart-intensity windows + tree shutdown order | M | `monitor`+timer | Sliding-window + ordering is the real work; library-buildable. |
| **Intentionally SKIP:** raw `link`/`trap_exit` | — | — | `monitor` = "link with trap_exit always on." Exposing raw links = a foot-gun for zero gain. *Simpler than Erlang.* |
| **NOT promised:** in-process hot code reload | — | LLVM AOT | Structurally incompatible with native AOT (correct GATE 4/5 tradeoff). Replaced by Layer 9 rolling restart. Honest because state is externalized (precondition above). |

### Layer 5 — Real-time & PubSub
*WHY:* Forge already *wins* here vs Channels (no Redis/ASGI fork). Extend to cluster + the crown jewel.

| Item | Cmplx | Substrate | Notes |
|---|---|---|---|
| Topic `forge.channel`/`broadcast`/`subscribe` (Phoenix-shaped) | S | `hub` ✅, `ws_room` ✅ | Promote existing hub to a clean topic API. |
| **Channel join authorization + socket assigns** | S | `ws_room` ✅ | **★ THE authorization point** (Phoenix `Channel.join/3`). Per-topic `authorize: fn(req, topic) -> Result` gating subscription; per-socket `assigns`. **Without this, PubSub is an open broadcast bus, not Phoenix-competitive.** **Default safe limit: a topic with no `authorize` is reject-by-default for non-public prefixes** (configurable). |
| Presence (local) | S | `ws_room_ex` on_join/on_leave ✅, `hub_count` ✅ | Per-topic Registry-GenServer of `{key→meta}`. **⟸ GenServer `on_info` (L4)** to react to membership events. |
| **LiveView** (per-conn process + WS + HTML-as-fn + render diff) | L | per-conn task ✅, WS ✅, HTML-as-fn ✅, structural `==`/Show ✅, **⟸ GenServer `on_info` (L4)** | **★ Crown jewel.** *Only the render-differ is new* — and NOVA's structural-identity machinery is exactly the right primitive for it. **The per-conn process must receive PubSub broadcasts via `on_info`** to react to server-pushed events — so the GenServer *API* (not just the primitive) is a hard prerequisite. Ships ~10KB JS client (Phoenix does too); WASM frontend later. |
| Cluster PubSub | M | `remote_*` 🟡 | Subscribe each node's hub to peers over `remote_*`. Gated on Layer 9. |
| Cluster Presence (CRDT / OR-Set) | L | `remote_*` 🟡 | CRDT is pure NOVA (data + merge fn — ideal for value semantics). Gated on Layer 9. |

### Layer 6 — Universal communication
*WHY:* "microservices," not just "REST." Exploits the one-channel-many-transports moat.

> **Hard prerequisite for gRPC and `service`/`impl` (load-bearing):** the `service`/`impl` block is essentially the **interface/trait feature** that the core backlog tracks as **#8 (XL), with FATAL holes flagged in the existing trait/dispatch** (silent-0 dispatch, any-bound-skip, hash-collision). **gRPC-from-types CANNOT ship before #8 interfaces is sound.** This is in addition to the HTTP/2 dependency. Both gate Layer 6's gRPC items in §9.

| Item | Cmplx | Substrate | Notes |
|---|---|---|---|
| **gRPC server + client** (service-from-types, 4 call shapes) | XL | channels ✅, `remote_*` ✅; **needs HTTP/2 (L1) AND interfaces #8** | **★ No `.proto`, no `protoc`** — the struct IS the message, channel directionality IS the streaming shape. **Default safe limit: max message size cap (e.g. 4 MiB) + max concurrent streams.** |
| protobuf codec (varint/zigzag/len-delimited from NOVA types) | L | RTTI ✅ | Generated from struct field-meta. **Wire-compat correctness trap (see §11 F2):** protobuf requires **stable field numbers** across schema evolution; deriving them from field *order* breaks the wire on reorder. Mechanism: **explicit field tags** (`@tag(3)`) — declaration order is NOT the wire contract. A migration check fails the build if a tag is reused or a field's tag changes. Without explicit tags the "no `.proto`" claim is unsound for any evolving service. |
| GraphQL (schema-from-types, resolvers, subscriptions, DataLoader) | L | ws/hub ✅ (subs), arena ✅ (DataLoader) | **★ Subscriptions transport already shipped.** **★ DataLoader on the per-request arena = the N+1 batch cache is *automatically freed at request end with zero GC*** — where JS DataLoader leaks if mis-scoped and Absinthe relies on process teardown. **Default safe limit (required for "secure by default"): query depth + complexity limit** (the GraphQL DoS surface; Absinthe has it — we must too). |
| Message-queue consumers (NATS→Kafka→Rabbit) | L | channels ✅ | **★ One `publish`/`consume` API**; ack/retry/DLQ/backpressure = framework concerns. NATS first (closest to channels). **Default safe limit: poison-message → DLQ after N retries; bounded prefetch.** |
| Outbox (atomic DB-write + publish) | M | `tx()` ✅; **relay = supervised job (⟸ L4)**; **⟸ DB (L2)** | **The reliability pattern teams botch most.** Write event in-tx, a **supervised background worker** drains the outbox table and publishes. Depends on both `tx()`/DB (L2) and the jobs subsystem (L4) — the relay *is* a supervised job. |
| WS/SSE **outbound client** | M | netpoller ✅ | Forge ships a WS *server* only. A "universal comms" framework must also **consume** a WebSocket/SSE feed (upstream events, third-party streams). Same `Channel<T>` on the consuming side. |
| REST maturity: cursor pagination `Page<T>`, content-neg table, versioned groups | M | negotiate ✅, groups ✅ | Framework owns cursor encode/sign. |
| True no-drift OpenAPI from typed handlers | M | RTTI ✅, OpenAPI v1 ✅ | **★ Compiler sees the types — spec that *cannot* drift** (beats springdoc/spectacular reflection). |
| RFC 9457 problem+json default | S | `Result` ✅ | `Problem` value + default error→problem mapper. |
| Idempotency keys + If-Match OCC (412) | M | ETag ✅ | `mw_idempotent(store)`; OCC is the HTTP-native lost-update fix. |

### Layer 7 — Microservice resilience patterns
*WHY:* what separates "does HTTP" from "run 200 services." Every one is a decorator on a channel — **one impl, every protocol.**

| Item | Cmplx | Substrate | Notes |
|---|---|---|---|
| Outbound HTTP client + connection pool | M | netpoller ✅ | Forge is server-only today; a universal framework must call out. (Shared substrate with WS/SSE outbound client, L6.) |
| Composable `.timeout/.retry/.circuit_breaker/.bulkhead` | M | channels ✅, supervision ✅ | **★ Wrap a channel, not a transport** → same CB works for HTTP, gRPC, queue-RPC. Bulkhead = process pool per dependency (isolation is native; the *inbound* bulkhead is already the server default, §1). |
| Deadline propagation (ambient context thru spawn/channels) | M | `spawn`/channels ✅ | **The one teams botch most.** Budget set at edge, decremented per hop. |
| Service discovery + client-side LB | L | `remote_*` 🟡, `clusterx` 🟡 | Resolver interface; k8s-DNS + Consul backends. |
| API gateway / BFF toolkit | S | router+mw ✅ | **★ Already most of a gateway**, same model as services behind it (Spring Gateway forces a reactive WebFlux fork). |
| Saga (orchestration first) | L | channels ✅ | No 2PC; local txns + compensations. |

### Layer 8 — Observability
*WHY:* distributed systems are undebuggable without it. Must be **automatic / zero-annotation** or no one instruments.

| Item | Cmplx | Substrate | Notes |
|---|---|---|---|
| OpenTelemetry tracing (auto W3C `traceparent` extract/inject, span/handler) | M | request-id ✅, channels (hop boundary) ✅ | **★ Propagate context *structurally* through channels** where Spring loses it across async/reactive. |
| **OTLP span export + sampling + batching** | M | outbound client (L7) | The egress mechanism behind "auto OTel" — without it the trace propagation has nowhere to go. **OTLP/gRPC + OTLP/HTTP exporter; configurable sampler (head sampling default, tail later); batch span processor.** |
| Prometheus `/metrics` (RED per route + registry) | S | shipped logging | Auto request count/latency-histogram/in-flight gauge. |
| Structured JSON logging + trace_id correlation | S | `logx` ✅, request-id ✅ | **★ JSON-by-default** (beat Spring's historical Logback-XML pain). Bind trace_id into log context. |
| Email / SMTP | S | outbound client (L7) | `send_mail` over the outbound client + SMTP codec. Every canonical web app needs it (Django `send_mail` / Spring `JavaMailSender` / Swoosh). |
| Health: `/healthz` (liveness) + `/readyz` (readiness) | S | `health_route` 🟡 | Distinct semantics; cheap, high credibility. |

### Layer 9 — Distribution & deployment
*WHY:* "run anywhere" + zero-downtime. **Correctly LAST** — single-node excellence first; BEAM took 25 years on distribution.

| Item | Cmplx | Substrate | Notes |
|---|---|---|---|
| Zero-downtime deploy (supervised rolling restart + drain) | M | supervisor 🟡, drain (L1) | **Honest substitute for hot-reload** (impossible under AOT). **State lives in DB/Agent, not code** — this is the L4 externalized-state precondition made concrete: a rolling restart only preserves data because the new process rebuilds from external state. |
| Distributed channels at scale (mesh, membership) | XL | `remote_*` ✅ (p2p) | Everything above the channel (mesh/gossip/global names) is unbuilt. |
| `remote_spawn` production-grade + cluster RPC | L | **`remote_spawn` = stub** 🟡, `call_by_name` ✅ | Mechanism shape is right; **NOT production** — currently returns a local proxy. JSON-able payloads only. |
| Global registry / distributed monitor / failover | XL | local registry ✅ | The largest distributed gap. Because `remote_spawn` returns a local proxy, you **can't supervise a remote process yet**. |
| Single-binary release + config tree | M | `nova_build` LTO ✅ | Tied to core backlog #10 (pkg-mgr). |
| mTLS (client-cert verify, rotation, SNI) | M | HTTPS/OpenSSL 🟡 | Table-stakes for an internal mesh. (Same TLS substrate that gates HTTP/2 ALPN, L1.) |

### Layer 10 — Crown jewels (full-stack, one language)
*WHY:* the "developer never leaves" proof — and the features that make Forge *not* just-another-framework.

| Item | Cmplx | Substrate | Notes |
|---|---|---|---|
| **Auto-admin from types** (register struct → CRUD UI) | XL | RTTI ✅, HTML-as-fn ✅, db 🟡 | **★ Django's biggest moat.** Django admin's *stickiness* is the full set, not just CRUD: list+search+filter+sort, FK→picker, bulk actions, **inline/nested editing** (Django `InlineModelAdmin`), **admin actions registry**, **audit/history log** (`LogEntry`), customizable `list_display`/`readonly`, object-level perms (native via process/capability model). **Committed scope:** CRUD + list/search/filter/sort + FK picker + bulk actions + object-level perms first; **inline editing + audit/history are a fast-follow** (not scope-cut, sequenced) because they are the stickiness layer. |
| **LiveView** (see Layer 5) | L | (deps shipped except render-differ + GenServer-`on_info`) | The interactivity crown. |
| **WASM frontend** (same NOVA, full-stack) | XL | WASM target = **stub** ⬜ | The endgame: backend + frontend + realtime, one language, zero JS framework. Blocked on NOVA's WASM completion. |
| `forge new` scaffold (1 file, no project/app split) | S | — | **★ Attacks Django's first wall** (~10 files day-one). |

---

## 6. The substrate insight (why OTP/Phoenix is cheap)

This is the single most important framing in the document. NOVA's runtime is **structurally Erlang** — a green task owns its values, communicates only by channel (deep-copy on send = ownership transfer), and a panic is contained and surfaced as `exit_reason`. The three safety preconditions for "let it crash" are all enforced *by construction* and *tested*:

1. **No shared mutable state** — channels deep-copy on send (`nova_rt_deep_copy` :2604 **(VERIFY)**); a crashing task can't leave a half-written value visible. *(Exceptions are deliberate: channels + atomic cells are shared by design — that's what makes OTP patterns work.)*
2. **Crash containment** — per-task `fault_buf`/`fault_active`; `nova_panic` longjmps to *this* task's boundary, sets `crashed=1`, notifies monitors, drains the mailbox; carrier survives. *(`crash_isolation_test`, `green_monitor_test`.)*
3. **Supervised restart from clean state** — `monitor` (:7594 **(VERIFY)**) + `exit_reason` (:7650 **(VERIFY)**) + re-`spawn`. **Honest limit:** restart only recovers if state is **externalized** (DB/Agent) — an in-memory-only GenServer loses its data on restart. *(`green_supervisor_test`, `supcrash_test`.)*

| OTP / Phoenix feature | Substrate status | Primitive (verified) |
|---|---|---|
| GenServer / Agent | 🟡 **primitive shipped, API ⬜** | `otp.nova` gen_start/call/cast; `actorx.nova` — first-class `forge.server` call/cast/**info**/timeout/terminate API is **not built** (matches §5 L4) |
| Task / async_stream | ✅ shipped | `spawn`+reply-channel; `pmap`; `futurex.nova` |
| One-for-one supervisor | ✅ shipped | `supx.nova`, `monitor`, crash isolation |
| Supervisor trees + strategies + child specs | 🟡 substrate yes, API no | `monitor` composes → trees compose |
| Monitors (DOWN signal) | ✅ shipped | `monitor(p)` → channel of 0/1; `exit_reason` |
| Links / trap_exit | ⬜ intentionally skip | `monitor` = trapped link; simpler than Erlang |
| Registry (local) | ✅ shipped | `otp.nova` registry-as-GenServer |
| Plug / middleware | ✅ shipped | `use(a, mw)`, `fn(req,next)` |
| Router / Controllers / Contexts | ✅ shipped | `app`/`get`/`post`; contexts = NOVA modules |
| Phoenix Channels (topic WS) | 🟡 shipped local, **no join-auth** | `ws_room`/`hub`/`room_say`; per-topic `authorize` ⬜ (§5 L5) |
| PubSub (local) | ✅ shipped | `hub()` / `pubsubx.nova` |
| Presence (local) | ✅ **local shipped** | `ws_room_ex` on_join/leave + `hub_count` (*`forge_ws_presence_test`*); **cluster/reactive** presence needs GenServer `on_info` |
| LiveView | 🟡 render-differ + GenServer-`on_info` are new | per-conn task + WS + HTML-as-fn + structural `==` |
| Telemetry | 🟡 easy | a `hub()` topic of structured events |
| Changesets | 🟡 most of it | `validate_typed` + `from_json_safe<T>` |
| Bounded mailbox / back-pressure | ✅ shipped | `nova_rt_channel_bounded` (:4382 **(VERIFY)**) |
| select / receive...after | ✅ shipped (**confirm `after 0` non-blocking poll**) | `select_timeout` (:4796 **(VERIFY)**) — the zero-timeout non-blocking poll case must be re-checked, not assumed |
| GenStage demand back-pressure | 🟡 buildable | two channels wired backwards (pure NOVA) |
| Distributed RPC | 🟡 p2p, **`remote_spawn` = stub** | `remote_*` channels + `call_by_name`; `clusterx` |
| Cluster mesh / global / CRDT / failover | ⬜ | the real distributed work, last |
| Preemption (fairness) | 🟡 cooperative by design | yield at recv/send/IO/`reschedule()`; involuntary rejected (GATE 4/5) |
| Per-process memory | ✅ **beats** BEAM **for req/resp** | per-task arena, no GC, `live_delta→0`. **Scope:** the GC-beat is the request/response arena path. **Long-lived shared state still leans on atomic cells** (scope-exit RC deferred, §4 B3) — this is *not* a blanket "beats GC everywhere" claim. |
| Hot code reload | ⬜ keep-no | AOT-incompatible; replaced by rolling restart |

---

## 7. Marquee API sketches

> **NOW-vs-GOAL for this whole section:** these are **intent, not shipped grammar**. The consolidated list of new language/runtime surface they assume — and which layers it gates — is in **§8 (NEW-SYNTAX / NEW-RUNTIME inventory)**. Read that before treating any sketch as buildable. In NOVA strings, `{x}` interpolates — sketches use it deliberately.

**1. Supervisor tree — with child specs (built on `monitor`+`spawn`)** — *NEW: `forge.supervisor`, child-spec options.*
```nova
let sup = forge.supervisor(strategy: one_for_one, max_restarts: 3, in_seconds: 5)
forge.child(sup, "db_pool", fn() -> start_db_pool(), restart: permanent)
forge.child(sup, "import",  fn() -> run_import(),    restart: transient, shutdown_ms: 5000)  // restart only on abnormal exit
forge.child(sup, "metrics", fn() -> start_metrics(), restart: permanent)
forge.start(sup)
// internally: p = spawn(spec.fn); mon = monitor(p);
//   recv(mon) = abnormal exit  ->  one_for_one: respawn this child
//                                  one_for_all: stop+respawn ALL
//                                  rest_for_one: respawn this + all started after
//   restart == transient && exit == normal  ->  do NOT restart
//   restarts-in-window > max  ->  this supervisor panics (escalates to parent)
```

**2. GenServer-equivalent — typed messages (no stringly dispatch), with `on_info`/`terminate`** — *NEW: `forge.server`, type-dispatched handlers.*
> The earlier draft dispatched on string keys (`"add"`/`"clear"`) and returned an ad-hoc `{state, reply}` dict — a typo'd name fails silently (the "silent-0 dispatch" hazard flagged in the core #8 work) and it loses to Elixir's pattern-matched `handle_call`. **Fixed here: messages are typed structs, dispatched by type; the compiler checks the message exists. `reply` is the return value; state mutation is an explicit `set_state`.**
```nova
struct CartState { items: list, total: float }
struct AddItem   { item: Item }     // typed messages — compiler-checked, no string keys
struct Clear     { }
struct CartTick  { }                // out-of-band (timer / PubSub) message

let cart = forge.server(CartState{items: [], total: 0.0})
forge.on_call(cart, AddItem, fn(s, m) -> {                 // dispatched by message TYPE
    set_state(CartState{items: push(s.items, m.item), total: s.total + m.item.price})
    return len(s.items) + 1                                 // the reply value
})
forge.on_cast(cart, Clear, fn(s, _) -> set_state(CartState{items: [], total: 0.0}))
forge.on_info(cart, fn(s, msg) -> handle_pubsub(s, msg))    // out-of-band: monitors / PubSub / timers
forge.on_terminate(cart, fn(s, reason) -> flush_cart(s))   // cleanup on stop/crash
let count = forge.call(cart, AddItem{item: apple})          // sync: per-call reply channel; typo'd type = COMPILE error
forge.cast(cart, Clear{})                                   // async
// sugar:  forge.agent(0)/update/get  ·  forge.async(fn)->await (Result, crash-safe)
```

**3. PubSub broadcast with join authorization (promotes `hub()`+`ws_room`)** — *NEW: `forge.pubsub`/`channel`/`authorize`.*
```nova
let bus = forge.pubsub()
forge.channel(app, "room:*",
  authorize: fn(req, topic) -> if can_join(req.user, topic) then ok() else err(403),  // THE auth point
  on_msg:    fn(sock, topic, msg) -> forge.broadcast(bus, topic, msg))
forge.broadcast(bus, "room:lobby", "{user} joined")
forge.subscribe(bus, "room:lobby", fn(msg) -> handle(msg))   // default: unauthorized topic = reject
```

**4. Presence with socket assigns (local now, CRDT later)** — *NEW: `forge.track`/`presence`/socket `assigns`.*
```nova
forge.channel(app, "room:*",
  authorize: fn(req, topic) -> ok_if_member(req.user, topic),
  on_join:  fn(sock, topic) -> forge.track(presence, topic, sock.assigns.user_id,
                                           {name: sock.assigns.name, at: now()}),
  on_leave: fn(sock, topic) -> forge.untrack(presence, topic, sock.assigns.user_id))
let online = forge.list_presence(presence, "room:lobby")   // [{user_id, meta}, ...]
```

**5. LiveView (per-conn process, render diffs, zero developer JS)** — *NEW: `forge.live`; depends on GenServer `on_info` for server-pushed events.*
```nova
struct Counter { count: int }
forge.live(app, "/counter",
  mount:    fn(req) -> Counter{count: 0},
  on_event: fn(s, ev) -> if ev.name == "inc" then Counter{count: s.count + 1}
                         else if ev.name == "dec" then Counter{count: s.count - 1} else s,
  on_info:  fn(s, msg) -> Counter{count: msg.count},          // server push via PubSub -> re-render
  render:   fn(s) -> html("<div><button phx-click=\"dec\">-</button>"
                        + "<span>{s.count}</span>"               // only THIS dynamic re-sends
                        + "<button phx-click=\"inc\">+</button></div>"))
// first GET -> full HTML; then WS; click -> recv -> on_event -> diff(prev,new) -> send {span:"1"}
```

**6. gRPC service — the types ARE the IDL, channel directionality IS the streaming shape**
> **NEW TOP-LEVEL SYNTAX — requires parser work AND the interfaces feature (#8, XL).** `service`/`impl` blocks and `chan T` return types are essentially the interface/trait feature the core backlog flags as having FATAL holes (silent-0 dispatch, any-bound-skip, hash-collision). **This sketch CANNOT ship before #8 is sound and HTTP/2 (L1) lands.** It is the single largest new-syntax surface in the document.
```nova
struct GetOrder { id: int }
struct Order    { id: int, total: float, status: string }
struct Tick     { symbol: string, price: float }

service Orders {                                  // NEW: requires interfaces #8
    fn get(req: GetOrder) -> Order               // unary        == one-shot reply channel
    fn watch(req: GetOrder) -> chan Order        // server-stream == receive channel  (NEW: `chan T` return)
    fn bulk(items: chan Order) -> Order          // client-stream == send channel
    fn feed(ticks: chan Tick) -> chan Tick       // bidi          == duplex channel pair
}
impl Orders {
    fn get(req: GetOrder) -> Order { return db_find(req.id) }
    fn watch(req: GetOrder) -> chan Order {
        let out = chan()
        spawn { for ev in order_events(req.id) { out.send(ev) } }   // backpressured by the channel
        return out
    }
}
let a = forge.app(); a.mount(Orders); a.serve_grpc(50051)   // OR a.serve(8080) as JSON/REST  -- ONE source, both transports
let orders = Orders.connect("grpc://orders:50051")          // OR "local" OR "tcp://..."
let o = orders.get(GetOrder{id: 42})                        // unary  == a call
for t in orders.watch(GetOrder{id: 42}) { handle(t) }       // stream == iterate a channel
```

**7. Message-queue consumer (reads like an HTTP handler; ack/retry/DLQ = framework)**
> **NEW GRAMMAR to validate:** `.backoff(exp_jitter)` (named backoff strategy) and `fn(msg: OrderPlaced)` typed-consumer dispatch. Marked aspirational until the builder/duration grammar in §8 is real.
```nova
struct OrderPlaced { order_id: int, total: float }
let q = forge.queue("nats://bus:4222")          // swap kafka:// / amqp:// by config only
q.consume("orders.placed", "billing", fn(msg: OrderPlaced) -> Result {
    charge(msg.order_id, msg.total)?            // Err -> auto-retry w/ backoff; exhausted -> DLQ
    return ok()
}).group("billing").retry(5).backoff(exp_jitter).dead_letter("orders.placed.dlq")
```

**8. Outbox publish (atomic DB-write + event)**
> **NEW GRAMMAR:** `with tx = db.begin() { ... }` lexical transaction block. The relay that drains the outbox is a **supervised background job** (L4) — not shown here but load-bearing for "crash before commit -> nothing leaked."
```nova
fn place_order(o: Order) -> Result {
    with tx = db.begin() {
        tx.insert(o)?
        tx.publish("orders.placed", OrderPlaced{order_id: o.id, total: o.total})?  // writes to outbox in-tx
    }   // commit -> supervised relay publishes; crash before commit -> nothing leaked (dual-write solved)
    return ok()
}
```

**9. Circuit-breaker client — composable wrappers, transport-agnostic (wrap a channel)**
> **NEW GRAMMAR to validate (§8):** duration literals `2s`/`30s`/`10s`/`1s`, the named keyword arg `on = transient`, and the named backoff `exp_jitter`. These do **not** appear elsewhere in NOVA's grammar yet — flagged as grammar dependencies, not existing features. The *inbound* bulkhead is already the server default (§1); `.bulkhead` here is the *outbound* per-dependency pool.
```nova
let pay = forge.client("http://payments:8080")
    .timeout(2s).deadline_propagate()
    .retry(3, on = transient).backoff(exp_jitter)
    .circuit_breaker(trip = 5, cooldown = 30s, half_open_probes = 1)
    .bulkhead(max_inflight = 10)
fn checkout(req: Checkout) -> Result {
    let res = pay.post("/charge", Charge{amount: req.amount})?   // Err on open-circuit/exhausted/deadline
    return ok(res)
}
// same wrappers around a gRPC client — one implementation, every protocol:
let inv = Orders.connect("grpc://orders:50051").timeout(1s).circuit_breaker(trip = 5, cooldown = 10s)
```

**10. Distributed handler (one channel, local or across the cluster)**
> **Honest gate:** this depends on Layer 9 (mesh/discovery) **and** `service`/interfaces #8. `remote_spawn` is a stub today, so `cluster.service<Orders>()` resolving a *live remote instance* is GOAL, not NOW.
```nova
let cluster = forge.cluster(discover: "k8s-dns://orders")
let orders = cluster.service<Orders>()          // resolves a live instance; client-side LB
app.get("/order/:id", fn(req) -> orders.get(GetOrder{id: req.param_int("id")}))
// the handler doesn't know or care that `orders` is remote — Channel<T> erases the boundary
// AND: when `orders` resolves LOCAL, this call serializes NOTHING (a move); when remote, the SAME
// boundary pays exactly the wire cost. One source, two costs, zero developer choice. (§1 advantage #2)
```

The through-line in 6–10: **transport never appears in a developer's type.** The moment a handler signature says "gRPC" or "Kafka," the unification is lost. Transport is configuration and inference; that discipline is what keeps Forge simpler-than-Python while spanning the whole communication landscape.

---

## 8. NEW-SYNTAX / NEW-RUNTIME inventory (the honest GOAL surface)

Every API sketch above leans on language/runtime surface that **does not exist yet**. Consolidated here so NOW-vs-GOAL is unmistakable and the dependency edges are explicit. Nothing in §7 ships before its row here is real.

| New surface | Appears in | Status | Gates / depends on |
|---|---|---|---|
| `service` / `impl` blocks (interface/trait) | §7 #6, #10 | ⬜ NEW — **= core backlog #8 (XL), FATAL holes flagged** | gRPC, distributed `service<T>` |
| `chan T` as a function return type | §7 #6 | ⬜ NEW parser work | gRPC streaming shapes |
| Duration literals (`2s`, `30s`, `10s`) | §7 #7, #9 | ⬜ NEW lexer/grammar | resilience client, timeouts |
| Named keyword args (`on = transient`, `restart: transient`) | §7 #1, #9 | 🟡 partial (`name:` args exist in some forms) — **validate** | supervisor specs, retry policy |
| Named strategy idents (`exp_jitter`, `one_for_one`, `permanent`) | §7 #1, #7, #9 | ⬜ NEW — enum-like idents | supervisor, backoff |
| `with tx = db.begin() { }` lexical block | §7 #8 | 🟡 `tx()` exists; **block form is new sugar** | outbox, transactions |
| Call-site type args `<T>` (`db.all<Todo>()`, `body_as<T>`, `service<Orders>`) | hero, §7 #10 | 🟡 `from_json_safe<T>` works; **let-site→callee inference (Phase 0c) needed** | the entire L2 ergonomic layer |

> **Typed-wrapper rewrite boundary (load-bearing).** `query_as<T>` / `db.all<T>` / `body_as<T>` work **only** at a *syntactically-adjacent typed `let`-binding* (the IR-lower assign ladder). A library function that receives rows generically (e.g. `list<list<any>>`) is **OUT OF SCOPE** for the rewrite. This reconciles the adversary's "needs a new compiler subsystem" with the plan's "three additive else-if arms": **the arms cover the typed-`let` form, not arbitrary generic call sites.** The SQLite typed path **today** is **composition-emulated** (`pool_query_dicts` + `form_as`), **NOT** a dedicated compiler rewrite — a dedicated rewrite is the **GOAL**, not the NOW.

| `@tag(n)` field tags (protobuf wire stability) | §11 F2 | ⬜ NEW field annotation (bounded, opt-in) | protobuf codec correctness |
| `@renamed_from("old")` migration hint | §5 L2 | ⬜ NEW field annotation (bounded, opt-in, ambiguous-case-only) | deterministic migrations |

**Rule:** these are the *only* sanctioned new annotations/syntax. `@tag` and `@renamed_from` are deliberately scoped to the two genuinely-ambiguous correctness cases (wire-number stability, rename-vs-drop) — they do **not** reopen the zero-annotation law for ordinary code.

---

## 9. Proposed Forge project structure

Beginner mode is **one file** (the hero). Real apps grow into a flat, explicit, *no-ceremony* layout — no project/app split, no `settings.py` god-module, no `migrations/` per-app graph.

```
myapp/
  app.nova            # entrypoint: forge.app(), routes, serve()  — beginners stop here
  config.nova         # typed config struct (env-overridable); typo'd key = COMPILE error
  contexts/           # domain logic; web layer never touches DB directly (Phoenix "contexts")
    accounts.nova     #   fn create_user(...), fn authenticate(...)
    billing.nova      #   fn charge(...), the OrderPlaced consumer
  models/             # plain typed structs = schema (no null/blank duality, auto to_json/Show)
    user.nova
    order.nova
  routes/             # route modules mounted into app (optional split for large apps)
    api.nova          #   app.group("/v1") ...
    web.nova          #   HTML / LiveView views
  workers/            # supervised GenServers / background jobs / cron / outbox relay
    mailer.nova       #   forge.server(...) under the app's supervision tree
  services/           # gRPC service defs + queue consumers (universal comms)
    orders.nova       #   service Orders { ... }   (requires interfaces #8)
  storage/            # blob/file storage backend config (local/S3/GCS)
  static/             # served correctly in dev AND prod (no collectstatic gap)
  migrations/         # derived-from-struct, deterministic (@renamed_from for renames) — NOT hand-edited graphs
```

Rules: **(1)** the web layer calls `contexts/`, never the DB directly. **(2)** config is one typed struct, env-overridden, schema-checked at compile time — the opposite of Django's stringly-typed `settings.py`. **(3)** every long-lived worker (incl. the outbox relay) hangs off the app's root supervisor (Layer 4), and assumes its state is externalized (L4 precondition). **(4)** a `service` block lives beside its REST routes and is mountable on either transport. Nothing here is required until the app outgrows one file.

---

## 10. Build order / dependency chain

```
DONE ──────────────────────────────────────────────────────────────────────
 Phase 0 keystone (struct→JSON RTTI)                                  ✅
 Phase 1 typed core + router + arena + spawn-per-conn + crash-iso     ✅
 Security / validation / OpenAPI / WS / SSE / hub / DB-pool surface   ✅

NEXT (no new runtime needed) ───────────────────────────────────────────────
 L1 hardening: read-timeout, accept-cap, param-decode, drain         [S/M]
 L2 ergonomics: body_as<T>/query_as<T>/db.all<T>  (let-site spec.)    [M]   <- THE frontier
 L4 OTP promotion: forge.supervisor(+child specs) + GenServer API
    (call/cast/INFO/timeout/terminate) + LOCAL jobs                  [M]   <- cheap moat; on_info gates L5
 L8 observability: /metrics, /healthz, JSON logs + correlation-id     [S]   <- high credibility/effort
 L3 auth: mw_auth pipeline + users/groups/perms + LOCAL rate-limit   [S/M]
 L5 channel join-auth + presence (needs GenServer on_info from L4)    [S]

THEN (new infra) ───────────────────────────────────────────────────────────
 #8 interfaces (service/impl) — core backlog, FATAL holes first      [XL]  <- gates gRPC + distributed service<T>
 L1 HTTP/2 stack (needs TLS+ALPN, which is 🟡)                       [XL]  <- gates gRPC
   └─> L6 gRPC server+client + protobuf codec (@tag wire stability)  [XL]  (⟸ #8 AND HTTP/2)
 L2 Postgres + pool-park + query DSL + migrations(@renamed_from)
    + N+1 detection (research) + cache + file/blob storage           [L]
 L4 durable jobs (⟸ DB)                                              [M]
 L5 LiveView (only the render-differ is new; ⟸ GenServer on_info)    [L]   <- crown jewel
 L6 WS/SSE outbound client                                           [M]
 L7 outbound client + resilience decorators + deadline propagation   [M]
 L6 outbox (⟸ DB tx AND L4 jobs); message queues+DLQ; GraphQL
    (+depth limit); no-drift OpenAPI                                 [L]
 L8 OTel tracing + OTLP exporter/sampler; SMTP/email                 [M]

LAST ───────────────────────────────────────────────────────────────────────
 L3/L4/L5 DISTRIBUTED variants (rate-limit, jobs, PubSub/Presence)   [M/L] <- all gated on L9
 L9 distribution at scale (mesh/global/failover) + rolling deploy    [XL]
 L10 auto-admin from types (+inline/audit fast-follow);
     WASM frontend (blocked on NOVA WASM)                            [XL]
```

**Hard dependencies (explicit edges):**
- gRPC ⟸ **HTTP/2** AND **interfaces #8** (both XL; #8 has FATAL holes to close first).
- HTTP/2 ⟸ **TLS + ALPN** (HTTPS/OpenSSL is 🟡, not ✅).
- LiveView ⟸ **GenServer `on_info`** (server-pushed events) + render-differ; Presence ⟸ GenServer `on_info`.
- Durable jobs ⟸ **DB (`tx`)** (durability needs persistent storage).
- Outbox ⟸ **DB `tx`** AND **L4 jobs** (the relay is a supervised background worker).
- Distributed rate-limit / distributed jobs / cluster PubSub / cluster Presence ⟸ **L9 distribution** (the *local* variants are NEXT; the distributed variants are LAST).
- `body_as`/`query_as`/`db.all<T>` ⟸ **let-site→callee specialization (Phase 0c)**.
- Cluster `service<T>` / production `remote_spawn` ⟸ **L9** (`remote_spawn` is a stub today).
- WASM frontend ⟸ **NOVA WASM target** (currently a stub).

### Completion estimate

Numbers are **feature-count weighted within each layer**; the **overall** figure is a capability-weighted roll-up with the per-layer weights shown so it isn't an unbacked single number.

| Layer | Done (feature-count) | Capability weight | Weighted | Remaining size |
|---|---|---|---|---|
| L1 Core HTTP hardening | 75% (HTTP/2 dominates the rest) | 8% | 6.0% | the 25% = HTTP/2 (XL) |
| L2 Data + ORM | 25% (pool ✅; typed/Postgres/DSL/migrations/cache/storage missing) | 16% | 4.0% | L |
| L3 Auth & security | 55% (JWT/CSRF/sessions ✅; users/OAuth missing) | 8% | 4.4% | M |
| L4 OTP / fault tolerance | 60% (substrate ✅; declarative API missing) | 12% | 7.2% | M — **cheap** |
| L5 Real-time | 70% (WS/SSE/hub ✅; LiveView/join-auth/cluster missing) | 10% | 7.0% | L (LiveView) |
| L6 Universal comms | 15% (OpenAPI v1 ✅; gRPC/GraphQL/MQ/outbox/outbound missing) | 16% | 2.4% | XL |
| L7 Microservice resilience | 10% (rate-limit ✅; client/CB/discovery missing) | 8% | 0.8% | M |
| L8 Observability | 35% (logging/req-id ✅; tracing/metrics/exporter/email missing) | 6% | 2.1% | S/M |
| L9 Distribution & deploy | 20% (`remote_*` p2p ✅; mesh/failover/remote_spawn-prod missing) | 10% | 2.0% | XL |
| L10 Crown jewels | 5% (HTML-as-fn ✅; admin/LiveView/WASM missing) | 6% | 0.3% | XL |

**Overall Forge ≈ 36% complete** (capability-weighted sum above; weights total 100%). The headline "~40%" from prior revisions was *feature-count* weighted and slightly optimistic because the three largest, least-done layers (L2 16%, L6 16%, L9 10%) carry the most weight. **The honest framing:** by *value delivered for a single-node beginner/CRUD app* it is far higher — the typed core, router, security, validation, real-time, and DB pool are all real today; the hero example needs only the L2 ergonomic layer to become literal. The remaining ~64% is front-loaded with cheap, high-leverage promotions (L4 OTP, L8 observability, L5 join-auth) and back-loaded with the genuinely large infra (#8 interfaces → HTTP/2 → gRPC, distribution, admin, WASM).

---

## 11. Cross-cutting posture (security defaults, citations, and the hard-honesty notes)

### Security-default posture per new ingress (the "secure by default" law, made verifiable)
Every new way data enters the system ships with a **default safe limit**, so the claim is checkable rather than asserted:
- **HTTP read/idle:** header within 10s, body within 30s (B1).
- **Accept:** bounded connection cap; excess accepts park, never spawn unboundedly (B4).
- **WS/SSE topics:** join is **authorize-or-reject** for non-public prefixes; no open broadcast bus (§5 L5, A1).
- **GraphQL:** query depth + complexity limit (DoS surface; Absinthe-parity).
- **gRPC:** max message size (e.g. 4 MiB) + max concurrent streams.
- **Message queues:** bounded prefetch + poison-message DLQ after N retries.
- **Static:** segment whitelist today; `realpath`/symlink containment is the open item (B7).

### Hard-honesty notes (the "no hand-waving / NOW-vs-GOAL" items)
- **F1 — Compile-time N+1 is a research item, not a shipped weapon.** It needs tagged `relation_load` IR calls + loop-nest detection + repetition proof, and emits a *warning* (never a silent semantic rewrite). False-positive policy: stay silent when repetition can't be proven. (§5 L2.)
- **F2 — protobuf field numbers must be explicit (`@tag(n)`), not order-derived.** Order-derived numbers break the wire on reorder; explicit tags + a build-time reuse/change check are required for the "no `.proto`" claim to be sound for evolving services. (§5 L6, §8.)
- **F3 — arena escape is sound, with a cited fix.** Any value escaping the request arena into a hub/cache is **deep-copied to the RC heap at channel send** (`nova_rt_deep_copy` materializes arena strings/boxes; spawn clears `active_arena`) — the exact arena-escape UAF class closed in commit **0e8cdce**. The open part is *performance/lifetime* of long-lived shared state (atomic cells, scope-exit RC deferred), not *safety*. (§4 B3.)
- **F4 — the completion number is weighted, and the weights are shown** (§10), relabeled away from an unbacked "~40%."
- **F5 — "let it crash" assumes externalized state.** A supervisor restart only recovers if the restarted process rebuilds state from DB/Agent/cache; an in-memory-only GenServer loses data on restart. Stated as a precondition of the whole OTP story (§5 L4, §6).
- **F6 — migrations disambiguate renames with an explicit hint.** A struct diff cannot tell rename from drop+add without intent; `@renamed_from("old")` is the bounded, opt-in mechanism (everything else stays zero-annotation). Without it a bare rename would data-loss. (§5 L2, §8.)
- **F7 — Benchmark honesty (no premature multi-core claim).** Make **no multi-core throughput claim vs Spring/Go** until the **N>1 carrier races are closed** — specifically the channel lost-wakeup and the netpoller M:N coordination. Single-carrier (N=1) numbers are fair to publish; N>1 throughput is off-limits as a marketing claim until those races are fixed and gated. (Ties to B8, B11.)

### Adoption track (parallel to the technical sprints)
The technical roadmap (§5/§10) is **not** the whole job. A separate **adoption track** runs in parallel and outside the technical sprints: **tutorial, migration guide (from Spring/Django/Phoenix), beginner-grade error messages, and a set of real example apps.** These are sequenced independently of the layer work — a framework that is technically complete but undiscoverable still fails NOVA's "download → build a full-stack app" promise.

### Citation verification note (G3)
Several runtime/compiler line references (`:2604`, `:7594`, `:7650`, `:4382`, `:4796`, `:1750`, `~L7902`, `~L7936`, `~L3371`) are carried from prior revisions and tagged **(VERIFY)** above — they have **not** been re-confirmed against the current `nova_runtime.c` (19,757 lines) or the moved compiler this revision. The *behaviors* are backed by passing tests; the *exact line numbers* may have drifted. Re-checking them is a tracked doc-maintenance task; until done, trust the test name, not the line number.

---

## 12. THE ONE THING NEXT

**Finish Layer 2's stdlib wrappers + run the 22-line hero.** *(The compiler keystone is now SHIPPED — see below.)*

**SHIPPED (the let-site→callee specialization, Phase 0c — was "the only thing standing between the hero and reality"):** the typed-let rewrites for `body_as` (→ `<T>__from_json_safe`, the safe path B5), `query_as` (→ `<T>__from_dict`), `db_find` (→ `<T>__from_dict(`result`)`), and `db_all` (→ generated `<T>__from_dict_list`, a typed loop yielding real `<T>` handles). Commit `47f66da` + the db_all follow-up. All four verified end-to-end, gated (reconverge byte-identical + 585×2). The keystone underneath (struct→JSON RTTI, `from_json_safe<T>`, the DB pool) was already shipped; Phase 0c is now done too.

**REMAINING for the literal hero (stdlib, no new runtime):** `db_insert<T>` (field-meta INSERT, skip the `id` PK → SQLite auto-assigns) + `db_delete<T>` (parameterized + a `db_affected`/`sqlite3_changes` extern); lexical `with tx { }`; async pool-park. Then the hero compiles and runs. (Postgres T2.8 is env-gated.) **NOW-vs-GOAL:** the hero's `req.body_as<Todo>()` *method+`<T>`* syntax is a follow-up (call-site type-args + UFCS); today it's written with typed lets. This is still the front door — finish it, then OTP/observability/HTTP-2 are leverage on top. (Live task ledger: FORGE_BUILD_PLAN.md "Build progress".)
