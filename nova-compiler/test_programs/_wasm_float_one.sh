#!/bin/bash
# NOVA FLOAT compute -> real wasm via native f64 (fmul/fadd). Float params/results cross the JS boundary as
# raw f64 BITS (the compiler unboxes via nova_rt_unbox = passthrough in the minimal runtime). node converts
# via DataView (f64<->BigInt bits). GATE: fma(2,3,1)=7.0, fsum(1.5,2.5,3,4)=11.0. -fno-builtin.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe wasm_float_demo.nova >/dev/null 2>&1
[ -f wasm_float_demo.ll ] || { echo "FAIL forge_wasm_float: NOVA->LLVM failed"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -Wl,--no-entry -Wl,--export-all -Wl,--allow-undefined wasm_float_demo.ll _wrt_min.c -o wasm_float_demo.wasm 2>/dev/null
[ -f wasm_float_demo.wasm ] || { echo "FAIL forge_wasm_float: wasm link failed"; exit 1; }
node -e '
const fs=require("fs");
const dv=new DataView(new ArrayBuffer(8));
const f2b=x=>{dv.setFloat64(0,x,true);return dv.getBigInt64(0,true);};
const b2f=b=>{dv.setBigInt64(0,b,true);return dv.getFloat64(0,true);};
const m=new WebAssembly.Module(fs.readFileSync("wasm_float_demo.wasm"));
const imp={}; for(const i of WebAssembly.Module.imports(m)){(imp[i.module]=imp[i.module]||{})[i.name]=()=>0n;}
const x=new WebAssembly.Instance(m,imp).exports;
const a=b2f(x.fma(f2b(2.0),f2b(3.0),f2b(1.0)));
const s=b2f(x.fsum(f2b(1.5),f2b(2.5),f2b(3.0),f2b(4.0)));
console.log("fma(2,3,1)="+a+" fsum(1.5,2.5,3,4)="+s);
process.exit((a===7.0 && s===11.0)?0:1);
' && echo "PASS forge_wasm_float (NOVA native-f64 compute -> real wasm -> node: fma=7.0, fsum=11.0)" || echo "FAIL forge_wasm_float"
