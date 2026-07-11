#!/bin/bash
# WASM frontend gate: a NOVA-COMPUTED render (a while-loop + str() + string concat via the wasm value-model)
# drives a real DOM tree through the dom_* host-import surface -> <ul> with 3 <li> "item 1/2/3" under #app.
# Proves a NOVA RENDER (not a single literal) builds the DOM, combining value-model-in-wasm + the extern-fn
# DOM channel. Linked with output/nova_runtime_wasm.o. -fno-builtin mandatory.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe _wasm_domrender.nova >/dev/null 2>&1
[ -f _wasm_domrender.ll ] || { echo "FAIL wasm_domrender: NOVA->LLVM"; exit 1; }
clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c ../compiler/nova_runtime_wasm.c -o output/nova_runtime_wasm.o 2>/dev/null || { echo "FAIL wasm_domrender: runtime"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -c _wasm_domrender.ll -o _dprog.o 2>/dev/null || { echo "FAIL wasm_domrender: prog"; exit 1; }
wasm-ld --no-entry --export-all --allow-undefined --gc-sections _dprog.o output/nova_runtime_wasm.o -o _domrender.wasm 2>/dev/null
[ -f _domrender.wasm ] || { echo "FAIL wasm_domrender: link"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("_domrender.wasm"));
let mem=null;
function readCStr(p){ const u=new Uint8Array(mem.buffer); let o=Number(BigInt.asUintN(32,BigInt(p))),e=o; while(u[e]!==0&&e<u.length)e++; return Buffer.from(u.subarray(o,e)).toString("utf8"); }
function mkEl(t){ return {tag:t,text:null,children:[]}; }
const app=mkEl("div"); const nodes=[null,app]; const byId={app:1};
const imp={}; for(const i of WebAssembly.Module.imports(m)){ (imp[i.module]=imp[i.module]||{})[i.name]=()=>0n; }
imp.env=imp.env||{};
imp.env.dom_get_by_id=(p)=>BigInt(byId[readCStr(p)]||0);
imp.env.dom_create=(p)=>{ nodes.push(mkEl(readCStr(p))); return BigInt(nodes.length-1); };
imp.env.dom_set_text=(h,p)=>{ const n=nodes[Number(h)]; if(n)n.text=readCStr(p); return 0n; };
imp.env.dom_append=(ph,ch)=>{ const a=nodes[Number(ph)],b=nodes[Number(ch)]; if(a&&b)a.children.push(b); return 0n; };
const inst=new WebAssembly.Instance(m,imp); mem=inst.exports.memory; inst.exports.render();
const ul=app.children[0];
const ok=ul&&ul.tag==="ul"&&ul.children.length===3&&ul.children.every((li,k)=>li.tag==="li"&&li.text==="item "+(k+1));
process.exit(ok?0:1);
' && echo "PASS wasm_domrender (NOVA-computed render -> DOM: ul>3 li item 1/2/3)" || echo "FAIL wasm_domrender"
