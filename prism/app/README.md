# prism/app — the application platform (Tier 2)

**COMPLETE — 14 modules, all KAT-gated.** Everything npm would otherwise supply for routing, forms,
typed client/server wiring, RBAC, sessions, offline sync, and shortcuts.

⛔ **This table is the audit basis.** The project rule is *audit by NAME, never by count* — a count
matched once while `text/` was 3/4 by content. Every module below must exist in this directory and
have a `_kat_<name>.nova` in `prism/kat/`.

## The planned ten

| Module | Purpose |
|---|---|
| `prism_route.nova` | Routing + deep-linked sheets (#89), breadcrumbs (#100), scroll restore (#69) |
| `prism_form.nova` | `form_of` + autosave / draft recovery (#87) |
| `prism_wire.nova` | Typed channel + dedup/retry/backoff (#92), versioning (#125) |
| `prism_guard.nova` | RBAC-conditional UI — unreachable UI is a COMPILE ERROR (#90) |
| `prism_session.nova` | Silent token refresh, logout-everywhere (#91) |
| `prism_sync.nova` | Offline queue (#75), multi-tab (#74), presence (#77), conflict resolution (#76) |
| `prism_wizard.nova` | Stepper state machine, typed ADT + exhaustive match (#88) |
| `prism_shortcut.nova` | Keyboard shortcuts + command palette (#67 #99) |
| `prism_clipboard.nova` | Clipboard — e.g. paste a range from Excel into a grid (#63) |
| `prism_download.nova` | Streaming download (#80) |

## Also delivered here (not in the original plan)

| Module | Purpose |
|---|---|
| `prism_app_console.nova` | ★ The **operations console** — a workspace → projects → issues → comments application. Built for milestone **M1.7**: its `PrismConState` is a genuinely nested **109-leaf, depth-6** state tree, which is what allowed Bet 1 to be measured at application scale rather than on flat library types. See `NOVA_DESIGN/M1_7_FALSIFIER_RESULT.md` §SCALE |
| `prism_app_dashboard.nova` | A dashboard app over a flat 16-leaf `PrismAppState` — the earlier, simpler demo |
| `prism_app_docs.nova` | Generated component documentation |
| `prism_forge.nova` | Forge integration — serving PRISM's HTML renderer from a NOVA server |

## Note on collection typing

Collection fields whose elements are a declared struct are typed **`list<T>`**, not bare `list`.
This is not cosmetic: `M3.4`'s key inference, keyed sub-face invalidation, and aggregate deltas all
require a knowable element type, and 85% of the library was invisible to that analysis until the
14 typeable fields were annotated. See `NOVA_DESIGN/PRISM_M3_4_REACTIVITY_DESIGN.md` §10.8.
