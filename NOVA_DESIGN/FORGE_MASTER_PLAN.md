# FORGE MASTER PLAN -- Beat Spring Boot, Django, and Every Framework That Exists

**Date:** 2026-06-15 (supersedes the 2026-06-04 draft)
**Status:** CANONICAL. This is the comprehensive, implementable plan for NOVA Forge.
**Strategy:** MOAT-FIRST as the SPINE -- build what Spring/Django structurally cannot,
match every table-stake, make their 100 modules FALL OUT of NOVA's core primitives.
**Author:** Chief Language Architect + Creator

---

## 0. VISION + HEADLINE PITCH

**One paragraph, the entire argument:**

NOVA Forge is the first web framework where one developer writes backend, data layer,
HTML views, middleware, background jobs, real-time PubSub, and (at endgame) a WASM
frontend -- in ONE language that compiles to ONE static binary with ZERO installed
dependencies -- and gets Go-class M:N concurrency (10k concurrent connections, no
`async`/`await`, handlers read as straight-line synchronous code), Erlang-class
per-request crash isolation (a panic returns 500 and the server lives), flat per-request
arena memory (zero GC pauses, deterministic p99 latency), compile-time end-to-end type
safety (a typo in a route, a JSON field, a DB column, or an HTML template is a compile
error, not a 3 AM production crash), and 0.98x-C throughput -- all derived from your
types at compile time with zero annotations, zero reflection, zero startup cost. Spring
Boot needs 1000+ JARs, 5s startup, 300MB RAM, and runtime proxies that silently bypass
`@Transactional` on self-invocation. Django needs Python + pip + gunicorn + Celery +
Redis. Forge needs nothing. Copy the binary. Run it.

### THE FLAGSHIP DEMO

A full-stack Notes application that a Spring team would build across 3 services, 2
languages, and 6 config files. In Forge it is ONE file:

```nova
use forge
use sqlitex

type Note
    id: int
    title: string
    body: string
    created_at: string

fn list_notes(req)
    let notes: list<Note> = forge.query_as(db(), "SELECT * FROM notes ORDER BY id DESC", [])
    forge.json(notes)                           // list<struct> -> JSON array of objects

fn create_note(req)
    let n: Note = forge.body_as(req)            // JSON -> struct, typed by the let
    if len(n.title) == 0
        return forge.bad_request("title required")
    let id = forge.exec(db(), "INSERT INTO notes(title,body,created_at) VALUES(?,?,?)",
                        [n.title, n.body, now_iso()])
    forge.status(forge.json(Note { id: id, title: n.title, body: n.body, created_at: now_iso() }), 201)

fn note_page(req)
    let notes: list<Note> = forge.query_as(db(), "SELECT * FROM notes ORDER BY id DESC", [])
    forge.html(layout("Notes", each(notes, fn(n) el("div",
        el("h3", esc(n.title)) + el("p", esc(n.body))))))

fn main()
    db_exec(db(), "CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMARY KEY, title TEXT, body TEXT, created_at TEXT)")
    let app = forge.app()
    forge.use(app, forge.recover())             // panic -> 500, server lives
    forge.use(app, forge.logger())
    forge.use(app, forge.cors("*"))
    forge.get(app,  "/",           note_page)   // HTML
    forge.get(app,  "/api/notes",  list_notes)  // JSON API
    forge.post(app, "/api/notes",  create_note)
    forge.static(app, "/assets", "public")      // static files
    forge.serve(app, 8080)
```

Backend + DB + HTML views + REST API + crash isolation + CORS + logging + flat memory
-- one language, one file, one binary. The Spring equivalent: Spring Boot + JPA +
Thymeleaf + Jackson + spring-boot-starter-security + Maven BOM + application.yml +
a JVM.

---

## 1. THE MOAT -- Nine Structural Superpowers

Each is an architectural impossibility for the incumbents. Not features to add later
-- properties of the language that competing runtimes cannot retrofit.

### Moat 1: Zero-Dependency Single Static Binary

**Mechanism:** NOVA's Values/Processes/Channels model eliminates the need for separate
ORMs, async runtimes, message brokers, and package managers. Forge compiles backend +
framework + stdlib + static assets + (endgame) WASM frontend into one native executable.

**Win condition:**
- Spring Boot: 1000+ transitive JARs, JVM required, 300MB baseline.
- Django: Python + pip + gunicorn + SQLAlchemy + Celery + Redis.
- Forge: one file, `scp myapp server:`, done. Works on embedded, edge, air-gapped.

**Status:** PROVEN. `gen3_test.exe` is a 923KB self-hosting compiler. Railway deploy
of a NOVA AI service is live.

### Moat 2: Green M:N Concurrency + Straight-Line Handlers + Zero Async Coloring

**Mechanism:** NOVA's scheduler is a netpoller-backed work-stealing pool. A handler
that calls `db.query()` parks the green fiber on I/O, other fibers run, I/O completion
resumes it. The developer writes `let user = db.query(...)` -- no `async`, no `.await`,
no `Mono<T>`, no callback, no function coloring.

**Win condition:**
- Spring WebFlux: every handler returns `Mono<Response>`, coloring infects every fn.
- Node/Express: `async/await` or callbacks everywhere; one CPU-bound handler blocks all.
- Rust/Axum: `async fn` + `.await` + `Send + 'static` + `Pin` puzzles.
- Phoenix: pattern-matched gen_server callbacks, not straight-line.
- Forge: `fn handle(req) -> Response { let user = db.query(...); forge.json(user) }`

**Status:** PROVEN. 10k green tasks, 382ms. `green_scale_test` + `green_netpoll` pass.
`tcp_connect` parks on netpoller (2cbc7da). DNS offload via blocking pool (7260870).

### Moat 3: Flat Per-Request Arena Memory + Zero GC Pauses

**Mechanism:** Every allocation during a request lands in a bump-allocated arena. At
response completion, the entire arena is freed with one `free()`. No per-object RC. No
GC. Cycles die with the arena. p99 latency is bounded by processing + network, never
by garbage collection.

**Win condition:**
- Java/Spring: 200-500MB heap, GC pauses dominate p99 (tens to hundreds of ms).
- Go: GC pauses (reduced but nonzero, and unpredictable under allocation pressure).
- Python/Django: GC + GIL, p99 is unbounded.
- Erlang/Phoenix: per-process generational GC on long-lived connections.
- Forge: one bump-alloc per request, one bulk free. Deterministic p99.

**Status:** PROVEN (b5222b0). `_forge_arena_readiness` shows `live_delta 16359 -> 0`
over 1000 requests including a cycle. Per-task arena via `NovaTaskState`.

**Honest gap:** ~41 string temporaries/request leak at scope-exit (not covered by the
arena -- fresh-per-call locals, not loop reassignment). Mitigated by `max_keepalive_reqs`
cap. Fully resolved when total-RC scope-exit drops land.

### Moat 4: Per-Request Crash Isolation at AOT-Native Speed

**Mechanism:** Each request runs in a NOVA Process (fiber + ownership boundary). A panic
is caught at the process boundary; the request returns 500; the server continues. The
supervisor process detects the crash via `monitor` and can restart worker processes.

**Win condition:**
- Go: `panic` in a goroutine kills the process unless recovery middleware catches it.
- Node/Express: an unhandled promise rejection can kill the event loop.
- Spring: an uncaught exception in a handler can corrupt shared mutable state.
- Erlang/Phoenix: identical model, but BEAM is 2-3x slower than AOT for CPU-bound work.
- Forge: Erlang's fault tolerance at 0.98x C speed.

**Status:** PROVEN. `crash_isolation_test` + `exit_reason_test` + `supervisor_test`
all pass. `recover()` middleware designed (FORGE_DESIGN.md s4.5).

### Moat 5: End-to-End Compile-Time Type Safety

**Mechanism:** The developer defines `type User { id: int; name: string; email: string }`.
The compiler infers and generates: DB schema, JSON serializer/deserializer, HTTP route
response shape, HTML form field names/types, validation rules, OpenAPI spec, and (endgame)
WASM frontend property types. A typo in ANY of these is a compile error.

**Win condition:**
- Spring/Jackson: reflection-based JSON; a deleted column with a remaining Java field
  is a silent mismatch.
- FastAPI/Pydantic: type hints drive validation -- but they are optional, erased, and
  enforced only at runtime via reflection.
- Rails/ActiveRecord: views (ERB) are untyped strings; form field name mismatches are
  discovered when the user submits.
- Forge: one type definition, all derivatives generated and type-checked at compile time.

**Status:** PARTIAL. Auto `__to_json` on structs works. The return-site compiler hook
(bare-struct through `any` boundary) is the keystone prerequisite (Phase 0).

### Moat 6: Compile-Time Dependency Injection

**Mechanism:** `main.nova` registers services, middleware, and handlers via function
calls. The compiler generates the wiring as static function calls -- no reflection, no
classpath scanning, no bean instantiation, no startup cost. A missing dependency is a
compile error.

**Win condition:**
- Spring: 5+ seconds startup for classpath scanning + reflection + proxy generation.
  `NoSuchBeanDefinitionException` is a RUNTIME failure.
- FastAPI: no built-in DI.
- Forge: startup < 5ms. Missing wiring = compile error.

**Status:** Partially inherent (NOVA's compile model). Needs the typed App struct +
handler registration to make it ergonomic. Phase 1 deliverable.

### Moat 7: Auto-Derived Validation + OpenAPI + Client SDKs from Types

**Mechanism:** The compiler reads route signatures and type definitions, generates
OpenAPI 3.x spec at compile time (zero runtime cost), emits validation functions inlined
into the request path, and can generate typed TypeScript client stubs.

**Win condition:**
- FastAPI: OpenAPI generated at runtime via reflection; must restart to see changes.
- Spring: requires `springdoc-openapi` + annotations + runtime scanning.
- Forge: change a type, recompile, the binary contains the updated spec. Zero drift.

**Status:** NOT STARTED. Blocked on the struct-reflection keystone (Phase 0). Phase 3.

### Moat 8: Distribution in the Core

**Mechanism:** NOVA's channels work locally (zero-copy pointer move) and distributed
(serialization generated from types). `send(user, message)` on a local channel is a
move; on a distributed channel it serializes, ships over the network, and deserializes.
The developer writes it once. `remote_connect`/`remote_listen`/`remote_send`/`remote_recv`
are shipped (f095790).

**Win condition:**
- Spring Cloud: requires stubs, config server, Eureka, separate release train.
- Erlang: requires `net_kernel` setup and node names.
- Forge: place a spawned process on a remote node, the code is unchanged.

**Status:** SHIPPED (remote_* primitives). Point-to-point TCP + length-prefixed JSON,
green-aware/netpoller-parking. `remote_spawn` still a stub.

### Moat 9: Whole-Program Optimization

**Mechanism:** Forge code, app code, stdlib, and runtime compile as ONE LLVM IR module.
The compiler inlines across framework/app boundaries, eliminates dead middleware,
specializes generic handlers, and proves no-alias for aggressive `noalias`/`nonnull`.

**Win condition:** Spring/Django/Rails compile framework and app separately. Express
interprets both. Even Rust/Actix respects crate boundaries. NOVA treats the whole
program as one compilation unit -- 30-50% real-world throughput advantage.

**Status:** INHERENT (NOVA's compilation model). S1 type-driven specialization done
(b36ae32) -- unannotated struct params emit native `fmul`/`fadd`.

---

## 2. COMPLETE CAPABILITY MAP

Every area a production platform needs, what the incumbents do, and how Forge does it.
For each: MATCH (parity), BEAT (structurally better), or BUILD (must construct).

---

### 2.1 HTTP Core + Server

| Feature | Spring/Django/Rails | Forge |
|---|---|---|
| HTTP/1.1 keep-alive | All have it | MATCH. `recv_request` + keep-alive loop (capped) |
| Chunked transfer-encoding | All have it | BUILD. Parse `Transfer-Encoding: chunked` in `recv_request` |
| HTTP/2 multiplexing + HPACK | Tomcat/Netty/Gunicorn | BUILD (Phase 5). Multiplexed streams over single TCP conn |
| HTTP/3 QUIC | Caddy, ASP.NET | BUILD (Phase 7+). QUIC over UDP, 0-RTT resumption |
| TLS termination | All (runtime-configured) | MATCH. OpenSSL client + Linux server shipped. Windows Schannel server TODO |
| WebSocket RFC 6455 | All (libraries) | MATCH. `ws_upgrade` + channel-pair, proven |
| SSE (Server-Sent Events) | Spring WebFlux `SseEmitter` | BUILD (Phase 4). Streaming response on a green fiber |
| Request parsing (headers/body/multipart) | All (mature) | PARTIAL. Headers + body done. Multipart BUILD (Phase 1) |
| Response compression (gzip/brotli/zstd) | All via middleware | BUILD (Phase 2). gzip primitives exist; brotli/zstd via FFI |
| Graceful shutdown | All (signal handlers) | BUILD (Phase 2). Inflight counter + `tcp_close(listener)` |
| Backpressure / max connections | Tomcat thread pool, Go `MaxConns` | BUILD (Phase 2). Semaphore channel limiting green-task count |
| Slowloris defense | Timeout configs | MATCH. `_recv_request_timeout` designed (FORGE_DESIGN s4.5) |

**Forge verdict:** MATCH on HTTP/1.1 at launch. HTTP/2 is Phase 5. HTTP/3 is endgame.
The spawn-per-connection green model is a structural win over thread-per-request and
single-event-loop models.

---

### 2.2 Routing

| Feature | Best incumbent | Forge |
|---|---|---|
| Path params (`/users/:id`) | All | MATCH. `_fr_match` works today |
| Wildcards (`/files/*path`) | chi, gorilla, Phoenix | BUILD (Phase 1). `*name` catch-all in `_match_pattern` |
| Method matching (GET/POST/...) | All | MATCH. Shipped |
| Route groups with shared middleware | Express `Router`, Rails `scope` | BUILD (Phase 1). `forge.group(app, "/api/v1")` |
| Named routes + reverse URL generation | Rails `_path` helpers, Phoenix `Routes` | BUILD (Phase 3). `url_for("user", id: 5)` compile-checked |
| 405 Method Not Allowed + Allow header | All (correct) | BUILD (Phase 1). Second-pass scan on miss |
| Content negotiation routing | Spring `produces`/`consumes` | BUILD (Phase 3). Accept-header dispatch |
| Compiled trie / radix tree | chi, httprouter (Go) | BUILD (Phase 3). O(path-length) compile-time trie |

**Forge verdict:** The current `_fr_match` is an O(routes) linear scan. Functional for
< 100 routes. The compile-time trie (Phase 3) is the endgame -- O(path-length), zero
runtime route table lookup. Named routes with compile-checked reverse is a WIN over Rails
(runtime `NoMethodError` on bad route name).

---

### 2.3 Middleware / Request Pipeline

| Feature | Best incumbent | Forge |
|---|---|---|
| Composable ordered chain | Express `app.use`, Django middleware | MATCH. `forge.use` + outside-in fold shipped |
| Before/after hooks | ASP.NET pipeline | MATCH. Middleware wraps `next(req)` -> modify response |
| Error-handling middleware | Express error mw, Django `process_exception` | BUILD (Phase 1). `forge.recover()` via spawn+monitor |
| CORS middleware | All | MATCH. `mw_cors` shipped |
| CSRF protection | Django (on by default), Spring Security | BUILD (Phase 3). Double-submit token, constant-time verify |
| Rate limiting | Spring Cloud Gateway, express-rate-limit | BUILD (Phase 2). Owner-actor over a channel (lock-free) |
| Request ID injection | Most | BUILD (Phase 2). UUID per request threaded via `req.state` |
| Security headers (HSTS/CSP/X-Frame) | Helmet (Express), Django SecurityMiddleware | BUILD (Phase 2). Default-on, configurable |
| Body size limiting | All | BUILD (Phase 1). `forge.limit_body(maxBytes)` |
| Logging middleware | All | MATCH. `mw_logger` shipped |
| Compression middleware | All | BUILD (Phase 2). gzip response bodies |

**Forge structural WIN:** Middleware composes as NOVA functions. The compiler can inline
the entire chain into one function body -- zero per-middleware closure allocation. Express
pays a `next()` closure per middleware per request.

---

### 2.4 Data Layer / ORM / Migrations / Transactions

This is where frameworks win or lose. The biggest single subsystem.

| Feature | Best incumbent | Forge |
|---|---|---|
| SQLite driver | All (via drivers) | MATCH. `sqlitex` via FFI, injection-safe bound params, proven |
| Postgres driver | pg (Node), psycopg (Python), JDBC | BUILD (Phase 4). Native Postgres wire protocol via FFI |
| MySQL driver | mysql2 (Node), mysqlclient (Python) | BUILD (Phase 5+). Native wire protocol via FFI |
| Connection pooling | HikariCP (Spring), SQLAlchemy pool | BUILD (Phase 2). Channel of connections (backpressure free) |
| Type-safe row->struct mapping | Spring Data JPA, Ecto, sqlx | BEAT. `query_as<T>` maps by column order = field order, typed by the `let` site. Zero reflection, zero annotation |
| Query builder (LINQ/Ecto-class) | Ecto, Eloquent, LINQ | BUILD (Phase 4). Composable query structs, compile-time checked |
| ORM: models/relations/eager loading | Django ORM, ActiveRecord, JPA | BUILD (Phase 4). Typed relations (1:1, 1:N, N:N), eager by default (no lazy-loading proxy footgun) |
| N+1 query detection at compile time | None (all detect at runtime) | BUILD (Phase 5). World-first: compiler traces query patterns and rejects N+1 |
| Migrations (versioned, reversible) | Rails, EF Core, Ecto, Flyway | BUILD (Phase 4). Model-diff generates up/down NOVA functions |
| Auto-generate migrations from model diffs | EF Core, Alembic | BUILD (Phase 4). Compiler diffs struct definitions between versions |
| Transactions (nested, savepoints) | All | BUILD (Phase 2). `forge.tx(db, fn(tx) { ... })` -- commit on ok, rollback on err |
| Compile-time SQL validation | sqlx (Rust, requires live DB) | BUILD (Phase 5). Compiler connects to schema at build time, verifies columns/types |
| Raw SQL escape hatch (parameterized) | All | MATCH. `db_query(db, sql, params)` always binds. Shipped |
| Prepared statement caching | All | BUILD (Phase 3). Per-connection LRU of prepared stmts |
| Read replicas / sharding hooks | Spring, Django | BUILD (Phase 6+). Routing fn selects pool by query type |

**Forge structural BEAT on data:**
1. `query_as<User>` is typed by the `let` site -- zero `@Entity`, zero `@Column`,
   zero Serde `#[derive]`, zero Pydantic class. The compiler generates the row->struct
   mapping. This is simpler than Django ORM.
2. Connection pool IS a channel -- backpressure, supervision, auto-reconnect come free
   from the process model. No HikariCP configuration matrix.
3. N+1 detection at compile time is a world-first (Phase 5 endgame).
4. No lazy-loading proxies -- no `LazyInitializationException`, no Hibernate session
   leaks, no dirty-checking surprises.

**Forge honest LOSE:** Ecosystem breadth. Spring Data supports 15+ databases. Forge
starts with SQLite + Postgres. MySQL and NoSQL are Phase 5+.

---

### 2.5 Serialization + API Generation

| Feature | Best incumbent | Forge |
|---|---|---|
| JSON serialization (struct -> JSON) | Jackson (Spring), json (Python) | BEAT. Auto `__to_json` from struct definition, zero annotations. (Keystone hook required for bare-struct return) |
| JSON deserialization (JSON -> struct) | Jackson, Pydantic, Serde | BEAT. `body_as<T>` typed by the `let` site. (from_json_safe -> Result<T> BUILD Phase 1) |
| Content negotiation (JSON/XML/MsgPack) | Spring `produces`/`consumes` | BUILD (Phase 4). Accept-header dispatch + pluggable codecs |
| OpenAPI 3.x auto-generation | FastAPI (runtime), springdoc | BEAT (Phase 3). Generated at COMPILE TIME from inferred route signatures. Cannot drift. Zero runtime cost |
| GraphQL endpoint generation | graphql-java, Strawberry (Python) | BUILD (Phase 6). Type-derived schema |
| gRPC services | grpc-java, grpcio | BUILD (Phase 6). Code-gen from `.proto` or type-derived |
| TypeScript client SDK generation | openapi-generator (post-hoc) | BEAT (Phase 3). Emitted alongside OpenAPI from the same types. Compile-checked against backend |
| API versioning | URL prefix, header-based | BUILD (Phase 3). `forge.group(app, "/api/v2")` |

**Forge structural BEAT:** FastAPI's killer feature (type-driven OpenAPI) is runtime
reflection. Forge generates the same spec at compile time. The spec, the validator, the
TS client, and the WASM frontend types are all ONE source of truth -- compiler-verified.

---

### 2.6 Validation

| Feature | Best incumbent | Forge |
|---|---|---|
| Type-driven input validation | Pydantic (FastAPI), Bean Validation (Spring) | BEAT. Constraints on types generate validators at compile time. Zero reflection. Invalid requests rejected with precise field-level errors before handler code runs |
| Composable validators | Pydantic validators, custom ConstraintValidator | BUILD (Phase 3). `forge.validate(T, rules)` -- composable fns |
| Form validation + error display | Django forms, Laravel Form Requests | BUILD (Phase 4). Form fields derived from types, validation errors mapped to fields |
| Cross-field validation | Pydantic `model_validator`, Spring groups | BUILD (Phase 3). Custom validation fns on the struct |
| Nested/deep validation | Pydantic (recursive) | BUILD (Phase 3). Compiler walks nested type structure |

**Forge structural BEAT:** Pydantic validation runs per-request via runtime reflection
(v2 rewrote the core in Rust to survive the perf cost). Forge generates validators as
inlined native code at compile time. Zero per-request overhead. A constraint violation
is a precise error with field path -- no `ValidationError` stack trace to parse.

---

### 2.7 Authentication + Authorization

| Feature | Best incumbent | Forge |
|---|---|---|
| Session management (cookie-based) | Django sessions, Spring Session | BUILD (Phase 3). HMAC-signed cookie (HttpOnly + SameSite=Lax default), constant-time verify. Server-side variant via SQLite |
| JWT (sign/verify/refresh) | Spring Security oauth2-resource-server | BUILD (Phase 3). `hmac_sha256` exists; JWT encode/decode + exp/iss claims |
| OAuth2 / OIDC (social login) | Spring Security oauth2-client, Passport | BUILD (Phase 4). Authorization-code flow, token exchange, PKCE |
| Password hashing (Argon2id) | Spring's DelegatingPasswordEncoder | BUILD (Phase 3). Argon2id via FFI (constant-time, auto-tuned params). SHA-256/HMAC exist |
| API key authentication | Various | BUILD (Phase 3). Header/query extraction + constant-time compare |
| RBAC / permissions / policy engine | Spring `@PreAuthorize`, Django permissions | BEAT (Phase 4). Policies are compiled NOVA functions, type-checked against the user model. Not SpEL strings evaluated at runtime |
| CSRF protection | Django (on by default), Spring | BUILD (Phase 3). Double-submit token, constant-time verify, default-on |
| MFA/2FA hooks | Various | BUILD (Phase 5). TOTP (RFC 6238) via HMAC-SHA1 |

**Forge structural BEAT on auth:**
- Spring's `@PreAuthorize("hasRole('ADMIN') and #id == authentication.principal.id")`
  is a SpEL string evaluated at runtime -- typos are runtime errors, self-invocation
  bypasses it (the proxy footgun). Forge's policy is a compiled function:
  `fn can_edit(user, post) -> bool { user.id == post.author_id or user.role == "admin" }`
  -- type-checked, no proxy, no footgun.
- Capability-based access via channel handles: a process literally cannot touch a
  resource it was not granted.

---

### 2.8 Observability

| Feature | Best incumbent | Forge |
|---|---|---|
| Structured logging | Spring/Logback, Python logging | MATCH. `print` + structured format. BUILD structured log sinks (Phase 3) |
| Prometheus metrics | Spring Actuator + Micrometer | BUILD (Phase 3). Counter/gauge/histogram/timer; `/metrics` endpoint |
| Distributed tracing (OpenTelemetry) | Spring Micrometer Tracing, Jaeger | BEAT (Phase 4). Tracing follows the CHANNEL GRAPH automatically -- all communication is channels, so request traces span processes/machines with zero manual span instrumentation |
| Health/readiness checks | Spring Actuator `/health` | BUILD (Phase 2). `/health` endpoint with composite indicators (DB, disk, custom) |
| Runtime log-level change | Spring Actuator `/loggers` | BUILD (Phase 4). Channel-based config reload |
| Error tracking / Sentry integration | All (via libraries) | BUILD (Phase 4). Panic + exit_reason -> structured error reports |
| Request profiling | Various | PARTIAL. Flamegraph + LCOV exist. BUILD per-request timing (Phase 2) |

**Forge structural BEAT:** Tracing follows the channel graph. Because ALL communication
in NOVA is channels, a distributed trace is the process/channel topology. No manual
`@WithSpan` annotations. No `TracerProvider` configuration. The process tree IS the trace.

---

### 2.9 Caching

| Feature | Best incumbent | Forge |
|---|---|---|
| In-memory cache (LRU) | Caffeine (Spring), ristretto (Go) | MATCH. `LRU` exists in stdlib, sub-microsecond (process-local, no Redis round-trip) |
| Distributed cache (Redis) | Spring Cache + Redis, Django cache | BUILD (Phase 5). Cache is a Mesh process; no external Redis for moderate scale |
| HTTP caching (ETag/Cache-Control) | Spring, Django middleware | BUILD (Phase 3). Auto-generated ETag from response body hash |
| Fragment caching (template partials) | Rails, Django | BUILD (Phase 5). Cache rendered HTML fragments by key |
| Declarative `@Cacheable` equivalent | Spring | BEAT (Phase 4). Compile-time-checked cache annotations -- no proxy self-invocation footgun |

---

### 2.10 Background Jobs + Scheduling

| Feature | Best incumbent | Forge |
|---|---|---|
| Job queues with priorities | Sidekiq (Rails), Celery (Django) | BEAT. A job is a spawned Process. The queue is a channel. No external Redis/RabbitMQ broker. No separate deployment |
| Scheduled / cron tasks | Spring `@Scheduled`, Celery Beat | BUILD (Phase 3). `forge.schedule("0 * * * *", fn() { ... })` -- cron syntax, supervised |
| Retries with exponential backoff | Sidekiq, Spring Retry | BUILD (Phase 3). Supervisor restart policy with backoff |
| Dead-letter queue | RabbitMQ DLX, Kafka DLT | BUILD (Phase 4). Failed-N-times channel |
| Distributed workers | Celery multi-worker, Sidekiq Enterprise | BEAT (Phase 6). Workers span machines via NOVA's distributed channels. Same binary, same code |
| Job dashboard (Horizon-style) | Laravel Horizon, Sidekiq Web | BUILD (Phase 5). Built-in ops UI showing throughput, retries, failures |

**Forge structural BEAT:** Django needs Celery + Redis + a separate worker deployment.
Rails needs Sidekiq + Redis. Forge: `spawn fn() { process_email(user) }` -- in the same
binary, supervised, retried by the supervisor. The thing they need 3 systems for, Forge
does with one word.

---

### 2.11 Real-Time (WebSocket / PubSub / Presence)

| Feature | Best incumbent | Forge |
|---|---|---|
| WebSocket connections | Phoenix Channels, Socket.IO, SignalR | MATCH. WebSocket IS a channel pair in NOVA |
| PubSub (topic broadcast) | Phoenix PubSub (cluster-wide), Redis PubSub | BEAT. Fan-out channel. No external Redis needed for single-node; cluster PubSub via distributed channels |
| Presence (who's online, CRDT) | Phoenix Presence | BUILD (Phase 5). Supervised process holding state, CRDT-merged across nodes |
| Broadcasting to groups | ActionCable, SignalR groups | BUILD (Phase 3). Channel groups: subscribe/unsubscribe/broadcast |
| SSE (Server-Sent Events) | Spring WebFlux, Express | BUILD (Phase 2). Streaming response on a green fiber |

**Forge structural BEAT:** Real-time is not a library -- it is the language. A WebSocket
is a channel pair. PubSub is a fan-out channel. Presence is a supervised process holding
state. Phoenix had to BUILD all this on top of Erlang; in NOVA it is the native primitive,
at native speed (not BEAM CPU-bound).

---

### 2.12 Templating + Views + Frontend

| Feature | Best incumbent | Forge |
|---|---|---|
| Server-side HTML rendering | Thymeleaf, Django templates, ERB, EEx | BEAT. HTML is NOVA functions -- `el("div", esc(user.name))`. A typo in `user.nane` is a COMPILE error, not a blank in output. No template language = no second language |
| Escape-by-default (XSS prevention) | Django autoescape, Rails `html_safe` | MATCH. `esc_text` for element content, `esc_attr` for attributes. Opt-out is explicit `{{{raw}}}` |
| Component-based rendering | React, Vue, Blazor | BUILD (Phase 5). NOVA functions compose as components |
| WASM frontend (same language) | Blazor (C#) | BEAT (Phase 7). NOVA->WASM, <30KB bundles (Blazor ships multi-MB .NET runtime). Same types both sides |
| LiveView-style server-driven UI | Phoenix LiveView | BUILD (Phase 7). Per-user Process holding state, compiler static/dynamic split, native speed |
| SSR + hydration | Next.js, Nuxt, Blazor | BUILD (Phase 7). Render on server, hydrate on WASM client |
| Static asset pipeline (fingerprint/minify) | Webpack, Vite, Sprockets | BUILD (Phase 4). Embed assets in binary with content-hash filenames |
| HTMX-style partial updates | HTMX, Turbo/Hotwire | BUILD (Phase 4). Partial HTML responses, swap targets |

**Forge structural BEAT on views:** HTML is a NOVA function. Loops are `each`. Conditions
are `if`. Partials are functions. Inheritance is composition. A field access `user.name`
is a REAL field access -- a typo is a compile error. No Jinja, no EJS, no ERB. No second
language.

---

### 2.13 Configuration + Secrets

| Feature | Best incumbent | Forge |
|---|---|---|
| Typed config binding | ASP.NET Options pattern, Spring `@ConfigurationProperties` | BEAT. Config is a typed NOVA struct validated at startup. Missing/mistyped value = startup error with clear message, not a `None` crash on request #1000 |
| Env-var layering (dev/test/prod) | Spring profiles, Django settings | MATCH. `.env` + env-var override + profile-specific files |
| Secrets management | Rails credentials, Django `SECRET_KEY` | BUILD (Phase 3). Encrypted secrets file, loaded at startup |
| Feature flags | LaunchDarkly, Flipper | BUILD (Phase 5). Compile-time flags (dead-code-eliminate disabled features) + runtime toggle |

---

### 2.14 Testing

| Feature | Best incumbent | Forge |
|---|---|---|
| In-process test client (no socket) | Django test client, Go `httptest` | BEAT. `forge.dispatch(app, req)` calls handlers directly in-process at full native speed. Tests run in milliseconds |
| Mock request/response | MockMvc (Spring), supertest (Express) | MATCH. `forge.mock_request(method, path, body)` -> Request. Pure, deterministic |
| Test fixtures/factories | FactoryBot (Rails), Faker, Testcontainers | BUILD (Phase 3). Type-aware factory generation from struct definitions |
| Integration tests with real DB | `@DataJpaTest` (Spring), Testcontainers | BUILD (Phase 3). In-memory SQLite per test (zero config), parameterized |
| Load-testing helpers | k6, wrk | BUILD (Phase 5). Built-in concurrent request generator |
| Test slices (web-only, data-only) | Spring Boot test slices | BEAT (Phase 4). Compiler knows the dependency graph -- build only the needed subgraph |

---

### 2.15 Developer Experience

| Feature | Best incumbent | Forge |
|---|---|---|
| Project scaffolding | `rails new`, `django-admin startproject` | MATCH (Phase 4). `nova forge new myapp` -> working full-stack app |
| Hot-reload dev server | Spring DevTools, `nodemon` | BUILD (Phase 3). Watch mtime, recompile (~200ms), restart. Fast because compilation is fast (AOT, not JIT warmup) |
| Code generators (model/handler/migration) | `rails generate`, Artisan | BUILD (Phase 4). `nova forge generate model User` |
| Dev error pages (stack + context) | Werkzeug (Flask), Better Errors (Rails) | BUILD (Phase 3). Process tree + channel state + request context |
| REPL with app context | `rails console`, `python manage.py shell` | BUILD (Phase 4). REPL with loaded app + DB handle |
| Auto-generated admin panel | Django admin (18 years of relevance) | BUILD (Phase 6). Zero-config CRUD UI from types. Compiler-generated, real-time via LiveView. The "Crown Jewel 1" |

---

### 2.16 Messaging (Kafka / AMQP / JMS equivalents)

| Feature | Best incumbent | Forge |
|---|---|---|
| In-process message queue | All (various) | MATCH. Channels ARE message queues. Bounded, typed, backpressure-aware |
| Kafka-style durable log | Spring Kafka, kafkajs | BUILD (Phase 6). Durable channel backed by append-only file |
| AMQP/RabbitMQ | Spring AMQP | BUILD (Phase 6+). Via FFI binding or native protocol impl |
| Dead-letter routing | All (config) | BUILD (Phase 4). Failed messages routed to a DLQ channel |
| At-least-once semantics | All (ack-based) | BUILD (Phase 5). Channel ack/nack protocol |

**Forge structural note:** Kafka/RabbitMQ are external systems. For moderate scale, NOVA's
durable channels (append-only file + supervised consumer processes) eliminate the external
broker. For large scale, FFI bindings to librdkafka / rabbitmq-c are the pragmatic path.

---

### 2.17 Deployment + Ops

| Feature | Best incumbent | Forge |
|---|---|---|
| Single binary deploy | Go | MATCH. One file. No JVM, no pip, no npm |
| < 5ms startup | Go | MATCH. Binary just runs. No reflection, no classpath scanning |
| Cross-compile | Go `GOOS=linux` | MATCH. `nova build --target x86_64-unknown-linux-gnu` (proven for Linux) |
| Docker image | All | MATCH. Proven (Railway deployment). Minimal `FROM scratch` possible |
| Graceful shutdown | All (signal handlers) | BUILD (Phase 2). Inflight drain + `tcp_close(listener)` |
| Health + readiness probes (k8s) | Spring Actuator, Go | BUILD (Phase 2). `/health/live`, `/health/ready` |
| Zero-downtime rolling deploy | Kubernetes, Spring Cloud | BUILD (Phase 5). Process hot-swap via supervisor |
| Serverless / edge (WASM) | Cloudflare Workers, Vercel | BUILD (Phase 7). NOVA->WASM on edge nodes |

---

### 2.18 Internationalization

| Feature | Best incumbent | Forge |
|---|---|---|
| Translation files + locale detection | Django i18n, Rails i18n | BUILD (Phase 5). `.nova` translation files, Accept-Language parsing |
| Missing translation = compile warning | None (all fail silently or show `[missing]`) | BEAT (Phase 5). Compiler reads translation files, warns on missing keys for declared locales |
| Pluralization rules | Rails, ICU | BUILD (Phase 5). CLDR-based plural categories |
| Locale-aware formatting (date/number) | All | MATCH. `clockx` + `decimalx` exist for dates/decimals |

---

### 2.19 Email / File Storage

| Feature | Best incumbent | Forge |
|---|---|---|
| SMTP email with templates | ActionMailer (Rails), Django mail | BUILD (Phase 5). Async send = spawned Process. Templates reuse view engine |
| File storage abstraction (local/S3/GCS) | Laravel Storage, Django Files | BUILD (Phase 5). Uniform interface, swap by config |
| Streaming uploads | All | BUILD (Phase 4). Multipart -> disk (not RAM) via buffered file handles |
| Image processing hooks | ImageMagick wrappers | BUILD (Phase 6+). Via FFI |

---

## 3. CORE PREREQUISITES (Phase 0 -- Compiler Work)

These gate everything. Nothing in the typed framework works correctly without them.

### Prerequisite 1: The Struct-to-JSON Compiler Dispatch Keystone

**The problem:** A handler returning a bare struct (`return user`) erases the type to
`any` at the call site. `ir_expr_struct_type` returns `""` for an `any`-typed local.
`nova_rt_json_stringify` hits the `NOVA_MEM_LIST` branch and emits `[3,4]` (a JSON array)
instead of `{"x":3,"y":4}`. Silent wrong output to the wire.

**The mechanism (DECIDED: return-site compiler hook + runtime type-id header for long-term):**

**Near-term (Phase 0, ships with Module 1):** A compiler hook at the handler's return
site rewrites:
```
return <struct-expr>  ->  return forge.json(<Type>__to_json(<expr>) as body)
```
BEFORE the value is erased to `any`, while `ir_expr_struct_type` can still resolve the
type. This is a SMALL, LOCALIZED change (~50 lines in `ir_lower_expr`):
1. At a return from a function whose return type is `any` (or unspecified -- the handler
   case), check if the return expression's `ir_expr_struct_type` returns a known struct.
2. If yes, emit `<Type>__to_json(expr)` instead of the bare value.
3. String and already-Response returns pass through unchanged.
4. List-of-struct returns use the existing `ir_list_elem_struct` path (already works).

**Long-term (Phase 2+):** Give record structs a runtime type-id header so
`nova_rt_json_stringify` / `==` / `show` recover field names dynamically even through the
`any` boundary. This is a value-model change (every struct allocation grows a tag word)
with its own reconverge + GATE 4/5 gate. It generalizes the solution to all
struct-through-any contexts (containers, channels, closures), not just handler returns.

**Justification for the near-term path:** The return-site hook is sufficient for 95% of
Forge use cases (handler returns are the dominant struct-to-wire path). It is small,
testable, and does not touch the value model. The long-term type-id header is tracked
but does not block Forge v0.1.

**Gate:** `handler_return_json_test` -- a handler returning a bare `Point{x:3,y:4}`
struct must produce wire body `{"x":3,"y":4}`, NOT `[3,4]`.

### Prerequisite 2: Cross-Import Extern Resolution

**The problem:** `extern fn` declarations in module A cannot be called from module B.
The compiler does not resolve extern symbols across import boundaries. Forge cannot
`import sqlitex` and call `sqlitex.db_query` directly.

**The fix:** When resolving a call to `module.fn_name`, if `fn_name` is not found in the
module's regular function table, also check the module's extern declarations. Thread the
extern's declaration (name, params, return type, link symbol) into the calling module's
IR emission so the LLVM `declare` is emitted in the caller's compilation unit.

**Scope:** This is a compiler fix in the module-resolution pass. Estimated ~30 lines
in `ir_resolve_module_call`. Unblocks `forge.query_as(db, ...)` calling through to
sqlitex externs without the user importing sqlitex directly.

**Gate:** A test where `forge.nova` calls `sqlitex.db_query` via import must compile
and execute correctly.

### Prerequisite 3: from_json Typed-Let Implementation

**The problem:** `let p: Point = from_json(data)` crashes at runtime. The
`_make_from_json_method` generates code that calls a reconstructor that does not exist
at runtime.

**The fix:** Implement the `<Type>__from_json` method body: given a dict/JSON-decoded
value, extract fields by name (from the struct's field list, known at compile time),
coerce each to the field's type (int -> parse_int, float -> parse_float, string -> pass,
bool -> =="true", nested struct -> recursive __from_json), and construct the struct.

**Gate:** `from_json_test` must pass (currently not in the regression suite -- add it).

### Prerequisite 4: Request/Response as Structs (not dicts)

**The problem:** Today's `req` is a hand-built dict `{method, path, body, params}`.
`resp` is a wire string. This prevents typed field access, makes middleware do fragile
string surgery, and prevents compile-time checking of handler signatures.

**The fix:** Define `Request` and `Response` as NOVA structs per FORGE_DESIGN.md s4.1.
Parse-once dicts for params/query/headers (O(1) access). Response is a mutable struct
with status/headers/body fields. `finalize(resp)` serializes to wire string once.

**Dependency:** Requires Prerequisite 1 (the struct->JSON keystone) so that handlers
returning a Response struct serialize correctly.

---

## 4. LAYERED PHASE PLAN

Each phase is gated: edit -> precheck -> gen4 smoke -> bootstrap reconverge (gen5.ll ==
gen6.ll) -> full regression -> commit. Kill-on-timeout enforced for all binary execution.

---

### Phase 0: Prerequisites (Compiler Keystones)

**Goal:** Fix the three compiler blockers so the typed framework can exist.

**Deliverables:**
1. Return-site auto-JSON compiler hook (Prerequisite 1)
2. Cross-import extern resolution (Prerequisite 2)
3. `from_json` typed-let implementation (Prerequisite 3)
4. `handler_return_json_test` proof gate
5. `from_json_test` added to regression suite

**NOVA core work:** ~100 lines of compiler changes across `ir_lower_expr` (return hook),
`ir_resolve_module_call` (externs), and `_make_from_json_method` (body impl).

**Gate:** All three tests pass. Bootstrap reconverges. Full regression stays green.

**Competitive claim unlocked:** "Return a struct, get JSON -- zero annotations."

**Estimated effort:** 3-5 iterations.

---

### Phase 1: Typed Core (Request/Response/App + Integrated Routing)

**Goal:** Replace the dict-based MVP with typed structs and close the three named MVP
gaps (G1: synchronous accept, G2: handler can't see raw request, G3: no object model).

**Deliverables:**
1. `Request` struct (method/path/raw_path/params/query/headers/body/state/conn)
2. `Response` struct (status/headers/body/halted)
3. `App` struct (router/mws/prefix/static_root/not_found/on_panic/db)
4. `_build_request` parse-once (O(1) access, case-insensitive headers, fixes xkey= bug)
5. `finalize(resp)` -- Response struct -> wire string, single pre-sized buffer
6. `forge.json(value)` / `forge.text(s)` / `forge.html(s)` / `forge.redirect(url)` /
   `forge.file(path)` -- value-polymorphic builders returning Response structs
7. `_coerce(any) -> Response` for handler return coercion
8. Spawn-per-connection serve (THE fix for G1)
9. Keep-alive loop with `max_keepalive_reqs` cap (leak mitigation)
10. `_recv_request_timeout` (Slowloris defense)
11. `forge.recover()` middleware (spawn+monitor per request, panic -> 500)
12. `forge.limit_body(maxBytes)` middleware
13. 405 vs 404 second-pass dispatch + Allow header
14. `*name` wildcard catch-all in route matching
15. `forge.group(app, prefix)` for route grouping
16. Traversal-safe `forge.static(app, prefix, root)` (url_decode FIRST, reject `..`)
17. Pure test surface: `forge.mock_request` / `forge.dispatch` / `forge.status_of` /
    `forge.body_of`

**NOVA core work:** None beyond Phase 0 (all pure NOVA).

**Gate:** `forge_typed_test` -- full CRUD handler round-trip with typed Request/Response,
bare-struct return producing correct JSON, crash isolation via recover, static file
serving, route groups, 405/404 distinction. Socket + pure dispatch tests.

**Competitive claim unlocked:**
- "Flask-simple handlers with Go-class concurrency and Erlang-class crash isolation"
- "Type-checked templates (HTML is NOVA functions)"
- "One static binary, zero dependencies"

**Estimated effort:** 5-8 iterations.

---

### Phase 2: Data Layer + Transactions + Connection Pool

**Goal:** Make Forge database-capable with the simplest, most type-safe data access
of any framework.

**Deliverables:**
1. `forge.query_as<T>(db, sql, params)` -- row -> struct by column order, typed by `let`
2. `forge.query_one<T>(db, sql, params)` -- Result<T, Error>
3. `forge.exec(db, sql, params)` -- returns last_insert_id
4. `forge.body_as<T>(req)` -- JSON body -> struct, typed by `let`
5. `forge.form_as<T>(req)` -- URL-encoded form -> struct, typed by `let`
6. `from_json_safe<T>` -> Result<T, Error> (monadic-? on malformed bodies)
7. `forge.tx(db, fn(tx) { ... })` -- transactions, rollback on err
8. Connection pool as a channel of SQLite handles (bounded, backpressure)
9. `last_insert_rowid` extern (one line)
10. Health endpoint (`/health`) with DB check
11. Request-ID middleware (UUID per request)
12. Security headers middleware (HSTS/CSP/X-Frame, default-on)
13. Rate limiting middleware (owner-actor, lock-free)
14. Response compression middleware (gzip)
15. Graceful shutdown (inflight counter + `tcp_close(listener)`)
16. SSE (Server-Sent Events) via streaming response

**NOVA core work:** `last_insert_rowid` extern. Possible small compiler work for the
row->struct structural method.

**Gate:** Full-stack CRUD app with typed data access, transactions, connection pool,
health check, graceful shutdown. Load test: 1000 concurrent requests, no crash, correct
data, arena-flat.

**Competitive claim unlocked:**
- "Simpler than Django ORM: `let users: list<User> = query_as(db, sql, [])` -- done."
- "Connection pool is a channel: backpressure, supervision, auto-reconnect for free."
- "Transactions that actually work on self-invocation (no @Transactional proxy footgun)."

**Estimated effort:** 5-8 iterations.

---

### Phase 3: Security + Sessions + Validation + OpenAPI + DevX Foundations

**Goal:** Make Forge secure-by-default and API-documentation-complete.

**Deliverables:**
1. `forge.sessions(secret)` -- HMAC-signed cookie (HttpOnly + SameSite=Lax)
2. Server-side session store (token -> SQLite row)
3. `forge.csrf()` -- double-submit token, constant-time verify, default-on
4. `forge.require_auth(verify_fn)` -- guard middleware
5. JWT encode/decode/verify (HS256 via `hmac_sha256`)
6. API key middleware (header extraction + constant-time compare)
7. Argon2id password hashing (via FFI to reference C impl)
8. Type-driven validation: constraints on types generate validators at compile time
   - `forge.validate(req, rules)` returning `Result<T, ValidationErrors>`
   - Field-level error messages with path
9. OpenAPI 3.x generation at compile time from route signatures + types
10. TypeScript client stub generation from the same types
11. Named routes + `url_for` (compile-checked reverse routing)
12. Compiled radix-trie router (O(path-length))
13. Hot-reload dev server (watch mtime, recompile, restart)
14. Dev error pages (process tree + request context + stack trace)
15. Prepared statement caching (per-connection LRU)
16. ETag/Cache-Control middleware
17. PubSub channel groups (subscribe/unsubscribe/broadcast)
18. Cron-style scheduled tasks (`forge.schedule(cron, fn)`)
19. Background job retries with exponential backoff (supervisor restart policy)

**NOVA core work:** Argon2id FFI binding. Compile-time route analysis for OpenAPI
(a build-step that walks the AST).

**Gate:** Secure notes app with sessions, CSRF, JWT API, Argon2 passwords, validated
input, auto-generated OpenAPI spec served at `/docs`, TypeScript client that compiles.

**Competitive claim unlocked:**
- "FastAPI's auto-OpenAPI, but compile-time (can't drift, zero runtime cost)."
- "Spring Security's power without the proxy footguns."
- "Django's secure-by-default (CSRF, XSS escape, SQL injection impossible)."

**Estimated effort:** 8-12 iterations.

---

### Phase 4: Full ORM + Relations + Migrations + Content Negotiation

**Goal:** Complete data layer rivaling Django ORM / Ecto in ergonomics, beating both
in type safety.

**Deliverables:**
1. Model relations: `has_many`, `belongs_to`, `has_one`, `many_to_many`
   (typed, compiler-enforced foreign key consistency)
2. Eager loading by default (no lazy-loading proxy -- no `LazyInitializationException`)
3. Query builder: composable query structs (`User.where(age: gt(18)).order("name")`)
4. Auto-generate migrations from model diffs (compiler diffs struct definitions)
5. Reversible up/down migrations as NOVA functions
6. Data-loss-dangerous migration warnings at compile time
7. OAuth2/OIDC social login (authorization-code flow + PKCE)
8. Form validation with field-level error rendering
9. Content negotiation (JSON/HTML based on Accept header)
10. Multipart/form-data parsing (file uploads with max-body cap)
11. Static asset fingerprinting (content-hash filenames) + embedding in binary
12. HTMX-style partial HTML responses
13. Postgres driver (native wire protocol via FFI)
14. `nova forge new myapp` scaffolding
15. `nova forge generate model/handler/migration` generators
16. Dead-letter queue for failed background jobs
17. Error tracking (panic -> structured error report)

**NOVA core work:** Postgres wire protocol FFI. Asset embedding (`embed_file` compile-time
directive -- equivalent to Go's `//go:embed`).

**Gate:** Multi-model app with relations, migrations, eager loading, OAuth login, file
uploads, Postgres backend. `nova forge new` produces a working app.

**Competitive claim unlocked:**
- "Django ORM ergonomics, Ecto type safety, no Hibernate surprises."
- "Auto-generated migrations from model diffs -- like EF Core, but in the compiler."
- "`nova forge new` -> working full-stack app in 30 seconds."

**Estimated effort:** 10-15 iterations.

---

### Phase 5: Distribution + Compile-Time SQL + Advanced Features

**Goal:** Unlock the features that are structurally impossible for incumbents.

**Deliverables:**
1. Compile-time SQL validation (compiler connects to schema at build time, verifies
   column names, types, joins). A typo in a query = compile error.
2. N+1 query detection at compile time (compiler traces query patterns in loops)
3. Distributed channels across machines (already have `remote_*` primitives; this
   adds the service-discovery + configuration layer)
4. Distributed cache (cache is a Mesh process)
5. Phoenix Presence equivalent (CRDT-merged per-node state)
6. MySQL driver (native wire protocol via FFI)
7. Job dashboard (ops UI: throughput, retries, failures)
8. MFA/2FA (TOTP RFC 6238)
9. i18n with compile-time translation checking
10. Email sending (SMTP + templated, async via spawned process)
11. File storage abstraction (local / S3 via FFI, swap by config)
12. Load-testing helpers built into the test framework
13. Test factories (type-aware random struct generation)
14. Fragment caching
15. Feature flags (compile-time + runtime toggle)

**NOVA core work:** The compile-time SQL validation is the crown jewel of the data layer.
Mechanism: `nova build` connects to a SQLite/Postgres schema (file or connection string
in `nova.toml`), reads the schema metadata, and the compiler checks every
`query_as`/`exec` call against it. This is a build-step, not a language change.

**Gate:** A query referencing a non-existent column must fail the build with a clear
error. A loop containing a `query_as` inside a `for note in notes` must warn about N+1.

**Competitive claim unlocked:**
- "Compile-time SQL validation -- the thing sqlx needs a live DB + macros for, Forge
  does natively."
- "N+1 detection at compile time -- a world-first."
- "Distributed workers with zero code change -- same binary, different machine."

**Estimated effort:** 12-18 iterations.

---

### Phase 6: Crown Jewels (Auto-Admin + Real-Time UI + WASM Frontend)

**Goal:** Ship the three features no competitor can copy.

**Deliverables:**
1. **Crown Jewel 1: Auto-Admin.** Zero-config CRUD UI generated from type definitions.
   Compiler knows every model's fields, types, and relations -> generates a complete
   admin panel. Like Django's admin, but rendered as a real-time UI (Crown Jewel 2)
   with compile-time type safety. No `admin.site.register(Model)`. Zero config.

2. **Crown Jewel 2: Server-Driven Real-Time UI (LiveView model).**
   Per-user Process holding UI state, communicating over a WebSocket channel. Template
   compiler-split into static and dynamic parts -- only changed values cross the wire.
   Client patches the DOM. Native speed (not BEAM). Per-user crash isolation from the
   process model. The same model handles: live dashboards, chat, collaborative editing,
   notifications, the admin panel.

3. **Crown Jewel 3: WASM Frontend.**
   NOVA components compile to client-side WASM (lean, <30KB, no heavy runtime). Same
   types on both sides of the wire (compile-checked). Per-component render modes:
   Static SSR, Server-push (LiveView), Client WASM, Auto (starts server, transitions
   to client). Beats Blazor on bundle size and LiveView on offline capability.

4. GraphQL endpoint generation (type-derived schema)
5. gRPC services (code-gen from `.proto` or type-derived)
6. Durable message channels (append-only file for Kafka-like semantics)
7. RBAC policy engine (compiled functions, type-checked against user model)

**NOVA core work:** WASM DOM/IO bindings (WASM compute already works; needs browser
APIs). LiveView diffing engine. Template static/dynamic split in the compiler.

**Gate:** Auto-admin running on a real database showing all models with CRUD operations.
A LiveView counter that updates in real-time across multiple browser tabs. A WASM
frontend sharing types with the backend, compiled to <30KB.

**Competitive claim unlocked:**
- "Django's auto-admin + Phoenix's LiveView + Blazor's WASM -- all at native speed,
  one language, one binary."
- "The first framework with a type-checked, single-language, native-speed full stack."

**Estimated effort:** 15-25 iterations.

---

### Phase 7: Production Hardening + Battle-Testing

**Goal:** Make Forge production-grade. Earn trust.

**Deliverables:**
1. HTTP/2 multiplexing + HPACK
2. Zero-downtime rolling deploy (supervisor hot-swap)
3. Windows TLS server (Schannel)
4. Comprehensive security audit (OWASP Top 10 coverage)
5. Memory campaign: close the ~41 objs/req scope-exit leak (total-RC)
6. 10 real applications built with Forge by external developers
7. Performance certification: TechEmpower-style benchmarks vs Spring/Django/Go/Phoenix
8. Documentation: getting-started guide, API reference, cookbook, migration guides
9. `nova forge console` (REPL with app + DB context)
10. Visual admin theming
11. Edge deployment (WASM to CDN nodes)
12. HTTP/3 QUIC

**NOVA core work:** Total-RC scope-exit drops (the memory campaign). HTTP/2 parser.
QUIC implementation.

**Gate:** 10 real apps running in production. TechEmpower benchmark results showing
Forge in top 5 across categories. Security audit passing with zero critical findings.

---

## 5. COMPETITIVE SCORECARD

Forge vs every major framework across 20 dimensions. Honest assessment with current
status (TODAY) and target status (PLAN).

| # | Dimension | Spring Boot | Django | Rails | Phoenix | FastAPI | Axum/Rust | Go (Gin) | **Forge TODAY** | **Forge PLAN** |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Startup time | LOSE (5s) | LOSE (1s) | LOSE (2s) | TIE (50ms) | LOSE (500ms) | TIE (5ms) | TIE (5ms) | **WIN (<5ms)** | **WIN** |
| 2 | Memory baseline | LOSE (300MB) | LOSE (80MB) | LOSE (100MB) | LOSE (60MB) | LOSE (50MB) | TIE (5MB) | TIE (15MB) | **WIN (<10MB)** | **WIN** |
| 3 | Single binary deploy | LOSE | LOSE | LOSE | LOSE | LOSE | TIE | TIE | **WIN** | **WIN** |
| 4 | Handler simplicity (no coloring) | LOSE (WebFlux) | TIE | TIE | LOSE (gen_server) | LOSE (async) | LOSE (async fn) | TIE | **WIN** | **WIN** |
| 5 | Concurrency (10k conn) | TIE (threads) | LOSE (GIL) | LOSE (MRI) | TIE (BEAM) | LOSE (GIL) | TIE | TIE (goroutines) | **WIN** | **WIN** |
| 6 | Per-request crash isolation | LOSE | LOSE | LOSE | WIN | LOSE | LOSE | LOSE | **TIE (Phoenix)** | **WIN (+ AOT speed)** |
| 7 | GC pause impact on p99 | LOSE | LOSE | LOSE | LOSE (per-proc GC) | LOSE | WIN (no GC) | LOSE | **WIN (arena)** | **WIN** |
| 8 | Type safety (end-to-end) | TIE (Java types) | LOSE | LOSE | LOSE | TIE (hints) | WIN (Rust) | TIE | **TIE** | **WIN (+ HTML + WASM)** |
| 9 | JSON from domain object | TIE (Jackson) | TIE (DRF) | TIE | TIE (Jason) | TIE (Pydantic) | TIE (Serde derive) | LOSE | **LOSE (broken)** | **WIN (zero-annotation)** |
| 10 | ORM / data ergonomics | TIE (JPA) | WIN | WIN (AR) | WIN (Ecto) | LOSE | LOSE | LOSE | **LOSE (dict only)** | **WIN (typed query_as)** |
| 11 | Auto-admin (zero-config) | LOSE | WIN | LOSE | LOSE | LOSE | LOSE | LOSE | **LOSE** | **WIN (+ real-time)** |
| 12 | Auto OpenAPI from types | LOSE (annotations) | LOSE | LOSE | LOSE | WIN | LOSE | LOSE | **LOSE** | **WIN (compile-time)** |
| 13 | Real-time (WS/PubSub) | LOSE | LOSE | TIE (Hotwire) | WIN | LOSE | LOSE | LOSE | **TIE** | **WIN (native speed)** |
| 14 | WASM frontend (same lang) | LOSE | LOSE | LOSE | LOSE | LOSE | LOSE | LOSE | **LOSE** | **WIN (unique)** |
| 15 | Background jobs (no broker) | LOSE (Quartz) | LOSE (Celery) | LOSE (Sidekiq) | TIE (OTP) | LOSE | LOSE | LOSE | **WIN (spawn)** | **WIN** |
| 16 | Compile-time SQL validation | LOSE | LOSE | LOSE | LOSE | LOSE | TIE (sqlx) | TIE (sqlc) | **LOSE** | **WIN (native)** |
| 17 | Compile-time DI | LOSE (runtime) | LOSE | LOSE | LOSE | LOSE | TIE (static) | TIE (static) | **WIN** | **WIN** |
| 18 | Security by default | TIE | WIN | TIE | TIE | LOSE | LOSE | LOSE | **LOSE** | **WIN (SQL impossible)** |
| 19 | Scaffolding/generators | TIE (Initializr) | TIE | WIN | WIN (mix) | LOSE | LOSE | LOSE | **LOSE** | **TIE** |
| 20 | Ecosystem maturity | WIN (20yr) | WIN (18yr) | WIN (20yr) | TIE (10yr) | TIE (5yr) | LOSE (3yr) | TIE (10yr) | **LOSE** | **LOSE** |

**Reading the scorecard:**
- **TODAY:** Forge WINs on 7 dimensions (startup, memory, binary, handlers, concurrency,
  GC, DI), TIEs on 3, LOSEs on 10. The LOSEs are almost all "not built yet" -- not
  structural deficiencies.
- **PLAN:** Forge WINs on 18 dimensions, TIEs on 1 (scaffolding), LOSEs on 1 (ecosystem
  maturity -- won by time, not code).
- **The one permanent LOSE:** Ecosystem maturity. Spring has 20 years, Django has 18.
  Forge has zero. This is won by real users over real time. The plan ends in
  battle-testing (Phase 7), not more features.

---

## 6. RISKS + HONEST GAPS

### Risk 1: The Struct-JSON Keystone Is Harder Than It Looks

**Probability:** Medium. The return-site hook is small (~50 lines) but touches the
compiler's core expression-lowering path. Any mistake here breaks every program.

**Mitigation:** Bootstrap reconverge is mandatory. The hook is context-scoped (only
fires for functions whose return type is `any` and whose return expression is a known
struct type). The existing `ir_expr_struct_type` heuristic is proven reliable for
statically-known struct expressions.

**Fallback:** If the hook proves unsound for edge cases, fall back to the runtime
type-id header approach (longer but general).

### Risk 2: Per-Request Memory Leak at Sustained High Throughput

**Probability:** HIGH. The ~41 string temporaries/request leak is measured and real.
Under sustained high load (100k+ requests), memory grows without bound.

**Mitigation (today):** `max_keepalive_reqs` cap + process-recycle (the uWSGI
max-requests pattern). Arena frees everything per-request for arena-scoped handlers.

**Mitigation (planned):** Total-RC scope-exit drops (the core follow-on, tracked in
FULL_TOTAL_RC_DESIGN.md). When this lands, all per-request temporaries are reclaimed
with zero Forge API change.

**Honest positioning:** "Production-ready for dev and moderate load. For sustained high
throughput, use arena-scoped handlers (proven flat) or the keep-alive cap until total-RC
ships." This is stated in the README, not hidden.

### Risk 3: Cross-Import Extern Resolution Is a Deeper Compiler Gap

**Probability:** Medium. The extern-across-module issue may have interactions with the
module loader, the LLVM declaration emitter, and the linker.

**Mitigation:** The workaround (same-file externs + wrapper functions exported through
the module) is proven and works for SQLite. The compiler fix is cleanly scoped.

**Fallback:** Forge bundles sqlitex code inline until the fix lands.

### Risk 4: Compile-Time SQL Validation Requires Schema Access at Build Time

**Probability:** LOW (it is a design challenge, not a risk). The mechanism is a
build-step: `nova build` reads the schema from a file or connection string configured
in `nova.toml`. The compiler checks queries against the schema metadata.

**Known challenge:** Schema changes between build and deploy. Mitigation: migrations
must be applied before deploy (the standard Rails/Django workflow). The build checks
against the CURRENT schema; the migration ensures the deployed schema matches.

### Risk 5: The Crown Jewels (Phase 6) Are Multi-Month Efforts

**Probability:** HIGH. LiveView, WASM frontend, and auto-admin are each significant
subsystems.

**Mitigation:** They are Phase 6, not Phase 1. Forge is competitive (and usable for
real apps) after Phase 3 -- all three Crown Jewels are additive, not foundational.
The framework stands on its own without them.

**Honest positioning:** The Crown Jewels are the "why Forge is special" endgame, not the
"why Forge is usable today" bar. The bar is Phase 3: typed data, sessions, auth,
validation, OpenAPI.

### Risk 6: NOVA Core Limitations That Block Forge Features

| NOVA gap | Blocks | Status | Plan |
|---|---|---|---|
| Struct-through-any JSON (keystone) | Handler return, admin, OpenAPI | Phase 0 prerequisite | Return-site hook (near-term) + type-id header (long-term) |
| Cross-import extern | Forge importing sqlitex | Phase 0 prerequisite | Compiler fix |
| from_json crashes | body_as typed deserialization | Phase 0 prerequisite | Implement __from_json body |
| Scope-exit string leak | Sustained high-throughput memory | Tracked core follow-on | Total-RC design exists. Not a Forge blocker; mitigated |
| WASM DOM/IO bindings | Crown Jewel 3 (WASM frontend) | Phase 6 | WASM compute works; browser APIs needed |
| Windows TLS server (Schannel) | HTTPS on Windows | Phase 7 | Linux OpenSSL server works today |
| Multi-carrier M:N (N>1) | True multi-core load balancing | Opt-in (single carrier is production-ready) | Stage 2b work-stealing |
| Const generics | Array-length-in-type | Not needed for Forge v0.1 | Future |
| Growable stacks | Deep recursion in handlers | 32KB fixed; sufficient for web handlers | Future |

---

## 7. SEQUENCING RATIONALE

**Why this order, and what unblocks what.**

### Phase 0 first (compiler keystones):
Everything typed depends on structs surviving the `any` boundary. The return-site hook
is the smallest change that unblocks the widest surface: handler returns, `body_as`,
`query_as`, `form_as`, OpenAPI, admin, and the entire "derive from types" thesis. Without
it, Forge ships silently wrong JSON -- the one thing worse than shipping nothing.

Cross-import externs unblock clean module boundaries (Forge importing sqlitex without
same-file hacks). `from_json` unblocks typed request deserialization.

### Phase 1 second (typed core):
The four structs (Request/Response/App/Handler) are the API surface everything else
builds on. Middleware, data, auth, views -- all consume and produce Request/Response.
Getting these right first means every subsequent phase is additive, never rewriting
the core.

Spawn-per-connection (the G1 fix) is here because Forge cannot demo concurrency without
it. Recovery middleware is here because crash isolation is a headline moat.

### Phase 2 third (data):
Data access is the #1 thing every web app needs after routing. Every framework's adoption
depends on how easy it is to get data in and out of a database. `query_as<User>` is the
jaw-drop moment that makes NOVA feel magical -- zero annotations, zero ORM config, just
`let users: list<User> = query_as(db, sql, [])`.

Transactions and connection pooling make it production-viable. Health checks and graceful
shutdown make it deploy-viable.

### Phase 3 fourth (security + validation + OpenAPI):
These are the table-stakes that make Forge credible for real applications. A framework
without auth, sessions, CSRF, and validation is a toy. OpenAPI auto-generation is the
FastAPI-killer feature that makes Forge stand out at conferences and in blog posts.

### Phase 4 fifth (full ORM + relations + migrations):
The full data layer completes the "someone can build a real product" milestone. Relations,
eager loading, migrations, and scaffolding make Forge competitive with Django/Rails for
data-heavy applications.

### Phase 5 sixth (distribution + compile-time SQL):
These are the features that are structurally impossible for incumbents. Compile-time SQL
validation and N+1 detection are world-firsts. Distributed channels across machines
are the scaling story. These are the "why Forge, not Django?" answers for large teams.

### Phase 6 seventh (Crown Jewels):
Auto-admin, LiveView, WASM frontend. These are the "jaw-drop" features that generate
conference talks, blog posts, and mindshare. They require a mature framework underneath
(which Phases 1-5 deliver). Building them on a shaky foundation would waste the effort.

### Phase 7 continuous (battle-testing):
Trust is earned by real users running real apps. Features don't matter if they break
under production load. This phase starts during Phase 4 (when the framework is usable
for real apps) and never ends.

---

## 8. WHAT "BUILT WITH FORGE" MEANS

At the end of this plan, a developer types `nova forge new myapp`, gets a working
full-stack app in 30 seconds, builds their backend + frontend + database + real-time
+ background jobs in ONE language, and deploys ONE binary that starts in 5ms, handles
10k concurrent connections with straight-line synchronous handlers, never falls over
because the supervisor catches every crash, never leaks memory because every request
runs in an arena, and never ships a type mismatch to production because the compiler
checks JSON, SQL, HTML, and the frontend against the same types.

Spring Boot needs 1000+ JARs, a JVM, 5 seconds to start, and 300MB of RAM.
Django needs Python, pip, gunicorn, Celery, Redis, and a deployment pipeline.
Rails needs Ruby, Bundler, Puma, Sidekiq, Redis, and ActiveRecord.
Phoenix needs Erlang, Elixir, Mix, and accepts being 10x slower than native for CPU work.

Forge needs nothing. One binary. One language. One developer.

**The developer never leaves. That is why we build all of it. And the compiler, the
process model, the arena, and the single binary are why we build it BETTER.**

---

## APPENDIX A: File Locations

```
NOVA_DESIGN/FORGE_MASTER_PLAN.md        -- THIS FILE (canonical build plan)
NOVA_DESIGN/FORGE_DESIGN.md             -- v0.3 detailed design (object model, lifecycle, keystone)
NOVA_DESIGN/FORGE_ARCHITECTURE.md       -- Internal framework structure + project layout
NOVA_DESIGN/SERIALIZATION_GAPS.md       -- Struct-through-any JSON analysis + Path A/B
NOVA_DESIGN/FULL_TOTAL_RC_DESIGN.md     -- Arena + RC dual-path memory design
NOVA_DESIGN/PERFORMANCE_SPECIALIZATION.md -- Type-driven specialization roadmap
nova-compiler/test_programs/forge.nova   -- Current framework implementation (~550 lines)
nova-compiler/test_programs/sqlitex.nova  -- SQLite FFI binding (proven)
nova-compiler/test_programs/routerx.nova  -- Router implementation
nova-compiler/test_programs/supx.nova     -- Supervisor/monitor
nova-compiler/test_programs/authx.nova    -- Auth utilities
nova-compiler/test_programs/urlx.nova     -- URL encoding/parsing
```

## APPENDIX B: The Spring Boot Deconstruction

Spring Boot's ~25 major modules mapped to how Forge replaces them:

| Spring Module | What it does | Forge equivalent | How |
|---|---|---|---|
| spring-core (IoC/DI) | Runtime bean container, reflection, proxies | Compile-time wiring | Static function calls, no reflection |
| spring-boot-autoconfigure | Conditional bean registration from classpath | Compiler sees all code | Whole-program compilation = implicit autoconfigure |
| spring-web (MVC) | DispatcherServlet, @Controller, routing | forge.get/post + dispatch | Green-task-per-conn, straight-line handlers |
| spring-webflux | Reactive Mono/Flux stack | Not needed | Green scheduler eliminates the need for reactive |
| spring-data-jpa | JPA repository abstraction | forge.query_as + typed structs | Zero-reflection row mapping |
| spring-security | Filter chain, auth, authz | forge.sessions/csrf/require_auth | Compiled policies, no proxy footgun |
| spring-boot-actuator | Health/metrics/info endpoints | forge observability module | Built-in /health /metrics, channel-graph tracing |
| spring-cloud-config | Centralized config from Git | Config is a typed struct + env layering | Compile-time validated, no config server needed |
| spring-cloud-gateway | API gateway, rate limiting | forge.rate_limit + route groups | Same binary, no separate gateway service |
| spring-kafka/amqp | Messaging integration | NOVA channels (local + distributed) | No external broker for moderate scale |
| spring-batch | Chunk-oriented batch processing | Supervised spawned processes | Job = Process, queue = Channel |
| spring-session | Distributed sessions via Redis | forge.sessions (cookie/SQLite) | No Redis for single-node |
| spring-cache (@Cacheable) | Declarative caching via proxy | forge.cache (process-local LRU) | No proxy, no self-invocation footgun |
| spring-retry (@Retryable) | Retry via proxy | Supervisor restart policy | Native fault tolerance, not a proxy |
| spring-scheduling (@Scheduled) | Cron tasks | forge.schedule | Supervised, same binary |
| spring-test (MockMvc) | Controller test slicing | forge.dispatch (in-process) | Full native speed, no context boot |
| spring-boot-devtools | Hot reload | Watch + recompile | ~200ms vs 5s restart |
| spring-hateoas | Hypermedia REST | url_for + link generation | Compile-checked links |
| Thymeleaf | Server-side templates | HTML = NOVA functions | Type-checked, no template language |
| Flyway/Liquibase | Schema migrations | forge.migrate | Model-diff auto-generated |
| HikariCP | Connection pool | Channel of connections | Backpressure + supervision for free |
| Jackson | JSON (de)serialization | Auto __to_json/__from_json | Zero annotation, compile-time |
| Hibernate Validator | Bean Validation (JSR-380) | Type-driven validation | Compile-time generated validators |
| GraalVM native-image | AOT native compilation | Default (NOVA is AOT-native) | No reflection metadata, no fragile build |

---

# PART II — ADVERSARIAL REVIEW & BINDING CORRECTIONS (2026-06-15)

Part I (above) is the ambition. Part II is the **honesty layer** produced by an adversarial
review (devils-advocate agent, 14 findings: 2 FATAL, 7 HIGH, 5 MEDIUM). Where Part II
contradicts Part I, **Part II wins** — it overrides the optimistic claims. The moats are
real and structurally impossible for Spring to copy; the *timeline and several "PROVEN"
claims were overpromised*. This is the plan we actually execute.

## Adversary's verdict (verbatim, accepted)

> The moats (arena memory, crash isolation, zero-dep binary, no async coloring) are
> genuine and structurally impossible for Spring to copy — but the projected 18-WIN
> scorecard is overpromised by ≥5 dimensions, the realistic timeline is 3–5 years of
> solo work, and the plan commits to building an ORM / compile-time SQL / LiveView / WASM
> frontend on top of a language that TODAY cannot return a struct from a handler without
> corrupt JSON, has no keep-alive, leaks ~41 objects/request, runs on one OS thread by
> default, and has no generics for `query_as<T>`. There is no ecosystem strategy.

**Accepted in full.** None of this kills the project — but every item below is now a tracked
constraint, not a surprise discovered in production.

## The single most important correction — the keystone mechanism is WRONG as written

**Part I §3 Prerequisite 1 proposes a return-site hook** ("when a function returns `any`
and the return expr is a known struct, rewrite `return e` → `return Type__to_json(e)`").
**The adversary proved this UNSOUND (Gap #6), and it is.** It fires on *every* function that
returns a struct through `any`, not just handlers:

```nova
fn make_user() -> any { return User{...} }   // NOT a handler
let u = make_user()
print(u.name)        // CRASH/garbage — u is now a JSON string, not a User
```

The plan's "context-scoped (only fires for any-returning fns)" is exactly the bug: that
describes *every* struct-returning function. To scope it to handlers, the compiler must
track which functions are route callbacks — an effect annotation that **violates NOVA's
zero-annotation law** and is still narrower than the real need (structs also lose their
type through containers, channels, and closures — the same silent-array bug).

**BINDING DECISION — the keystone is the runtime type-id header, not the return-site hook.**
Give every record-struct allocation a small **type-id word** (an index into a compile-time
struct-metadata table: field names, count, field types). Then `nova_rt_json_stringify`,
`==`, and `show` recover the struct's shape **dynamically through the `any` boundary** —
sound *everywhere* (handler return, list element, channel payload, closure capture), with
**zero handler-tracking and zero annotations**. This is the NOVA-way solution: the value
carries its own identity; the compiler doesn't have to guess intent at the return site.

Cost, stated honestly: this is a **value-model change** (struct header grows; touches
`find_tag`, the arena tag bits, the int/pointer-soundness invariants) → full reconverge +
GATE 4/5 perf check. It is bigger than "~50 lines." But it is **sound**, and soundness is
the non-negotiable #1 rule. It also subsumes Prerequisite 3 (`from_json`) — the same
metadata table drives reconstruction. *This is the one decision the keystone sign-off must
make* (see the question posed alongside this plan).

## `query_as<T>` is its own compiler sub-track, not "~30 lines" (Gap #1, FATAL)

The typed-let rewrite (`let p: Point = from_json(d)` → `Point__from_json(d)`) only works
for a **syntactically adjacent** call. `query_as` is a *library* function receiving
`list<list<any>>` rows — nothing tells it `T = Note`. Making `let xs: list<Note> =
query_as(...)` work requires **let-site type propagation into callee specialization** —
ad-hoc monomorphization for a *registered set* of type-directed framework functions
(`query_as`, `query_one`, `body_as`, `form_as`). **BINDING:** this is a Phase-0 compiler
sub-track of its own (est. 4–8 iters), reusing the type-id-header metadata; it is **not**
bundled with, and does not block, the JSON keystone.

## BINDING corrections to scope, sequencing, and claims

| # | Sev | Correction (overrides Part I) |
|---|---|---|
| 2 | FATAL | **Moat 3 (flat memory): PROVEN → PARTIAL.** Arena is flat for arena-scoped allocs; ~41 string temporaries/request still leak. **No p99 / TechEmpower claim vs Spring until the scope-exit total-RC lands.** Keep-alive process-recycle is an interim *mitigation* (the uWSGI pattern), explicitly not a "win." |
| 3 | HIGH | **Moat 2 (concurrency): honest label = "I/O-bound-class today" (single carrier = 1 OS thread, Node-like).** "Go-class multi-core" requires **multi-carrier N>1**, which has known races (channel lost-wakeup, netpoller not M:N-coordinated). **Multi-carrier stabilization (Stage 2b) is PROMOTED to a prerequisite for any throughput benchmark.** No TechEmpower until it works. |
| 4 | HIGH | **HTTP/1.1 keep-alive PROMOTED from Phase 1 item to Phase 0/1 core**, with the arena-per-request × persistent-connection interaction designed explicitly (socket + keep-alive loop state live *outside* the per-request arena). No benchmark is meaningful without it. Current `Connection: close` makes every request pay TCP+TLS handshake. |
| 12 | MED | **Response body = string OR channel/iterator from Phase 1** (streaming-capable from day one). Retrofitting streaming onto the current string-concat response is a rewrite; design it out now. Unblocks SSE, large-file, chunked. |
| 7 | HIGH | **Postgres PROMOTED from Phase 4 → Phase 1/2 via libpq FFI** (native wire protocol stays a Phase-5+ optimization). Connection pool via channels lands with it. Forge is **not** pitched as enterprise-ready until Postgres works. SQLite-only = toy-tier for enterprise eval. |
| 5 | HIGH | **N+1 detection downgraded** from "world-first compile-time guarantee" to a **syntactic best-effort lint** (query-call inside for-over-query-result). Removed as a scorecard WIN dimension. Inter-procedural data-flow proof is intractable; don't claim it. |
| 8 | HIGH | **Scorecard PLAN column split** into **PLAN-TRACTABLE** (Phase 1–2, depends only on shipped/near mechanisms) vs **PLAN-SPECULATIVE** (Phase 4+, depends on unsolved compiler work). Do not present a speculative WIN as equivalent to a shipped Spring feature. Honest near-term target ≈ **9–11 WIN**, not 18. |
| 14 | MED | **Arena escape-hatch designed BEFORE caching/sessions/pools.** Data sent to a long-lived cache/session process must be deep-copied out of the arena into an RC heap; **handle-typed values (FILE*, fd) cannot be deep-copied** — the connection pool holds handles in a long-lived, non-arena structure. The atomic-RC half of the dual-path is a hard prerequisite for those features. |
| 13 | MED | **Manual versioned migrations first** (Flyway/Liquibase-style). Auto-generation from model-diff is a *later enhancement* with acknowledged unsolved rename / data-migration problems — not a core promise. |
| 11 | MED | **WASM frontend (Crown Jewel 3) is OFF the "beat Spring" critical path.** Spring has no WASM frontend either — beating Spring does not require one. It is a separate multi-year R&D track (full DOM bindings = an entire frontend framework from scratch). **LiveView-style server-driven UI (no client WASM) is the achievable real-time story.** |
| 10 | HIGH | **Phase 0 re-estimated at 6–10+ iterations** (the type-id header is a value-model change; struct-JSON was attempted iter-31–34 and reverted). Each prerequisite is **independently gated with a fallback**, never bundled. |
| 9 | HIGH | **ADOPTION TRACK added, running parallel from Phase 2:** getting-started tutorial, Spring/Django migration guide, beginner-grade error messages, real example apps, finding early adopters. Technical superiority without adoption is how OCaml/Nim/Crystal stayed niche. The one permanent scorecard LOSE (ecosystem maturity) is won by years + users, not code. |

## Revised Phase 0 (the immediate work, post-corrections)

0a. **Keystone — runtime type-id header** (struct metadata table + `json/show/==` recover
shape through `any`; subsumes `from_json`). Value-model change → reconverge + GATE 4/5.
*Fallback if perf regresses >5%: header only on structs that escape to `any` (escape
analysis already exists).*
0b. **Cross-import extern resolution** (forge → sqlitex externs). *Fallback: inline sqlitex.*
0c. **`query_as<T>` let-site specialization sub-track** (reuses 0a metadata).
0d. **HTTP keep-alive + streaming-capable Response** (arena × persistent-conn designed).
0e. **Multi-carrier (N>1) stabilization** — gated as a prerequisite for throughput claims
(may run parallel; not blocking the typed DX of 0a–0c).

Each is independently gated (edit → precheck → gen4 smoke → reconverge gen5.ll==gen6.ll →
432 regression both modes → ASAN → green_scale → commit). Soundness-first: a single
UAF/double-free is a hard revert.

**Bottom line:** the moats justify building Forge; the corrections make the plan survivable.
Forge becomes genuinely usable for real apps around the *corrected* Phase 3 (typed data +
Postgres + sessions/auth + validation + OpenAPI), not "8 phases from beating Spring." It
beats Spring on the structural axes from day one and earns the rest over years.
