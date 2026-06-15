# Forge — the NOVA web framework

Forge is NOVA's batteries-included web framework. It is **bundled in the NOVA toolchain**, not
a downloaded dependency: `import forge` resolves from `$NOVA_HOME/lib/forge.nova`, and
`nova build` compiles it into one static native binary. No runtime, no dependency tree, no
container base image — download the `nova` binary and ship a server.

## This folder

`forge/forge.nova` is the **single canonical source** of the framework (its own home, not
buried in compiler test scratch). The toolchain install copies it to `$NOVA_HOME/lib/forge.nova`
so every compile — the test suite and any out-of-tree project alike — resolves the same module.

- Install / refresh the toolchain copy: `nova-compiler/test_programs/_install_forge.ps1`
  (the test harness also auto-syncs it on every run, so the installed copy can never drift).

## What Forge gives you (typed handler model)

- Routing with path params and groups: `app()`, `get/post/put/delete(a, "/users/:id", h)`,
  `group(a, "/api/v1")`.
- Typed dispatch: handlers are `fn(req: Request) -> Response` (or return a bare value — see
  coercion). 404 / 405 handled.
- Return coercion: `return user` / `return notes` / `return "ok"` — a struct/list becomes JSON
  (via compiler-derived struct RTTI), a string becomes 200 text, a Response passes through.
- Middleware: `use(a, mw)` with `fn(req, next) -> Response`, folded outside-in, short-circuitable
  (`mw_set_header`, `mw_cors_origin`, `mw_log`).
- Static files: `static(a, "/assets", "public")` — traversal-safe by construction (no `..`,
  no dotfiles, no backslash/drive escapes; the served file cannot leave the mount root).
- Concurrency: `serve_req(a, port)` spawns a green task per connection (no async coloring).
- Fault tolerance: `serve_safe_req(a, port)` runs each handler in a monitored process — a panic
  becomes a 500 and the server lives ("let it crash" at native AOT speed).
- Flat per-request memory: requests are handled inside a per-task arena — no GC pause, no manual
  lifetimes, cycle-immune.

## Quickstart (once `nova new` lands)

```
nova new --api myapp     # or --microservice / --frontend / --fullstack / --lib
cd myapp
nova run                 # compile + serve
nova build               # one static binary
```
