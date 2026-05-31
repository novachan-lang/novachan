# NOVA Documentation

NOVA is a universal computing language: one syntax for systems code, web services, AI inference, distributed systems, embedded firmware, browser code, and everything in between. It compiles through LLVM to native code and runs at C-level speed.

Read the docs in this order:

1. **[Tutorial](TUTORIAL.md)** — guided walk from `Hello, world` to a deployed full-stack app
2. **[Language spec](LANGUAGE_SPEC.md)** — formal syntax + semantics
3. **[Stdlib API](STDLIB_API.md)** — every built-in function, signature, and example
4. **[FFI guide](FFI_GUIDE.md)** — calling C from NOVA
5. **[Frameworks](FRAMEWORKS.md)** — the nine first-party framework modules
6. **[Getting started](getting-started.md)** — short reference card
7. **[Reference](reference.md)** — condensed grammar + builtin tables
8. **[Examples](examples.md)** — runnable samples

The compiler source is [`nova-compiler/test_programs/nova_compiler.nova`](../nova-compiler/test_programs/nova_compiler.nova) — NOVA is self-hosted, so the implementation IS a NOVA program you can read.

## The pitch in 60 seconds

```nova
import forge
import cortex

let _weights = tensor_from_list([1.0, 2.0, 0.0,   0.0, 1.0, 1.0], [2, 3])

fn route(method, path, body)
    if method == "POST" and path == "/classify"
        let x = tensor_from_list(cortex.parse_floats(body), [1, 3])
        let r = cortex.classify(_weights, x)
        return forge.json(200, "\{\"class\": \{r[0]}\}")
    forge.text(404, "?")

fn main()
    forge.serve(8080, route)
```

That's a complete AI inference web service. Compile it: `nova build app.nova`. Run the resulting native binary. No Python, no Docker (unless you want one), no microservice mesh. One executable, one compilation unit.

The same language, the same syntax, the same compiler runs on a Cortex-M3 with 64 KB of RAM, on a WebAssembly module in your browser, on a GPU kernel through OpenCL, and on a thousand-node Erlang-style distributed system.

## What's working today

- ✅ Self-hosted compiler (`gen3_test.exe`, ~12k lines of NOVA)
- ✅ 113-test regression suite green on Windows
- ✅ Track 8 RC elision shipping by default (~20% perf gain)
- ✅ Nine first-party frameworks (Forge, Cortex, Pulse, Mesh, Sentinel, Ops, Reactor, Prism, Edge)
- ✅ FFI to libc, sqlite, openssl, pthread
- ✅ Cloud deploy verified (Railway, AI inference service over HTTPS)
- ✅ WebAssembly + GPU + UDP + datetime + regex stdlib
- ✅ Trait system with bounds + exhaustive match + generics
- ✅ Result/Option with `?` operator
- ✅ LSP / debugger / coverage / profiler tooling
- ✅ Package manager (`nova.toml`, `nova_packages/`)

## What's not working yet

- ⏳ Cross-platform CI (Linux, macOS) — verified locally only
- ⏳ W5b auto-drop default-on (opt-in via `NOVA_T8_DROP=1` while soundness is completed)
- ⏳ Framework v0.2 (WebSocket, model loading, real wgpu, etc.)
- ⏳ Microcontroller backend
- ⏳ Continuous benchmark tracking across commits

See [`NOVA_DESIGN/`](../NOVA_DESIGN/) for the design history.
