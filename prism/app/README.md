# prism/app — the application platform (Tier 2)

Not started. Everything npm would otherwise supply for routing, forms, typed client/server wiring,
RBAC, sessions, offline sync, and shortcuts.

| Module | Purpose |
|---|---|
| `prism_route.nova` | Routing + deep-linked sheets (#89), breadcrumbs (#100), scroll restore (#69) |
| `prism_form.nova` | `form_of` + autosave / draft recovery (#87) |
| `prism_wire.nova` | Typed channel + dedup/retry/backoff (#92), versioning (#125) |
| `prism_guard.nova` | RBAC-conditional UI -- unreachable UI is a COMPILE ERROR (#90) |
| `prism_session.nova` | Silent token refresh, logout-everywhere (#91) |
| `prism_sync.nova` | Offline queue (#75), multi-tab (#74), presence (#77), conflict resolution (#76) |
| `prism_wizard.nova` | Stepper state machine, typed ADT + exhaustive match (#88) |
| `prism_shortcut.nova` | Keyboard shortcuts + command palette (#67 #99) |
| `prism_clipboard.nova` | Clipboard -- e.g. paste a range from Excel into a grid (#63) |
| `prism_download.nova` | Streaming download (#80) |
