#!/usr/bin/env python3
"""M3.4 -- KEYED SUB-FACES: does the split actually pay for itself?

`M1_7_FALSIFIER_RESULT.md` SCALE section measured `prism_app_console.nova`'s 109-leaf
`PrismConState` and found the read-set problem is entirely collection-driven: 41% of leaves
(45/109) sit under a collection, and the three worst faces (`prism_con_selected_project` 51
marginal, `prism_con_stat_row` 50, `prism_con_project_list` 32) all iterate one.
`PRISM_M3_4_REACTIVITY_DESIGN.md` SS4(b) answers with KEYED SUB-FACES: a face that renders a
collection is structurally a face PER ELEMENT, so a row edit invalidates one row-face instead of
the whole table. This tool puts a number on how much that actually buys, on the real app, rather
than taking the design's word for it.

WHAT THIS MEASURES (four steps, matching the milestone brief)

  1. COLLECTION-ITERATING FACES.  A face over `PrismConState` "iterates a collection" if, once
     delegation is followed (the SAME fixed point M1.7 built), its read-set contains leaves that
     live under a `list<StructX>`-typed field.  Three sub-patterns actually occur in this file and
     are detected separately, because a single literal-`for`-in-body check misses two of the three
     NAMED WORST FACES (`prism_con_selected_project` and `prism_con_stat_row` have no `for` in
     their own body -- the loop is one hop away, inside a helper they call):
       (a) a literal `for x in expr` whose body reads `x.field`               [row-rendering, len()]
       (b) `fn(v) v.field` / `fn(v) SOMEFN(v.field)` closures passed to a table-column builder,
           `.filter`, or `.map`                                              [row-rendering]
       (c) a "finder" -- `for x in coll: if x.key == arg: return ok(x)` -- whose CALLER binds the
           result to a local and reads `.field` off it, or chains it into a second finder
           (`prism_con_selected_project` -> `prism_con_find_issue`)          [keyed lookup, not a list]
     (a)+(b) are genuine "render N rows" faces: keying them creates a real per-element face.
     (c) is a keyed LOOKUP, not a rendered list -- there is no "N" to key over, so it is reported
     separately (SS "in-place slicing", no population growth) rather than folded into the
     outer+element split, and `prism_con_stat_row` is a fourth, distinct case: an AGGREGATE
     (a count/sum over every element) that keying cannot help at all -- flagged, not silently
     folded into the win column.

  2. THE SPLIT, MODELED.  For a render-N-rows face, BEFORE = the existing over-approximation this
     project's own static analysis already produces (whole `list<X>` field passed to a helper is
     read as ALL its transitively reachable leaves -- i.e. exactly PRISM_M3_4 SS4(a), "path
     wildcards", which is what happens with no keying at all).  AFTER = outer face (collection
     identity/count + whatever non-element leaves it reads) + element face (the leaves actually
     referenced inside the row-closures, found by parsing them, scoped to the element type -- never
     mixed back into the 109-leaf PrismConState tree, because an element face's population is
     "per PrismConProject/PrismConIssue/...", not "per PrismConState").
     For a keyed LOOKUP, AFTER replaces "inherit the whole collection's transitive closure" with
     "the key field being compared, a collection-identity leaf, and only the specific field(s) the
     caller dereferences off the result" -- computed by a small recursive resolver
     (`resolve_face`) that composes through chained finders/wrappers, the same idea as
     `m17_slicing.py`'s reconstructor-slicer but for "search-and-return-one-element" instead of
     "rebuild-the-same-struct".  Chains are followed to a bounded depth (6), same spirit as
     `m17_slicing.py`'s explicit "ONE level" bound.

  3. REPORT.  Marginal read-set (a face's reads minus what its directly-called sibling faces
     already cover -- the SAME subtraction the SCALE section used, reproduced here and verified
     against its three published numbers before trusting it further) and invalidation fan-out
     (leaves 1..109, how many of the 26 face DEFINITIONS have that leaf in their marginal set),
     mean/median/max, BEFORE vs AFTER.

  4. KEYABILITY.  For every collection whose elements get an element face, whether the element
     type carries an identity field (`id`/`key`/`name`/`slug`/`code`/`label`/`title`, exact or
     `_`-suffixed, per PRISM_M3_4 SS4b's own definition), is positional, or is neither.

POPULATION, STATED UP FRONT (the trap that has hit this analysis three times before): candidates
are functions with a `state: PrismConState` parameter whose return type is NOT `PrismConState`
(that excludes reducers) defined in `prism_app_console.nova`.  Running this filter over the whole
corpus reproduces exactly 26 -- matching the count already published in `M1_7_FALSIFIER_RESULT.md`
and in the file's own module docstring.  Nothing here recruits reducers, renderer-plumbing types,
or faces from any other module.

LIMITS -- read this before trusting a percentage in this file's output.

  * Static and syntactic, same as `m17_readset.py`.  A read behind a dict/list index, a value
    threaded through an opaque combinator this tool does not special-case, or dynamic dispatch is
    invisible to it.
  * The "element face" read-sets (step 2's row closures) are extracted by a purpose-built parser
    for THIS file's three closure shapes: an inline `fn(v) v.field` (or `fn(v) SOMEFN(v.field)`)
    argument to any call (table columns, `.filter`, `.map`), and `let mk = fn(v) HELPER(v)` where
    HELPER is a named function with one typed struct parameter -- reusing `m17`'s OWN global
    `trans` fixed point for HELPER's read-set (e.g. `_prism_con_comment_node`) rather than
    re-deriving it.  That reuse is exact for direct field reads but, like the rest of `m17`, does
    not know a `len(x)`-only usage from a full read -- `prism_con_comment_thread`'s element face
    over-counts `concmt_reactions` by one field (the real usage is a count) for exactly this
    reason; the inline-lambda path (pattern a/b) DOES catch `len()` and does not have this gap.
    None of this is a general lambda-analysis pass; a closure shape not seen in this file would
    need its own case.
  * The finder/wrapper resolver (`resolve_face`) only recognises a relay call written as a single,
    unqualified, non-nested `NAME(args)` on its own line (a `let X = NAME(args)?` or a bare tail
    call).  A relay buried inside a qualified or nested expression is invisible to it -- this is
    why `prism_con_stat_row`'s own `let ws = state.con_workspace` line is NOT resolved as a slice
    (its `prism_con_open_issue_count(ws)`/`urgent_issue_count(ws)` calls appear only nested inside
    `str(...)`/further calls), so its AFTER number keeps 5 residual workspace-scalar leaves
    (`conws_name`/`slug`/`plan`/`seats_used`/`seats_total`) that a more complete resolver would
    also drop.  This makes `prism_con_stat_row`'s reported AFTER marginal (7) an OVER-statement of
    its true dependency (the aggregate's genuine need is the 2 per-issue fields) -- i.e. this
    specific number is conservative in the safe direction, not optimistic.
  * The AFTER model's "element face" is a MODEL, not a measurement of a real compiler pass -- like
    `m17_slicing.py`, its numbers are an upper bound on what real per-element read-set inference
    could achieve (real inference can only do at least this well, and the row closures here are
    about as simple as closures get: one field, or one field wrapped in a pure named function).
  * `prism_con_stat_row`'s AFTER number is also a genuine, UNAVOIDABLE limit of keying, separate
    from the tool gap above: an aggregate (count/sum over every element) reads every element's
    relevant field by construction, and keying an individual row cannot change that -- surfaced
    explicitly in the report rather than averaged into the win column.
  * One file, 26 faces.  Fan-out means and maxima here describe THIS app, not the corpus and not a
    500-face application; `M1_7_FALSIFIER_RESULT.md`'s own SS"Honest limits" already says as much
    for the read-set numbers this tool starts from.
  * The AFTER model's baseline is deliberately conservative in the OTHER direction too: any
    collection-driven crude-marginal leaf that none of the three rules can explain is left at its
    crude (whole-subtree) value rather than assumed fixed -- see "faces NOT affected by keying" and
    the per-face tables for what was and was not actually modeled.

Run:  python NOVA_DESIGN/tools/m34_keyed_subfaces.py [prism_root]
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
m17s = _load('m17_slicing')          # reused for split_args -- do not reimplement a paren-splitter

ROOT = sys.argv[1] if len(sys.argv) > 1 else 'prism'
TARGET_TYPE = 'PrismConState'
TARGET_MOD = 'prism_app_console'
IDENTITY_TOKENS = ('id', 'key', 'name', 'slug', 'code', 'label', 'title')


def strip_generic(ft):
    return re.sub(r'^.*<|>.*$', '', ft)


def field_type(types, t, fname):
    for f, ft in types.get(t, []):
        if f == fname:
            return ft
    return None


def collection_chain(types, root_type, path):
    """Segments of dotted `path` (rooted at root_type) whose declared field type is list</dict<."""
    parts = path.split('.')
    cur, segs = root_type, []
    for i, p in enumerate(parts):
        ft = field_type(types, cur, p)
        if ft is None:
            break
        if ft.startswith('list<') or ft.startswith('dict<'):
            segs.append((i, p, ft))
        inner = strip_generic(ft)
        cur = inner if inner in types else None
        if cur is None:
            break
    return segs


def is_identity_field(fname):
    return any(fname == tok or fname.endswith('_' + tok) for tok in IDENTITY_TOKENS)


#==============================================================================================
# STEP 1a/step-3-population -- the 26 PrismConState faces, their crude (unkeyed) total/marginal
# read-sets, and the composition graph among them.  This reproduces (and is checked against) the
# three named numbers in M1_7_FALSIFIER_RESULT.md SSSCALE before anything else is trusted.

def base_faces(types, F, direct, trans, R):
    faces = {}
    for fn, (typed, pos, ret, body, mod) in F.items():
        if mod != TARGET_MOD:
            continue
        for pv, pt in typed:
            if pt != TARGET_TYPE:
                continue
            if strip_generic(ret) == pt:
                continue  # reducer, not a face
            pre = trans.get((fn, pv), set())
            read = {x for x in R for p in pre if x == p or x.startswith(p + '.')}
            if not read:
                continue
            faces[fn] = read
    names = list(faces.keys())
    callees = {}
    for fn in names:
        body = F[fn][3]
        callees[fn] = {o for o in names if o != fn
                        and re.search(r'\b' + re.escape(o) + r'\s*\(\s*state\s*\)', body)}
    marginal = {}
    for fn in names:
        union = set()
        for c in callees[fn]:
            union |= faces[c]
        marginal[fn] = faces[fn] - union
    return faces, callees, marginal


#==============================================================================================
# STEP 1b -- collection-segment classification: which of the 109 leaves sit under a collection,
# and under which outermost `list<StructX>` field.  Reproduces the design doc's 45/109 (41%).

def classify_leaves(types, R):
    under = {}
    for path in R:
        segs = collection_chain(types, TARGET_TYPE, path)
        if segs:
            under[path] = segs[0][1]     # outermost collection field name
    return under


#==============================================================================================
# STEP 2a -- row-closure scanner (patterns (a)/(b)): `fn(v) EXPR` arguments to ANY call, anywhere
# in the target module, with the fields of `v` referenced inside EXPR, and whether each is wrapped
# in `len(...)` (a count-only read, not a full-row read).  Reused via a call-graph fixed point so a
# face that only calls a `_..._columns()` helper still gets credited with what that helper's
# closures read (M1.7 correction #3: undercounting through one hop of delegation is the dominant
# error class in this whole campaign).

_LAMBDA_RE = re.compile(r'^fn\(\s*([a-z_]\w*)\s*\)\s*(.*)$', re.DOTALL)


def scan_row_closures(F, field_owner):
    """fn -> set of (owner_type, field, count_only) referenced by any fn(v) v.field closure
    appearing as a call argument anywhere in fn's own body."""
    direct = defaultdict(set)
    for fn, (typed, pos, ret, body, mod) in F.items():
        if mod != TARGET_MOD:
            continue
        for cm in re.finditer(r'\b[a-z_]\w*\s*\(', body):
            args = m17s.split_args(body, cm.end())
            for a in args:
                a = a.strip()
                lm = _LAMBDA_RE.match(a)
                if not lm:
                    continue
                v, expr = lm.group(1), lm.group(2)
                for fm in re.finditer(re.escape(v) + r'\.([a-z_]\w*)', expr):
                    field = fm.group(1)
                    owners = field_owner.get(field)
                    if not owners or len(owners) != 1:
                        continue                       # unowned/ambiguous field -- skip, don't guess
                    owner = next(iter(owners))
                    count_only = bool(re.search(r'\blen\(\s*' + re.escape(v) + r'\.' + re.escape(field) + r'\s*\)', expr))
                    direct[fn].add((owner, field, count_only))
    return direct


def propagate_row_closures(F, direct):
    """Fixed point over a plain (unlabelled) call graph restricted to TARGET_MOD, so a face
    inherits the row-fields its own helpers reference (mirrors m17's delegation fixed point, but
    for closure-field facts rather than leaf-path reads -- a different quantity, not a reuse of
    m17's own fixed-point code)."""
    names = [fn for fn, (t, p, r, b, m) in F.items() if m == TARGET_MOD]
    edges = defaultdict(set)
    for fn in names:
        body = F[fn][3]
        for cm in re.finditer(r'\b([a-z_]\w*)\s*\(', body):
            callee = cm.group(1)
            if callee in F and callee != fn:
                edges[fn].add(callee)
    trans = {fn: set(direct.get(fn, ())) for fn in names}
    for _ in range(32):
        changed = False
        for fn in names:
            acc = set(trans[fn])
            for c in edges.get(fn, ()):
                acc |= trans.get(c, set())
            if acc != trans[fn]:
                trans[fn] = acc
                changed = True
        if not changed:
            break
    return trans


#==============================================================================================
# STEP 2b -- finder/wrapper resolver (pattern (c)): keyed LOOKUPS, not rendered lists.
#
# A FINDER is `fn NAME(coll_param: T, key_param: K) -> Result<ELEM>` whose body is exactly
# `for x in coll_param(.chain)?: if x.KEYFIELD == key_param: return ok(x)` then an `err(...)`.
# A WRAPPER is any function whose body, after its own direct field reads on ITS typed struct
# param(s), ultimately relays a finder's (or another wrapper's) result -- resolved recursively so
# `prism_con_selected_issue` (wraps `prism_con_selected_project` AND chains into
# `prism_con_find_issue`) composes correctly, bounded to depth 6 against runaway recursion.

_FOR_RE = re.compile(r'^(\s*)for\s+([a-z_]\w*)\s+in\s+([a-z_][\w.]*)\s*\??\s*$')
_IF_EQ_RE = re.compile(r'^\s*if\s+([a-z_]\w*)\.([a-z_]\w*)\s*==\s*([a-z_]\w*)\s*$')
_RETURN_OK_RE = re.compile(r'^\s*return ok\(\s*([a-z_]\w*)\s*\)\s*$')


def find_finders(types, F):
    finders = {}
    for fn, (typed, pos, ret, body, mod) in F.items():
        if len(typed) != 2:
            continue
        (cparam, ctype), (kparam, ktype) = typed
        elem = strip_generic(ret)
        if elem not in types:
            continue
        lines = body.split('\n')
        for i, l in enumerate(lines):
            fm = _FOR_RE.match(l)
            if not fm or i + 2 > len(lines):
                continue
            loopvar, expr = fm.group(2), fm.group(3)
            if not (expr == cparam or expr.startswith(cparam + '.')):
                continue
            chain = expr[len(cparam):].lstrip('.')
            # scan forward for the if-equality + return ok(x), allowing intervening blank lines
            j = i + 1
            ifm = None
            while j < len(lines) and lines[j].strip() == '':
                j += 1
            if j < len(lines):
                ifm = _IF_EQ_RE.match(lines[j])
            if not ifm or ifm.group(1) != loopvar or ifm.group(3) != kparam:
                continue
            k = j + 1
            while k < len(lines) and lines[k].strip() == '':
                k += 1
            rm = _RETURN_OK_RE.match(lines[k]) if k < len(lines) else None
            if not rm or rm.group(1) != loopvar:
                continue
            finders[fn] = dict(coll_param=cparam, coll_relchain=chain, key_param=kparam,
                                key_field=ifm.group(2), elem_type=elem)
            break
    return finders


_LET_RE = re.compile(r'^\s*let\s+([a-z_]\w*)\s*=\s*(.*?)\??\s*$')
_TAILCALL_RE = re.compile(r'^\s*([a-z_]\w*)\s*\(([^()]*)\)\s*\??\s*$')


class FaceInfo(object):
    """Resolved summary of what a function ACTUALLY depends on, in terms of its own typed struct
    parameter(s): real leaves (exist in R, narrow), an identity/count marker per collection
    touched only for its shape (reported, never counted as a real leaf), and -- if this function
    is itself a relay -- the element type and relative chain a caller can chain through."""
    def __init__(self):
        self.real = set()            # dotted leaf paths, relative to the resolved param
        self.identity = set()        # dotted collection-field prefixes touched for shape only
        self.relchain = None         # if this fn resolves to "some element", its chain
        self.elem_type = None


def resolve_face(name, F, types, finders, memo, depth=0):
    if name in memo:
        return memo[name]
    if depth > 6 or name not in F:
        return None
    memo[name] = None            # cycle guard while this call is in flight
    typed, pos, ret, body, mod = F[name]
    info = FaceInfo()

    if name in finders:
        fi = finders[name]
        info.identity.add(fi['coll_relchain'])
        info.relchain = fi['coll_relchain']
        info.elem_type = fi['elem_type']
        memo[name] = info
        return info

    struct_params = [(pv, pt) for pv, pt in typed if pt in types]
    if not struct_params:
        memo[name] = info
        return info
    pv0 = struct_params[0][0]

    def resolve_arg(expr, locals_):
        """Resolve an argument-expression's chain relative to pv0 (this fn's own struct param).
        '' means "the whole object, no further chain" (a bare pass-through); None means
        unresolvable (a literal, an unrelated local, or an expression this tool does not trace)."""
        if expr is None:
            return None
        if expr == pv0:
            return ''
        if expr.startswith(pv0 + '.'):
            return expr[len(pv0) + 1:]
        if expr in locals_ and locals_[expr].relchain is not None:
            return locals_[expr].relchain
        return None

    # PASS 1 -- relay calls (let-bound or bare tail calls to a known finder/wrapper).  Must run
    # BEFORE the blind own-field scan so the collection/struct argument of a relay call (e.g. the
    # `ws.conws_projects` implicit in `find_project(ws, id)`, or here the arg TEXT passed for it)
    # is excluded from that scan -- otherwise a bare `state.con_workspace` used only to REACH a
    # finder gets misread as "reads the whole workspace", exactly the over-approximation being
    # modeled away.
    locals_ = {}
    consumed_chains = set()      # chains "spent" as a relay's struct/collection argument
    lines = body.split('\n')
    for idx, line in enumerate(lines):
        lm = _LET_RE.match(line)
        callee = argtext = bindvar = None
        if lm and _TAILCALL_RE.match(lm.group(2)):
            cm = _TAILCALL_RE.match(lm.group(2))
            bindvar, callee, argtext = lm.group(1), cm.group(1), cm.group(2)
        else:
            tm = _TAILCALL_RE.match(line)
            if tm:
                callee, argtext = tm.group(1), tm.group(2)
        if callee is None or callee == name or callee not in F:
            continue
        callee_typed = F[callee][0]
        is_relay = callee in finders or any(pt in types for _, pt in callee_typed)
        if not is_relay:
            continue
        sub = resolve_face(callee, F, types, finders, memo, depth + 1)
        if sub is None:
            continue
        args = [a.strip() for a in argtext.split(',')] if argtext.strip() else []
        argmap = {p[0]: (args[i] if i < len(args) else None) for i, p in enumerate(callee_typed)}

        base_param = finders[callee]['coll_param'] if callee in finders else (
            callee_typed[0][0] if callee_typed else None)
        src_arg = argmap.get(base_param) if base_param else None
        base_leaf = resolve_arg(src_arg, locals_)
        for a in args:
            leaf = resolve_arg(a, locals_)
            if leaf is not None:
                consumed_chains.add(leaf if leaf else a)

        resolved_chain = None
        if sub.relchain is not None and base_leaf is not None:
            resolved_chain = sub.relchain if base_leaf == '' else base_leaf + '.' + sub.relchain
            info.identity.add(resolved_chain)

        if callee in finders:
            key_leaf = resolve_arg(argmap.get(finders[callee]['key_param']), locals_)
            if key_leaf:
                info.real.add(key_leaf)
        else:
            if base_leaf is not None:
                info.real |= sub.real if base_leaf == '' else {
                    (base_leaf + '.' + l) for l in sub.real}
            info.identity |= sub.identity

        child = FaceInfo()
        child.relchain = resolved_chain if resolved_chain is not None else sub.relchain
        child.elem_type = sub.elem_type
        if bindvar:
            locals_[bindvar] = child
        elif idx == len(lines) - 1 or all(l.strip() == '' for l in lines[idx + 1:]):
            # a bare tail call with nothing bound: this call's result IS the function's own
            # return value, so ITS resolution becomes this function's own relchain/elem_type
            info.relchain, info.elem_type = child.relchain, child.elem_type

    # PASS 2 -- this fn's OWN remaining direct field reads on its struct param (guard checks
    # etc.), EXCLUDING whatever a relay call already consumed above.
    for fm in re.finditer(re.escape(pv0) + r'((?:\.[a-z_]\w*)+)', body):
        chain = fm.group(1)[1:]
        if chain not in consumed_chains and not any(
                c == chain or chain.startswith(c + '.') for c in consumed_chains):
            info.real.add(chain)

    # `.field` access on a local bound from a finder/wrapper result
    for var, child in locals_.items():
        if child.relchain is None or child.elem_type not in types:
            continue
        for fm in re.finditer(re.escape(var) + r'\.([a-z_]\w*)', body):
            field = fm.group(1)
            if field_type(types, child.elem_type, field) is not None:
                info.real.add(child.relchain + '.' + field)

    memo[name] = info
    return info


#==============================================================================================
# reporting helpers

def stats(label, values):
    if not values:
        print("  {}: n/a".format(label))
        return
    print("  {}: mean {:.2f}  median {:.1f}  max {}".format(
        label, statistics.mean(values), statistics.median(values), max(values)))


def fanout(R, per_face_reads):
    names = list(per_face_reads.keys())
    counts = []
    for leaf in R:
        counts.append(sum(1 for n in names if leaf in per_face_reads[n]))
    return counts, len(names)


def main():
    types = m17.load_types(ROOT)
    F = m17.load_fns(ROOT)
    direct, trans = m17.transitive_reads(F)
    R = m17.reach(types, TARGET_TYPE)

    faces, callees, marginal = base_faces(types, F, direct, trans, R)
    n_faces = len(faces)
    print("population: {} faces over {} (fn taking `state: {}`, not returning it, defined in "
          "{}.nova) -- reducers, other modules, and non-{} params excluded".format(
              n_faces, TARGET_TYPE, TARGET_TYPE, TARGET_MOD, TARGET_TYPE))
    print("reachable leaves of {}: {}".format(TARGET_TYPE, len(R)))
    print()

    under = classify_leaves(types, R)
    by_field = Counter(under.values())
    print("leaves under >=1 collection: {}/{} ({:.0f}%)".format(len(under), len(R), 100.0 * len(under) / len(R)))
    for k, v in by_field.most_common():
        print("    {:20s} {}".format(k, v))
    print()

    # ---- BEFORE: crude marginal (validated against the 3 published numbers) ----
    print("=" * 78)
    print("BEFORE (no keying -- SS4(a) path wildcards: whole list<X> = read everything under it)")
    print("=" * 78)
    marg_before = {fn: len(marginal[fn]) for fn in faces}
    ranked = sorted(marg_before.items(), key=lambda kv: -kv[1])
    print("top marginal read-sets:")
    for fn, v in ranked[:8]:
        print("    {:3d}/{}  {}".format(v, len(R), fn))
    stats("marginal read-set (leaves)", list(marg_before.values()))
    for name, expect in (('prism_con_selected_project', 51), ('prism_con_stat_row', 50),
                          ('prism_con_project_list', 32)):
        got = marg_before.get(name)
        print("  sanity check vs M1_7_FALSIFIER_RESULT.md: {} marginal={} (doc: {}) {}".format(
            name, got, expect, "OK" if got == expect else "MISMATCH"))
    fo_before, npop_before = fanout(R, marginal)
    stats("invalidation fan-out (of {} faces)".format(npop_before), fo_before)
    print("    as % of face count: mean {:.1f}%  max {:.1f}%".format(
        100.0 * statistics.mean(fo_before) / npop_before, 100.0 * max(fo_before) / npop_before))
    print()

    # ---- Row-closure scan (patterns a/b) ----
    field_owner = defaultdict(set)
    for t, flds in types.items():
        for f, ft in flds:
            field_owner[f].add(t)
    rc_direct = scan_row_closures(F, field_owner)
    rc_trans = propagate_row_closures(F, rc_direct)

    # ---- Finder/wrapper resolver (pattern c) ----
    finders = find_finders(types, F)
    memo = {}
    for fn in faces:
        resolve_face(fn, F, types, finders, memo)

    print("finders detected (search-and-return-one-element by key): {}".format(
        ", ".join(sorted(finders)) or "none"))
    print()

    # ---- Pattern (b-named): a row is mapped through a NAMED helper with a typed struct param
    # (`let mk = fn(c) HELPER(c)` then `..._collect(coll, mk)`) rather than an inline `fn(v)
    # v.field` closure.  HELPER's read-set is already sitting in the GLOBAL `trans` fixed point
    # m17 built -- reused as-is, no new analysis needed for the helper itself.
    named_mapper = re.compile(r'let\s+([a-z_]\w*)\s*=\s*fn\(\s*([a-z_]\w*)\s*\)\s*([a-z_]\w*)\(\2\)')
    for fn in list(faces.keys()):
        body = F[fn][3]
        for mm in named_mapper.finditer(body):
            helper = mm.group(3)
            if helper not in F:
                continue
            htyped = F[helper][0]
            hstruct = [(pv, pt) for pv, pt in htyped if pt in types]
            if len(hstruct) != 1:
                continue
            hpv, hpt = hstruct[0]
            hR = m17.reach(types, hpt)
            hpre = trans.get((helper, hpv), set())
            hread = {x for x in hR for p in hpre if x == p or x.startswith(p + '.')}
            if hread:
                rc_trans.setdefault(fn, set()).update((hpt, f, False) for f in
                                                       {l.split('.')[0] for l in hread})

    # ---- combine into the AFTER model. Baseline is conservative: strip EVERY collection-driven
    # leaf from a face's crude marginal (keying's whole premise is that a collection touched only
    # for identity/rendering purposes stops inflating the reader that merely passes it through);
    # a leaf is only kept/replaced when one of the three rules below can name what specifically
    # still needs it.  Anything left unreduced after all three rules is therefore reported
    # honestly as "not modeled", not silently assumed fixed.
    own_after = {fn: {l for l in marginal[fn] if l not in under} for fn in faces}

    # Rule 4 (finder/wrapper slicing) -- trust resolve_face's answer WHOLESALE (not just its
    # collection-leaf portion) only when it is DEMONSTRABLY narrower than the crude collection-leaf
    # count it would replace.  A whole-object pass-through (`state.con_workspace` handed to a
    # finder) inflates BOTH the collection subtree AND con_workspace's own scalar fields via the
    # exact same prefix match, so a real fix has to drop both -- resolve_face's own Pass 2 already
    # keeps every genuine non-consumed direct read, so this is not lossy.  Otherwise this face's
    # collection leaves are left for rules 1-3, or reported unreduced.
    for fn in faces:
        info = memo.get(fn)
        if info is None:
            continue
        resolved_real = {x for x in R for p in info.real if x == p or x.startswith(p + '.')}
        resolved_collection = {l for l in resolved_real if l in under}
        crude_collection = {l for l in marginal[fn] if l in under}
        if crude_collection and len(resolved_collection) < len(crude_collection):
            own_after[fn] = resolved_real

    # Rules 1-3 (row closures, incl. the stat_row aggregate) -- driven by rc_trans, matched to
    # the SPECIFIC collection segment (anywhere in the path, not just the outermost -- milestones
    # nest two levels down under conws_projects) whose element type is the one being closed over.
    element_reads = {}
    for fn in faces:
        fields = rc_trans.get(fn, set())
        if not fields:
            continue
        owners = {o for o, f, c in fields}
        if len(owners) != 1:
            continue
        elem_type = next(iter(owners))
        target_field = None
        for path in R:
            for _, seg_field, seg_ft in collection_chain(types, TARGET_TYPE, path):
                if strip_generic(seg_ft) == elem_type:
                    target_field = seg_field
                    break
            if target_field:
                break
        if target_field is None:
            continue
        in_target = lambda l, tf=target_field: any(
            f == tf for _, f, _ in collection_chain(types, TARGET_TYPE, l))
        if fn == 'prism_con_stat_row':
            # AGGREGATE: cannot be keyed -- a sum/count over every element still needs every
            # element's relevant field.  Put back the real leaves (there is exactly one path per
            # referenced field, since these are direct, unnested struct fields) instead of an
            # outer+element split -- there is no "N" here to key over.
            wanted = {f for _, f, c in fields if not c}
            own_after[fn] |= {l for l in R if in_target(l) and l.split('.')[-1] in wanted}
            continue
        element_reads[fn] = (elem_type, fields)
        own_after[fn] = {l for l in own_after[fn] if not in_target(l)}

    # total_after: recursive union over the (acyclic) callee graph, to a fixed point -- this is
    # what makes the fix at selected_project/stat_row/project_list propagate automatically to
    # every composer above them, exactly mirroring how the CRUDE model's own transitive fixed
    # point already composes (base_faces above).
    total_after = {fn: set(own_after[fn]) for fn in faces}
    for _ in range(len(faces) + 2):
        changed = False
        for fn in faces:
            acc = set(own_after[fn])
            for c in callees[fn]:
                acc |= total_after[c]
            if acc != total_after[fn]:
                total_after[fn] = acc
                changed = True
        if not changed:
            break

    marg_after = {}
    for fn in faces:
        union = set()
        for c in callees[fn]:
            union |= total_after[c]
        marg_after[fn] = total_after[fn] - union

    print("=" * 78)
    print("AFTER (keyed sub-faces + finder slicing, modeled)")
    print("=" * 78)
    ranked_a = sorted(marg_after.items(), key=lambda kv: -len(kv[1]))
    print("top marginal read-sets (outer face only -- element faces reported below):")
    for fn, v in ranked_a[:8]:
        print("    {:3d}/{}  {}".format(len(v), len(R), fn))
    stats("marginal read-set (leaves)", [len(v) for v in marg_after.values()])
    fo_after, npop_after = fanout(R, marg_after)
    stats("invalidation fan-out (of {} faces)".format(npop_after), fo_after)
    print("    as % of face count: mean {:.1f}%  max {:.1f}%".format(
        100.0 * statistics.mean(fo_after) / npop_after, 100.0 * max(fo_after) / npop_after))
    print()

    print("named-worst-face comparison (marginal read-set, BEFORE -> AFTER outer):")
    for fn in ('prism_con_selected_project', 'prism_con_stat_row', 'prism_con_project_list'):
        b = len(marginal[fn])
        a = len(marg_after.get(fn, marginal[fn]))
        print("    {:30s} {:3d} -> {:3d}".format(fn, b, a))
    print()

    print("element faces created (row-closure fields, scoped to the ELEMENT type -- not part of "
          "the 109-leaf PrismConState tree):")
    for fn, (elem_type, fields) in sorted(element_reads.items()):
        real_fields = sorted(f for _, f, c in fields if not c)
        count_fields = sorted(f for _, f, c in fields if c)
        print("    {} -> element face over {}: {} field(s){}".format(
            fn, elem_type, len(real_fields) + len(count_fields),
            "  [{}]".format(", ".join(real_fields)) if real_fields else ""))
        if count_fields:
            print("        count-only (collection identity, not full contents): {}".format(
                ", ".join(count_fields)))
    print()

    print("faces NOT affected by keying (no collection leaves at all):")
    unaffected = [fn for fn in faces if fn not in element_reads
                  and marg_before[fn] == len(marg_after.get(fn, marginal[fn]))
                  and not any(under.get(l) for l in faces[fn])]
    print("    " + ", ".join(sorted(unaffected)))
    print()

    # ---- keyability of every element type that got its own face ----
    print("=" * 78)
    print("KEYABILITY of collections whose elements get an element face")
    print("=" * 78)
    # every struct collection element type reachable anywhere in the tree (not just the ones that
    # got an element face here -- PrismConProject/PrismConIssue are keyed LOOKUPS, not row-renders,
    # but still belong in a complete keyability picture), found by walking each leaf's FULL
    # segment chain (not just the outermost segment).
    all_collection_elem_types = set()
    for path in R:
        for _, fname, ft in collection_chain(types, TARGET_TYPE, path):
            all_collection_elem_types.add(strip_generic(ft))
    directly_keyable, positional, unkeyable = [], [], []
    for et in sorted(all_collection_elem_types):
        fnames = [f for f, _ in types.get(et, [])]
        if any(is_identity_field(f) for f in fnames):
            directly_keyable.append(et)
        else:
            positional.append(et)          # no identity field found -- see note below
    print("directly keyable (has an id/key/name/slug/code/label/title field): {}/{}".format(
        len(directly_keyable), len(all_collection_elem_types)))
    for et in directly_keyable:
        print("    {}".format(et))
    if positional:
        print("no identity field -- positional or genuinely unkeyable: {}".format(len(positional)))
        for et in positional:
            print("    {}  fields: {}".format(et, ", ".join(f for f, _ in types.get(et, []))))
    print()
    print("(design-doc corpus baseline for comparison: 62% directly keyable, remainder mostly "
          "positional -- PRISM_M3_4_REACTIVITY_DESIGN.md SS4b)")
    print()

    print("=" * 78)
    print("CRITERION -- PRISM_M3_4_REACTIVITY_DESIGN.md's final form: <=10% mean, <=25% max fan-out")
    print("=" * 78)
    mean_pct_b = 100.0 * statistics.mean(fo_before) / npop_before
    max_pct_b = 100.0 * max(fo_before) / npop_before
    mean_pct_a = 100.0 * statistics.mean(fo_after) / npop_after
    max_pct_a = 100.0 * max(fo_after) / npop_after
    print("  BEFORE: mean {:.1f}%  max {:.1f}%   {}".format(
        mean_pct_b, max_pct_b, "PASS" if mean_pct_b <= 10 and max_pct_b <= 25 else "FAIL"))
    print("  AFTER:  mean {:.1f}%  max {:.1f}%   {}".format(
        mean_pct_a, max_pct_a, "PASS" if mean_pct_a <= 10 and max_pct_a <= 25 else "FAIL"))
    print()
    print("NOTE: fan-out counts FACE DEFINITIONS invalidated, not per-element face INSTANCES -- a")
    print("      single edit to one row was already charged to only one face definition before")
    print("      keying (the compositional model already isolated that).  What keying changes is")
    print("      the COST of that one re-run (the marginal read-set size / how many rows get")
    print("      needlessly re-touched), not the fan-out count -- see the marginal read-set table")
    print("      above, and the docstring's discussion of this exact point.")


if __name__ == '__main__':
    main()
