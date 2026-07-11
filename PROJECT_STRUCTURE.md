# NOVA — Project Structure (the shared map: what/where/why)

NOVA is **one language + one framework**, built by two people. This file is the single source of truth for
**where everything lives and why**, so we never lose the coherent whole. (Roadmap = `NOVA_DESIGN/
NOVA_MASTER_PLAN_2026_07_10.md`; live task tracker = `NOVA_DESIGN/EXECUTION_STATE.md`.)

## The layers (keep these three straight — conflating them was a real past mistake)
1. **The language** — the self-hosted NOVA compiler + runtime + standard library.
2. **The framework** — Forge (web framework), in `forge/`. Separate from the language. **Untouched unless asked.**
3. **Runtime builtins** — native functions compiled into every binary (math, PRNG, I/O), in `nova_runtime.c`.

## Repo map (as-is, after the std/ reorganization)
```
std/                         ← THE NOVA STANDARD LIBRARY, hierarchical by category (import std/<cat>/<name>)
  numeric/    bignum (signed), nat (unsigned/naturals), rational, complexnum, matrixx
  crypto/     blake2b
  collections/ hamt, pvecx, bitset, setops, collx
  text/       xml, strx, urlx, csvx, graphemex
  encoding/   basex
  core/       corex, getin
  util/       prng, uuid, coro
forge/                       ← the FORGE FRAMEWORK (web) — separate from the language, owner's domain
NOVA_DESIGN/                 ← the master plan + design docs + the live execution ledger
bench/                       ← benchmarks
nova-compiler/               ← the compiler's build home (see "the honest reality" below)
  test_programs/
    nova_compiler.nova       ← THE self-hosted compiler (~22k lines, written in NOVA)
    output/nova_runtime.c    ← THE C runtime
    gen3_test.exe            ← the pinned bootstrap binary
    *.ps1                    ← build / CI / reconverge scripts (nova_ci, _proc_util, _build_gen4, …)
    *_test.nova              ← test programs
    lib/  std/               ← installed toolchain copies (synced, gitignored)
```

## How it's built (the pipeline)
source → **lexer → parser → type inferencer (`TiState`, Hindley-Milner) → IR (`IrBuilder`) → 2 LLVM backends
→ native**. The runtime (`nova_runtime.c`) provides memory (RC + arena, with a leak-checking **FULLRC** mode),
values, concurrency, builtins.

## How it's verified (why the process is what it is)
Because the compiler is **self-hosted**, any compiler change must survive compiling *itself* unchanged — the
**reconverge**: `gen5.ll == gen6.ll` byte-identical. It's the only check that catches the deep bugs (it once
caught a UAF nothing else could), so it gates every compiler change. Full arc = `nova_ci.ps1` (reconverge +
regression in **both** memory modes + ASAN). Rhythm: fast per-task verify (gen4 probe / KAT), **full arc every
~30 tasks**. Pure-NOVA stdlib modules touch no compiler → no reconverge.

## Module resolution (LOCK-1)
`import std/<category>/<name>` resolves `$NOVA_HOME/std/<category>/<name>.nova` (the `std/` tree is bundled
into the toolchain, like `forge/` → `lib/`). Bare `import forge` still resolves from `lib/`. Path segments use
`/`; the default alias is the last segment.

## The honest reality about `nova-compiler/test_programs/`
The compiler + runtime + build scripts + tests currently live inside a directory named `test_programs/` — a
scratch dir. A textbook layout would be `compiler/ runtime/ tools/ tests/`. **We are deliberately NOT
relocating them right now**, because: `gen3_test.exe`, `output/nova_runtime.c`, and `nova_compiler.nova` are
hardcoded across the core build chain, the bootstrap, and the compiler's own path logic — moving them risks
breaking self-hosting for a purely *internal* gain (users of NOVA never see this directory; they see `std/`
and `forge/`, which ARE properly organized). If we ever do it, it's a dedicated, carefully-staged,
reconverge-gated project — not interleaved with feature work. This is a conscious risk/reward call, recorded
here so it's a decision, not drift.

## Quick "where do I put X?"
- A new **stdlib** capability → `std/<category>/<name>.nova` + a `_<name>_test.nova` (KAT) + orphan manifest.
- A new **native builtin** → `nova_runtime.c` fn + register in `nova_compiler.nova` (name-map, type, 2 LLVM
  declares, raw-double list if it returns float) → reconverge.
- A **Forge/framework** feature → `forge/` (owner's domain).
- Design/plan → `NOVA_DESIGN/`. Progress → tick `NOVA_MASTER_PLAN` + update `EXECUTION_STATE.md`.
