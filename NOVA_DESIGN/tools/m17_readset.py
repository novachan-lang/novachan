#!/usr/bin/env python3
"""M1.7 -- THE BET-1 FALSIFIER.  Reproducible measurement.

Bet 1 (PRISM spec) claims zero-annotation reactivity is survivable: a compiler pass can infer
each face's dependency set finely enough that a state change re-runs only a little of the UI.
M1.7's kill criterion: mean inferred read-set per face >20-30% of reachable state => granularity
has collapsed => Bet 1 is dead.

WHAT THIS MEASURES, and the four corrections that mattered (each one changed the answer):

 1. FACE vs REDUCER.  A fn returning its own state type is a state TRANSITION, not a face; it
    reads everything by construction.  Counting reducers put the mean at 71.9% -- meaningless.
    Reducers are excluded and reported separately.
 2. TRANSITIVE reachable state as the denominator, not the parameter's own field count.
    "Reachable program state" is the transitive leaf closure through nested state types.
 3. TRANSITIVE read-set via a fixed point over delegation edges.  Counting only `p.field` in the
    immediate body UNDERCOUNTS: 34% of faces read more once helpers are followed (mean 1.09 ->
    1.87 leaves).  A face that hands its whole state to a callee inherits the callee's read-set.
 4. RENDERER PLUMBING is not application state.  PrismCanvasCtx (theme+cursor+metrics+output
    buffer) is threaded into every painter, which is why 20 unrelated painters all read exactly
    12/13 of it.  Reactivity never tracks a canvas context; it is the face's OUTPUT channel.
    Left in, it alone drove the regression slope from 0.13 to 0.46.

KNOWN LIMITS (stated because they bound the verdict, see M1_7_FALSIFIER_RESULT.md):
  * Static and syntactic.  Field reads behind a dict/list indirection are invisible.
  * The delegation fixed point unions a callee's WHOLE read-set for the matching param -- it does
    not slice by which part of the result the caller observes.  An implementable inference pass
    without value-level slicing has the same imprecision, so this is representative, not a bug.
  * The corpus is a LIBRARY.  Its largest app-state type is 16 leaves, so nothing here supports
    extrapolation to a 200- or 500-leaf application state tree.

Run:  python NOVA_DESIGN/tools/m17_readset.py [prism_root]
"""
import io, os, re, sys, statistics
from collections import defaultdict, Counter

ROOT = sys.argv[1] if len(sys.argv) > 1 else 'prism'
# Renderer context, not application state -- see correction 4.
PLUMBING = {'PrismCanvasCtx', 'PrismCanvasTheme'}


def load_types(root):
    types = {}
    for dp, _, fs in os.walk(root):
        if os.sep + 'kat' in dp:
            continue
        for f in sorted(fs):
            if not f.endswith('.nova'):
                continue
            cur = None
            for line in io.open(os.path.join(dp, f), encoding='utf-8', errors='replace'):
                line = line.rstrip('\n')
                m = re.match(r'^type\s+([A-Za-z_]\w*)', line)
                if m:
                    cur = m.group(1)
                    types[cur] = []
                    continue
                if cur is not None:
                    fm = re.match(r'^\s{4}([a-z_]\w*)\s*:\s*([A-Za-z_][\w<>]*)', line)
                    if fm:
                        types[cur].append((fm.group(1), fm.group(2)))
                    elif line.strip() == '' or not line.startswith('    '):
                        cur = None
    return types


def reach(types, t, seen=None):
    """Transitive dotted leaf paths reachable from a value of type t. Cycle-safe."""
    if seen is None:
        seen = set()
    if t in seen or t not in types:
        return set()
    seen = seen | {t}
    out = set()
    for fld, ft in types[t]:
        inner = re.sub(r'^.*<|>.*$', '', ft)          # Result<PrismX> / list -> PrismX
        sub = reach(types, inner, seen) if inner in types else set()
        if sub:
            for s in sub:
                out.add(fld + '.' + s)
        else:
            out.add(fld)
    return out


def load_fns(root):
    F = {}
    for dp, _, fs in os.walk(root):
        if os.sep + 'kat' in dp:
            continue
        for f in sorted(fs):
            if not f.endswith('.nova'):
                continue
            L = io.open(os.path.join(dp, f), encoding='utf-8', errors='replace').read().split('\n')
            i = 0
            while i < len(L):
                m = re.match(r'^fn\s+(?:<[^>]*>\s*)?([a-z_]\w*)\s*\((.*?)\)\s*(?:->\s*(\S+))?\s*$', L[i])
                if m:
                    body, j = [], i + 1
                    while j < len(L) and (L[j].startswith('    ') or L[j].strip() == ''):
                        body.append(L[j])
                        j += 1
                    typed = [(a.group(1), a.group(2))
                             for a in re.finditer(r'([a-z_]\w*)\s*:\s*([A-Za-z_]\w*)', m.group(2))]
                    # positional names incl. untyped params, so arg index -> param maps correctly
                    pos = [p.group(1) for p in
                           (re.match(r'\s*([a-z_]\w*)', s) for s in m.group(2).split(',')) if p]
                    F[m.group(1)] = (typed, pos, m.group(3) or '', '\n'.join(body), f[:-5])
                    i = j
                    continue
                i += 1
    return F


def transitive_reads(F):
    """(fn, param) -> dotted read prefixes; fixed point over whole-value delegation."""
    direct = defaultdict(set)
    for fn, (typed, pos, ret, body, mod) in F.items():
        for pv, _ in typed:
            for fm in re.finditer(re.escape(pv) + r'((?:\.[a-z_]\w*)+)', body):
                direct[(fn, pv)].add(fm.group(1)[1:])

    edges = defaultdict(set)
    for fn, (typed, pos, ret, body, mod) in F.items():
        pvars = {pv for pv, _ in typed}
        for cm in re.finditer(r'\b([a-z_]\w*)\s*\(([^()]*)\)', body):
            callee, args = cm.group(1), cm.group(2)
            if callee not in F or callee == fn:
                continue
            cpos = F[callee][1]
            for idx, a in enumerate(args.split(',')):
                if a.strip() in pvars and idx < len(cpos):
                    edges[(fn, a.strip())].add((callee, cpos[idx]))

    trans = {k: set(v) for k, v in direct.items()}
    for k in edges:
        trans.setdefault(k, set())
    for _ in range(64):
        changed = False
        for k, outs in edges.items():
            acc = set(trans.get(k, ()))
            for c in outs:
                acc |= trans.get(c, set())
            if acc != trans.get(k, set()):
                trans[k] = acc
                changed = True
        if not changed:
            break
    return direct, trans


def fit(rows, ix_read, ix_reach):
    xs = [r[ix_reach] for r in rows]
    ys = [r[ix_read] for r in rows]
    mx, my = statistics.mean(xs), statistics.mean(ys)
    den = sum((x - mx) ** 2 for x in xs)
    b1 = sum((x - mx) * (y - my) for x, y in zip(xs, ys)) / den if den else 0.0
    b0 = my - b1 * mx
    sy = statistics.stdev(ys) if len(ys) > 1 else 0
    r = (b1 * statistics.stdev(xs) / sy) if sy else 0
    return b0, b1, r * r


def report(label, rows):
    if not rows:
        print(label + ": none")
        return None
    pct = [r[6] for r in rows]
    b0, b1, r2 = fit(rows, 4, 5)
    over = 100.0 * sum(1 for x in pct if x > 30) / len(pct)
    print("{}  n={}".format(label, len(rows)))
    print("  read-set: mean {:.2f} leaves, median {:.1f}".format(
        statistics.mean([r[4] for r in rows]), statistics.median([r[4] for r in rows])))
    print("  as pct of reachable: mean {:.1f}%  median {:.1f}%  over-30%: {:.0f}%".format(
        statistics.mean(pct), statistics.median(pct), over))
    print("  scaling: read-set = {:.2f} + {:.3f} x reachable  (r2={:.2f})".format(b0, b1, r2))
    return b1


def main():
    types = load_types(ROOT)
    F = load_fns(ROOT)
    direct, trans = transitive_reads(F)

    faces, reducers = [], []
    for fn, (typed, pos, ret, body, mod) in F.items():
        for pv, pt in typed:
            if pt not in types:
                continue
            R = reach(types, pt)
            if len(R) < 3:                       # a 1-2 field wrapper says nothing
                continue
            pre = trans.get((fn, pv), set())
            read = {x for x in R for p in pre if x == p or x.startswith(p + '.')}
            if not read:
                continue
            dpre = direct.get((fn, pv), set())
            dread = {x for x in R for p in dpre if x == p or x.startswith(p + '.')}
            rec = (mod, fn, pt, len(dread), len(read), len(R), 100.0 * len(read) / len(R))
            if re.sub(r'^.*<|>.*$', '', ret) == pt:
                reducers.append(rec)
            else:
                faces.append(rec)

    app = [f for f in faces if f[2] not in PLUMBING]
    plumb = [f for f in faces if f[2] in PLUMBING]

    grew = sum(1 for f in faces if f[4] > f[3])
    print("corpus: {} state types, {} fns, mean reachable leaves/type {:.1f}".format(
        len(types), len(F), statistics.mean([len(reach(types, t)) for t in types])))
    print("read-sets that GREW once helpers were followed: {}/{} ({:.0f}%)   mean {:.2f} -> {:.2f} leaves".format(
        grew, len(faces), 100.0 * grew / len(faces),
        statistics.mean([f[3] for f in faces]), statistics.mean([f[4] for f in faces])))
    print()
    report("APP-STATE FACES", app)
    print()
    report("RENDERER PLUMBING (excluded)", plumb)
    print()
    report("REDUCERS (excluded -- read all by construction)", reducers)
    print()

    print("largest app-state types measured (this bounds any extrapolation):")
    for t, n in Counter(f[2] for f in app if f[5] >= 8).most_common(6):
        print("  {:22s} {:2d} leaves, {} faces".format(t, len(reach(types, t)), n))
    print()
    app.sort(key=lambda q: -q[6])
    print("widest app-state faces (granularity collapse, if anywhere):")
    for q in app[:8]:
        print("  {:5.1f}%  {:2d}/{:2d} (direct {})  {}.{}({})".format(
            q[6], q[4], q[5], q[3], q[0], q[1], q[2]))


if __name__ == '__main__':
    main()
