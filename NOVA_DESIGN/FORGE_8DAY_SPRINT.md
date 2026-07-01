# FORGE 8-DAY SPRINT PLAN (2026-07-01 → recharge end ~07-09)

**Goal:** move Forge from ~36% → ~65–70% capability-weighted by clearing the high-leverage S/M items across
every layer, then take a real run at HTTP/2. Honest: the XL protocol items (gRPC, distribution, WASM,
auto-admin) do NOT fully land in 8 days; HTTP/2 is the stretch flagship.

## Working method (NON-NEGOTIABLE for speed)
- **Model split:** Opus = architecture + every compiler/runtime/protocol change + spec-writing + REVIEW + the
  gate/commit decision. Sonnet subagents = mechanical lib-only feature implementation UNDER an Opus spec +
  targeted test scaffolding + running the targeted test. Opus reviews the Sonnet diff before gating.
- **Tiered testing (stop running 600 tests per change):**
  - Dev loop per feature: build+run ONLY the affected forge test via `_fdb_one` (~seconds).
  - Gate per BATCH (3–5 related lib features), not per feature: one `nova_ci -SkipReconverge` (both RC modes).
  - Full `nova_ci` (reconverge + both modes) ONLY for compiler/runtime changes + milestone gates.
- **High-level NOVA syntax IS allowed in Forge** (map/filter/comprehensions/method-chains) — Forge is
  framework code, not the hot compiler path. Drop to loops only in a genuinely hot per-request inner loop.
- Each feature: spec → implement → targeted test → Opus review → batch-gate → commit → update this file.

## PHASE 1 (Days 1–2) — Production floor + cheap high-value sweep [mostly Sonnet]
Production floor (S0/L1, lib-only unless noted):
- [ ] T1.6 wire forge_limits (rate_allow/conn_acquire/limit_body_ok) into the live `_serve_conn` path  (S)
- [ ] T1.7 static realpath/symlink containment (prefix-check vs mount root)  (S, security B7)
- [ ] T1.8 `nova new` → forge templates + bundle full lib set to $NOVA_HOME/lib  (S, B9)
- [ ] T1.5 graceful drain (stop-accept + await in-flight via shutdown_requested + semaphore)  (M)
- [ ] T1.1/T1.2 read/idle timeout (Slowloris) — runtime `tcp_recv_bytes_to` + wire into keep-alive  (M, OPUS, reconverge)
Auth sweep (S4/L3, lib-only):
- [ ] JWT raw-byte HMAC fix (B6 external interop)  (S)
- [ ] T3.1 mw_auth(resolver) pipeline; T3.4 route requires(role); T3.3 persisted users via forge_db  (S×3)
- [ ] T3.5/T3.6 password_hash/verify (PBKDF2) + needs_rehash  (S)
- [ ] T3.8 rate-limit single-owner actor (N>1-correct, models _hub_loop)  (S, B8)
Real-time sweep (S5/L5, lib-only):
- [ ] T5.1/T5.2 forge.pubsub() topic bus (isolated topics); T5.3 socket assigns  (S×2)
- [ ] T5.4/5/6 per-topic join authorization (default-reject non-public)  (S)
- [ ] T5.7/T5.8 presence GenServer + auto track/untrack on join/leave  (M)
OTP sweep (S2/L4, lib-only forge_otp):
- [ ] T4.3 one_for_all + rest_for_one; T4.11 on_terminate; T4.15 application root  (S×3)
- [ ] audit/wire T4.16–T4.20 background jobs (queue/retry/DLQ/cron/pool/nursery)  (M)

## PHASE 2 (Days 3–4) — L2 Data keystones [Opus compiler bits + Sonnet lib]
- [ ] T2.7 `with tx { }` lexical transactions (parser + panic-aware desugar)  (M, OPUS, reconverge)
- [ ] T2.8 Postgres pool integration into the typed-DB ergonomic layer  (M)
- [ ] Migrations derive-from-struct (extend orm_create_table; add/drop/type-change; @renamed_from hint)  (M/L)
- [ ] Composable type-checked query DSL (extend forge_orm builder → where/select/order/limit)  (L)
- [ ] File/blob storage abstraction (storage.put/get/url; local backend)  (M)
- [ ] Cache abstraction (Agent-backed keyed memo)  (M)
- [ ] Cursor pagination Page<T> (keyset) + versioned route groups  (M)

## PHASE 3 (Days 5–6) — L6/L7 comms unlock (outbound-client chain) [Opus substrate + Sonnet decorators]
- [ ] D7r.1 outbound HTTP client + connection pool (over netpoller)  (M, OPUS) — UNLOCKS the chain
- [ ] D7r.2 composable channel decorators (timeout/retry/circuit_breaker/bulkhead)  (M)
- [ ] D7r.4 WS/SSE outbound consume client (ws_connect/sse_consume + reconnect)  (M)
- [ ] D7r.3 idempotency keys + If-Match OCC (412)  (M)
- [ ] OTLP span exporter (OTLP/HTTP) + SMTP send_mail (ride the outbound client)  (M)
- [ ] Deadline propagation (ambient budget decremented per hop)  (M)

## PHASE 4 (Days 7–8) — FLAGSHIP: HTTP/2 [Opus architecture + runtime; Sonnet HPACK/framing under spec]
- [ ] D2.1 ALPN-capable TLS listener (solidify HTTPS first; nova_rt_tls_alpn_selected)  (M, OPUS)
- [ ] D2.2 HPACK encoder/decoder (RFC 7541 C.2/C.3/C.4 byte-exact fixtures)  (L, Sonnet under spec)
- [ ] D2.3 frame codec (DATA/HEADERS/SETTINGS/WINDOW_UPDATE/RST_STREAM/PING/GOAWAY + preface)  (L)
- [ ] D2.4 conn+stream flow-control windows  (M)
- [ ] D2.5 multiplexed streams on netpoller → serve_h2 routing through the existing router  (L)
Stretch/if-blocked: if HTTP/2 stalls on ALPN-TLS, HPACK + frame codec + fixtures still land as the foundation.

## SEQUENCED (dependency-first) — the actual execution order
1. Phase 1 production floor (T1.6/T1.7/T1.8) — parallel Sonnet batch.  2. JWT fix + auth sweep.
3. T5 real-time sweep.  4. T4 OTP sweep.  5. T1.1 timeout (Opus).  6. T2.7 with-tx (Opus) → T2.8 → migrations
→ query DSL → storage/cache/pagination.  7. D7r.1 outbound client → decorators/consume/idempotency → OTLP/SMTP.
8. HTTP/2 (ALPN → HPACK → frames → flow-control → multiplex).

## DEFERRED (correctly out of 8-day scope; XL)
gRPC (S8), GraphQL (S8), full distribution/mesh (S11), auto-admin parity (S12), WASM frontend (S13),
NATS/Kafka/Rabbit backends (S10). Also: caching_sha2 0x04 full-auth + MySQL float/date decode + pool (DB nice-to-haves).
