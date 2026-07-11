#!/bin/bash
# WASM i128-correctness gate: a tight scalar-int loop that -O2 closed-forms into the polynomial sum, needing
# i128 intermediates (__multi3). Verifies the wasm value-model computes the SAME result as native, i.e. the
# compiler-rt i128 builtins are present + correct. Without __multi3 in nova_runtime_wasm.c the optimizer's
# __multi3 import gets stubbed -> WRONG result; this gate catches that regression.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe _wasm_bench.nova >/dev/null 2>&1
clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c ../compiler/nova_runtime_wasm.c -o output/nova_runtime_wasm.o 2>/dev/null || { echo "FAIL wasm_bench: runtime"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -c _wasm_bench.ll -o _bprog.o 2>/dev/null || { echo "FAIL wasm_bench: prog"; exit 1; }
wasm-ld --no-entry --export-all --allow-undefined --gc-sections _bprog.o output/nova_runtime_wasm.o -o _bench.wasm 2>/dev/null
[ -f _bench.wasm ] || { echo "FAIL wasm_bench: link"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("_bench.wasm"));
const imp={}; for(const i of WebAssembly.Module.imports(m)){ (imp[i.module]=imp[i.module]||{})[i.name]=()=>0n; }
const x=new WebAssembly.Instance(m,imp).exports;
process.exit(x.bench(30000000n).toString()==="-2011557970256188608"?0:1);
' && echo "PASS wasm_bench (i128 builtins correct: bench matches native)" || echo "FAIL wasm_bench (i128 wrong)"
