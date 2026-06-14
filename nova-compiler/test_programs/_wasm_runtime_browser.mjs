// Browser ES-module runtime for NOVA wasm32 + a DOM host-import binding. Mirrors the env
// importObject of _wasm_runtime.cjs (memory ops) but for the browser, and adds dom_set_text.
// Usage (from _wasm_dom_index.html):
//   import { runDom } from "./_wasm_runtime_browser.mjs";
//   runDom("./_wasm_dom_demo.wasm");
let memU8 = null;
function readCStr(ptr) {
  const off = Number(BigInt(ptr) & 0xFFFFFFFFn);
  let end = off; while (memU8[end] !== 0) end++;
  return new TextDecoder().decode(memU8.subarray(off, end));
}
export async function runDom(wasmUrl) {
  // Minimal env: the DOM host import + tolerant no-op stubs for any runtime symbol the
  // module may import (this sound subset -- string literals + a host call -- needs none of them).
  const env = new Proxy(
    { dom_set_text(idPtr, txtPtr) {
        document.getElementById(readCStr(idPtr)).textContent = readCStr(txtPtr);
        return 0n;
      } },
    { get(t, k) { return k in t ? t[k] : (() => 0n); } }   // unknown import -> no-op
  );
  const resp = await fetch(wasmUrl);
  const { instance } = await WebAssembly.instantiate(await resp.arrayBuffer(), { env });
  memU8 = new Uint8Array(instance.exports.memory.buffer);
  instance.exports.nova_user_main();
}
