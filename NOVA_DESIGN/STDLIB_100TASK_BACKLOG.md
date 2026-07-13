# STDLIB 100-TASK CAMPAIGN — Backlog & Ledger

**Rhythm (owner, 2026-07-13):** develop tasks ONE BY ONE, continuously, NO stopping. Per-module
compile+run+KAT during build (fast, correctness gate). **NO mid-campaign full arc** — run the heavy
`nova_ci` both-mode (NORMAL+FULLRC) arc **ONCE at the end of ~100 tasks.** A task = 1 coherent library
(~12 modules). Modules written to BOTH `std/<cat>/` AND `nova-compiler/std/<cat>/` (byte-identical);
KAT tests in `nova-compiler/test_programs/_<mod>_test.nova`; add to `_orphan_coverage_manifest.txt`.

**Sourcing:** backlog is grep-verified against the existing std/ tree (gap-analysis workflow `wwr9euk59`,
12 domain surveyors vs JDK/Python/Go/Rust). std/ is very mature (math 72, text 65, collections 48…) —
every task below was dup-checked absent. Ordered LOW-RISK / high-value first.

## DONE (certified both-mode, tasks 1–7; task 8 in flight)
| # | Task | Modules | Commit |
|---|---|---|---|
| 1 | std/compress/ | 12 | cdac0a6b |
| 2 | std/finance/ | 12 | f8a20eb3 |
| 3 | std/color/ | 12 | bf7b7c05 |
| 4 | std/automata/ | 12 | 9e0cfc5d |
| 5 | std/validation/ | 12 | e2c38ad7 |
| 6 | std/dsp/ | 12 | 0d8b9765 |
| 7 | std/testing/ | 12 | ec43eec6 |
| 8 | std/media/ (image+audio codecs: ppm pgm pbm pam bmp tga qoi farbfeld png xpm ico wav) | 12 | *(building wx7niq4xo)* |

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
