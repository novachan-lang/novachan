# STRUCT RTTI — Hash-Keyed Metadata (the Forge keystone)

**Date:** 2026-06-15
**Status:** CANONICAL design for the struct↔JSON/show/== keystone (Phase 0a of FORGE_MASTER_PLAN.md).
**Decision:** Recover a struct's field names/types **through the `any` boundary** by keying a
runtime metadata table on the struct's **existing slot-0 DJB2 type-hash** — extending the
already-shipping `nova_rt_register_struct_name` / `nova_struct_name_for_hash` registry.
**Supersedes:** the tag-word "type-id header" draft (`_typeid_design.md`), which the adversary
review (`STRUCT_RTTI_ADVERSARY.json`) found NOT SOUND (4 FATAL).

---

## 1. The problem

A struct returned/stored through `any` loses its static type. `nova_rt_json_stringify` then
hits the list branch and emits `[3,4]` instead of `{"x":3,"y":4}`; `str()` emits `<struct>`.
Silent-wrong output to the wire. This is the Forge correctness cliff (FORGE_DESIGN §4.3) and the
keystone that unblocks ALL typed Forge DX (handler returns, `body_as`, `query_as`, OpenAPI).

## 2. Why hash-keyed, not a tag-word type-id (rejected)

The first design packed an 8-bit type-id into the tag word by shrinking nslots 13→5 bits and
changing `nova_rt_struct_alloc`'s signature. The adversary found this **NOT SOUND**:
- **4 FATAL** "missed struct-creation site": `deep_copy`, `nova_result_pack`, `aligned_struct_alloc`
  delegation, and the **gen3 bootstrap codegen** all call `nova_rt_struct_alloc` with the old arity
  → compile error / silent corruption / broken bootstrap.
- **Silent 32-field cliff** (5-bit nslots) + a 256-type cap + an ABI break of `NOVA_STRUCT_NSLOTS`.

**All of these stem from changing allocation.** The key insight: **we don't need to.** Every
non-repr-C struct *already* carries its DJB2 type-hash in slot-0 (`make_struct`,
nova_compiler.nova:15088-15096), and the runtime *already* maps that hash → type name
(`nova_struct_name_for_hash`, used by `type_name()` at nova_runtime.c:13552). Keying the field
metadata on that same hash means:
- **No allocation change** → all 4 FATALs evaporate. `deep_copy`/channel-send already copy slot-0,
  so a struct's identity survives every boundary **for free**.
- **No nslots change** → no 32-field cliff, no 256-type cap, no `NOVA_STRUCT_NSLOTS` ABI break.
- **Reuses a proven mechanism** (the hash→name registry has shipped and reconverges).

The only cost vs an array-indexed type-id is a hash lookup (linear scan over <1000 types, same as
the existing `nova_struct_name_for_hash`; upgrade to sorted+bsearch later if ever hot — it is not,
serialization is string-bound; adversary perf finding = no GATE 4/5 impact).

## 3. Mechanism

### Runtime (nova_runtime.c), beside the struct-name registry (~13380)
```c
typedef struct { const char* name; const char** field_names; const char** field_types; int32_t field_count; } NovaStructMeta;
#define NOVA_MAX_STRUCT_META 1024
static int64_t       g_smeta_hash[NOVA_MAX_STRUCT_META];
static NovaStructMeta g_smeta[NOVA_MAX_STRUCT_META];
static int           g_smeta_count = 0;

void nova_rt_register_struct_meta(int64_t hash, int64_t name_p, int64_t fnames_p, int64_t ftypes_p, int64_t fcount) {
    if (g_smeta_count >= NOVA_MAX_STRUCT_META) return;
    int i = g_smeta_count++;
    g_smeta_hash[i] = hash;
    g_smeta[i].name = (const char*)(uintptr_t)name_p;
    g_smeta[i].field_names = (const char**)(uintptr_t)fnames_p;
    g_smeta[i].field_types = (const char**)(uintptr_t)ftypes_p;
    g_smeta[i].field_count = (int32_t)fcount;
}
static const NovaStructMeta* nova_struct_meta_for_hash(int64_t h) {
    for (int i = 0; i < g_smeta_count; i++) if (g_smeta_hash[i] == h) return &g_smeta[i];
    return NULL;
}
// ptr must be a find_tag-validated NOVA_MEM_STRUCT. slot-0 = type hash for non-repr-C structs.
static const NovaStructMeta* nova_struct_meta_for_ptr(const void* ptr) {
    return nova_struct_meta_for_hash(((const int64_t*)ptr)[0]);
}
```
- **Closures / repr-C structs:** slot-0 is a fn-ptr / a real field, not a registered DJB2 hash →
  lookup misses → NULL → existing fallback. Sound (identical to today's `type_name` behavior). A
  fn-ptr coincidentally equaling a registered 64-bit hash is 1/2⁶⁴ — and even then renders fields,
  never crashes find_tag (the ptr is already validated as a struct before we read slot-0).

### Compiler (nova_compiler.nova), extend the @main registration block (~17357-17369)
Currently iterates `ire_struct_types` and emits `nova_rt_register_struct_name(hash, name)`.
Change to iterate **sorted(keys)** (determinism, adversary #7) and additionally, per struct:
1. emit `@nova_meta_fnames_<i> = private constant [N x ptr] [...]` (interned field-name strings),
2. emit `@nova_meta_ftypes_<i> = private constant [N x ptr] [...]` (interned field-type strings),
   — both in the existing string-constant section, forward-referenced (adversary #10),
3. emit `call void @nova_rt_register_struct_meta(i64 hash, i64 name_p, i64 fnames_p, i64 ftypes_p, i64 N)`.
Field list + order come from `b.ir_sdefs[name]` (declaration order == slot order: `make_struct`
stores field `i` at slot `i+1`). Declare `nova_rt_register_struct_meta(i64,i64,i64,i64,i64)`.

### Consumers
- `json_stringify_value` struct case → `{ "fname": val, ... }` reading `slots[i+1]`.
- `nova_rt_any_to_str` / `nova_rt_elem_to_str` → `Name { fname: val, ... }`.
- `nova_rt_type_of` / `nova_type_name_of` → already hash-keyed; optionally read `meta->name`.
- `from_json` runtime reconstructor (S4) → build struct from a dict by `field_names`.
- `nova_rt_eq` / `nova_rt_hash` → **NO CHANGE** (existing structural slot-0-hash + field walk is
  already correct; nslots is untouched so no cliff).

## 4. Soundness (vs the adversary findings)
- **FATAL #1-4 (allocation call sites / bootstrap):** N/A — allocation/signature unchanged.
- **#6 (nslots cliff) / #12 (ABI macro):** N/A — tag word & `NOVA_STRUCT_NSLOTS` unchanged.
- **#7 (reconverge determinism):** iterate **sorted** struct names; emit globals in that order.
- **#8 (RC during serialization):** serialization runs in one cooperative green task; arenas are
  per-task, freed only by that task's `arena_exit`. No concurrent free. (Documented; matches the
  existing list/dict serialization paths — no new exposure.)
- **#9 (from_json, S4):** `nova_rt_dict_get` compares keys by `strcmp` (content) → interned
  field-name matches parsed JSON key. Missing field → set sentinel/0 and (typed path) prefer a
  `Result` error; handle explicitly when S4 lands.
- **#13 (closure slot-0 collision):** addressed above — table miss; ptr pre-validated as struct.
- **find_tag / arena / int-pointer CVE:** untouched (no header/tag/alloc change).

## 5. Staged implementation (each independently gated: precheck → gen4 smoke → reconverge
gen5.ll==gen6.ll → 432 regression BOTH flag modes → ASAN → green_scale → commit; kill-on-timeout
mandatory; a single UAF/double-free = hard revert)

- **S1 — emit table + register, NO consumer change.** Runtime: add the table + `register_struct_meta`
  + `nova_struct_meta_for_*` (unused). Compiler: emit the metadata globals + register calls (sorted).
  Behavior identical; prove reconverge + **zero perf delta** (the only cost is one-time @main init).
  Bootstrap-safe: ADD a runtime fn + ADD compiler emission (no signature change) → gen4.ll (old gen3)
  links fine (fn unused), gen5/gen6 both emit it → converge.
- **S2 — `json_stringify_value` struct case** → JSON object. Test through every `any` path: function
  return, list element, channel send/recv, closure capture, nested struct. The keystone proof gate:
  a handler returning a bare `Point{x:3,y:4}` yields wire `{"x":3,"y":4}` not `[3,4]`.
- **S3 — `show`/`str`/`type_of`** → `Name { f: v }`.
- **S4 — `from_json` runtime reconstructor** (dict→struct by field_names; missing-field handling).

## 6. File references (verified)
- nova_runtime.c: struct-name registry 13379-13399; `type_name` slot-0 lookup 13552;
  `json_stringify_value` ~3209-3269; `nova_rt_any_to_str` ~3477; `nova_rt_elem_to_str` ~3513;
  `nova_rt_eq` 3716-3727; `deep_copy` struct 2292-2304; `nova_result_pack` ~11473; dict_get ~2054.
- nova_compiler.nova: `make_struct` 15066-15107 (slot-0 hash store 15088-15096; `ire_struct_types`
  15096); @main struct registration 17357-17369; `type_name_hash` 6967-6973; `b.ir_sdefs` ~7013.
