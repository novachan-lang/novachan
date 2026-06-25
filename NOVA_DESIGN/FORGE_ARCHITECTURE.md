> ⚠️ **SUPERSEDED — 2026-06-25. Archived for history; do not plan from this file.** The canonical Forge docs are **[FORGE_STATUS.md](FORGE_STATUS.md)** (what/why) and **[FORGE_BUILD_PLAN.md](FORGE_BUILD_PLAN.md)** (how/when). Everything actionable here has been reconciled into those two against the real `forge.nova` source + all tests.

---

# FORGE ARCHITECTURE — Complete Design & Project Structure

**Date:** 2026-06-04
**Status:** Canonical architecture for NOVA's web framework (planning — no code yet)
**Companion to:** [FORGE_MASTER_PLAN.md](FORGE_MASTER_PLAN.md) (build sequence + competitive feature anatomy)
**Basis:** Exhaustive verified inventories of Django 5.x/6.0, Spring Boot 3.x/4.0, the Go web ecosystem, Rails 8, Phoenix, Laravel 12, ASP.NET Core 10, FastAPI.

---

## 1. The Governing Thesis — Why Forge Beats All Of Them

Every modern framework's signature win is the same idea: **derive behavior from a single source of truth** instead of forcing the developer to declare the same fact in 3–4 places. Define a model once → get the schema, the API, the validation, the docs.

But every incumbent pays a **runtime tax** to do it:
- **FastAPI** derives validation + serialization + OpenAPI from types — via *runtime reflection* (per-request cost).
- **Spring** derives beans + config — via *runtime classpath scanning + reflection + proxies* (5s startup, 300MB RAM).
- **Rails** derives routes + tables + controllers — via *runtime naming-convention lookups* (Ruby interpreter cost).
- **Django** derives admin + migrations + forms from models — via *runtime introspection*.

**Forge derives all of it at COMPILE TIME, as zero-overhead native code.** NOVA's compiler already knows every type, every field, every relationship. So Forge generates the validators, serializers, OpenAPI spec, admin UI, migrations, and DI graph as compiled native code with **no runtime reflection, no startup scanning, no per-request derivation cost.**

> **One sentence that positions Forge above all five:** *Everything is derived from your types — at compile time, with zero runtime cost.*

This is not a feature. It is the single capability — compile-time derivation from types — expressed across the entire framework. It is the thing none of them can copy, because none of them have a genius compiler that owns the whole stack.

---

## 2. Design Principles (Each Earned From The Research)

1. **Single source of truth = the type.** A `type User` is the schema, the API contract, the validation rules, the admin UI, the serializer, and the docs — all derived, never re-declared. (Absorbs FastAPI/Pydantic; pushes it to compile time.)

2. **Compile-time over runtime, always.** Validators, serializers, the DI graph, the router, OpenAPI, SQL checking — all resolved at build time. Zero reflection. (Beats Spring's startup tax, FastAPI's per-request reflection.)

3. **Convention over configuration, inference over convention.** Rails infers from naming; NOVA infers from *types* — even less ceremony. `type User` → table `users`, endpoint shapes, admin — with zero config files. (Absorbs Rails CoC; the compiler makes it deeper.)

4. **Progressive disclosure: one-liner OR structured, same framework.** A one-line endpoint for a microservice; full structured handlers + middleware for a large app. (Absorbs ASP.NET's Minimal APIs ↔ MVC duality. Matches NOVA's core principle.)

5. **Enforced layer boundaries.** The domain layer (`core/`) *cannot import* the web layer (`web/`) — the compiler rejects it. (Absorbs Phoenix Contexts; turns a convention into a compile-time guarantee — innovation Phoenix only enforces by discipline.)

6. **Keep Go's deployment wins, non-negotiable.** Single static binary, embedded assets, sub-10ms startup, low memory, cross-compile. Forge must never become a heavy runtime. (The half of Forge's thesis that makes it deployable everywhere.)

7. **Secure by default, opt out explicitly.** XSS escaping, SQL parameterization, CSRF, security headers are ON by default. (Absorbs Django's secure-by-default; SQL injection becomes *impossible* via compile-time validation.)

8. **The process model is the concurrency, fault-tolerance, AND real-time model — one model.** A request handler, a background job, a per-user live UI, a WebSocket — all are NOVA Processes communicating over Channels. (This is Phoenix's deepest win, and it's *native* to NOVA, not bolted on.)

9. **Explicit effects, not hidden magic.** No Django-style implicit signals firing invisible side effects. Business logic lives in explicit service functions. (Fixes Django's most-criticized footgun.)

10. **One-word error handling.** No Go `if err != nil` sprawl, no exception soup. NOVA's `?` / `else` propagation. (Fixes Go's #1 complaint at the language level.)

---

## 3. The Three Crown Jewels — Where Forge Decisively Wins

The research surfaced three features where NOVA has a structural, unfair advantage. These are Forge's headline differentiators — lead with them.

### Crown Jewel 1 — Zero-Config Auto-Admin, Rendered Real-Time

**The gap:** Django's auto-admin (a full CRUD UI generated from models with zero per-model code) is its single most-loved feature. The research found that **the modern frameworks REGRESSED on it** — Laravel (Filament/Nova) and Rails (ActiveAdmin) require hand-declaring every admin resource. *None of the five modern frameworks matches Django's true zero-config auto-admin.*

**Forge's win:** The compiler already knows every model's fields, types, and relationships. So Forge generates a **complete admin panel with zero declaration** — like Django — but rendered as a **server-driven real-time UI** (Crown Jewel 2) that Django's admin isn't. *Django's best feature + Phoenix's real-time UI + zero config, generated by the compiler.* This is a layup that no one else can play.

### Crown Jewel 2 — Server-Driven Real-Time UI (the LiveView model, native-speed)

**The reference:** Phoenix LiveView — a stateful server process per connected user, holding UI state; the template is compile-split into static and dynamic parts so only changed dynamic values cross the WebSocket; the client patches the DOM. Full interactivity, near-zero hand-written JS, crash-isolated per user.

**Forge's win:** This maps **1:1 onto NOVA Processes + Channels.** A live view per user IS a NOVA Process holding state, communicating over a Channel (the WebSocket). The static/dynamic template split is done by NOVA's compiler. And NOVA delivers it at **compiled-native speed the BEAM cannot reach**, with **per-user crash isolation** from the process model. The concurrency model, the fault-tolerance model, and the real-time UI model are *the same model* — which is exactly NOVA's thesis.

### Crown Jewel 3 — WASM Frontend, Compiler-Chosen Server/Client Execution

**The reference:** Blazor — C# compiled to WASM, with per-component render modes (Static SSR / Interactive Server / Interactive WASM / **Auto** — starts server-side, transparently moves to client WASM). Proves "same language front and back" ships and is loved. Its weakness: multi-MB .NET-runtime-in-WASM download.

**Forge's win:** This is literally NOVA's stated vision ("one language, runs anywhere"). NOVA's compiler *already* chooses targets (CPU/GPU/WASM), so per-component "server-push vs client-WASM" is a natural extension — and **NOVA-native WASM is far smaller/faster than Blazor's runtime-laden bundles** (no heavy managed runtime to ship). The same UI component compiles to server-push *or* client-WASM, compiler-chosen, with an Auto bridge — beating Blazor on bundle size and LiveView on offline/client capability. Type-checked across the client-server boundary because both sides are the same language.

---

## 4. The Forge Project Structure (What `nova forge new myapp` Generates)

This is the structure a developer's app has on disk. It resolves the central tension from the research: **Rails/Phoenix opinionated structure** (so scaffolding + conventions work) **+ FastAPI type-derivation** (so types drive everything) — the two halves no single framework unites today. The skeleton is Phoenix's **core/web split, but compiler-enforced.**

```
myapp/
├── nova.toml                  # NOVA package manifest (deps, build) — already exists in NOVA
├── forge.toml                 # Forge config (server, db, env mapping) — TYPED, validated at startup
├── .env                       # secrets (gitignored) → loaded into the typed Config
├── .env.example               # committed template
├── .gitignore                 # generated
├── README.md                  # generated
│
├── src/
│   ├── main.nova              # ENTRY POINT — the composition root: forge.app(...)
│   │
│   ├── core/                  # ── DOMAIN LAYER ── web-unaware, pure business logic
│   │   │                      #    COMPILER-ENFORCED: core/ CANNOT import web/
│   │   ├── models/            # data models = THE single source of truth
│   │   │   ├── user.nova      #    type User {...} → DB table + admin + API + validation + docs
│   │   │   ├── post.nova
│   │   │   └── ...
│   │   ├── services/          # business logic, the public API of each domain (Phoenix contexts)
│   │   │   ├── accounts.nova  #    accounts.create_user(...) — handlers call THIS, never models directly
│   │   │   └── ...
│   │   ├── queries/           # read-side query functions (selectors — keep handlers thin)
│   │   └── jobs/              # background jobs (each is a spawned Process)
│   │
│   ├── web/                   # ── DELIVERY LAYER ── HTTP / WebSocket / UI
│   │   ├── routes.nova        # route table (or convention-based auto-discovery)
│   │   ├── handlers/          # request handlers (controllers) — thin: parse → call service → respond
│   │   │   ├── users.nova
│   │   │   └── ...
│   │   ├── middleware/        # app-specific middleware (built-ins ship with Forge)
│   │   ├── live/              # server-driven real-time UI components (Crown Jewel 2)
│   │   │   ├── dashboard.nova
│   │   │   └── ...
│   │   ├── components/        # reusable UI components (compile to server-push OR WASM)
│   │   └── api/               # API handlers (REST + GraphQL), versioned
│   │
│   └── config.nova           # type Config {...} — typed, validated configuration (no flat settings.py)
│
├── db/
│   ├── migrations/           # AUTO-GENERATED by diffing model definitions between versions
│   └── seeds.nova            # seed/fixture data
│
├── assets/                   # source static files (css/js/img) → fingerprinted + compressed at build
│
├── public/                   # served static root; compiled WASM frontend lands here
│
├── tests/
│   ├── core/                 # domain/service tests
│   └── web/                  # handler + integration tests via in-process test client (no socket)
│
└── build/                    # gitignored
    └── myapp                 # ── SINGLE STATIC BINARY ── app + framework + assets + WASM, embedded
```

**Why this structure (the reasoning behind every choice):**

- **`core/` vs `web/`, compiler-enforced.** Phoenix proved bounded contexts keep large apps maintainable, but enforces the boundary only by convention. Forge makes `core/` importing `web/` a **compile error** — turning Phoenix's discipline into a guarantee. The domain never depends on the delivery mechanism, so the same business logic serves HTTP, WebSocket, CLI, or a job.

- **`models/` is the single source of truth.** Django's deepest win: models feed migrations + admin + forms + serializers. Forge extends it — a `type User` feeds the table, the migration, the admin UI, the API contract, the validator, the serializer, and the OpenAPI docs, all compiler-derived.

- **`services/` (contexts) is the missing layer Django never had.** Django's "fat models/fat views" has no business-logic home, so every serious team retrofits a service layer (the HackSoft styleguide exists for exactly this). Forge ships it as the default architecture: handlers call services; services own the logic; models stay data.

- **`config.nova` is typed, not a flat file.** Django's `settings.py` sprawl is its #1 complaint. Forge's config is a typed NOVA struct, validated at startup — a missing/mistyped value is a startup error with a clear message, not a `None` that crashes on request #1000. (Absorbs ASP.NET's Options pattern.)

- **`db/migrations/` is auto-generated by model diff.** (Absorbs EF Core / Rails / Ecto.) The compiler diffs typed model definitions between versions and generates reversible up/down migrations — and flags data-loss-dangerous migrations at compile time.

- **`build/myapp` is ONE binary.** (Keeps Go's killer win.) App + framework + static assets + the compiled WASM frontend, all embedded. Deploy = copy one file. No JVM, no virtualenv, no node_modules, no Docker required.

**Progressive disclosure:** a tiny service can collapse this to a single `main.nova` with inline one-line endpoints (ASP.NET Minimal-API style). The full structure appears only when the app grows. The beginner and the expert use the same framework at different depths.

---

## 5. The Forge Framework Internal Structure (How Forge Itself Is Organized)

Forge is a NOVA package. Its own source is organized by subsystem, each a NOVA module (file = module, `_prefix` = private):

```
forge/
├── http/            # HTTP core
│   ├── server       # accept loop; each connection is a Process (~512 bytes)
│   ├── request      # ZERO-COPY parsing (header values are fat-string slices into the buffer)
│   ├── response     # building, streaming-by-default
│   ├── parser       # HTTP/1.1 → HTTP/2 → HTTP/3 (QUIC); smuggling-safe
│   ├── multipart    # multipart/form-data, file uploads
│   ├── cookies      # signed/encrypted cookies
│   └── compress     # gzip / brotli / zstd
├── router/          # COMPILE-TIME trie router
│   ├── trie         # perfect-hash dispatch generated at compile time
│   ├── params       # typed path params (compile-checked)
│   └── reverse      # reverse URL generation — url_for to a nonexistent route = COMPILE ERROR
├── middleware/      # built-in, ordered, compile-inlined chain
│   ├── logging  cors  csrf  ratelimit  request_id  security_headers  compress  recovery
├── db/              # data layer
│   ├── pool         # connection pool = a Channel of connection Processes (backpressure free)
│   ├── query        # type-safe query builder (LINQ/Ecto-class, compiler-checked)
│   ├── orm          # model↔row mapping, compile-time derived (no reflection)
│   ├── sql          # COMPILE-TIME SQL VALIDATION against the live schema
│   ├── migrate      # model-diff migration engine, reversible, data-loss-aware
│   ├── tx           # transactions, savepoints, on_commit hooks
│   └── drivers/     # sqlite (FFI, first) → postgres → mysql
├── derive/          # ★ the thesis engine: compile-time derivation from types
│   ├── validate     # validators generated from type constraints
│   ├── serialize    # JSON/binary (de)serializers generated from types
│   ├── openapi      # OpenAPI 3 spec generated from route signatures
│   └── client       # typed client SDK generation (TS/NOVA) from the same types
├── auth/            # authentication & authorization
│   ├── session  jwt  oauth (OIDC)  apikey
│   ├── password     # Argon2id (via Sentinel), constant-time
│   ├── rbac         # roles/permissions/policies as compiled functions (not string annotations)
│   └── csrf
├── live/            # ★ Crown Jewel 2 — server-driven real-time UI
│   ├── socket       # per-user Process holding UI state
│   ├── diff         # compile-split static/dynamic template → minimal wire diff
│   ├── stream       # keyed streams for large collections (no server-memory bloat)
│   └── upload       # direct-to-handler live uploads
├── wasm/            # ★ Crown Jewel 3 — WASM frontend
│   ├── compile      # NOVA component → WASM (lean, no heavy runtime)
│   ├── hydrate      # SSR + hydration
│   └── rendermode   # per-component server-push / client-WASM / auto bridge
├── admin/           # ★ Crown Jewel 1 — zero-config auto-admin from models, real-time
├── jobs/            # background work
│   ├── queue        # durable channel; a job is a spawned Process
│   ├── scheduler    # cron / interval
│   └── dashboard    # Horizon-style ops UI (throughput, retries, failures)
├── realtime/        # ws (WebSocket as Channel) · pubsub (cluster-wide) · presence (who's online)
├── cache/           # in-process (sub-µs) + distributed (Redis via Mesh); HTTP caching (ETag)
├── config/          # typed config loading, env layering, validation, secrets
├── observe/         # structured logging · metrics (Prometheus) · tracing (follows the channel graph)
├── mail/            # SMTP + templated emails (async send = spawned Process)
├── storage/         # uniform file storage (local dev / S3 / GCS prod, swap by config)
├── i18n/            # translations (missing key for a locale = compile warning), locale formatting
├── validate/        # (public surface of derive/validate) form/request validation
├── test/            # in-process test client (calls handlers directly, full native speed)
└── cli/             # the `nova forge` command surface (see §7)
```

**Key internal architecture decisions (the reasoning):**

- **Each connection is a Process (~512 bytes).** Goroutine-per-request is Go's bar; NOVA matches the synchronous-looking style AND makes handlers **data-race-impossible** by construction (Go needs `-race` + manual mutexes). 1M concurrent connections = ~512MB.
- **Zero-copy parsing via fat strings.** Header names/values are slices into the single request buffer — no per-header allocation. This is why nginx/h2o are fast; Forge does it natively.
- **The router is a compile-time trie.** Routes are known at compile time → perfect-hash dispatch, O(path-length), zero runtime route-table lookup. Reverse routing is compile-checked.
- **The middleware chain inlines.** Middlewares are NOVA functions composed at compile time — the whole chain flattens into one function (no per-middleware `next()` closure allocation like Express).
- **`derive/` is the thesis made concrete.** One module family generates validators, serializers, OpenAPI, and clients from types — at compile time. This is the engine behind "everything from your types."
- **The connection pool is a Channel.** Backpressure, supervision, and auto-reconnect come free from the process/channel model.
- **Tracing follows the channel graph.** Because all communication is channels, a request can be traced across processes, machines, and into Cortex/Pulse calls automatically — no manual span instrumentation.

---

## 6. Complete Subsystem Definition — What We Build, From Whom, The NOVA Way

Every subsystem, what it must provide, which framework's idea we absorb, and how NOVA does it better. Priority: **P0** = needed for a real app · **P1** = needed for production · **P2** = needed for completeness · **P3** = future.

| # | Subsystem | What it provides | Best idea absorbed from | How Forge does it BETTER | Priority |
|---|---|---|---|---|---|
| 1 | **HTTP core** | HTTP/1.1→2→3, TLS, WS, multipart, cookies, compression, streaming, graceful shutdown | Go net/http quality | Zero-copy parse; HTTP/3 default; smuggling-safe; inlined into handler | P0 |
| 2 | **Routing** | path/params/wildcards, groups, method match, named+reverse routes | Rails resources + chi radix tree | Compile-time trie; reverse routing compile-checked | P0 |
| 3 | **Middleware** | ordered chain, before/after, error mw, built-ins (CORS/CSRF/ratelimit/logging/headers) | ASP.NET explicit pipeline | Compile-inlined chain; recovery via process isolation | P0 |
| 4 | **Config** | env layering, typed binding, validation, secrets | ASP.NET Options + Rails credentials | Typed struct, validated at startup; no flat settings sprawl | P0 |
| 5 | **Data layer / ORM** | models, relations, query builder, eager loading, N+1 prevention, transactions | Eloquent ergonomics + EF/Ecto type-safety | **Compile-time SQL validation**; N+1 detected at compile time; changesets+Multi | P0 |
| 6 | **Migrations** | versioned, diff-based, reversible, data migrations | EF Core / Rails / Ecto | Diff typed models at compile time; flag data-loss migrations | P0 |
| 7 | **Validation** | type-driven, composable, field-level errors, form requests | FastAPI/Pydantic + Laravel Form Requests | Generated from type constraints at compile time; zero reflection | P0 |
| 8 | **Serialization** | JSON (de)ser, content negotiation, typed request/response | FastAPI type-driven | Compile-time generated codecs; no runtime reflection | P0 |
| 9 | **Auto API docs** | OpenAPI 3 + interactive UI + typed client SDKs | FastAPI `/docs` | Generated from inferred types at **compile time**; can't drift; emits client SDKs | P1 |
| 10 | **Auth / authz** | sessions, JWT, OAuth2/OIDC, password hashing, RBAC, CSRF, MFA hooks | Spring Security power + Laravel Sanctum DX | Argon2id (Sentinel); policies = compiled functions; capability via channel handles | P1 |
| 11 | **Real-time UI (Live)** | stateful server UI, minimal diffs, streams, presence | Phoenix LiveView | Per-user Process; compiler static/dynamic split; native speed; crash-isolated | P1 ★ |
| 12 | **WASM frontend** | components, SSR+hydration, per-component server/client render | Blazor render modes | Compiler-chosen target; lean WASM (no heavy runtime); type-checked client↔server | P1 ★ |
| 13 | **Auto-admin** | zero-config CRUD UI from models | Django admin | Zero declaration + real-time UI + compiler-generated | P1 ★ |
| 14 | **Background jobs** | queues, scheduling, retries, dead-letter, ops dashboard | Laravel Horizon | A job is a spawned Process; queue is a durable Channel; no external broker | P1 |
| 15 | **Real-time infra** | WebSocket, PubSub (cluster-wide), Presence (CRDT) | Phoenix Channels/PubSub/Presence | Native channels; cluster PubSub via Mesh; no Redis needed | P1 |
| 16 | **Caching** | in-proc, distributed, HTTP caching, fragment caching | Spring abstraction + Go ristretto | In-proc sub-µs; distributed via Mesh; one API | P2 |
| 17 | **Observability** | structured logs, metrics, tracing, health checks | Spring Actuator + OTel | Tracing follows channel graph automatically; health/metrics built in | P2 |
| 18 | **Security** | CORS, CSRF, XSS auto-escape, SQLi-proof, headers, rate limit | Django secure-by-default | SQLi *impossible* (compile-validated); escaping opt-out; Sentinel integration | P0/P1 |
| 19 | **Testing** | in-process test client, fixtures/factories, mocking, assertions | Django test client + Go testing + Laravel factories | In-process (no socket); full-stack spins in ms; built-in mocking | P1 |
| 20 | **Dev experience** | scaffolding, generators, hot reload, dev error pages, REPL | Rails scaffold + Laravel artisan | `nova forge new` → working full-stack app in 30s; type-aware generators | P1 |
| 21 | **Email/notifications** | SMTP, templated, async send, push/SMS hooks | Laravel/Rails mailers | Async send = spawned Process; reuses template engine | P2 |
| 22 | **File storage** | local + S3/GCS, uploads, image processing | Laravel storage + Django files | Uniform interface, swap by config; streaming uploads | P2 |
| 23 | **i18n / l10n** | translations, locale detect, pluralization, formatting | Django/Rails i18n | Missing translation key = compile warning | P2 |
| 24 | **GraphQL / gRPC** | schema-first or type-derived GraphQL; gRPC services | — (new) | Schema derived from NOVA types at compile time | P3 |
| 25 | **Service layer / contexts** | bounded-context organization, enforced boundaries, scope threading | Phoenix Contexts | Boundaries **compiler-enforced**; Scope value auto-threaded | P0 |

★ = the three Crown Jewels (§3).

---

## 7. The `nova forge` CLI — The Missing `rails new`

Go's #1 structural complaint is "no `rails new`, every team reinvents structure." Forge ships a cohesive command surface (Rails/Laravel/Phoenix-class), which Go projects must hand-build with cobra:

```
nova forge new <app>              # scaffold a full-stack app (backend + WASM frontend + DB) — works in 30s
nova forge generate model <Name>  # model + migration + admin registration
nova forge generate scaffold <N>  # model + migration + handlers + live UI + tests (Rails scaffold)
nova forge generate handler <N>   # a request handler
nova forge generate live <N>      # a server-driven real-time UI component
nova forge generate service <N>   # a domain service (context)
nova forge migrate                # apply pending migrations
nova forge migrate --make         # auto-generate a migration from model diffs
nova forge migrate --rollback     # reverse the last migration
nova forge routes                 # list all routes (with reverse-route names)
nova forge serve                  # dev server with hot reload
nova forge console                # REPL with app + DB context loaded
nova forge test                   # run tests via in-process client
nova forge build                  # produce the single static binary (assets + WASM embedded)
nova forge deploy                 # build + deploy (via Ops)
```

Scaffolding goes **further than Rails/Laravel**: because the compiler infers types, generated code carries *fewer annotations*, and a scaffold can target multiple deploy surfaces (server, WASM, edge) from one spec.

---

## 8. The Request Lifecycle (End To End)

How a request flows through Forge — the architectural contract:

```
1. TCP accept            → http/server spawns a connection Process (~512 bytes, data-race-free)
2. Parse (zero-copy)     → http/parser builds Request; header values are slices into the buffer
3. Middleware (inlined)  → the compile-flattened chain runs: request_id → logging → security
                           headers → cors → csrf → ratelimit → recovery (panic caught at process boundary)
4. Route (compile-trie)  → router/trie perfect-hash dispatch → handler + typed path params
5. Validate (derived)    → derive/validate rejects bad input with field-level errors BEFORE handler runs
6. Handler (thin)        → web/handlers: parse typed request → call core/services → build response
   └─ Service (core)     → business logic; calls db (compile-validated SQL); may spawn jobs
7. Serialize (derived)   → derive/serialize renders the typed response to JSON (no reflection)
8. Response (streamed)   → middleware unwinds (compression, headers); response streams out
9. Trace (automatic)     → the whole path is traced via the channel graph, into any Cortex/Pulse calls
```

Every step that says "derived," "compile-trie," or "inlined" is work the incumbents do at runtime that Forge does at compile time.

---

## 9. What's Missing Today (The Honest Foundation)

Forge cannot be more solid than the language under it. From the verified core audit (CORE_COMPLETENESS.md, ~61% done), these gaps **block** Forge and must be closed first (they are core-language work, which is why building Forge *drives* core completion):

| Gap | Blocks which subsystem | Status |
|---|---|---|
| Typed `Result<T,E>` error handling | All — clean error propagation everywhere | ✅ recently implemented (verify) |
| File I/O completeness (streaming, binary) | Static serving, uploads, config | 🟡 partial |
| String formatting + full regex | Logging, templating, routing, validation | 🟡 partial |
| Concurrent `serve()` (currently single-threaded) | HTTP core under load | 🔴 must fix |
| Argon2id + constant-time compare | Auth password hashing | 🔴 (Sentinel) |
| Asset embedding (`go:embed`-equivalent) | Single-binary with assets + WASM | 🔴 needed |
| Compile-time DB schema access | Compile-time SQL validation (Crown of data layer) | 🔴 new capability |
| WASM I/O + DOM bindings | WASM frontend (Crown Jewel 3) | 🔴 (WASM compute works; I/O missing) |
| Unicode-correct strings | Templating, i18n, validation | 🟡 partial |

---

## 10. Future Roadmap (What We Add To Forge Over Time)

Explicitly tracked so nothing is "forgotten." Ordered by when it makes sense:

**v0.x (foundation → real app):** HTTP core hardening, compile-trie router, middleware, typed config, SQLite data layer + compile-time SQL validation, migrations, type-driven validation/serialization, the `nova forge` CLI + scaffolding.

**v1.0 (production):** Auth (sessions/JWT/OAuth/RBAC/Argon2), auto OpenAPI + client SDKs, the three Crown Jewels (auto-admin, LiveView-style real-time UI, WASM frontend), background jobs + dashboard, Postgres driver, observability, in-process test client, security hardening, battle-testing.

**v1.x (completeness):** caching (distributed via Mesh), email/storage/i18n, GraphQL (type-derived), gRPC, HTTP/3 default, presence/PubSub at cluster scale, fragment caching, hot-reload of compiled handlers.

**v2.x (frontier):** edge deployment (WASM to CDN nodes), full reactive component library, visual admin theming, multi-tenancy primitives, the Auto render-mode bridge (server↔WASM), distributed sessions, zero-downtime rolling deploy via Ops.

---

## 11. The Forge Scorecard (Design Targets vs The World)

| Capability | Spring | Django | Go | Rails | Phoenix | FastAPI | **Forge (design)** |
|---|---|---|---|---|---|---|---|
| Single binary | 🔴 | 🔴 | 🟢 | 🔴 | 🔴 | 🔴 | 🟢 **+ embedded WASM** |
| Startup | 🔴 5s | 🟡 1s | 🟢 5ms | 🟡 | 🟢 | 🟡 | 🟢 **<5ms** |
| Type-driven (valid+ser+docs) | 🟡 | 🔴 | 🔴 | 🔴 | 🟡 | 🟢 | 🟢 **compile-time, zero-reflection** |
| Compile-time SQL validation | 🔴 | 🔴 | 🟡 sqlc | 🔴 | 🟡 | 🔴 | 🟢 **native** |
| Auto-admin (zero-config) | 🔴 | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🟢 **+ real-time** |
| Server-driven real-time UI | 🟡 | 🔴 | 🔴 | 🟢 Hotwire | 🟢 LiveView | 🔴 | 🟢 **native-speed processes** |
| WASM frontend (same lang) | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🟢 **lean, compiler-chosen** |
| Background jobs (no broker) | 🟡 | 🟡 | 🔴 | 🟡 | 🟢 | 🔴 | 🟢 **spawn = job** |
| First-class DI | 🟢 | 🔴 | 🔴 | 🟡 | 🟡 | 🟢 | 🟢 **compile-time, zero-overhead** |
| Enforced layer boundaries | 🔴 | 🔴 | 🔴 | 🔴 | 🟡 convention | 🔴 | 🟢 **compiler-enforced** |
| Scaffolding / `new` | 🟡 | 🟡 | 🔴 | 🟢 | 🟢 | 🔴 | 🟢 **full-stack in 30s** |
| Ecosystem maturity | 🟢 | 🟢 | 🟢 | 🟢 | 🟡 | 🟢 | 🔴 **zero — won by users, over years** |

Forge is designed to win or tie every *architectural* row. The last row — ecosystem maturity — is the honest gap, and it's won by users and time, not code. Which is why the plan ends in battle-testing and getting the first real developers (FORGE_MASTER_PLAN.md §F7), not in more features.

---

## 12. The One-Paragraph Summary

Forge is a full-stack web framework where **your types are the single source of truth** — and unlike FastAPI, Spring, Rails, or Django, which derive behavior from types at *runtime* (reflection, scanning, convention lookups), **Forge derives everything at compile time as zero-overhead native code**: the router, the validators, the serializers, the OpenAPI docs, the DI graph, the migrations, the SQL checking, the admin panel. It keeps Go's single-binary, fast-startup, low-memory deployment; absorbs Django's auto-admin and secure-by-default, Spring's DI and Actuator, Rails' convention-and-scaffolding, Phoenix's contexts and LiveView, Laravel's queues and DX, FastAPI's type-derivation, and ASP.NET's explicit pipeline and Blazor render modes — and does each one *better* because the compiler owns the whole stack. Its three crown jewels — zero-config real-time auto-admin, native-speed server-driven UI, and lean compiler-chosen WASM frontend — are features no competitor can copy, because none of them have NOVA's Values/Processes/Channels model and genius compiler underneath. **One developer, one language, one binary — backend, frontend, database, real-time, jobs — and the developer never leaves.**
