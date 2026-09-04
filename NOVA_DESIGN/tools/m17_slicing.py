#!/usr/bin/env python3
"""M1.7 part 2 -- DOES CONSTRUCTOR SLICING RECOVER THE INFLATED READ-SETS?

Part 1 (m17_readset.py) found the dominant imprecision: a face hands its whole state to a helper
and inherits that helper's ENTIRE read-set. prism_ss_is_usable reads 11/11 leaves of PrismSession
with direct=0 -- it touches no field itself. Part 1 named this the genuine risk to M3.4, because an
inference pass without value-level slicing computes exactly that over-approximation.

This measures whether the CHEAPEST available slicing technique recovers it.

THE KEY OBSERVATION.  The helpers causing the inflation are FIELD-WISE RECONSTRUCTORS -- functions
of shape `f(p: T, ...) -> T` whose body is `T(p.f0, p.f1, ..., expr, ...)`, i.e. a functional
"with"-style update. _ss_advance passes 10 of 11 fields through UNCHANGED and rewrites one. That is
not a hard dataflow problem: result field i flows from whatever arg i mentions, a direct
field-to-field map. So reading `result.X` depends only on X's SOURCE fields, not on all of f's
reads.

Measured over the corpus: 90 reconstructors, and a mean 49% of their fields pass through
identically (median 50%) -- which is why the map is worth building.

VALIDATION.  For prism_ss_is_usable the slicer returns 4/11: ss_access_sec, ss_status, ss_seen_ms,
ss_expires_at. That is exactly the set derivable by hand from the source, computed independently.

LIMITS.  This slicer is deliberately the simplest version: ONE level, syntactic, matching only
`let v = recon(p, ...)` followed by reads of `v.X`. A real pass would iterate to a fixed point and
handle nesting, so every number here is an UPPER BOUND on the read-set -- real inference can do at
least this well, not worse.

Run:  python NOVA_DESIGN/tools/m17_slicing.py
"""
import io, os, re, statistics, importlib.util
from collections import Counter

_spec = importlib.util.spec_from_file_location(
    "m17", os.path.join(os.path.dirname(os.path.abspath(__file__)), "m17_readset.py"))
m17 = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(m17)


def split_args(body, start):
    """Top-level comma split of a call's argument list beginning just after '('."""
    i, depth, cur, args = start, 1, '', []
    while i < len(body) and depth > 0:
        c = body[i]
        if c == '(':
            depth += 1
        elif c == ')':
            depth -= 1
            if depth == 0:
                args.append(cur)
                break
        if depth == 1 and c == ',':
            args.append(cur)
            cur = ''
        else:
            cur += c
        i += 1
    return args


def reconstructors(types, F):
    """fn -> (param, type, {result_field: {source fields}}) for field-wise reconstructors."""
    out = {}
    for fn, (typed, pos, ret, body, mod) in F.items():
        rt = re.sub(r'^.*<|>.*$', '', ret)
        if rt not in types:
            continue
        pv = [v for v, t in typed if t == rt]
        if not pv:
            continue
        pv = pv[0]
        decl = [f for f, _ in types[rt]]
        maps = []
        for cm in re.finditer(re.escape(rt) + r'\(', body):
            args = split_args(body, cm.end())
            if len(args) != len(decl):
                continue
            maps.append({decl[i]: {g.group(1) for g in
                                   re.finditer(re.escape(pv) + r'\.([a-z_]\w*)', a)}
                         for i, a in enumerate(args)})
        if maps:
            merged = {f: set() for f in decl}
            for fm in maps:
                for k, v in fm.items():
                    merged[k] |= v
            out[fn] = (pv, rt, merged)
    return out


def main():
    types = m17.load_types('prism')
    F = m17.load_fns('prism')
    recon = reconstructors(types, F)

    ident = [100.0 * sum(1 for f, s in mp.items() if s == {f}) / len(mp)
             for _, (_, _, mp) in recon.items()]
    print("field-wise reconstructors: {}".format(len(recon)))
    print("  fields passing through IDENTICALLY: mean {:.0f}%, median {:.0f}%"
          "   <- why the map is cheap to build".format(statistics.mean(ident), statistics.median(ident)))
    print()

    direct, trans = m17.transitive_reads(F)
    rows = []
    for fn, (typed, pos, ret, body, mod) in F.items():
        for pv, pt in typed:
            if pt not in types or pt in m17.PLUMBING:
                continue
            if re.sub(r'^.*<|>.*$', '', ret) == pt:      # reducer
                continue
            R = m17.reach(types, pt)
            if len(R) < 3:
                continue
            pre = trans.get((fn, pv), set())
            unsliced = {x for x in R for p in pre if x == p or x.startswith(p + '.')}
            if not unsliced:
                continue
            sl = {g.group(1)[1:] for g in
                  re.finditer(re.escape(pv) + r'((?:\.[a-z_]\w*)+)', body)}
            for lm in re.finditer(r'let\s+([a-z_]\w*)\s*=\s*([a-z_]\w*)\s*\(\s*'
                                  + re.escape(pv) + r'\b', body):
                lv, callee = lm.group(1), lm.group(2)
                if callee not in recon:
                    continue
                mp = recon[callee][2]
                for u in re.finditer(re.escape(lv) + r'\.([a-z_]\w*)', body):
                    sl |= mp.get(u.group(1), {u.group(1)})
            sliced = {x for x in R for p in sl if x == p or x.startswith(p + '.')}
            if sliced:
                rows.append((mod, fn, pt, len(sliced), len(unsliced), len(R)))

    impr = [r for r in rows if r[3] < r[4]]
    print("app-state faces: {}   improved by slicing: {}".format(len(rows), len(impr)))
    print("  read-set:  unsliced mean {:.2f} leaves  ->  SLICED {:.2f}".format(
        statistics.mean([r[4] for r in rows]), statistics.mean([r[3] for r in rows])))
    print("  as pct of reachable:  {:.1f}%  ->  {:.1f}%".format(
        statistics.mean([100.0 * r[4] / r[5] for r in rows]),
        statistics.mean([100.0 * r[3] / r[5] for r in rows])))
    print("  faces over the 25% line:  {}  ->  {}".format(
        sum(1 for r in rows if 100.0 * r[4] / r[5] > 25),
        sum(1 for r in rows if 100.0 * r[3] / r[5] > 25)))
    for label, ix in (("unsliced", 4), ("SLICED", 3)):
        xs = [r[5] for r in rows]
        ys = [r[ix] for r in rows]
        mx, my = statistics.mean(xs), statistics.mean(ys)
        b1 = sum((x - mx) * (y - my) for x, y in zip(xs, ys)) / sum((x - mx) ** 2 for x in xs)
        b0 = my - b1 * mx
        r = b1 * statistics.stdev(xs) / statistics.stdev(ys)
        print("  {:8s} scaling: read-set = {:.2f} + {:.3f} x reachable  (r2={:.2f})".format(
            label, b0, b1, r * r))
    print()
    print("  the tail is what matters -- biggest recoveries:")
    for q in sorted(impr, key=lambda z: z[3] - z[4])[:8]:
        print("    {:2d}/{:2d} -> {:2d}/{:2d}   {}.{}({})".format(
            q[4], q[5], q[3], q[5], q[0], q[1], q[2]))


if __name__ == '__main__':
    main()
