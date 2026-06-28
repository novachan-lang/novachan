#!/bin/bash
# WASM value-model MILESTONE gate: a NOVA program that BUILDS heap values (string concat + list literal + dict
# literal) and measures them runs in node WebAssembly with correct lengths, linked against the FULL value-model
# runtime (output/nova_runtime_wasm.c -> nova_runtime.c under NOVA_FREESTANDING). Proves the HEAP value-model
# (strings/lists/dicts, not just scalars/string-literals) executes in wasm. -fno-builtin is mandatory.
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
const sb=x.strbuild(), ll=x.listlen(), dl=x.dictlen();
process.exit((sb===3n && ll===4n && dl===3n)?0:1);
' && echo "PASS wasm_vm (heap value-model in wasm: string concat=3, list=4, dict=3)" || echo "FAIL wasm_vm (wrong lengths)"
