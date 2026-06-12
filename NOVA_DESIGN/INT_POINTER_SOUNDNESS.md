# Int/Pointer & Int/String Discrimination — A Value-Model Soundness Gap (RESOLVED)

**Status:** Diagnosed AND FIXED 2026-06-13. Both vectors closed soundly: (1) the
find_tag/RC path hardened; (2) the int/string wild-read eliminated by giving every
runtime string RC identity + recognizing static literals by module range, so a bare
integer can never be discriminated as a string. Full regression 401/401 (incl. the
crash repro + a string-identity completeness test), bootstrap reconverged byte-identical.
This document is the canonical record.

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

## 2. Why content/address heuristics can't work — and what does

Every *heuristic* discriminator was tried and falsified:

| Approach | Why it fails |
|---|---|
| **Readability** (`IsBadReadPtr`) | A large int addressing mapped memory passes. (the status quo crash) |
| **Module-range gating ALONE** | Sound for *static* literals, but rejects legitimate `malloc`'d runtime strings (exit-reason, SHA-256 hex, auth tokens) — broke 5 real tests. |
| **Bounded page-guarded content probe** (NUL within a page, text bytes) | Still misclassifies integers that address text-like memory (`a=2147405400` had a nearby NUL) → reintroduced the crash. No content test is sound. |

The fundamental theorem: **in a uniform-i64 model, a header-less `char*` and a bare integer
are information-theoretically indistinguishable** by address or content. Soundness requires
*identity*. So the implemented fix gives every string identity:

- **Runtime strings → RC header.** All raw-`malloc`'d string *values* (which were silently
  *leaked* anyway, since `rc_dec` no-ops on a header-less pointer) now carry an RC header:
  small/fixed ones via `nova_heap_alloc(.., NOVA_MEM_RAW)`, and the realloc'd / error-freed
  ones (`shell`, `hex_decode`, `base64_decode`) headered at the *return boundary* via
  `nova_str_take` (a headered copy + free of the raw buffer, so the internal buffer keeps
  its malloc/realloc/free lifecycle). `exit_reason` returns a headered copy. **Net: a leak
  became correct rc management.** A 49-site audit (parallel agents + per-site re-verification
  — the agent mislabeled `shell`'s realloc'd buffer and the decoders' error-free paths, which
  would have caused heap corruption; caught before commit) found 17 value-producing sites; the
  rest are internal scratch (already funnel through `nova_fat_str_create`).
- **Static literals → module range.** The only header-less string left is a compiler-emitted
  `.rodata` literal; it lives in the loaded image (Windows: exact PE `SizeOfImage` range).
  A bare integer is neither headered nor in the image, so `nova_is_readable_str` returns false
  → numeric path → no `strlen`, no crash.

This is value identity short of the full tagged value model — sound for Windows (the build/test
platform); POSIX keeps a page-guarded text probe for literals (module-range capture there is a
follow-up; runtime strings are headered on all platforms).

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

Result: bootstrap reconverged byte-identical (gen5.ll==gen6.ll F4FF4C45). `rc_inc`/`rc_dec`
and operator type-dispatch can no longer be fooled into a wild deref by a magic-colliding
integer.

## 3b. The string vector — FIXED (same day)

The int/string `strlen` wild-read was then closed by the value-identity approach of §2:
header all runtime string values + recognize literals by module range + drop the readability
heuristic. `nova_is_readable_str` is now sound — `RAW`/`FAT_STR` header ⇒ string, module-image
⇒ literal, otherwise (a bare integer) ⇒ **not** a string. The repro computes the exact
`16787058750000` instead of crashing; `str_identity_test.nova` confirms every headered producer
(sha256/hmac/hex/base64 round-trips, uuid, exit_reason) renders correctly inside `any`, and that
a mixed `[1,"two",3,...]` list discriminates each element by type. **Full regression 401/401**
(both added as permanent guards), bootstrap reconverged byte-identical.

---

## 4. Still worth doing (perf, not soundness)

**Type-Driven Specialization (S1)** — `PERFORMANCE_SPECIALIZATION.md`. The compiler infers
`x: int` in the repro but drops the inferred type at the codegen boundary, emitting *dynamic*
`nova_rt_add`. Threading inferred types so inferred-int arithmetic lowers to native `add`/`mul`
removes the runtime discrimination *for performance* (it is no longer needed for *soundness* —
that is now handled) **and** delivers the headline beat-C win. The crash that exposed this and
the perf gap shared the same root cause (the uniform-i64 dynamic path); soundness is fixed,
perf remains. The full tagged value model (`VALUE_MODEL_OVERHAUL.md`) is the eventual endgame.

POSIX follow-up: capture the executable's mapped range (e.g. `/proc/self/maps`) so literals are
recognized by exact module range there too, replacing the page-guarded text probe.

---

## 5. Falsifiability / re-verification

`int_ptr_soundness_repro.nova` must print `int_ptr_soundness_repro passed` (it `assert_eq`s the
sum `16787058750000`) and exit 0 — **now in `_run_final_regression.ps1`** alongside
`str_identity_test.nova`. A regression here means the int/string discrimination lost soundness.
