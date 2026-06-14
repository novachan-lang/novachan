"use strict";
const fs = require("fs");
let memU8 = null, bumpPtr = 0, inst = null, captured = null;
function readCStr(p){ const o=Number(BigInt(p)&0xFFFFFFFFn); let e=o; while(memU8[e]!==0)e++; return Buffer.from(memU8.subarray(o,e)).toString("utf8"); }
function writeCStr(s){ const b=Buffer.from(s,"utf8"); const p=(bumpPtr+7)&~7; bumpPtr=p+b.length+1; memU8.set(b,p); memU8[p+b.length]=0; return p; }
const document = { getElementById:()=>({ set textContent(v){captured=v;}, get textContent(){return captured;} }) };
const env = new Proxy({
  dom_get_by_id:()=>1n,
  dom_set_text:(h,txtPtr)=>{ document.getElementById().textContent = readCStr(txtPtr); return 0n; },
  host_provide:(namePtr)=>{ const name=readCStr(namePtr); const p=writeCStr('{"ok":true,"n":3}'); inst.exports[name](BigInt(p)); return 0n; },
}, { get(t,k){ return k in t ? t[k] : (()=>0n); } });
WebAssembly.instantiate(fs.readFileSync("_wasm_fetch_probe.wasm"), { env }).then(({instance})=>{
  inst=instance; memU8=new Uint8Array(instance.exports.memory.buffer);
  bumpPtr = Number(instance.exports.__heap_base ? instance.exports.__heap_base.value ?? instance.exports.__heap_base : 0) || 65536;
  instance.exports.nova_user_main();
  if (captured === '{"ok":true,"n":3}') { console.log("FETCH_PROBE_OK captured="+captured); process.exit(0); }
  console.log("FETCH_PROBE_FAIL captured="+captured); process.exit(1);
}).catch(e=>{ console.error("err",e); process.exit(1); });
