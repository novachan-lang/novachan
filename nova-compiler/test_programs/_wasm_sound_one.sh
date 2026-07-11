#!/bin/bash
# WASM soundness gate: f64 arithmetic, a math host-import (sqrt via Math.sqrt), the integer div/mod identity,
# and an out-of-bounds read all compute the SAME in wasm as native (oob = the sound 0-guard, not a wild read).
# The node harness provides REAL math imports and TRAPS any other import -> a future undefined compiler-rt
# builtin (like the __multi3 bug) FAILS LOUD here instead of silently computing wrong.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe _wasm_sound.nova >/dev/null 2>&1
clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c ../compiler/nova_runtime_wasm.c -o output/nova_runtime_wasm.o 2>/dev/null || { echo "FAIL wasm_sound: runtime"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -c _wasm_sound.ll -o _soprog.o 2>/dev/null || { echo "FAIL wasm_sound: prog"; exit 1; }
wasm-ld --no-entry --export-all --allow-undefined --gc-sections _soprog.o output/nova_runtime_wasm.o -o _sound.wasm 2>/dev/null
[ -f _sound.wasm ] || { echo "FAIL wasm_sound: link"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("_sound.wasm"));
const M={sin:Math.sin,cos:Math.cos,tan:Math.tan,asin:Math.asin,acos:Math.acos,atan:Math.atan,atan2:Math.atan2,log:Math.log,log2:Math.log2,log10:Math.log10,exp:Math.exp,fabs:Math.abs,fmod:(a,b)=>a%b,round:Math.round,sqrt:Math.sqrt,pow:Math.pow,sinh:Math.sinh,cosh:Math.cosh,tanh:Math.tanh,cbrt:Math.cbrt,hypot:Math.hypot,floor:Math.floor,ceil:Math.ceil,fmax:Math.max,fmin:Math.min};
const imp={env:{}};
for(const i of WebAssembly.Module.imports(m)){ imp.env[i.name]=M[i.name]||(()=>{throw new Error("UNDEFINED IMPORT CALLED: "+i.name);}); }
const x=new WebAssembly.Instance(m,imp).exports;
const ok = Number(x.float_ok())===1 && Number(x.sqrt_ok())===1 && Number(x.divmod_ok())===1 && Number(x.oob_index())===0;
process.exit(ok?0:1);
' && echo "PASS wasm_sound (float/math/divmod/OOB sound in wasm; trap-on-unknown-import armed)" || echo "FAIL wasm_sound"
