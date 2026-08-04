// Runs a NOVA WASM module and reports HOW it ended: a clean guard-triggered exit(2), a normal
// return, or an engine trap. The distinction is the whole point of the test -- without the depth
// guard an unbounded recursion is an opaque RuntimeError with no diagnostic.
const fs = require('fs');
const buf = fs.readFileSync(process.argv[2]);
let exitCode = null;
const imports = { wasi_snapshot_preview1: { proc_exit: (c) => { exitCode = c; throw new Error('__exit__'); } } };
const mod = new WebAssembly.Module(buf);
for (const i of WebAssembly.Module.imports(mod)) {
  imports[i.module] = imports[i.module] || {};
  if (!imports[i.module][i.name]) imports[i.module][i.name] = () => 0n;
}
const inst = new WebAssembly.Instance(mod, imports);
try {
  const r = inst.exports.nova_user_main();
  console.log('RETURNED ' + r);
} catch (e) {
  // The exported flag is what distinguishes NOVA's guard from the engine simply running out
  // of stack -- both surface as a RuntimeError, so the message alone cannot tell them apart.
  const g = inst.exports.nova_rt_stack_overflowed;
  const fired = g ? new Int32Array(inst.exports.memory.buffer, g.value, 1)[0] : -1;
  if (fired === 1) console.log('GUARD FIRED (contained stack overflow)');
  else if (exitCode !== null) console.log('CLEAN EXIT code=' + exitCode);
  else console.log('TRAP (guard did NOT fire): ' + e.message);
}
