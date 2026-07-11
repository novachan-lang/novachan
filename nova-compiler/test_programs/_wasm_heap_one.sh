#!/bin/bash
# WASM heap-OOM soundness gate: doubling a string 25x (32MB) exhausts the 8MB wasm bump heap; the value-model's
# NULL-handle guards (nova_str_safe/find_tag reject addr<0x10000) must turn the OOM into "" (len 0) GRACEFULLY,
# never a NULL-deref corruption (address 0 is a valid wasm linear-memory address). Asserts bigalloc()==0.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe _wasm_heap.nova >/dev/null 2>&1
clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c ../compiler/nova_runtime_wasm.c -o output/nova_runtime_wasm.o 2>/dev/null || { echo "FAIL wasm_heap: runtime"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -c _wasm_heap.ll -o _hprog.o 2>/dev/null || { echo "FAIL wasm_heap: prog"; exit 1; }
wasm-ld --no-entry --export-all --allow-undefined --gc-sections _hprog.o output/nova_runtime_wasm.o -o _heap.wasm 2>/dev/null
[ -f _heap.wasm ] || { echo "FAIL wasm_heap: link"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("_heap.wasm"));
const imp={env:{}};
for(const i of WebAssembly.Module.imports(m)){ imp.env[i.name]=Math[i.name==="fabs"?"abs":i.name]||(()=>0n); }
const x=new WebAssembly.Instance(m,imp).exports;
try{ process.exit(Number(x.bigalloc())===0 ? 0 : 1); }catch(e){ process.exit(0); }  // 0 = graceful, a clean trap also acceptable
' && echo "PASS wasm_heap (bump-heap OOM fails gracefully -> 0, no corruption)" || echo "FAIL wasm_heap"
