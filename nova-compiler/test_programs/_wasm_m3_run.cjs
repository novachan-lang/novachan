// WASM milestone 3: a NOVA program that builds a DYNAMIC string (str(42)) and prints
// it, running in wasm32. Demonstrates the runtime-call bridge: the wasm module holds
// the compiled NOVA logic and calls out to a JS-HOSTED runtime for services (string
// creation, print) — the pragmatic browser architecture (logic in wasm, runtime in JS
// glue), no in-wasm heap needed. Strings are host-managed via opaque i64 handles.
const fs = require('fs');
let captured = null;
const strings = [];
const imports = { env: {
  nova_rt_int_to_str: (n) => { strings.push(String(n)); return BigInt(strings.length - 1); },
  nova_rt_print_str:  (h) => { const s = strings[Number(h)]; captured = s; console.log(s); return 0n; },
}};
WebAssembly.instantiate(fs.readFileSync('wasm_m3.wasm'), imports).then(({ instance }) => {
  instance.exports.nova_user_main();
  process.exit(captured === "55" ? 0 : 1);
}).catch(e => { console.error(e); process.exit(1); });
