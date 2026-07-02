# FORGE — Comprehensive Feature Audit vs Spring Boot / Django / Rails / Phoenix / NestJS

> **Why this doc exists (2026-07-03).** The prior "Forge is essentially complete" framing was WRONG. Forge
> has the *plumbing* — HTTP/HTTP2/gRPC/GraphQL, routing, middleware, basic typed CRUD, real-time, OTP,
> resilience, observability. It is MISSING the *deep, high-level, developer-productivity* features that make
> the incumbents "batteries-included": **dependency injection, declarative cross-cutting concerns (tx/cache/
> retry/schedule), configuration + profiles, repository derived-queries, an application event bus, form
> objects, a template engine, i18n, a testing harness, method-level security, entity auditing.** This audit
> enumerates the FULL competitive surface from first-hand knowledge of each framework and marks Forge's
> honest status. The prioritized gaps become new sprints (S14–S18) in FORGE_BUILD_PLAN.md.
>
> Legend: **✅ HAVE** · **🟡 PARTIAL** · **❌ MISSING**  ·  Priority: **P0** (defining/blocking) · **P1** (high) · **P2** (medium)

---

## A. Dependency Injection / IoC — *Spring's defining feature*  →  Forge ❌ (P0)

| Capability | Spring | Django/Rails/Phoenix | Forge |
|---|---|---|---|
| IoC container / bean registry | core | (convention over DI) | ❌ |
| Constructor/field autowiring | ✅ | — | ❌ |
| Bean scopes: singleton/prototype/**request**/session | ✅ | — | ❌ |
| Qualifiers / @Primary / @Conditional | ✅ | — | ❌ |
| **Profiles** (@Profile dev/test/prod) | ✅ | Django settings-per-env / Rails env | ❌ |
| Lazy init, `@PostConstruct`/`@PreDestroy` | ✅ | — | 🟡 (OTP lifecycle) |

**NOVA angle:** the process model favors *explicit passing* over hidden magic, and NOVA should NOT copy Spring's reflective auto-wiring wholesale (it fights "no hidden costs"). BUT the *ergonomic* win DI provides — "declare a component once, get it wired + request-scoped everywhere" — is real. The NOVA-shaped answer: a **lightweight typed service registry + a request-scoped context dict** (`ctx`) threaded through handlers, plus **profiles**. This is a P0 gap because every large app leans on it.

---

## B. Cross-cutting concerns / AOP (declarative)  →  Forge 🟡 (P0/P1)

| Capability | Spring | Forge status |
|---|---|---|
| **@Transactional** (propagation REQUIRED/REQUIRES_NEW/NESTED, isolation, rollback-for, readOnly) | ✅ | 🟡 `with_tx(pool, fn)` — no propagation/nesting/declarative; `with tx{}` sugar BLOCKED (`with` taken) |
| **@Cacheable / @CacheEvict / @CachePut** (method-result cache, key SpEL, conditional) | ✅ | 🟡 `forge_cache` actor exists; NO method-result decorator |
| **@Retryable / @Recover** (declarative retry around a call) | ✅ | 🟡 `forge_retry` policy exists; not a decorator around a fn |
| **@Async** (declarative off-thread) | ✅ | 🟡 `spawn` primitive; no declarative wrapper |
| **@Scheduled** (cron / fixedRate / fixedDelay) | ✅ | 🟡 jobs exist; declarative cron unclear |
| Method interceptors / around-advice / pointcuts | ✅ | ❌ |

**NOVA-shaped answer:** since a channel/fn IS the unit, provide **higher-order decorators** — `tx(pool, fn)`, `cached(cache, key, fn)`, `retried(policy, fn)`, `scheduled(cron, fn)`, `timed(ms, fn)` — that WRAP a service fn. One impl, every call site. This is the "resilience zoo = decorators over a channel" thesis extended to tx/cache/schedule. **P0** for tx-with-propagation + method cache.

---

## C. Configuration & Profiles  →  Forge 🟡 (P0)

| Capability | Spring | Django/Rails | Forge |
|---|---|---|---|
| Externalized config (env + file + yaml/props) | ✅ | settings.py / config/*.yml | 🟡 `env()` only |
| **Profiles** (dev/test/prod overlays) | ✅ | ✅ | ❌ |
| Typed config binding (`@ConfigurationProperties` → struct) | ✅ | — | ❌ |
| Property precedence / multiple sources | ✅ | ✅ | ❌ |
| Config refresh / Spring Cloud Config | ✅ | — | ❌ |
| Secrets (vault / encrypted) | ✅ | ✅ | ❌ |

**Answer:** `forge_config` — load `env` + a `nova.toml`/`config.<profile>.toml`, merge by profile precedence, **bind into a typed struct** (RTTI). **P0** (foundational; everything reads config).

---

## D. Data / ORM depth  →  Forge 🟡 (P1)

| Capability | Spring Data / Django ORM / ActiveRecord / Ecto | Forge |
|---|---|---|
| Typed CRUD + relations | ✅ | ✅ (`forge_orm`) |
| Connection pool | ✅ | ✅ |
| **Migrations** (versioned files, up/down, history table) | ✅ | 🟡 struct-diff add-only; no versioned files/rename/drop |
| Composable/typed query DSL | ✅ | 🟡 fragments + fluent builder |
| **Derived query methods** (`findByNameAndAgeGreaterThan`) | ✅ Spring / Django `filter()` | ❌ |
| Aggregation / group-by / window (F/Q, having) | ✅ | 🟡 count/exists/agg only |
| Eager/lazy loading + **N+1 detection** | ✅ | ❌ (DataLoader for GraphQL only) |
| **Optimistic locking** (`@Version`) | ✅ | 🟡 If-Match at HTTP only |
| Pessimistic locking (SELECT FOR UPDATE) | ✅ | ❌ |
| **Soft deletes** (`@SQLDelete` / paranoia / Ecto) | ✅ | ❌ |
| **Entity auditing** (`@CreatedDate/@CreatedBy/@LastModified`) | ✅ | ❌ |
| Multiple datasources / read replicas / sharding | ✅ | ❌ |
| DB seeding / fixtures | ✅ | ❌ |
| Full-text search | ✅ (PG) | ❌ |
| Change data capture / events on save (signals/callbacks) | ✅ Django signals / AR callbacks | ❌ |

**P1:** derived queries, entity auditing (created/updated timestamps + user), soft deletes, optimistic `@version`, versioned migration files, model callbacks/signals, seeding.

---

## E. Web layer depth  →  Forge 🟡 (P1/P2)

| Capability | Incumbents | Forge |
|---|---|---|
| Routing / middleware / content-negotiation | ✅ | ✅ |
| **Form objects** (Django `Form/ModelForm`: fields, widgets, per-field errors, re-render, CSRF) | ✅ | 🟡 `form_as`/`validate`; no form object w/ widget+error-render round-trip |
| Multipart file upload | ✅ | ✅ |
| **Global exception handlers** (`@ControllerAdvice` → error→response mapping registry) | ✅ | 🟡 `problem+json`; no global handler registry |
| **HATEOAS** / hypermedia links | ✅ (Spring HATEOAS) | ❌ |
| Pagination/sorting | ✅ | ✅ (cursor) |
| Interceptors (pre/post/around handler) | ✅ | 🟡 middleware (pre/post only) |
| Reactive/streaming (WebFlux Mono/Flux) | ✅ | 🟡 channels/SSE |
| Server-driven UI (Hotwire/Turbo/LiveView) | Rails/Phoenix | 🟡 LiveView |
| Flash messages | ✅ | ✅ |

**P1:** form objects (fields+widgets+errors), global exception-handler registry. **P2:** HATEOAS.

---

## F. Security depth  →  Forge 🟡 (P1)

| Capability | Spring Security / Django auth | Forge |
|---|---|---|
| Auth: form/basic/JWT/OAuth2/sessions/CSRF | ✅ | ✅ |
| RBAC (roles) | ✅ | ✅ |
| **Method-level security** (`@PreAuthorize`/`@Secured` on a fn) | ✅ | ❌ |
| **Object/row-level ACL** | ✅ | 🟡 `admin_can` only |
| OIDC / SAML / LDAP | ✅ | ❌ |
| Password policy / account lockout / brute-force | ✅ | ❌ |
| API keys / mutual-TLS auth | ✅ | 🟡 (mTLS needs ALPN) |
| Security headers / HSTS / clickjacking | ✅ | ✅ |
| 2FA / TOTP | ✅ (starters) | ❌ |

**P1:** method-level security guard, account lockout/brute-force, TOTP 2FA. **P2:** OIDC.

---

## G. Templating & Frontend  →  Forge 🟡/❌ (P1/P2)

| Capability | Thymeleaf/Django-templates/ERB/HEEx | Forge |
|---|---|---|
| HTML builders | — | ✅ (`forge_html`) |
| **Template engine** (layout inheritance, partials/includes, tags, filters, auto-escape) | ✅ | ❌ |
| Asset pipeline / bundling / fingerprinting | ✅ | ❌ |
| Rich text / CMS blocks | ✅ (ActionText/Wagtail) | ❌ |
| WASM frontend (shared structs) | — | 🟡 value-model runs; DOM pending |

**P1:** a template engine (layouts + partials + auto-escape + expression interpolation) — the thing every server-rendered app needs beyond raw builders.

---

## H. Messaging & Integration  →  Forge 🟡 (P1)

| Capability | Spring Integration/AMQP/Kafka, Rails ActiveJob | Forge |
|---|---|---|
| In-proc broker + DLQ + outbox + typed pub/consume | — | ✅ |
| NATS/Kafka/RabbitMQ transport | ✅ | ❌ (behind the same API — env-gated) |
| STOMP / WebSocket messaging routing | ✅ | 🟡 WS+hub, no STOMP |
| **Application event bus** (domain events + `@EventListener`, sync+async, transactional events) | ✅ | ❌ |
| EIP patterns (router/filter/aggregator/splitter) | ✅ | ❌ |

**P1:** a typed application **event bus** (publish an event → typed listeners, sync + async + after-commit). **P2:** a real broker transport.

---

## I. Background / Scheduling / Batch  →  Forge 🟡 (P1/P2)

| Capability | Spring @Scheduled/Batch, Sidekiq/Oban/Celery | Forge |
|---|---|---|
| Background jobs (enqueue/worker) | ✅ | ✅ (`forge_jobs`) |
| **Cron scheduling** (declarative) | ✅ | 🟡 |
| **Batch / chunk ETL** (reader→processor→writer, restart/skip) | ✅ (Spring Batch) | ❌ |
| Retry/backoff on jobs, unique jobs, priorities | ✅ | 🟡 |
| Job dashboard | ✅ (Sidekiq web) | ❌ |

**P1:** declarative cron + a batch/chunk processor. **P2:** job dashboard.

---

## J. Observability & Ops  →  Forge 🟡 (P2)

| Capability | Spring Actuator / Micrometer | Forge |
|---|---|---|
| Metrics / health / readiness / liveness | ✅ | ✅ |
| Distributed tracing propagation | ✅ | ✅ (W3C) |
| **Actuator endpoints** (env, beans, mappings, loggers, threaddump, heapdump, httptrace) | ✅ | 🟡 metrics/health only |
| Runtime log-level change | ✅ | ❌ |
| Audit events | ✅ | 🟡 admin audit |

**P2:** an actuator-style introspection endpoint set (routes/config/loggers/build-info).

---

## K. Testing  →  Forge 🟡 (P1)

| Capability | Spring Test / Django TestCase / RSpec | Forge |
|---|---|---|
| **Test harness** (request builder, response asserts, no socket) | ✅ | 🟡 `dispatch_test` exists, no framework |
| **Fixtures / factories** (seed test data) | ✅ | ❌ |
| DB test isolation (transaction rollback per test) | ✅ | ❌ |
| Mocking / test doubles | ✅ | ❌ |
| Integration (TestContainers) | ✅ | ❌ |

**P1:** a Forge test harness — `test_request(method,path,body,headers)` → assert status/json/header, plus per-test DB rollback + factories.

---

## L. Developer Experience  →  Forge 🟡 (P2)

| Capability | Rails generators / Spring Initializr / Django manage.py | Forge |
|---|---|---|
| Project scaffold | ✅ | ✅ (`nova new`) |
| **Per-resource generators** (`rails g model/controller/scaffold`) | ✅ | ❌ |
| CLI (migrate / routes / console / dbshell) | ✅ | 🟡 |
| Hot reload / devtools | ✅ | ❌ |
| **i18n / l10n** (message bundles, locale resolution, pluralization) | ✅ | ❌ |
| Email (send + templates) | ✅ | ✅ (SMTP) |

**P1:** i18n. **P2:** per-resource generators, dev console.

---

## PRIORITIZED PLAN — new sprints (added to FORGE_BUILD_PLAN.md)

The incumbents' "batteries-included" feel is 80% these deep features. Sequenced by leverage:

- **S14 — Config + Profiles + lightweight DI/service-registry + request-scoped `ctx`** (P0). Foundational; unblocks everything else reading config + wiring components without a global.
- **S15 — Declarative cross-cutting decorators** (P0/P1): `tx` (propagation/nesting) · `cached` · `retried` · `scheduled(cron)` · `timed` — HOF wrappers over a service fn. The AOP substitute, NOVA-shaped.
- **S16 — Data depth** (P1): derived query-method parsing · entity auditing (timestamps+user) · soft deletes · optimistic `@version` · versioned migration files (up/down + history) · model callbacks/signals · seeding.
- **S17 — Web + rendering depth** (P1): **template engine** (layouts/partials/auto-escape/interpolation) · **form objects** (fields+widgets+per-field errors+re-render) · **global exception-handler registry** · HATEOAS.
- **S18 — Platform depth** (P1): **application event bus** (typed events + sync/async/after-commit listeners) · **method-level security** guard · **i18n** (message bundles + locale) · **testing harness** (request builder + asserts + factories + per-test rollback) · account-lockout/TOTP.
- **S19 — Ops/DX polish** (P2): actuator endpoints (routes/config/loggers/buildinfo) · batch/chunk processor · declarative cron dashboard · per-resource generators.

**Competitive scorecard after S14–S18 lands:** Forge would match Spring Boot's config/DI/AOP/data/security/event ergonomics and Django's forms/admin/ORM/i18n depth — with NOVA's advantages (one language front-to-back, process-isolation safety, channels-as-every-transport) on top. THAT is "beats Spring Boot / Django," not the plumbing alone.

**Honest note (F-audit):** some Spring features NOVA should deliberately NOT copy (reflective auto-wiring magic, XML config, the annotation-processor build step) — they fight "no hidden costs / simpler than Python." The audit distinguishes the *capability* (wire a component, cache a method) from Spring's *mechanism* (reflection/proxies). Forge delivers the capability the NOVA way: explicit HOF decorators, RTTI-driven binding, typed registries.
