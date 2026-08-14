# prism/core — runtime spine (backend-agnostic)

The types and values every backend and every widget builds on. Nothing here may know about HTML,
ANSI escapes, or a GPU surface.

| Module | Status | Purpose |
|---|---|---|
| `prism_node.nova` | **BUILT (MA.2)** | The node-tree value type: kind, attrs, children, keyed identity, resource bounds |
| `prism_face.nova` | planned | Lifecycle, process wiring, supervision/restart (feature #12) |
| `prism_key.nova` | planned | Runtime keyed-identity map for collection rows (spec §12.6) |
| `prism_event.nova` | planned | Event model, default-event resolution, provenance tags (spec §15.7) |
| `prism_caps.nova` | planned | Capability values -- unforgeable host-power grants (spec §15.2, features #112 #124) |
| `prism_journal.nova` | planned | The message log -> undo/redo, replay, audit (features #61 #114) |
| `prism_secret.nova` | planned | `Secret<T>` -- no serializer, so PII redaction is structural (spec §15.3, feature #123) |

See `NOVA_DESIGN/PRISM_STATUS.md` "REPOSITORY STRUCTURE" for the authoritative map.
