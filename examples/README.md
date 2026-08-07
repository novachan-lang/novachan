# NOVA Examples

Three programs that show what NOVA is for. Each one **compiles and runs as-is** — every output
below was captured from an actual run, not written by hand.

```bash
nova run cli_wordcount.nova <file>
nova run pipeline.nova
nova run rest_api.nova
```

---

## 1. `cli_wordcount.nova` — a CLI tool (30 lines)

Reads a file, counts words, prints the top 5.

```
$ nova run cli_wordcount.nova sample.txt
10 distinct words in sample.txt
  the: 5
  fox: 2
  dog: 2
  quick: 1
  brown: 1
```

Shows `args()`, file IO, dicts, `sort_by` with a key function, list comprehensions, and string
interpolation. **Not one local variable has a type annotation** — the compiler infers all of them.

---

## 2. `pipeline.nova` — concurrency (45 lines)

Fans work out to 4 green tasks, fans the results back in.

```
$ nova run pipeline.nova
primes below 100000: 9592
```

`spawn` + `channel()` + `send`/`recv` is the whole concurrency model. Values are deep-copied
across channels, so there is no shared mutable state to race on and no lock to forget. The same
`spawn` scales from a green task to a distributed node — and a program that never spawns compiles
the runtime away entirely.

---

## 3. `rest_api.nova` — REST API + SQLite (85 lines)

A complete CRUD service on a real database.

```
$ nova run rest_api.nova
REST API listening on http://localhost:8080

$ curl -X POST localhost:8080/tasks -d '{"title":"write nova","done":0}'
{"id":1,"title":"write nova","done":0}

$ curl localhost:8080/tasks
[{"id":1,"title":"write nova","done":0},{"id":2,"title":"ship v1","done":1}]

$ curl localhost:8080/tasks/99
{"error":"no task with id 99"}

$ curl -X DELETE localhost:8080/tasks/1
{"deleted":1}
```

Routing, path params, JSON in and out, structs that serialize themselves, and a pooled SQLite
connection. The pool is a **channel**: acquiring is `recv`, releasing is `send`, so when every
connection is busy the next request parks instead of piling up — backpressure for free.

Queries are parameterized, which was verified rather than assumed:

```bash
$ curl -X POST localhost:8080/tasks -d '{"title":"x'\''); DROP TABLE tasks; --","done":0}'
{"id":3,"title":"x'); DROP TABLE tasks; --","done":0}     # stored as text; table intact
```

---

## Three things that will bite you

These are real traps, each of which cost time while writing these very examples:

**`else` fallback is statement-level.** `let x = f() else 0` is fine; `str(f() else 0)` does not
parse. Bind it first.

**Every string interpolates `{...}`.** There is no `f` prefix — `"count: {n}"` just works. The flip
side is that a literal brace must be escaped: `"\{not an expression}"`.

**Pick one server API and stay in it.** `resp_json`/`resp_text` return a typed `Response` and pair
with `serve_req`. `forge.json`/`forge.text` return strings and pair with `serve_app`. Crossing them
sends a struct raw and the client sees a malformed HTTP/0.9 reply.

Full catalogue: [`NOVA_DESIGN/NOVA_LANGUAGE_FEATURES.md`](../NOVA_DESIGN/NOVA_LANGUAGE_FEATURES.md)
(§7 is the trap list). Tutorial: [`docs/TUTORIAL.md`](../docs/TUTORIAL.md).
