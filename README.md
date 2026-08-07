# NOVA — One Language. Build Anything.

NOVA is a programming language designed to unify all computing domains — systems, AI, distributed, web, cloud, edge, and embedded — into one coherent language and runtime.

**Website:** [novachan.org](https://novachan.org)

## Why NOVA?

- **Faster than C** — LLVM AOT compilation, zero-cost abstractions, C-parity benchmarks proven
- **Safer than Rust** — process-isolated memory model, no lifetime annotations, no undefined behavior
- **Simpler than Python** — zero type annotations for 95%+ of code, one-word error handling, reads like English
- **Concurrent like Go** — lightweight green threads, typed channels, M:N scheduling, automatic parallelism
- **Fault-tolerant like Erlang** — process isolation, crash recovery, distributed channels

## Quick Start

```nova
fn main()
    print("Hello from NOVA!")
```

```nova
import forge

fn main()
    let app = forge.app()
    forge.get(app, "/hello", fn(req)
        forge.json(200, {"message": "Hello, world!"})
    )
    forge.serve(app, 8080)
```

## Features

- **Self-hosted compiler** — the NOVA compiler is written in NOVA (~30k lines), compiles itself to a byte-identical fixpoint
- **Three primitives** — Values, Processes, Channels: the entire computational model
- **Forge framework** — full-stack web framework built in, HTTP/1.1 + HTTP/2 + WebSocket + TLS + ORM
- **Type inference** — Hindley-Milner based, generics, ADTs, pattern matching, Result types
- **Concurrency** — spawn, channels, select, async I/O, work-stealing scheduler
- **Multi-target** — native (Windows/Linux/macOS), WASM, cross-compilation
- **Built-in tooling** — LSP server, formatter, REPL, debugger, package manager, test runner

## Building

```bash
# Compile a NOVA program
nova run myapp.nova

# Create a new Forge project
nova new myapi --api

# Start the LSP server (for IDE integration)
nova lsp
```

## Architecture

NOVA's computational universe is built on three primitives:

| Primitive | What it represents | Examples |
|-----------|-------------------|----------|
| **Values** | ALL data | integers, structs, tensors, messages, JSON |
| **Processes** | ALL execution | threads, actors, GPU kernels, distributed nodes |
| **Channels** | ALL communication | function calls, network streams, HTTP, events |

The compiler infers types, picks allocation strategy, derives capabilities, and optimizes — all without annotations. The developer writes simple code; the compiler does the hard work.

## Standard Library

570+ modules across 20+ categories: crypto, networking, data structures, AI/ML, text processing, media codecs, databases, and more. Every module is KAT-gated (known-answer tested against authoritative vectors).

## License

Copyright 2026 Mangesh Mane. Licensed under the [Apache License 2.0](LICENSE).

NOVA is a trademark of Mangesh Mane. See [NOTICE](NOTICE) for details.

## Author

**Mangesh Mane** — Creator and Lead Developer
- Email: mangeshmaneCT@gmail.com
- Website: [novachan.org](https://novachan.org)

---

*NOVA: The last programming language you'll ever need.*
