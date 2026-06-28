#!/bin/bash
# WASM frontend IN-direction gate (event/form-input path): JS writes a string into wasm linear memory via the
# exported wasm_alloc, a NOVA fn receives it as a `string` and processes it with the value-model -- echo_len
# returns its length, echo_upper sends an UPPERCASED copy back out via host_emit. Proves the JS->NOVA->JS string
# round-trip. Linked with output/nova_runtime_wasm.o. -fno-builtin mandatory.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe _wasm_strin.nova >/dev/null 2>&1
[ -f _wasm_strin.ll ] || { echo "FAIL wasm_strin: NOVA->LLVM"; exit 1; }
clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c output/nova_runtime_wasm.c -o output/nova_runtime_wasm.o 2>/dev/null || { echo "FAIL wasm_strin: runtime"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -c _wasm_strin.ll -o _sprog.o 2>/dev/null || { echo "FAIL wasm_strin: prog"; exit 1; }
wasm-ld --no-entry --export-all --allow-undefined --gc-sections _sprog.o output/nova_runtime_wasm.o -o _strin.wasm 2>/dev/null
[ -f _strin.wasm ] || { echo "FAIL wasm_strin: link"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("_strin.wasm"));
let mem=null, captured=null;
function readCStr(p){ const u=new Uint8Array(mem.buffer); let o=Number(BigInt.asUintN(32,BigInt(p))),e=o; while(u[e]!==0&&e<u.length)e++; return Buffer.from(u.subarray(o,e)).toString("utf8"); }
const imp={}; for(const i of WebAssembly.Module.imports(m)){ (imp[i.module]=imp[i.module]||{})[i.name]=()=>0n; }
imp.env=imp.env||{}; imp.env.host_emit=(p)=>{ captured=readCStr(p); return 0n; };
const x=new WebAssembly.Instance(m,imp).exports; mem=x.memory;
const ptr=Number(x.wasm_alloc(16));
const u8=new Uint8Array(mem.buffer); const b=Buffer.from("hello","utf8"); b.copy(u8,ptr); u8[ptr+b.length]=0;
const len=Number(x.echo_len(BigInt(ptr))); x.echo_upper(BigInt(ptr));
process.exit((len===5 && captured==="HELLO")?0:1);
' && echo "PASS wasm_strin (JS->wasm string: echo_len(hello)=5, echo_upper->HELLO)" || echo "FAIL wasm_strin"
