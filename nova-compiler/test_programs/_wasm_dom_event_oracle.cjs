// Stage 3 oracle (CI proxy): prove a host event invokes a NOVA fn that mutates the DOM.
// A fake `document` + handle table + an addEventListener that calls the exported NOVA handler.
"use strict";
const fs = require("fs");
const { createRuntime } = require("./_wasm_runtime.cjs");
let memU8 = null, inst = null;
function readCStr(ptr){ const o=Number(BigInt(ptr)&0xFFFFFFFFn); let e=o; while(memU8[e]!==0)e++; return Buffer.from(memU8.subarray(o,e)).toString("utf8"); }
function mkEl(tag){ return { tag, text:null, attrs:{}, children:[], _listeners:{}, addEventListener(ev,fn){ (this._listeners[ev]||(this._listeners[ev]=[])).push(fn); }, click(){ (this._listeners.click||[]).forEach(f=>f()); } }; }
const app = mkEl("div"); app.id = "app";
const nodes = [null, app];
const byId = { app: 1 };
const rt = createRuntime();
rt.imports.dom_get_by_id = (idPtr) => BigInt(byId[readCStr(idPtr)] || 0);
rt.imports.dom_create    = (tagPtr) => { nodes.push(mkEl(readCStr(tagPtr))); return BigInt(nodes.length-1); };
rt.imports.dom_set_text  = (h, txtPtr) => { const n=nodes[Number(h)]; if(n) n.text=readCStr(txtPtr); return 0n; };
rt.imports.dom_append    = (ph, ch) => { const p=nodes[Number(ph)], c=nodes[Number(ch)]; if(p&&c) p.children.push(c); return 0n; };
rt.imports.dom_on_click  = (h, namePtr) => { const n=nodes[Number(h)], name=readCStr(namePtr); if(n) n.addEventListener("click", () => inst.exports[name]()); return 0n; };
WebAssembly.instantiate(fs.readFileSync(process.argv[2] || "_wasm_dom_event_demo.wasm"), { env: rt.imports })
  .then(({instance})=>{
    inst = instance; rt.init(instance); memU8 = new Uint8Array(instance.exports.memory.buffer);
    instance.exports.nova_user_main();                  // builds the button + registers on_click
    const btn = app.children[0];
    if (!btn || btn.tag !== "button") { console.log("CB_FAIL no button"); process.exit(1); }
    btn.click(); btn.click();                            // simulate two host clicks -> NOVA on_click x2
    const ps = app.children.filter(c => c.tag === "p" && c.text === "clicked");
    if (ps.length === 2 && app.children.length === 3) { console.log("DOM_OK3 children=" + app.children.map(c=>c.tag).join(",")); process.exit(0); }
    console.log("DOM_FAIL3 children=" + JSON.stringify(app.children.map(c=>({t:c.tag,x:c.text})))); process.exit(1);
  }).catch(e=>{ console.error("err",e); process.exit(1); });
