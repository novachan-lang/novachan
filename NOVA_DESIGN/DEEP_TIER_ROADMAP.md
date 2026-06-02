# NOVA Deep-Tier Roadmap — the gaps that need focused sessions

**Status:** 2026-06-02. After the 14-batch autonomous push (A–N, scorecard 55%→58%, 164/164 tests), the
*safely-autonomous* pure-NOVA gaps are closed. What remains is the **deep tier**: cross-cutting changes to
the inferrer / codegen / threading runtime that need bootstrap-per-iteration and full context budget. Each
item below is scoped with current state, approach, key risk, and effort so a focused session executes it
cleanly. Ordered by leverage.

---

## 1. Typed `Result<T,E>` / `Option<T>`  ·  ⭐ #1  ·  see [TYPED_RESULT_PLAN.md](TYPED_RESULT_PLAN.md)
**State:** runtime + `?` + combinators real; type-erased (`ok`/`unwrap` are `any→any`).
**Approach:** registry schemes over the existing (unused) `nt_sum`; the unifier already handles `sum`
component-wise and `any` is permissive, so it's a contained inferrer change + a `?`/try rule + confirming
codegen lowers `sum`-returns as i64. **Effort:** 3–5 bootstrap iterations. Full checklist in the linked plan.

---

## 2. Structured concurrency (bounded channels + supervision)
**State (verified):** the primitives are REAL — `nova_rt_spawn` (OS-thread pool + deep-copy isolation),
`channel_create/send/recv` (lock + `not_empty` condvar, deep-copy ownership transfer), `select`, `async`,
`pmap`. What's missing is the *structured* layer.

**2a. Bounded / back-pressured channels — contained runtime change.** Channels are currently UNBOUNDED
(`channel_send` enqueues unconditionally). To add back-pressure:
  1. Add `int capacity` and a `not_full` condition variable to `NovaChannel`.
  2. New builtin `channel_bounded(cap)` (wire all 4 sites: name-map, type reg `nt_fn([nt_int()], nt_channel(T))`,
     both LLVM emitters, IR classification → int handle) + one bootstrap.
  3. `channel_send`: `while (ch->count >= ch->capacity && !ch->closed) wait(not_full)` BEFORE enqueue
     (capacity 0 = unbounded, preserving current behavior).
  4. `channel_recv`: after dequeue, `signal(not_full)` to wake a blocked sender.
**Risk:** lost-wakeup / deadlock — mitigate by mirroring the existing `not_empty` predicate-loop pattern
exactly (always re-check the predicate under the lock). **Effort:** 1 bootstrap + threaded stress test.

**2b. Supervision / "let it crash" — mostly NOVA-level.** `nova_rt_monitor` already registers listener
channels and the design delivers an exit notification. A supervisor can be written largely in NOVA today:
`fn supervise(spawn_fn, strategy)` spawns the child, receives on its monitor channel, and on an exit message
re-spawns per strategy (one_for_one / max_restarts window). The runtime gap is making `process_link`/
`exit_notify` (currently log-only stubs at ~9383) actually push a typed exit message onto the monitor
channel. **Effort:** small runtime fix (stubs→real exit-message send) + a NOVA `supervisor.nova` module +
1 bootstrap. This is where the **Erlang-beating thesis** is won and it is now a *small* lift.

---

## 3. Unicode-correct default `len` / indexing
**State:** codepoint VIEWS exist (`char_count`/`char_at`/`code_points`/`from_codepoint`, Batch A), but
default `len`/`s[i]`/`ord`/`chr`/regex are byte-level (`len("café")==5`).
**Approach (decision required):** NOVA's strings are UTF-8 bytes. Two options: (a) keep `len`/indexing
byte-level (like Go) and make codepoint-ness explicit via the existing views — *lowest blast radius, already
mostly done, arguably the right call*; or (b) make `len`/indexing codepoint-aware by default (like
Python/Swift) — **high blast radius**: changes the meaning of `len` across the whole codebase + 164 tests +
the self-hosted compiler's own string handling. **Risk:** (b) could destabilize the bootstrap (the compiler
lexes by bytes). **Recommendation:** adopt (a) as the official model + document it; reserve (b) only if a
concrete need appears. **Effort:** (a) = documentation; (b) = large migration, own session.

---

## 4. Reflection / comptime / macros  ·  (the deepest; gates Serde-derive)
**State:** 0% (the only true 0%). No compile-time reflection, no `derive`, no hygienic macros.
**Approach:** the NOVA way is **typed comptime** (per NOVA_INNOVATIONS C1) — compile-time code that runs over
typed AST/Values, replacing macros+templates+reflection with one substrate. First concrete step: a
compile-time `type` introspection Value (fields/kind of a struct) usable by a comptime function, then a
`derive(serialize)` that emits a codec from a struct's field list. **Risk:** large new compiler subsystem;
design-heavy. **Effort:** multi-session; needs its own design doc before code. This unblocks Serde-style
serialization (cat-18) and DI/ORM patterns.

---

## 5. Compile-time units / dimensional analysis  ·  (cat-11, signature-ish)
**Approach:** a refinement on the numeric type — a unit is a compile-time tag on a numeric Value; `+`
requires equal units, `*` adds unit exponents. Fits the comptime-Value machinery (#4). Adding meters to
seconds becomes a type error. **Effort:** medium, gated on #4's comptime surface.

---

## 6. DB driver layer + remote package registry + HTTP depth  ·  (framework-adjacent)
**State:** SQLite via FFI works E2E but SQL is string-concatenated (injection-prone); `nova_pkg` registry is
local-only; HTTP server is thread-poolable (now that the pool is real) but lacks cookies/sessions/auth/
multipart/middleware. **Approach:** a typed connection+parameter-binding abstraction (gated partly on typed
Result #1 for error handling); a network-fetch + transitive-resolution layer for `nova_pkg`; a middleware
chain + request/response Value types for HTTP. **Effort:** large, multiple sessions; these are the bridge
into the parked frameworks (Forge especially). Best tackled after #1 (typed errors) lands.

---

## Suggested order
**#1 typed Result** (unblocks safe DB/HTTP error handling) → **#2a bounded channels** + **#2b supervision**
(completes the concurrency thesis, small lift) → **#3 adopt byte-`len` officially** (doc) → **#4 comptime/
reflection** (own design session) → **#5 units** + **#6 DB/HTTP depth** (gated on #1/#4). Each is now scoped
enough to start without re-discovery.
