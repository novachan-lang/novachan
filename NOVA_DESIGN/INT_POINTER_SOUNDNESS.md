# Int/Pointer & Int/String Discrimination — A Value-Model Soundness Gap

**Status:** Diagnosed 2026-06-13. RC/find_tag path hardened (shipped). String wild-read
remains a known gap pending the value-model work. This document is the canonical record.

---

## 1. The bug (CVE-class, latent)

Heavy **untyped** (`any`) integer arithmetic can crash with a wild pointer read.

Minimal repro (`int_ptr_soundness_repro.nova`):

```nova
fn work(x)                 # x is UNTYPED -> `any` -> dynamic nova_rt_add / nova_rt_mul
    let s = 0
    let i = 0
    while i < 50
        s = s + (x + i) * (x + i)
        i = i + 1
    s

fn main()
    let xs = []
    let k = 0
    while k < 10000
        push(xs, k)
        k = k + 1
    let results = map(xs, work)     # 10k calls -> ~10^6 dynamic arithmetic ops
    let total = 0
    for r in results
        total = total + r
    print(str(total))               # expect 16787058750000
```

- **Untyped** `work` ⇒ `s`, `x`, `(x+i)` are `any` ⇒ `+`/`*` lower to `nova_rt_add`/`nova_rt_mul`.
- Typing the parameter (`fn work(x: int) -> int`) makes the arithmetic native and the
  crash **vanishes** — proof the fault is in the *dynamic* path, not the loop.
- 100% deterministic (the colliding value is computed deterministically), but does NOT
  reproduce at small list sizes (the colliding large values only occur at higher `x`).
- **0 of 399 regression tests hit it** — it needs pathological untyped-int-at-scale whose
  values collide with readable process addresses.

### Root cause (confirmed by lldb)

```
strlen (reads 0x02a1c479 -> ACCESS VIOLATION)
nova_rt_str_concat(a=2147405400, b=44156025)      # both operands strlen'd
nova_rt_str_concat_safe
nova_rt_add(a=2147405400, b=44156025)             # the `s + (x+i)*(x+i)` add
work
```

`nova_rt_add`/`nova_rt_mul` support `"a"+"b"`, `"ab"*3`, `[x]*n`, so they must decide at
runtime whether an `any` operand is a string/list/number. For a raw C-string literal
(which has no RC header) they fall back to:

```c
a_is_str = (... || ((uint64_t)a > 0x10000 && find_tag(a)==-1 && nova_is_readable_str(a)));
```

`nova_is_readable_str` is just `!IsBadReadPtr(a,1)` — **readability, not stringness**. A
large integer whose *value* is a readable address (e.g. `2147405400 ≈ 0x7FFECE58`, inside a
mapped Windows region) is judged a string, and `str_concat` then `strlen`s **both** operands
— including the genuinely-unmapped integer `b=44156025` — walking into unmapped memory.

This is the same uniform-i64 ambiguity already seen with floats (solved by *boxing* floats —
see `project_any_int_float_soundness`) and with the magic-collision LIST/DICT path (hardened
below). The common disease: **a 64-bit value carries no tag distinguishing int from pointer.**

---

## 2. Why there is no sound *runtime-only* fix

Every runtime-only discriminator was tried and falsified:

| Approach | Why it fails |
|---|---|
| **Readability** (`IsBadReadPtr`) | A large int addressing mapped memory passes. (the status quo crash) |
| **Module-range gating** (literal lives in the PE image) | Sound for *static* literals, but **rejects legitimate `malloc`'d runtime strings** (exit-reason, error, SHA-256 hex, auth tokens) — broke 5 real tests. |
| **Bounded page-guarded content probe** (NUL within a page, text bytes) | Still misclassifies integers that address text-like memory (`a=2147405400` had a nearby NUL) → reintroduced the crash. No content test is sound. |
| **Header all runtime strings** then module-OR-headered discrimination | *Sound*, but a 46-site sweep with per-site lifetime surgery (raw `malloc`/`free` ↔ rc-managed). High risk of use-after-free — worse than a latent crash. Deferred, not rejected. |

The fundamental theorem: **in a uniform-i64 model, a header-less `char*` and a bare integer
are information-theoretically indistinguishable** by address or content. Soundness requires
*identity*: either every string value carries a header/tag, or values are tagged.

---

## 3. What WAS fixed (shipped 2026-06-13)

The RC / `find_tag` discrimination path — distinct from the string path — **was** hardened,
because there every check is provably sound (never rejects a real object):

1. **`nova_mem_find_tag`**: added (a) 8-alignment fast-reject (every managed pointer is
   8-aligned), (b) `rc >= 1` (every live object has positive refcount), (c) **structural
   validation** for the deref-dangerous kinds — LIST/DICT (`0 <= size <= cap < 2^40`),
   FAT_STR (`0 <= len < 2^40`), with reads range-bounded to `[heap_base, heap_top)` so
   validation cannot fault. This closes the magic-collision vector where a large integer
   faking the 16-bit RC magic was dereferenced as a list (`nova_rt_list_repeat`) or dict.
2. **`nova_rc_is_managed`** unified to route through the hardened `find_tag` (strpool checked
   first, since `find_tag` returns `NOVA_MEM_RAW` for *both* strpool and heap-RAW strings —
   conflating them corrupts the strpool refcount table; that was caught and fixed).

Result: **399/399 regression, bootstrap reconverged byte-identical (gen5.ll==gen6.ll
F4FF4C45)**. `rc_inc`/`rc_dec` and operator type-dispatch can no longer be fooled into a
wild deref by a magic-colliding integer. The string `strlen` vector (no header to validate)
is the only residual.

---

## 4. The real fixes (pick during value-model discussion)

In order of preference:

1. **Type-Driven Specialization (S1)** — `PERFORMANCE_SPECIALIZATION.md`. The compiler already
   *infers* `x: int` in the repro (`xs` is a list of ints) but drops the inferred type at the
   codegen boundary, emitting dynamic `nova_rt_add`. Threading inferred types so inferred-int
   arithmetic lowers to native `add`/`mul` **eliminates the runtime discrimination entirely**
   for this whole class — *and* delivers the headline perf win. This crash and the perf gap
   are the **same root cause**. Strongly preferred: fixes both, no runtime risk.
2. **Value tagging / boxing identity for all string values** — give every string an RC header
   (the 46-site sweep, done carefully with rc lifetime management), then make
   `nova_is_readable_str` module-OR-headered only (no heuristic). Sound but invasive.
3. **Full tagged value model** — `VALUE_MODEL_OVERHAUL.md`. The endgame; subsumes everything.

Genuinely-`any` arithmetic (a value that is truly dynamic at runtime) still needs (2) or (3)
even after (1), but (1) removes ~all real-world occurrences (inferred-int code).

---

## 5. Falsifiability / re-verification

`int_ptr_soundness_repro.nova` must print `16787058750000` and exit 0. Today it segfaults
(exit 139) — it is **excluded from the regression suite** for that reason. After S1 (or the
value-model work), add it to `_run_final_regression.ps1`; its passing is the acceptance gate.
