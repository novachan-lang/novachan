#!/bin/bash
# WASM frontend RENDER-PATH gate: a NOVA fn BUILDS a string in the wasm value-model (concat) and passes it
# across the extern-fn -> wasm-import "channel" to the JS host, which reads the built bytes from wasm linear
# memory. Proves the browser "render" path (compute text/markup in NOVA -> hand to the DOM host), combining the
# full value-model-in-wasm (output/nova_runtime_wasm.o) with the pre-existing extern-fn host-import surface.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe _wasm_render.nova >/dev/null 2>&1
[ -f _wasm_render.ll ] || { echo "FAIL wasm_render: NOVA->LLVM"; exit 1; }
clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c output/nova_runtime_wasm.c -o output/nova_runtime_wasm.o 2>/dev/null || { echo "FAIL wasm_render: runtime"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -c _wasm_render.ll -o _rprog.o 2>/dev/null || { echo "FAIL wasm_render: prog"; exit 1; }
wasm-ld --no-entry --export-all --allow-undefined --gc-sections _rprog.o output/nova_runtime_wasm.o -o _render.wasm 2>/dev/null
[ -f _render.wasm ] || { echo "FAIL wasm_render: link"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("_render.wasm"));
let captured=null, mem=null;
function readCStr(ptr){ const u=new Uint8Array(mem.buffer); let e=ptr; while(u[e]!==0&&e<u.length) e++; return Buffer.from(u.slice(ptr,e)).toString("utf8"); }
const imp={}; for(const i of WebAssembly.Module.imports(m)){ (imp[i.module]=imp[i.module]||{})[i.name]=()=>0n; }
imp.env=imp.env||{};
imp.env.host_emit=(p)=>{ const ptr=typeof p==="bigint"?Number(BigInt.asUintN(32,p)):p; captured=readCStr(ptr); return 0n; };
const inst=new WebAssembly.Instance(m,imp); mem=inst.exports.memory; inst.exports.render();
process.exit(captured==="Hello from NOVA!"?0:1);
' && echo "PASS wasm_render (NOVA-built string crosses wasm->JS host: Hello from NOVA!)" || echo "FAIL wasm_render"
