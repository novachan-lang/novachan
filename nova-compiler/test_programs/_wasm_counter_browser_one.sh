#!/bin/bash
# Real-browser counter artifact gate: validates the browser runtime wiring used by _wasm_counter.html (a Proxy
# env over the DOM host-imports + a node<->handle table + readCStr over the wasm memory) drives the NOVA counter
# correctly against a fake document -> count: 0->1->2->3. _wasm_counter.html is the human artifact (serve the dir
# over http:// and open it); this node sim is the CI proxy for its JS wiring (jsdom absent). Rebuilds _counter.wasm.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe _wasm_counter.nova >/dev/null 2>&1
clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c ../compiler/nova_runtime_wasm.c -o output/nova_runtime_wasm.o 2>/dev/null || { echo "FAIL wasm_counter_browser: runtime"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -c _wasm_counter.ll -o _cprog.o 2>/dev/null || { echo "FAIL wasm_counter_browser: prog"; exit 1; }
wasm-ld --no-entry --export-all --allow-undefined --gc-sections _cprog.o output/nova_runtime_wasm.o -o _counter.wasm 2>/dev/null
[ -f _counter.wasm ] || { echo "FAIL wasm_counter_browser: link"; exit 1; }
node -e '
const fs=require("fs");
const elems={ count:{textContent:"count: ..."} };
const document={ getElementById:(id)=>elems[id]||null };
const handles=[null]; const byNode=new Map(); let mem=null;
const dec=new (require("util").TextDecoder)();
function readCStr(p){ const u=new Uint8Array(mem.buffer); let o=Number(BigInt.asUintN(32,BigInt(p))),e=o; while(u[e]!==0)e++; return dec.decode(u.subarray(o,e)); }
function handleFor(node){ if(!node) return 0; if(byNode.has(node)) return byNode.get(node); handles.push(node); const h=handles.length-1; byNode.set(node,h); return h; }
const env=new Proxy({
  dom_get_by_id:(p)=>BigInt(handleFor(document.getElementById(readCStr(p)))),
  dom_set_text:(h,p)=>{ const n=handles[Number(h)]; if(n) n.textContent=readCStr(p); return 0n; },
},{ get(t,k){ return k in t ? t[k] : ()=>0n; } });
const inst=new WebAssembly.Instance(new WebAssembly.Module(fs.readFileSync("_counter.wasm")),{env}); mem=inst.exports.memory;
const seq=[]; inst.exports.init(); seq.push(elems.count.textContent);
inst.exports.bump(); seq.push(elems.count.textContent); inst.exports.bump(); seq.push(elems.count.textContent); inst.exports.bump(); seq.push(elems.count.textContent);
process.exit(JSON.stringify(seq)===JSON.stringify(["count: 0","count: 1","count: 2","count: 3"])?0:1);
' && echo "PASS wasm_counter_browser (browser runtime wiring: count 0->1->2->3)" || echo "FAIL wasm_counter_browser"
