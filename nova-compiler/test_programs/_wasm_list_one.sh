#!/bin/bash
# NOVA LIST ops -> real wasm via the minimal runtime (_wrt_min.c: heap list_create/append/get + raw-int add).
# Proves a NOVA fn that BUILDS + INDEXES a list runs in wasm. List struct {i64 data,size,cap}; the compiler
# reads list size INLINE at handle+8. Honest scope: fixed-cap lists, int elements, list len via the inline
# read (len_any on a list needs find_tag tag-disambiguation = the value-model carve). ALWAYS -fno-builtin.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe wasm_list_demo.nova >/dev/null 2>&1
[ -f wasm_list_demo.ll ] || { echo "FAIL forge_wasm_list: NOVA->LLVM failed"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -Wl,--no-entry -Wl,--export-all -Wl,--allow-undefined wasm_list_demo.ll _wrt_min.c -o wasm_list_demo.wasm 2>/dev/null
[ -f wasm_list_demo.wasm ] || { echo "FAIL forge_wasm_list: wasm link failed"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("wasm_list_demo.wasm"));
const imp={}; for(const i of WebAssembly.Module.imports(m)){(imp[i.module]=imp[i.module]||{})[i.name]=()=>0n;}
const x=new WebAssembly.Instance(m,imp).exports;
const a=x.llen(), b=x.lsum();
console.log("llen="+a+" lsum="+b);
process.exit((a===3n && b===60n)?0:1);
' && echo "PASS forge_wasm_list (NOVA list build+index -> real wasm -> node: llen([10,20,30])=3, lsum=60)" || echo "FAIL forge_wasm_list"
