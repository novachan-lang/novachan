# prism/backend/gpu — native desktop / mobile / embedded

Not started (Phase 6 in `PRISM_ROADMAP.md`). There is no DOM on native targets, so this backend is
required there, and it is where pixel parity across Windows/macOS/Linux genuinely pays for itself.

| Module | Purpose |
|---|---|
| `prism_gpu_api.nova` | WebGPU/Vulkan/Metal/D3D12 abstraction |
| `prism_paint.nova` | Display list, batching, damage tracking |
| `prism_atlas.nova` | Alpha-only glyph atlas, bin packing, 16 subpixel variants |
| `prism_text_shape.nova` | Platform shaping (DirectWrite/CoreText/HarfBuzz) |
| `prism_gpu_a11y.nova` | UIA / NSAccessibility / AT-SPI |
