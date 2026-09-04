#!/usr/bin/env python3
"""M3.4 step 4 -- FACE PURITY GATE.

Static read-set analysis (see PRISM_M3_4_REACTIVITY_DESIGN.md) infers a face's dependencies from
its PARAMETERS. A face that reads MUTABLE MODULE-LEVEL STATE is therefore invisible to the
analysis: its output can change with no changeset entry, which yields a stale UI. Every other
imprecision in that design costs performance; this one costs CORRECTNESS, silently.

So it must be a REJECTION, not a warning. This tool is the detection half, runnable today with no
compiler change. Enforcement in the compiler is a separate, gated change.

It reports two things:

  1. MUTATED module-level state read by a function.  In NOVA a module-level `let X = [...]` is a
     mutable CELL (`X[0] = v`, `push(X, v)`), which is how the KATs keep their counters. A face
     reading one is unsound for reactivity.

  2. Module-level `let` with a COMPUTED initialiser.  A known project defect class: such a binding
     has read as 0/empty when the module is IMPORTED rather than run as main
     (reference_module_let_computed_initializer_zero). Independent of reactivity, and worth
     gating for its own sake.

Result as of 2026-09-04 over all 130 prism modules: 21 modules declare module-level `let`, 41
function-to-binding references, and **0 mutating** -- every one is a read-only constant. 0 computed
initialisers. The library is structurally compatible with static read-set analysis as written.

Exit code 1 if anything is found, so it can be wired into a gate.

Run:  python NOVA_DESIGN/tools/m34_face_purity.py [prism_root]
"""
import io, os, re, sys
from collections import defaultdict

ROOT = sys.argv[1] if len(sys.argv) > 1 else 'prism'


def scan(root):
    mutating, computed, refs = [], [], 0
    modcount = 0
    for dp, _, fs in os.walk(root):
        if os.sep + 'kat' in dp:
            continue
        for f in sorted(fs):
            if not f.endswith('.nova'):
                continue
            L = io.open(os.path.join(dp, f), encoding='utf-8', errors='replace').read().split('\n')

            lets = {}
            for i, l in enumerate(L):
                m = re.match(r'^let\s+([A-Za-z_]\w*)\s*=\s*(.*)$', l)
                if not m:
                    continue
                lets[m.group(1)] = (i + 1, m.group(2)[:70])
                # a call in the initialiser is the import-zero defect class; a literal is safe
                if re.search(r'[a-z_]\w*\s*\(', m.group(2)):
                    computed.append((f, i + 1, m.group(1), m.group(2)[:70]))
            if not lets:
                continue
            modcount += 1

            i = 0
            while i < len(L):
                m = re.match(r'^fn\s+(?:<[^>]*>\s*)?([a-z_]\w*)\s*\(', L[i])
                if m:
                    name = m.group(1)
                    body, j = [], i + 1
                    while j < len(L) and (L[j].startswith('    ') or L[j].strip() == ''):
                        body.append(L[j])
                        j += 1
                    b = '\n'.join(body)
                    for v, (ln, init) in lets.items():
                        if not re.search(r'\b' + re.escape(v) + r'\b', b):
                            continue
                        refs += 1
                        if (re.search(re.escape(v) + r'\s*\[[^\]]*\]\s*=', b)
                                or re.search(r'\bpush\s*\(\s*' + re.escape(v) + r'\b', b)):
                            mutating.append((f, name, v, ln, init))
                    i = j
                    continue
                i += 1
    return modcount, refs, mutating, computed


def main():
    modcount, refs, mutating, computed = scan(ROOT)
    print("modules declaring module-level `let`: {}".format(modcount))
    print("  function-to-binding references: {}   MUTATING: {}".format(refs, len(mutating)))
    print()
    if mutating:
        print("[FAIL] mutated module-level state read by a function -- invisible to read-set")
        print("       analysis, so a face reading one yields a STALE UI with no changeset entry:")
        for f, fn, v, ln, init in mutating:
            print("   {}: fn {} mutates `{}` (declared line {}: {})".format(f, fn, v, ln, init))
    else:
        print("[OK] no function mutates module-level state -- every binding is a read-only")
        print("     constant, so the library is compatible with static read-set analysis.")
    print()
    print("module-level `let` with a COMPUTED initialiser: {}".format(len(computed)))
    if computed:
        print("[FAIL] a computed module-level initialiser has read as 0/empty when the module is")
        print("       IMPORTED rather than run as main:")
        for f, ln, v, init in computed:
            print("   {}:{}  let {} = {}".format(f, ln, v, init))
    else:
        print("[OK] none -- every module-level binding has a literal initialiser.")

    if mutating or computed:
        sys.exit(1)


if __name__ == '__main__':
    main()
