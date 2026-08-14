# Decision: Windows native target moves from MSVC ABI to GNU/mingw ABI

## Date: 2026-08-08

## Status: ACCEPTED

## Context

NOVA has no installer today. The compiler generates LLVM IR text, then shells out to
a system `clang` binary (`system()`/`system()`-family calls in `nova_link()` and
related functions in `nova_compiler.nova`) to produce a native executable. Every user
must separately obtain and install LLVM/clang themselves before `nova build`/`nova run`
works at all — there is no bundling, and `site/index.html` currently instructs users
to `apt install llvm clang` / `brew install llvm` / run the LLVM Windows installer.

The goal is a single self-contained installer file per platform (Windows, Linux,
macOS) that bundles the compiler with a working toolchain, so end users never
separately install LLVM. For Linux and macOS, bundling a trimmed official LLVM/clang
release archive is sufficient — the OS's own base toolchain assumptions (glibc headers,
Xcode Command Line Tools SDK) are already near-universal.

Windows is different. NOVA's native Windows target has always been MSVC ABI
(`x86_64-pc-windows-msvc` / `aarch64-pc-windows-msvc`, hardcoded in
`native_target_triple()`/`resolve_target()`, `nova_compiler.nova:21917-21947`).
Official LLVM Windows release archives target this same MSVC ABI — but *linking*
against it still requires a separately-installed Visual Studio Build Tools / Windows
SDK, which LLVM's own archive does not provide. Bundling official LLVM for Windows
as-is would not eliminate the "go install something else" step; it would just
relocate it from "install LLVM" to "install VS Build Tools" (itself a multi-GB
download), failing the actual goal.

## Decision

NOVA's *default* native Windows compilation target moves from MSVC ABI to GNU/mingw
ABI (`x86_64-pc-windows-gnu` / `aarch64-pc-windows-gnu`), sourced from
[llvm-mingw](https://github.com/mstorsjo/llvm-mingw) — clang + lld + a complete
mingw-w64 UCRT sysroot (headers, CRT, import libs), needing nothing else installed.
`windows-msvc` remains available as an explicit, non-default `--target` for anyone who
specifically needs MSVC-ABI output; they supply their own MSVC/Build Tools for that
path, exactly as today.

## Rationale

This is the only option that actually satisfies the stated goal (single file, zero
separate installs) on Windows:

- Bundling official LLVM (MSVC-targeting) + requiring a separate VS Build Tools
  install does not solve the problem — it just moves the same problem to a bigger
  download.
- llvm-mingw bundles everything needed (compiler, linker, and full C runtime/sysroot)
  in one archive with no external dependency, which is uniquely true of the
  GNU/mingw route on Windows — a property Linux and macOS bundling doesn't need
  because their base toolchain assumptions are already satisfied by a normal OS
  install.
- The engineering cost is small and independently verified against the live compiler
  source (not assumed): the calling-convention/ABI-lowering code that would be the
  natural place for MSVC-specific behavior to leak in does not key off "msvc" at all.
  - `target_datalayout()` (`nova_compiler.nova:21949-21956`) branches on the generic
    substring `"windows"`, not `"msvc"` — confirmed by direct read.
  - The LOCK-11 struct-by-value FFI ABI classifier (`_abi_byval_type`,
    `_abi_field_kinds`, and the return-lowering logic starting at `:21958`) is framed
    around calling-convention families — "Win64 vs SysV vs AAPCS64" — not vendor
    strings. This matches a real, independently-known fact about the Windows x64 ABI:
    the Win64 calling convention (register usage, shadow space, struct-passing rules)
    is standardized across compilers targeting Windows — MSVC and mingw-w64 both
    implement the identical Microsoft x64 calling convention. Only the environment tag
    differs (name mangling details, default CRT), not the ABI NOVA's codegen has to
    reason about.
  - Net code change: one string literal per branch, in `native_target_triple()` and
    `resolve_target()` (`:21917-21947`) — not a rewrite of any codegen or ABI logic.

## Alternatives Considered

**Bundle official LLVM (MSVC-targeting) as-is.**
Strongest argument: zero ABI change, keeps today's Windows target identity fully
intact.
Rejected because: does not achieve the actual goal. Linking still requires a
separately-installed VS Build Tools/Windows SDK — the exact class of "go install
something else first" experience this whole effort exists to remove, just with a
larger download than the LLVM step it replaces.

**Bundle a redistributable subset of the MSVC/Windows SDK directly** (the "xwin"-style
approach some Rust cross-compilation tooling uses: extract just the needed CRT/SDK
files under Microsoft's redistribution terms).
Strongest argument: would preserve full MSVC ABI compatibility with zero triple change.
Rejected because: legally murkier (redistribution terms for extracted SDK/CRT pieces
are narrower and less clearly settled than LLVM's own Apache-2.0-with-exceptions
license), and technically more fragile (tied to Microsoft's SDK versioning/EULA
changes over time) for a benefit — full MSVC ABI parity — that most NOVA users do not
need. Not ruled out forever, but not the v1 choice.

**Keep MSVC as the only target, defer Windows installer entirely.**
Strongest argument: avoids the decision altogether; ship Linux+macOS first.
Rejected as the only path forward (though it's the accepted fallback for phased
rollout — see the implementation plan) because Windows is a primary NOVA platform and
indefinitely shipping a worse install experience there is not acceptable long-term.

## Consequences

### Positive
- Windows installer becomes genuinely self-contained: one file, no separate
  Visual Studio/Windows SDK, matching Linux/macOS's dependency story.
- llvm-mingw is actively maintained, mature technology — mingw-w64-built Windows
  binaries are already how large real-world projects ship (Git for Windows
  components, FFmpeg's official Windows builds, the MSYS2 ecosystem).
- NOVA gains, for free, a real C compiler bundled with every install — useful beyond
  just linking NOVA's own output (e.g., compiling third-party C source for `@link_source`
  FFI, without any separate toolchain).

### Negative
- Third-party MSVC-prebuilt **static** `.lib` archives (real compiled code, not a DLL
  import stub, with no source available) can no longer be directly FFI-linked without
  conversion. This is a real, permanent-by-default limitation for that narrow case.
- NOVA's documented "native Windows ABI identity" changes going forward — anyone who
  has built mental models or documentation around `-pc-windows-msvc` being the default
  needs to update that understanding.

### Neutral
- DWARF remains NOVA's debug-info format on Windows either way — this was already a
  deliberate choice (so `lldb` can inspect NOVA locals) independent of MSVC vs GNU,
  and if anything aligns more naturally with the GNU/mingw route's conventions than
  MSVC's native PDB format.
- SEH-based structured exception handling is not something NOVA's own error model
  relies on today, so the exception-handling-model difference between environments
  is not a practical concern for NOVA-generated code.

## Tradeoffs Explicitly Accepted

Losing direct linkage against MSVC-only static `.lib` files is accepted because:
1. It's a narrow case — most C libraries someone would FFI against either already
   ship mingw-compatible builds, or can be compiled from source using the bundled
   toolchain itself (NOVA now ships a full C compiler as a side effect of this
   decision).
2. Many real-world "MSVC .lib" situations are actually DLL import stubs, not true
   static archives, and can be regenerated as mingw-compatible via standard tools
   (`dlltool`/`gendef`) from the DLL alone.
3. NOVA is early in building its own ecosystem, not sitting on a base of legacy
   MSVC-only Windows dependencies that this would break. The cost is lowest right now
   and only grows if deferred.
4. The escape hatch (`--target windows-msvc`, BYO toolchain) is not removed — this is
   a default change, not a capability removal.

## Interaction with Other Decisions

No existing decision in `NOVA_DESIGN/decisions/` addresses toolchain distribution or
target ABI — this is the first decision in that space. It does not touch or
contradict `naming_convention.md` (identifier casing) or any of the core-model
research/open-problem documents (those govern the Values/Processes/Channels language
architecture, not native code generation targets). Future toolchain/distribution
decisions (e.g., the from-source minimal-LLVM-build size optimization, or the
xwin-style MSVC-SDK-bundling alternative revisited later) should reference this
decision as their baseline.

## Reversal Cost

Moderate, and cleanly bounded. The code change itself is trivially reversible (revert
the string literals in `native_target_triple()`/`resolve_target()`). The real cost of
reversal is ecosystem churn, not engineering effort: any Windows binaries already
built and distributed under the mingw default, and any documentation/tutorials written
assuming it, would need updating. Reversal gets more expensive the longer this
decision stands and the more the ecosystem grows around it — this is a normal,
expected property of a default-behavior decision, not a red flag specific to this one.

## Validation Criteria

This decision is correct if:
- The Windows installer, once built (Phase 3 of the installer plan), successfully
  runs `nova build hello.nova` end-to-end on a clean Windows machine with zero
  pre-installed clang/LLVM/Visual Studio — the concrete, falsifiable proof of the
  goal this decision exists to serve.
- Existing NOVA regression suites (`cross-platform.yml`'s `windows-full-regression`,
  and the gen5==gen6 reconverge check) stay green after the triple change, confirming
  the verified-unaffected ABI-lowering code claim holds in practice, not just in
  static analysis.
- No FFI-related regression appears in NOVA's own `@link`/`@link_source`/`extern fn`
  test coverage, which all funnel through the same bundled toolchain and are
  therefore expected to be fully unaffected (only *third-party pre-built MSVC*
  artifacts are impacted, and NOVA's own test suite does not depend on any).

This decision would be proven wrong if: a significant fraction of real NOVA users
turn out to need direct linkage against MSVC-only static libraries with no
mingw-compatible alternative and no source available — in which case the
xwin-style rejected alternative should be revisited as a supplementary (not
replacement) option, not a reversal of the mingw default.
