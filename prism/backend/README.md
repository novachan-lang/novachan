# prism/backend — the swappable part

Everything above this folder (`core/`, `widget/`, `style/`, `layout/`, `text/`) is backend-agnostic.
Per the 2026-08-14 falsification (`PRISM_STATUS.md`): the **web** target emits real DOM elements (no
canvas, no own layout, no own text stack -- F1-F6 killed the case for an own-renderer web backend);
**native** targets (desktop/mobile/embedded) get an owned GPU renderer, which is required there
anyway since there is no DOM to defer to.

| Folder | Status | Purpose |
|---|---|---|
| `ansi/` | **BUILT (MA.1)** | Terminal backend -- relocated from the v0.1 `nova-compiler/test_programs/prism.nova`. A genuinely real fourth target for CLI/TUI tools |
| `dom/` | planned (MA.5 covers only the HTML-render subset via `render/prism_render_html.nova`; the live interactive DOM backend is Phase 3+) | Web -- vocabulary -> real DOM elements, update path, derived a11y, CSP |
| `gpu/` | planned, native-only (Phase 6) | WebGPU/Vulkan/Metal/D3D12 abstraction, paint, glyph atlas, platform text shaping, platform a11y |

`prism_backend.nova` (the interface both `dom/` and `gpu/` implement) is not yet written -- it is
designed once both backends have enough real surface to generalize from, not before.
