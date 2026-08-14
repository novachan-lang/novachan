# prism/ui — component library

Not started. Fleet-delegable once `widget/` (MA.3) and `style/` (MA.4) interfaces are frozen --
`PRISM_ROADMAP.md`'s sequencing rule: "fleet work only after its interface is frozen."

| Module | Purpose |
|---|---|
| `prism_ui_grid.nova` | THE data grid (#85) -- cell edit, fill-down, resize/reorder/pin/freeze, multi-select, grouping, aggregation. ~3-5 pm; AG Grid is a ~1 MB commercial product and the single biggest component in the whole matrix |
| `prism_ui_table.nova`, `prism_ui_datepicker.nova`, `prism_ui_cascader.nova`, … | Standard component set (Ant-class surface) |
| `prism_ui_chart_*.nova` | Charts (#84) -- one implementation renders both client and server (for PDF) |
| `prism_ui_skeleton.nova` | Loading skeleton DERIVED from the face's static layout (#73) |
| `prism_ui_tour.nova` | Product tours / onboarding (#98) |
| `prism_ui_map.nova` | Maps / geospatial (#83) |
