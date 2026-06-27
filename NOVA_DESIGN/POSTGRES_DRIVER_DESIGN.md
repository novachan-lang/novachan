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
