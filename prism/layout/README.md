# prism/layout — box constraints

Single-pass box-constraint layout (PRISM_SPEC.md §7): constraints descend, sizes ascend, parent
positions child. O(n) per frame; layout thrash is structurally impossible because no child can read
its own final position during layout. This is the **GPU backend's** layout engine -- the DOM backend
defers to CSS instead (PRISM_STATUS.md's post-falsification architecture).

| Module | Purpose |
|---|---|
| `prism_constraint.nova` | The constraint graph representation |
| `prism_solve.nova` | The single-pass solver |
| `prism_rtl.nova` | RTL mirroring as a layout flag, not a CSS rewrite (feature #121) |

Not started. Depends on the GPU backend milestones (Phase 2 / P6 in `PRISM_ROADMAP.md`), which are
compiler/runtime-adjacent and out of Phase A's pure-library scope.
