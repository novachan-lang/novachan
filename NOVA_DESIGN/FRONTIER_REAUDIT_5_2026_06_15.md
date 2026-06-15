# FRONTIER RE-AUDIT 5 -- 2026-06-15 (HEAD a415895)

One-line summary: W5b is now suite-sound but does NOT touch the headline loop-local leak; the real iter-84 pick is the bounded, sound, iter-sized fresh-RHS slice of the S2.5 ownership leak fix -- and the synthesis's #1 (WASM) is demoted because its premise is false (the WASM value model already exists in _wasm_runtime.cjs; the real gap is the open-ended, partly-blocked tag-soundness problem).

## What is now DONE (consumed from re-audit #4 + iters 77-82)
- General @link FFI breadth shipped (iter-77, a8af162, fixpoint CD05F294).
- call_by_name arity 8 -> 16 shipped (iter-78, 5b1d6eb).
- Unicode casefold shipped (iter-79, 6f8ee16).
- W5b return-drop leak DIAGNOSED (iter-80) and FIXED to SUITE-SOUNDNESS (iters 81-82, 39b1789 + 59d5086): full regression 431/0 under NOVA_T8_DROP=1 AND 431/0 normal, reconverged fixpoint 59AB0B6B. W5b is STILL DEFAULT OFF. Both fixes are conservative (only ADD escape marks -> more leaks, never fewer frees -> cannot introduce a UAF).
- remote_spawn is DONE, not a stub (compiler L4709-4712, runtime L9287, passing remote_spawn_test.nova) -- the stale memory note is corrected.

## The decisive reframing (ground-truthed against RC_COMPLETENESS.md + leak_baseline_test.nova)
W5b suite-soundness does NOT resolve the headline leak. SOURCE-VERIFIED:
- RC_COMPLETENESS.md L29: the 2000-iter rebind oracle is LIST=2000, DICT=2001, CHAN=2001, and IDENTICAL with NOVA_T8_DROP=1.
- Cause (L20): slot_store (~L14482-14514) emits a bare store and never rc_dec's the overwritten value; RC is PARTIAL.
- W5b drops fire ONLY at function return on the function's own non-escaping list/dict slots -- structurally CANNOT touch a per-iteration reassigned value.
- The structural blocker for the real fix (L52-53): for-in borrowed elements and let x=[fresh] lower to IDENTICAL slot_store IR, so a flow-insensitive flat reg-type map cannot separate owned from borrowed -> naive rc_dec-on-overwrite is a use-after-free, not a leak.

So the genuinely-open frontier is: (a) the S2.5->S3 deep leak campaign (the actual #1 debt), (b) GPU source-to-kernel lowering, (c) the Windows-Schannel TLS server, (d) a now-legitimate-but-narrow W5b flip (declined), plus sound additive polish.

## Major premise correction vs the synthesis (a re-audit-4-class error caught)
The synthesis ranked "Real WASM runtime" #1 on the claim that the WASM value model is a no-op stub and the work is "just port the allocator + tagged values, low risk." FALSE against the live tree:
- nova_runtime_wasm.c (the compute-only STUB file) is a DEAD/older path.
- The actual nova wasm target uses _wasm_runtime.cjs (522 lines, live, copied by the CLI): real bump allocator with memory.grow, real lists in linear memory, real dicts (FNV-1a + open-addressing), strings, floats, structs, polymorphic ops. The value model is ALREADY BUILT.
- What REMAINS is the part the synthesis dismissed: _wasm_runtime.cjs L26-37 states an explicit SOUNDNESS BOUNDARY -- NO value tags, so integers >=256 whose low-32 bits hit a printable data-section byte DIVERGE from native through polymorphic ops. That is the exact int/pointer CVE-class problem that cost the native runtime a multi-session campaign, and the production fix (m7 tagged-C-runtime-to-wasm) is HARD-BLOCKED on the wasi-sdk sysroot.
- Therefore WASM is NOT an additive low-risk headline; it is either cosmetic stdlib breadth (low value) or open-ended/partly-blocked tag soundness.

## Ranked frontier
| Rank | Target | Tract | Soundness risk | Class | Why |
|---|---|---|---|---|---|
| 1 | S2.5 -> S3 total-RC: headline loop-local leak fix | low | high | compiler-source | The genuine #1 debt; OOMs a long-running server. Oracle 2000/2001/2001 IDENTICAL with W5b on (source-verified). Has a bounded sound iter-sized first slice. |
| 2 | GPU NOVA-source-to-kernel lowering | low | medium | compiler-source | Highest vision ceiling; device plumbing REAL but capped at one literal kernel. Missing piece is a real codegen backend. |
| 3 | TLS server on Windows via Schannel | medium | medium | runtime | Runtime-only, no reconverge; client crypto reusable. BUT un-oracled + the AUTO_CRED_VALIDATION killer makes a clean round-trip a security decision, not a drop-in. |
| 4 | Real WASM runtime soundness (tagged values) -- DEMOTED | low | high | campaign | Premise FALSE: value model already built in _wasm_runtime.cjs; real gap is the open-ended/wasi-sdk-blocked tag-soundness boundary. Needs a scoping spike, not a campaign. |
| 5 | W5b default-flip -- DECLINE; do the free doc-correction | high | low | investigation | Cannot reduce the headline leak (return-only vs per-iter); iter-82 fix eroded its narrow benefit; costs ~40-min reconverge for a near-neutral, UAF-surfaced heuristic S2.5 is designed to DELETE. Free win: fix stale comment L15700-15702. |
| 6 | remote_spawn closure serialization | low | high | mixed | remote_spawn DONE but NAME-based; closures need code-shipping + remote-exec security design. |
| 7 | Sound additive polish (Unicode collation, HTTP chunked, newtype erasure, nullability narrowing, call_by_name>16, bit-match) | high | low | mixed | Low-risk filler between deep iters. Unicode collation + HTTP chunked are the cleanest standalone wins. |
| 8 | BLOCKED / recorded-dead (ARM fibers, WASM-m7 wasi-sdk, beat-C struct-passing) | low | high | blocked | Not soundly advanceable here. beat-C struct-passing FALSIFIED 2026-06-12; matmul/tensor already beat C 1.45-1.72x. |

## Adversarial verdicts (TOP 3 sent for attack, all claims ground-checked at HEAD a415895)
- WASM (synthesis #1) -- AVOID AS FRAMED / built on a false premise. The value-model runtime is ALREADY BUILT in _wasm_runtime.cjs; the dismissed part (tag soundness, L26-37) is the real and partly-blocked work. Not knowable-in-one-iter. If pursued, the only sound first move is a scoping spike: 3-4 NOVA programs exercising large-int-through-polymorphic-op in the browser, measured for divergence frequency.
- S2.5 (loop-local leak) -- PICK WITH CARE, and the CORRECT headline. Every load-bearing claim checks out (slot_store never decs the overwritten value; W5b drop logic is return-only; for-in and let-fresh lower to identical IR). NOT a one-iter close as a full campaign -- but there IS a sound iter-sized slice: the fresh-RHS-only rc_dec with old!=new guard, which covers the entire oracle without touching the borrowed-element UAF surface.
- TLS-Windows -- PICK WITH CARE, cheapest of the three. nova_rt_tls_listen/accept are honest return-0 stubs; the killer is real -- the client at L16042 uses SCH_CRED_AUTO_CRED_VALIDATION and rejects a self-signed loopback cert. Sound path: implement the AcceptSecurityContext server handshake (EncryptMessage/DecryptMessage already context-agnostic) and gate the ROUND-TRIP TEST on a test-only SCH_CRED_MANUAL_CRED_VALIDATION client, never weakening the shipped client. Un-oracled today; correctness-of-claim win more than developers-blocked win.

## Iter-84 pick + sound first step + gate
PICK: S2.5 -- ONLY the bounded fresh-RHS slice (not the full ownership campaign).

SOUND FIRST STEP: behind a new NOVA_T8_FULLRC flag (default OFF, zero codegen change when off), at each slot_store emit site, emit an rc_dec of the prior slot value WHEN (a) the incoming value register has exactly one use (this store) AND its defining IrInst is a fresh same-block allocation -- list literal, dict literal, or channel() -- using the landed-but-inert ire_borrow_src provenance to EXCLUDE any register sourced from index_get / field_get / loop-induction (borrowed, NOT fresh), AND (b) old != new (pointer compare) and old is a heap handle. Conservative-toward-leaking: a register that is not provably fresh is left alone (still leaks, never double-frees) -> the floor is current behavior, never a UAF.

DONE criterion (falsifiable, oracle-gated): with NOVA_T8_FULLRC=1, leak_baseline_test.nova deltas drop from LIST=2000/DICT=2001/CHAN=2001 toward ~0; full regression 431/0 under the flag; ASAN of leak_baseline + green_scale under the flag shows ZERO UAF/double-free; with the flag OFF the compiler reconverges byte-identically (gen5.ll == gen6.ll).

GATE (compiler-source behind default-OFF flag; kill-on-timeout MANDATORY on every binary -- WaitForExit does NOT kill; verify loop termination before building):
1. edit nova_compiler.nova
2. precheck compile
3. gen4 smoke
4. FLAG-OFF reconverge -- assert gen5.ll == gen6.ll byte-identical (compare .ll files, NEVER exe SHAs; clang -O2 link is non-deterministic on Windows)
5. full regression 431/0 with flag OFF
6. FLAG-ON -- leak_baseline deltas toward ~0, full regression 431/0 under flag, green_scale under flag
7. ASAN sweep of leak_baseline + green_scale under the flag for UAF/double-free
8. commit SOURCE ONLY (nova_compiler.nova; never commit gen*/exe/.ll artifacts or test_programs/_*.txt scratch)
If step 4 diverges or step 6/7 shows any UAF -> REVERT (a single double-free is a hard fail, not a tunable).

## Free zero-risk side-action (fold in, do not campaign)
Correct the STALE comment at nova_compiler.nova L15700-15702 ("W5b-compiled compiler cannot correctly self-compile ... Keep opt-in until escape analysis handles compiler's own code patterns"). FALSE at HEAD: iter-80 proved byte-identical W5b self-compile, iters 81-82 made the suite W5b-sound. The real reason W5b is off is now the unweighed leak-vs-no_rc-clean-drop tradeoff + the un-run flip gate, NOT a self-compile failure. Leaving it misleads a future engineer.

## Deferred / declined
- W5b default-flip: DECLINED. Near-neutral on leaks (return-only drops cannot touch the per-iter headline leak), eroded benefit, ~40-min cost, residual UAF surface, and S2.5 is designed to delete the heuristic outright. Keep W5b as a guarded opt-in artifact.
- WASM: DEFERRED to a scoping spike first (measure tag-divergence frequency in-browser) before it is ever ranked #1 again; the production fix (m7) is wasi-sdk-blocked here.
- TLS-Windows: sequenced AFTER S2.5, gated on the cert-validation security decision (test-only MANUAL validation, never weaken the shipped client).
- GPU source-to-kernel, remote_spawn closures: deep multi-iteration campaigns, real frontier, lower charter-leverage than S2.5 this iteration.
- Additive polish (Unicode collation, HTTP chunked, newtype erasure, call_by_name>16): low-risk filler between deep iterations.
- BLOCKED (record-only): ARM/aarch64 fibers (no ARM/QEMU oracle), WASM-m7 (no wasi-sdk sysroot), beat-C scalar struct-passing (FALSIFIED 2026-06-12).
## HAND-VERIFICATION (iter-83) -- the #1 target is right, but its proposed first-step is UNSOUND

The top pick was hand-verified against the live tree before acceptance. Two results:

1. CONFIRMED (empirically + by source): the W5b work of iters 80-82 made W5b SOUND but did NOT
   reduce the headline leak. leak_baseline_test prints list=2000 dict=2000 chan=2000 IDENTICAL
   with NOVA_T8_DROP=0 and =1 (measured this iter). Root cause source-verified: slot_store emits
   a bare store and never rc_dec's the overwritten value (RC_COMPLETENESS.md L20-21), and W5b
   drops fire only at function return, never per-iteration reassignment. So the genuine #1
   correctness debt (the loop-local-reassignment leak) is still open. The audit ranked it #1
   correctly. The stale in-source comment at nova_compiler.nova L15700-15702 ("W5b-compiled
   compiler cannot correctly self-compile ... Keep opt-in") is now FALSE (iters 80-82 proved a
   byte-identical W5b self-compile + suite-soundness) and should be corrected.

2. CORRECTED: the audit's proposed first_sound_step (emit rc_dec(old) at slot_store when the NEW
   value is provably a same-block fresh allocation) is NOT sound as specified. rc_dec(old) safety
   depends on the OLD value (the one being overwritten) being OWNED and UNALIASED -- NOT on the
   NEW value being fresh. RC_COMPLETENESS.md L38-56 already analyzed and rejected this exact
   shortcut. Two concrete UAFs the NEW-fresh gate does not prevent:
   - let x = arr[0]; x = [fresh]  -- NEW is fresh, so the gate fires rc_dec(arr[0]); but arr[0]
     is a BORROWED element (arr owns it at RC=1), so this frees arr's live element -> UAF.
   - let y = x; x = [fresh]  -- y is a raw alias of x with no rc_inc; rc_dec(old) frees y's
     target -> UAF.
   x=[fresh] and the for-in borrowed-element store lower to IDENTICAL slot_store IR; a
   flow-insensitive flat map cannot separate owned from borrowed (RC_COMPLETENESS.md L52-54).
   The safety of the drop is a property of the SLOT (every value it ever holds is owned, and its
   value is never aliased/escaped), not of any single store's RHS.

THEREFORE the sound iter-84 first step is RC_COMPLETENESS.md Stage 1: the OWNED-vs-BORROWED
provenance bit in the IR -- OWNED iff produced by an allocating site and not aliased; BORROWED iff
from index_get / field_get / param / deep-copy-share. Pure metadata, must change ZERO codegen
(byte-identical reconverge gen5.ll == gen6.ll is the gate). This makes ownership KNOWABLE, which
is the precondition for any sound drop. The leak-reducing drop (RC_COMPLETENESS.md Stage 2/3 --
rc_dec on overwrite + scope-exit, with rc_inc on every aliasing copy, a no-op on BORROWED slots)
comes in later iters gated on that provenance, validated against the leak_baseline oracle
(deltas -> ~0) AND an ASAN sweep AND green_scale, byte-identical when the flag is off. Do NOT emit
a drop-slice before the provenance foundation exists -- that is the unsound shortcut above.

NET: iter-84 = RC_COMPLETENESS.md Stage 1 provenance foundation (sound, byte-identical), folding in
the free stale-comment correction at L15700-15702. The audit's #1 TARGET stands; only its
first-step is replaced with the sound one.
