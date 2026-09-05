# M0.3 vs M3.4 — WHICH GOES FIRST. A decision brief.

**Date:** 2026-09-05
**For:** owner GO/NO-GO on T11 / M0.3
**Recommendation:** ⭐ **Do M3.4 (reactivity) FIRST. Defer M0.3.** This inverts the plan of record,
which names M0.3 "the true critical path." The argument is below; the counter-argument is stated
too, because this is a reversal and should not be taken on my say-so.

---

## What M0.3 actually is

Split `nova_runtime.c` (**32,244 lines**) in two:

- `nova_runtime_core.c` — values, strings, lists, dicts, structs, RC, a real allocator. Depends only
  on a ~46-function libc surface. Compiles to **wasm32 freestanding with our own shims** — no
  external sysroot, which preserves the no-supply-chain property.
- `nova_runtime_host.c` — sockets, TLS, threads, processes, `dlopen`, signals, `mmap`. Native only.

**6–10 weeks, RED tier, full arc** (reconverge to a byte-identical fixpoint + both memory modes).
It is surgery on the single most load-bearing file in the project.

## The case for doing it first (the plan of record)

1. It is the **only** thing standing between PRISM and running in a browser. Without it, PRISM
   cannot be compared to React by anyone who would actually compare them.
2. **Part of it is forced anyway.** The never-freeing bump allocator must be replaced regardless
   (Phase-0 blocker 2), and owning the allocator is a prerequisite for the split. That work is not
   optional; only its timing is.
3. It unblocks T12 and T14 (the DOM backend vertical slice).

## ⭐ The case for doing M3.4 first

**1. M0.3 validates nothing about PRISM's central bet.** Bet 1 — zero-annotation reactivity — is
what makes PRISM a UI framework rather than a rendering library. M1.7 has now measured that the bet
*survives on paper* (median 2-leaf marginal read-sets, 7.5% fan-out, keying required and 90%
inferable). It has **not** been built. Spending 6–10 weeks of RED-tier risk on a runtime split
leaves that question exactly where it is today.

**2. M3.4 does not need M0.3.** Reactivity is a compiler pass plus changeset support in the runtime.
It needs no wasm, no DOM, no browser. The design doc already says the model is *"testable on the
ANSI/HTML backends first, which is how it should be proven"* — and PRISM has six working backends
to prove it against.

**3. PRISM already ships a product without a browser runtime.** The HTML renderer works
**server-side today** and is usable by Forge. A server-rendered application with form posts is a
real, shippable thing right now. What M0.3 buys is *client-side* interactivity — valuable, but not
the difference between "framework" and "not a framework."

**4. Failure ordering.** If Bet 1 breaks in implementation, we want to know *before* spending 6–10
weeks on runtime surgery, not after. M3.4-first fails cheap; M0.3-first fails expensive. This is the
same reasoning M1.7 was built on, applied one level up — and M1.7 has already vindicated it once:
the falsifier's stated 3–4-week compiler-pass plan would have produced a **wrong** answer (35.9%
against a 30% threshold) that a one-session static analysis showed was a denominator artifact.

**5. The risk profiles are not comparable.** M3.4 is a new pass over an existing compiler — additive,
and a bug shows up as a stale or over-eager re-render. M0.3 is surgery on the 32k-line runtime every
single NOVA program links against — a bug there breaks the compiler's own bootstrap, and the
reconverge gate is the only thing that would catch the deepest cases.

## Honest counter-arguments

- **"Browser reach is the actual goal."** If the objective is specifically *beat React where React
  lives*, M0.3 is unavoidable and delay is delay. This is the strongest counter and it is a matter
  of the owner's intent, not of engineering.
- **The allocator work is forced anyway**, so some of M0.3's cost is sunk regardless of order —
  which narrows the gap between the two orderings.
- **M3.4 is not free either.** It is compiler work and also needs a full arc; "cheaper" is relative.
- **Sequencing risk:** if M3.4's implementation reveals it needs runtime facilities that only exist
  post-split, the orderings become entangled. I do not believe it does — a changeset is a value, not
  a host facility — but it is not proven.

## ★ MEASURED EVIDENCE ADDED 2026-09-05 — the M3.4-first case is now quantified

When this brief was written the argument for M3.4-first was structural. It is now measured
(`PRISM_M3_4_REACTIVITY_DESIGN.md` §12, `tools/m34_invalidation_sim.py`). Work per user action on
the real 133-leaf console state, at a 1000-element collection:

| action | today (no reactivity) | with plain leaf-granular reactivity |
|---|---|---|
| session token refresh | 11015 units | **5** |
| toggle a preference | 11015 units | **5** |
| edit one comment | 11015 units | 6007 → **1** with keying |

**The first two rows are the argument.** They need **no keying, no aggregates, no browser** — only
the basic read-set intersection, which is the cheapest part of M3.4. A **2200×** reduction on
ordinary interactions, available on the ANSI and HTML backends that already work.

That reframes the ordering question. M0.3 is 6–10 weeks of RED-tier surgery on the 32k-line runtime
every NOVA program links against, and it buys **reach**. The first increment of M3.4 is additive,
gated by ordinary means, and buys **a 2200× cost reduction on a framework that already ships
server-side**. One of those is a bet on where users are; the other is a measured improvement to what
exists today.

It also tightens the fallback: if Bet 1 broke in implementation, we would learn it while holding a
working server-rendered framework — rather than after having rebuilt the runtime for a browser
target that had nothing worth running in it yet.

## Recommendation

**Do M3.4 first, on the ANSI/HTML backends. Then M0.3.**

Sequence, with the cheap steps first:

1. §8 steps 1–3 and 4(detection) — **already done**, no compiler change.
2. Keyed sub-face + changeset design as one unit (§3/§4b/§10) — design only, no GO.
3. Build the read-set pass **out-of-tree** first, as `tools/m17_readset.py` already is. Prove the
   numbers on `prism_app_console` before touching the compiler.
4. Reject faces reading module state — smallest correctness gate, already measured as violation-free
   (0/131 modules), so it can land without cleanup.
5. **Then** the compiler pass, RED tier, full arc.
6. **Then** M0.3, with a working reactive framework proving it was worth splitting for.

**What I need from you:** a decision on the ordering. Not on step 5 — that comes back for its own GO
once steps 1–4 have produced numbers.
