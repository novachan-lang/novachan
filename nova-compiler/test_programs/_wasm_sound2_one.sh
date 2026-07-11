#!/bin/bash
# WASM soundness batch 2 gate: recursion (fib 28), a 10k loop, bitwise (&|^<<>>), signed div/mod, and string
# ops (len/find) all compute the SAME in wasm as native. Real math imports + trap-on-unknown catches any new
# undefined compiler-rt builtin. Expected (== native): recur=317811 bigsum=49995000 bitops=639900 signed=-7301 strops=23012.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe _wasm_sound2.nova >/dev/null 2>&1
clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c ../compiler/nova_runtime_wasm.c -o output/nova_runtime_wasm.o 2>/dev/null || { echo "FAIL wasm_sound2: runtime"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -c _wasm_sound2.ll -o _s2prog.o 2>/dev/null || { echo "FAIL wasm_sound2: prog"; exit 1; }
wasm-ld --no-entry --export-all --allow-undefined --gc-sections _s2prog.o output/nova_runtime_wasm.o -o _sound2.wasm 2>/dev/null
[ -f _sound2.wasm ] || { echo "FAIL wasm_sound2: link"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("_sound2.wasm"));
const M={sin:Math.sin,cos:Math.cos,tan:Math.tan,sqrt:Math.sqrt,pow:Math.pow,log:Math.log,exp:Math.exp,fabs:Math.abs,floor:Math.floor,ceil:Math.ceil,round:Math.round,fmod:(a,b)=>a%b,fmax:Math.max,fmin:Math.min,atan:Math.atan,atan2:Math.atan2,asin:Math.asin,acos:Math.acos,log2:Math.log2,log10:Math.log10,sinh:Math.sinh,cosh:Math.cosh,tanh:Math.tanh,cbrt:Math.cbrt,hypot:Math.hypot};
const imp={env:{}};
for(const i of WebAssembly.Module.imports(m)){ imp.env[i.name]=M[i.name]||(()=>{throw new Error("UNDEF IMPORT: "+i.name);}); }
const x=new WebAssembly.Instance(m,imp).exports;
const exp={recur:317811n,bigsum:49995000n,bitops:639900n,signed:-7301n,strops:23012n};
let ok=true; for(const k in exp){ if(x[k]()!==exp[k]) ok=false; }
process.exit(ok?0:1);
' && echo "PASS wasm_sound2 (recursion/bigloop/bitwise/signed/string sound in wasm)" || echo "FAIL wasm_sound2"
