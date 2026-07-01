# HTTP/2 (Sprint S7 / P4 flagship) — build plan

> Linked from FORGE_BUILD_PLAN.md (the hub). HTTP/2 is XL and greenfield (verified 2026-07-02: no hpack/
> http2/alpn anywhere; ALPN is MISSING from the TLS runtime). Strategy per the plan: build the pure-logic
> pieces FIRST (HPACK + frame codec) — they are leaf modules with byte-exact RFC vectors, land regardless of
> the ALPN-TLS blocker, and unlock gRPC's wire format. ALPN-over-TLS is the one runtime dependency and the
> likely stall point; if it stalls, HPACK + frames + fixtures still ship as the foundation.

## Build order (each = its own gated unit, ledger updated in its commit)

### D2.2 — HPACK (RFC 7541) — leaf `forge_hpack.nova`, `_fdb_one` (byte-exact, no sockets)  ← START HERE
- **§5.1 prefix integer** encode/decode (N-bit prefix + continuation). Test: RFC C.1 (10 @5-bit, 1337 @5-bit, 42 @8-bit).
- **§5.2 Huffman** encode/decode (the 257-symbol static Huffman table). Test: RFC C.4 (byte-exact Huffman-coded literals).
- **Static table** (61 entries) + **dynamic table** (FIFO eviction by size, §4). 
- **Header block** encode/decode: indexed (§6.1), literal-incremental (§6.2.1), literal-no-index, literal-never-index.
- Exit gate: RFC 7541 **C.2 / C.3 / C.4** request sequences decode byte-exact (incl dynamic-table state across C.3/C.6). All `_fdb_one` (deterministic).

### D2.3 — frame codec — leaf `forge_h2.nova`, `_fdb_one`
- Connection preface `PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n`. Frame header (9 bytes: length24/type8/flags8/R1+streamid31).
- Frames: DATA(0) / HEADERS(1) / SETTINGS(4) / WINDOW_UPDATE(8) / RST_STREAM(3) / PING(6) / GOAWAY(7). Encode+decode round-trip each. Reject oversize / bad stream-id parity.
- Exit gate: every frame round-trips; a hand-built SETTINGS+HEADERS+DATA byte stream parses to the right frames.

### D2.4 — flow control — leaf, `_fdb_one`
- Connection + per-stream send/recv windows; WINDOW_UPDATE credit; refuse to send past the window. Deterministic unit test.

### D2.1 — ALPN-capable TLS listener — RUNTIME (`nova_rt_tls_alpn_selected`), full `nova_ci`
- Add ALPN offer/select to the TLS accept path (SChannel/OpenSSL). Server selects "h2" when offered. This is the hard part / stall risk. Full gate (runtime change).

### D2.5 — serve_h2 multiplex — forge.nova serve path, `-SkipReconverge`
- On an ALPN-"h2" connection: read preface+SETTINGS, then a stream loop on the netpoller — decode HEADERS(+CONTINUATION) via HPACK into a Request, route through the EXISTING router, encode the Response back as HEADERS+DATA. Two concurrent streams independent.
- Exit gate: two multiplexed streams served independently over one TLS conn through the existing handler path.

## Gate scope (per [[fast-effective-testing]])
HPACK / frame codec / flow control = leaf modules -> `_fdb_one` per unit. ALPN = runtime -> full `nova_ci`.
serve_h2 = serve-path -> `-SkipReconverge`. One section-end full gate when D2.x all land.

## Honest scope
Full h2-over-TLS-with-multiplex may not fully land (ALPN-TLS is the XL risk). HPACK + frame codec + flow
control WILL land as solid, tested foundations and are exactly gRPC's wire substrate (S8).
