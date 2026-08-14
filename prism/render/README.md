# prism/render — non-screen render targets

The SAME `PrismNode` tree produces screen pixels, server HTML, an email, a PDF, and a PNG (spec
§9.10) -- this is why duplicate "bar chart" implementations (one in the browser, one via a
server-side PDF library) collapse into a single implementation here.

| Module | Status | Purpose |
|---|---|---|
| `prism_render_html.nova` | **planned for MA.2 (this milestone's node type is its input) / built in MA.5** | Server-side HTML: SSR / SSG / email templates (#116). No closures, no WASM, no compiler change -- runs native today via Forge |
| `prism_render_pdf.nova` | planned | -> PDF (#117) |
| `prism_render_sheet.nova` | planned | -> Excel (#117) |
| `prism_render_image.nova` | planned | -> PNG, deterministic (#118) |
