# PostgreSQL Driver (forge_pg) — Design

**Goal:** a pure-NOVA PostgreSQL client, parallel to `forge_db`'s SQLite layer, so a Forge app talks to
production Postgres with zero external dependency (no libpq FFI). PG's v3 frontend/backend protocol is
length-prefixed big-endian binary messages over a TCP socket — a natural fit for NOVA's `tcp_*` + bytes.

## DONE (v1, this slice — `forge_pg.nova`, gated by `forge_pg_test`, no live server needed)
The wire-protocol **encoding/parsing**, fully unit-tested socketlessly:
- `pg_be32/pg_be16` + `pg_rd_be32/pg_rd_be16` — big-endian ints (the on-wire format).
- `pg_startup_message(user, db)` — `len + protocol(196608) + user/database params`.
- `pg_query_message(sql)` — `'Q' + len + sql\0` (simple query protocol).
- `pg_parse_row_description(b, off)` — column names from a `'T'` message.
- `pg_parse_data_row(b, off)` — column value strings from a `'D'` message (`-1` = SQL NULL).

## DEFERRED (needs a live PG server — `docker run postgres` — to gate; a focused session)

1. **Connect + the message-read loop.** `tcp_connect(host, 5432)`, send the startup message, then loop
   reading framed messages `[tag(1)][len(4)][body(len-4)]` (read exactly len-4 bytes via `tcp_recv_bytes`
   accumulated against the length, the same pattern as `recv_request_bin`). Dispatch by tag: `R` auth,
   `S` ParameterStatus, `K` BackendKeyData, `Z` ReadyForQuery, `T` RowDescription, `D` DataRow,
   `C` CommandComplete, `E` ErrorResponse (parse the fields, surface as `err(...)`).

2. **Auth handshake** (on the `R` Authentication message, by sub-code):
   - `3` CleartextPassword → send `PasswordMessage('p' + len + pw\0)`. (Simplest; dev/trust setups.)
   - `5` MD5Password → send `'md5' + md5(md5(password + user) + salt)` hex.
   - `10` SASL / **SCRAM-SHA-256** (the modern default) → the SASL exchange: client-first
     (`n,,n=*,r=<nonce>`), server-first (salt, iterations, server-nonce), client-final with the
     ClientProof. **Needs SHA-256 + HMAC-SHA-256 + PBKDF2-HMAC-SHA-256** — check for an existing pure-NOVA
     `hashx`/crypto module (the WS handshake already ships pure-NOVA SHA-1; SHA-256 is the same shape) or
     add them. This is the bulk of the remaining work; MD5/cleartext unblock real use first.

3. **Query execution.** `pg_exec(conn, sql)`: send `pg_query_message`, read until `ReadyForQuery`,
   collecting the `RowDescription` (names) + `DataRow`s (values) → a list of name-keyed row dicts (reuse
   the `pg_parse_*` parsers). Map `ErrorResponse` → `err`.

4. **Parameterized queries** (injection-safe): the extended protocol — `Parse` (`'P'`) + `Bind` (`'B'`,
   binds `$1..` values) + `Describe` + `Execute` (`'E'`) + `Sync` (`'S'`). Values are sent as parameters,
   never string-concatenated — same guarantee as `forge_db`'s positional binding.

5. **Pool + typed integration.** `pg_pool_open(url, n)` parallel to `forge_db.pool_open` (a channel of
   connections); `pg_query`/`pg_insert`/`pg_all<T>`/`pg_find<T>` parallel to the `db_*` typed API, reusing
   the generated `<T>__from_dict`/`from_dict_list` machinery so the same typed-DB ergonomics work over PG.
   `with_tx` works unchanged (it's `BEGIN`/`COMMIT`/`ROLLBACK` text, DB-agnostic).

## Gate plan
A focused session with a Postgres server: connect → auth (cleartext first, then MD5, then SCRAM) →
`SELECT`/`INSERT` round-trips → typed-query + pool tests, each a real-socket integration test guarded by
the server being up (skip cleanly if absent). The v1 encode/parse layer is already permanently guarded.

---

## v2 LIVE-COMPLETION PLAN (2026-06-30, owner-chosen mission) — assessment + unit breakdown

**Assessment (3 Sonnet agents):**
- DONE in `forge_pg.nova` (186 lines): wire encode/parse (`pg_be32/16`, `pg_rd_be32/16`, `pg_startup_message`,
  `pg_query_message`, `pg_parse_row_description`, `pg_parse_data_row`) + ALL auth MATH
  (`pg_scram_client_first`, `_pg_scram_parse_sf`, `pg_scram_finish`, `pg_md5_auth`). Unit-tested socketlessly.
- CRYPTO (forge_crypto.nova): `sha256_bytes`, `hmac_sha256_bytes`, `pbkdf2_sha256`, `b64_encode_blist`/
  `b64_decode_blist`, `md5_*` — everything SCRAM/MD5 needs. GAP: no NOVA random-bytes wrapper for the SCRAM
  client nonce; the runtime has `nova_rt_os_random` (CSPRNG, 58cf288) — wrap it (or build the nonce from it).
- BINARY SOCKET I/O: `tcp_send_bytes(sock,bytes)` + `tcp_recv_bytes(sock)->bytes` EXIST + are green-aware
  (park on the netpoller). PG plaintext needs NO runtime change.
- LIVE TLS: `tls_connect/tls_send/tls_recv/tls_close` are REAL (SChannel/Windows, OpenSSL/Linux; `tls_test`
  does a live HTTPS round-trip). TWO GAPS for PG-over-TLS: (1) `tls_send`/`tls_recv` are STRING-only
  (strlen-based) → cannot carry PG's binary protocol → need `tls_send_bytes`/`tls_recv_bytes` (runtime).
  (2) `tls_connect` opens its OWN socket; PG's SSLRequest must TLS-UPGRADE an EXISTING connected fd →
  need a `tls_upgrade(sock)->handle` (wrap an fd in SChannel/OpenSSL) (runtime).
- ENV: a native `postgres` is LIVE on 127.0.0.1:5432 (creds/auth-method/SSL-config unknown). DB API to
  MIRROR (forge_db.nova): standalone fns taking the pool first — `pool_open/pool_query/pool_query_dicts/
  pool_exec/pool_insert/db_all<T>/db_find<T>/db_insert/with_tx`. Build via `_fdb_one.ps1` (PG needs no
  sqlite link, but the harness links it harmlessly).

**UNIT 1 — Live PLAINTEXT driver (forge_pg.nova only; NO runtime change).** `pg_connect(host,port,user,db,
password)`: tcp_connect → send `pg_startup_message` → the framed-message read loop (`[tag(1)][len(4)]
[body]`, accumulate exactly len-4 via tcp_recv_bytes, the recv_request_bin pattern) → dispatch by tag:
`R` auth (sub-code 0 ok / 3 cleartext / 5 md5 / 10 SASL-SCRAM — drive the exchange with the existing math)
/ `S` ParameterStatus / `K` BackendKeyData / `Z` ReadyForQuery (done) / `E` ErrorResponse (parse → err).
`pg_exec(conn,sql)`: send `pg_query_message`, read until `Z`, collect `T`+`D` → name-keyed row dicts.
TEST against :5432 — first validate cred-FREE plumbing (connect + R-message auth-method detection + the
`E` error path on a bad password), then a full SELECT round-trip once creds are known (try trust/defaults;
ask owner only if needed). Kill-on-timeout; skip cleanly if the server is down.

**UNIT 2 — PG over TLS (runtime additions, full nova_ci gated).** Add `tls_send_bytes`/`tls_recv_bytes`
(binary-safe, mirror tcp_*_bytes; SChannel EncryptMessage / OpenSSL SSL_write on raw bytes) + `tls_upgrade
(sock)` (wrap a connected fd). Then PG SSLRequest: send `[int32 8][int32 80877103]`, read 1 byte ('S'→
upgrade via tls_upgrade then continue the handshake over tls_*_bytes; 'N'→plaintext or fail-closed if TLS
required). Gate: full reconverge + regression both modes + ASAN (runtime change).

**UNIT 3 — Typed + pool integration.** `pg_pool_open(url,n)` (channel of conns), `pg_query/pg_all<T>/
pg_find<T>` reusing the `<T>__from_dict(_list)` machinery, `with_tx` (BEGIN/COMMIT text, DB-agnostic).
Parameterized queries via the extended protocol (Parse/Bind/Execute/Sync) — injection-safe, no string concat.

**Model split:** Opus writes the core read-loop + auth state machine (intricate binary/protocol) + the
runtime TLS-bytes additions + reviews; Sonnet does test scaffolding, the pg_exec/pool wrappers under spec,
and gate runs.
