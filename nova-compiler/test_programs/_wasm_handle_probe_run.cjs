"use strict";
const fs = require("fs");
const { createRuntime } = require("./_wasm_runtime.cjs");
let memU8 = null;
function readCStr(ptr){ const o=Number(BigInt(ptr)&0xFFFFFFFFn); let e=o; while(memU8[e]!==0)e++; return Buffer.from(memU8.subarray(o,e)).toString("utf8"); }
const nodes = [null];                       // handle = index; 0 = null
const rt = createRuntime();
rt.imports.make_node = (tagPtr) => { const tag = readCStr(tagPtr); nodes.push({tag}); return BigInt(nodes.length-1); };
rt.imports.tag_len   = (h) => BigInt(nodes[Number(h)] ? nodes[Number(h)].tag.length : -1);
WebAssembly.instantiate(fs.readFileSync("_wasm_handle_probe.wasm"), { env: rt.imports })
  .then(({instance})=>{ rt.init(instance); memU8=new Uint8Array(instance.exports.memory.buffer); instance.exports.nova_user_main(); })
  .catch(e=>{ console.error("err",e); process.exit(1); });
