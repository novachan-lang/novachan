#!/bin/bash
# Capstone compute kernels: recursion (fibonacci) + a loop (sum of squares), pure native -> real wasm -> node
# V8. No runtime needed (the specializer lowers everything to native ops). fib(20)=6765, sumsq(10)=385.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe wasm_kernel_demo.nova >/dev/null 2>&1
[ -f wasm_kernel_demo.ll ] || { echo "FAIL forge_wasm_kernel: NOVA->LLVM failed"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -Wl,--no-entry -Wl,--export-all -Wl,--allow-undefined wasm_kernel_demo.ll -o wasm_kernel_demo.wasm 2>/dev/null
[ -f wasm_kernel_demo.wasm ] || { echo "FAIL forge_wasm_kernel: wasm link failed"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("wasm_kernel_demo.wasm"));
const imp={}; for(const i of WebAssembly.Module.imports(m)){(imp[i.module]=imp[i.module]||{})[i.name]=()=>0n;}
const x=new WebAssembly.Instance(m,imp).exports;
const f=x.fib(20n), s=x.sumsq(10n);
console.log("fib(20)="+f+" sumsq(10)="+s);
process.exit((f===6765n && s===385n)?0:1);
' && echo "PASS forge_wasm_kernel (NOVA recursion+loop kernels -> real wasm -> node V8: fib(20)=6765, sumsq(10)=385)" || echo "FAIL forge_wasm_kernel"
