# STDLIB 100-TASK CAMPAIGN — Backlog & Ledger

**Rhythm (owner, 2026-07-13):** develop tasks ONE BY ONE, continuously, NO stopping. Per-module
compile+run+KAT during build (fast, correctness gate). **NO mid-campaign full arc** — run the heavy
`nova_ci` both-mode (NORMAL+FULLRC) arc **ONCE at the end of ~100 tasks.** A task = 1 coherent library
(~12 modules). Modules written to BOTH `std/<cat>/` AND `nova-compiler/std/<cat>/` (byte-identical);
KAT tests in `nova-compiler/test_programs/_<mod>_test.nova`; add to `_orphan_coverage_manifest.txt`.

**Sourcing:** backlog is grep-verified against the existing std/ tree (gap-analysis workflow `wwr9euk59`,
12 domain surveyors vs JDK/Python/Go/Rust). std/ is very mature (math 72, text 65, collections 48…) —
every task below was dup-checked absent. Ordered LOW-RISK / high-value first.

## DONE (per-module KAT-gated at build; final both-mode arc deferred to campaign end — see rhythm)
## Campaign at **47 tasks committed** (2026-07-16). Strategic note: owner directed libraries are CONTINUOUS/
## open-ended — build high-value ones, then SHIFT to the NOVA_MASTER_PLAN (language ceilings + frameworks).
## Pivot underway after the last high-value general libraries (crypto batteries).
| # | Task | Modules | Commit |
|---|---|---|---|
| 1 | std/compress/ | 12 | cdac0a6b |
| 2 | std/finance/ | 12 | f8a20eb3 |
| 3 | std/color/ | 12 | bf7b7c05 |
| 4 | std/automata/ | 12 | 9e0cfc5d |
| 5 | std/validation/ | 12 | e2c38ad7 |
| 6 | std/dsp/ | 12 | 0d8b9765 |
| 7 | std/testing/ | 12 | ec43eec6 |
| 8 | std/media/ (image+audio codecs: ppm pgm pbm pam bmp tga qoi farbfeld png xpm ico wav) | 12 | df3d1d7b |
| 9 | std/net/dns (RFC 1035 message codec: name-compression/header/question/rr/rdata-a/txt/mx/soa/srv/message/query-EDNS0) | 12 | 1fb6637f |
| 10 | std/time/ depth (isoweek/period/strftime/strptime/holiday-easter/businessday/pduration/age/quarter/daycount/weeknum/reltime) | 12 | cbde0113 |
| 11 | std/net/ inetproto (ipv4/ipv6/tcp/tcpopts/udp/icmp/arp/eth/pseudo/ntp/dhcp + inet checksum) | 12 | 77aad8da |
| 12 | std/data/asn1 (DER/BER: tag/length/int/bool/null/oid/octetstring/bitstring/string/time/seq/parse) | 12 | a3e31a17 |
| 13 | std/collections/ heaps (daryheap/skewheap/heapsort/indexedpq/minmaxheap/intervalheap/leftistheap/binomialheap/weakheap/heapselect/kwaymerge/radixheap) | 12 | 08e09122 |
| 14 | std/hash/ breadth (crc8/crc16/crc32c/crc64/fnv64 + xxh32/xxh64/murmur3_32/murmur3_128/siphash/hashcombine/classichash) | 12 | fcdb35ff + bc239644 |
| 15 | std/parsing/ toolkit (calc/exprvars/rpn/pratt/peg/combinators/tokenizer/glob/jsonpath/wildcard/template/numparse) | 12 | 45f2353a + e9736b3d |
| 16 | std/text/ diff+patch (diff_lcs/diff_char/diff_patience/diff_histogram/diff_myers/unified_emit/unified_parse/patch_apply/patch_reverse/diff3_merge/conflict_format/patch_stats) | 12 | bd3e8542 + 53e08098 |

| 17 | std/term/ ANSI (color16/color256/style/cursor/screen/strip/box/progress/spinner/hyperlink/columns/gradient) | 12 | 3dbac697 |
| 18 | std/random/ PRNG engines (mt19937/pcg32/splitmix64/xoshiro256/xoshiro128/lcg/well512/lfsr/wyrand/jsf64/sfc64/lehmer) | 12 | eaf30328 |
| 19 | std/cipher/ classical (playfair/bifid/foursquare/twosquare/hill/columnar/affine/autokey/beaufort/polybius/scytale/adfgx) | 12 | 998728fe |
| 20 | std/midi/ MIDI protocol + SMF | 12 | 58f607f8 |
| 21 | std/net/lineproto application-protocol codecs | 12 | 3a1a0ab1 |
| 22 | std/compress/univcodes universal integer codes | 12 | 03674ade |
| 23 | std/music/theory music-theory | 12 | f5ddcf6b |
| 24 | std/game/cards card-game | 12 | 41e2806e |
| 25 | std/game/maze maze algorithms | 12 | 87e1db74 |
| 26 | std/data/subtitles SRT/WebVTT | 12 | c755af8e |
| 27 | std/net/binproto MQTT/CoAP/STOMP/POP3 | 12 | 5e63a90a |
| 28 | std/data/feeds feed + playlist formats | 12 | ccf6d953 |
| 29 | std/compress/adaptive dictionary+transform coders | 12 | 3c80d921 |
| 30 | std/physics/mechanics | 12 | 5d8f8ae3 |
| 31 | std/chem/formulas | 12 | 13cf1f55 |
| 32 | std/physics/waves_em waves/optics/thermo/EM | 12 | c9bdb5fa |
| 33 | std/geo/spherical | 12 | 377c5a60 |
| 34 | std/audio/synth | 12 | e8fd1504 |
| 35 | std/math/tseries time-series analysis | 12 | 0c549e06 |
| 36 | std/numeric/scientific numerical methods | 12 | 0e892a74 |
| 37 | std/game/rating rating + tournament | 12 | bc1127f3 |
| 38 | std/text/markdown Markdown->HTML renderer | 12 | 9673815c |
| 39 | std/data/geodata geo-format codecs | 12 | 86805af5 |
| 40 | std/game/puzzle puzzle solvers | 12 | 1fcd2220 |
| 41 | std/image image-processing | 12 | 54d7670a |
| 42 | std/calendar calendar-system | 12 | a4d802e7 |
| 43 | std/barcode barcode-symbology | 12 | 18eb418e |
| 44 | std/finance advanced finance | 12 | ab784b9d |
| 45 | std/numeric/distributions probability distributions | 12 | 7892247e |
| 46 | std/os pure path/binary/byte utilities | 12 | 2fc466b2 |
| 47 | binary file-format parsers — os/{elf_header,pe_coff,macho,tar_ustar,ar_archive,cpio} compress/{zip_read,gzip_member} data/{wasm_hdr,java_class,pdf_xref} media/id3 | 12 | 2cf8cc74 |
| 48 | std/crypto/ batteries (cryptanalysis merkle commitment securetok otp pwentropy blockpad randomtest) — round-trip KATs | 8 | 0d660ddc |
| 49 | std/text/ NLP+search (bm25 keyword textrank collocation nlp_eval ngram_lm stopwords langdetect sentiment readability2 summarize spellcorrect) — **INDEPENDENT ADVERSARIAL AUDIT gate added**: 3 KAT-passing modules REJECTED (summarize+spellcorrect silent-sort-corruption, langdetect dead trigram) → FIXED + re-verified with >3-elem probes | 12 | 5c4de071 |
| 50 | std/bio/ bioinformatics (seq codon kmer orf fastx restriction protein align motif phylo population seqstats) — audit: 5 clean + 5 fixed (fastx OOB-read, population hw_chi NaN, seqstats empty-MW, restriction palindrome biology, align REAL NW/SW traceback); re-verified with own probes | 12 | 131a36bc |
| 51 | std/control/ control+robotics (pid statespace transferfn dcmotor so3 quatext trajectory motionprofile discretefilter ratelimit sim1d lqr) — audit: ratelimit REJECT (neg quantize) FIXED, pid/motionprofile guards added, so3/quatext self-audited. **robotkin HELD (13th): confirmed layout-dependent float-ABI codegen bug in rk_fk — cos on raw float param; needs ATTENDED compiler fix** | 12 | e28007d7 |
| 52 | std/units/ conversions (length mass time temperature area volume speed pressure energy power data_size angle_unit) — SAFE domain (pure multiply, no trig). Audit recomputed ALL ~96 factors vs NIST/SI: all correct; 1 doc-only fix (cup label). NOTE: energy test = `_units_energy_test` (avoids `_energy_test` = std/physics/energy) | 12 | 751e97b3 |
| 53 | std/money/ INTEGER money (minor currency format parse round allocate exchange tax discount aggregate accounting validate) — cents-as-int, no floats. Audit caught systematic NEG-numerator half_up bug (exchange/tax/discount) + format sign-position, FIXED + verified with neg probes. NOTE: 5 generic basenames collided (format/round/tax/validate/parse) → tests are `_money_<mod>_test`; 7 std tests | 12 | d36771ca |
| 54 | std/framing/ stream/serial framing (cobs slip hdlc kiss lenprefix delimiter bytestuff ppp_frame crc_frame stxetx escaping reassembly) — byte-oriented, SAFE, UNIQUE basenames (no collisions). Audit: 11 clean + 1 low doc-fix (bs_overhead). Canonical vectors confirmed: COBS paper vectors, CRC16-CCITT-FALSE=0x29B1, CRC32=0xCBF43926, PPP FCS tamper-detect | 12 | bacfa1e9 |
| 55 | std/sketch/ probabilistic structures (countmin cuckoofilter countingbloom hyperloglog distinctcount streamstats topk reservoir bloomscalable minhash simhash) — invariant KATs (no-false-neg, never-underestimate, Welford exact, seed-determinism). Audit stress-tested @200 items: 5 clean + 6 low doc/tuning + topk docstring FIXED. **quotientfilter HELD (12th): not a correct QF (unused run/cluster logic, qf_count 30% under, spurious-dup drops) — needs proper rebuild** | 11 | 3ea7b976 |
| 56 | std/combinatorics/ generators (permutations subsets compositions derangement multiset_perm cartesian nextperm powerset partition_gen catalan_struct lyndon setpartition) — exact counts (n!/C/2^n/D_n/Catalan/Bell/Stirling/p(n)/Lyndon) + no-dups + identities (Euler, conjugate-involution, gray-adjacency) all audit-verified. nextperm REJECT (neg-index sort sentinel in permutation_index) FIXED + re-verified (24/24 ranks) | 12 | 78b994c5 |
| 57 | std/matrix/ linear algebra (matmul mattranspose matnorm matdet matadjugate matrank matgauss matsolve matinverse matlu matqr mateigen) — float, NO trig (safe). Audit verified ALL invariants on fresh 3x3 (A·inv=I, LU=PA, QR=A + Q orthonormal, A·x=b, A·adj=det·I, eigen trace/det). matlu singular-solve FIXED (returns []); added msv_make/mi_make constructors | 12 | 63552467 |
| 58 | std/poly/ polynomials (polyadd polymul polydiv polyeval polygcd polyderiv polyroots polyinterp polymodp chebyshev bernstein polyfromroots) — exact int-coeff arith + round-trip (q·b+r=a, from_roots eval≈0, GCD divides both). polyroots REJECT FIXED: pr_quadratic float-slot bug (inline sqrt) + pr_cubic trig-precision (replaced with bisection+deflate) → re-verified [1,2,3] eval≈0. Medium notes documented (polymodp large-p overflow, polyfromroots int-only roots) | 12 | 769255fe |
| 59 | std/interval/ (interval_arith interval_bound interval_overlap allen interval_merge interval_set interval_partition interval_cover interval_scheduling interval_stab interval_map interval_tree2) — integer/exact. Audit ALL 12 ACCEPT (scheduling optimality + weighted DP brute-force-confirmed; set difference/complement + Allen 13-relations verified fresh). Cleanest task. ib_shrink over-shrink guard added; allen point-interval limitation documented | 12 | 12372ee9 |
| 60 | std/textlayout/ (wordwrap textpad truncate_text justify textindent textcenter textfill hangindent reflow textcolumns linebreak texttable) — pure-string, exact KATs verified fresh + edge cases. 11 ACCEPT + textcolumns CONCERN (trailing whitespace on last column) FIXED (rstrip per line). texttable 'nested-loop bug' repro'd FALSE ALARM | 12 | 71b46c27 |
| 61 | std/geo/ grid encodings (pluscode maidenhead quadkey dms latlon_bbox antimeridian utm_zone tile_math grid_ref geo_normalize mgrs_grid geo_morton) — integer/string, NO trig (safe subset). Audit ALL 12 ACCEPT clean: round-trips hold + reference vectors independently verified (Maidenhead JN58td, quadkey 213 bit-checked, UTM zone 32 + Norway exceptions, DMS 40.4461, OSGB round-trip) + pole/antimeridian edge cases | 12 | 34e6a6dc |
| 62 | std/coding/ ECC (reed_muller repetition_code parity2d convolutional viterbi interleaver hadamard_code berger_code crc_param checksum_fletcher constant_weight dual_modular) — integer/bit. Audit ALL 12 ACCEPT clean: error correction verified at EVERY position (RM 8/8, Hadamard 64/64, Viterbi 12/12, TMR 24/24) + all CRC/Fletcher check values recomputed (0x29B1/0xCBF43926/0xF4/0x4B37/0xC8F0/0x024D0127) | 12 | b11f8030 |
| 63 | std/raster/ 2D graphics (bresenham thick_line raster_clip raster_circle raster_ellipse bezier_raster flood_fill polygon_fill raster_rect blit sprite_mask dither) — integer pixel math. Audit: 11 ACCEPT + raster_ellipse CONCERN (boundary pixels lie just outside exact ellipse) — verified NOT a bug (0 dups/0 asym/extremes present, standard rasterization); documented boundary-vs-containment. Bresenham reverse-symmetry, Bezier de-Casteljau, flood 4-vs-8, Bayer(2)=[0,2,3,1] verified | 12 | e7e97985 |
| 64 | std/game2d/ (aabb_collide circle_collide sat_collide spatial_hash quadtree_hit sweep_test grid_astar raycast2d tilemap steering2d collision_resolve motion2d) — float/no-trig/no-HOF. Audit ALL 12 ACCEPT: A* hand-traced optimal (len 9 around fresh maze wall) + valid path + [] no-path; SAT/MTV separates; swept-AABB TOI=gap/vel; raycast hit points exact; reflect v-2(v.n)n + impulse momentum. 2 low doc-notes (id-keying, quadtree boundary) | 12 | 205f64e3 |
| 65 | std/phonetic/ name-matching (nysiis cologne match_rating daitch_mokotoff phonex statcan_code roman_soundex onca lein phonetic_compare) — string algos, canonical reference-vector KATs. 12-skeptic adversarial audit recomputed canonical vectors INDEPENDENTLY (not trusting fleet KATs) + coverage-probed rule-heavy algos. Shipped **10**; **HELD caverphone + double_metaphone** — both are long-rule-table algos (50 / ~200 rules) and BOTH the fleet AND the auditor produced WRONG canonical values (I verified caverphone is canonically wrong on initial-vowel/internal-r/y names — drops initial vowel instead of →A, maps every r→A; DM missing initial-X→S + Spanish-LL, ~40/200 rules). No reference oracle available → deferred to attended effort w/ Apache-Commons/jellyfish oracle. FIXED before ship: phonex px_digit -1 dedup contract (was ignoring `prev`), nysiis ny_translate_char next-lookahead (EV/KN/PH/H/W now honored); cologne umlaut-comment + X-sentinel doc; daitch secondary-branch-dedup limitation documented. Rule-verified: Soundex R163/A261/T522, NYSIIS MACINTOSH→MCANTAS, Cologne 65752682, MRA BYRN, D-M 739400, LEIN digit-table, Jaro MARTHA/MARHTA 0.944 | 10 | ff89cf7c |
| 66 | std/rational/ exact fraction arithmetic (rfrac_core arith compare convert continued farey approx egyptian mixed harmonic vector format) — integer-based [num,den], first-principles reference-vector + round-trip + gcd-reduced-invariant KATs. Safe domain (hand-verifiable, no oracle needed). All 12 KATs green + hand-verified: 1/2+1/3=5/6, CF(415/93)=[4,2,6,7], F_5 (11 terms traced), egyptian(4/13)=[4,18,468], H(4)=25/12, simplest_between(2/7,3/7)=1/3, best_within(3.14,den<=10)=22/7, negatives (floor(-7/2)=-4, parse('-1 3/4')=[-7,4]) all correct | 12 | b012c57c |
| 67 | std/numeral/ number systems (bijective26 cardinal_en ordinal_en base_radix base_between factoradic zeckendorf balanced_ternary negabinary gray_code mixed_radix tally) — integer/string codecs, round-trip + reference-vector KATs (safe, hand-verifiable, no oracle). All 12 KATs green + verified: bijective col 703='AAA', cardinal 999999999999 spelled correctly, factoradic 463=[3,4,1,0,1,0]+Lehmer, Zeckendorf 100=[89,8,3], balanced-ternary 5='1TT', negabinary 6='11010', Gray to/from round-trips 0..31. Fleet died mid-run (session cap) → resumed via resumeFromRunId (cached batches instant, finished factoradic + zeckendorf/baltern/negabinary) | 12 | c27b9077 |
| 68 | std/bits/ scalar bit-manipulation (popcount bitscan bitrotate bitreverse bitfield pow2 lowbits zigzag bitpack bittricks rankselect binary_fmt) — integer-exact, reference-vector + round-trip KATs. Fresh (no dedicated bit-ops lib; bitset=data-structure, morton=2D). NOVA shift/precedence gotchas baked into brief (parenthesize & vs ==, >> is arithmetic, never shift 64). All 12 KATs green + adversarial probe PASS on the full-width/negative danger zone: popcount(-1)=64, popcount(i64_min)=1, log2_floor(1)=0, tk_abs/min/max on negatives, zigzag RT on -1e9. pow2 uses native clz builtin (63-clz) | 12 | *(this commit)* |

## GAP-MAP #2 BACKLOG (2026-07-16, grep-verified over 240-module tree) — tasks 21-50, LOW-risk first
**LOW risk (int/string/bytes, deterministic/round-trip KATs) — build first:**
- std/net/lineproto: resp2 resp3 irc syslog5424 syslog3164 ftp_reply beanstalkd memcache_text telnet_opt gopher whois_parse smtp_line
- std/bits/bits64: rotl rotr reverse next_pow2 is_pow2 set/clear/test/toggle_bit lowest/highest_set popcount clz/ctz
- std/bits/bitfield: mask extract extract_signed insert test clear_field replace pack2/3 unpack2/3 field_range
- std/bits/morton3d: encode decode x/y/z parent children neighbors distance (z-order curves)
- std/devtool/semver: parse compare valid bump range_caret/tilde/hyphen satisfies max_satisfying sort diff coerce
- std/devtool/gitignore: parse_line compile_pat match_path negation anchor double_star dir_only load match_list layer_merge explain from_string
- std/music/theory: interval scale chord mode keysig circlefifths tuning_equal/just/cents rhythm arpeggio progression
- std/functional/combinators: curry2/3 partial1/2 flip once juxt always complement converge evolve memoize_n
- std/functional/result: res_ok/err/is_ok/is_err/map/flat_map/map_err/unwrap_or/and_then/or_else opt_from/map
- std/compress/univcodes: elias_omega fibonacci_code unary exp_golomb truncated_binary start_step_stop comma interleaved_elias abs_binary byte_aligned_huff bitpack frame_of_reference
- std/net/binproto: mqtt_fixed mqtt_connect mqtt_publish mqtt_sub mqtt5_props coap_msg coap_opt coap_block stomp_frame stomp_build stomp_heartbeat pop3_reply  (LOW-MED)
- std/data/subtitles: srt_parse/build/shift vtt_parse/build/shift sub_timecode/merge/split/filter/reindex/roundtrip
- std/data/feeds: rss_parse atom_parse opml_parse/build m3u_parse/build pls_parse/build po_parse/build feed_item feed_roundtrip  (LOW-MED)
- std/game/cards: card deck deal hand_sort hand_classify hand_compare showdown blackjack cribbage war bridge_suit solitaire
- std/game/maze: grid recursive_backtracker kruskals prims aldous_broder wilsons sidewinder binary_tree eller hunt_kill solve_bfs solve_astar
- std/text/bbcode: lex parse strip to_html to_text validate color quote list url code (+nest)
- std/math/tseries: rolling_mean/var/std/min/max diff pct_change seasonal_naive trend_linear anomaly_zscore/iqr kat  (LOW-MED)
- std/sync/coordination: barrier phaser promise event_flag rwlock once_cell mailbox broadcast work_queue timeout_chan select_first gate  (LOW-MED; respect process/channel model)

**MED risk (float / complex / data tables) — build after:**
- std/compress/adaptive (adaptive-huffman/LZSS/LZ78/BWT-pipeline), std/physics/mechanics, std/physics/waves_em,
  std/chem/formulas, std/geo/spherical, std/geo/projection (float+atan2 CARE), std/audio/synth, std/devtool/uuid_ext
  (needs md5/sha1), std/text/markdown, std/text/wikifmt, std/data/geodata, std/numeric/spline, std/numeric/polyregress,
  std/game/rating (elo/glicko). NOTE geo/physics float gotchas: coerce int*1.0, bind sub-exprs to float lets.

## RHYTHM NOTE (2026-07-14): run DEPTH-1 (one 12-agent fleet at a time). Depth-2 (24 agents) drained the account
## session cap twice. One fleet at a time is the sustainable pace. **18 full tasks committed clean (216 modules).**
## New categories added this campaign: std/media, std/parsing, std/term, std/cipher. Saturated (grep first):
## collections, math, text, numeric, data, encoding, fmt-area, random-sampling.

*(History: weekly limit hit 2026-07-13 mid-task-14 → owner switched accounts → resumed, 7 hash modules re-ran from
cache, no work lost. Then depth-2 hit this session cap.)*

## BACKLOG (grep-verified, ordered low-risk-first)
| # | Task | Risk | Value | Modules |
|---|---|---|---|---|
| 9 | std/net/dns | LOW | VERY HIGH | dns_name(compression) dns_header dns_question dns_rr dns_rdata_a dns_rdata_txt dns_rdata_mx dns_rdata_soa dns_rdata_srv dns_message dns_types dns_query(EDNS0) |
| 10 | std/functional/combinators | LOW | HIGH | hof partial curry compose pipe flip scan predicate group once memoize thunk (grep-verify each vs builtins/itertools) |
| 11 | std/text/phonetics | LOW | HIGH | nysiis caverphone double_metaphone cologne phonex fuzzy_score phonetic_sim name_match phonetic_index phonetic_cluster phonetic_sort phonetic_dedup |
| 12 | std/time/depth | LOW | HIGH | isoweek period strftime strptime rrule holiday businessday pduration age quarter weeknum daycount |
| 13 | std/parsing/cli (NEW cat) | LOW | HIGH | cli_schema cli_parse cli_help cli_short cli_long cli_subcommand cli_required cli_default cli_type cli_flag cli_positional cli_env |
| 14 | std/parsing/expr | LOW-MED | HIGH | expr_tokenize expr_shunt expr_eval expr_pratt expr_ops expr_unary expr_func expr_var expr_prec expr_paren expr_assoc expr_error |
| 15 | std/net/uritemplate | LOW | HIGH | ut_parse ut_vars ut_expand ut_simple ut_reserved ut_fragment ut_label ut_path ut_query ut_form ut_explode ut_matrix (RFC 6570) |
| 16 | std/collections/heaps | LOW-MED | HIGH | maxheap indexedpq daryheap binomialheap fibheap pairingheap heapmerge heapsort heapkth medianheap intervalheap heapselect |
| 17 | std/collections/ordmap_ext | LOW | HIGH | triemap skipmap arc_cache lfu_cache circularbuf quotientfilter weightedunion seglazy fenwick2d sparsetable orderstat multiset |
| 18 | std/text/patch | LOW-MED | HIGH | diff_myers diff_patience unified_emit unified_parse hunk_parse hunk_apply patch_apply patch_reverse patch_validate diff3_merge conflict_format patch_stats |
| 19 | std/os/system | LOW | HIGH | pathutil fileutil glob tempfile loghandler argsext termctl hexdump endianio bufreader linereader envconfig (mind Win+Linux) |
| 20 | std/net/inetproto | LOW-MED | HIGH | inet_checksum ipv4_header ipv6_header tcp_header udp_header icmp_echo arp ethernet vlan pseudo_header ip_options tcp_options |
| 21 | std/hash/breadth | MED | HIGH | crc8 crc16 crc64 crc_param fnv64 xxh32 xxh64 murmur3_32 murmur3_128 siphash hashcombine checksum (64-bit rotl needs logical-shift helper; avoid crc32/fnv1a32/djb2/sdbm/fletcher/pearson/jenkins/adler32 — exist) |
| 22 | std/data/asn1 | MED | HIGH | der_oid der_int der_seq der_set der_octetstr der_bitstr der_utctime der_bool der_null der_length der_tag ber_parse |
| 23 | std/data/bson | MED-HIGH | HIGH | bson_encode bson_decode bson_doc bson_array bson_int bson_double bson_string bson_bool bson_null bson_date bson_binary bson_objectid |
| 24 | std/parsing/combinators | MED | HIGH | pc_result pc_primitives pc_char pc_seq pc_alt pc_many pc_map pc_between pc_sepby pc_lazy pc_token pc_expr |
| 25 | std/parsing/jsonpath | MED | HIGH | jfp_lex jfp_parse jfp_filter jfp_slice jfp_recurse jfp_eval jfp_union jfp_wildcard jfp_index jfp_name jfp_root jfp_apply |
| 26 | std/net/smtp_framing | LOW | MED-HIGH | smtp_command smtp_response smtp_ehlo smtp_mailfrom smtp_rcptto smtp_data smtp_auth smtp_status imap_line imap_tag pop3_line pop3_resp |
| 27 | std/data/byteserial (xdr+netstring+ubjson) | LOW-MED | MED-HIGH | xdr_int xdr_uint xdr_hyper xdr_string xdr_opaque xdr_array netstring_enc netstring_dec ubj_encode ubj_decode ubj_optimized ubj_marker |
| 28 | std/geometry/vector | MED | HIGH | affine2d bezier_adv svgpath delaunay qrcode turtle transform3d polyclip quadtree bbox3d bspline earcut |
| 29 | std/numeric/distributions | MED (float) | HIGH | normaldist poisson binomial tdist chisqdist fdist betadist gammadist exponential uniform lognormal weibull |
| 30 | std/numeric/scientific | MED (float) | HIGH | specialfn(gamma,erf,beta) ttest chisqtest anova ranktest spline optimize polyroots bessel legendre quadrature interp1d |
| 31 | std/text/unicode | HIGH (data tables) | CRITICAL | utf16 utf32 casefold2 unicat ucwidth2 ucseg uninorm_nfc uninorm_nfd uninorm_nfkc script_id bidi_class combining_class |

**Extend past 31:** re-run gap-analysis for a second wave (depth in graph/geometry/dsp, plus new categories:
regex engine, template engines, markup parsers, scientific units, bignum-decimal depth) to reach ~100 tasks.

**Status legend:** update this table's DONE section (commit hash) as each task lands — same discipline as
[[feedback_canonical_docs_living_plan]]. Full arc deferred to campaign end per [[feedback_execution_rhythm_30task]].
