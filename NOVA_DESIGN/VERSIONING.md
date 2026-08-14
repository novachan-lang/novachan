# NOVA Versioning and Packaging System

## Status: Active (v0.1.0)

## Overview

NOVA follows a Java/Rust-inspired versioning model where every component—compiler,
standard library, forge framework, and user packages—has an explicit version that
is checked at compile time. Version mismatches are caught early, not at link time
or runtime.

## Version Sources (Single Source of Truth)

| Component       | Authority           | Read by                    |
|-----------------|---------------------|----------------------------|
| Compiler        | `nova-compiler/VERSION` (plain text) | `nova_find_version()` at compile time |
| Stdlib          | `std/core/version.nova` → `stdlib_version()` | User programs at runtime   |
| Forge           | `std/core/version.nova` → `forge_version()` | User programs at runtime   |
| User packages   | `nova.toml` → `[package].version` | Compiler + package manager |
| ABI             | `abi_version()` builtin | Runtime compatibility      |

## Semantic Versioning (SemVer 2.0)

All NOVA versions follow [SemVer 2.0](https://semver.org/):
- `MAJOR.MINOR.PATCH[-prerelease][+build]`
- MAJOR: breaking changes (new syntax that invalidates old code)
- MINOR: backwards-compatible features (new builtins, new std/ modules)
- PATCH: bug fixes (compiler/runtime fixes, no API changes)

The `std/semver/` module provides full SemVer parsing, comparison, range matching
(caret, tilde, hyphen, wildcard), sorting, and validation.

## nova.toml — Project Manifest

Every NOVA project has a `nova.toml` at its root. Created by `nova init` or `nova new`.

```toml
[package]
name = "my-app"
version = "0.1.0"
nova-version = "0.1.0"       # minimum compiler version required
description = "A web service"
author = "dev"
license = "MIT"

[dependencies]
json = "0.2.0"
http = "0.1.3"
```

### Fields

| Field          | Required | Description |
|----------------|----------|-------------|
| `name`         | yes      | Package name (kebab-case) |
| `version`      | yes      | Package's own SemVer version |
| `nova-version` | no       | Minimum NOVA compiler version; warns on mismatch |
| `description`  | no       | One-line description |
| `author`       | no       | Author name or email |
| `license`      | no       | SPDX license identifier |
| `repository`   | no       | Source repository URL |

### Dependency format
```toml
[dependencies]
name = "version"     # exact version
name = ">=0.2.0"     # minimum version (future)
name = "^0.3"        # caret range (future)
```

## Module Resolution Order

When the compiler encounters `import std/core/str`, it searches these locations
in order (first match wins):

1. **Relative to importing file** — `<file_dir>/std/core/str.nova`
2. **Relative to CWD** — `std/core/str.nova`
3. **nova_packages/** — vendored local packages
4. **$NOVA_HOME** — `$NOVA_HOME/std/core/str.nova`, then `$NOVA_HOME/lib/std/core/str.nova`
5. **Exe-relative** — probes relative to the compiler binary:
   - `parent(exe_dir)/<name>.nova` — std/ at sibling level (gen3_test.exe in test_programs/)
   - `parent(exe_dir)/lib/<name>.nova` — lib/ at sibling level
   - `exe_dir/<name>.nova` — installed layout
   - `exe_dir/lib/<name>.nova` — installed layout

This means `import std/core/str` works from ANY directory without setting
`NOVA_HOME`, as long as the compiler binary is in its normal location relative
to the std/ tree.

## Compile-Time Version Check

When `nova build` or `nova run` compiles a file, the compiler reads `nova.toml`
from the source file's directory. If `nova-version` is set and the current
compiler version is older, a warning is printed:

```
warning: nova.toml requires nova-version 0.2.0 but this compiler is 0.1.0
  upgrade your NOVA toolchain or adjust nova-version in path/to/nova.toml
```

This is a WARNING, not an error — it lets development continue while flagging
the mismatch. Future: promote to error for major version mismatches.

## Package Manager Commands

| Command            | Description |
|--------------------|-------------|
| `nova init`        | Create nova.toml in current directory |
| `nova new <name>`  | Scaffold a new project with nova.toml |
| `nova install`     | Install all dependencies from nova.toml |
| `nova get <pkg>`   | Add and install a single package |
| `nova version`     | Print compiler version |

## Runtime Version API (`std/core/version`)

```nova
import std/core/version

fn main()
    print(nova_version())          // "0.1.0"
    print(stdlib_version())        // "0.1.0"
    print(forge_version())         // "0.1.0"
    let info = version_info()      // dict with all versions
    print(version_gte("0.2.0", "0.1.0"))        // true
    print(version_compatible("0.1.5", "0.1.0")) // true (same major)
```

## Future Work

- **Dependency version constraints**: caret (`^0.2`), tilde (`~0.2.1`), range (`>=0.2,<0.4`)
  — the `std/semver/` modules already support these; wire into the resolver.
- **SAT-based version resolution**: replace first-writer-wins with proper constraint solving.
- **Binary package distribution**: pre-compiled `.nova.pkg` bundles.
- **Edition system**: like Rust editions, to allow syntax evolution without breaking old code.
- **Lock file checksums**: integrity verification of downloaded packages.
- **Private registries**: corporate/air-gapped package hosting.
