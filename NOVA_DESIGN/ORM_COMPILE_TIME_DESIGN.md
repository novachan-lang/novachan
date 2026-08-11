# NOVA ORM — Statically-Known Data Access

**Status:** Phase 0 + Phase 1 implemented and 3-dialect verified (2026-08-12). Phase 2 designed, not built.

## Thesis

> Every other ORM defers knowledge to **runtime**. NOVA's ORM is fully **known at compile time** — the
> schema (the struct), the query (a value), the dialect (the DSN), the cost (static), and the
> transaction scope (escape analysis).

This is the only "better than every ORM" claim that isn't marketing, and it is available to NOVA
*because NOVA owns its compiler*. Hibernate cannot add compile-time checks to Java. Prisma cannot.
NOVA already performs type-directed ORM rewriting (`let x: list<T> = orm_all(...)` →
`T__from_dict_list(...)` at `nova_compiler.nova:13401`) — **the compiler is already part of the ORM.**

## Know the enemy

Not the feature lists — the bug trackers:

| Failure | Industry reality |
|---|---|
| N+1 queries | The #1 ORM performance disaster. Hibernate/Prisma/SQLAlchemy default to lazy → 1000 rows = 1001 queries. Every fix (`JOIN FETCH`, `@BatchSize`, `include`, `selectinload`) is **opt-in**, discovered in production |
| `LazyInitializationException` | The most-Googled Hibernate error. Detached proxy → runtime explosion |
| Invisible cost | Nothing in `user.getOrders().get(0).getItems()` reveals whether it is 1 query or 300 |
| Flush-order surprises | Unit-of-work decides *when* to write; constraint violations depend on insertion order |
| String queries | JPQL/HQL and Spring's `findByFirstNameAndLastNameOrderByAge` are code encoded as **strings** — validated no earlier than startup |
| Dev/prod dialect divergence | Works on dev SQLite, breaks on prod Postgres |

## Measured dialect ground truth

Executed against live SQLite + PostgreSQL 16 (:5432) + MySQL (:3306) through `forge_orm`.
**Three divergences SUCCEED while returning the wrong value** — the worst class, because a green
suite still corrupts data.

| SQL | SQLite | Postgres | MySQL |
|---|---|---|---|
| `SELECT "id"` (want `7`) | `7` ✅ | `7` ✅ | **`'id'`** ❌ string literal |
| `SELECT 'a' \|\| 'b'` (want `ab`) | `ab` ✅ | `ab` ✅ | **`0`** ❌ logical OR |
| `SELECT NOW()` | **0 rows** ❌ | ✅ | ✅ |
| `RETURNING id` | ✅ | ✅ | **✗** |
| `ON CONFLICT … DO UPDATE` | ✅ | ✅ | **✗** |
| `ON DUPLICATE KEY UPDATE` | ✗ | ✗ | ✅ |
| `LIMIT 18446744073709551615` | **0 rows** ❌ | **22003 error** ❌ | ✅ |
| `CREATE UNIQUE INDEX` on `TEXT` | ✅ | ✅ | **✗** needs key length |
| `SELECT * … GROUP BY x` | ✅ lenient | **✗ rejects** | ✅ lenient |
| backtick `` `id` `` | ✅ | **✗** | ✅ |

**Portable choices forced by this:** `CONCAT()` not `||`; `LOWER(col) LIKE` not `ILIKE`;
`CURRENT_TIMESTAMP` not `NOW()`; signed-64 max for a bare-offset ceiling; `VARCHAR(255)` not `TEXT`
for indexable MySQL strings; branch on `orm_kind(db)` for upsert and generated keys.

## The binding constraint: compiler-pinned names

`nova_compiler.nova:13401-13403` rewrites typed lets by **hard-coded function name** (`db_all`,
`orm_all`, `orm_where` → `T__from_dict_list`; `orm_one`/`orm_get` → `T__from_dict`; `orm_fetch` →
`orm_fetch_all`). Those must return a **bare `list`** of name-keyed dicts.

> Returning `Result` instead would iterate a sum value as a list → **garbage/crash, not a type error.**

Consequence, and the reason the Phase 1 design looks the way it does:

| Category | Compiler change needed |
|---|---|
| Writes (upsert, bulk, DDL, auditing) — return `Result` | **No** |
| Scalars (count/exists/agg) | **No** |
| Typed multi-row reads | **Yes**, unless routed through the pinned names |

A spec value composes SQL and the terminal read stays `orm_all(db, q.sql(), q.params)` — so the whole
Phase 1 surface needed **zero** compiler change and stayed out of RED blast radius.

## Phase 0 — the floor (DONE)

The flagship zero-SQL flow was **broken on 2 of 3 dialects**: `_orm_sql_type` emitted
`INTEGER PRIMARY KEY` for `id` everywhere, which auto-increments *only* on SQLite, while `orm_insert`
deliberately omits `id` when it is 0 — so the database was asked for a key it could not generate
(`23502` on PG, `1364` on MySQL).

Delivered: `_orm_autopk` per-dialect PK · `orm_upsert`/`orm_upsert_by` · `orm_put` (JPA `save()`
insert-or-update; `orm_save` was and remains INSERT-ONLY) · `orm_insert_id`/`orm_save_id` ·
`orm_try_count`/`orm_try_exists`/`orm_try_agg` (the originals report a **driver failure** as
`0`/`false`/`""`) · `orm_qident`/`orm_table_of`/`orm_now_sql`/`orm_concat_sql`/`orm_ilike_sql`.

`orm_insert_id` on MySQL must pin the INSERT and `LAST_INSERT_ID()` to **one connection** —
`LAST_INSERT_ID()` is per-connection, and issued as two pool calls the probe returned a **stale id
(2 where the true key was 1001)**.

## Phase 1 — the analyzable surface (DONE)

A query is a **value**, not a string and not a method name. That is not ergonomics: a spec built from
data can be read by tooling and by the compiler, which is what makes Phase 2 possible at all. It also
keeps *one* composable concept instead of Spring's combinatorial derived-name explosion.

`orm_spec(db, row)` / `orm_from(db, table)` → `eq ne gt ge lt le between is_null not_null like starts
ends contains icontains in_ not_in` · composing `asc`/`desc` · `distinct` · `group_by`/`having` ·
`paginate` · `columns_of` · `cond()` · `count_sql()` · `try_run()`.
Plus `OrmPage`/`orm_page_meta`, `orm_update_where`, `orm_delete_where`, `orm_delete_all`,
`orm_delete_by_ids`, `orm_pluck`/`orm_pluck_uniq`/`orm_group_by_field`, `orm_ensure_index`/`orm_ensure_unique`.

Deliberate safety decisions:
- empty `in_()` → `1=0` (matches **nothing**); empty `not_in()` → `1=1` (matches **everything**).
  Dropping the predicate instead would silently widen the query to every row.
- `orm_delete_where` **refuses** a spec with no condition. JPA's `deleteAll()` quietly erasing a table
  because a criteria object came back empty is a data-loss footgun; erasing must be asked for by name.
- `orm_delete_all` uses `DELETE`, not `TRUNCATE` — TRUNCATE is non-transactional / implicitly commits
  on some engines, so it could not be rolled back inside `orm_with_tx`.
- `count_sql()` keeps the SELECT list intact when wrapping a grouped query, because
  `SELECT * … GROUP BY x` is **rejected by PostgreSQL** and accepted by the other two.

## Phase 2 — the differentiators (DESIGNED, compiler, RED)

All four hook the site that already knows both the SQL literal and the target struct
(`nova_compiler.nova:13401`, where `fj_le` is `T` and `b.ir_sdefs[T]` gives `Param(name,type,default)`).

**P2.1 · Dialect lint** *(lowest risk, zero false positives, ship first)*. Scan SQL string literals at
ORM call sites for the measured non-portable forms and refuse them:
```
error: `||` is string concat on sqlite/postgres but logical OR on mysql (returns 0)
   = help: use CONCAT(a, b) — portable across all three
```
Covers `||`, `NOW()`, `ILIKE`, and double-quoted identifiers. **No ORM does this.**

**P2.2 · SQL verified against the struct — with no live database.** The struct *is* the schema:
```
error: column `nmae` does not exist on struct `Widget`
   = help: did you mean `name`?
```
`sqlx` needs a live DB at build time; JPA finds it at runtime. NOVA needs **neither a DB nor
annotations**. Scope to an explicit SELECT list with an edit-distance-1 near miss to keep false
positives at zero (a deliberate projection must stay legal).

**P2.3 · N+1 is a compile error.** A query inside a loop over another query's rows is statically
detectable:
```
error: N+1 query — `orm_where` runs inside a loop over rows from line 12
   = help: batch it — orm_pluck + in_() + orm_group_by_field (2 queries, not 1001)
```
Hibernate ships a *runtime* counter for this. NOVA would make it **unshippable**.

**P2.4 · Transaction escape analysis.** The vicious bug no ORM catches: inside
`orm_with_tx(db, fn(tx) …)` you use the **outer** `db`, so a "transactional" write lands outside the
transaction and survives rollback. NOVA already has escape analysis for ownership — point it at
connection handles: inside a tx body `tx` is the only legal handle, and letting it escape via `spawn`
is an error.

**P2.5 · Total mapping.** `from_dict_list` currently **drops rows it cannot map, silently**
(`nova_compiler.nova:~4324`) — data loss presenting as an empty result. Mapping becomes total.

## Phase 3 — north star: automatic query coalescing

The ORM as a **process**; the scheduler batches concurrent queries from green tasks into single round
trips. That is DataLoader, but automatic and language-level rather than a userland library, built on
NOVA's actual Values/Processes/Channels core. N+1 stops being merely *detected* and becomes
*eliminated*. Cannot batch across transaction boundaries — that constraint is the design's hard edge.

## What NOVA wins for free (state it loudly)

NOVA structs are plain values: there are **no lazy proxies**, so `LazyInitializationException` cannot
exist. There is **no unit-of-work**, so no flush-order surprises and no stale L1 cache. Hibernate's
most confusing behaviours are not features we lack — they are problems we do not have.

## Competitive scorecard

| Dimension | Best today | NOVA now (Phase 0+1) | After Phase 2 |
|---|---|---|---|
| N+1 prevention | Hibernate (runtime counter) | tools to fix it manually | **wins** — compile error |
| Query type-safety | Diesel / sqlx (needs live DB) | typed reads, unchecked SQL | **wins** — struct is schema, no DB |
| Dialect portability | none | **wins** — measured + branched | **wins** — compile lint |
| Zero ceremony | ActiveRecord | **wins** — no annotations at all | wins |
| No silent failure | none | **wins** — `Result` + `orm_try_*` | wins |
| Bulk write speed | COPY-based tools | ties — 192–219× batch, 8× COPY | ties |
| Ecosystem maturity | Hibernate | **loses** — honest gap, deferred | loses |

## Verification standard

A feature counts as "works on all three" only when a KAT asserts its **value** on all three live
servers. The error-only probe demonstrably lies — it returned YES for three forms that produced
garbage. KATs: `_kat_orm_phase0.nova`, `_kat_orm_spec.nova`.

⚠ **`NOVA_NO_CACHE=1` is mandatory when testing a `forge_*` edit.** Without it the module cache serves
a stale `forge_orm` and the run silently tests the OLD code — this produced a false green during
development.
