// Stage 2 oracle (CI proxy): a fake `document` + a handle side-table prove NOVA built the DOM tree.
"use strict";
const fs = require("fs");
const { createRuntime } = require("./_wasm_runtime.cjs");
let memU8 = null;
function readCStr(ptr){ const o=Number(BigInt(ptr)&0xFFFFFFFFn); let e=o; while(memU8[e]!==0)e++; return Buffer.from(memU8.subarray(o,e)).toString("utf8"); }
function mkEl(tag){ return { tag, text:null, attrs:{}, children:[] }; }
const app = mkEl("div"); app.id = "app";
const nodes = [null, app];                 // handle 1 = #app
const byId = { app: 1 };
const rt = createRuntime();
rt.imports.dom_get_by_id = (idPtr) => BigInt(byId[readCStr(idPtr)] || 0);
rt.imports.dom_create    = (tagPtr) => { nodes.push(mkEl(readCStr(tagPtr))); return BigInt(nodes.length-1); };
rt.imports.dom_set_text  = (h, txtPtr) => { const n=nodes[Number(h)]; if(n) n.text=readCStr(txtPtr); return 0n; };
rt.imports.dom_set_attr  = (h, kPtr, vPtr) => { const n=nodes[Number(h)]; if(n) n.attrs[readCStr(kPtr)]=readCStr(vPtr); return 0n; };
rt.imports.dom_append    = (ph, ch) => { const p=nodes[Number(ph)], c=nodes[Number(ch)]; if(p&&c) p.children.push(c); return 0n; };
WebAssembly.instantiate(fs.readFileSync("_wasm_dom_demo2.wasm"), { env: rt.imports })
  .then(({instance})=>{
    rt.init(instance); memU8=new Uint8Array(instance.exports.memory.buffer);
    instance.exports.nova_user_main();
    const ok = app.children.length===1 && app.children[0].tag==="p"
            && app.children[0].text==="Built by NOVA" && app.children[0].attrs.class==="greeting";
    if (ok) { console.log("DOM_OK2 tree=" + JSON.stringify(app)); process.exit(0); }
    console.log("DOM_FAIL2 tree=" + JSON.stringify(app)); process.exit(1);
  })
  .catch(e=>{ console.error("err",e); process.exit(1); });
