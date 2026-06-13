// WASM milestone-2 harness: a NOVA program that prints a static string runs in wasm.
// The minimal runtime shim is nova_rt_print_str: read the null-terminated bytes from
// the module's exported linear memory at the given pointer and print them.
const fs = require('fs');
let mem = null;
let captured = "";
const readCStr = (ptr) => {
  const u8 = new Uint8Array(mem.buffer);
  let p = Number(ptr & 0xFFFFFFFFn), end = p;
  while (u8[end] !== 0) end++;
  return Buffer.from(u8.subarray(p, end)).toString("utf8");
};
const imports = { env: { nova_rt_print_str: (ptr) => { captured = readCStr(ptr); console.log(captured); return 0n; } } };
WebAssembly.instantiate(fs.readFileSync('wasm_m2.wasm'), imports).then(({ instance }) => {
  mem = instance.exports.memory;
  instance.exports.nova_user_main();
  const want = "hello from wasm";
  process.exit(captured === want ? 0 : 1);
}).catch(e => { console.error(e); process.exit(1); });
