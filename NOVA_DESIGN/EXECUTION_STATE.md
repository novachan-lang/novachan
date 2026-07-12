# NOVA — EXECUTION STATE (live dashboard)

> **Goal:** complete CORE NOVA per `NOVA_MASTER_PLAN_2026_07_10.md` — every language feature + a full
> standard library, competitive with C/C++/Java/Python/Go/Erlang/Elixir/Rust (parity or ~1× beat), to
> JDK-scale (~200k+ lines) — BEFORE any framework work. Update this file in EVERY commit. Resume from here.
>
> **The gate (every change):** edit → precheck → build → **reconverge gen5==gen6 (compiler changes)** →
> regression BOTH modes → ASAN on risk surface → commit. Kill-on-timeout always. No cracked foundations.

## Two streams
- **Stream 1 — Opus (compiler/runtime foundation)** — `nova_compiler.nova` + `nova_runtime.c`. Sequential,
  reconverge-gated. Soundness FIRST, then language ceilings, runtime builtins, backend/FFI.
- **Stream 2 — Sonnet fleet (stdlib breadth)** — pure-NOVA modules in `std/`. Parallel, KAT-gated, one
  commit/module, NO reconverge. Independent libs start now; feature-dependent libs wait for Stream 1.

## ⏱ EXECUTION RHYTHM (OWNER RULE — do NOT violate)
- **UPDATED 2026-07-13: ~100 plan tasks IN ORDER, THEN one full arc** (owner raised 30→100 for the autonomous run;
  "just check syntax/compile and go ahead" per task; end-of-100 testing must be done very correctly). FULL AUTONOMY —
  do NOT stop or ask; decide independently. Sonnet-fleet builds / Opus verifies + commits.
- **Complete ~100 plan tasks IN ORDER, THEN one full arc.** NOT an arc every few commits (that was the mistake).
- Between tasks: FAST check only — gen4-probe / KAT / standalone-run. **Pure-NOVA stdlib (Stream 2) needs NO reconverge.**
- The full arc (per ~30 tasks) = reconverge gen5==gen6 IF the compiler/runtime was touched + full nova_ci BOTH modes.
- Tick ✅ in THIS file + the master plan as each task lands. `std/`=stdlib home; `forge/`=framework only. Production-grade always.
- Anti-dup: NEVER shadow a NATIVE builtin (deque/pq/lru/ringbuf/…); forge-overlap is OK (std/ is the canonical stdlib home).

## Current focus
- **Stream 2 (ACTIVE — 30-task batch): JDK-scale `std/` breadth.** Goal ~200k+ lines; std/ barely started.
  Marching genuine KAT-gated non-native-shadow modules; ONE full-CI arc per ~30 modules.
- Stream 1 (parallel, sequential): **CORE_GAP 0.11 = ✅ DONE** (`bfc55fba`+`29e380c1`, re-verified). Next = **Wave B #6
  MOVE-on-insert** (leak confirmed 2001, gated `_move6_insert_leak_test`; XL/UAF-prone — borrow-builtins must stay rc-inc).

## Stream 1 — compiler/runtime (Opus) — status
| Item | Phase | Tier | Status | Commit |
|---|---|---|---|---|
| 0.8 struct-field-leak | 0-A | A | ✅ DONE | fb1167cf |
| 0.11 float-return-uninit | 0-A | A | ✅ DONE + RE-VERIFIED (stddev=1.4142; `bfc55fba`+`29e380c1`) | 29e380c1 |
| abs(float) mistypes return -> i64/pointer | 0-A | A | ✅ DONE (compiler types abs-of-any 'any' + runtime nova_rt_abs re-boxes) | 058cbea5 |
| is_dict/is_list/is_* return 0 on any-typed | 0-A | A | ✅ DONE (new nova_rt_type_pred; compiler emits runtime check for undecidable case) | 441819d6 |
| type_of() returns "int" for float AND bool (can't discriminate scalars) | 0-A | C | ⬜ NEW (found via std/data/schema; runtime nova_rt_type_of@4700 has no FLOAT/BOOL case → default "int". is_float/is_bool on any therefore weak. Now also limits std/data/tomlwrite+yamlemit bool fidelity. Fix = box-kind checks in type_of) | |
| int from LIST ELEMENT inside while loop, forwarded to a fn param, arrives as corrupted FLOAT (i64 bitpattern reinterpreted as double) | 0-A | B | ⬜ NEW (found via std/encoding/braille cyc6-b24; `_pow2(dots[i]-1)` got garbage; workaround = if-chain lookup, no fn call. Likely same boxed-any/ABI class as float-return-uninit. ATTENDED — codegen) | |
| module-level `let X=<scalar literal>` read 0/"" inside fns | 0-A | A | ✅ DONE (scalar consts) via backend-agnostic AST pre-pass `inline_module_consts` — inlines int/float/str/bool module consts into reading fns (local-shadow-safe); reconverged | 1f141de9 |
| module-level NON-scalar/non-literal/MUTABLE globals still per-fn copies | 0-A | B(XL) | ⬜ REMAINS (rarer) — true-globals `@nova_g_X` storage-model change in the active ire_line backend (SSA-style; deep) + keep cg/emit byte-identical. Workaround: init inside a fn. | |
| ~~floor()/ceil() boxed-float corrupts layout~~ | 0-A | — | ❌ NOT A BUG — nova_rt_floor returns clean `(int64_t)floor(x)`, typed int. Agent misdiagnosed; float_to_int helped an unrelated float-slot issue. | |
| multi-line list/dict literal in module body silently aborts module parse | 0-A | B | ⬜ NEW (whole import yields 0 symbols; use single-line/if-chain; found via calendar) | |
| trait-conformance sig type-check (LOCK-3) | 0-A | A | ✅ DONE (gen4-verified; reconverge at arc) | (batch 1) |
| user-enum payload typing | 0-A | A | ✅ DONE (gen4-verified; reconverge at arc) | (batch 1) |
| **enum float-payload unbox** (codegen) | 0-A | A | ✅ FIXED + CERTIFIED (gen5==gen6, 1155/0 both modes) | (task 5) |
| `==` NFC/NFD helper | 0-A | C | ❌ DROPPED — not a gap (byte-equality is correct; matches Python/Rust/Go — NFC-by-default would be *wrong*) | |
| `1<<64` shift guard | 0-A | C | ✅ DONE (gen4-verified; reconverge at batch arc) | (batch 1) |
| lexer: numeric separators | 0-A | C | ✅ ALREADY DONE (decimal/hex/binary all strip `_`; audit stale) | |
| lexer: `\u{}` escapes / labeled break | 0-A | C | ⏸ DEFERRED (low-value: `from_codepoint` covers `\u`; labeled-break is involved, not a quick win) | |
| RC: push/closure/reassign leaks (MOVE-on-insert) | 0-B | A | ⬜ Wave-B #6 NEXT (leak CONFIRMED 2001; gated `_move6_insert_leak_test` 83650843; design=MOVE owned-temps only, borrow-builtins stay rc-inc=the 0.10 UAF) | |
| RC cycle collector | 0-B | A(XL) | ⬜ | |
| ARM aarch64 fibers | 0-C | B | ⬜ | |
| N>1 per-carrier I/O | 0-C | B | ⬜ | |
| ALPN + Windows TLS server | 0-C | B | ⬜ | |
| FD_SETSIZE Linux guard | 0-C | B | ⬜ | |
| safepoint preemption + kill (LOCK-5) | 0-C | A(XL) | ⬜ | |
| constant-time `@ct` + `Secret<T>` (LOCK-7) | 0-C | A | ⬜ | |
| module namespacing `@mod__fn` (LOCK-1) | ceil | A | ⬜ | |
| sized/unsigned numerics + f32 (LOCK-4) | ceil | A(XL) | ⬜ | |
| annotations→codegen (LOCK-2) | ceil | A(XL) | ⬜ | |
| macros/comptime | ceil | A(XL) | ⬜ | |
| const generics · variance · assoc types | ceil | A | ⬜ | |
| custom index/iter/call operators | ceil | A | ⬜ | |
| enforced immutability `let mut` | ceil | A | ⬜ | |
| `@cdecl` FFI callbacks (LOCK-6) + struct-by-value | ceil | A | ⬜ | |
| monotonic type-id vtables | ceil | A | ⬜ | |
| explicit SIMD path | ceil | A | ⬜ | |
| runtime builtins: math (D11) | rt | C | ✅ DONE (isnan/isinf/clamp/copysign/fma/nextafter/lgamma/erf; reconverge pending) | (batch 2) |
| runtime builtins: PRNG (D8) | rt | C | ✅ DONE (xoshiro256** seedable: rng_new/next/int/float; reconverge pending) | (batch 2) |
| runtime builtins: signals/sockets/glob/sync/pack | rt | B/C | ⬜ | |
| regex capture-group engine | rt | B | ⬜ | |
| GPU lowering (SPIR-V/PTX) · MCU triples | backend | A(XL) | ⬜ | |

## Stream 2 — std/ stdlib (Sonnet fleet) — status
| Module | Category | Needs (Stream 1) | Status | Commit |
|---|---|---|---|---|
| forge_xmlparse (D5 XML parser) | data | — | ✅ DONE (ACCEPT) | a051c26a |
| forge_signum (D4 signed bignum) | numeric | — | ✅ DONE (fixed INT_MIN) | d708af6f |
| forge_blake2b (RFC 7693 hash) | crypto | — | ✅ DONE (fixed validation) | d708af6f |
| forge_hamt (D7 persistent map) | collections | — | ✅ DONE (fixed real-trie) | d708af6f |
| **JDK-SCALE BREADTH — 199 modules (cyc1-5; cyc5 arc ALL GREEN both modes, 1344 tests)** | (all) | — | ✅ DONE (each KAT-gated + independently re-verified; ONE full-CI both-mode arc per cycle) | cyc1 b80b7e24·3dc1086d·b4641598·2f5fba65 · cyc2 85fa62b2·d29951ec·fd4d82bc·d0699a19 · cyc3 01d9214e·ac7f0287·febd7584·753a5256 · cyc4 bce96075·5c57e071·2537a25c·30b1f453 · **cyc5 [30] 7119ba60·d4fb830a·f64fa588·2ab40967 (arc green)** |
|   ↳ cyc5 adds (io/* gap + algos) | platform·httpheaders·httprequest·crc16·summary·idgen·wraphard·xmlbuild·primes·mimetype·multiset·trie·graph·soundex·cookie·polynomial·bytebuffer·linereader·textwriter·jsonpath·ngram·tokenize·fixedpoint·varint·checkdigit·radix·consistent·shuffle·csvdict·sample | (all) | — | ✅ | |
|   ↳ cyc6 (100-task) DONE — **104 modules** (b21-b29), ~303 std/ total | b21 33ba6e97 hash+numth · b22 f6ac45c5 numth2 · b23 b33ab525 collections(12 data-structs) · b24 9840524d encoding+data · b25 d10eea58 text-NLP+data · b26 757e1b29 time+numeric+math · b27 ddc4575e os+config+io+random · b28 76cddc5e util+math+spatial+crc32 · b29 0951a00c util+math+data+text | (all) | — | ✅ (arc: 1429 PASS, only FAIL = https_client_test TIMEOUT = transient network flake, PASSES on isolated retry; both-mode re-run bzky90z0z in progress for clean FULLRC leak-check) | |
|   ↳ cyc4 adds | logging·httpdate·wcwidth·btreemap·useragent·roundmode·proplist·typename·stats_ext·env·flatten·frozendict·iprange·hexdump·shellquote·combinations·query·worddiff·whitespace·normaldist·schema·ipclass·morse·acronym·percent·pigify·reverse_words·pipe·gcd_list·netmask | (all) | — | ✅ | |
|   ↳ cyc3 adds | http_status·similarity·sequences·base64·indexmap·box·enumflags·graycode·color·ipv6·geo·ratelimiter·banner·cron·damerau·jsonmerge·url·orderedset·rot13·metaphone·latin1·deepcopy·highlight·titlecase·mime·humanize_number·uuencode·introot·frozenlist·portname | (all) | — | ✅ | |
|   ↳ collections | unionfind·ordereddict·bloomfilter·sortedlist·bimap·trie·graph·multimap·fenwick·rangeset·defaultdict·segmenttree | — | ✅ | |
|   ↳ text | distance·format·tablefmt·shlex·roman·ordinal·pluralize·soundex·ansi·diff·wordcount·lorem·truncate·naturalsort | — | ✅ | |
|   ↳ math | numtheory·geometry2d·combinatorics·bits·quaternion·easing·polynomial·regression·angle·primesieve | — | ✅ | |
|   ↳ encoding/data | inifmt·properties·jsonpointer·ascii85·quotedprintable·ndjson·tsv | — | ✅ | |
|   ↳ util/net/time/other | itertools·func·hash/noncrypto·cli/args·random/dist·querystring·mac·cookie·stopwatch·humanize·calendar·retry·nanoid·humansize·ulid·validate·dotenv | — | ✅ | |
| forge_decimal (D2 BigDecimal) | numeric | signum | ⬜ Wave-2 | |
| forge_argon2id (KDF) | crypto | blake2b | ⬜ Wave-2 | |
| forge_unicode (D6 casefold/graphemes) | text | — | ⬜ Wave-2 | |
| S2 HTTP-client redirects/cookies | net | — | ⬜ Wave-2 | |

*(Wave-1 = 4/4 landed, each KAT-gated + adversarially verified; the verify pass forced fixes to hamt/signum/blake2b before accept.)*

## Batch log (what we did per task; full-arc runs after ~10 tasks)
### Batch 1 (Phase-0 foundation) — ✅ FULL-ARC CERTIFIED (2026-07-11)
**Arc result:** `nova_ci.ps1` ALL GREEN — reconverge **gen5 == gen6 byte-identical** (gen5 installed as
gen3_test.exe/nova.exe), all feature gates PASS, negative gate PASS (incl. the 3 new Wave-A negatives),
**regression 1154 PASS / 0 FAIL / 2 SKIP in BOTH NORMAL and FULLRC modes**. The 4 new positive guards
(_shift64_guard / _trait_sig_ok / _enum_payload_ok / _floatret_uninit) run green in both modes. The 3
compiler changes (1<<64, trait-conformance, enum-payload) preserve the self-hosting fixpoint. Wave A
soundness = DONE. Next: task 5 (float-payload codegen, empirical) then the breadth phase.
1. **0.11 float-return-uninit → GUARDED.** Investigated: does NOT reproduce on the current post-0.8 compiler
   (correct at -O0 and -O2). Root: the garbage-uninit path is closed — every local slot (incl. all float
   locals) gets `store i64 0` zero-init at fn entry, and complex float returns (`sqrt(variance(xs))`) lower
   to pure SSA (no uninit temp). Action: tightened `_floatret_uninit_test.nova` from CI-safe (always exit 0)
   to a HARD ASSERT on stddev≈√2 + pearson≈0.7746, so any future layout shift that re-triggers it fails LOUD
   with a live repro. Test-only change (no compiler edit → no reconverge). *Next arc validates.*
2. **`1<<64` shift-UB guard -> DONE.** LLVM `shl`/`ashr` by >= bit-width is POISON (the `1<<64 -> garbage`
   bug). Fixed the ire emitter (nova_compiler.nova ~16462): mask the amount `& 63` for a valid shift +
   `select` the defined big-shift result (NOVA wraps: `shl`>=64 = 0; `ashr`>=64 = sign-ext). LLVM -O2
   constant-folds the guard away for constant amounts (zero cost); variable amounts keep it. gen4 built
   (compiler self-compiles with the new codegen) + `_shift64_guard_test` PASS (13/13). Compiler-only. Reconverge at arc.
3. **lexer scan (no code change):** numeric separators ALREADY done; `==`NFC/NFD is NOT a gap (byte-eq
   matches Python/Rust/Go); `\u{}` + labeled-break deferred (low-value; `from_codepoint` covers `\u`).
4. **trait-conformance signature TYPE check (LOCK-3) -> DONE.** Prior state checked name + arity only; a
   same-name/same-arity impl with WRONG param/return types was silently accepted -> unsound under DYNAMIC
   dispatch (runtime returns/consumes the impl's value AS the trait's declared type = type confusion).
   Fix: record self-excluded param type annotations + return type for trait methods AND impls (4 new TiState
   dicts), then compare in ti_check_trait_conformance. Conservative `_sig_type_compatible`: fires ONLY on
   provably-distinct primitives (int/float/bool/string/bytes); unannotated/`any`/user-type/generic slots
   pass (no false positives — inference + call-site unification guard those). New E1006 message. gen4-verified:
   OK impl compiles+runs; bad-return + bad-param REJECTED with precise messages; dyn_trait/bounds compile
   (no false positive); conformance_test still errors correctly. (phase75_default is a PRE-EXISTING failure,
   identical under old gen3 — unrelated from_json_safe orphan.) Compiler-only. *Reconverge at arc; wire the 2
   negatives into the neg-test gate at arc.*
5. **user-enum payload TYPING -> DONE.** Matching a USER enum variant `Circle(r)` bound payload vars to a
   fresh type var (untyped) — unlike the built-in Ok/Err/Some/None path — so payload misuse went uncaught
   (a float payload used as a string unified to `string` -> the runtime treated float bits as a string
   pointer = type confusion). Fix: record ordered payload field type annotations per variant (new TiState
   `ti_variant_ptypes`, populated in the enum pre-pass), and at match bind each positional binder to the
   DECLARED type. Conservative — concrete types only (empty/generic/`var` -> fresh, no regression).
   gen4-verified: bad test (float payload -> needs_string) COMPILED on old gen3 (unsound) but is REJECTED on
   gen4 (hole closed); int-payload OK test runs (move sum=7, wait=10); existing enum tests byte-identical
   gen3/gen4 (no regression). Compiler-only. *Reconverge at arc.*
   **DISCOVERED (task 5, separate pre-existing CODEGEN bug):** a FLOAT enum payload extracts as its raw
   IEEE-754 i64 bit-pattern (garbage, e.g. `str(r)`=4617315517961601024 for 5.0) instead of unboxing to a
   float — happens for the single-field float variant (`Circle`) routed through an `any`-typed fn param; the
   2-field `Rect` and direct single-variant `F(x:float)` unbox fine. Identical on gen3 -> NOT my change;
   boxed-float-through-any-variant unbox class. High-value (enums with float data are common). Next task.

   **FULL DIAGNOSIS (for the fix, do empirically after the arc):** The match-arm payload binder codegen at
   nova_compiler.nova ~8531-8544 (`m_pt == "pat_ctor"` loop) emits `field_get m_fd ir_type_any() [subject]
   m_fpv m_fi` and then sets the binder's codegen type via `ir_match_ok_payload_stype` — which returns a
   type ONLY for built-in Ok/Some (7479). For a USER variant it returns "" -> `b.ir_locals[m_fpv] = 1`
   (the any/default code). So the binder's static type is lost. Consumer = `ir_expr_struct_type` (8738-41):
   for an ident it returns `b.ir_locals[ev]` when that is a struct name OR a builtin-type name
   (`_is_builtin_type_name` @8702 = int/float/string/list/dict/bool). So the ENCODING to set is the
   declared type STRING ("float"), not `1`. The variant's ordered field types are already available as
   `b.ir_sdefs[m_pv]` = list of `Param(name, type, _)` (populated @18082). FIX TEMPLATE (mirror the struct
   field-access path @8316-8333): for each payload position m_fi, read `b.ir_sdefs[m_pv][m_fi-1]` -> field
   ann; set the `field_get` result type (float/int/str) like @8324-8329 AND set `b.ir_locals[m_fpv]` to that
   ann string. CAVEAT/why empirically: `Circle`(1 field) corrupts but `Rect`(2 fields, same enum) works —
   so the raw-vs-boxed representation of variant scalar payloads may differ by arity; setting ir_locals=
   "float" on an already-correct (Rect) path could BREAK it. MUST build gen4 + test Circle AND Rect AND F
   AND existing enum_test/enum_full_test, iterate. Also 3 match codegen sites exist (~8503, ~9406, ~9676) —
   check which the repro hits. DEFERRED to a focused build-test loop right after the Wave-A arc.

### Batch 2 (breadth + runtime builtins) — reconverge in progress
- **task 5 float-enum-payload** → FIXED + CERTIFIED (`29e380c1`). See Stream-1 table + memory.
- **Breadth Wave-1 (Stream-2 fleet, 4/4 landed):** forge_xmlparse (`a051c26a`), forge_signum + forge_blake2b
  + forge_hamt (`d708af6f`). Each KAT-gated by an impl agent + ADVERSARIALLY VERIFIED by a second agent that
  independently recomputed the KATs — the verify pass caught + forced fixes to: hamt (was a flat 32-bucket
  table, not a trie → real leaf/internal split, maxdepth 3-4 at scale), signum (sn_from_int(INT_MIN) double-
  minus corruption → parse str(i)), blake2b (missing out_len/key validation). Pure-NOVA LEAF modules → no
  reconverge; canonical import tests in the manifest.
- **D11 extended math** (isnan/isinf/clamp/copysign/fma/nextafter/lgamma/erf) + **D8 seedable PRNG**
  (xoshiro256** over a 32-byte NOVA-managed bytes state: rng_new/rng_next/rng_int/rng_float). Runtime +
  compiler (name-map, type schemes, 2× LLVM declares, raw-double lists). gen4-tested: D11 14/14, D8 5/5
  (determinism/seed-independence/range/reproducibility). Reconverge (gen5==gen6) + full both-mode regression
  running now — validates D11 + D8 AND re-certifies the 4 breadth modules. Commit after green.
