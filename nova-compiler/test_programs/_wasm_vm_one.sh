#!/bin/bash
# WASM value-model + control-flow gate: a NOVA program that BUILDS heap values (string concat, list, dict,
# struct) and runs control flow (while-loop sum, list indexing) executes in node WebAssembly with correct
# results, linked against the FULL value-model runtime (output/nova_runtime_wasm.c under NOVA_FREESTANDING).
# Proves strings/lists/dicts/structs + loops + index access run in wasm. -fno-builtin mandatory.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe _wasm_strbuild.nova >/dev/null 2>&1
[ -f _wasm_strbuild.ll ] || { echo "FAIL wasm_vm: NOVA->LLVM failed"; exit 1; }
clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c output/nova_runtime_wasm.c -o output/nova_runtime_wasm.o 2>/dev/null || { echo "FAIL wasm_vm: runtime wasm compile"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -c _wasm_strbuild.ll -o _prog.o 2>/dev/null || { echo "FAIL wasm_vm: prog wasm compile"; exit 1; }
wasm-ld --no-entry --export-all --allow-undefined --gc-sections _prog.o output/nova_runtime_wasm.o -o _strbuild.wasm 2>/dev/null
[ -f _strbuild.wasm ] || { echo "FAIL wasm_vm: wasm link failed"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("_strbuild.wasm"));
const imp={}; for(const i of WebAssembly.Module.imports(m)){(imp[i.module]=imp[i.module]||{})[i.name]=()=>0n;}
const x=new WebAssembly.Instance(m,imp).exports;
const want={strbuild:3n,listlen:4n,dictlen:3n,structfield:42n,loopsum:55n,listindex:15n};
let ok=true; for(const k in want){ if(x[k]()!==want[k]) ok=false; }
process.exit(ok?0:1);
' && echo "PASS wasm_vm (value-model+control-flow in wasm: str=3 list=4 dict=3 struct=42 loop=55 index=15)" || echo "FAIL wasm_vm (wrong results)"
