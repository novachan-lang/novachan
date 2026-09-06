# ▶ RESUME HERE — session paused 2026-09-06

Everything committed is **gated green**. The working tree is clean. Nothing is broken.

---

## Where we are in one line

**M3.4's foundation is complete and landed.** The compiler can compute a face's read-set and can
identify/validate a face. **Nothing consumes either yet** — that is the next step, and it was
just started.

---

## ✅ Landed and gated (all RED-tier: reconverge byte-identical + 3592 tests, both memory modes)

| commit | what |
|---|---|
| `fcf47864` | **`readset_of`** — given a function + struct param, the leaf fields it reads, transitively through callees, sliced through reconstructors |
| `b2fb2d8c` | **Control-flow coverage** — KAT 6→12 cases (`if` / `while` / `for` / `match`). Algorithm untouched; these verified a claim the code made about itself |
| `f6765c12` | **`@face`** — marks a face, enforces its contract at compile time: **E1320** (needs a struct param), **E1321** (must not read mutable module state), **E1322** (must not return its own state type = a reducer) |
| `3974a2a1` | **Concurrency guard** — CI/reconverge refuse to start while another NOVA run is active |

Verify at any time (takes seconds):

```
cd nova-compiler/test_programs && ./gen3_test.exe self-test
```

Expected:
```
readset_of: ALL 12 KAT CASES PASSED
@face contract: ALL KAT CASES PASSED
NOVA Self-Hosting Compiler: ALL TESTS PASSED
```

---

## ▶ THE NEXT STEP (was in progress when paused)

**§3's runtime bridge: emit each `@face`'s read-set into the generated program.**

Spec is written and ready in `PRISM_M3_4_REACTIVITY_DESIGN.md` **§18**. Two findings there matter:

1. **The precedent is exact — no new mechanism needed.** `@redact` already folds a bitmap at
   compile time (`nova_compiler.nova:26628`) and emits
   `call void @nova_rt_register_struct_redact(i64 hash, i64 mask)` (`:29364`), consumed by
   `nova_runtime.c:22296`. Read-set emission follows this pattern exactly.

2. ⛔ **A single 64-bit mask is NOT enough.** `PrismConState` has **134 reachable leaves** — and it
   is the acceptance target (§16.1). Use a **multi-word mask** (array of `i64`, word = leaf/64,
   bit = leaf%64). That keeps §3's performance argument (register-level AND, not a graph walk).

3. ⛔ **Determinism is load-bearing.** The leaf→bit order must come from **declared field order in
   a fixed traversal**, never dict/hash iteration — otherwise emitted IR varies per compile and
   **reconverge breaks**. This is the **first change that alters emitted output**, so reconverge
   will genuinely test it rather than pass trivially.

### Partial work from the interrupted attempt

Saved as **`NOVA_DESIGN/WIP_readset_emission.patch`** (308 lines: 249 compiler + 60 runtime).
It was **unverified and ungated**, so it was NOT committed — the tree was restored to the last
gated state instead.

**Treat that patch as a reference sketch, not a starting point.** Re-read it against §18 before
reusing; it never passed reconverge, so its determinism (the hard part) is unproven. Apply with
`git apply NOVA_DESIGN/WIP_readset_emission.patch` only after reading it.

### After this slice

§4b keyed invalidation → §9.6 Tier-1 aggregates (`count`/`sum`) → then **M0.3** (runtime split for
the browser, which is what makes PRISM an actual SPA framework).

---

## ⛔ Three environment landmines — all real, all cost hours. Read before debugging any failure.

**When a gate fails, ask "is it testing what I think it is?" BEFORE "what did I break?"**
All three of tonight's failures were a gate reporting something true about the **wrong artifact**.

1. **`exit=-1 timedout=False` on a step that runs fine by hand** = a concurrent or orphaned NOVA
   run. `_proc_util.ps1` rewrites `$NOVA_HOME/lib` and `/std` on *every* dot-source, so two
   concurrent runs corrupt each other's inputs. **Now guarded** — if CI refuses to start, that is
   the guard working. Do **not** set `NOVA_ALLOW_CONCURRENT=1`.
2. **A gate can fail *reproducibly* and still be testing the wrong compiler.** `_move_gate.ps1` and
   `_farray_perf_gate.ps1` silently prefer `_gen4.exe` if present. A **stale committed copy**
   (1.49 MB, predating the `move` feature) made the move gate test a compiler that rejects `move`
   outright. Refreshed for now, but the `Test-Path`-then-prefer pattern is still a live hazard.
3. **Never trust a wrapped exit code.** `cmd | tee log` or `cmd; echo done` reports the *last*
   command's status. Redirect (`> log 2>&1`) and append the real code into the **same** file
   (`echo "REAL_EXIT=$?" >> log`).

---

## Project state

- **PRISM library: complete** — 131 modules, 130 KATs, all green in one clean run.
- **Server-rendered UI works today** (HTML + CSS-as-typed-values + Forge APIs, no npm/build step).
- **Not yet an SPA** — needs the reactivity wiring above, then M0.3 for the browser.
- Docs: `PRISM_STATUS.md` (per-task), `EXECUTION_STATE.md` (**the file to read first each
  session**), `PRISM_M3_4_REACTIVITY_DESIGN.md` (§1–§18, the active design).
