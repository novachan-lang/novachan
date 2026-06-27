#!/bin/bash
# NOVA DICT ops -> real wasm via the minimal runtime (_wrt_min.c: linear (key,val) pairs, string-key compare
# via len_any). Proves a NOVA fn that BUILDS + LOOKS UP a dict runs in wasm. Honest scope: fixed-cap, linear
# scan, string keys; hashed dicts + len_any/keys/values ON a dict value need the value-model carve. -fno-builtin.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe wasm_dict_demo.nova >/dev/null 2>&1
[ -f wasm_dict_demo.ll ] || { echo "FAIL forge_wasm_dict: NOVA->LLVM failed"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -Wl,--no-entry -Wl,--export-all -Wl,--allow-undefined wasm_dict_demo.ll _wrt_min.c -o wasm_dict_demo.wasm 2>/dev/null
[ -f wasm_dict_demo.wasm ] || { echo "FAIL forge_wasm_dict: wasm link failed"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("wasm_dict_demo.wasm"));
const imp={}; for(const i of WebAssembly.Module.imports(m)){(imp[i.module]=imp[i.module]||{})[i.name]=()=>0n;}
const x=new WebAssembly.Instance(m,imp).exports;
const v=x.dval();
console.log("dval="+v);
process.exit(v===16n?0:1);
' && echo "PASS forge_wasm_dict (NOVA dict build+lookup -> real wasm -> node: d[a]=7,d[b]=9 -> 16)" || echo "FAIL forge_wasm_dict"
