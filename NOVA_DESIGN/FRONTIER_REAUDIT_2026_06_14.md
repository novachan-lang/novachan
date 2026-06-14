# FRONTIER RE-AUDIT 2026-06-14

Summary: the next sound iter-63 increment is WASM memory.grow (the only live candidate that is high-impact, additive, value-model-untouched, AND whose oracle runs entirely on this host); ARM fibers is the #1 IMPACT frontier but is blocked by the absence of an ARM execution host, and the synthesis's TLS-server and cross-compile premises were factually overstated.

Produced by a 7-agent re-audit workflow (4 parallel grounding readers over REMAINING_FEATURES.md / IMPLEMENTATION_AUDIT.md+AS_BUILT_ARCHITECTURE.md / the deep-frontier memory+plan notes / code TODO-STUB markers, then synthesis + adversarial attack + final recommendation). Every load-bearing coordinate was re-verified by hand against the live runtime after the workflow returned.

## Method and ground truth

Every load-bearing claim re-verified against the live build nova-compiler/test_programs/output/nova_runtime.c (~17,980 lines, 2026-06-14) and nova-compiler/test_programs/nova_build.nova.

Confirmed coordinates (hand-verified post-workflow):
  - ARM fiber stub: nova_runtime.c:4724-4737 (#else after #elif defined(__x86_64__) at :4578; prints "fibers not supported", returns 0; resume/yield/gen all no-op). x86_64 naked nova_asm_switch to mirror at :4581.
  - TLS server REAL on OpenSSL: nova_runtime.c:16058-16099 (SSL_CTX_new(TLS_server_method()), PEM cert/key load, SSL_accept, shared-CTX design). The return-0 stub at :15971-15976 is ONLY the Windows-SChannel #else branch.
  - WASM memory.grow: nova_runtime.c:16937 (opcode 0x40 pops arg, pushes -1). memory.size at :16936 already reads m->mem_size/65536; load/store at :16928-16935 already bound-check m->mem_size. Stale TODO at :16765 falsely lists implemented opcodes (calls :16920, mem :16928, i64 :16979, f64 :17004, f32 :17020, br_table :16970).
  - Cross-compile plumbing: nova_build.nova L146-235 -- link_binary passes --target= AND the runtime as SOURCE (.c), is_known_target lists x86_64-unknown-linux-gnu + aarch64 triples, target_is_windows drives ext/link-flag selection.

## Ranked frontiers

  Rank  Frontier                                  Tractability                 Soundness risk   Note
  1     ARM/aarch64 green-task context switch     blocked: no ARM exec host    medium-to-high   Highest impact (charter non-negotiable); naked asm untestable here
  2     WASM memory.grow (+ delete stale TODO)    high (one host increment)    low              ITER-63 PICK: only on-host gateable win
  3     Cross-compile win-host -> linux-x86_64    medium (needs WSL oracle)    low              ~70%+ already plumbed; oracle is external (WSL)
  4     Native TLS server                         n/a (already done on Linux)  none             DEMOTE to ledger fix; stub is Windows-SChannel only
  5     Zero-cost newtype erasure + unit/clock    low (cross-cutting)          medium           Strongest differentiator; touches type-erased codegen

## Adversarial verdicts (top 3 attacked)

  - ARM fibers -- PICK-WITH-CARE / blocked. Impact premise is TRUE: all concurrency (M:N scheduler, generators, netpoller) is a silent no-op on every aarch64 platform (Apple Silicon, Graviton, Raspberry Pi, ARM edge). But this is hand-written naked aarch64 asm and there is NO ARM build-or-run host on this Windows x86_64 box, so the verification oracle (run the concurrency tests on ARM) is unreachable. A subtly-wrong AAPCS64 callee-saved set (x19-x28, x29/fp, x30/lr, sp, low64 of v8-v15; 16-byte sp alignment; trampoline lr/fp seeding) yields SILENT register corruption, not a loud crash. Do not write untestable naked asm. First stand up QEMU user-mode (or a cloud/CI ARM runner) and prove the existing x86_64 tests run there as a control; only then write the asm.

  - TLS server -- AVOID (premise FALSE). The server is already fully REAL on the OpenSSL build (Linux/macOS) at :16058-16099 -- a native NOVA HTTPS server works today on the deployment target that matters. The quoted return-0 stub is ONLY the Windows-SChannel branch. The real residual is dev-HTTPS-on-Windows, marginal leverage. Action: ledger correction, not a build.

  - Cross-compile -- PICK-WITH-CARE (premise half-wrong in NOVA's favor). Triple plumbing + runtime-as-source cross-build are ALREADY present in nova_build.nova; the real gaps are a target sysroot/libc + cross-linker and an external Linux host to RUN the oracle. Reachable via WSL (unlike ARM), but it is a substrate dependency outside the host-only standard gate. Narrow to win-host -> linux-x86_64; do not chase any-target-from-any-host.

## Iter-63 pick: WASM memory.grow

Why this and not the higher-impact frontiers: the brief requires tractable + SOUND + high-impact and explicitly prefers a clean small win over an unsound big change. ARM fibers (#1 impact) and cross-compile (#3) both have oracles unreachable inside the host-only gate (no ARM host; cross-compile needs WSL). WASM memory.grow is the only live candidate that is additive, value-model-untouched, and fully verifiable on this host -- and it advances the WASM/browser-reach identity pillar (nearly every real Rust/Emscripten/AssemblyScript wasm payload grows its heap; the interpreter fails the instant a module allocates past its initial pages).

First sound step:
  Replace the memory.grow handler at nova_runtime.c:16937. Today:
      else if (op == 0x40) { if (cp < body_end) cp++; if (sp > 0) sp--; if (sp < 1024) stack[sp++] = -1; }
  New behavior (mirroring the established m->mem / m->mem_size / 65536-page convention used by memory.size at :16936 and load/store at :16928-16935):
      1. skip the reserved memory-index byte (cp++)
      2. pop delta-in-pages from the stack
      3. old_pages = m->mem_size / 65536
      4. compute new_size = (old_pages + delta) * 65536 with an overflow / sane-max guard (reject -> push -1, the wasm spec grow-failure value, if new_size overflows size_t or exceeds a fixed cap, e.g. 65536 pages / 4 GiB)
      5. realloc m->mem to new_size; on NULL push -1 and leave m->mem / m->mem_size unchanged (OOM handled, old block intact)
      6. on success: memset [old_size, new_size) to 0, set m->mem_size = new_size, push old_pages
  Separately delete the stale "TODO: calls, memory, i64/f32/f64, br_table" clause at :16765 (all those opcodes are implemented at :16920 / :16928 / :16979 / :17004 / :17020 / :16970); leave an accurate note that imported/host functions remain.
  Add a regression test: a hand-assembled minimal wasm module that calls memory.grow then stores and loads in the newly grown region, asserting (a) grow returns the prior page count and (b) the post-grow store/load round-trips. The interpreter runs on the host; no foreign substrate.

Gate:
  1. Precheck the edited source (self-host precheck; no parse/type regressions).
  2. Build gen4_test.exe; run the gen4 smoke.
  3. Reconverge bootstrap: regenerate gen5 and gen6; assert gen5.ll == gen6.ll byte-identical (compare .ll files, NOT exe SHAs -- clang -O2 link is non-deterministic on Windows). NOTE: this is a RUNTIME-ONLY change (nova_runtime.c + a new test file), so it reconverges BYTE-IDENTICAL to the current fixpoint 3F75D36A (no new compiler-source fixpoint).
  4. Rebuild nova_runtime.o from the edited nova_runtime.c.
  5. Full regression with kill-on-timeout MANDATORY (Invoke-Timed / _proc_util.ps1; WaitForExit does not kill): require 0 SUSPECT and 0 FAIL, including the new wasm memory.grow test.
  6. green_scale flagship at N=1 still passes (orthogonal no-regression check).
  7. Commit SOURCE ONLY (nova_runtime.c + new test .nova + harness manifest line); no generated .o/.exe/.ll artifacts.

## Deferred (and why)

  - Tracked deep leak campaign (W5b spawn/channel escape leak, S3 total-RC): explicitly OFF-LIMITS per the brief; any value-model/RC ownership change risks the float-through-slots and escape-gap-UAF classes. Not in scope for an additive increment.
  - ARM/aarch64 fibers (#1 impact): blocked on a missing ARM execution host. Prerequisite = QEMU user-mode or cloud/CI ARM runner so the concurrency-test oracle can run; only then write the ~40 lines of aarch64 asm. Highest silent-corruption risk if done blind.
  - Cross-compile (#3): plumbing largely present; deferred pending a WSL (linux-x86_64) execution host to satisfy the run-the-cross-built-binary oracle. Narrow scope to win-host -> linux-x86_64 first.
  - GPU device dispatch / game engine / Stage-5 native-ABI / hot reload / comptime macros: real frontiers but each is either a multi-quarter vertical, a codegen-ABI change, or high-soundness-risk (value-model / live-state / hygiene adjacent). Not shippable through one verified additive gate.
  - Native TLS server: not a frontier -- already real on the OpenSSL build; only a ledger correction (gap = Windows SChannel inbound, marginal) is warranted.
  - Newtype zero-cost erasure (#5): strongest differentiator but touches the type-erased codegen boundary; needs a design decision and staging, not an immediate sprint.
