#!/bin/bash
# Capstone: ONE NOVA fn using all 4 value types -- list (nums[i]), dict (d["base"]), string build ("ab"+"cde"),
# scalar compute -- compiled to a single wasm module and run in node. combo = 60 (list) + 100 (dict) + 5 (strlen) = 165.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe wasm_combo_demo.nova >/dev/null 2>&1
[ -f wasm_combo_demo.ll ] || { echo "FAIL forge_wasm_combo: NOVA->LLVM failed"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -Wl,--no-entry -Wl,--export-all -Wl,--allow-undefined wasm_combo_demo.ll _wrt_min.c -o wasm_combo_demo.wasm 2>/dev/null
[ -f wasm_combo_demo.wasm ] || { echo "FAIL forge_wasm_combo: wasm link failed"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("wasm_combo_demo.wasm"));
const imp={}; for(const i of WebAssembly.Module.imports(m)){(imp[i.module]=imp[i.module]||{})[i.name]=()=>0n;}
const x=new WebAssembly.Instance(m,imp).exports;
const v=x.combo();
console.log("combo="+v);
process.exit(v===165n?0:1);
' && echo "PASS forge_wasm_combo (ONE NOVA fn: list+dict+string+compute -> real wasm -> node = 165)" || echo "FAIL forge_wasm_combo"
