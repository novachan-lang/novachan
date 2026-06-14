# FRONTIER RE-AUDIT 4 -- 2026-06-15 (iter-77)

One-line summary: the clean-additive well is dry and every deep item is now a multi-month value-model campaign or tooling-blocked; the highest sound impact-per-risk for iter-77 is generalizing FFI auto-link (@link_source/@link_object), and the synthesis's "flip W5b default-on" pick is rejected because its enabling premise (escape-hardening commits that closed the iter-58 crash) is FALSE per the git log.

## What is now DONE since re-audit #3 (verified at HEAD 0396377)

- remote_spawn is REAL and tested, not a stub: nova_rt_remote_spawn + call_by_name function registry (the NOVA-way {M,F,A} model -- ship a name+data, never code) + remote_spawn_test in the regression. The closure-serialization "design that does not exist" was sidestepped, not solved.
- The whole SQLite/DB story shipped in 4 commits (8d7bc79, 021cdf6, fa37559, 0396377): parameterized injection-safe bind, ergonomic sqlitex, modular FFI (imported libs declare+use extern fns), nova_link auto-links the bundled sqlite3.c amalgamation on demand.
- ZIP reader (zipx, b958cfc), dynamic-Huffman gzip inflate (6ea5553), demand-driven OpenSSL https/TLS client (e8e96a1), REPL repair (977757b), Linux x86_64 cross-compile incl. the M:N scheduler (18fccde/af45f20), WASM memory.grow (5cda952), tensor toolkit + end-to-end MLP (1b8f753..55432eb).
- State: fixpoint reconverged (gen5.ll==gen6.ll), regression GREEN.

## The decisive correction (verified, not assumed)

The synthesis claims the iter-58 W5b crash "no longer exists" because "~15 commits of ir_escaping_set hardening since iter-58 closed the spawn/channel escape gap," yielding a stable reconverge (C53682C0) and an 86-test W5b-on pass. I checked the live tree:

- git log 48f55ea(iter-58)..HEAD = 17 commits. SIX touch nova_compiler.nova; ALL six are tensor / modular-FFI / OpenSSL features (0396377, fa37559, e8e96a1, 55432eb, d8c7f04, 1b8f753). grep of those commit messages for escap|w5b|drop = NONE. The "ir_escaping_set hardening commit series" does NOT exist.
- The in-source comment at nova_compiler.nova L15670-15673 still reads: "Bootstrap fixpoint bug found: W5b-compiled compiler cannot correctly self-compile (2nd-gen binary fails trait/closure/generics tests). Keep opt-in until escape analysis handles compiler's own code patterns."
- do_w5b (L15677) still defaults OFF, gated on NOVA_T8_DROP=1. Nothing about W5b changed since iter-58.

Therefore the "rebuilt the compiler, exit 0, reconverged C53682C0, 86 tests green" narrative has no artifact in the repo -- never committed (so it does not exist for iter-77) or fabricated. Everything downstream of it is unverified.

What IS verified directly: the blind-spot machinery matches the description. ire_load_origin[dest] is set at exactly one place (L14812, slot_load). The W5b drop reads e.ire_load_origin[ret_arg] (L15688) and skips any slot in e.ire_slot_escaped (L15697). A container that escapes via a field-read (obj.items), a call result (get_list() passed straight to spawn), or a literal has NO origin entry -> the escape mark never fires -> under aggressive drop the slot is freed while the escaping container still references it. That is a USE-AFTER-FREE, not merely a leak. This is exactly why W5b-on failed bootstrap on trait/closure/generics: the compiler's own code is field-read/call-result heavy. The synthesis self-contradicts -- it admits the blind spot while claiming "any residual blind spot degrades to a leak, never a UAF."

## Ranked frontier

| Rank | Item | Tractability | Soundness risk | Change class |
|---|---|---|---|---|
| 1 | General at-link FFI breadth (@link_source/@link_object) | high | low | compiler-source |
| 2 | TLS server (nova_rt_tls_listen/accept) | medium | none | runtime |
| 3 | RE-DIAGNOSE the W5b blind spot statically | high | low | investigation |
| 4 | Reflection call_by_name -- lift 8-arg ceiling | high | low | runtime |
| 5 | Unicode collation + case-fold (UCA/DUCET) | medium | low | new-file |
| 6 | RE-VALIDATE + FLIP W5b default-on -- REJECTED | low | high | compiler-source |
| 7 | S3 total-RC (headline loop-local leak fix) | low | high | compiler-source |
| 8 | Real GPU NOVA-source-to-kernel lowering | low | medium | compiler-source |
| 9 | ARM/aarch64 fibers -- BLOCKED (no QEMU oracle) | low | high | blocked |
| 10 | WASM-m7 / remote closure-serialization / beat-C scalar | low | high | blocked |

## Adversarial verdicts on the top-3 the synthesis proposed

- FLIP W5b default-on -- AVOID. Premise fabricated (git log shows zero escape-analysis commits since iter-58; in-source comment still documents the live bootstrap-fixpoint failure). Flipping do_w5b re-introduces a known, reverted, UAF-capable regression. High time cost (~40min reconverge), soundness landmine, likely no merge. The blind spot makes field-read/call-result/literal escapes a use-after-free, not a leak.
- RE-DIAGNOSE the blind spot -- SAFE, the only honest leak work for iter-77. Bounded static read of L14800-15270, no lldb, no reconverge, uses the safe harness. Output is INFO (a diagnosis + targeted test programs), deliberately. MUST stay standalone -- combining it with the flip re-imports the landmine. The eventual fix is additive escape-marking (propagate ire_load_origin through field-load + call-result), which can only make MORE slots be skipped (more conservative = more leaks, never fewer frees) -- the safe direction.
- General at-link FFI breadth -- SAFE and strongest. Premise verified at L17640-17683: generic ; LINK_LIB: scan (L17655) + two hard-coded special-cases (needs_ssl scans call @nova_rt_tls_/@nova_rt_http_get L17663-68; needs_sqlite scans call @sqlite3_ L17665/75-81 with full compile-once-cache L17676-81). Three special cases = one missing abstraction. Zero value-model contact; testable through the installed compiler. The one real risk is path/command-injection in system() at L17680 -- sanitize/quote, resolve to project root.

## The iter-77 pick

General at-link FFI breadth. It is the only top item that is simultaneously sound (zero value-model contact -- never touches IR semantics, the value model, escape analysis, or codegen of user arithmetic), tractable in a slow reconverge env (testable through the installed compiler; reconverge only at the final gate), charter-advancing ("the developer never leaves NOVA" -- inability to link an arbitrary C lib is the single most common reason a real dev must leave), and merge-producing (real code, not a doc). It converts the one-off SQLite achievement into the universal C-interop story: wrap zlib, libcurl, libpng, any vendor SDK with one annotation and nova build just works.

First sound step: add two annotations that emit ; LINK_OBJECT: <path> and ; LINK_SOURCE: <path> marker lines into the .ll (mirroring ; LINK_LIB:). In nova_link's ll_lines loop (L17653), add a generic branch: for each LINK_SOURCE marker reuse the exact sqlite3.c->sqlite3.o compile-once-cache logic at L17676-17681 (if cached .o missing/empty, clang -c -O2 src -o obj, append quoted .o); for each LINK_OBJECT marker append the quoted path. Leave needs_ssl/needs_sqlite as-is (they key off runtime-internal call patterns the user cannot annotate). Harden: quote the path and reject shell metacharacters before system() (L17680 already interpolates a path into clang -- must not become an injection vector); resolve relative to project root. DONE: a hand-written foo.c (one fn foo_add) bound via extern fn + @link_source("foo.c") builds via the installed compiler and prints the correct value; a program using NEITHER annotation links byte-identically (.ll has no new markers, link command unchanged).

Gate (compiler-source + new test): edit nova_compiler.nova; precheck self-compile with the CURRENT installed gen3 (gen3_test.exe, NEVER gen2_move.exe) under Invoke-Timed/_proc_util.ps1 kill-on-timeout (mandatory -- WaitForExit does NOT kill); build+run ffi_link_test through the fresh compiler asserting correct output AND an unchanged no-annotation control; gen4 smoke; bootstrap reconverge comparing gen5.ll vs gen6.ll (.ll FILES, never exe SHAs -- clang -O2 link is non-deterministic on Windows); full ~438-program regression GREEN with kill-on-timeout on every binary; commit SOURCE ONLY (nova_compiler.nova + ffi_link_test.nova + foo.c), no generated .ll/.o/.exe. Co-Author line on the commit.

## Deferred (and why)

- S3 total-RC -- the ACTUAL headline loop-local-reassignment leak fix (leak_baseline still 2000/2000/2000; W5b does NOT touch it). Deep value-model campaign: prereq S2.5 clone-or-transfer ownership does not exist; for-in borrowed elements and let x=[fresh] lower to identical slot_store IR (L14818), so a flat reg-type map cannot separate owned from borrowed. Sequence AFTER the safe partial wins, gated on the #3 diagnosis. Do NOT flip W5b in the interim.
- GPU NOVA-source-to-kernel lowering -- device plumbing is real (OpenCL dlopen, real gpu_vadd + CPU fallback) but capped at a fixed kernel whitelist; the compiler path (NOVA fn -> SPIR-V/PTX/Metal) is multi-quarter (kernel-IR pass + device-buffer abstraction + per-vendor codegen).
- ARM/aarch64 fibers -- HARD-BLOCKED: no ARM/QEMU oracle in the repo; naked AAPCS64 asm fails silently on a wrong register set and must be runtime-verified, not just compiled. Highest charter impact for "runs anywhere" but cannot be soundly delivered here.
- WASM-m7 (NOVA's own C runtime -> wasm32) -- HARD-BLOCKED on no wasi-sdk sysroot; the JS-runtime interim already runs real programs in-browser.
- remote_spawn closure/code serialization -- by-name RPC already ships + tests the distributed value the Erlang way; serializing captured-state closures needs a code-shipping design that does NOT exist in the repo; recv-timeout is gated on the leak fix.
- beat-C scalar struct-passing -- FALSIFIED 2026-06-12 (native-ABI clone 1.28x C, WORSE than i64-ABI 1.20x). NOVA at the uniform-i64 ceiling with zero annotations + memory safety. Lowest ROI: matmul/tensor ALREADY beat C 1.45-1.72x via SIMD + auto-parallel, so the prestige target is met on the workloads that matter.

Relevant file: nova-compiler/test_programs/nova_compiler.nova -- W5b drop site + stale "cannot self-compile" comment + do_w5b default-off (L15669-15713); sole ire_load_origin set (L14812); escape marks (L14965-15264); nova_link FFI auto-link with generic LINK_LIB + hard-coded needs_ssl/needs_sqlite (L17640-17683).
