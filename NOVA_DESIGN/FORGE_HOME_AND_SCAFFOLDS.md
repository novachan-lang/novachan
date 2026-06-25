> ⚠️ **SUPERSEDED — 2026-06-25. Archived for history; do not plan from this file.** The canonical Forge docs are **[FORGE_STATUS.md](FORGE_STATUS.md)** (what/why) and **[FORGE_BUILD_PLAN.md](FORGE_BUILD_PLAN.md)** (how/when). The `nova new` scaffold work tracked here is now build-plan tasks in S0 (note: `nova new` is currently wired to a dead `nova_pkg_new` stub — see FORGE_STATUS §4 B9).

---

# Forge Home + `nova new` Scaffolds — Architecture & Execution

Status: ACTIVE (arc started incr-8). This is the "download-and-go" DX the user prioritised:
one `nova` binary, `nova new` → working project, `import forge` resolves with no package
install, `nova build` → one static binary with forge compiled in.

## The moat (why this beats everyone)

FastAPI / Django / Spring / Rails / Express all require: install a runtime, `pip`/`mvn`/`npm`
install a tree of dependencies, then ship the runtime + deps alongside the app. NOVA's edge:
**forge is bundled in the toolchain stdlib** (`$NOVA_HOME/lib/forge.nova`), so `import forge`
resolves with zero install, and `nova build` produces ONE static native binary with forge
compiled in — no runtime, no dependency tree, no container base image required. "Download the
`nova` binary, `nova new --api app`, `nova run`" — and a real server is live.

## Module resolution (incr-8 — DONE, pending reconverge)

`resolve_module_file` (nova_compiler.nova) gained a final fallback: after the importing-file
dir, the CWD, and `nova_packages/`, it tries `$NOVA_HOME/lib/<name>.nova`. Tried LAST, so a
local/vendored copy always wins → existing imports are byte-identical; only out-of-CWD
projects gain the new path. Verified gen4: out-of-tree project imports forge ONLY via
`$NOVA_HOME/lib` (positive resolves+runs; negative without NOVA_HOME fails — proving no other
path). This is the keystone: a `nova new` project created anywhere on disk can `import forge`.

## Directory layout (end state)

```
<repo>/
  forge/                     # the framework's canonical HOME (its own folder, per user)
    forge.nova               # framework source (single source of truth)
    README.md
    templates/               # scaffold sources for `nova new`
      api/  microservice/  frontend/  fullstack/  lib/
  nova-compiler/
    lib/forge.nova           # INSTALLED copy = $NOVA_HOME/lib (NOVA_HOME=nova-compiler in dev)
    test_programs/forge.nova # test-local copy (existing 445 tests resolve locally; later: drop)
```

Drift control: `forge/forge.nova` is canonical; `_install_forge.ps1` syncs it →
`nova-compiler/lib/forge.nova`. Test-local copy stays until the harness migrates to NOVA_HOME
resolution (a later increment that then makes the regression itself prove install-resolution).

## `nova new <type> <name>` — project types (separate project creation, per user)

1. `--api`         REST API: typed routes returning JSON via _coerce, /health, example CRUD,
                   middleware (logger + CORS), spawn-per-connection serve. nova.toml + README.
2. `--microservice` Minimal single-purpose service: crash-isolated serve (dispatch_safe),
                   /health + /ready, structured for one static binary in a container.
3. `--frontend`    Static SPA served via forge.static: public/index.html + app.js + style.css.
                   (WASM compile of NOVA front-end logic is a later additive step.)
4. `--fullstack`   API + frontend in ONE binary, ONE `nova run`: backend routes + static mount.
                   The NOVA identity use case (CLAUDE.md "first experience").
5. `--lib`         Reusable module skeleton: <name>.nova module + <name>_test.nova + nova.toml.

Each scaffold emits: entry (`main.nova`), `nova.toml` (name/version/entry/deps), `README.md`,
plus `public/` for frontend/fullstack. All generated code compiles + runs immediately.

## Build/run sequencing (reconverge-aware — each compiler change is one reconverge)

- incr-8  module-resolution fallback ...................... COMPILER (reconverge) — IN PROGRESS
- incr-9  forge/ home + lib/ install + _install_forge ..... files only (no reconverge)
- incr-10 scaffolder as `nova_new.nova` module (scaffold(type,name)->Result) + per-type
          templates; validate by generating each project, compiling + running it ... no reconverge
- incr-11 unified `nova` driver: subcommand dispatch (new/run/build/compile/fmt); `nova new`
          calls the scaffolder module; backward-compatible (a .nova arg still compiles) . COMPILER
          (reconverge — batch ALL subcommands in one pass to amortise the reconverge cost)
- incr-12 `nova run` (compile+run; hot-reload later) + `nova build` wiring to one static binary

Rationale for splitting 10/11: build + validate the scaffold LOGIC cheaply (no reconverge) as a
module, THEN wire it into the driver in a single reconverge that adds all subcommands at once.
This minimises the number of expensive bootstrap reconverges while keeping each step verified.

## Failure hunt / risks

- Three forge.nova copies during transition → drift. Mitigation: canonical in forge/, scripted
  install, planned consolidation to NOVA_HOME-only test resolution.
- `nova new` writing files: must refuse to overwrite a non-empty target dir (no clobber); must
  create parent dirs. Verify write_file + a dir-exists/mkdir primitive before relying on them.
- Generated projects must resolve forge: requires NOVA_HOME set OR forge vendored into the
  project. Decision: scaffolds assume an installed toolchain (NOVA_HOME); `nova build` in the
  driver will set/derive it. Document the env var until exe-relative resolution lands.
- Subcommand dispatch must NOT break `nova file.nova` (the current compile invocation) — keep
  the "first arg ends in .nova → compile" path as the default/fallback.
```
