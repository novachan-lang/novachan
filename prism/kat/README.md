# prism/kat — known-answer tests

Project gate culture: every stdlib/library module ships a known-answer test proving correctness
against an authoritative vector (see `.claude/rules/quality-standards.md` "MANDATORY GATES").

Naming convention: `_kat_prism_<module>.nova`, one per `prism/**/prism_<module>.nova`.

| KAT | Status | Proves |
|---|---|---|
| `_kat_prism_node.nova` | **BUILT (MA.2)** | `prism/core/prism_node.nova` -- multi-kind tree construction, child order, keyed identity round-trip, depth/count bound enforcement, RTTI introspection |

Wiring every KAT here into the regression manifest (the 1121-test harness) is **MA.8**, a later
milestone -- not done yet. Each KAT is directly runnable standalone in the meantime (see its own
header for the exact compile/link/run commands).
