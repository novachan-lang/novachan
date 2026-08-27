// prism_canvas_host.js -- the JS half of Prism's Canvas2D backend (WEAPON PARITY 5.6).
//
// prism_render_canvas.nova walks a PrismNode tree and emits a flat, self-describing i64
// draw-command stream (see that file's header for the encoding and why it was chosen over a
// string protocol or raw pointer sharing). This file is the ONLY thing on the JS side that needs
// to understand that wire format. It has three independent jobs, used by three different callers:
//
//   1. decode(words, sink)  -- the pure decoder. Walks the record stream and calls one method on
//      `sink` per draw command (fillRect/strokeRect/line/text/clipPush/clipPop/hit). `sink` is
//      unopinionated about WHERE those calls go -- canvas2DSink() below adapts it to a real
//      CanvasRenderingContext2D for the browser; recordingSink() (also below) adapts it to a plain
//      array of description strings for a headless test, in the EXACT text shape
//      prism_canvas_dump() uses on the NOVA side ("fill_rect x,y,w,h,rgba", etc.) so a gate can
//      assert Node's decoded output against the SAME expected lines the native KAT already proved
//      by hand-derived arithmetic -- one expected-value vocabulary, not two that could drift apart.
//   2. verify(words) -- reimplements prism_canvas_verify()'s three framing checks (header
//      word_count, per-record argc, END-record DJB2 checksum) independently in JS. This is
//      deliberately NOT "trust that NOVA already checked it": a buffer can reach the browser over
//      ANY channel (postMessage, IndexedDB, a future network fetch), each with its own way to
//      truncate or reorder bytes that has nothing to do with NOVA's own correctness.
//   3. pullWordsFromWasmExports(exports) -- reads the word list out of a running wasm instance's
//      exports by calling canvas_len()/canvas_word(i) repeatedly (see _wasm_canvas_probe.nova and
//      prism_render_canvas.nova's header for why: the alternative, parsing NovaList's raw
//      {data,size,cap,elem_kind} struct directly out of linear memory, means depending on the
//      RC-header offset and the S4 typed-array elem_kind tagging state -- both runtime internals,
//      NEITHER part of prism_render_canvas.nova's public contract, and either can change size or
//      shape independently of this file with no compile error to catch it here. One call per word
//      is not "zero crossings" the way a raw memory read would be, but for a UI-sized command
//      stream (a screen's worth of draw commands, not a video frame) the cost is not the risk that
//      matters; silently decoding a stale struct layout is.
//
// WIRE FORMAT (must stay byte-for-byte in sync with prism_render_canvas.nova -- see its header):
//   header (6 words): magic, version, word_count, cmd_count, surface_w, surface_h
//   records: [op, argc, arg...]   (argc is the count of ARGS, not including op/argc themselves)
//   TEXT is the one variable-length record: args = [x,y,rgba,size_px,align,weight,nbytes,...bytes]
//     where each byte is inlined as ONE FULL WORD (see prism_render_canvas.nova's header on why:
//     it keeps every word in the buffer unambiguously an integer, so the untagged-value heuristic
//     some other NOVA/wasm boundaries need never has to run on this stream at all).
//   trailer: an END record (op=0, argc=1, arg=DJB2 checksum of every word before it)

'use strict';

const OP_END = 0, OP_FILL_RECT = 1, OP_STROKE_RECT = 2, OP_LINE = 3, OP_TEXT = 4,
      OP_CLIP_PUSH = 5, OP_CLIP_POP = 6, OP_HIT = 7;
const HEADER_WORDS = 6;
const MAGIC = 1347552049;   // "PRC1" -- see prism_canvas_magic()
const VERSION = 1;
const CHECKSUM_MOD = 2147483647; // 2^31 - 1, matches prism_canvas_checksum's mask exactly

const OP_NAME = { 0: 'end', 1: 'fill_rect', 2: 'stroke_rect', 3: 'line', 4: 'text', 5: 'clip_push', 6: 'clip_pop', 7: 'hit' };

// ── checksum: the exact DJB2-masked algorithm prism_canvas_checksum() uses ─────────────────────
// Every word in this stream fits comfortably under 2^32 (the largest is a packed RGBA colour,
// 0xFFFFFFFF = 4294967295), and h stays under CHECKSUM_MOD (2^31-1) after every step, so the
// running product h*33+word never exceeds ~7.5e10 -- far inside JS's exact-integer range (2^53).
// Plain Number arithmetic is exact here; BigInt would only be needed for the wasm i64 ABI values
// THEMSELVES (handled in pullWordsFromWasmExports), not for this checksum.
function checksum(words, upto) {
    let h = 5381;
    for (let i = 0; i < upto && i < words.length; i++) {
        h = (h * 33 + words[i]) % CHECKSUM_MOD;
    }
    return h;
}

// ── verify: independent re-check of the framing prism_canvas_verify() already enforces on the
// NOVA side. Returns { ok: true, cmdCount } or { ok: false, error }. Order matches the NOVA side:
// magic -> version -> declared length -> checksum -> per-record walk (+ clip balance) -- so a
// failure names the SAME layer of corruption a NOVA-side failure would name, which matters when a
// human is diffing a bug report against the KAT's own error strings.
function verify(words) {
    if (words.length < HEADER_WORDS + 3) return { ok: false, error: `buffer of ${words.length} words is shorter than the minimum framed buffer` };
    if (words[0] !== MAGIC) return { ok: false, error: `bad magic ${words[0]} (expected ${MAGIC}) -- this is not a Prism canvas buffer` };
    if (words[1] !== VERSION) return { ok: false, error: `unsupported stream version ${words[1]} (this host speaks ${VERSION})` };
    if (words[2] !== words.length) return { ok: false, error: `header declares ${words[2]} words but the buffer holds ${words.length} -- TRUNCATED or padded` };
    const expect = checksum(words, words.length - 1);
    if (words[words.length - 1] !== expect) return { ok: false, error: `checksum ${words[words.length - 1]} != computed ${expect} -- the buffer is corrupt or reordered` };

    let i = HEADER_WORDS, n = 0, depth = 0, sawEnd = false;
    while (i < words.length) {
        if (i + 1 >= words.length) return { ok: false, error: `record at word ${i} has an opcode but no argc -- TRUNCATED` };
        const op = words[i], argc = words[i + 1];
        if (argc < 0) return { ok: false, error: `record at word ${i} has negative argc ${argc}` };
        if (i + 2 + argc > words.length) return { ok: false, error: `record at word ${i} (op ${OP_NAME[op] ?? op}) declares ${argc} args but only ${words.length - i - 2} remain -- TRUNCATED` };
        if (op === OP_CLIP_PUSH) depth++;
        if (op === OP_CLIP_POP) { depth--; if (depth < 0) return { ok: false, error: `clip_pop at word ${i} with no matching clip_push` }; }
        if (op === OP_END) {
            sawEnd = true;
            i += 2 + argc;
            if (i !== words.length) return { ok: false, error: `${words.length - i} words follow the END record -- trailing garbage` };
            break;
        }
        i += 2 + argc;
        n++;
    }
    if (!sawEnd) return { ok: false, error: 'no END record -- the buffer is TRUNCATED (a short read is indistinguishable from a short frame without this check)' };
    if (depth !== 0) return { ok: false, error: `${depth} clip_push record(s) never popped` };
    return { ok: true, cmdCount: n };
}

// ── decode: walk the (already-verified) stream, dispatching one sink call per record ───────────
// Text bytes are inlined as one WORD per BYTE (see the encoding note in prism_render_canvas.nova),
// and those bytes are the raw UTF-8 encoding of the original string, so reassembling them through
// TextDecoder is the correct inverse of how the NOVA side built them (ord() per byte on the way
// out; this is byte values back to a JS string on the way in).
function decode(words, sink) {
    const v = verify(words);
    if (!v.ok) throw new Error('prism_canvas decode: ' + v.error);
    let i = HEADER_WORDS;
    while (i < words.length) {
        const op = words[i], argc = words[i + 1];
        const args = words.slice(i + 2, i + 2 + argc);
        switch (op) {
            case OP_END: return v.cmdCount;
            case OP_FILL_RECT: sink.fillRect(args[0], args[1], args[2], args[3], args[4]); break;
            case OP_STROKE_RECT: sink.strokeRect(args[0], args[1], args[2], args[3], args[4], args[5]); break;
            case OP_LINE: sink.line(args[0], args[1], args[2], args[3], args[4], args[5]); break;
            case OP_TEXT: {
                const nbytes = args[6];
                const bytes = new Uint8Array(args.slice(7, 7 + nbytes));
                const text = new TextDecoder('utf-8').decode(bytes);
                sink.text(args[0], args[1], args[2], args[3], args[4], args[5], text);
                break;
            }
            case OP_CLIP_PUSH: sink.clipPush(args[0], args[1], args[2], args[3]); break;
            case OP_CLIP_POP: sink.clipPop(); break;
            case OP_HIT: sink.hit(args[0], args[1], args[2], args[3], args[4], args[5]); break;
            default: throw new Error(`prism_canvas decode: unknown opcode ${op} at word ${i} -- host and stream disagree about the op vocabulary`);
        }
        i += 2 + argc;
    }
    throw new Error('prism_canvas decode: fell off the end without an END record'); // verify() already rules this out; kept as a second, cheap guard
}

// ── colour: packed 0xRRGGBBAA -> a CSS colour string ────────────────────────────────────────────
function colorToCss(rgba) {
    const r = (rgba >>> 24) & 0xff, g = (rgba >>> 16) & 0xff, b = (rgba >>> 8) & 0xff, a = rgba & 0xff;
    return `rgba(${r},${g},${b},${(a / 255).toFixed(3)})`;
}

// ── canvas2DSink: adapts the decoder to a REAL CanvasRenderingContext2D ─────────────────────────
// This is the actual Canvas2D backend -- see prism_render_canvas.nova's header for what that
// means precisely (fills/strokes/lines/text/clips, no WebGL, no shaders). Text uses fillText: no
// glyph-level control, host font/advance-width dependence (documented there, not repeated here).
// HIT records are not drawn -- they are collected into `hits` so the host can hit-test pointer
// events against the same geometry the NOVA side computed, via the same "last match wins" rule
// prism_canvas_hit_test() uses (later paint = on top), without a second wasm round trip per move.
function canvas2DSink(ctx) {
    const hits = [];
    return {
        hits,
        fillRect(x, y, w, h, rgba) { ctx.fillStyle = colorToCss(rgba); ctx.fillRect(x, y, w, h); },
        strokeRect(x, y, w, h, rgba, lw) { ctx.strokeStyle = colorToCss(rgba); ctx.lineWidth = lw; ctx.strokeRect(x + 0.5, y + 0.5, w - 1, h - 1); },
        line(x0, y0, x1, y1, rgba, lw) { ctx.strokeStyle = colorToCss(rgba); ctx.lineWidth = lw; ctx.beginPath(); ctx.moveTo(x0, y0); ctx.lineTo(x1, y1); ctx.stroke(); },
        text(x, y, rgba, sizePx, align, weight, str) {
            ctx.fillStyle = colorToCss(rgba);
            ctx.font = `${weight ? 'bold ' : ''}${sizePx}px sans-serif`;
            ctx.textAlign = align === 1 ? 'center' : align === 2 ? 'right' : 'left';
            ctx.textBaseline = 'top';
            ctx.fillText(str, x, y);
        },
        clipPush(x, y, w, h) { ctx.save(); ctx.beginPath(); ctx.rect(x, y, w, h); ctx.clip(); },
        clipPop() { ctx.restore(); },
        hit(x, y, w, h, nodeIndex, role) { hits.push({ x, y, w, h, nodeIndex, role }); }
    };
}

// ── recordingSink: a headless sink for tests -- one string per call, in prism_canvas_dump()'s
// EXACT text shape. Used by the gate so "the Node harness executes the list and reports the draw
// calls it received" is checked against the SAME literal strings the native KAT's exact-dump
// assertion already proved by hand arithmetic, not a second, independently-invented format.
function recordingSink() {
    const calls = [];
    return {
        calls,
        fillRect(x, y, w, h, rgba) { calls.push(`fill_rect ${x},${y},${w},${h},${rgba}`); },
        strokeRect(x, y, w, h, rgba, lw) { calls.push(`stroke_rect ${x},${y},${w},${h},${rgba},${lw}`); },
        line(x0, y0, x1, y1, rgba, lw) { calls.push(`line ${x0},${y0},${x1},${y1},${rgba},${lw}`); },
        text(x, y, rgba, sizePx, align, weight, str) { calls.push(`text ${x},${y},${rgba},${sizePx},${align},${weight} "${str}"`); },
        clipPush(x, y, w, h) { calls.push(`clip_push ${x},${y},${w},${h}`); },
        clipPop() { calls.push('clip_pop'); },
        hit(x, y, w, h, nodeIndex, role) { calls.push(`hit ${x},${y},${w},${h},${nodeIndex},${role}`); }
    };
}

// ── pullWordsFromWasmExports: read the draw-command list out of a LIVE wasm instance ───────────
// `exports` is a wasm instance's exports object with canvas_len()->BigInt and
// canvas_word(i)->BigInt, exactly what _wasm_canvas_probe.nova exports (and what any real Prism
// wasm app would export alongside it, per the ABI note in prism_render_canvas.nova's PUBLIC API).
// i64 crosses the wasm boundary as BigInt (project convention); every value in this stream --
// coordinates, packed colours up to 0xFFFFFFFF, text bytes -- fits in a JS-safe double, so
// converting to Number immediately (rather than threading BigInt through decode()) is lossless and
// keeps the decoder above agnostic to where the words came from (wasm, a file, a literal array).
function pullWordsFromWasmExports(exports) {
    const n = Number(exports.canvas_len());
    const words = new Array(n);
    for (let i = 0; i < n; i++) words[i] = Number(exports.canvas_word(i));
    return words;
}

// Universal export: CommonJS for the Node-side gate test, `window.PrismCanvasHost` for the plain
// <script> the HTML harness uses (a browser has no `module`, and this file is small enough that
// pulling in a bundler just to get ES-module syntax would be a worse trade than one UMD-style
// footer). One implementation, two callers -- the alternative (a separate browser copy) is exactly
// the kind of duplicated logic that drifts, which this project has hit before with duplicated
// backend code paths.
const PrismCanvasHost = { decode, verify, checksum, colorToCss, canvas2DSink, recordingSink, pullWordsFromWasmExports, OP_NAME, MAGIC, VERSION, HEADER_WORDS };
if (typeof module !== 'undefined' && module.exports) {
    module.exports = PrismCanvasHost;
} else {
    globalThis.PrismCanvasHost = PrismCanvasHost;
}
