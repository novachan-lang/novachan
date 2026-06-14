# NOVA Frontier Re-Audit #2 (iter-67 synthesis / iter-68 pick), HEAD af45f20

SUMMARY (one line)
Two of iter-62's five frontiers are now DONE (WASM memory.grow, Linux x86_64 cross-compile);
of the rest, the only env-viable next move is a small reconverge-safe REPL repair, because the
synthesis's other two top picks were disqualified on verification (sqrt-inline is already
shipped; OpenSSL-default's "no-reconverge" premise is false).

Produced by a 7-agent re-audit workflow (4 parallel grounding readers -> synthesis ->
adversarial attack -> recommendation). Every load-bearing coordinate hand-verified after.

WHAT ITER-62 LEFT vs WHAT IS NOW DONE
iter-62 (FRONTIER_REAUDIT_2026_06_14.md) ranked 5 frontiers. Re-audited against the live build:
 - DONE  #2 WASM memory.grow -- commit 5cda952. Full spec semantics (pops delta-pages, 64-bit
   size math, 256MiB cap matching the wasm_run init guard, OOM-safe realloc, zero-fills new
   pages, returns prev page count, grow-by-0 short-circuit).
 - DONE  #3 Cross-compile win-host -> linux-x86_64 -- 18fccde (Linux runtime build-breaks fixed +
   10k-task M:N flagship cross-built and RUN in WSL), 4770cac (sort_by made a STABLE merge sort,
   fixing a real qsort cross-platform nondeterminism bug; 40/40 portability sweep), af45f20
   (first-class nova_build --target=x86_64-unknown-linux-gnu). Windows reconverges byte-identical
   (3F75D36A). First verified NOVA execution on a second platform.
 - STILL-OPEN  #1 ARM/aarch64 fibers -- hard-blocked, no ARM/QEMU host (see Deferred).
 - DEMOTED  #4 Native TLS server -- premise was FALSE. A real OpenSSL server exists
   (nova_runtime.c ~16114-16143: TLS_server_method + PEM load + SSL_accept); only the
   no-OpenSSL/SChannel inbound branch stubs it. A ledger correction, not a frontier.
 - STILL-OPEN  #5 Zero-cost newtype erasure -- the semantic distinct/newtype gate is DONE
   (UserId != Int enforced) but the value still carries a 1-field struct box; erasure-to-bare-i64
   + the units/clock/money applications remain, behind the type-erased codegen boundary.

Also corrected vs stale memory/premises: NFC/NFD normalization is SHIPPED
(nova_rt_normalize_nfc/nfd) but still marked DEFERRED in REMAINING_FEATURES.md; remote_spawn is
at least partly wired at runtime (readers disagreed -- needs a reconcile before any scope).

RANKED FRONTIERS (iter-68 shortlist)
  Rank | Frontier                                                              | Tract | Sound risk | Change class
  1 | REPL repair: repoint repl.nova:112 off the absent gen2_move.exe to gen3 | high  | none       | test-program (not a bootstrap input -> reconverge-safe)
  2 | Demand-driven OpenSSL link via the existing ; LINK_LIB: mechanism       | med   | low        | compiler-source
  3 | Distributed remote_spawn + compiler-transparent channel routing         | med   | medium     | mixed
  4 | Unicode ledger correction (un-defer shipped NFC/NFD) + collation/casefold| med   | low        | new-file
  5 | Compression: dynamic-Huffman deflate/inflate + zip central-directory     | med   | low        | new-file

ADVERSARIAL VERDICTS (verified against code at HEAD af45f20, not memory)
 - PICK #1 REPL -> PICK-WITH-CARE (verified launchable). repl.nova:112 calls .\gen2_move.exe
   (absent legacy binary the memory bans); line 117 already does the clang-link. The CLI DOES
   dispatch: nova_compiler.nova:18504 (cmd=='repl') discovers repl.nova, compiles+links it via the
   compiler's internal nova_compile_file/nova_link, and execs the resulting repl.exe -- which is
   the running REPL that per-line shells out at :112. So the repoint target is the live bootstrap
   binary .\gen3_test.exe (NOT nova_compile_file/nova_link -- those are internal fns, not
   subprocesses). Honest scope: broken->working, NOT broken->Python-class (each line pays a full
   compile+clang-link; build_temp_source re-emits the whole session O(n^2) -- a separate latency
   follow-up). repl.nova is a TEST PROGRAM, not in the bootstrap input set, so the fix cannot
   change gen5.ll/gen6.ll -> reconverge-safe.
 - PICK #2 OpenSSL default -> PICK-WITH-CARE, reject the synthesis framing. "tool-only, no
   reconverge" is FALSE: nova_link builds the link command INSIDE the self-hosted compiler
   (compiler-source -> full reconverge). An unconditional default -lssl -lcrypto would break the
   default build on any stock Linux without libssl-dev for the common non-HTTPS program (worse
   90th-percentile failure). Sound design: reuse the existing ; LINK_LIB: emission, adding the
   OpenSSL libs + the -DNOVA_HAVE_OPENSSL define ONLY when an HTTPS/TLS builtin is referenced.
 - PICK #3 sqrt-inline -> AVOID-FOR-NOW. ALREADY SHIPPED and sound at HEAD. ire_proven_float is a
   live IrEmitter field (nova_compiler.nova:14330), set ONLY at float-producing SSA sites (14346,
   never slot_load), with intrinsic inlining gated on it (14887) for sqrt/sin/cos/exp/log/.../fabs
   /floor/ceil; the comment at 14862 records the sound-fix-after-revert history. Re-picking re-does
   done work and risks regressing a delicate live soundness gate. Only adjacent work = adding a few
   more intrinsics (pow/tan/atan2) via the SAME gate -- breadth, not the beat-C frontier.

ITER-68 PICK
REPL interim repair -- repoint test_programs/repl.nova:112 from .\gen2_move.exe to .\gen3_test.exe.
Rationale: the only top candidate simultaneously high-impact (the "try NOVA in 10 seconds" onramp,
currently silently broken), tractable (one string change), and sound (test program, not a bootstrap
input -> compiler .ll unchanged -> reconverge-safe, zero soundness surface). Tie-break: the cheapest
viable loop on this memory-pressured box; the compiler-source alternatives each pay the
~40-min-reconverge tax, and the headline perf one (sqrt) is already done.

SOUND FIRST STEP
Edit repl.nova:112: exec(".\\gen2_move.exe repl_session.nova") -> exec(".\\gen3_test.exe
repl_session.nova"). Verified before commit: (a) the CLI dispatches to repl.nova on cmd=='repl'
(nova_compiler.nova:18504) so the fix reaches a launchable feature; (b) repl.nova is absent from the
bootstrap input set (a test program). Then drive one interactive session round-trip (a let-binding
then a print referencing it) and confirm each line yields repl_session.ll -> repl_session.exe ->
correct output. Do NOT touch build_temp_source / session-accretion (separate latency follow-up).

GATE (scaled to change_class; kill-on-timeout MANDATORY via Invoke-Timed / Start-Process+WaitForExit)
 1. Precheck: edited repl.nova parses/compiles.
 2. Functional verify: launch the REPL via the compiler's 'repl' verb; run a multi-line session
    (let x = 21 + 21; print(x) -> 42, exercising accretion); confirm each line yields
    repl_session.ll -> repl_session.exe -> correct output (no COMPILE_ERROR).
 3. Full regression 426/426 0-SUSPECT via _run_final_regression.ps1 -- expected UNCHANGED (the
    compiler .ll is untouched; repl.nova is not a bootstrap input).
 4. Reconverge SKIP-justified: repl.nova is not a bootstrap input, so gen5.ll==gen6.ll is preserved
    by construction (fixpoint stays 3F75D36A) -- no ~40-min reconverge needed.
 5. Commit SOURCE ONLY (repl.nova; never built .exe/.ll artifacts).

DEFERRED (and why)
 - sqrt / math-intrinsic inline -- ALREADY SHIPPED at HEAD (ire_proven_float gate). Optional: add
   intrinsic breadth (pow/tan/atan2) via the same gate.
 - W5b return-drop default-on + S3 total reference counting -- the KNOWN tracked leak campaign.
   W5b default-on hard-blocked on a spawn/channel escape-gap UAF (W5b-compiled compiler crashes
   0xC0000005 compiling green_scale_test); S3 needs a value-level clone-or-transfer ownership model
   (S2.5) that does not exist. Exactly the landmine class to avoid this iteration.
 - Stage-5 native-ABI / raw-representation value-model overhaul -- hand-validated and FALSIFIED
   2026-06-12 (native-ABI clone = 1.28x C, WORSE than i64-ABI ~1.20x; the EA-local [4 x i64]
   alloca + i64-handle laundering defeat LLVM SROA regardless of call ABI). NOVA is at the ceiling
   of uniform-i64 (~1.0-1.2x C, memory-safe, zero-annotation). Multi-month value-model rearchitecture.
 - ARM/aarch64 fibers -- highest charter impact (Apple Silicon / Graviton / Pi / ARM edge all hit the
   #else "fibers not supported" stub; the entire M:N scheduler + generators + netpoller silently
   no-op there). HARD-BLOCKED: no ARM/QEMU tooling in repo; hand-written naked AAPCS64 asm fails
   SILENTLY on a wrong register set, so it must be runtime-verified, not just compiled. Now MORE
   tractable than at iter-62 (the Linux x86_64 port proved the POSIX fiber/netpoller path runs), but
   parked until a QEMU/CI ARM oracle exists.
 - Native TLS server -- DEMOTED to a ledger correction (real OpenSSL server exists; only the
   no-OpenSSL/SChannel-inbound branch is stubbed).
 - Real GPU backend -- endgame multi-quarter (the CPU-backed dispatch table needs a kernel-lowering
   path SPIR-V/PTX/Metal + device-buffer abstraction + a driver binding).
 - WASM-full (m7 real-runtime-to-wasm) -- the sound-subset JS-runtime frontend is LIVE (DOM/event/
   bundler, Node-verified) and is the correct interim; m7 blocked on no wasi-sdk sysroot.
 - Stale WASM TODO doc-comment in the interpreter header -- free cosmetic ledger fix; fold into any
   nearby runtime edit (NB: the iter-63 header fix already corrected the primary one).
