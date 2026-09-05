# prism/a11y — accessibility

**COMPLETE — 1 module, KAT-gated.**

⛔ This table is the audit basis. The project rule is *audit by NAME, never by count*.

| Module | Purpose |
|---|---|
| `prism_a11y.nova` | Accessibility checks over a node tree — findings carry severity, rule and message |

Accessibility is not concentrated here by design. The **role is DERIVED from the widget type**
(`core/prism_node.nova`'s `prism_node_role_of`), so a role cannot disagree with the widget it
describes, and captions/labels are enforced by the widget constructors themselves rather than
checked after the fact. This module is the audit pass over what remains.
