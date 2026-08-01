# NOVA Duplicate Modules Tracker

> **Created:** 2026-07-11
> **Purpose:** Track all duplicate/overlapping .nova modules between forge/ and std/, within std/ itself, and within forge/ itself.
> **Root cause:** The STDLIB_100TASK and FORGE_DEV_TRACK campaigns were authored independently and never cross-checked.
> **Resolution strategy:** Make forge duplicates into thin wrappers over the canonical std/ module (follow the `std/data/jsonpath.nova` pattern), or merge and delete the redundant copy.

---

## Status Summary

| Category | Count | Status |
|----------|-------|--------|
| forge/ ↔ std/ overlaps (unique basenames) | 166 | TRACKED |
| forge/ ↔ std/ overlaps (total pairs, some 1:2) | 178 | TRACKED |
| std/-internal basename collisions | 22 | TRACKED |
| forge/-internal duplicates | 1 | TRACKED |
| **Total duplicate pairs to resolve** | **201** | **TRACKED** |

---

## Section A — forge/ ↔ std/ Overlaps (166 basenames, 178 pairs)

These are independently-implemented modules covering the same algorithm/concept. The forge version is typically 1/3–1/2 the size (simpler API surface), while std/ has the fuller implementation. 12 basenames match two std/ paths each.

**Status legend:** `[ ]` = unresolved, `[W]` = forge made into wrapper, `[D]` = forge deleted (std canonical), `[F]` = false positive (different concept), `[K]` = keep both (intentionally different)

### Collections / Data Structures
```
[ ] forge/forge_bitset.nova           | std/collections/bitset.nova
[ ] forge/forge_bktree.nova           | std/collections/bktree.nova
[ ] forge/forge_fenwick.nova          | std/collections/fenwick.nova
[ ] forge/forge_fenwick2d.nova        | std/collections/fenwick2d.nova
[ ] forge/forge_graph.nova            | std/collections/graph.nova
[ ] forge/forge_intervaltree.nova     | std/collections/intervaltree.nova
[ ] forge/forge_kdtree.nova           | std/collections/kdtree.nova
[ ] forge/forge_multimap.nova         | std/collections/multimap.nova
[ ] forge/forge_setops.nova           | std/collections/setops.nova
[ ] forge/forge_sparsetable.nova      | std/collections/sparsetable.nova
[ ] forge/forge_splaytree.nova        | std/collections/splaytree.nova
[ ] forge/forge_suffixarray.nova      | std/collections/suffixarray.nova
[ ] forge/forge_treap.nova            | std/collections/treap.nova
[ ] forge/forge_trie.nova             | std/collections/trie.nova
[ ] forge/forge_union_find.nova       | std/collections/union_find.nova
```

### Graph Algorithms
```
[ ] forge/forge_astar.nova            | std/graph/astar.nova
[ ] forge/forge_bellmanford.nova      | std/graph/bellmanford.nova
[ ] forge/forge_bipartite.nova        | std/graph/bipartite.nova
[ ] forge/forge_dijkstra.nova         | std/graph/dijkstra.nova
[ ] forge/forge_floydwarshall.nova    | std/graph/floydwarshall.nova
[ ] forge/forge_hamiltonian.nova      | std/graph/hamiltonian.nova
[ ] forge/forge_maxflow.nova          | std/graph/maxflow.nova
```

### Sketch / Probabilistic
```
[ ] forge/forge_countmin.nova         | std/sketch/countmin.nova
[ ] forge/forge_cuckoofilter.nova     | std/sketch/cuckoofilter.nova
[ ] forge/forge_hyperloglog.nova      | std/sketch/hyperloglog.nova
[ ] forge/forge_minhash.nova          | std/sketch/minhash.nova
[ ] forge/forge_reservoir.nova        | std/sketch/reservoir.nova
[ ] forge/forge_simhash.nova          | std/sketch/simhash.nova
[ ] forge/forge_topk.nova             | std/sketch/topk.nova
```

### Text / String Algorithms
```
[ ] forge/forge_align.nova            | std/bio/align.nova
[ ] forge/forge_anagram.nova          | std/text/anagram.nova
[ ] forge/forge_ansi.nova             | std/text/ansi.nova
[ ] forge/forge_boyermoore.nova       | std/text/boyermoore.nova
[ ] forge/forge_case.nova             | std/text/case.nova
[ ] forge/forge_damerau.nova          | std/text/damerau.nova
[ ] forge/forge_editops.nova          | std/text/editops.nova
[ ] forge/forge_hamming.nova          | std/text/hamming.nova
[ ] forge/forge_indent.nova           | std/text/indent.nova
[ ] forge/forge_kmp.nova              | std/text/kmp.nova
[ ] forge/forge_lcs.nova              | std/text/lcs.nova
[ ] forge/forge_lcsubstring.nova      | std/text/lcsubstring.nova
[ ] forge/forge_lorem.nova            | std/text/lorem.nova
[ ] forge/forge_manacher.nova         | std/text/manacher.nova
[ ] forge/forge_pad.nova              | std/text/pad.nova
[ ] forge/forge_rabinkarp.nova        | std/text/rabinkarp.nova
[ ] forge/forge_readability.nova      | std/text/readability.nova
[ ] forge/forge_roman.nova            | std/text/roman.nova
[ ] forge/forge_shlex.nova            | std/text/shlex.nova
[ ] forge/forge_slug.nova             | std/text/slug.nova
[ ] forge/forge_tfidf.nova            | std/text/tfidf.nova
[ ] forge/forge_tokenize.nova         | std/text/tokenize.nova
[ ] forge/forge_wordwrap.nova         | std/textlayout/wordwrap.nova
[ ] forge/forge_xml.nova              | std/text/xml.nova
```

### Geometry
```
[ ] forge/forge_bbox.nova             | std/geometry/bbox.nova
[ ] forge/forge_closestpair.nova      | std/geometry/closestpair.nova
[ ] forge/forge_convexhull.nova       | std/geometry/convexhull.nova
[ ] forge/forge_polygon.nova          | std/geometry/polygon.nova
[ ] forge/forge_spatial_hash.nova     | std/game2d/spatial_hash.nova
```

### Math / Numeric
```
[ ] forge/forge_bignum.nova           | std/numeric/bignum.nova
[ ] forge/forge_binomial.nova         | std/math/binomial.nova
[ ] forge/forge_calc.nova             | std/parsing/calc.nova
[ ] forge/forge_checkdigit.nova       | std/math/checkdigit.nova
[ ] forge/forge_collatz.nova          | std/math/collatz.nova
[ ] forge/forge_combinatorics.nova    | std/math/combinatorics.nova
[ ] forge/forge_easing.nova           | std/math/easing.nova
[ ] forge/forge_egyptian.nova         | std/math/egyptian.nova
[ ] forge/forge_geo.nova              | std/math/geo.nova
[ ] forge/forge_jacobi.nova           | std/math/jacobi.nova
[ ] forge/forge_linsolve.nova         | std/numeric/linsolve.nova
[ ] forge/forge_pell.nova             | std/math/pell.nova
[ ] forge/forge_primes.nova           | std/math/primes.nova
[ ] forge/forge_stats.nova            | std/math/stats.nova
[ ] forge/forge_units.nova            | std/numeric/units.nova
```

### Encoding / Serialization
```
[ ] forge/forge_ascii85.nova          | std/encoding/ascii85.nova
[ ] forge/forge_base32.nova           | std/encoding/base32.nova
[ ] forge/forge_base45.nova           | std/encoding/base45.nova
[ ] forge/forge_base58.nova           | std/encoding/base58.nova
[ ] forge/forge_base62.nova           | std/encoding/base62.nova
[ ] forge/forge_bencode.nova          | std/data/bencode.nova
[ ] forge/forge_cbor.nova             | std/data/cbor.nova
[ ] forge/forge_geohash.nova          | std/encoding/geohash.nova
[ ] forge/forge_htmlentities.nova     | std/encoding/htmlentities.nova
[ ] forge/forge_ini.nova              | std/data/ini.nova
[ ] forge/forge_morse.nova            | std/encoding/morse.nova
[ ] forge/forge_msgpack.nova          | std/data/msgpack.nova
[ ] forge/forge_pdf.nova              | std/encoding/pdf.nova
[ ] forge/forge_protobuf.nova         | std/encoding/protobuf.nova
[ ] forge/forge_toml.nova             | std/data/toml.nova
[ ] forge/forge_tsv.nova              | std/data/tsv.nova
[ ] forge/forge_yaml.nova             | std/data/yaml.nova
```

### Compression
```
[ ] forge/forge_bwt.nova              | std/compress/bwt.nova
[ ] forge/forge_huffman.nova          | std/compress/huffman.nova
[ ] forge/forge_lzw.nova              | std/compress/lzw.nova
[ ] forge/forge_mtf.nova              | std/compress/mtf.nova
[ ] forge/forge_rle.nova              | std/compress/rle.nova
[ ] forge/forge_runlength.nova        | std/encoding/runlength.nova
```

### Network / Web
```
[ ] forge/forge_cookie.nova           | std/net/cookie.nova
[ ] forge/forge_http_status.nova      | std/net/http_status.nova
[ ] forge/forge_httpdate.nova         | std/net/httpdate.nova
[ ] forge/forge_mac.nova              | std/net/mac.nova
[ ] forge/forge_mime.nova             | std/net/mime.nova
[ ] forge/forge_useragent.nova        | std/net/useragent.nova
```

### Validation
```
[ ] forge/forge_ean.nova              | std/validation/ean.nova
[ ] forge/forge_email.nova            | std/validation/email.nova
[ ] forge/forge_iban.nova             | std/validation/iban.nova
[ ] forge/forge_phone.nova            | std/validation/phone.nova
[ ] forge/forge_vin.nova              | std/validation/vin.nova
```

### Time / Date
```
[ ] forge/forge_age.nova              | std/time/age.nova
[ ] forge/forge_calendar.nova         | std/time/calendar.nova
[ ] forge/forge_cron.nova             | std/time/cron.nova
[ ] forge/forge_duration.nova         | std/time/duration.nova
[ ] forge/forge_humanize.nova         | std/time/humanize.nova
[ ] forge/forge_stopwatch.nova        | std/time/stopwatch.nova
```

### Identifiers / Random
```
[ ] forge/forge_dice.nova             | std/random/dice.nova
[ ] forge/forge_idgen.nova            | std/util/idgen.nova
[ ] forge/forge_lfsr.nova             | std/random/lfsr.nova
[ ] forge/forge_nanoid.nova           | std/util/nanoid.nova
[ ] forge/forge_prng.nova             | std/util/prng.nova
[ ] forge/forge_snowflake.nova        | std/util/snowflake.nova
[ ] forge/forge_ulid.nova             | std/util/ulid.nova
```

### Utility / Control
```
[ ] forge/forge_accumulator.nova      | std/util/accumulator.nova
[ ] forge/forge_backoff.nova          | std/util/backoff.nova
[ ] forge/forge_color.nova            | std/util/color.nova
[ ] forge/forge_env.nova              | std/util/env.nova
[ ] forge/forge_histogram.nova        | std/util/histogram.nova
[ ] forge/forge_path.nova             | std/io/path.nova
[ ] forge/forge_ratelimit.nova        | std/control/ratelimit.nova
[ ] forge/forge_schema.nova           | std/data/schema.nova
[ ] forge/forge_semaphore.nova        | std/sync/semaphore.nova
[ ] forge/forge_semver_bump.nova      | std/semver/semver_bump.nova
```

### Other / Miscellaneous
```
[ ] forge/forge_crc16.nova            | std/hash/crc16.nova
[ ] forge/forge_diff.nova             | std/testing/diff.nova, std/text/diff.nova
[ ] forge/forge_factoradic.nova       | std/numeral/factoradic.nova
[ ] forge/forge_hexdump.nova          | std/os/hexdump.nova
[ ] forge/forge_lyndon.nova           | std/combinatorics/lyndon.nova
[ ] forge/forge_movingavg.nova        | std/dsp/movingavg.nova
[ ] forge/forge_nqueens.nova          | std/game/nqueens.nova
[ ] forge/forge_pid.nova              | std/control/pid.nova
[ ] forge/forge_progress.nova         | std/term/progress.nova, std/util/progress.nova
[ ] forge/forge_shellquote.nova       | std/os/shellquote.nova
[ ] forge/forge_sudoku.nova           | std/game/sudoku.nova
[ ] forge/forge_table.nova            | std/testing/table.nova
[ ] forge/forge_task_scheduler.nova   | std/greedy/task_scheduler.nova
[ ] forge/forge_wildcard.nova         | std/parsing/wildcard.nova
[ ] forge/forge_zeckendorf.nova       | std/numeral/zeckendorf.nova
```

### Matches into TWO std/ paths (1 forge → 2 std)
```
[ ] forge/forge_cursor.nova           | std/io/cursor.nova, std/term/cursor.nova
[ ] forge/forge_diff.nova             | std/testing/diff.nova, std/text/diff.nova
[ ] forge/forge_gradient.nova         | std/color/gradient.nova, std/term/gradient.nova
[ ] forge/forge_hex.nova              | std/color/hex.nova, std/encoding/hex.nova
[ ] forge/forge_jsonpath.nova         | std/data/jsonpath.nova, std/parsing/jsonpath.nova
[ ] forge/forge_ndjson.nova           | std/data/ndjson.nova, std/encoding/ndjson.nova
[ ] forge/forge_percent.nova          | std/encoding/percent.nova, std/math/percent.nova
[ ] forge/forge_progress.nova         | std/term/progress.nova, std/util/progress.nova
[ ] forge/forge_query.nova            | std/core/query.nova, std/data/query.nova
[ ] forge/forge_retry.nova            | std/core/retry.nova, std/util/retry.nova
[ ] forge/forge_template.nova         | std/parsing/template.nova, std/text/template.nova
[ ] forge/forge_url.nova              | std/net/url.nova, std/validation/url.nova
```

### Confirmed FALSE POSITIVES (same name, different concept — keep both)
```
[F] forge/forge_card.nova             | std/game/card.nova         — Luhn credit-card vs playing cards
[F] forge/forge_dist.nova             | std/random/dist.nova       — distributed-spawn wire protocol vs probability distributions
[F] forge/forge_envelope.nova         | std/dsp/envelope.nova      — API response envelope vs DSP signal envelope
[F] forge/forge_euler.nova            | std/numeric/euler.nova     — Eulerian graph paths vs Euler's ODE method
[F] forge/forge_interval.nova         | std/music/interval.nova    — integer interval algebra vs musical intervals
[F] forge/forge_mode.nova             | std/music/mode.nova        — statistical mode vs musical modes
[F] forge/forge_otp.nova              | std/crypto/otp.nova        — Erlang OTP supervision vs one-time pad cipher
[F] forge/forge_scale.nova            | std/music/scale.nova       — ML feature scaling vs musical scales
```

---

## Section B — std/-internal Basename Collisions (22 basenames)

These are files in different std/ subdirectories sharing the same basename. Some are true duplicates (reimplemented), some are complementary, some are unrelated concepts.

**Status legend:** `[ ]` = unresolved, `[T]` = true duplicate (merge), `[C]` = complementary (keep), `[U]` = unrelated concept (keep)

### True Duplicates (same concept reimplemented)
```
[T] asn1        | std/data/asn1.nova, std/encoding/asn1.nova           — both ASN.1 DER TLV codecs
[T] ndjson      | std/data/ndjson.nova, std/encoding/ndjson.nova       — both NDJSON codecs
[T] properties  | std/data/properties.nova, std/encoding/properties.nova — both Java .properties parsers
[T] retry       | std/core/retry.nova, std/util/retry.nova             — both backoff-delay calculators (+ forge_retry = 3-way!)
[T] tax         | std/finance/tax.nova, std/money/tax.nova             — both progressive tax-bracket calculators
```

### Properly Factored (wrapper pattern — GOOD example)
```
[C] jsonpath    | std/data/jsonpath.nova, std/parsing/jsonpath.nova     — data/ is thin wrapper over parsing/ engine
```

### Complementary (different aspects of same domain — keep)
```
[C] plist       | std/data/plist.nova, std/encoding/plist.nova          — XML plist parser vs binary bplist00
[C] hex         | std/color/hex.nova, std/encoding/hex.nova             — hex color codes vs byte hex encode/decode
[C] glob        | std/os/glob.nova, std/parsing/glob.nova               — filesystem globbing vs string pattern glob
[C] cursor      | std/io/cursor.nova, std/term/cursor.nova              — byte-buffer cursor vs ANSI terminal cursor
[C] gradient    | std/color/gradient.nova, std/term/gradient.nova        — color gradient math vs terminal gradient rendering
[C] diff        | std/testing/diff.nova, std/text/diff.nova              — test diff utility vs text diff algorithm
```

### Unrelated Concepts (same word, different domain — keep)
```
[U] energy      | std/physics/energy.nova, std/units/energy.nova        — physics formulas vs unit conversion
[U] format      | std/money/format.nova, std/testing/format.nova, std/text/format.nova — 3 different domains
[U] percent     | std/encoding/percent.nova, std/math/percent.nova      — URL percent-encoding vs percentage math
[U] query       | std/core/query.nova, std/data/query.nova              — query combinator vs data query
[U] round       | std/math/round.nova, std/money/round.nova             — general rounding vs currency rounding
[U] seq         | std/bio/seq.nova, std/core/seq.nova                   — DNA/RNA sequences vs generic list utilities
[U] template    | std/parsing/template.nova, std/text/template.nova     — template parser vs text template
[U] url         | std/net/url.nova, std/validation/url.nova             — URL parsing vs URL validation
[U] validate    | std/core/validate.nova, std/money/validate.nova, std/util/validate.nova — 3 different scopes
[U] progress    | std/term/progress.nova, std/util/progress.nova        — terminal progress bar vs progress tracker
```

---

## Section C — forge/-internal Duplicate

```
[T] forge/forge_rle.nova (34 lines)        — strict SUBSET of forge_runlength.nova
    forge/forge_runlength.nova (89 lines)   — superset (adds pair-based API + run_count)
    Both define `rle_encode(s: string) -> string` — symbol collision risk.
    Resolution: DELETE forge_rle.nova, keep forge_runlength.nova as canonical.
```

---

## Resolution Plan

**Phase 1 — Quick wins (no behavior change):**
1. Delete `forge/forge_rle.nova` (subsumed by `forge_runlength.nova`)
2. Merge std/-internal true duplicates: pick one canonical location, make the other a re-export or delete

**Phase 2 — Forge wrapper campaign:**
- For each forge/std overlap, make the forge file a thin wrapper that imports from std/ and re-exports
- Follow the `std/data/jsonpath.nova` pattern (already correctly done)
- This preserves backwards compatibility for anything importing `forge_*`

**Phase 3 — Validation:**
- Run KAT tests on all modified modules
- Verify no import breakage across the codebase
