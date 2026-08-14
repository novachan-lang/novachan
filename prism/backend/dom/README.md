# prism/backend/dom — the web backend

Not started (Phase 3+ in `PRISM_ROADMAP.md`; MA.5's HTML renderer lives at
`prism/render/prism_render_html.nova` instead, since it needs no closures/WASM and is usable by Forge
today -- this folder is the *live, interactive* DOM backend, which does).

| Module | Purpose |
|---|---|
| `prism_dom_emit.nova` | Vocabulary -> real DOM elements (never a `div role="button"` shim -- a real `<button>`) |
| `prism_dom_patch.nova` | The update path |
| `prism_dom_a11y.nova` | Derived semantics -- role/label/state from the widget type, not developer annotation |
| `prism_dom_csp.nova` | CSP / security headers, no inline script (feature #113) |
| `prism_dom_host.js` | Thin host shim -- the ONLY JS in the whole project |
