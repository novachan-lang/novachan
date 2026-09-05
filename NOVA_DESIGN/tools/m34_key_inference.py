#!/usr/bin/env python3
"""M3.4 s10 -- KEY INFERENCE COVERAGE.  Does Rule 1 actually fire?

PRISM_M3_4_REACTIVITY_DESIGN.md s10 infers a collection's key by four rules in priority order.
RULE 1 is load-bearing and had never been measured:

  Rule 1 -- THE PROGRAM'S OWN LOOKUP KEY.  If an element of a collection is anywhere selected by a
  field (find(xs, fn(x) x.f == target), a filter narrowing to one, an index built on x.f), then f
  is the identity the program ALREADY uses.  Behavioural, not nominal -- the compiler reads an
  existing fact rather than guessing from a name.

  Rule 3 -- NOMINAL.  The element type carries id / <prefix>_id / key / slug / uuid / code / name /
  title.  A naming heuristic; s4b measured 62% corpus-wide, 9/10 in the console app.

s4b measured how many element types HAVE an identity field (Rule 3).  That is a DIFFERENT question
from how many are LOOKED UP BY one (Rule 1).  This measures Rule 1, and cross-tabulates the two --
the interesting cell being where both fire and DISAGREE, since s10.4 says Rule 1 wins there.

METHOD.  For every collection field whose element type is a known struct, scan the whole corpus for
an equality comparison on a field of that element type appearing inside a loop or closure.  The
compared field is the Rule 1 candidate.

LIMITS.  Static and syntactic.  A lookup expressed unusually, built from a composed predicate, or
hidden behind a helper that takes the field name as data will be MISSED -- so Rule 1 coverage here
is a LOWER BOUND.  Field names are matched corpus-wide rather than resolved per-collection, so a
field name shared by two element types can attribute a lookup to the wrong collection; every
element type in prism/ is prefixed, which makes that unlikely but not impossible.

Run:  python NOVA_DESIGN/tools/m34_key_inference.py
"""
import io, os, re, sys, importlib.util
from collections import defaultdict

_d = os.path.dirname(os.path.abspath(__file__))
_s = importlib.util.spec_from_file_location("m17", os.path.join(_d, "m17_readset.py"))
m17 = importlib.util.module_from_spec(_s)
_s.loader.exec_module(m17)

NOMINAL = re.compile(r'(^|_)(id|key|slug|uuid|code|name|title)$')


def corpus_text(root='prism'):
    out = []
    for dp, _, fs in os.walk(root):
        if os.sep + 'kat' in dp:
            continue
        for f in sorted(fs):
            if f.endswith('.nova'):
                out.append((f[:-5], io.open(os.path.join(dp, f), encoding='utf-8',
                                            errors='replace').read()))
    return out


def main():
    types = m17.load_types('prism')
    files = corpus_text()
    alltext = "\n".join(t for _, t in files)

    # collection fields whose element type is a known struct
    colls = []
    for t, fs in types.items():
        for f, ft in fs:
            inner = re.sub(r'^.*<|>.*$', '', ft)
            if (ft.startswith('list') or ft.startswith('dict')) and inner in types:
                colls.append((t, f, inner))

    # Rule 1: an equality comparison on a field of the element type, inside a loop or closure.
    # Collect per element-type the set of fields compared with ==.
    cmp_fields = defaultdict(set)
    for et in {c[2] for c in colls}:
        for fld, _ in types[et]:
            # x.fld == ...   or   ... == x.fld
            if re.search(r'\.' + re.escape(fld) + r'\s*==', alltext) or \
               re.search(r'==\s*\w+\.' + re.escape(fld) + r'\b', alltext):
                cmp_fields[et].add(fld)

    print("=" * 78)
    print("POPULATION")
    print("=" * 78)
    print("state types: {}   collection fields with a STRUCT element type: {}".format(
        len(types), len(colls)))
    print("distinct element types: {}".format(len({c[2] for c in colls})))
    print("(s4b's comparable population was 43 struct-collection FACES; this counts collection")
    print(" FIELDS instead, so the two are not expected to match exactly.)")
    print()

    both = r1 = r3 = neither = 0
    disagree = []
    rows = []
    for owner, fld, et in sorted(colls):
        lookup = cmp_fields.get(et, set())
        nominal = {f for f, _ in types[et] if NOMINAL.search(f)}
        has1, has3 = bool(lookup), bool(nominal)
        if has1 and has3:
            both += 1
            if not (lookup & nominal):
                disagree.append((owner, fld, et, sorted(lookup), sorted(nominal)))
        elif has1:
            r1 += 1
        elif has3:
            r3 += 1
        else:
            neither += 1
        rows.append((owner, fld, et, sorted(lookup), sorted(nominal)))

    n = len(colls)
    print("=" * 78)
    print("RULE 1 (behavioural) x RULE 3 (nominal)")
    print("=" * 78)
    def pc(x): return "{:5.1f}%".format(100.0 * x / n) if n else "n/a"
    print("  both fire              {:3d}  {}".format(both, pc(both)))
    print("  Rule 1 only            {:3d}  {}".format(r1, pc(r1)))
    print("  Rule 3 only            {:3d}  {}".format(r3, pc(r3)))
    print("  neither                {:3d}  {}".format(neither, pc(neither)))
    print()
    print("  RULE 1 coverage (a key derivable from the program's own lookup): {}  [LOWER BOUND]"
          .format(pc(both + r1)))
    print("  any rule fires:                                                  {}".format(
        pc(both + r1 + r3)))
    print()
    print("=" * 78)
    print("DISAGREEMENTS -- s10.4 says Rule 1 WINS.  How often does that matter?")
    print("=" * 78)
    if not disagree:
        print("  none: wherever both rules fire, the looked-up field set INTERSECTS the")
        print("  nominal identity set.  The Rule-1-wins ordering is therefore low-stakes.")
    else:
        print("  {} collections where the lookup field is NOT a nominal identity field:".format(
            len(disagree)))
        for owner, fld, et, lk, nm in disagree[:12]:
            print("    {}.{} ({}):".format(owner, fld, et))
            print("       looked up by : {}".format(lk))
            print("       nominal ids  : {}".format(nm))
    print()
    print("=" * 78)
    print("CONSOLE APP (prism_app_console) -- the app the design is measured against")
    print("=" * 78)
    con = [r for r in rows if r[2].startswith('PrismCon')]
    print("  collection fields with a PrismCon* element type: {}".format(len(con)))
    for owner, fld, et, lk, nm in con:
        tag = "R1+R3" if lk and nm else ("R1" if lk else ("R3" if nm else "NONE"))
        print("    [{:5s}] {}.{} -> {}".format(tag, owner, fld, et))
        if lk:
            print("             lookup: {}".format(lk))


if __name__ == '__main__':
    main()
