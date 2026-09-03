# prism/dev — developer tooling (MANDATORY per spec §12.7, not optional)

Not started except as noted. The reactivity research (`PRISM_STATUS.md` Q1) concluded that shipping
zero-annotation reactivity with no diagnostics and no escape hatch is a product failure on its own --
every prior system that shipped inferred reactivity also shipped these.

| Module | Purpose |
|---|---|
| `prism_explain.nova` | `nova prism explain <face>` -- read-sets + why a node's invalidation escalated |
| `prism_inspect.nova` | Tree / state inspector, repaint flashing |
| `prism_catalog.nova` | Storybook equivalent -- GENERATED from the widget library, no `.stories` files (#103). **Planned for MA.7** |
| `prism_test.nova` | Testing API -- query by DERIVED role/label (#47) |
| `prism_visual.nova` | Pixel-exact visual regression against deterministic renders (#104) |
| `prism_audit_a11y.nova` | Audits only the 4 residual manual a11y annotations (#105) |
| `prism_size.nova` | Per-route bundle budget (#106) |
| `prism_tokens_dev.nova` | Design-token export (#108) |

> **Naming note.** This layer's token exporter is `prism_tokens_dev.nova`, NOT `prism_tokens.nova`.
> `prism/**/*.nova` is FLATTENED into `$NOVA_HOME/lib`, so a second `prism_tokens.nova` would collide
> with `style/prism_tokens.nova` and one would silently win. Module basenames are a GLOBAL namespace
> in this project, not a per-folder one.
