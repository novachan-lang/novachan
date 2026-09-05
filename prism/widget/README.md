# prism/widget — the primitives (PRISM_SPEC.md Part III)

**COMPLETE (MA.3)** — the **22 primitives** (axiom A7's closed vocabulary) as plain functions returning a `PrismNode`
(`prism/core/prism_node.nova`) -- no `face`/`->` syntax yet, exactly how `forge_html`'s
`div()`/`p()`/`el()` are plain functions returning strings.

| Module | Purpose |
|---|---|
| `prism_arrange.nova` | `stack` `band` `layer` `mesh` `flow` `pane` `gap` (spec §7) |
| `prism_content.nova` | `label` `art` `glyph` `draw` (spec §8) |
| `prism_interact.nova` | `press` `entry` `pick` `flag` `range` `link` (spec §9) |
| `prism_structure.nova` | `each` `grid` `sheet` `hint` `tabs` (spec §10) |
| `prism_media.nova` | Video / audio playback (feature #82) |
| `prism_notice.nova` | Toasts / snackbars / notification centre (feature #71) |

Each primitive's `PrismNode` shape is a smart constructor over `prism_node_new`/`prism_node_leaf`/
`prism_node_branch`/`prism_node_keyed` -- this is the layer where each kind's attrs get validated
and typed, since `prism_node.nova` itself deliberately keeps `attrs` a generic dict.

> **Naming notes.** The §9 interaction primitives ship as `prism_interact.nova` (the README
> originally called this `prism_input.nova`). And `prism_node.nova` is NOT in this folder — the
> node type lives in `core/`, beside the kind vocabulary and the derived-role table that both
> depend on it; listing it here implied a second copy.
