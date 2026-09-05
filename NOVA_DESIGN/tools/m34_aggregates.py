#!/usr/bin/env python3
"""M3.4 -- AGGREGATE FACES: how big is the fold-over-all-rows problem, really?

`PRISM_M3_4_REACTIVITY_DESIGN.md` SS5 flags a gap the original failure hunt missed: keyed
sub-faces (SS4b) fix per-row RENDERING, but do nothing for a fold over ALL rows.
`prism_con_stat_row` reads 50 of 52 leaves because it *counts* across every element of a
collection -- keying one row cannot shrink that, because the aggregate genuinely depends on every
element. Before designing an incremental-view-maintenance mechanism for that, this tool measures
how many such faces exist across the WHOLE `prism/` corpus (not just the console app), what shape
each fold takes, and whether it is even possible to update it from a changeset alone.

WHAT THIS MEASURES

  STEP 1 -- AGGREGATE PRIMITIVES.  A function is an aggregate primitive if its body, for one of its
  declared-struct-typed parameters, folds a collection-typed field of that parameter into a scalar
  (or a small joined/concatenated summary), via one of the shapes actually found by inspecting this
  corpus (grep first, pattern second -- see METHOD):
    (a) bare cardinality:      len(p.coll)                              -- e.g. prism_nt_count
    (b) filtered cardinality:  len(p.coll.filter(fn(x) ...))             -- e.g. prism_con_open_issue_count
                               len(HELPER(p...).filter(fn(x) ...)) where HELPER passes the
                               collection through unchanged (a "flatten" helper)
    (c) manual loop accumulator: `for x in p.coll: ACC[0] = ACC[0] <op> ...` (a boxed mutable cell,
        this codebase's idiom for "a local the closure captures"), where ACC is the value the
        function actually returns afterwards -- as opposed to a plain loop INDEX that never
        escapes the loop (`cursor` in `prism_tm_same`, which indexes but is not returned)
    (d) map + reduce:  p.coll.map(fn(x) x.f).sum() / min(p.coll.map(...)) / max(p.coll.map(...)) /
        join(p.coll.map(fn(x) x.f), sep)                                 -- e.g. prism_tm_text
    (e) holistic (median/percentile/top-N/distinct-count): searched for explicitly (keyword scan
        over the whole corpus plus a `len(unique(...))`/`len(dedup(...))`-shaped scan) -- NONE
        found. Reported as zero, not omitted, because a milestone document must say what it looked
        for and did not find, not just what it found.

  STEP 2 -- INCREMENTALIZABILITY, per PRISM_M3_4_REACTIVITY_DESIGN.md SS5's own three-way split:
    self-maintainable       count / filtered-count / sum / boolean AND-fold -- updatable from the
                             changeset alone (a group inverse exists: insert/delete of one element
                             changes the accumulator by a bounded, computable amount)
    not self-maintainable   min/max -- inserting is O(1) (compare-and-replace), but deleting the
    on delete               CURRENT extreme forces a rescan to find the new one
    holistic                median / percentile / top-N / distinct-count -- no bounded incremental
                             update exists at all. None found in this corpus (see 1e).

  STEP 3 -- COST.  For every aggregate face IN THE M17 READ-SET POPULATION (see POPULATION below),
  its read-set size and which collection(s) it folds over, reusing `m17_readset.py`'s own
  `reach`/`transitive_reads` rather than recomputing read-sets from scratch. Corpus totals: how
  many of all app-state faces are aggregates, and aggregate vs non-aggregate mean read-set.

  STEP 4 -- THE CONSOLE APP.  Every aggregate in `prism_app_console.nova` (the app the M3.4 design
  is measured against), named, classified, with its read-set -- reproducing and extending
  `M1_7_FALSIFIER_RESULT.md`'s own `prism_con_stat_row` (50/52) finding rather than re-deriving it
  from nothing.

POPULATION, STATED UP FRONT (four earlier passes in this campaign each got a wrong answer from the
wrong population or unit -- see M1_7_FALSIFIER_RESULT.md's "FOUR CORRECTIONS" and
PRISM_M3_4_REACTIVITY_DESIGN.md SSCRITERION's four revisions):

  * The base population for STEP 1's primitive scan is EVERY function in the corpus with at least
    one parameter typed as a declared `type` (2245 functions total, per m17.load_fns), independent
    of whether m17's own read-set machinery would count it as a "face" -- because, as STEP 1.5
    below shows, several real aggregates are invisible to that machinery for a reason worth
    surfacing on its own.
  * The population for STEPS 2-4 (read-set COST) is m17's own "APP-STATE FACES" selection,
    reproduced here from its exported pieces (load_types/reach/load_fns/transitive_reads/PLUMBING)
    rather than re-derived: parameter type declared via `type`, >=3 reachable leaves, non-empty
    transitive read, return type != parameter type (excludes reducers), parameter type not in
    m17.PLUMBING (excludes renderer context: PrismCanvasCtx/PrismCanvasTheme).
  * ONE ADDITIONAL EXCLUSION NOT IN m17, JUSTIFIED BELOW: PrismNode. See STEP 1.5.
  * A function with two struct-typed parameters (e.g. `prism_tm_same(a: PrismDoc, b: PrismDoc)`)
    gets one population entry PER PARAMETER, exactly matching m17's own per-(fn, param) counting
    (its published "535" and "571" totals already count this way -- verified by reproducing 571
    here, see the corpus-totals print at startup).

STEP 1.5 -- A FIFTH INSTANCE OF A TRAP THIS CAMPAIGN HAS ALREADY NAMED FOUR TIMES, FOUND WHILE
BUILDING THIS TOOL, NOT GUESSED AT: `PrismNode` -- the type EVERY face RETURNS -- is itself a
declared `type` with 6 flat leaves (kind/attrs/children/key/depth/count), so any function taking a
`PrismNode` PARAMETER (a renderer, a backend serializer, a dev-tool tree-walker consuming an
already-built tree) satisfies m17's own face criteria and gets counted as a "face over PrismNode
state". Measured directly against this corpus: **157 of m17's reported 571 app-state faces (27.5%)
have PrismNode as their parameter type** -- functions like `_gd_walk`/`_exp_walk` (tree-walking
accumulators over a DEV-TOOL introspection of the rendered tree) and every canvas/ansi/html
backend function. None of these read APPLICATION state; they consume a face's OUTPUT. This is
qualitatively the same mistake M1_7_FALSIFIER_RESULT.md's correction #4 fixed for
PrismCanvasCtx/PrismCanvasTheme (context threaded into every call, mistaken for state) -- here the
mechanism is different (an OUTPUT type, not a context type) but the effect is identical: a type
that is not application state inflates the "faces" population by over a quarter. Excluded here via
OUTPUT_TYPES = m17.PLUMBING | {'PrismNode'}, and the exclusion count is printed so this is checked,
not asserted.

STEP 1.6 -- A SIXTH, DIFFERENT ISSUE, ALSO FOUND WHILE BUILDING THIS TOOL: two of the highest-
confidence real aggregates found by hand -- `prism_nt_pending_ack`/`prism_nt_count`
(PrismNoticeQueue) and `prism_tm_same`/`prism_tm_text`/`prism_tm_length`/`prism_tm_width`
(PrismDoc) -- are INVISIBLE to m17's read-set population entirely, not merely under-measured. Both
`PrismNoticeQueue.nq_items` and `PrismDoc.tm_doc_runs` are declared as bare `list` (a source
comment even says "// list<PrismRun>, canonical" right next to the bare-`list` annotation), so
`reach()` cannot recurse into the element type and scores the WHOLE type at 1-2 leaves --
below m17's own ">=3 reachable leaves" cutoff (a cutoff that exists to drop "a 1-2 field wrapper
[that] says nothing", which is exactly wrong here: the wrapper has one field, but that field is a
collection). This is DIFFERENT from the already-documented "a collection is one leaf" caveat in
M1_7_FALSIFIER_RESULT.md (which was measured on state types that DO write `list<PrismConX>` and so
DO get a 1-leaf-but-still-counted read) -- this is the population dropping the type before read-set
size is even at issue. Reported as a separate, explicitly-labeled section (STEP 1.6 below), not
folded into the STEP 3/4 population, because folding it in would silently change what "the m17
population" means for every future reader who diffs this tool's headline numbers against
M1_7_FALSIFIER_RESULT.md's.

METHOD (how the shapes above were chosen -- not guessed, grepped): every regex in this file
followed a manual grep pass over the non-kat corpus for `.filter(`, `.map(`, `.sum()`, `min(`/
`max(`, `[0] =` (this codebase's boxed-mutable-cell idiom), and `median|percentile|distinct|
top_n|unique(|dedup(`, reading the surrounding function for each hit before writing a pattern for
it. Two real hits were found and deliberately EXCLUDED after inspection, and are named in the
report as a caution against over-counting: `_max_w`/`_max_h` in
`backend/canvas/prism_render_canvas.nova` (`max(boxes.map(fn(b) b.pcv_w))`) and
`prism_spl_panes`'s `pcts.sum()` in `ui/prism_ui_splitter.nova` -- both take a bare `list` /
`PrismCanvasCtx` parameter, not a declared application-state struct, so neither is a face over
state at all; they are layout math and constructor validation, respectively.

LIMITS -- read before trusting a count in this file's output.

  * Static and syntactic, same as m17/m34. A fold reached through a dict/list index, a value
    threaded through a combinator this tool does not special-case, or dynamic dispatch is
    invisible to it. A closure shape not in the METHOD list above needs its own case to be found.
  * STEP 1's loop-accumulator detector (pattern c) only recognises THIS codebase's specific idiom:
    a `let NAME = [init]` boxed cell (or `let mut NAME = init`) declared before the loop, updated
    inside it, and referenced again afterward. It tells the RETURNED accumulator apart from an
    internal loop index (like `cursor` in `prism_tm_same`) by checking which name is referenced
    AFTER the loop block ends -- this is a real distinction this tool has to make correctly (an
    index that never escapes the loop is not an aggregate), and it is checked against the two
    named, hand-verified examples in this docstring before being trusted further.
  * The "is this face DOMINATED by its aggregate, or does the aggregate arrive alongside a row-
    render (keyed-subface) concern that already explains most of its read-set" classification is a
    heuristic (does the face's OWN body also contain a bare `fn(v) v.field` row-closure), not a
    proof. It is deliberately narrow (a filter PREDICATE like `fn(i) i.some_bool_field` with no
    comparison would be mis-read as a row-closure) -- stated here rather than discovered later. The
    two named results this tool's docstring claims (`prism_con_stat_row` aggregate-dominant,
    `prism_con_project_list` row-dominant with an incidental count) are cross-checked against a
    hand read of the source, not trusted from the heuristic alone.
  * The delegation graph (STEP 1, "does face F transitively call an aggregate primitive") resolves
    ONE level of local `let VAR = param.chain` aliasing (needed for `prism_con_stat_row`'s
    `let ws = state.con_workspace` before it calls `prism_con_open_issue_count(ws)`) but not two,
    and does not resolve through a `?`-chained or nested call expression as an argument.
  * `gd_ar_role_count`/`PrismCanvasBox`-style PRE-COMPUTED aggregate fields (a count stored in the
    struct at construction time, e.g. `GdAuditReport.gd_ar_role_count`, `PrismNode.count`) are NOT
    counted as aggregate FACES here -- reading a field is O(1) regardless of what computed it. They
    are the existing, load-bearing precedent that "maintain the aggregate as state and update it
    from the changeset" (the mechanism SS5 says this design does not yet address) already works
    for at least one shape in this codebase, and are named in the report for that reason.
  * One corpus, one static pass, same day as the design doc it answers. It measures what shapes
    exist in 55k lines written by one team; it is not a claim about UI aggregates in general.

Run:  python NOVA_DESIGN/tools/m34_aggregates.py [prism_root]
"""
import io, os, re, sys, statistics, importlib.util
from collections import defaultdict, Counter

_HERE = os.path.dirname(os.path.abspath(__file__))


def _load(modname):
    spec = importlib.util.spec_from_file_location(modname, os.path.join(_HERE, modname + '.py'))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


m17 = _load('m17_readset')
m34k = _load('m34_keyed_subfaces')     # reuse strip_generic/field_type -- do not re-derive them

strip_generic = m34k.strip_generic
field_type = m34k.field_type

ROOT = sys.argv[1] if len(sys.argv) > 1 else 'prism'
CONSOLE_MOD = 'prism_app_console'
CONSOLE_TYPE = 'PrismConState'

# See STEP 1.5 in the module docstring: PrismNode is a face's OUTPUT type, not application state,
# and is not caught by m17.PLUMBING (which only names the two renderer-CONTEXT types).
OUTPUT_TYPES = set(m17.PLUMBING) | {'PrismNode'}

_COLLECTION_FT = re.compile(r'^(list|dict)(<.*>)?$')


def is_collection_ft(ft):
    return bool(ft) and bool(_COLLECTION_FT.match(ft))


def resolve_chain_type(types, root_type, chain):
    """Declared field type at the end of dotted `chain` (e.g. 'con_workspace.conws_projects')
    rooted at `root_type`. None if any segment isn't a declared field."""
    cur, ft = root_type, None
    for part in chain.split('.'):
        ft = field_type(types, cur, part)
        if ft is None:
            return None
        cur = strip_generic(ft)
    return ft


#==================================================================================================
# STEP 0 -- population: m17's own "APP-STATE FACES" selection, reproduced from its exported pieces
# (never re-derived independently), plus the OUTPUT_TYPES exclusion justified in STEP 1.5.

def build_population(types, F, direct, trans):
    pop = {}
    excluded_output = 0
    for fn, (typed, pos, ret, body, mod) in F.items():
        for pv, pt in typed:
            if pt not in types:
                continue
            R = m17.reach(types, pt)
            if len(R) < 3:
                continue
            pre = trans.get((fn, pv), set())
            read = {x for x in R for p in pre if x == p or x.startswith(p + '.')}
            if not read:
                continue
            if strip_generic(ret) == pt:
                continue                          # reducer
            if pt in m17.PLUMBING:
                continue
            if pt in OUTPUT_TYPES:
                excluded_output += 1
                continue
            dpre = direct.get((fn, pv), set())
            dread = {x for x in R for p in dpre if x == p or x.startswith(p + '.')}
            pop[(fn, pv)] = dict(pt=pt, mod=mod, body=body, R=R, read=read, dread=dread)
    return pop, excluded_output


#==================================================================================================
# STEP 1 -- aggregate PRIMITIVE detection, over EVERY typed struct parameter in the corpus (not
# just the population above -- see STEP 1.6).

_FOR_HEAD = re.compile(r'^(\s*)for\s+([a-z_]\w*)\s+in\s+([a-z_][\w.]*)\s*\??\s*$')
_LEN_FILTER_DIRECT = re.compile(r'\blen\(\s*([a-z_]\w*(?:\.[a-z_]\w*)*)\.filter\(')
_LEN_FILTER_CALL = re.compile(r'\blen\(\s*([a-z_]\w*)\(([^()]*)\)\.filter\(')
_LEN_CHAIN = re.compile(r'\blen\(\s*([a-z_]\w*(?:\.[a-z_]\w*)*)\s*\)')
_MAP_SUM = re.compile(r'\b([a-z_]\w*(?:\.[a-z_]\w*)*)\.map\([^()]*\)\.sum\(\)')
_MINMAX_MAP = re.compile(r'\b(min|max)\(\s*([a-z_]\w*(?:\.[a-z_]\w*)*)\.map\(')
_JOIN_MAP = re.compile(r'\bjoin\(\s*([a-z_]\w*(?:\.[a-z_]\w*)*)\.map\(')
_BOX_INIT = re.compile(r'^\s*let\s+(?:mut\s+)?([a-z_]\w*)\s*=\s*(\[.*\]|true|false|-?\d+|"")\s*$')
_ALIAS_RE = re.compile(r'^\s*let\s+([a-z_]\w*)\s*=\s*([a-z_]\w*(?:\.[a-z_]\w*)*)\s*\??\s*$')

CLS_SELF = 'self-maintainable'
CLS_SELF_STAR = 'self-maintainable*'     # bool AND/OR-fold -- needs a satisfy-count, see LIMITS
CLS_NOT_ON_DELETE = 'not-self-maintainable-on-delete'
CLS_HOLISTIC = 'holistic'
CLS_UNCLASSIFIED = 'unclassified'


def _own_chain(expr, pv):
    if expr == pv:
        return ''
    if expr.startswith(pv + '.'):
        return expr[len(pv) + 1:]
    return None


def scan_expr_shapes(pv, pt, types, body):
    """Non-loop shapes: bare/filtered cardinality, map+sum/min/max/join (rules A/B/D)."""
    hits = []
    filtered_chains = set()

    for m in _LEN_FILTER_DIRECT.finditer(body):
        sub = _own_chain(m.group(1), pv)
        if sub is None:
            continue
        ft = resolve_chain_type(types, pt, sub) if sub else None
        if is_collection_ft(ft):
            hits.append(dict(rule='B-direct', kind='count-filtered', cls=CLS_SELF, chain=sub,
                              evidence=m.group(0) + '...)'))
            filtered_chains.add(sub)

    for m in _LEN_FILTER_CALL.finditer(body):
        callee, argtext = m.group(1), m.group(2)
        callee_f = F.get(callee)
        if not callee_f:
            continue
        cpos = callee_f[1]
        args = [a.strip() for a in argtext.split(',')]
        if not args or not cpos:
            continue
        sub0 = _own_chain(args[0], pv)
        if sub0 is None:
            continue
        cd = direct.get((callee, cpos[0]), set())
        for d in cd:
            chain = (sub0 + '.' + d) if sub0 else d
            ft = resolve_chain_type(types, pt, chain)
            if is_collection_ft(ft):
                hits.append(dict(rule='B-via-helper', kind='count-filtered', cls=CLS_SELF,
                                  chain=chain, evidence=m.group(0) + '...)  [via ' + callee + ']'))
                filtered_chains.add(chain)

    for m in _LEN_CHAIN.finditer(body):
        sub = _own_chain(m.group(1), pv)
        if sub is None or sub in filtered_chains:
            continue
        ft = resolve_chain_type(types, pt, sub) if sub else None
        if is_collection_ft(ft):
            hits.append(dict(rule='A', kind='count-bare', cls=CLS_SELF, chain=sub,
                              evidence=m.group(0)))

    for m in _MAP_SUM.finditer(body):
        sub = _own_chain(m.group(1), pv)
        if sub is None:
            continue
        ft = resolve_chain_type(types, pt, sub) if sub else None
        if is_collection_ft(ft):
            hits.append(dict(rule='D', kind='sum-map', cls=CLS_SELF, chain=sub, evidence=m.group(0)))

    for m in _MINMAX_MAP.finditer(body):
        which, sub = m.group(1), _own_chain(m.group(2), pv)
        if sub is None:
            continue
        ft = resolve_chain_type(types, pt, sub) if sub else None
        if is_collection_ft(ft):
            hits.append(dict(rule='D', kind=which + '-map', cls=CLS_NOT_ON_DELETE, chain=sub,
                              evidence=m.group(0)))

    for m in _JOIN_MAP.finditer(body):
        sub = _own_chain(m.group(1), pv)
        if sub is None:
            continue
        ft = resolve_chain_type(types, pt, sub) if sub else None
        if is_collection_ft(ft):
            hits.append(dict(rule='D', kind='join-map', cls=CLS_SELF, chain=sub, evidence=m.group(0)))

    return hits


def _classify_loop_updates(loopvar, cellref_pat, updates):
    saw = set()
    for line, rhs in updates:
        if re.match(cellref_pat + r'\s*\+\s*1$', rhs):
            saw.add('count')
        elif re.match(cellref_pat + r'\s*\+\s*' + re.escape(loopvar) + r'\.[a-z_]\w*$', rhs):
            saw.add('sum')
        elif rhs in ('true', 'false'):
            saw.add('bool')
        elif re.match(r'^' + re.escape(loopvar) + r'\.[a-z_]\w*$', rhs) or \
                re.search(re.escape(loopvar) + r'\.[a-z_]\w*\s*(>|<)\s*' + cellref_pat, line):
            saw.add('minmax')
        else:
            saw.add('other')
    if 'minmax' in saw:
        return CLS_NOT_ON_DELETE, 'min-max-loop'
    if 'count' in saw:
        return CLS_SELF, 'count-loop'
    if 'sum' in saw:
        return CLS_SELF, 'sum-loop'
    if 'bool' in saw:
        return CLS_SELF_STAR, 'bool-fold-loop'
    return CLS_UNCLASSIFIED, 'other-loop'


def scan_loop_accumulators(pv, pt, types, body):
    """Rule C: `for x in p.coll: ... ACC[0] = ACC[0] <op> ...` where ACC (not a bare loop index)
    is referenced again after the loop ends."""
    lines = body.split('\n')
    hits = []
    for i, l in enumerate(lines):
        m = _FOR_HEAD.match(l)
        if not m:
            continue
        loopvar, expr = m.group(2), m.group(3)
        sub = _own_chain(expr, pv)
        if not sub:
            continue
        ft = resolve_chain_type(types, pt, sub)
        if not is_collection_ft(ft):
            continue
        loop_indent = len(l) - len(l.lstrip(' '))

        boxed = {}
        for j in range(i):
            bm = _BOX_INIT.match(lines[j])
            if bm:
                rhs = lines[j].split('=', 1)[1].strip()
                boxed[bm.group(1)] = 'box' if rhs.startswith('[') else 'mut'
        if not boxed:
            continue

        j = i + 1
        block = []
        while j < len(lines):
            lj = lines[j]
            if lj.strip() != '':
                if len(lj) - len(lj.lstrip(' ')) <= loop_indent:
                    break
                block.append(lj)
            j += 1

        touched = defaultdict(list)
        for lj in block:
            for name, style in boxed.items():
                pat = re.escape(name) + (r'\[0\]' if style == 'box' else '')
                um = re.match(r'^\s*' + pat + r'\s*=\s*(.+)$', lj)
                if um:
                    touched[name].append((lj.strip(), um.group(1).strip()))
        if not touched:
            continue

        rest = '\n'.join(lines[j:])
        for name, updates in touched.items():
            style = boxed[name]
            cellref = name + '[0]' if style == 'box' else name
            if cellref not in rest:
                continue                          # an internal index (e.g. `cursor`), not returned
            cellref_pat = re.escape(cellref)
            cls, kind = _classify_loop_updates(loopvar, cellref_pat, updates)
            hits.append(dict(rule='C', kind=kind, cls=cls, chain=sub, accumulator=name,
                              evidence='for {} in {}.{}: {}'.format(
                                  loopvar, pv, sub, updates[0][0])))
    return hits


#==================================================================================================
# STEP 1e -- holistic shapes: keyword scan across the whole corpus (independent of population).

_HOLISTIC_RE = re.compile(
    r'\b(median|percentile|top_n|topn|nlargest|nsmallest|distinct_count)\b', re.I)
_DISTINCT_COUNT_RE = re.compile(r'\blen\(\s*(unique|dedup)\(')


def scan_holistic(root):
    hits = []
    for dp, _, fs in os.walk(root):
        if os.sep + 'kat' in dp:
            continue
        for f in sorted(fs):
            if not f.endswith('.nova'):
                continue
            path = os.path.join(dp, f)
            for i, line in enumerate(io.open(path, encoding='utf-8', errors='replace'), 1):
                if _HOLISTIC_RE.search(line) or _DISTINCT_COUNT_RE.search(line):
                    hits.append((path, i, line.strip()))
    return hits


#==================================================================================================
# STEP 1' -- delegation: does face F transitively CALL an aggregate primitive?  A plain
# argument -> parameter call graph, resolving one level of `let VAR = pv.chain` aliasing (needed
# for `prism_con_stat_row`'s `let ws = state.con_workspace`). Mirrors m17.transitive_reads' own
# edge-matching regex (m17 does not expose its internal edges dict, so this is not reachable by
# importing it -- it answers a different question, "calls a primitive", not "reads a field").

def build_call_edges(F):
    edges = defaultdict(set)
    for fn, (typed, pos, ret, body, mod) in F.items():
        pvars = [pv for pv, _ in typed]
        if not pvars:
            continue
        alias = {}
        for line in body.split('\n'):
            am = _ALIAS_RE.match(line)
            if am:
                for pv in pvars:
                    sub = _own_chain(am.group(2), pv)
                    if sub is not None:
                        alias[am.group(1)] = (pv, sub)
                        break

        def resolve(a):
            for pv in pvars:
                sub = _own_chain(a, pv)
                if sub is not None:
                    return (pv, sub)
            return alias.get(a)

        for cm in re.finditer(r'\b([a-z_]\w*)\s*\(([^()]*)\)', body):
            callee, argtext = cm.group(1), cm.group(2)
            if callee not in F or callee == fn:
                continue
            cpos = F[callee][1]
            for idx, a in enumerate(a.strip() for a in argtext.split(',')):
                r = resolve(a)
                if r is not None and idx < len(cpos):
                    edges[(fn, r[0])].add((callee, cpos[idx]))
    return edges


def propagate_aggregate_reach(edges, agg_hits):
    keys = set(edges.keys()) | set(agg_hits.keys())
    trans = {k: set() for k in keys}
    for _ in range(48):
        changed = False
        for k, outs in edges.items():
            acc = set(trans.get(k, ()))
            for c in outs:
                if c in agg_hits:
                    acc.add(c)
                acc |= trans.get(c, set())
            if acc != trans.get(k, set()):
                trans[k] = acc
                changed = True
        if not changed:
            break
    return trans


_ROW_CLOSURE_RE = re.compile(r'fn\(\s*([a-z_]\w*)\s*\)\s*([a-z_]\w*\.[a-z_]\w*)')


def has_own_row_closure(body):
    for line in body.split('\n'):
        for m in _ROW_CLOSURE_RE.finditer(line):
            v, expr = m.group(1), m.group(2)
            if expr.startswith(v + '.'):
                return True
    return False


#==================================================================================================
# reporting helpers

def stats(label, values):
    if not values:
        print("  {}: n/a".format(label))
        return
    print("  {}: mean {:.2f}  median {:.1f}  max {}".format(
        label, statistics.mean(values), statistics.median(values), max(values)))


def main():
    global F, direct
    types = m17.load_types(ROOT)
    F = m17.load_fns(ROOT)
    direct, trans = m17.transitive_reads(F)

    pop, excluded_output = build_population(types, F, direct, trans)
    print("=" * 90)
    print("POPULATION")
    print("=" * 90)
    print("corpus: {} state types, {} fns".format(len(types), len(F)))
    print("m17 app-state face population reproduced here: {} (fn, param) entries "
          "over {} distinct fns".format(len(pop), len({fn for fn, pv in pop})))
    print("  excluded as OUTPUT_TYPES (m17.PLUMBING + PrismNode, see STEP 1.5): {}".format(
        excluded_output))
    node_only = sum(1 for fn, (typed, pos, ret, body, mod) in F.items()
                     for pv, pt in typed if pt == 'PrismNode')
    print("  sanity check: PrismNode reach = {} leaves; {} typed (fn,param) pairs corpus-wide "
          "take a PrismNode parameter".format(len(m17.reach(types, 'PrismNode')), node_only))
    print()

    # ---- STEP 1: aggregate primitives, over EVERY typed struct parameter, population or not ----
    print("=" * 90)
    print("STEP 1 -- AGGREGATE PRIMITIVES (corpus-wide, independent of the read-set population)")
    print("=" * 90)
    agg_hits = {}                      # (fn, pv) -> list of hit dicts
    all_pairs = 0
    for fn, (typed, pos, ret, body, mod) in F.items():
        for pv, pt in typed:
            if pt not in types:
                continue
            all_pairs += 1
            hits = scan_expr_shapes(pv, pt, types, body) + scan_loop_accumulators(pv, pt, types, body)
            if hits:
                agg_hits[(fn, pv)] = dict(pt=pt, mod=mod, hits=hits)
    print("typed (fn, param) pairs scanned: {}".format(all_pairs))
    print("aggregate-primitive hits found: {} (fn, param) pairs".format(len(agg_hits)))
    print()
    by_type = Counter(v['pt'] for v in agg_hits.values())
    for fn, pv in sorted(agg_hits):
        v = agg_hits[(fn, pv)]
        excluded = " [EXCLUDED from population -- {}]".format(
            'OUTPUT_TYPE' if v['pt'] in OUTPUT_TYPES else
            ('reach<3' if len(m17.reach(types, v['pt'])) < 3 else 'other')) \
            if (fn, pv) not in pop else ""
        print("  {}.{}({}: {}){}".format(v['mod'], fn, pv, v['pt'], excluded))
        for h in v['hits']:
            print("      [{:11s}] {:20s} {:26s} coll={}".format(
                h['rule'], h['kind'], h['cls'], h['chain'] or '(self)'))
            print("          {}".format(h['evidence']))
    print()
    print("by parameter type: {}".format(dict(by_type)))
    print()

    holistic = scan_holistic(ROOT)
    print("STEP 1e -- holistic shapes (median/percentile/top-N/distinct-count/unique+len/dedup+len):")
    print("  found: {}".format(len(holistic)))
    for path, ln, text in holistic[:10]:
        print("    {}:{}: {}".format(path, ln, text[:100]))
    print()

    # ---- STEP 1.6: aggregates invisible to the m17 population because their collection field is
    # declared as bare `list` (not `list<Struct>`), so reach() scores the whole type at <3 leaves.
    print("=" * 90)
    print("STEP 1.6 -- aggregate primitives EXCLUDED from the m17 population by reach()<3, "
          "caused by a bare-`list` (not `list<Struct>`) field annotation -- see docstring")
    print("=" * 90)
    for fn, pv in sorted(agg_hits):
        v = agg_hits[(fn, pv)]
        if (fn, pv) in pop:
            continue
        if v['pt'] in OUTPUT_TYPES:
            continue
        R = len(m17.reach(types, v['pt']))
        if R < 3:
            decl = None
            for h in v['hits']:
                ft = resolve_chain_type(types, v['pt'], h['chain']) if h['chain'] else None
                if ft:
                    decl = ft
                    break
            print("  {}.{}({}: {}, reach={}) -- {} hit(s), collection field declared as {!r}".format(
                v['mod'], fn, pv, v['pt'], R, len(v['hits']), decl))
    print()

    # ---- delegation: does a population face transitively CALL an aggregate primitive? ----
    edges = build_call_edges(F)
    trans_agg = propagate_aggregate_reach(edges, agg_hits)

    own_agg = {k for k in pop if k in agg_hits}
    delegated_agg = {k for k in pop if k not in own_agg and trans_agg.get(k)}

    print("=" * 90)
    print("AGGREGATE FACES within the m17 read-set population")
    print("=" * 90)
    print("population size: {}".format(len(pop)))
    print("  aggregate in OWN body:            {}".format(len(own_agg)))
    print("  aggregate reached via delegation: {}".format(len(delegated_agg)))
    print("  total aggregate faces:            {} ({:.1f}% of population)".format(
        len(own_agg) + len(delegated_agg),
        100.0 * (len(own_agg) + len(delegated_agg)) / len(pop) if pop else 0.0))
    print()

    dominant, incidental = [], []
    for k in sorted(own_agg | delegated_agg):
        fn, pv = k
        body = pop[k]['body']
        if has_own_row_closure(body):
            incidental.append(k)
        else:
            dominant.append(k)
    print("of those, split by whether the face's OWN body also renders rows (a keyed-subface "
          "concern already explains most of its read-set) -- heuristic, see LIMITS:")
    print("  aggregate-DOMINANT (no row-closure in own body): {}".format(len(dominant)))
    for fn, pv in dominant:
        print("      {}.{}".format(pop[(fn, pv)]['mod'], fn))
    print("  MIXED (aggregate + row-render in the same face):  {}".format(len(incidental)))
    for fn, pv in incidental:
        print("      {}.{}".format(pop[(fn, pv)]['mod'], fn))
    print()
    for name, expect in (('prism_con_stat_row', 'dominant'), ('prism_con_project_list', 'mixed')):
        got = 'dominant' if (name, 'state') in dominant else (
            'mixed' if (name, 'state') in incidental else 'not-aggregate')
        print("  sanity check: {} classified as {} (expected {}) {}".format(
            name, got, expect, "OK" if got == expect else "MISMATCH"))
    print()

    # ---- classification totals across the three-way split ----
    def worst_cls(k):
        kinds = list(agg_hits.get(k, {}).get('hits', []))
        for other in trans_agg.get(k, ()):
            kinds += agg_hits.get(other, {}).get('hits', [])
        order = [CLS_HOLISTIC, CLS_NOT_ON_DELETE, CLS_UNCLASSIFIED, CLS_SELF_STAR, CLS_SELF]
        classes = {h['cls'] for h in kinds}
        for o in order:
            if o in classes:
                return o
        return CLS_UNCLASSIFIED

    print("=" * 90)
    print("STEP 2 -- INCREMENTALIZABILITY (worst class per aggregate face)")
    print("=" * 90)
    cls_counts = Counter(worst_cls(k) for k in (own_agg | delegated_agg))
    for cls in (CLS_SELF, CLS_SELF_STAR, CLS_NOT_ON_DELETE, CLS_HOLISTIC, CLS_UNCLASSIFIED):
        names = [k for k in (own_agg | delegated_agg) if worst_cls(k) == cls]
        print("  {:26s} {:3d}   examples: {}".format(
            cls, cls_counts.get(cls, 0),
            ", ".join(sorted({pop[k]['mod'] + '.' + k[0] for k in names})[:4])))
    print()

    # ---- STEP 3: cost -- read-set size, aggregate vs non-aggregate ----
    print("=" * 90)
    print("STEP 3 -- COST: read-set size, aggregate vs non-aggregate faces")
    print("=" * 90)
    agg_keys = own_agg | delegated_agg
    agg_reads = [len(pop[k]['read']) for k in agg_keys]
    non_agg_reads = [len(v['read']) for k, v in pop.items() if k not in agg_keys]
    print("aggregate faces:     n={}".format(len(agg_keys)))
    stats("  read-set (leaves)", agg_reads)
    print("non-aggregate faces: n={}".format(len(non_agg_reads and [0] * 0) or len(non_agg_reads)))
    stats("  read-set (leaves)", non_agg_reads)
    print()
    print("aggregate faces, ranked by read-set size:")
    for k in sorted(agg_keys, key=lambda k: -len(pop[k]['read']))[:12]:
        fn, pv = k
        print("    {:3d}/{:3d}  {}  {}.{}({})".format(
            len(pop[k]['read']), len(pop[k]['R']),
            worst_cls(k), pop[k]['mod'], fn, pop[k]['pt']))
    print()
    print("which collection(s) each folds over:")
    for k in sorted(agg_keys, key=lambda k: (pop[k]['mod'], k[0])):
        fn, pv = k
        chains = sorted({h['chain'] for h in agg_hits.get(k, {}).get('hits', []) if h['chain']})
        if not chains:
            # delegated -- report the primitive(s) it reaches
            chains = sorted({h['chain'] for c in trans_agg.get(k, ())
                              for h in agg_hits.get(c, {}).get('hits', []) if h['chain']})
        print("    {}.{}: {}".format(pop[k]['mod'], fn, ", ".join(chains) or "(delegated, see above)"))
    print()

    # ---- pre-computed / already-self-maintained aggregate fields, named as positive precedent ----
    print("existing precedent for 'maintain the aggregate as state' (a field set once at "
          "construction, read as O(1) thereafter -- not a fold at read time):")
    precomputed = ['GdAuditReport.gd_ar_role_count (set by the audit builder)',
                   'PrismNode.count / PrismNode.depth (set by prism_node_new from children)']
    for p in precomputed:
        print("    {}".format(p))
    print()

    # ---- STEP 4: the console app specifically ----
    print("=" * 90)
    print("STEP 4 -- prism_app_console.nova SPECIFICALLY (the app the design is measured against)")
    print("=" * 90)
    console_keys = [k for k in agg_keys if pop[k]['mod'] == CONSOLE_MOD]
    print("aggregate faces in {}.nova: {}".format(CONSOLE_MOD, len(console_keys)))
    for k in sorted(console_keys, key=lambda k: -len(pop[k]['read'])):
        fn, pv = k
        cls = worst_cls(k)
        tag = 'DOMINANT' if k in dominant else 'MIXED'
        print("    {:3d}/{:3d} leaves  {:26s} {:8s}  {}".format(
            len(pop[k]['read']), len(pop[k]['R']), cls, tag, fn))
    print()
    if ('prism_con_stat_row', 'state') in pop:
        k = ('prism_con_stat_row', 'state')
        print("prism_con_stat_row detail: read {}/{} leaves, direct {} -- matches "
              "M1_7_FALSIFIER_RESULT.md's published 50/52 marginal figure? (that figure is "
              "MARGINAL, i.e. read minus what its own callees already cover; this print is TOTAL "
              "transitive read, a different number by construction -- see M1.7's own "
              "total-vs-marginal distinction)".format(
                  len(pop[k]['read']), len(pop[k]['R']), len(pop[k]['dread'])))
    print()

    print("=" * 90)
    print("SUMMARY")
    print("=" * 90)
    print("{} aggregate faces / {} population faces ({:.1f}%) across {} modules".format(
        len(agg_keys), len(pop), 100.0 * len(agg_keys) / len(pop) if pop else 0,
        len({pop[k]['mod'] for k in agg_keys})))
    print("incrementalizability: {} self-maintainable, {} self-maintainable*, "
          "{} not-on-delete, {} holistic, {} unclassified".format(
              cls_counts.get(CLS_SELF, 0), cls_counts.get(CLS_SELF_STAR, 0),
              cls_counts.get(CLS_NOT_ON_DELETE, 0), cls_counts.get(CLS_HOLISTIC, 0),
              cls_counts.get(CLS_UNCLASSIFIED, 0)))
    print("console app ({}): {} aggregate faces".format(CONSOLE_MOD, len(console_keys)))
    print("mean read-set: aggregate {:.2f} vs non-aggregate {:.2f} leaves".format(
        statistics.mean(agg_reads) if agg_reads else 0.0,
        statistics.mean(non_agg_reads) if non_agg_reads else 0.0))


if __name__ == '__main__':
    main()
