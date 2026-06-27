#!/bin/bash
# NOVA loop building a LARGE list (100 elems, forcing the wasm runtime's growable list to double 8->128) then
# summing -> real wasm -> node. Proves loops + larger-than-initial-cap data run in wasm. bigsum=sum(0..99)=4950.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe wasm_loop_demo.nova >/dev/null 2>&1
[ -f wasm_loop_demo.ll ] || { echo "FAIL forge_wasm_loop: NOVA->LLVM failed"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -Wl,--no-entry -Wl,--export-all -Wl,--allow-undefined wasm_loop_demo.ll _wrt_min.c -o wasm_loop_demo.wasm 2>/dev/null
[ -f wasm_loop_demo.wasm ] || { echo "FAIL forge_wasm_loop: wasm link failed"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("wasm_loop_demo.wasm"));
const imp={}; for(const i of WebAssembly.Module.imports(m)){(imp[i.module]=imp[i.module]||{})[i.name]=()=>0n;}
const x=new WebAssembly.Instance(m,imp).exports;
const v=x.bigsum();
console.log("bigsum="+v);
process.exit(v===4950n?0:1);
' && echo "PASS forge_wasm_loop (NOVA loop builds a 100-elem list (growable) + sums -> real wasm -> node = 4950)" || echo "FAIL forge_wasm_loop"
