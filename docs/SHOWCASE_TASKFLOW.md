# Showcase: TaskFlow — a real REST service in one NOVA file

`nova-compiler/test_programs/showcase_taskflow_test.nova`

This is NOVA's identity made concrete: **one developer, one language, one file — a real product.**
TaskFlow is a task/project-management REST API of the kind you would actually ship, and it is
*self-verifying* — the same file that defines the service also exercises it end-to-end in-process
(no sockets, deterministic), so `showcase_taskflow_test` is both the example and its own test.

## What it demonstrates (the full backend stack, zero ceremony)

| Capability | Where |
|---|---|
| HTTP routing with **path params** | `/api/projects/:id`, `/api/projects/:id/tasks`, `/api/tasks/:id` |
| **Query params** (optional, guarded) | `GET /api/projects?page=2`, `GET /.../tasks?status=open` |
| **Auth middleware** (leaves `/health` public) | `forge.use(a, fn(req, next) require_key(...))` |
| **Typed JSON in** (`from_json` into a struct) | `let inp: Project = from_json(req.body)` |
| **Typed JSON out** (return your type → JSON) | `forge.resp_json(201, Project(...))` |
| **SQLite persistence**, every value parameterized | `forge_db.pool_query(pool, "... VALUES (?, ?)", [...])` |
| **Validation** with correct status codes | `400` empty name, `401` bad key, `404` missing resource |
| **Pagination + filtering** | `LIMIT ? OFFSET ?`, `WHERE status = ?` |
| **Aggregation** (dashboard summary) | `GET /api/stats` → counts by status |
| **Cascade delete** | `DELETE /api/projects/:id` removes its tasks |

There are **zero type annotations** on the request-handling logic beyond the domain `type`
declarations, and **zero manual memory management**. The compiler infers the rest.

## The endpoints

```
GET    /health                      -> {"status":"ok",...}         (public, no key)
POST   /api/projects                -> 201 Project | 400
GET    /api/projects?page=N         -> 200 [Project] (page size 5)
GET    /api/projects/:id            -> 200 Project | 404
DELETE /api/projects/:id            -> 204 | 404   (cascades tasks)
POST   /api/projects/:id/tasks      -> 201 Task | 400 | 404
GET    /api/projects/:id/tasks?status=  -> 200 [Task] (optional filter)
PATCH  /api/tasks/:id               -> 200 Task | 400 | 404
GET    /api/stats                   -> 200 {"projects":N,"tasks_by_status":{...}}
```

All `/api/*` routes require `X-API-Key: secret-key-123`; missing/wrong key → `401`.

## Running it

It is wired into the regression harness (`_run_final_regression.ps1`) and links SQLite. To run it
standalone from `nova-compiler/test_programs` (Windows, kill-on-timeout runner):

```powershell
powershell -NoProfile -File .\_run1db.ps1 -Test showcase_taskflow_test
# -> showcase_taskflow_test passed -- full REST service: auth + CRUD + tasks + filter + stats, all in one NOVA file
```

To serve it for real over a socket instead of the in-process harness, replace the test block in
`main` with `forge.serve(a, 8080)` (or `forge.serve_n_arena` for the concurrent, per-request-arena
path) — the handlers are unchanged.

## A note on robustness (found by building this)

Building TaskFlow surfaced and fixed a real compiler soundness bug: comparing a **dynamic value that
holds a non-string** (e.g. `dict["missing"]`, which yields int `0`) against a string with `==`/`!=`
used to dereference the integer as a pointer and crash. It now routes through the box-aware
`nova_rt_eq`/`nova_rt_neq` (a string is simply *not equal* to a stray int — no crash). This is why
dogfooding matters: a 200-line real app exercises paths no unit test had. The idiomatic guard for
*optional* request params is still `contains(req.query, key)` (see `_qget`/`_hget` in the source),
since a missing key yields `0`, not `""`.
