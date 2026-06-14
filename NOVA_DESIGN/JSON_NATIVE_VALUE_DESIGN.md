# JSON-Native Tagged Value Model — Vetted Design (2026-06-14)

Produced by a 16-agent design+adversarial-stress-test workflow (wf_a0180fac-003, 1.31M subagent
tokens: ground → 5 research lenses → 3 candidates → 6 adversarial refutations → synthesis). This is
the #1 deep-frontier item. **NO code was changed by the workflow** — this is the plan to execute.

---

## The exact gap (grounded, line-referenced)

`{"active":true,"score":3,"tags":[null,"x",1.5]}` round-trips through `json_encode(json_decode(s))`
to `{"active":1,"score":3,"tags":[0,"x",1.5]}` — **true→1 and null→0, irreversibly, AT DECODE TIME.**

Mechanism: `json_parse_value` sets `true`→bare i64 1, `null`→bare i64 0 (nova_runtime.c ~2972-2982);
the dict then holds i64 1 (bit-identical to integer 1) and i64 0 (identical to integer 0 / false /
a missing key). `json_stringify_value` sees a bare i64 → `find_tag` returns -1 → emits the integer.

Two root causes: (a) **bool and null have NO first-class tagged value** — only int(bare) / float(box)
/ string-list-dict(ptr) exist, so they alias integer 0/1; (b) the only any-path type carrier is the
`NovaBox`, which has no surviving-BOOL and no NULL kind, and is only minted at **static-type store
sites**, never reconstructed for values that arrive already-`any` (json_decode, dict reads).

---

## Chosen representation — "Sealed Singleton Oddballs" (NovaBox-V2)

- Extend the existing `NovaBox` heap cell: add `NOVA_BOX_NULL=2`; reuse `NOVA_BOX_BOOL=0`.
- Three **pinned singleton cells** `g_null_box` / `g_true_box` / `g_false_box` (one each, never freed).
- null/bool/string/list/dict/struct/float ALL discriminated by the **existing hardened
  `nova_mem_find_tag`** — NEVER by bits-in-word. → the int/pointer-soundness CVE stays closed by the
  same oracle; no NaN collision (address-boxing, float bits stay in their own box payload).
- **INT stays bare i64** (permanent) — keeps the compiler's unmasked-DJB2 dispatch table safe.
- ★ **Fidelity is LOCAL TO THE JSON CODEC** (json_parse_value decode + json_stringify_value encode,
  which read the RAW backing array and dispatch by `find_tag`), NOT the global container-read path.
  `nova_rt_unbox_elem` (runtime ~626) stays GLOBALLY UNCHANGED → the compiler's `_ds_flags`/`_sp_flags`
  truthiness (nova_compiler.nova 1380/1428) cannot break.

### Rejected (verified-unsafe, NO-GO)
- **Global unbox flip** (keep BOOL boxed on every read): miscompiles the compiler — `_ds_flags` reads
  return a nonzero pointer → `if`-truthiness inverts. THE disqualifier for naive Candidate 1.
- **INT-boxing**: `type_name_hash` is UNMASKED DJB2 (nova_compiler.nova 6926-6932) → billions pushed
  into an any-list + stringified into generated IR; boxing ints corrupts the dispatch table.
- **NaN-boxing / nt_nanany**: corrupts DJB2 dispatch AND breaks the shared type-erased RC/deep-copy
  primitives (UAF). Forces two value representations forever.

---

## Staged plan (every stage byte-identical until ONE deliberate cutover)

| Stage | Goal | Reconverge | Risk |
|---|---|---|---|
| **0 — Dark infra** | NULL define + 3 singletons + encode-side NULL arm + RC pin, as DEAD code | **byte-identical** (nova_compiler.nova NOT edited) | window poisoning, int32 UAF — both mitigated in-stage |
| **1 — Decode fidelity** | json_parse_value: null→g_null_box, true/false→singletons; round-trip faithful | **byte-identical** (compiler never json_decodes its own state) | user `d["k"]==true` surprises until Stage 3 — document as known-partial |
| **2 — Term wire + oracle** | extend fidelity to the term/distribution codec; harden oracle matrix | **byte-identical** (runtime-only) | low/additive; confirm NOVA_TT_NULL tag unused |
| **3 — General any-read** | bool/null survive a general container read via a DISTINCT seam (NOT a global flip) | **NEW fixpoint** (edits compiler codegen) — the cutover | HIGHEST; needs IR-grep gate + spread_test.nova; separate go/no-go |
| **4 — Cutover** | make default, lock with permanent fixtures | on the established fixpoint | low if 0-2 only |

**GO: Stages 0-2 now** (closes the round-trip blocker — unblocks web-backend identity / WASM-DOM /
distribution wire — with ZERO compiler change, byte-identical by construction).
**CONDITIONAL GO: Stage 3** only after 0-2 ship, with the IR-grep gate (no kept-boxed-bool into a raw
`icmp ne 0`) + FULL on-path regression incl. spread_test (reconverge .ll-equality is provably
insufficient there: the compiler's own spread path is dead during self-compile → false green).

---

## Killer risks + mitigations (all baked into the stages)

1. **Window poisoning (Stage 0):** tracking the 3 singletons into `[g_box_lo,g_box_hi]` would make
   `nova_is_box`'s fast-reject non-empty for EVERY program → taxes every any-container read.
   **MITIGATION:** a SEPARATE `[g_oddball_lo,g_oddball_hi]` window checked first + **lazy init** on
   first json_decode → pure-numeric/compiler code never widens the box window. Verify via gen5 compile
   wall-time vs baseline.
2. **INT32-overflow UAF on pinned singletons (Stage 0 RC):** `NOVA_RC_COUNT` is int32 (~424); a
   dec-only pin lets `nova_rc_inc` keep bumping a shared singleton → wraps after ~1.07e9 inserts in a
   long-lived JSON server → premature free. **MITIGATION:** range-check the oddball window in BOTH
   `nova_rc_inc` AND `nova_rc_dec_internal` → early-return, never touch rc (singletons immortal).
3. **Global unbox flip** → keep `nova_rt_unbox_elem` unchanged (design constraint, not a patch).
4. **DJB2 corruption** → INT stays bare (deferred indefinitely).
5. **Float-in-any is load-bearing** → leave json_parse_number's `nova_rt_box_float` + the f2i/
   nova_float_arg path UNCHANGED. Do NOT fold float into the singleton scheme.

---

## Oracle (json_oracle_test.nova)

Core: `assert to_json(json_decode("{\"active\":true,\"score\":3,\"tags\":[null,\"x\",1.5]}")) == <same>`
(the EXACT failing value) — true→true (not 1), null→null (not 0), int 3 stays int, 1.5 stays float,
"x" stays string (byte-identical mod dict-key-order + %.15g float formatting, which the test
normalizes). Extended matrix: standalone null/true/false; deeply nested objects/arrays.

---

## Stage 0 — exact first implementation (all in `output/nova_runtime.c`; do NOT edit nova_compiler.nova)

1. `#define NOVA_BOX_NULL 2` near the `NOVA_BOX_FLOAT 1` define.
2. statics `g_null_box/g_true_box/g_false_box` + `g_oddball_lo/hi`; `nova_rt_oddballs_init()` lazily
   allocates 3 NovaBox cells via the SAME path `nova_rt_box_bool` uses
   (`nova_heap_alloc(sizeof(NovaBox), NOVA_MEM_BOX)`), kinds NULL / BOOL payload 1 / BOOL payload 0,
   records the [lo,hi] range, `nova_box_track`s each. Expose `nova_rt_null()` and `nova_rt_bool(v)`.
3. Encode NULL arm in `json_stringify_value`, inside the `NOVA_MEM_BOX` branch, before the BOOL/FLOAT
   split: `if (bx->kind==NOVA_BOX_NULL){ emit "null"; return; }`.
4. RC pin: at the top of `nova_rc_inc` AND `nova_rc_dec_internal`, after computing addr `a`:
   `if (a>=g_oddball_lo && a<=g_oddball_hi) return;`.
   Nothing else — json_parse_value stays bare; `nova_rt_unbox_elem` unchanged; the new fns are dead
   from any NOVA program's view.

**Gate (in order, kill-on-timeout MANDATORY):** runtime compiles → recompile nova_compiler.nova →
reconverge `gen5.ll == gen6.ll` BYTE-IDENTICAL → full regression → a C harness building
`{a:null,b:true,c:false}` from the singletons asserting encode → `{"a":null,"b":true,"c":false}` →
gen5 compile wall-time vs baseline (window-poisoning check). PASS = all green → then Stage 1.
