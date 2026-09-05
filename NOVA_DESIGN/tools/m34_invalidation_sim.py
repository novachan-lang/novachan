#!/usr/bin/env python3
"""M3.4 s8 step 3 -- INVALIDATION SIMULATOR: what does one realistic user action ACTUALLY COST?

WHAT THIS IS.  A SIMULATION over a STATIC MODEL, not a running system.  There is no compiled M3.4
pass and no runtime -- this tool reuses the existing static analysers (`m17_readset.py`'s read-set
fixed point, `m34_keyed_subfaces.py`'s keyed-sub-face model) to compute, for a handful of realistic
user actions on `prism/app/prism_app_console.nova`'s `PrismConState`/26 faces, how much WORK three
different reactivity designs would charge to handle that action:

  (A) NO REACTIVITY  -- every face re-runs, always (this is what PRISM does TODAY).
  (B) LEAF-GRANULAR, UNKEYED  -- a face re-runs iff its (crude, whole-collection) read-set
      intersects the changeset; a collection-iterating face therefore re-runs over ALL N elements
      even when only one changed.
  (C) KEYED SUB-FACES  -- a collection-iterating face re-runs for the CHANGED ELEMENT ONLY
      (PRISM_M3_4_REACTIVITY_DESIGN.md SS4b); everything else is unaffected.

WORK, not face count.  A collection-iterating face (renders/folds over every element) is charged N
units (N = element count, PARAMETERISED at 10 / 100 / 1000).  A scalar face is charged 1 unit.  This
is `M1_7_FALSIFIER_RESULT.md`'s SSCRITERION #4 in its final form: "invalidated WORK per state change,
where a collection-iterating face costs O(rows)" -- applied to concrete actions instead of averaged
over the whole population.

METHOD (four steps, matching the milestone brief)

  1. INPUTS, reused by import (NOT reimplemented):
       `m17_readset.py`   -- load_types/load_fns/reach/transitive_reads (the crude read-set fixed
                              point: every function's transitive dependency on PrismConState).
       `m34_keyed_subfaces.py` -- base_faces (the 26-face population + crude marginal read-sets,
                              validated here again against its own published sanity checks),
                              classify_leaves (which leaves sit under which collection),
                              scan_row_closures/propagate_row_closures/find_finders/resolve_face
                              (the keyed-sub-face AFTER model -- per-face narrowed dependencies).
       `m34_key_inference.py` -- corpus_text/collection_fields/keyability_by_elem_type (the Rule 1
                              behavioural-lookup / Rule 3 nominal-identity analysis that decides,
                              per action's `elem_type`, whether ANY key is derivable at all -- see
                              `derive_unkeyable` below). Keyability is DERIVED from this every run;
                              it is never a hardcoded per-action fact in this file.
     This tool's OWN code is the six action definitions and the cost/invalidation arithmetic over
     those reused facts -- it does not re-derive read-sets, finders, or keyability from scratch.

  2. SIX REALISTIC ACTIONS, chosen from what the console app can actually represent (SSACTIONS
     below): editing one comment's text; adding a new issue to a project (a STRUCTURAL `+key`
     insert, PRISM_M3_4 SS3); dismissing one notification (a STRUCTURAL `-key` delete -- the
     corpus's actual mechanism for "acknowledge a notification"; there is no per-notice "read"
     flag, only `prism_nt_dismiss(q, index)`, so this is the honest analogue, not "mark read");
     changing the issue-table sort column; a session-token refresh; toggling one preference.

  3. For each action, a CHANGESET is modeled as either a set of changed LEAF FIELD NAMES (resolved
     to their unique dotted path in the 133-leaf tree -- field names are project-wide unique by
     this file's own tagging discipline, asserted below, not assumed) or a STRUCTURAL delta naming
     the affected collection field.

  4. Per action, per model (A/B/C): which of the 26 faces are invalidated, and at what cost.  A
     face's cost type (scalar=1 / row-render=N / aggregate=N, HAND-CLASSIFIED below against the
     actual source of all 26 functions, listed with a one-line justification each) is fixed
     regardless of action; WHETHER it is invalidated, and whether keying reduces its cost from N to
     1, depends on the action and the model.

POPULATION, stated up front (the trap that has hit this analysis eight times: wrong population,
unit, or denominator).  The 26-face population is `m34_keyed_subfaces.base_faces`'s own population
(fn taking `state: PrismConState`, not returning it, defined in `prism_app_console.nova`) -- NOT
reducers, NOT plumbing, NOT root-composer-inflated read-set-as-%%.  Every one of the 26 is
individually classified below (15 scalar + 8 row-render + 3 aggregate = 26; asserted, not assumed).
The three ROOT COMPOSERS (`prism_con_console`/`_html`/`_ansi`) are IN the population, classified
scalar (their own marginal work is dispatch+serialize; the N-sized work they compose is ALREADY
charged separately to whichever row/aggregate face does it) -- counting them AS row-render too would
double the very thing SS10.10 of the reactivity design warned about (root composers inflate every
metric that does not exclude them).  This does create a KNOWN, DISCLOSED double-count of its own
(see LIMITS): `prism_con_issue_table` calls `prism_con_issue_table_data` internally, so if BOTH are
invalidated, this model charges N twice for what a real runtime would compute once.  That is the
same accounting the corpus's own fan-out CRITERION already uses (SS4 of M1_7_FALSIFIER_RESULT.md:
"fan-out counts face DEFINITIONS... not per-element face INSTANCES") -- adopted here for
consistency with the published methodology, not invented for this tool, and named as a limit below.

CURRENT-CORPUS DRIFT, VERIFIED, NOT ASSUMED.  `M1_7_FALSIFIER_RESULT.md`/PRISM_M3_4's own SS10.8-10.10
already document that MORE collection fields were typed corpus-wide after "109 leaves" was written.
Running `m34_keyed_subfaces.py` TODAY reports **133 reachable leaves**, not 109 -- because
`con_router`/`con_shortcuts`/`con_sync`/`con_invite_form` (reused app/-tier sub-state) now ALSO have
typed `list<X>` collection fields the analyser can recurse into.  This tool reports the LIVE number
(re-derived every run) and calls out the drift explicitly rather than quoting the stale 109 -- the
three PUBLISHED sanity numbers this analysis depends on (selected_project=51, stat_row marginal=50,
project_list=32) are UNCHANGED by the drift (verified below) because none of the newly-typed fields
sit under `PrismConWorkspace`.

ONE KNOWN GAP IN THE REUSED TOOL, HAND-VERIFIED AND EXPLICITLY CORRECTED (not silently trusted).
`scan_row_closures` (in `m34_keyed_subfaces.py`) detects ONLY inline `fn(v) EXPR` closures passed as
call arguments.  `prism_notice.prism_nt_pending_ack` -- the function `prism_con_unread_notification_
count` delegates to -- folds over `nq_items` with a PLAIN `for it in q.nq_items: if it.nn_auto==0:
...` loop, which this pattern does not match.  Consequence: the reused AFTER-model would (wrongly,
if trusted blindly) report `prism_con_unread_notification_count`/`prism_con_notification_badge` as
having NO real dependency on notification content after keying -- i.e. it would show these two faces
as NOT INVALIDATED AT ALL by a notification change, which is false REGARDLESS of keyability: this is
a DETECTION gap (the read is real but syntactically invisible to `scan_row_closures`), not a
keyability question, and the two must not be conflated (an earlier version of this file did, by
tying the override to a hardcoded `unkeyable=True` flag -- see below). This tool overrides the
generic mechanism for exactly THREE faces -- `prism_con_unread_notification_count` and
`prism_con_notification_badge` (which call it), PLUS `prism_con_stat_row` (which also directly
reports an "Unread" stat off the same function, verified at `prism_app_console.nova`'s
`prism_con_stat_row` line `s4 = ... prism_con_unread_notification_count(state) ...`) -- on any
action touching `PrismNotice` (see `_NOTIFICATION_AGGREGATE_OVERRIDE`), verified by reading
`prism_notice.nova` directly rather than trusted from the generic read-set intersection.  This
override forces INVALIDATION only; it never forces the cost REDUCTION keying would give a
row-render face, because these three are `agg`-classified (see COST_TYPE) and are excluded from
`element_reads`/`row_hits` by construction (`build_models`'s `prism_con_stat_row` special case) --
SS4b keyed sub-faces (all Model C implements) narrows a ROW-render face's dependency to the ONE
changed element; it does not implement incremental aggregation (SS9's group-class IVM), so an
aggregate that folds over all N elements pays N when invalidated REGARDLESS of whether its
collection is keyable.  This is the ONLY hand override left in this tool; everything else is the
generic mechanical test, INCLUDING KEYABILITY ITSELF -- which used to be hand-asserted here as
"PrismNotice has no identity field, so keying cannot help this collection AT ALL, in EITHER
direction" and is now DERIVED, per action, from `m34_key_inference.py`'s live Rule 1 (behavioural
lookup) / Rule 3 (nominal identity) analysis, imported not reimplemented (see `derive_unkeyable` /
`_assert_manual_exceptions_still_hold` below).  THAT premise was STALE: `prism_notice.nova` now
declares `nn_id` (a caller-supplied stable identity, see its own header) -- added precisely because
this analysis identified the missing identity field as the reason keying bought nothing here --
and `m34_key_inference.py` confirms it live: `PrismNoticeQueue.nq_items (PrismNotice)` now falls in
its "both rules fire" bucket (11 -> 12).  POSITIONAL keying is STILL UNSOUND for this collection --
`prism_nt_dismiss` deletes by index and eviction (`prism_nt_post`) can evict ANY auto-dismissing
slot, not just the ends, so an index is never a stable identity (the classic React index-key trap)
-- but ID-BASED keying (via `nn_id`) is now sound, which is a DIFFERENT claim from "no valid key
exists at all", and this file no longer conflates them.  The run's own "DETECTION PATHS" section
prints, for each of the three override faces, whether ANY generic detector (inline closure /
propagation / named-mapper / finder-slicing) ever attributes a `PrismNotice`-owned field to it --
confirming the DETECTION gap is real (0/3), independent of the keyability question, which each
action now reports separately under "keyability (derived...)".

LIMITS -- read before trusting a number in this file's output.
  * Static and syntactic throughout, same limits as `m17_readset.py`/`m34_keyed_subfaces.py`: a read
    behind a dict/list index or an opaque combinator is invisible to the underlying analysis.
  * ONE SYMBOLIC N per action, not one N per real collection.  A real app's projects/issues/
    comments/members/audit-entries/milestones/integrations/notifications differ in count; this tool
    charges every "collection-iterating" face invalidated by an action the SAME N, because the
    question being asked is asymptotic (O(1) vs O(N) in collection size), not "what are today's
    demo-data counts" (3 projects, <=3 issues each, <=2 comments -- too small to say anything about
    scaling). Flagged, not hidden.
  * Definition-level double counting (see POPULATION above): `issue_table` calls `issue_table_data`;
    both, if invalidated, are separately charged N. Inherited from the corpus's own published
    fan-out accounting, not introduced here.
  * SELECTION SCOPING is asserted per action, not derived.  Whether an edited comment belongs to the
    CURRENTLY SELECTED issue (so `prism_con_comment_thread` would actually render it) is a runtime
    fact this static tool cannot know; each action states its scoping assumption explicitly
    (`in_scope=...`) and the arithmetic is conditioned on it, exactly as a real keyed runtime would
    conditio n a re-render on the actual key comparison.  This is the one place a human judgment
    call substitutes for derivable static fact; it is stated, not hidden.
  * `prism_con_issue_table_data`'s SORT-COLUMN dependency is genuinely global (SS9.4 of the design
    doc: "predicate reads other state ... full rescan, and it is rare") -- keyed sub-faces do NOT
    help this action, correctly, and this tool reports that as O(N) in ALL THREE models rather than
    forcing a false win for C.
  * RECONSTRUCTOR SLICING (`m17_slicing.py`), the OTHER M3.4 technique, is NOT modeled here.  Two
    actions (session-token refresh, preference toggle) touch non-collection nested structs where
    slicing -- not keying -- is the applicable fix; this tool's Model C equals Model B for those
    actions and says so, rather than silently improving a number keying cannot actually produce.

Run:  python NOVA_DESIGN/tools/m34_invalidation_sim.py [prism_root]
"""
import io, os, re, sys, importlib.util
from collections import defaultdict

_HERE = os.path.dirname(os.path.abspath(__file__))


def _load(modname):
    spec = importlib.util.spec_from_file_location(modname, os.path.join(_HERE, modname + '.py'))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


m17 = _load('m17_readset')
m34ks = _load('m34_keyed_subfaces')          # reused for base_faces/classify_leaves/scan_row_
                                              # closures/propagate_row_closures/find_finders/
                                              # resolve_face/collection_chain/strip_generic/
                                              # field_type/is_identity_field -- NOT reimplemented.
m34ki = _load('m34_key_inference')           # reused for corpus_text/collection_fields/
                                              # keyability_by_elem_type (Rule 1 / Rule 3 keyability
                                              # analysis) -- NOT reimplemented.

ROOT = sys.argv[1] if len(sys.argv) > 1 else 'prism'
TARGET_TYPE = 'PrismConState'
TARGET_MOD = 'prism_app_console'
NS = (10, 100, 1000)


# =================================================================================================
# STEP 1 -- load the corpus and reproduce the two reused models (crude BEFORE, keyed AFTER).  Every
# function call below is into m17/m34ks; the composition sequence mirrors m34_keyed_subfaces.main()
# exactly (same steps, same order) because that composition is not exposed as a single return-a-
# result function there -- calling the primitives in the SAME sequence is reuse, not reimplementation
# of the underlying analysis (scan_row_closures/propagate_row_closures/find_finders/resolve_face are
# the actual hard-won logic, and none of it is re-derived here).

def build_models(root):
    types = m17.load_types(root)
    F = m17.load_fns(root)
    direct, trans = m17.transitive_reads(F)
    R = m17.reach(types, TARGET_TYPE)

    faces, callees, marginal = m34ks.base_faces(types, F, direct, trans, R)
    under = m34ks.classify_leaves(types, R)

    # LIVE keyability (Rule 1 behavioural lookup / Rule 3 nominal identity), reused by import from
    # m34_key_inference.py -- NOT hardcoded per action. See `derive_unkeyable` below for how each
    # action's elem_type is looked up in this map.
    alltext = "\n".join(t for _, t in m34ki.corpus_text(root))
    keyability = m34ki.keyability_by_elem_type(types, alltext)

    field_owner = defaultdict(set)
    for t, flds in types.items():
        for f, ft in flds:
            field_owner[f].add(t)
    rc_direct = m34ks.scan_row_closures(F, field_owner)
    rc_trans = m34ks.propagate_row_closures(F, rc_direct)
    # DETECTION-PATH INSTRUMENTATION (snapshot BEFORE the named-mapper loop mutates rc_trans further,
    # and BEFORE the hand-override below adds anything): this is what makes the coverage gap the
    # module docstring describes VISIBLE in the report, rather than only discoverable by reading
    # source. Restricted to the 26-face population throughout -- a hit on a non-face helper function
    # is not something this tool's output claims credit for.
    detect_inline_direct = {fn for fn in faces if rc_direct.get(fn)}
    detect_inline_propagated = {fn for fn in faces if rc_trans.get(fn)}
    finders = m34ks.find_finders(types, F)
    memo = {}
    for fn in faces:
        m34ks.resolve_face(fn, F, types, finders, memo)

    named_mapper = re.compile(r'let\s+([a-z_]\w*)\s*=\s*fn\(\s*([a-z_]\w*)\s*\)\s*([a-z_]\w*)\(\2\)')
    detect_named_mapper = set()
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
                detect_named_mapper.add(fn)

    own_after = {fn: {l for l in marginal[fn] if l not in under} for fn in faces}
    detect_finder_narrowed = set()
    for fn in faces:
        info = memo.get(fn)
        if info is None:
            continue
        resolved_real = {x for x in R for p in info.real if x == p or x.startswith(p + '.')}
        resolved_collection = {l for l in resolved_real if l in under}
        crude_collection = {l for l in marginal[fn] if l in under}
        if crude_collection and len(resolved_collection) < len(crude_collection):
            own_after[fn] = resolved_real
            detect_finder_narrowed.add(fn)

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
            for _, seg_field, seg_ft in m34ks.collection_chain(types, TARGET_TYPE, path):
                if m34ks.strip_generic(seg_ft) == elem_type:
                    target_field = seg_field
                    break
            if target_field:
                break
        if target_field is None:
            continue
        in_target = lambda l, tf=target_field: any(
            f == tf for _, f, _ in m34ks.collection_chain(types, TARGET_TYPE, l))
        if fn == 'prism_con_stat_row':
            wanted = {f for _, f, c in fields if not c}
            own_after[fn] |= {l for l in R if in_target(l) and l.split('.')[-1] in wanted}
            continue
        element_reads[fn] = (elem_type, fields, target_field)
        own_after[fn] = {l for l in own_after[fn] if not in_target(l)}

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

    return dict(types=types, F=F, R=R, faces=faces, callees=callees, marginal=marginal,
                under=under, total_after=total_after, element_reads=element_reads, finders=finders,
                memo=memo, rc_trans=rc_trans, detect_inline_direct=detect_inline_direct,
                detect_inline_propagated=detect_inline_propagated,
                detect_named_mapper=detect_named_mapper,
                detect_finder_narrowed=detect_finder_narrowed,
                keyability=keyability)


def leaves_under_field(types, R, target_field):
    """Every R-leaf whose FULL collection chain (not just the outermost segment) passes through
    `target_field` -- e.g. leaves_under_field(..., 'coniss_comments') is exactly the 8 PrismConComment
    leaves, distinct from the 32 PrismConProject leaves 'conws_projects' alone would give."""
    return {p for p in R if any(f == target_field for _, f, _ in
                                 m34ks.collection_chain(types, TARGET_TYPE, p))}


def leaf_for_field(R, field_name):
    """The R-leaf(s) ending in this exact field name. Field names are project-wide unique by this
    file's own tagging discipline (its header explicitly checks every new prefix against the whole
    corpus) -- asserted, not assumed: a field name resolving to 0 or >1 leaves is a hard error, since
    a silent multi-leaf match would corrupt every changeset built from it."""
    hits = [p for p in R if p == field_name or p.endswith('.' + field_name)]
    assert len(hits) == 1, "field '{}' resolved to {} leaves (expected exactly 1): {}".format(
        field_name, len(hits), hits)
    return hits[0]


# =================================================================================================
# STEP 2 -- the 26-face population, HAND-CLASSIFIED by cost type against the actual source (not
# inferred from the tool's read-set numbers, which measure DEPENDENCY size, a different question
# from OUTPUT/fold size). scalar=1 unit. row=N units (renders/depends on N elements it iterates
# itself). agg=N units (folds a value over N elements; group-class per SS9.6, so IN PRINCIPLE
# incrementally maintainable, but that is a SEPARATE mechanism -- SS9's incremental view maintenance
# -- not part of SS4(b) keyed sub-faces, which is all Model C implements here).

COST_TYPE = {
    'prism_con_selected_project':          ('scalar', None),
    'prism_con_selected_issue':            ('scalar', None),
    'prism_con_session_active':            ('scalar', None),
    'prism_con_unread_notification_count': ('agg',    'notifications'),
    'prism_con_issue_table_data':          ('row',    'issues in selected project'),
    'prism_con_header':                    ('scalar', None),
    'prism_con_breadcrumb':                ('scalar', None),
    'prism_con_notification_badge':        ('agg',    'notifications'),
    'prism_con_stat_row':                  ('agg',    'issues workspace-wide'),
    'prism_con_project_list':              ('row',    'projects'),
    'prism_con_issue_table':               ('row',    'issues in selected project'),
    'prism_con_issue_detail':              ('scalar', None),
    'prism_con_comment_thread':            ('row',    'comments on selected issue'),
    'prism_con_members_view':              ('row',    'members'),
    'prism_con_audit_log_view':            ('row',    'audit entries'),
    'prism_con_project_milestones_view':   ('row',    'milestones of selected project'),
    'prism_con_integrations_view':         ('row',    'integrations'),
    'prism_con_command_palette':           ('scalar', None),
    'prism_con_preferences_pane':          ('scalar', None),
    'prism_con_invite_form_view':          ('scalar', None),
    'prism_con_new_project_wizard_view':   ('scalar', None),
    'prism_con_presence_view':             ('scalar', None),
    'prism_con_pane':                      ('scalar', None),   # dispatch only; the active branch is
    'prism_con_console':                   ('scalar', None),   # ALSO one of the 26 and separately
    'prism_con_console_html':              ('scalar', None),   # charged -- see POPULATION note on
    'prism_con_console_ansi':              ('scalar', None),   # why composers are not double-typed.
}


def cost_of(fn, n):
    kind = COST_TYPE[fn][0]
    return n if kind in ('row', 'agg') else 1


def model_a_total(faces, n):
    return sum(cost_of(fn, n) for fn in faces)


# =================================================================================================
# STEP 3 -- six actions. Each is `(name, description, changeset)`.  A changeset is either
#   ('value', {field_names}, in_scope)         -- a leaf value changed
#   ('struct', target_field, elem_type, in_scope)  -- an element was inserted/removed under
#                                                      target_field (PRISM_M3_4 SS3's `+key`/`-key`)
# `in_scope` states, per SS"LIMITS" above, whether the changed/added/removed element belongs to
# whatever parent the SCOPED faces are currently displaying (selected project / selected issue) --
# a fact this static tool cannot derive, so it is asserted as part of the scenario, exactly as a
# real keyed runtime would compare an actual key at actual runtime.

ACTIONS = [
    dict(name='edit_comment_text',
         desc="Edit the body text of one comment on the issue currently open (issue = the "
              "SELECTED issue; PRISM_M3_4 SS4b's own worked example).",
         kind='value', fields={'concmt_body'}, elem_type='PrismConComment',
         collection_field='coniss_comments', in_scope=True),
    dict(name='add_new_issue',
         desc="Create a new issue inside the currently SELECTED project (status=open, so it also "
              "moves the open-issue aggregate; PRISM_M3_4 SS3's structural `+key` delta).",
         kind='struct', op='insert', elem_type='PrismConIssue', collection_field='conprj_issues',
         in_scope=True, moves_aggregate=True),
    dict(name='dismiss_notification',
         desc="Dismiss (acknowledge) one notification -- the corpus's ACTUAL mechanism "
              "(`prism_nt_dismiss`, a structural delete by index; there is no per-notice 'read' "
              "flag). POSITIONAL keying is UNSOUND here regardless of anything else (the index is "
              "not a stable identity -- eviction, `prism_nt_post`, can remove any auto-dismissing "
              "slot, the classic index-key trap) -- but `PrismNotice` now declares `nn_id` (a "
              "caller-supplied stable identity; see prism_notice.nova's header), so ID-based "
              "keying is a separate question and may now be sound. Whether it actually is, and "
              "whether that helps THIS action, is DERIVED below (not asserted) from the live "
              "Rule 1/Rule 3 analysis in m34_key_inference.py -- see 'keyability (derived)'.",
         kind='struct', op='delete', elem_type='PrismNotice', collection_field='nq_items',
         in_scope=True),
    dict(name='change_sort_column',
         desc="Change the issue table's sort field (a viewer-slice SETTING, not an element's "
              "data) -- a global predicate change; SS9.4 says this is a full rescan regardless of "
              "keying, and this action exists to show that plainly.",
         kind='value', fields={'consrt_field'}, elem_type=None, collection_field=None,
         in_scope=True, global_predicate=True),
    dict(name='session_token_refresh',
         desc="Refresh the session's access token (new secret, new expiry, advanced clock). "
              "con_session is a plain nested STRUCT, not a collection -- SS4b keying does not "
              "apply at all; the applicable M3.4 technique is RECONSTRUCTOR SLICING "
              "(m17_slicing.py), not modeled here, so Model C == Model B for this action.",
         kind='value', fields={'ss_access_val', 'ss_expires_at', 'ss_seen_ms'}, elem_type=None,
         collection_field=None, in_scope=True, not_a_collection=True),
    dict(name='toggle_preference',
         desc="Toggle 'reduce motion' in Preferences. Also not a collection -- and unlike the "
              "session case, `prism_con_preferences_pane` reads con_prefs with NO delegation "
              "indirection at all, so the crude model is ALREADY tight here: nothing to fix.",
         kind='value', fields={'conpref_reduce_motion'}, elem_type=None, collection_field=None,
         in_scope=True, not_a_collection=True),
]

# The one hand-verified correction (see module docstring): PrismNotice's aggregate faces are not
# caught by scan_row_closures (a plain `for` loop inside a library helper, not an `fn(v)` closure),
# so the generic AFTER model would under-report them as having no real dependency left. Verified by
# reading prism_notice.nova directly. Applied to any action touching PrismNotice. NOTE: this is a
# DETECTION-gap override (these faces ARE invalidated; the generic model just can't see the read),
# not a keyability override -- it forces invalidation (inv_b/inv_c) unconditionally, but it does NOT
# force row_hits.pop() because keyability demands it; it does so because these three are
# `agg`-classified and agg faces are excluded from `element_reads`/`row_hits` by construction
# already (see build_models' `prism_con_stat_row` special case) -- the pop() below is a defensive
# no-op stating that invariant explicitly, not a second keyability judgment.
_NOTIFICATION_AGGREGATE_OVERRIDE = {
    'prism_con_unread_notification_count', 'prism_con_notification_badge', 'prism_con_stat_row'}


# Manual exceptions to the LIVE keyability derivation (see `derive_unkeyable`), for a collection
# whose element type this tool asserts is unkeyable EVEN IF m34_key_inference.py's Rule 1/Rule 3
# scan finds a candidate field -- because that candidate is a false positive (e.g. an `==`
# comparison against a shared boolean/status flag used as a FILTER predicate, not a genuine
# per-element lookup key), so "some rule fired" does not actually mean "a stable identity exists".
# Empty today: PrismNotice's own known false positive (Rule 1 fires on `nn_auto`, a boolean flag
# compared in `prism_nt_pending_ack`'s `if it.nn_auto==0` filter -- see m34_key_inference.py's
# DISAGREEMENTS section) does NOT need an entry here, because this tool only asks the boolean
# question "is ANY key derivable for this elem_type", never "which specific field is THE key" --
# and Rule 3 independently and correctly finds `nn_id`, so the bottom-line `keyable` bool is right
# regardless of the Rule-1 false positive. An entry would only be needed for an elem_type where
# EVERY rule that fires is a false positive (keyable=True with no real identity behind it at all).
#
# Each entry MUST be asserted against the live analysis by `_assert_manual_exceptions_still_hold`,
# called once in `main()` before any action is simulated: a stale entry (one the live tool no
# longer agrees is unkeyable) raises loudly instead of silently reproducing exactly the bug this
# fix addresses -- an "unkeyable" premise that quietly outlived the fact it was describing.
_MANUAL_UNKEYABLE_EXCEPTIONS = {
    # 'ElemType': "why this elem type is unkeyable despite whatever the live tool currently reports",
}


def _assert_manual_exceptions_still_hold(keyability):
    for et, reason in _MANUAL_UNKEYABLE_EXCEPTIONS.items():
        info = keyability.get(et, {'lookup': set(), 'nominal': set(), 'keyable': False})
        assert not info['keyable'], (
            "STALE MANUAL EXCEPTION: '{}' is hardcoded unkeyable here ({!r}) but the LIVE "
            "m34_key_inference analysis now reports it keyable (lookup={}, nominal={}) -- the "
            "premise this exception documents no longer holds; remove it, do not trust it."
        ).format(et, reason, sorted(info['lookup']), sorted(info['nominal']))


def derive_unkeyable(elem_type, keyability):
    """Whether keying can help a face touching this element type AT ALL -- derived, per run, from
    the LIVE Rule 1 (behavioural lookup) / Rule 3 (nominal identity) analysis in
    m34_key_inference.py, not a hardcoded per-action fact. `elem_type=None` (a non-collection /
    global-predicate action) is never 'unkeyable' in this sense -- those actions are excluded from
    keying by their own `not_a_collection`/`global_predicate` flags instead (see module LIMITS)."""
    if elem_type is None:
        return False
    if elem_type in _MANUAL_UNKEYABLE_EXCEPTIONS:
        return True
    info = keyability.get(elem_type)
    return not (info and info['keyable'])


# =================================================================================================
# STEP 4 -- per action, per model: which faces invalidate, and at what cost.

def invalidated_value(model_reads, changed_paths):
    return {fn for fn, reads in model_reads.items() if reads & changed_paths}


def invalidated_struct_crude(types, R, model_reads, target_field):
    hit = leaves_under_field(types, R, target_field)
    return {fn for fn, reads in model_reads.items() if reads & hit}


def simulate(models, action):
    types, R = models['types'], models['R']
    faces, total_after, element_reads = models['faces'], models['total_after'], models['element_reads']
    unkeyable = derive_unkeyable(action.get('elem_type'), models['keyability'])

    if action['kind'] == 'value':
        changed_paths = {leaf_for_field(R, f) for f in action['fields']}
        inv_b = invalidated_value(faces, changed_paths)
        inv_c_generic = invalidated_value(total_after, changed_paths)
    else:
        tf = action['collection_field']
        inv_b = invalidated_struct_crude(types, R, faces, tf)
        inv_c_generic = invalidated_struct_crude(types, R, total_after, tf)

    # Model C: start from the generic (leaf-path) result, then apply keyed-sub-face treatment for
    # any row-render face whose OWN target collection is the one this action touches (cost drops to
    # 1 rather than the row's N -- an insert/edit/delete localizes to one row) PROVIDED it is in
    # scope; a row-render face whose target collection this action does NOT touch is simply absent
    # from inv_c_generic already (the generic total_after test correctly excludes it, since keying
    # strips exactly the collection leaves that face does not own).
    row_hits = {}     # fn -> cost override (1 unit, keyed) for this action
    inv_c = set(inv_c_generic)
    for fn, (elem_type, fields, target_field) in element_reads.items():
        touches = (action.get('elem_type') == elem_type or
                   (action['kind'] == 'value' and target_field == action.get('collection_field')) or
                   (action['kind'] == 'struct' and target_field == action['collection_field']))
        if not touches:
            continue
        if action['kind'] == 'value' and not (action['fields'] & {f for _, f, _ in fields} |
                                               (action['fields'] & {f for f, _, _ in fields})):
            # value-change action naming a field this element face does not even read: no effect
            field_names = {f for _, f, c in fields} if fields and isinstance(next(iter(fields)), tuple) else set()
            if not (action['fields'] & field_names):
                continue
        if not action.get('in_scope', True):
            continue
        inv_b.add(fn)          # crude model ALSO fires here (over-approximation includes this face)
        inv_c.add(fn)
        if unkeyable:
            continue            # no reduction possible -- stays at full N (handled by cost table)
        row_hits[fn] = 1

    # the one hand-verified correction (module docstring + ACTIONS comment): a DETECTION-gap fix,
    # NOT a keyability judgment -- fires on any action touching PrismNotice regardless of the
    # `unkeyable` verdict above, because the dependency these 3 faces have on notification content
    # is real either way; whether keying could reduce their COST is a separate question, answered
    # by the pop() below purely as a defensive statement of the agg/row_hits invariant (see comment
    # at _NOTIFICATION_AGGREGATE_OVERRIDE's definition), not by consulting `unkeyable`.
    if action.get('elem_type') == 'PrismNotice':
        for fn in _NOTIFICATION_AGGREGATE_OVERRIDE:
            inv_b.add(fn)
            inv_c.add(fn)
            row_hits.pop(fn, None)   # agg faces are never row-reduced -- see comment above

    # global-predicate actions (sort column): keying cannot help a row-render face whose OWN
    # invalidation trigger is the predicate/order itself, not one element's data -- force full N.
    if action.get('global_predicate'):
        for fn in list(row_hits):
            row_hits.pop(fn)

    return inv_b, inv_c, row_hits, unkeyable


def cost(faces_inv, n, row_hits=None):
    row_hits = row_hits or {}
    total = 0
    for fn in faces_inv:
        total += row_hits.get(fn, cost_of(fn, n))
    return total


# =================================================================================================
# reporting

def hr(c='='):
    print(c * 96)


def main():
    models = build_models(ROOT)
    faces = models['faces']
    n_faces = len(faces)

    _assert_manual_exceptions_still_hold(models['keyability'])

    hr()
    print("POPULATION")
    hr()
    print("faces measured: {}  (expected 26, from m34_keyed_subfaces.base_faces)".format(n_faces))
    assert n_faces == 26, "population drifted from the published 26 -- verify before trusting anything below"
    classified = sum(1 for fn in faces if fn in COST_TYPE)
    print("cost-classified: {}/{} (expected {}/{} -- an unclassified face is a silent zero-cost bug, not a pass)".format(
        classified, n_faces, n_faces, n_faces))
    assert classified == n_faces, "every face in the population must have an explicit cost classification"
    by_kind = defaultdict(list)
    for fn in faces:
        by_kind[COST_TYPE[fn][0]].append(fn)
    for kind in ('scalar', 'row', 'agg'):
        print("  {:6s} ({:2d}): {}".format(kind, len(by_kind[kind]), ", ".join(sorted(by_kind[kind]))))
    print()
    print("reachable leaves of {}: {} (current corpus; the design doc's own 109 is STALE -- see "
          "module docstring on corpus drift)".format(TARGET_TYPE, len(models['R'])))

    print()
    hr()
    print("DETECTION PATHS -- how many of the 26 faces each collection/aggregate-dependency detector")
    print("found (so a coverage gap is VISIBLE in the output, not just discoverable by reading source)")
    hr()
    di = models['detect_inline_direct']
    dp = models['detect_inline_propagated']
    dn = models['detect_named_mapper']
    df = models['detect_finder_narrowed']
    er = models['element_reads']
    print("  (a)/(b) inline `fn(v) EXPR` row closures, direct (m34ks.scan_row_closures):      {:2d}/{}  {}".format(
        len(di), n_faces, sorted(di)))
    print("       same, after call-graph propagation (m34ks.propagate_row_closures):          {:2d}/{}  {}".format(
        len(dp), n_faces, sorted(dp)))
    print("  named-mapper indirection `let mk = fn(v) HELPER(v)` (this file's own addition):   {:2d}/{}  {}".format(
        len(dn), n_faces, sorted(dn)))
    print("  (c) finder/wrapper slicing narrowed a face's real dependency (m34ks.resolve_face): {:2d}/{}  {}".format(
        len(df), n_faces, sorted(df)))
    print("  TOTAL row/element faces created (rules (a)-(c) combined, what Model C's per-row")
    print("       reduction is actually built from):                                          {:2d}/{}  {}".format(
        len(er), n_faces, sorted(er)))
    print("  HAND-OVERRIDE for the loop-form gap (`prism_nt_pending_ack`'s plain `for it in")
    print("       q.nq_items: if it.nn_auto==0` -- invisible to scan_row_closures, verified by")
    print("       reading prism_notice.nova directly, see module docstring):                   {:2d}/{}  {}".format(
        len(_NOTIFICATION_AGGREGATE_OVERRIDE), n_faces, sorted(_NOTIFICATION_AGGREGATE_OVERRIDE)))
    # Precise check, not just "found something at all": prism_con_stat_row DOES appear in the
    # generic propagated set above (dp) -- but for an UNRELATED reason (it also calls
    # prism_con_open_issue_count/urgent_issue_count, whose OWN inline `.filter(fn(i) i.coniss_...)`
    # closures are genuinely caught by scan_row_closures and correctly propagate to stat_row). That
    # is a real, separate detection of the ISSUE aggregate, not evidence the NOTIFICATION dependency
    # was found. So the honest check is per-OWNER-TYPE: does any generic path attribute a PrismNotice
    # field to this face at all, before the override is applied?
    notif_seen_generically = {fn for fn in _NOTIFICATION_AGGREGATE_OVERRIDE
                               if any(o == 'PrismNotice' for o, f, c in models['rc_trans'].get(fn, ()))}
    print("  ==> of these {} faces, the generic detectors attribute a PrismNotice-owned field to: "
          "{}/{}  {}".format(len(_NOTIFICATION_AGGREGATE_OVERRIDE), len(notif_seen_generically),
                              len(_NOTIFICATION_AGGREGATE_OVERRIDE), sorted(notif_seen_generically) or "(none)"))
    print("      (prism_con_stat_row DOES appear in the propagated set above, but only via its OWN")
    print("       separate issue-count closures -- that is a real, unrelated detection, not partial")
    print("       coverage of the notification gap.) Confirms the loop-form gap is real for all 3.")

    print()
    hr()
    print("SANITY CHECK -- published crude marginal read-sets must still hold before trusting anything below")
    hr()
    ok_all = True
    for name, expect in (('prism_con_selected_project', 51), ('prism_con_stat_row', 50),
                          ('prism_con_project_list', 32)):
        got = len(models['marginal'].get(name, set()))
        ok = got == expect
        ok_all = ok_all and ok
        print("  {:30s} marginal={:3d}  (published: {})  {}".format(name, got, expect, "OK" if ok else "MISMATCH"))
    assert ok_all, "a published sanity number no longer matches -- STOP, do not trust downstream numbers"

    print()
    hr()
    print("MODEL A (no reactivity) -- constant, independent of the action:")
    hr()
    for n in NS:
        print("  N={:5d}:  cost = {}   (15 scalar x1  +  11 row/agg x N)".format(n, model_a_total(faces, n)))

    attempted = len(ACTIONS)
    completed = 0
    all_rows = []
    for action in ACTIONS:
        print()
        hr('-')
        print("ACTION: {}".format(action['name']))
        print("  {}".format(action['desc']))
        hr('-')
        inv_b, inv_c, row_hits, unkeyable = simulate(models, action)
        et = action.get('elem_type')
        if et is None:
            print("  keyability (derived, m34_key_inference.py): n/a -- action has no single "
                  "collection element type (scalar/global-predicate/non-collection action)")
        else:
            info = models['keyability'].get(et, {'lookup': set(), 'nominal': set(), 'keyable': False})
            forced = " [MANUAL EXCEPTION, asserted against live analysis]" if et in _MANUAL_UNKEYABLE_EXCEPTIONS else ""
            rules = []
            if info['lookup']:
                rules.append("Rule1 lookup={}".format(sorted(info['lookup'])))
            if info['nominal']:
                rules.append("Rule3 nominal={}".format(sorted(info['nominal'])))
            if not rules:
                rules.append("no rule fires")
            print("  keyability (derived, m34_key_inference.py, LIVE not hardcoded): elem_type={} "
                  "-> {}{}  ({})".format(et, "UNKEYABLE" if unkeyable else "KEYABLE", forced,
                                         "; ".join(rules)))
        print("  invalidated under B (crude, unkeyed): {}/{}  -- {}".format(
            len(inv_b), n_faces, ", ".join(sorted(inv_b)) or "(none)"))
        print("  invalidated under C (keyed sub-faces): {}/{}  -- {}".format(
            len(inv_c), n_faces, ", ".join(sorted(inv_c)) or "(none)"))
        if row_hits:
            print("  reduced to O(1) by keying: {}".format(", ".join(sorted(row_hits))))
        else:
            print("  reduced to O(1) by keying: (none -- keying does not help this action; see LIMITS)")
        print()
        print("  {:>10s}  {:>12s}  {:>12s}  {:>12s}  {:>10s}".format("N", "A", "B", "C", "B/C ratio"))
        row = {'name': action['name']}
        for n in NS:
            a = model_a_total(faces, n)
            b = cost(inv_b, n)
            c = cost(inv_c, n, row_hits)
            ratio = (float(b) / c) if c else float('inf')
            print("  {:>10d}  {:>12d}  {:>12d}  {:>12d}  {:>9.1f}x".format(n, a, b, c, ratio))
            row[n] = (a, b, c, ratio)
        all_rows.append(row)
        b_scales = len(inv_b & {fn for fn in inv_b if COST_TYPE[fn][0] in ('row', 'agg')}
                       - set(row_hits)) > 0
        c_scales = len({fn for fn in inv_c if COST_TYPE[fn][0] in ('row', 'agg') and fn not in row_hits}) > 0
        print()
        print("  Model B is {} in N.   Model C is {} in N.".format(
            "O(N)" if b_scales else "O(1)", "O(N)" if c_scales else "O(1)"))
        agg_hits = {fn for fn in inv_c if COST_TYPE[fn][0] == 'agg'}
        if agg_hits:
            print("  AGGREGATES dominate C's cost here regardless of keying: {} (SS9 -- group-class "
                  "IVM, a SEPARATE mechanism from SS4b keying, is not modeled)".format(", ".join(sorted(agg_hits))))
        completed += 1

    print()
    hr()
    print("SUMMARY -- B/C ratio at N=1000, all six actions (attempted {}, completed {}; a mismatch "
          "here means an action silently produced no result, not that all passed)".format(attempted, completed))
    hr()
    assert attempted == completed == len(ACTIONS), "attempted/completed/expected must all agree"
    for row in all_rows:
        a, b, c, ratio = row[1000]
        print("  {:24s}  A={:6d}  B={:6d}  C={:6d}  B/C={}".format(
            row['name'], a, b, c, ("{:.1f}x".format(ratio) if ratio != float('inf') else "inf (C=0)")))

    print()
    print("exit 0")


if __name__ == '__main__':
    main()
    sys.exit(0)
