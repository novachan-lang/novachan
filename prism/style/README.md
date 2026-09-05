# prism/style — typed style values (PRISM_SPEC.md §11)

**COMPLETE — 7 modules, all KAT-gated.** No cascade, no specificity, no global namespace -- a `look` is a typed value
resolvable to a flat constant at compile time.

| Module | Purpose |
|---|---|
| `prism_color.nova` | Colour values + contrast computation |
| `prism_theme.nova` | Theme composition over `look`/`palette` |
| `prism_tokens.nova` | Design tokens (see `dev/prism_tokens_dev.nova` — the basename collision is deliberate; `prism/**` flattens into one namespace) |
| `prism_look.nova` | Typed style values, merge order (later wins on conflict) |
| `prism_palette.nova` | Tokens, light/dark, 9 presets, multi-tenant (feature #101) |
| `prism_motion.nova` | Animation curves; reduced-motion respected BY DEFAULT (features #70 #102) |
| `prism_print.nova` | Print layout (feature #115) |

`look`/`palette` land here first as NOVA values (dicts/structs); the `look`/`palette` *keyword*
syntax is compiler sugar added later (Phase 3, per `PRISM_ROADMAP.md`).
