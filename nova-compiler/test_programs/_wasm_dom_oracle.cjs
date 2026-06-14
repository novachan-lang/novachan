// Stage 1 oracle (CI proxy for a real browser, since jsdom isn't installed): prove a NOVA fn
// reaches "the DOM" via the dom_set_text host import end-to-end. A minimal fake `document`
// captures textContent; the assertion is that NOVA's main() drove it to "Hello from NOVA".
"use strict";
const fs = require("fs");
const { createRuntime } = require("./_wasm_runtime.cjs");

let captured = null;
const document = {
  getElementById: (_id) => ({ set textContent(v) { captured = v; }, get textContent() { return captured; } }),
};

const rt = createRuntime();
let memU8 = null;
function readCStr(ptr) {
  const off = Number(BigInt(ptr) & 0xFFFFFFFFn);   // wasm i64 ptr; low 32 bits = linear-mem offset
  let end = off; while (memU8[end] !== 0) end++;
  return Buffer.from(memU8.subarray(off, end)).toString("utf8");
}
// the host import NOVA declared `extern fn dom_set_text(id, txt)`
rt.imports.dom_set_text = (idPtr, txtPtr) => {
  document.getElementById(readCStr(idPtr)).textContent = readCStr(txtPtr);
  return 0n;   // declare returns i64; harmless if void
};

WebAssembly.instantiate(fs.readFileSync("_wasm_dom_demo.wasm"), { env: rt.imports })
  .then(({ instance }) => {
    rt.init(instance);
    memU8 = new Uint8Array(instance.exports.memory.buffer);
    instance.exports.nova_user_main();
    if (captured === "Hello from NOVA") { console.log("DOM_OK captured=[" + captured + "]"); process.exit(0); }
    console.log("DOM_FAIL captured=[" + captured + "]"); process.exit(1);
  })
  .catch((e) => { console.error("wasm run error:", e); process.exit(1); });
