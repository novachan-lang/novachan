# Cross-Platform CI — Issue Register

**Audit date:** 2026-08-25 · **Scope:** `.github/workflows/cross-platform.yml`, `release.yml`
**Method:** read-only inspection of the workflow + the artifacts it consumes. No workflow was run
(the local arc was mid-flight), so every finding below is STATIC — confirmed against the repo, not
against a live run. Anything needing a live run is marked ▲ UNVERIFIED.

**Why this file exists:** GitHub gives us `ubuntu-latest` and `macos-latest` runners for free, and
`macos-latest` is now ARM64 — so Linux, macOS and ARM coverage are all reachable without buying
hardware. That would move WEAPON_PARITY items 5.1 / 5.2 / 5.7 out of "blocked on hardware", which is
where they have been sitting. The workflow already targets those runners. It just does not work.

---

## X-1 · macOS self-hosted job CANNOT RUN — builds from an untracked file · **BLOCKER**

`cross-platform.yml:344`
```
clang -O2 -o nova nova_compiler.ll nova_runtime.c -lm -Wno-everything -D_DARWIN_C_SOURCE
```
`nova_compiler.ll` is **not tracked by git** — not committed, and not even gitignored (it exists only
as a local build product). On a fresh runner checkout the file is absent, so this step fails at
`clang: no such file or directory`.

Evidence:
```
git ls-files -- nova-compiler/compiler/nova_compiler.ll   -> (empty)
git cat-file -e HEAD:nova-compiler/compiler/nova_compiler.ll -> NO
git ls-files -- 'nova-compiler/compiler/*.ll'             -> nova_compiler_linux.ll   (only this one)
```

So the macOS self-hosted job has **never been able to pass**. The Linux job at line 65 does this
correctly — it consumes the tracked `nova_compiler_linux.ll` and even guards the target triple:
```
grep -q 'x86_64-unknown-linux-gnu' nova_compiler_linux.ll || { echo "bootstrap IR is not Linux-targeted"; exit 1; }
```

**Fix:** commit a macOS-targeted seed (`nova_compiler_macos.ll`) and consume it with the same
triple guard (`arm64-apple-darwin` / `x86_64-apple-darwin`). Generate it from the SAME commit as the
Linux seed so the two cannot drift apart.

---

## X-2 · The Linux bootstrap seed is 18 days STALE · **HIGH**

`nova_compiler_linux.ll` was last committed **2026-08-07** (`ab362bd7`). Everything since is absent
from it — the cross-module `-> bool` fix, param-type chaining, `bytes_view`, the declared-`any`
return rule, the box-aware `min`/`max`.

So the Linux job is green against a compiler that is **three weeks behind master**. It is not
testing Linux support for the current compiler; it is testing that an old artifact still builds.
A green tick here is actively misleading, which is worse than no job at all.

**Fix:** regenerate both seeds as part of the RELEASE flow (or a `make seeds` target) so they cannot
rot silently, and add a staleness guard — fail the job if the seed's embedded compiler version does
not match the checked-out source. A seed that must be refreshed by hand WILL go stale; that is what
happened here.

---

## X-3 · Three of six jobs test the DEAD Kotlin compiler · **HIGH**

`linux-test` (206), `macos-test` (450) and `determinism-check` (574) all build via:
```
cd nova-compiler && ./gradlew fatJar --no-daemon -q
```
That is the **original Java/Kotlin bootstrap**. Per CLAUDE.md it is historical — the live compiler is
the self-hosted `nova_compiler.nova`, which self-compiles to a byte-identical fixpoint.

So half the cross-platform matrix exercises a compiler that is no longer the product. Whatever those
jobs prove, they do not prove the shipping compiler works on Linux or macOS. `determinism-check` is
the worst of the three: determinism of the DEAD compiler's output tells us nothing about the
reconverge property that actually guards the live one.

**Fix:** repoint all three at the self-hosted compiler, or delete them. Keeping them is worse than
deleting them — they consume runner minutes and produce green ticks that mean nothing.

---

## X-4 · Non-Windows coverage is 62 tests out of 3584 — **1.7%** · **HIGH**

Every cross-platform job runs a hand-listed `TESTS=(...)` array:

| job | tests |
|---|---|
| windows-full-regression | 62 |
| linux-selfhosted | 62 |
| linux-test | 62 |
| macos-selfhosted | 62 |
| macos-test | 62 |
| determinism-check | 6 |

The live suite is **3584** tests per mode. So a platform-specific defect has a ~98% chance of not
being covered. And the list is hand-maintained, so it does not grow when the suite grows — the
+721 tests added on 2026-08-25 are invisible to every platform but Windows.

The job's own comment says *"full 114-test regression"*. The real number is 62 in the array and 3584
in the suite, so that comment has been wrong in both directions for a long time.

**Fix:** drive the platform jobs from the SAME source of truth as the local runner — the curated
lists plus `_orphan_coverage_manifest.txt` — rather than a copy-pasted array. Then coverage tracks
the suite automatically. If full runtime on a hosted runner is too slow, subset it by a documented
rule (e.g. every test that does not need a live DB), not by an ad-hoc list nobody updates.

---

## X-5 · No reconverge, and no FULLRC, on any platform · **MEDIUM**

The two checks that actually catch NOVA's deepest bugs are absent from cross-platform CI:
- **reconverge** (gen5.ll == gen6.ll byte-identical) — the only check that caught the struct-field
  use-after-free; nothing else could.
- **NOVA_T8_FULLRC** (leak-checking mode) — half of the local mandatory gate.

Both are Windows-only today. A platform-specific memory bug — precisely the kind that differs
between msvcrt, glibc and Apple libc — is therefore invisible.

**Fix:** run reconverge on at least one non-Windows platform. It is the highest value-per-minute
check available, and it needs no test list to maintain.

---

## X-6 · `release.yml` publishes artifacts these broken jobs never validated · ▲ UNVERIFIED

`release.yml` (8.5 KB) builds the shipped toolchains. Given X-1 and X-3, the macOS artifact is built
by a path no working CI job covers. Needs a live-run check before trusting any macOS release.

---

## Priority

1. **X-1** — commit a macOS seed. Without it, macOS CI is fiction.
2. **X-2** — refresh + auto-generate both seeds. Without it, Linux CI is theatre.
3. **X-3** — repoint or delete the three Kotlin jobs.
4. **X-5** — add reconverge to Linux (cheap, highest value).
5. **X-4** — derive the test list from the manifest instead of a copy-paste array.
6. **X-6** — verify with a live run.

X-1 through X-3 are the ones that make the difference between "we have cross-platform CI" and "we
have cross-platform CI that means something". None of them require touching the compiler.

## Note on sequencing

Nothing here has been changed yet — this is the register only. The macOS/Linux seeds must be
generated from a COMMITTED compiler state, so the right moment is immediately after the current
batch lands, not before.
