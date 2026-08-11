# NOVA — Complete Command Reference

**Every command in this file was verified by execution or by reading the source on 2026-08-11.**
Anything not verified is explicitly marked `⚠ UNVERIFIED`. Nothing here is guessed.

Verification legend:
- ✅ **RUN** — I executed it and saw the output
- 📖 **SOURCE** — read from the script's own `param()` block / the compiler's dispatch
- ⚠ **UNVERIFIED** — listed for completeness, not confirmed

---

## 0. Paths you need (the #1 source of wrong commands)

| Thing | Actual location | Note |
|---|---|---|
| Live compiler source | `nova-compiler/compiler/nova_compiler.nova` | ~22k lines, self-hosted NOVA |
| C runtime source | `nova-compiler/compiler/nova_runtime.c` | sibling of the compiler |
| **Working compiler binary** | `nova-compiler/test_programs/gen3_test.exe` | this is what you run |
| Runtime object | `nova-compiler/compiler/nova_runtime.o` | also copies in `test_programs/` and `test_programs/output/` |
| SQLite object | `nova-compiler/compiler/sqlite3.o` | **needed to link ANY ORM program**, even a Postgres-only one |
| Process helper | `nova-compiler/test_programs/_proc_util.ps1` | ✅ **ONLY here** — NOT at repo root |
| Canonical gate | `nova-compiler/test_programs/nova_ci.ps1` | run from `test_programs/` |

> ⚠ **Trap:** `_proc_util.ps1` exists **only** in `nova-compiler/test_programs/`. Dot-sourcing it
> from the repo root or from `nova-compiler/` fails with "not recognized as the name of a cmdlet".
> Several scripts dot-source it via `$PSScriptRoot`, so they must be run from their own directory.

---

## 1. The `nova` CLI

✅ **RUN** — this is the binary's own usage output. Run with **no arguments** to print it.

> ⚠ **`--help` does NOT work.** The binary treats `--help` as a filename and reports
> `error: cannot read '--help': file not found`. Use no arguments instead.

```bash
# from nova-compiler/test_programs/
./gen3_test.exe                    # prints full usage
```

### Project commands

| Command | What it does |
|---|---|
| `nova new <name>` | Create a new project skeleton |
| `nova init` | Create `nova.toml` in the current directory |
| `nova build [file]` | Build project (or one file) to an executable. Defaults to `-O2` |
| `nova run [file]` | Build and run. Defaults to `-O0` |
| `nova test` | Run all `*_test.nova` files in `tests/` and `./` |
| `nova clean` | Remove `.ll` and `.exe` build artifacts |
| `nova fmt <file.nova>` | Format source (whitespace normalization) |
| `nova lint <file.nova>` | Static checks (tabs, line length, TODOs) |
| `nova check <file.nova>` | Parse + type-check only, no codegen — **fast** |
| `nova repl` | Interactive shell (compiles + runs `repl.nova`) |
| `nova debug <file.nova>` | Build with debug info and launch lldb |
| `nova bench <file.nova>` | Build, then time N runs (min/mean/max) |
| `nova cov <file.nova>` | Build with coverage, run, print per-line report |

### Single-file commands

| Command | What it does |
|---|---|
| `nova compile <file.nova>` | Compile to LLVM IR only |
| `nova emit <file.nova>` | Print generated LLVM IR to stdout (inspect codegen) |
| `nova wasm <file.nova>` | Compile to a runnable WebAssembly bundle (`.wasm` + JS loader) |

### Package commands

| Command | What it does |
|---|---|
| `nova get <package>[@ver]` | Add a dependency to `nova.toml` |
| `nova install` | Download all dependencies from `nova.toml` |

### Tools

| Command | What it does |
|---|---|
| `nova setup` | Pre-compile the build cache (one-time; makes builds instant) |
| `nova version` | Show version |
| `nova self-test` | Run the compiler self-test |
| `nova lsp` | Start the LSP server (IDE integration) |

### Options

| Option | Meaning |
|---|---|
| `-O0` | Disable optimizations (**default for `nova run`**) |
| `-O2` | Full optimizations (**default for `nova build`**) |
| `-o <output>` | Output file path |
| `--target <t>` | Cross-compile: `linux`, `linux-arm64`, `macos`, `macos-arm64`, `windows`, `windows-msvc`, `wasm` |
| `--old` | Use the legacy non-IR compiler |

`windows` = GNU/mingw ABI (the self-contained default). `windows-msvc` requires your own
separately-installed MSVC / Visual Studio Build Tools.

### Verified examples

✅ **RUN** (from `nova-compiler/test_programs/`, with `NOVA_HOME` set):

```bash
export NOVA_HOME="c:/Users/mange/Crypto/AI/New folder/New folder/nova-compiler"

./gen3_test.exe version              # -> NOVA v0.1.0 (self-hosted, IR pipeline)
./gen3_test.exe check hello.nova     # -> hello.nova: ok
./gen3_test.exe lint  hello.nova     # -> hello.nova: 0 warning(s)
./gen3_test.exe compile hello.nova   # -> Compiled: hello.nova -> hello.ll (target: x86_64-pc-windows-gnu)
./gen3_test.exe emit hello.nova      # -> LLVM IR on stdout
./gen3_test.exe hello.nova           # -> Compiled (IR): hello.nova -> hello.ll
```

> Note the **default target is `x86_64-pc-windows-gnu`**. If you then link with a clang whose
> default triple is MSVC you will see `warning: overriding the module target triple` — harmless.

---

## 2. Compile → link → run one file (the manual loop)

✅ **RUN** — used repeatedly and reliably this session.

```bash
cd nova-compiler/test_programs
export NOVA_HOME="c:/Users/mange/Crypto/AI/New folder/New folder/nova-compiler"

# 1. compile  (⚠ the .ll lands NEXT TO THE SOURCE, not in output/)
timeout 60 ./gen3_test.exe mytest.nova

# 2. link
timeout 90 clang -O2 -o output/mytest.exe mytest.ll \
    ../compiler/nova_runtime.o \
    -lws2_32 -ladvapi32

# 3. run  (kill-on-timeout is MANDATORY)
cd output && timeout 15 ./mytest.exe
```

### Required link libraries

| Situation | Add to the clang line |
|---|---|
| Always | `../compiler/nova_runtime.o` |
| Any networking / most Forge code | `-lws2_32` |
| Crypto / `CryptAcquireContextW` | `-ladvapi32` |
| **Anything importing `forge_orm`** | `../compiler/sqlite3.o` ← required even for a Postgres-only app |

> ⚠ **Trap:** omitting `-ladvapi32` gives `undefined symbol: CryptAcquireContextW`.
> Omitting `sqlite3.o` on an ORM program gives ~16 `undefined symbol: sqlite3_*` errors even
> if you never touch SQLite, because `forge_orm` links all three drivers.

---

## 3. The gates (what you must run before committing)

### 3.1 Full CI gate — the authoritative pre-commit gate

📖 **SOURCE** `nova-compiler/test_programs/nova_ci.ps1`, `param([switch]$SkipReconverge, [switch]$Quick, [switch]$SkipPerfTrack)`

```powershell
cd nova-compiler\test_programs
powershell -ExecutionPolicy Bypass -File .\nova_ci.ps1 [-SkipReconverge] [-Quick] [-SkipPerfTrack]
```

Three stages, fails fast, non-zero exit on any failure:

| Stage | What it proves |
|---|---|
| 1. Bootstrap reconverge | `gen5.ll == gen6.ll` — compiler self-consistency; **installs gen5** as `gen3_test.exe` |
| 2. Perf-regression gate | scalar/float/struct stay C-level native (no re-boxing) |
| 3. Full regression | the whole test suite (see the FULLRC note below) |

| Switch | Effect |
|---|---|
| `-SkipReconverge` | Skips stage 1. Prints a loud warning. **Safe ONLY for test/doc-only changes** — never for a commit touching `nova_compiler.nova` or the runtime |
| `-Quick` | Skips the second stage-3 pass |
| `-SkipPerfTrack` | Skips stage 2 |

✅ **RUN** — a full pass (`-SkipReconverge`) measured **2850 PASS / 0 FAIL / 0 SKIP**, wall time
**2063 s (~34 min)**. Budget ~50+ min with reconverge.

> ### ⚠ KNOWN GATE DEFECT — "both memory modes" is currently ONE mode run twice
>
> 📖 **SOURCE**, verified three ways. `nova_ci.ps1` stage 3 unsets `NOVA_T8_FULLRC` for pass 1
> and sets `NOVA_T8_FULLRC=1` for pass 2. But:
> - the compiler reads **`NOVA_NO_FULLRC`**, not `NOVA_T8_FULLRC` (`nova_compiler.nova:23782`)
> - FULLRC is **default-ON** (the pass runs *unless* `NOVA_NO_FULLRC=1`)
> - `NOVA_T8_FULLRC` appears in the runtime and compiler **only inside comments**; there is no
>   `#ifdef NOVA_T8_FULLRC` in `nova_runtime.c` and no runtime `getenv` for it, so building the
>   runtime with `-DNOVA_T8_FULLRC=1` is also a **no-op**
>
> Consequence: both stage-3 passes run with FULLRC **on**. The "regression both modes" claim in
> the final banner is not currently true, ~28 min per run is spent re-running an identical pass,
> and the genuine non-FULLRC path is untested. Note also that `leak_baseline_test.nova` *asserts
> FULLRC drops ARE firing*, so simply flipping pass 1 to `NOVA_NO_FULLRC=1` would fail that test —
> a real fix needs the test to become mode-aware. **Tracked, not yet fixed.**

### 3.2 Regression suite alone

📖 **SOURCE** `_run_final_regression.ps1`, `param([switch]$ForgeOnly, [switch]$NoServer)`

```powershell
cd nova-compiler\test_programs
powershell -ExecutionPolicy Bypass -File .\_run_final_regression.ps1 [-ForgeOnly] [-NoServer]
```

| Switch | Effect |
|---|---|
| `-ForgeOnly` | Only tests whose source `import`s a forge module — the fast gate for forge-library work |
| `-NoServer` | Skips the serial server-integration tests |

Structure: a **parallel** batch (up to `min(16, cores-2)` jobs), then a **serial** phase for
server-binding tests (they each run a real in-process TCP server and starve each other in parallel).
Per-test timeouts: compile 150 s, link 300 s, run 60 s. A test whose `.nova` file is missing is
reported as SKIP.

### 3.3 Reconverge alone (the deepest correctness proof)

📖 **SOURCE** `_bootstrap_reconverge_slow.ps1` — 3-pass; sets `NOVA_NO_CACHE=1`; confirms
`gen5.ll == gen6.ll` and installs gen5 as `gen3_test.exe`.

```powershell
cd nova-compiler\test_programs
powershell -ExecutionPolicy Bypass -File .\_bootstrap_reconverge_slow.ps1
```

Passes: `gen3_test.exe` → gen4 (`nova_p1`) → gen5 → gen6, comparing the emitted `.ll`.
The `_slow` variant uses compile timeout 900 000 ms (15 min) and link 240 000 ms (4 min) because
the `nova_compiler.nova` self-compile takes ~9 min on this host. A non-`_slow`
`_bootstrap_reconverge.ps1` also exists with 450 000 / 120 000 ms timeouts.

> **Compare `.ll` files, never `.exe` SHAs.** Executables embed non-determinism; the IR is the fixpoint.

### 3.4 Mandatory: kill-on-timeout

📖 **SOURCE** `nova-compiler/test_programs/_proc_util.ps1`

`Process.WaitForExit(ms)` **returns** on timeout but does **not kill** the process. A hung binary
pins a CPU core forever; dozens once blocked the whole machine. Every script that launches a NOVA
compiler or test binary MUST use `Invoke-Timed`.

```powershell
cd nova-compiler\test_programs
. .\_proc_util.ps1

Invoke-Timed -FilePath <string> [-Arguments <string>] [-TimeoutMs <int>] [-WorkingDirectory <string>]
Stop-StrayCompilers      # kills orphaned builds from an aborted run
```

Exact parameter names — ✅ verified against the `param()` block:

| Param | Type | Default |
|---|---|---|
| `-FilePath` | string, **mandatory** | — |
| `-Arguments` | string | `""` |
| `-TimeoutMs` | int | `30000` |
| `-WorkingDirectory` | string | `$PSScriptRoot` |

Returns an object exposing `.ExitCode` and `.TimedOut`. Reads stdout/stderr asynchronously so a
full pipe can never deadlock the child.

> ⚠ **Trap:** the params are `-FilePath` / `-Arguments` / `-TimeoutMs`.
> They are **NOT** `-Path` / `-Args` / `-TimeoutSec`. Using the wrong names fails silently-ish
> with "Invoke-Timed is not recognized" style errors or a parameter-binding error.

From bash, prefer plain `timeout <sec> <cmd>` — simpler and equally safe.

---

## 4. Building and running an application (worked example: TaskBoard)

✅ **RUN** — the full sequence below was executed this session and the server served HTTP 200.

App: `nova_taskboard/` — `app.nova` (entry), `db.nova` (ORM layer), `models.nova`,
`routes_api.nova`, `routes_web.nova`, `routes_forms.nova`, `views.nova`, `nova.toml`.

```bash
cd nova_taskboard

# 1. compile
timeout 60 ../nova-compiler/test_programs/gen3_test.exe app.nova
#    -> Compiled (IR): app.nova -> app.ll

# 2. link  (sqlite3.o is REQUIRED even though this app uses PostgreSQL)
timeout 60 clang -O2 -o app.exe app.ll \
    ../nova-compiler/nova_runtime.o \
    ../nova-compiler/compiler/sqlite3.o \
    -lws2_32 -ladvapi32

# 3. selfcheck (no server; dispatches two requests in-process and exits)
timeout 15 ./app.exe --check
#    -> selfcheck status=200 / api check status=200 / TaskBoard: selfcheck PASS

# 4. run the server
./app.exe
#    -> TaskBoard running on http://localhost:8080
```

Endpoints (✅ all returned 200):

| URL | Purpose |
|---|---|
| `http://localhost:8080/` | Dashboard |
| `http://localhost:8080/api/v1/` | REST API |
| `http://localhost:8080/api/v1/stats` | Stats |
| `http://localhost:8080/health` | Health check |

`PORT` env var overrides the default `8080` (`app.nova` `_port()`).

> ⚠ **Before blaming the runtime for a "crash", run `netstat -ano | grep :8080`.** A previously
> reported ORM segfault turned out to be two stale `app.exe` processes both listening on 8080.

---

## 5. Databases

✅ **RUN** — all three probed live on 2026-08-11 through `forge_orm`.

| Driver | DSN used by the tests | Status on this box |
|---|---|---|
| SQLite | `sqlite://path/to.db` | ✅ live (embedded via `sqlite3.o`) |
| PostgreSQL | `postgres://postgres:root@127.0.0.1:5432/postgres` | ✅ live on :5432 |
| MySQL | `mysql://root:root@127.0.0.1:3306/nova_test` | ✅ live on :3306 |

TaskBoard's own DSN: `postgres://postgres:root@localhost:5432/taskboard` (pool size 8).

Some test suites skip their live-PG arm unless `PGPASSWORD` is set — set it to exercise them.

---

## 6. Environment variables

📖 **SOURCE** — grepped from `nova_runtime.c` (`getenv`), `nova_compiler.nova` (`env(`), and the gate scripts.

### Read by the compiler

| Var | Effect |
|---|---|
| `NOVA_HOME` | Root for module resolution — **set this or `import forge`/`import std/...` fails** |
| `NOVA_NO_CACHE` | `1` disables the build cache (the gates set this for determinism) |
| `NOVA_NO_FULLRC` | `1` **disables** the total-RC Stage-3 drop pass. FULLRC is **default-ON** |
| `NOVA_CLANG` | Override the clang binary used for linking |
| `NOVA_RUNTIME` | Override the runtime object path |
| `NOVA_REGISTRY` | Package registry URL |
| `NOVA_TI_STRICT` | Strict type inference (strict is already the default) |
| `NOVA_COV`, `NOVA_DBG`, `NOVA_DWARF_VARS` | Coverage / debug-info emission |
| `NOVA_TRACK8`, `NOVA_NO_TRACK8`, `NOVA_T8_W8`, `NOVA_T8_NO_DROP` | Track-8 RC tuning |
| `NOVA_NO_SROA` | Disable scalar-replacement-of-aggregates |
| `NOVA_AUTO_ARENA`, `NOVA_S4_ESCAPE`, `NOVA_ESCAPE_STATS` | Escape-analysis / arena tuning |
| `NOVA_S5_ABI`, `NOVA_S5_HOF`, `NOVA_STRUCT_RET` | ABI / HOF / struct-return specialization |
| `PORT` | Default server port for apps that read it |

### Read by the C runtime

| Var | Effect |
|---|---|
| `NOVA_CARRIERS` | Number of scheduler carrier threads (`4`/`8` are the tested N>1 values) |
| `NOVA_CARRIER_STATS` | Dump carrier statistics |
| `NOVA_GREEN` | Green-thread scheduler toggle |
| `NOVA_SCHED_WATCHDOG`, `NOVA_SCHED_RECLAIM_TASK` | Scheduler watchdog / task reclaim |
| `NOVA_HEAP_PROFILE` | Heap profiling |
| `PATH`, `TMPDIR` | Standard |

### Used by the gate scripts

| Var | Effect |
|---|---|
| `NOVA_REGRESSION_COMPILER` | Use a different compiler binary than `gen3_test.exe` |
| `NOVA_T8_FULLRC` | ⚠ **DEAD** — set by `nova_ci.ps1` but read by nothing. See the gate defect in §3.1 |

---

## 7. Benchmarks

📖 **SOURCE** — `nova-compiler/` contains the benchmark drivers:

`bench.ps1`, `bench_all.ps1`, `bench_quick.ps1`, `bench_vs_c.ps1`, `bench_c.ps1`,
`bench_compute.ps1`, `bench_alloc.ps1`, `bench_iter.ps1`, `bench_int_vs_c.ps1`,
`bench_num_vs_c.ps1`, `bench_num_o3.ps1`, `bench_final.ps1`, `bench_fib_only.ps1`,
`bench_dict_only.ps1`, `bench_compile_speed.ps1`, `bench_single_compile.ps1`

```powershell
cd nova-compiler
powershell -ExecutionPolicy Bypass -File .\bench_quick.ps1     # fastest sanity benchmark
powershell -ExecutionPolicy Bypass -File .\bench_vs_c.ps1      # NOVA vs C comparison
```

Also: `nova bench <file.nova>` times N runs of a single program.
History is recorded in `bench/history.jsonl`.

⚠ **UNVERIFIED**: I did not execute these this session, so their individual switches are not confirmed.

Performance tolerances the gate enforces (from the project's compiler-architecture rules):

| Benchmark | Max overhead vs C `-O2` |
|---|---|
| `fib(40)` | < 5 % |
| `sum_to(1B)` | < 2 % |
| `sieve(10M)` | < 10 % |
| `matmul(300)` | < 10 % |
| sequential primes(1M) | < 10 % |
| parallel 4-worker | > 1.8× speedup |

---

## 8. Other build scripts

📖 **SOURCE** — present in `nova-compiler/`:

| Script | Purpose |
|---|---|
| `build.ps1` | Build the compiler |
| `bootstrap_test.ps1` | Bootstrap verification |
| `build_gate4.ps1` | GATE-4 (erasure/perf) build |
| `build_and_test_spawn.ps1` | Concurrency spawn build + test |

`nova-compiler/test_programs/` holds ~600 `.ps1` files — the great majority are per-test or
per-investigation helpers, not user-facing entry points. The canonical ones are the four in §3.

⚠ **UNVERIFIED**: switches for the scripts in this section were not confirmed by execution.

---

## 9. Cross-platform / Linux

The gate is **Windows-only**, which has historically hidden Linux-only bugs (e.g. `str(n<10000)`
once returned `""` only on Linux). WSL2 **Ubuntu** is installed and works on this box
(`wsl -d Ubuntu -e uname -m` → `x86_64`), and outbound network is up.

```bash
wsl -d Ubuntu -e uname -m       # -> x86_64
```

For runtime work, build and RUN in WSL **Ubuntu** (not Kali).
Cross-compile from Windows with `--target linux` / `--target linux-arm64`.

CI workflows live in `.github/workflows/` (incl. `cross-platform.yml`), but the repo's remote is
**Bitbucket**, so GitHub-hosted runners do not currently execute.

---

## 10. Quick recipes

```bash
# Type-check fast, no codegen
./gen3_test.exe check myfile.nova

# See the generated LLVM IR
./gen3_test.exe emit myfile.nova | head -50

# Full pre-commit gate for a COMPILER or RUNTIME change (~50+ min, mandatory)
cd nova-compiler/test_programs
powershell -ExecutionPolicy Bypass -File ./nova_ci.ps1

# Fast gate for a FORGE-LIBRARY change only
powershell -ExecutionPolicy Bypass -File ./_run_final_regression.ps1 -ForgeOnly

# Rebuild the C runtime after editing nova_runtime.c
cd nova-compiler
clang -O2 -c compiler/nova_runtime.c -o nova_runtime.o
#   then copy to the places that need it:
cp nova_runtime.o test_programs/nova_runtime.o
cp nova_runtime.o test_programs/output/nova_runtime.o

# Make builds instant (one-time)
./gen3_test.exe setup
```

> ⚠ **Stale-runtime trap:** there are ~10 copies of `nova_runtime.c`/`.o` in the tree. Only
> `nova-compiler/compiler/nova_runtime.c` is live. A link error about a symbol you *know* you just
> added means you are linking the wrong copy.

---

## 11. Definition of Done (project rule)

A change is done only when **all** of these hold:

1. Implemented to standard (high-level NOVA; secure; no UB)
2. Gated green — the cadence matching its blast radius:
   - **GREEN** (builtin / KAT / doc) → fast light gate
   - **YELLOW** (bounded feature) → KAT + relevant gate + spot-check
   - **RED** (compiler / runtime / type system / soundness) → **FULL ARC**: reconverge
     `gen5.ll == gen6.ll` + full regression + N>1 + adversarial verification
3. KAT wired (a known-answer test against an authoritative vector)
4. `NOVA_DESIGN/EXECUTION_STATE.md` ticked **in the same commit**
5. Any contradicted doc corrected

`NOVA_DESIGN/EXECUTION_STATE.md` is the single live tracker — read it first, tick it with the work.

---

## Appendix — corrections this file makes to earlier assumptions

Recorded because each one silently produced a broken command during this session:

| Wrong assumption | Verified reality |
|---|---|
| `_proc_util.ps1` is at the repo root | It is **only** at `nova-compiler/test_programs/_proc_util.ps1` |
| `Invoke-Timed -Path/-Args/-TimeoutSec` | It is `-FilePath` / `-Arguments` / `-TimeoutMs` / `-WorkingDirectory` |
| `nova --help` prints usage | `--help` is read as a **filename**; run with **no args** instead |
| The compiled `.ll` lands in `output/` | It lands **next to the source file** |
| `NOVA_T8_FULLRC=1` enables leak-checking mode | It is read by **nothing**; the real var is `NOVA_NO_FULLRC` and FULLRC is default-**ON** |
| Linking a Postgres app needs no SQLite | `forge_orm` links all 3 drivers → `sqlite3.o` is **always** required |
