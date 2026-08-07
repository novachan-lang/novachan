# NOVA Package Registry

A NOVA registry is **just a directory of files**. There is no registry server to run — anything
that can serve static files (GitHub raw, Bitbucket raw, S3, nginx, or a local folder) is a valid
registry. That keeps the whole system inspectable and impossible to lock anyone out of.

## Layout

```
registry/
  <pkg-name>/
    index.toml        # metadata + where the source lives
    <pkg-name>.nova   # the source itself (vendored — optional, see below)
```

`index.toml`:

```toml
[package]
name = "greet"
version = "0.1.0"
description = "Simple greeting library"
source = "greet/greet.nova"     # relative to the registry root

[dependencies]                  # optional — resolved TRANSITIVELY
someother = "1.0.0"
```

`source` may be either:

| Form | Resolved as |
|---|---|
| `greet/greet.nova` | relative to the registry root (**vendored** — works offline) |
| `https://host/path/greet.nova` | fetched directly over HTTP |

If `source` is omitted entirely, the resolver falls back to the convention
`<pkg-name>/<pkg-name>.nova`.

## Pointing NOVA at a registry

`NOVA_REGISTRY` selects the registry and accepts both a URL and a filesystem path:

```bash
# Use the registry bundled in this repo — no network needed
export NOVA_REGISTRY="/path/to/nova/packages/registry"

# Or your own host
export NOVA_REGISTRY="https://raw.githubusercontent.com/<you>/<repo>/main/registry/"
```

Unset, it falls back to the built-in default URL. Because it is an env var, you can retarget the
registry **without rebuilding the compiler**.

## Using packages

```bash
nova init                 # creates nova.toml
nova get greet            # adds greet to nova.toml and fetches it
nova install              # resolves everything in nova.toml, writes nova.lock
```

```nova
import greet

fn main()
    print(greet.greet("NOVA"))
```

`nova install` resolves **transitively** — a dependency's own `[dependencies]` are pulled in too,
and a dependency cycle terminates cleanly rather than hanging. The resulting `nova.lock` pins exact
versions so the next install (and CI) resolves identically, like `npm ci` / `cargo --locked`.

## Publishing this registry

The registry is static files, so publishing is just pushing a directory:

```bash
# from the repo root
cd packages
git init && git add registry && git commit -m "nova registry"
git remote add origin <your-remote>
git push -u origin main
```

Then point users at the raw base URL of `registry/`:

```
NOVA_REGISTRY=https://raw.githubusercontent.com/<you>/<repo>/main/registry/
```

Because sources are vendored beside their `index.toml`, one repo is enough — you do **not** need a
separate hosted repo per package.

## Bundled packages

| Package | Description |
|---------|-------------|
| greet | Simple greeting library |
| dotenv | Parse `.env` files into environment variables |
| uuid | UUID v4 generation |
| args | CLI argument parser |
| semver | Semantic versioning parser and comparator |

## Verification

`nova-compiler/test_programs/_pkg_install_gate.ps1` (wired into `nova_ci.ps1` as stage 2c2) proves,
offline and with no external host, that: install resolves and writes a lockfile; an installed
package is importable and produces correct output; transitive dependencies resolve; and a
dependency cycle terminates.

## Known limitation

Version constraints are recorded and pinned, but not yet *solved* — on a conflict the first
resolution wins rather than a semver-compatible intersection being computed. A real solver
(`nova-compiler/test_programs/nova_pkg.nova` has a semver implementation with caret/tilde matching)
is the next step. This is tracked, not forgotten.
