// Stage B oracle (CI proxy): a NOVA WASM frontend fetches (mocked) from a "NOVA backend" + renders.
// Proves the async data flow JS->wasm + the full-stack wiring end-to-end (sound subset: no in-browser
// json_decode; that awaits m7). Fake document + handle table + bump allocator + mock http_get_json.
"use strict";
const fs = require("fs");
let memU8 = null, bumpPtr = 0, inst = null;
function readCStr(p){ const o=Number(BigInt(p)&0xFFFFFFFFn); let e=o; while(memU8[e]!==0)e++; return Buffer.from(memU8.subarray(o,e)).toString("utf8"); }
function writeCStr(s){ const b=Buffer.from(s,"utf8"); const p=(bumpPtr+7)&~7; bumpPtr=p+b.length+1; if(bumpPtr>memU8.length){ throw new Error("oom"); } memU8.set(b,p); memU8[p+b.length]=0; return p; }
function mkEl(tag){ return { tag, text:null, children:[], _cl:[], addEventListener(ev,fn){ if(ev==="click") this._cl.push(fn); }, click(){ this._cl.forEach(f=>f()); } }; }
const app = mkEl("div"); app.id="app";
const nodes=[null, app]; const byId={app:1};
const BACKEND_JSON = '[{"name":"a","done":true},{"name":"b","done":false}]';   // what the NOVA backend would serve
const env = new Proxy({
  dom_get_by_id:(p)=>BigInt(byId[readCStr(p)]||0),
  dom_create:(p)=>{ nodes.push(mkEl(readCStr(p))); return BigInt(nodes.length-1); },
  dom_set_text:(h,p)=>{ const n=nodes[Number(h)]; if(n) n.text=readCStr(p); return 0n; },
  dom_append:(ph,ch)=>{ const a=nodes[Number(ph)],c=nodes[Number(ch)]; if(a&&c) a.children.push(c); return 0n; },
  dom_on_click:(h,np)=>{ const n=nodes[Number(h)],name=readCStr(np); if(n) n.addEventListener("click",()=>inst.exports[name]()); return 0n; },
  http_get_json:(urlP,nameP)=>{ const url=readCStr(urlP), name=readCStr(nameP); /* MOCK fetch(url): synchronously deliver the backend's JSON */ const p=writeCStr(BACKEND_JSON); inst.exports[name](BigInt(p)); return 0n; },
}, { get(t,k){ return k in t ? t[k] : (()=>0n); } });
WebAssembly.instantiate(fs.readFileSync("_wasm_fullstack_demo.wasm"), { env }).then(({instance})=>{
  inst=instance; memU8=new Uint8Array(instance.exports.memory.buffer);
  const hb=instance.exports.__heap_base; bumpPtr = Number(hb&&hb.value!==undefined?hb.value:hb)||65536;
  instance.exports.nova_user_main();                 // builds the button + registers load
  const btn=app.children[0];
  if(!btn||btn.tag!=="button"){ console.log("FULLSTACK_FAIL no button"); process.exit(1); }
  btn.click();                                        // user clicks -> load() -> http_get_json -> on_items renders
  const pre=app.children[1];
  const ok = app.children.length===2 && pre && pre.tag==="pre" && pre.text===BACKEND_JSON;
  if(ok){ console.log("FULLSTACK_OK rendered=["+pre.text+"]"); process.exit(0); }
  console.log("FULLSTACK_FAIL tree="+JSON.stringify(app.children.map(c=>({t:c.tag,x:c.text})))); process.exit(1);
}).catch(e=>{ console.error("err",e); process.exit(1); });
