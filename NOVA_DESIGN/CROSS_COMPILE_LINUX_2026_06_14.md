# NOVA Cross-Compile to Linux x86_64 -- VERIFIED 2026-06-14

Summary: NOVA programs now cross-compile from this Windows host to genuine Linux
x86_64 ELF binaries and RUN CORRECTLY on Linux (verified in WSL2 Ubuntu). This is the
first verified execution of NOVA on a second platform -- the "runs ANYWHERE" charter
non-negotiable, demonstrated concretely rather than claimed. (iter-64, frontier
re-audit's #3 pick once WSL was confirmed available as a run-oracle.)

## What was actually broken (and fixed)

NOVA had only ever been BUILT on Windows, so the entire non-Windows runtime path had
latent compile breaks -- code that existed but had never been compiled. Found by
compiling output/nova_runtime.c under Linux gcc (WSL Ubuntu, gcc 13.3.0):

  1. Missing POSIX includes (the linux branch used the symbols but never included the
     headers): waitpid needed <sys/wait.h>; dlopen/dlsym/dlclose + RTLD_NOW/RTLD_LOCAL
     needed <dlfcn.h>. Added both inside the existing #else (non-_WIN32) include block
     -- invisible to Windows (preprocessor skips the whole #else).

  2. Fiber context-switch asm syntax: the POSIX x86_64 nova_asm_switch (the
     #elif defined(__x86_64__) branch, never compiled on Windows because _WIN32 takes
     the first branch) used %%reg register escaping -- that is EXTENDED-asm syntax and
     gcc rejects it in a basic-asm naked function ("bad register name %%rbx"). Fixed to
     single-% AT&T basic-asm syntax (pushq %rbx ... movq %rsp,(%rdi) ... retq). Pure
     syntactic fix; the callee-saved save/restore + rsp swap logic is unchanged.

Both fixes are non-Windows-only, so the Windows build is byte-identical (the runtime
reconverges to the same fixpoint 3F75D36A and the regression is unchanged).

## The cross-build pipeline (no installs required)

The NOVA-generated .ll hardcodes target triple = x86_64-pc-windows-msvc with a Windows
datalayout (m:w / COFF), but the function bodies carry NO explicit calling conventions
-- the CC is applied per-target at codegen, and the Win64 vs Linux-SysV integer/pointer
layout is identical. So the .ll is portable after a header rewrite. _xc_build_run.ps1:

  1. gen3 (Windows) compiles Src.nova -> Src.ll
  2. rewrite the .ll header: triple -> x86_64-unknown-linux-gnu; datalayout m:w -> m:e
  3. Windows clang lowers the linux-.ll -> Src_linux.o (IR -> ELF object; needs NO
     sysroot, since lowering IR to an object emits no header dependencies)
  4. WSL Ubuntu gcc compiles nova_runtime.c (it has the Linux headers) and links
     Src_linux.o + nrt.o -> a Linux ELF, with -lpthread -lm -ldl
  5. WSL runs the ELF

WSL gcc serves as the Linux sysroot + linker + run host. A pure-Windows cross-build
(clang + a bundled Linux sysroot, no WSL) is the natural follow-up now that the runtime
and codegen are proven portable -- it only needs a sysroot, not any code change.

## Verified output (WSL2 Ubuntu, gcc 13.3.0)

(1) A 2-function program exercising the portability-sensitive paths produced, on Linux:

  hello from NOVA on linux
  sum 1..10 = 55            (while loop)
  3.5 * 2.0 = 7.0           (float ABI -- xmm registers, SysV)
  add(20, 22) = 42          (SysV calling convention, multi-arg function call)
  list sum = 10             (for-in over a list -> runtime list calls)
  exit=0
  file: ELF 64-bit LSB pie executable, x86-64, SYSV, for GNU/Linux 3.2.0

Calling convention, float ABI, loops, and runtime list ops are all correct on Linux ->
the cross-compile is genuinely sound, not a trivial puts() echo.

(2) THE FLAGSHIP: green_scale_test cross-built + run on Linux produced

  phase1 OK: 10000 green tasks fanned in, sum=10000
  phase2 OK: 10000 parked tasks woken, sum=50005000 (expected 50005000)
  GREEN SCALE PASS: 10000 green tasks x2 phases on the M:N scheduler
  exit=0

This is the decisive result: it drives spawn/channels -> green tasks -> the POSIX
x86_64 nova_asm_switch (the fiber asm fixed this iteration) -> the netpoller (epoll on
Linux) parking + waking 10k tasks. So the M:N green scheduler RUNS CORRECTLY on Linux
x86_64 -- the fiber context-switch asm fix is verified correct at runtime (not merely
compilable), and NOVA's flagship concurrency is proven on a second platform.

## Broad portability sweep (iter-65) -- 40/40 tests pass on Linux

To prove the port is real across features (not cherry-picked), a representative batch of
40 regression tests was cross-built and run in WSL Ubuntu via _xc_sweep.ps1 + _xc_sweep.sh
(gcc builds nova_runtime.o once; each test's linux .o is linked + run with kill-on-timeout
from the test dir; a test PASSES iff it exits 0, since the regression tests self-assert).
The batch spanned: floats/strings/unicode, dicts/sets, structs + auto-show, closures/HOFs,
generics, traits, match/enums/guards, math/bignum, bitwise, ranges, tuples/destructuring,
Result/error handling, spawn + supervisor (concurrency), generators (yield), JSON + float
soundness, file-IO (read_bytes), tensors + the MLP classifier, and str/int soundness guards.

Result: 40/40 PASS on Linux x86_64.

The sweep surfaced exactly one REAL cross-platform bug, now fixed:

  sort_by was NONDETERMINISTIC across platforms. It used qsort (unstable) with a
  comparator returning 0 on equal keys, and glibc vs MSVCRT order tied keys differently --
  so sort_by(by a non-unique key) gave platform-dependent results (stdlib_test's
  sort-3-words-by-length, with two len-6 ties, passed on Windows but failed on Linux).
  A language promising "same code, same result everywhere" must not have this. FIX: made
  nova_rt_sort_by STABLE -- precompute each element's key once (n closure calls, not
  O(n log n)), then a stable merge sort that takes the LEFT run on ties (preserving input
  order for equal keys), with an OOM fallback to qsort. Now deterministic on every
  platform (matching Python/Rust/modern-JS stable-sort semantics). The compiler never
  calls sort_by, so this reconverges byte-identical to 3F75D36A; Windows regression
  426/426 0-SUSPECT (stdlib_test updated to the deterministic stable order).

## Scope / remaining

  - PROVEN: NOVA codegen + runtime are portable to Linux x86_64; real programs run,
    INCLUDING the M:N green scheduler at 10k-task scale (fiber switch + netpoller).
  - First-class nova_build --target=x86_64-linux: DONE (iter-66). nova_build now, for a
    non-Windows target, rewrites the generated .ll (triple + m:w->m:e datalayout) and
    selects link libs/tooling by target+host: on a native Linux/macOS host it links
    directly with clang; cross from a Windows host (no native Linux sysroot) it lowers
    the .ll to a Linux ELF object with Windows clang (-c) then links via a WSL distro's
    gcc (configurable build.wsl_distro, default Ubuntu) which has the Linux headers.
    Verified end-to-end: `nova_build build --target=x86_64-unknown-linux-gnu <proj>`
    produces xc_project/build/<name> as a Linux ELF that runs in WSL (Hello, exit 0),
    while the default Windows build path is byte-for-byte unchanged. Oracle:
    _test_xc_build.ps1. A no-WSL Windows cross-link still needs a bundled Linux sysroot
    (future); native-Linux/CI builds need neither WSL nor a sysroot.
  - aarch64/ARM: still blocked on no ARM execution host (re-audit #1); the POSIX asm
    switch is x86_64-only.
  - Tools: _xc_linux_probe.ps1 (linux compile probe), _xc_build_run.ps1 (cross-build +
    run oracle).
