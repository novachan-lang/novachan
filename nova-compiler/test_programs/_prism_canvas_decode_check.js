// Support script for _prism_canvas_gate.ps1, stage 3: "the Node harness executes the list and
// reports the draw calls it received, checked against expected values."
//
// The word list it reads (argv[2]) was produced by _canvas_words_dump.nova -- a NATIVE (not wasm)
// NOVA binary that builds the exact same small tree the KAT hand-verifies and prints one word per
// line. Native, not wasm, because producing a LIVE wasm word list needs the value-model wasm
// runtime carve to compile, which is currently blocked upstream of this renderer (see this
// script's caller and NOVA_DESIGN/WEAPON_PARITY_PLAN.md item 5.6 for the exact reason). Using the
// native dump instead of hand-retyping the 61 words into this file keeps the test honest: the
// WORDS come from a real, already-KAT-proven renderer execution, not from a human's transcription,
// and what THIS script actually exercises -- decoding raw opcodes/argc/text-byte-arrays back into
// fillRect/text/hit calls -- is exactly the logic prism_canvas_host.js needs to get right whether
// its input arrives from wasm, a file, or (once the carve is fixed) live linear memory.
const fs = require('fs');
const path = require('path');
const host = require(path.join(__dirname, '..', '..', 'prism', 'backend', 'canvas', 'prism_canvas_host.js'));

const wordsPath = process.argv[2];
if (!wordsPath) { console.log('usage: node _prism_canvas_decode_check.js <path-to-words.txt>'); process.exit(2); }

const words = fs.readFileSync(wordsPath, 'utf8').split(/\r?\n/).filter(l => l.length > 0).map(Number);

let failed = 0;
function check(label, cond) {
    if (cond) { console.log('  pass  ' + label); }
    else { console.log('  FAIL  ' + label); failed++; }
}

console.log(`word count: ${words.length}`);

// 1. verify() -- the independent JS re-implementation of the framing checks.
const v = host.verify(words);
check('verify(): buffer is well-formed', v.ok === true);
check('verify(): reports 6 commands', v.ok && v.cmdCount === 6);

// 2. decode() with a recording sink -- checked against the SAME exact-text expectation the native
// KAT's prism_canvas_dump() assertion already proved by hand-derived geometry (see that KAT's
// header comment for the arithmetic). This is the "draw calls it received, checked against
// expected values" assertion: exact x/y/w/h, exact packed colour, exact text.
//
// decode() throws on a stream that fails verify() (by design -- a caller should never receive
// draw calls from a stream it was just told is corrupt). Guarded here so a bad input degrades to a
// reported FAIL like every other check in this file, not an uncaught exception and a raw Node
// stack trace -- the same "detectable, not a crash" property this whole gate is about.
const EXPECTED = [
    'fill_rect 0,0,200,100,4294967295',
    'text 0,0,437918463,14,0,0 "Hi"',
    'hit 0,26,200,36,2,1',
    'fill_rect 0,26,200,36,1330046463',
    'stroke_rect 0,26,200,36,1330046463,1',
    'text 100,34,4294967295,14,1,1 "Go"'
];
let sink = host.recordingSink();
try {
    const cmdCount = host.decode(words, sink);
    check('decode(): returns 6 commands', cmdCount === 6);
} catch (e) {
    check('decode(): returns 6 commands', false);
    console.log('        decode() threw: ' + e.message);
}
check('decode(): command count matches expected', sink.calls.length === EXPECTED.length);
for (let i = 0; i < EXPECTED.length; i++) {
    check(`decode(): record ${i} exact match: ${EXPECTED[i]}`, sink.calls[i] === EXPECTED[i]);
    if (sink.calls[i] !== EXPECTED[i]) {
        console.log(`        got  = ${sink.calls[i]}`);
        console.log(`        want = ${EXPECTED[i]}`);
    }
}

// 3. canvas2DSink -- exercised against a minimal fake CanvasRenderingContext2D (Node has no real
// Canvas2D without an extra native dependency this project does not carry; the HTML harness is
// the real Canvas2D consumer). This only proves the adapter calls a legal, complete Canvas2D
// surface without throwing -- not pixel output -- which is what a headless Node process even CAN
// prove about a Canvas2D adapter.
class FakeCtx {
    constructor() { this.ops = []; }
    set fillStyle(v) { this.ops.push('fillStyle=' + v); }
    set strokeStyle(v) { this.ops.push('strokeStyle=' + v); }
    set lineWidth(v) { this.ops.push('lineWidth=' + v); }
    set font(v) { this.ops.push('font=' + v); }
    set textAlign(v) { this.ops.push('textAlign=' + v); }
    set textBaseline(v) { this.ops.push('textBaseline=' + v); }
    fillRect(...a) { this.ops.push('fillRect(' + a.join(',') + ')'); }
    strokeRect(...a) { this.ops.push('strokeRect(' + a.join(',') + ')'); }
    beginPath() { this.ops.push('beginPath()'); }
    moveTo(...a) { this.ops.push('moveTo(' + a.join(',') + ')'); }
    lineTo(...a) { this.ops.push('lineTo(' + a.join(',') + ')'); }
    stroke() { this.ops.push('stroke()'); }
    fillText(...a) { this.ops.push('fillText(' + a.join(',') + ')'); }
    rect(...a) { this.ops.push('rect(' + a.join(',') + ')'); }
    clip() { this.ops.push('clip()'); }
    save() { this.ops.push('save()'); }
    restore() { this.ops.push('restore()'); }
}
try {
    const fakeCtx = new FakeCtx();
    const canvasSink = host.canvas2DSink(fakeCtx);
    host.decode(words, canvasSink);
    check('canvas2DSink: decodes the full stream without throwing', true);
    check('canvas2DSink: issued a fillText for both text runs', fakeCtx.ops.filter(o => o.startsWith('fillText')).length === 2);
    check('canvas2DSink: recorded exactly one hit (the press button)', canvasSink.hits.length === 1 && canvasSink.hits[0].nodeIndex === 2);
} catch (e) {
    check('canvas2DSink: decodes the full stream without throwing', false);
    console.log('        error = ' + e.message);
}

// 4. Truncation must be DETECTABLE, never silently mis-decoded -- re-confirms the JS side of the
// contract independently of the NOVA-side KAT's own truncation tests (section 2 there).
const shortWords = words.slice(0, words.length - 5);
const vShort = host.verify(shortWords);
check('verify(): a truncated buffer is rejected, not silently accepted', vShort.ok === false);

console.log('');
if (failed === 0) {
    console.log('_prism_canvas_decode_check: ALL PASS');
    process.exit(0);
} else {
    console.log(`_prism_canvas_decode_check: ${failed} FAILURE(S)`);
    process.exit(1);
}
