# NOVA Frontier Re-Audit #3 -- 2026-06-14 (iter-70 synthesis / iter-71 pick)

ONE-LINE SUMMARY
The clean-additive frontier from re-audit #2 is exhausted (REPL/OpenSSL/compression all
shipped); after a 7-agent re-audit + HAND-VERIFICATION, the iter-71 pick is the ZIP archive
reader -- because the workflow's #1 (a "full-stack flagship") is LARGELY REDUNDANT with demos
that already exist (the workflow's premise that it was "never shown together" is false).

Produced by a 7-agent workflow (4 grounding readers -> synthesis -> adversarial -> recommend),
then every load-bearing claim hand-verified against the live tree.

## What re-audit #2 left, and what is now done
Re-audit #2's 5 frontiers: #1 REPL (DONE iter-67, 977757b), #2 OpenSSL/HTTPS+TLS (DONE iter-68,
e8e96a1 @ fixpoint C9E463FB), #5 compression/dynamic-Huffman gzip inflate (DONE iter-69,
6ea5553). Still-open: #3 remote_spawn/transparent-channel-routing (a closure-serialization
DESIGN problem, multi-iter), #4 Unicode collation + case-fold (NFC/NFD are now DONE per the
iter-69 ledger fix; only collation + case-fold remain, ~100KB data tables).

## Ranked candidates (workflow output)
  Rank | Candidate                                                  | Class           | Tract | Risk
  1 | Full-stack flagship assembly (routerx + bounded serve_n)    | demo            | high  | low
  2 | ZIP archive reader (zipx.nova) over the inflate engine      | new-file        | high  | low
  3 | SQLite persistence (pre-build sqlite3.o + nova_link .o path)| compiler-source | med   | low
  4 | THE LEAK -- bounded DIAGNOSIS of W5b (do NOT flip default)  | compiler-source | med   | high
  5 | Distributed-channel length-framing (rchanx via node_* frame)| new-file        | med   | low

## HAND-VERIFICATION CORRECTION (why the iter-71 pick is #2, not #1)
The workflow ranked the full-stack flagship #1 on "vision-credibility-per-risk." Hand-checking
the tree shows that flagship LARGELY ALREADY EXISTS:
  - demo_full_stack_test.nova: "ONE NOVA binary, NINE frameworks composed in the same process
    tree" -- forge HTTP (with a route() dispatcher) + cortex AI classify + pulse + mesh +
    sentinel + ops + reactor + prism + edge, each oracle-verified. This IS the full-stack
    flagship. (In the regression.)
  - demo_cortex_serve_test.nova: a real cortex+forge ML-inference HTTP server (TCP accept ->
    HTTP parse -> matmul -> softmax -> argmax -> JSON), bounded serve_n. (In the regression.)
  - Plus demo_http_server_test, real_http_api, demo_forge_*; the WASM full-stack flow already
    RAN live (_wasm_fullstack_oracle.cjs -> FULLSTACK_OK); Railway HTTPS deploy returned class:1.
A new routerx+cortex+forge demo would duplicate these with only marginally richer routing -- a
DEMO (no new capability) on top of demos that already prove the identity. Marginal value.
So the iter-71 pick is #2: the ZIP reader -- the only top candidate that is genuinely NEW
capability AND clean (pure-NOVA, zero reconverge) AND has no contested premise.

## Adversarial verdicts (top 3)
  - #1 flagship -> AVOID-AS-PRIMARY (redundant, per the hand-verification above). The one real
    gap it would add (spawn-per-connection concurrency) is exactly the spawn/channel escape
    surface the leak campaign is stuck on -- defer. Optional tiny follow-up: add explicit
    routerx routing to demo_full_stack_test if richer routing is wanted; low priority.
  - #2 ZIP reader -> SAFE-TO-PICK. deflatex.nova is a complete RFC1951 inflate (stored+fixed+
    DYNAMIC, multi-block, .gz FNAME/FEXTRA parse, CRC32). A ZIP reader parses
    EOCD -> central directory -> local headers and reuses inflate + _crc32 verbatim. Pure-NOVA,
    new-file, zero reconverge, deterministic oracle (a real .zip from .NET ZipFile). Table-stakes
    for build-anything: .jar/.docx/.xlsx/.apk/.nupkg are ZIP.
  - #3 SQLite -> PICK-WITH-CARE later. The synthesis's "cheap build-line edit" premise is FALSE:
    nova_link emits -l<name> only and cannot compile the 257k-line bundled sqlite3.c amalgamation;
    making SQLite link is a COMPILER-SOURCE change (same reconverge cost as the leak). Sound first
    step (future): prove the FFI end-to-end via a manual clang link against a pre-built sqlite3.o,
    THEN budget the nova_link change. High value (DB is the one missing full-stack leg) but not
    this iter's clean win.

## ITER-71 PICK: ZIP archive reader (zipx.nova)
A pure-NOVA module that reads a real ZIP archive: scan for the End-Of-Central-Directory record
(signature 0x06054b50, from the end), read the central-directory entries (0x02014b50: name,
compression method, sizes, CRC32, local-header offset), then per entry read the local file
header (0x04034b50) and inflate the data (method 8 = deflate, reusing deflatex.inflate; method
0 = stored = copy), verifying CRC32 via deflatex._crc32. Expose zip_open(bytes)->entries,
zip_names(z), zip_read(z, name)->bytes.

FIRST SOUND STEP
Create zipx.nova importing/reusing deflatex's inflate + _crc32 (or include the needed helpers).
Implement EOCD scan + central-directory parse + per-entry local-header + inflate(method 8)/copy
(method 0) + CRC32 verify. Oracle: a real multi-file .zip produced by .NET System.IO.Compression
.ZipFile (or PowerShell Compress-Archive), embedded as a byte vector (like the iter-69 gzip
oracle) or a committed .zip; assert zip_names + zip_read of each entry == the known contents.

GATE (new-file -> cheapest; kill-on-timeout MANDATORY)
  1. Compile zipx.nova + its test with the DEFAULT compiler (C9E463FB); 0-byte lint-err.
  2. Run the test: open the oracle .zip, assert names + per-entry decompressed bytes match.
  3. Full regression (register the test) 426 -> 427, 0 FAIL 0 SKIP 0 SUSPECT.
  4. green_scale N=1 PASS.
  5. NO reconverge (zipx.nova is a stdlib program, not a bootstrap input; compiler/runtime
     untouched). Commit source only.

## Deferred (and why)
  - Full-stack flagship -- already exists (demo_full_stack_test + demo_cortex_serve_test). Only a
    minor routerx-routing enhancement remains; low priority.
  - THE LEAK (W5b/S3) -- #1 correctness debt, but the bounded step is DIAGNOSIS-ONLY (do NOT flip
    W5b default-on: a UAF is strictly worse than the leak; iter-58 proved the W5b-compiled compiler
    UAF-crashes on green_scale). Value-model-landmine-adjacent + ~40-min reconverge per attempt in
    this memory-pressured env. A dedicated future campaign, not a clean iter win.
  - SQLite persistence -- high value (DB = the missing full-stack leg) but compiler-source
    (nova_link must learn to compile/link a .o, not just -l). Prove the FFI via a manual sqlite3.o
    link first, then budget the reconverge.
  - remote_spawn/transparent channel routing -- needs a closure/code-serialization design that does
    not exist; multi-iter.
  - Unicode collation + case-fold -- ~100KB generated data tables; effort, not cleverness; modest
    impact (NFC/NFD already shipped).
