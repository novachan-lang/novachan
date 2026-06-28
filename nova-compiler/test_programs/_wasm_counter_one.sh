#!/bin/bash
# WASM frontend STATEFUL-COUNTER gate (event + state + logic + render in NOVA). JS invokes bump() on each
# "click"; NOVA reads a persistent wasm state cell (nova_state_get), increments it, and re-renders "count: N"
# via dom_set_text. State persists across exported calls (the cell lives in nova_runtime_wasm.c; NOVA module-
# level mutable globals don't yet persist across wasm calls). Linked with output/nova_runtime_wasm.o.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe _wasm_counter.nova >/dev/null 2>&1
[ -f _wasm_counter.ll ] || { echo "FAIL wasm_counter: NOVA->LLVM"; exit 1; }
clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c output/nova_runtime_wasm.c -o output/nova_runtime_wasm.o 2>/dev/null || { echo "FAIL wasm_counter: runtime"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -c _wasm_counter.ll -o _cprog.o 2>/dev/null || { echo "FAIL wasm_counter: prog"; exit 1; }
wasm-ld --no-entry --export-all --allow-undefined --gc-sections _cprog.o output/nova_runtime_wasm.o -o _counter.wasm 2>/dev/null
[ -f _counter.wasm ] || { echo "FAIL wasm_counter: link"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("_counter.wasm"));
let mem=null;
function readCStr(p){ const u=new Uint8Array(mem.buffer); let o=Number(BigInt.asUintN(32,BigInt(p))),e=o; while(u[e]!==0&&e<u.length)e++; return Buffer.from(u.subarray(o,e)).toString("utf8"); }
const countNode={tag:"span",text:null}; const nodes=[null,countNode]; const byId={count:1};
const imp={}; for(const i of WebAssembly.Module.imports(m)){ (imp[i.module]=imp[i.module]||{})[i.name]=()=>0n; }
imp.env=imp.env||{};
imp.env.dom_get_by_id=(p)=>BigInt(byId[readCStr(p)]||0);
imp.env.dom_set_text=(h,p)=>{ const n=nodes[Number(h)]; if(n)n.text=readCStr(p); return 0n; };
const x=new WebAssembly.Instance(m,imp).exports; mem=x.memory;
const seq=[]; x.init(); seq.push(countNode.text); x.bump(); seq.push(countNode.text); x.bump(); seq.push(countNode.text); x.bump(); seq.push(countNode.text);
process.exit(JSON.stringify(seq)===JSON.stringify(["count: 0","count: 1","count: 2","count: 3"])?0:1);
' && echo "PASS wasm_counter (event+state+render in NOVA: count 0->1->2->3)" || echo "FAIL wasm_counter"
