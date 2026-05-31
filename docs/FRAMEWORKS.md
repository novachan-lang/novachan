# NOVA Frameworks Guide

NOVA ships nine first-party framework modules under `nova-compiler/test_programs/`. Each is a single `.nova` file you `import` and use directly — no package manager round-trip, no version skew. They all run in the same process: a Forge HTTP handler can call a Cortex model that pushes through a Pulse pipeline, and the whole thing compiles to one optimized function.

| Framework | Domain | Source | v0.1 demo |
|---|---|---|---|
| [Forge](#forge) | HTTP server | `forge.nova` | `demo_forge_test.nova` |
| [Cortex](#cortex) | AI inference | `cortex.nova` | `demo_cortex_serve_test.nova` |
| [Pulse](#pulse) | Data pipeline | `pulse.nova` | `demo_pulse_test.nova` |
| [Mesh](#mesh) | Parallel / distributed | `mesh.nova` | `demo_mesh_test.nova` |
| [Sentinel](#sentinel) | Security / crypto | `sentinel.nova` | `demo_sentinel_test.nova` |
| [Ops](#ops) | DevOps / deployment | `ops.nova` | `demo_ops_test.nova` |
| [Reactor](#reactor) | Games / simulation | `reactor.nova` | `demo_reactor_test.nova` |
| [Prism](#prism) | Terminal UI | `prism.nova` | `demo_prism_test.nova` |
| [Edge](#edge) | Embedded / IoT | `edge.nova` | `demo_edge_test.nova` |

The "ONE binary, nine frameworks" demo is `demo_full_stack_test.nova` — read it last for the why.

---

## Forge

A pure-NOVA HTTP/1.1 server. Built on the `tcp_*` stdlib and `spawn`.

```nova
import forge

fn route(method: string, path: string, body: string) -> string
    if method == "GET" and path == "/"
        return forge.html(200, "<h1>Hello from NOVA</h1>")
    if method == "GET" and path == "/api/time"
        return forge.json(200, "\{\"now\": \{time_ms()}\}")
    forge.text(404, "not found")

fn main()
    print("listening on http://localhost:8080")
    forge.serve(8080, route)
```

### API

| Function | Purpose |
|---|---|
| `forge.text(status, body)` | text/plain response |
| `forge.html(status, body)` | text/html response |
| `forge.json(status, body)` | application/json response |
| `forge.parse_method(req)` | "GET", "POST", ... |
| `forge.parse_path(req)` | request path |
| `forge.parse_body(req)` | request body string |
| `forge.serve(port, handler)` | infinite accept loop |
| `forge.serve_n(port, handler, n)` | serve N requests then close (for tests) |

### What's in v0.2 (proposal)

- WebSocket upgrade (`forge.ws_upgrade(handler)`)
- Header parsing helpers
- Static-file serving with `Cache-Control`

## Cortex

Tiny AI inference. Real tensor ops, real argmax classification, no Python in the loop.

```nova
import cortex

fn main()
    // Weights: 2 classes × 3 features
    let w = tensor_from_list([
        1.0, 2.0, 0.0,
        0.0, 1.0, 1.0
    ], [2, 3])

    // Input feature vector
    let x = tensor_from_list([1.0, 2.0, 3.0], [1, 3])

    let result = cortex.classify(w, x)
    print("class = {result[0]}, prob = {result[1]}")
```

### API

| Function | Purpose |
|---|---|
| `cortex.softmax(logits)` | numerically stable softmax over a list |
| `cortex.argmax(values)` | index of the maximum |
| `cortex.linear_classifier(W, x)` | logits via tensor matmul |
| `cortex.classify(W, x)` | `[class_index, top_prob]` |
| `cortex.parse_floats(csv)` | "1.0,2.0,3.0" → `list<float>` |

A real inference service composes Cortex with Forge:

```nova
import forge
import cortex

let _weights = tensor_from_list([...], [2, 3])

fn route(method, path, body)
    if method == "POST" and path == "/classify"
        let x = tensor_from_list(cortex.parse_floats(body), [1, 3])
        let r = cortex.classify(_weights, x)
        return forge.json(200, "\{\"class\": \{r[0]}\}")
    forge.text(404, "?")

fn main()
    forge.serve(8080, route)
```

### What's in v0.2

- Operator fusion (matmul → relu → add into one kernel)
- Model loading from a binary format
- Quantized inference (int8 weights)

## Pulse

CSV-style data pipelines. Filter, group, aggregate.

```nova
import pulse

fn main()
    let rows = pulse.read_csv("sales.csv")
    let big = pulse.filter_rows(rows, row => parse_float(row[2]) > 100.0)
    let groups = pulse.group_by(big, 0)         // group by column 0
    let totals = pulse.agg_sum(groups, 2)       // sum column 2 per group

    for region in keys(totals)
        print("{region}: \${totals[region]}")
```

### API

| Function | Purpose |
|---|---|
| `pulse.read_csv(path)` | `list<row>`, each row a `list<string>` |
| `pulse.filter_rows(rows, pred)` | predicate-based row filter |
| `pulse.col_as_float(rows, idx)` | column as `list<float>` |
| `pulse.sum_floats(xs)` | sum a list of floats |
| `pulse.count_rows(rows)` | row count |
| `pulse.group_by(rows, key_col)` | `dict<group_value, list<row>>` |
| `pulse.agg_sum(groups, col_idx)` | `dict<group_value, float>` |

### What's in v0.2

- Streaming reader for files > memory
- `pulse.join(left, right, on_col)` for relational joins
- Parquet output

## Mesh

Parallel compute. v0.1 ships the canonical map-then-reduce; v0.2+ adds true cross-node channels.

```nova
import mesh

fn double_int(x: int) -> int
    x + x

fn main()
    let xs = []
    let i = 1
    while i <= 50
        xs.push(i)
        i = i + 1

    let total = mesh.parallel_sum_int(xs, double_int)
    print(total)   // 2 * (1+2+...+50) = 2550
```

### API (v0.1)

| Function | Purpose |
|---|---|
| `mesh.parallel_sum_int(values, mapper)` | map then sum, in parallel |

### What's in v0.2

- `mesh.parallel_map(values, mapper)` returning a list
- `mesh.scatter_gather(node_addrs, work)` for cross-node distribution
- Real network channels (built on `node_listen` / `node_connect`)

## Sentinel

Security primitives.

```nova
import sentinel

fn main()
    print(sentinel.hash("hello"))
    // e.g. "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"

    let pw_hash = sentinel.hash_password("hunter2")
    let ok = sentinel.verify_password("hunter2", pw_hash)
    print(ok)   // true
```

### API

| Function | Purpose |
|---|---|
| `sentinel.hash(data)` | SHA-256 hex |
| `sentinel.hash_password(pw)` | password digest (v0.1: SHA-256; v0.2: Argon2id) |
| `sentinel.verify_password(pw, hash)` | constant-time compare |
| `sentinel.audit_chain_add(prev_hash, event)` | append to a tamper-evident log |
| `sentinel.audit_chain_verify(chain)` | verify integrity |

### What's in v0.2

- Argon2id password hashing
- AES-GCM encrypt/decrypt
- Ed25519 sign/verify
- Post-quantum candidates

## Ops

Codegen for deployment artifacts plus runtime health checks.

```nova
import ops

fn main()
    // Generate a Dockerfile for the binary "myapp" on port 8080
    let df = ops.dockerfile("myapp", 8080)
    write_file("Dockerfile", df)

    // Generate a CI workflow
    let yml = ops.github_workflow("nova-build", "ubuntu-latest")
    write_file(".github/workflows/build.yml", yml)

    // Health-check a running service
    let healthy = ops.healthcheck("http://localhost:8080/ready", "OK", 5, 200)
    if not healthy
        exit(1)
```

### API

| Function | Purpose |
|---|---|
| `ops.dockerfile(app, port)` | Dockerfile string |
| `ops.github_workflow(name, runs_on)` | Actions YAML |
| `ops.healthcheck(url, substr, max_tries, delay_ms)` | poll for a substring |

### What's in v0.2

- Railway / Fly.io / Render deploy scripts
- Prometheus metrics scrape format
- Kubernetes manifests

## Reactor

Game / simulation loop. Cleanly testable — no GPU needed for v0.1.

```nova
import reactor

fn shift_right(state: list) -> list
    let nxt = []
    let n = len(state)
    let i = 0
    while i < n
        let p = (i + n - 1) % n
        nxt.push(state[p])
        i = i + 1
    nxt

fn main()
    let initial = [1, 0, 0, 0, 0]
    let final = reactor.run_n_ticks(initial, shift_right, 3)
    print(final)   // [0, 0, 0, 1, 0]

    print(reactor.frame_to_str([1, 0, 1, 1, 0], 5, 1))
    // "#.##."
```

### API

| Function | Purpose |
|---|---|
| `reactor.run_n_ticks(state, update, n)` | run update n times |
| `reactor.frame_to_str(grid, w, h)` | ASCII render of a 2D grid |

### What's in v0.2

- WGPU-backed rendering via FFI
- Component-system primitives
- Input event polling
- Audio mixing

## Prism

Terminal UI. ANSI escape codes today; GUI via WGPU FFI in v0.2.

```nova
import prism

fn main()
    print(prism.clear())
    print(prism.color_fg(200, 100, 50))
    print("hello in orange")
    print(prism.reset())

    let tbl = prism.table(
        ["name", "score"],
        [["alice", "100"], ["bob", "50"]]
    )
    print(tbl)
```

### API

| Function | Purpose |
|---|---|
| `prism.clear()` | clear screen + home cursor |
| `prism.move(x, y)` | move cursor |
| `prism.color_fg(r, g, b)` | 24-bit foreground |
| `prism.color_bg(r, g, b)` | 24-bit background |
| `prism.reset()` | reset attributes |
| `prism.box(w, h)` | ASCII-art box |
| `prism.table(headers, rows)` | aligned table |

### What's in v0.2

- GPU-accelerated widget rendering
- Mouse and keyboard events
- Layout primitives (HBox, VBox, Grid)

## Edge

Embedded / cross-platform primitives.

```nova
import edge

fn main()
    print(edge.cores())                  // host CPU count
    print(edge.bit_set(0, 3))            // 8
    print(edge.bit_test(8, 3))           // 1
    print(edge.bytes_to_hex([222, 173, 190, 239]))   // "DEADBEEF"
```

### API

| Function | Purpose |
|---|---|
| `edge.cores()` | host CPU count |
| `edge.bit_set(v, bit)` | set bit |
| `edge.bit_clear(v, bit)` | clear bit |
| `edge.bit_test(v, bit)` | test bit |
| `edge.hex_byte(b)` | one byte as two-char hex |
| `edge.bytes_to_hex(bytes)` | byte list to hex string |
| `edge.byte_at(value, i)` | i-th byte of int (LSB at 0) |

### What's in v0.2

- Microcontroller backend (Cortex-M3 / RISC-V)
- GPIO and ADC primitives
- Real-time scheduler hooks
- Flash / EEPROM helpers

---

## Composing all nine in one binary

`demo_full_stack_test.nova` is the proof: every framework above used in **one** `main()`. The whole file is ~100 lines.

```
Sentinel hashes "nova-rocks"
   →
Edge encodes bytes to hex
   →
Pulse reads a CSV, groups, aggregates
   →
Cortex classifies a feature vector via tensor matmul
   →
Reactor evolves a state forward
   →
Prism renders an aligned table
   →
Mesh sums a parallel reduction
   →
Forge spawns and serves HTTP
   →
Ops health-checks Forge
```

No IPC. No serialization. No microservice mesh. One compiled binary, one optimized function, every framework. This is what NOVA's compiler advantage looks like in production.

```bash
nova run demo_full_stack_test.nova
# FULL-STACK DEMO PASSED: 9 frameworks composed in ONE NOVA binary
```
