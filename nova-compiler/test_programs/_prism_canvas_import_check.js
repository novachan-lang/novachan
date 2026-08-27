// Support script for _prism_canvas_gate.ps1, stage 2.
//
// Loads a wasm module LINKED WITHOUT ANY RUNTIME (program object only, wasm-ld --allow-undefined)
// and reports its full import list. Linking the program alone this way makes EVERY nova_rt_*/
// nova_rc_* call the compiler emitted for this program show up as an unresolved import -- so this
// is the COMPLETE closure of runtime symbols prism_render_canvas.nova's wasm output depends on,
// independent of whether the (separately, currently stale) full value-model runtime carve
// currently compiles. See _prism_canvas_gate.ps1 and NOVA_DESIGN/WEAPON_PARITY_PLAN.md item 5.6
// for why that split matters.
//
// Exit code carries the verdict (gate convention, see _wasm_exec_run.js): 0 = every import is an
// expected nova_rt_*/nova_rc_*/strcmp value-model primitive; 1 = something unexpected showed up
// (a network/file/thread/process symbol would mean this "pure compute" renderer somehow reaches
// for host I/O, which the memory-noted "--allow-undefined silently stubs to 0" danger makes a
// SILENT WRONG ANSWER risk, not just a build nuisance).
const fs = require('fs');
const path = process.argv[2];
if (!path) { console.log('usage: node _prism_canvas_import_check.js <path-to-wasm>'); process.exit(2); }

const buf = fs.readFileSync(path);
const mod = new WebAssembly.Module(buf);
const imports = WebAssembly.Module.imports(mod);

const ALLOW = /^(nova_rt_|nova_rc_)/;
const ALLOW_EXACT = new Set(['strcmp']);
// Any of these substrings in an import name is a network/file/thread/process capability this pure
// layout+draw-command computation has no legitimate reason to need.
const DENY_PATTERNS = [/sock/i, /\btcp\b/i, /\bhttp\b/i, /\bdns\b/i, /file/i, /fopen/i, /\bdir\b/i,
    /thread/i, /pthread/i, /spawn/i, /\bexec/i, /popen/i, /mmap/i, /epoll/i, /\bselect\b/i,
    /\bssl\b/i, /\btls\b/i, /getenv/i, /\bfork\b/i];

let unexpected = [];
let denied = [];
for (const imp of imports) {
    const label = `${imp.module}.${imp.name}`;
    if (imp.module !== 'env') { unexpected.push(label + ' (unexpected import module)'); continue; }
    for (const pat of DENY_PATTERNS) {
        if (pat.test(imp.name)) { denied.push(label + ` (matches deny-pattern ${pat})`); }
    }
    if (!ALLOW.test(imp.name) && !ALLOW_EXACT.has(imp.name)) {
        unexpected.push(label + ' (not a recognized nova_rt_*/nova_rc_*/strcmp symbol)');
    }
}

console.log(`TOTAL_IMPORTS ${imports.length}`);
for (const imp of imports.slice().sort((a, b) => a.name.localeCompare(b.name))) {
    console.log(`IMPORT ${imp.module}.${imp.name}`);
}

if (denied.length) {
    console.log('DENIED ' + denied.join(' | '));
}
if (unexpected.length) {
    console.log('UNEXPECTED ' + unexpected.join(' | '));
}

if (denied.length === 0 && unexpected.length === 0) {
    console.log(`VERDICT PASS -- all ${imports.length} imports are expected value-model primitives, no network/file/thread/process symbols`);
    process.exit(0);
} else {
    console.log('VERDICT FAIL');
    process.exit(1);
}
