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
| `prism_tokens.nova` | Design-token export (#108) |
