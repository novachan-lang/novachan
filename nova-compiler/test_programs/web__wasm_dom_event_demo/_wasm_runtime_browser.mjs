// Browser ES-module runtime for NOVA wasm32 + the DOM host-binding surface (WASM Stage 2).
// NOVA-WAY FRAMING: the JS host is a PEER PROCESS; the wasm import table is the CHANNEL to it.
// extern fns declared in NOVA are the channel ops. Marshalling (the sound subset): strings flow
// IN as char* linear-memory pointers (readCStr); DOM nodes flow OUT as opaque int HANDLES kept in
// a JS side-table (handle = index, 0 = null). No heterogeneous-any crosses the boundary.
// Usage (from _wasm_dom_index.html):
//   import { runDom } from "./_wasm_runtime_browser.mjs";
//   runDom("./_wasm_dom_demo2.wasm");
let memU8 = null;
function readCStr(ptr) {
  const off = Number(BigInt(ptr) & 0xFFFFFFFFn);
  let end = off; while (memU8[end] !== 0) end++;
  return new TextDecoder().decode(memU8.subarray(off, end));
}
export async function runDom(wasmUrl) {
  const nodes = [null];                       // handle = index into this table; 0 = null
  let inst = null;                            // bound after instantiate; event handlers read it
  const dom = {
    dom_get_by_id(idPtr) { const el = document.getElementById(readCStr(idPtr)); if (!el) return 0n; nodes.push(el); return BigInt(nodes.length - 1); },
    dom_create(tagPtr)   { nodes.push(document.createElement(readCStr(tagPtr))); return BigInt(nodes.length - 1); },
    dom_set_text(h, txtPtr) { const n = nodes[Number(h)]; if (n) n.textContent = readCStr(txtPtr); return 0n; },
    dom_set_attr(h, kPtr, vPtr) { const n = nodes[Number(h)]; if (n) n.setAttribute(readCStr(kPtr), readCStr(vPtr)); return 0n; },
    dom_append(ph, ch)   { const p = nodes[Number(ph)], c = nodes[Number(ch)]; if (p && c) p.appendChild(c); return 0n; },
    // Stage 3: a browser event invokes a NOVA fn, identified by its wasm EXPORT NAME (a string).
    dom_on_click(h, namePtr) { const n = nodes[Number(h)], name = readCStr(namePtr);
      if (n) n.addEventListener("click", () => inst.exports[name]()); return 0n; },
  };
  // tolerant: any runtime symbol the module imports but we don't model -> a no-op returning 0n.
  const env = new Proxy(dom, { get(t, k) { return k in t ? t[k] : (() => 0n); } });
  const resp = await fetch(wasmUrl);
  const { instance } = await WebAssembly.instantiate(await resp.arrayBuffer(), { env });
  inst = instance;
  memU8 = new Uint8Array(instance.exports.memory.buffer);
  instance.exports.nova_user_main();
}
