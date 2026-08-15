// Runs a NOVA wasm module for the execution gate and reports BOTH the computed value and the
// module's import list.
//
// ── WHY IMPORTS ARE REPORTED, AND WHY NOTHING IS AUTO-STUBBED HERE ────────────────────────────
// The existing probe runner (_wsg_run.js) fills every unresolved import with `() => 0n` so that a
// stack-guard test can run regardless of what else is missing. That is right for that probe and
// catastrophic as a general policy: combined with `-Wl,--allow-undefined`, ANY runtime function the
// wasm build forgets to define becomes an import, gets silently filled with a zero-returning stub,
// and the module then computes wrong answers with no link error, no trap and no failing test.
// Measured on 2026-08-15: `nova_rt_mod` was missing, so `i % 2` was always 0 -- a Collatz loop took
// the even branch every iteration (native 16 steps, wasm 8) and an odd-counter returned 0 not 5.
//
// So this runner does the opposite: it REPORTS the imports and refuses to invent any. A module that
// needs an import it should not need fails the gate on structure, before any value is compared --
// which catches every missing function, not just the ones a test happens to exercise.
const fs = require('fs');
const path = process.argv[2];
const buf = fs.readFileSync(path);
const mod = new WebAssembly.Module(buf);

const imports = WebAssembly.Module.imports(mod);
console.log('IMPORTS ' + imports.map(i => i.module + '.' + i.name).sort().join(','));

// Only the WASI exit hook is legitimate; everything else is a defect. It is provided rather than
// auto-stubbed because a clean exit is a real, intended control path.
const provided = { wasi_snapshot_preview1: { proc_exit: (c) => { throw new Error('__exit__' + c); } } };
let missing = [];
for (const i of imports) {
  if (provided[i.module] && provided[i.module][i.name]) continue;
  missing.push(i.module + '.' + i.name);
}
if (missing.length > 0) {
  // Deliberately do NOT fabricate them -- report and stop. Fabricating is the bug.
  console.log('UNRESOLVED ' + missing.sort().join(','));
  process.exit(3);
}

try {
  const inst = new WebAssembly.Instance(mod, provided);
  const r = inst.exports.nova_user_main();
  console.log('VALUE ' + r);
} catch (e) {
  console.log('TRAP ' + e.message);
  process.exit(4);
}
