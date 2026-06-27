#!/bin/bash
# NOVA string-LITERAL ops -> real wasm via a MINIMAL runtime (_wrt_min.c provides nova_rt_len_any = strlen).
# Proves a NOVA fn USING a string runs in wasm (beyond pure scalar). Heap string BUILDING (create_string/
# concat) + lists/dicts need the value-model port (tracked: NOVA_DESIGN/WASM_RUNTIME_PORT.md). NOTE:
# -fno-builtin so clang doesn't rewrite the runtime's strlen loop into an (undefined) libc strlen import.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe wasm_str_demo.nova >/dev/null 2>&1
[ -f wasm_str_demo.ll ] || { echo "FAIL forge_wasm_str: NOVA->LLVM failed"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -Wl,--no-entry -Wl,--export-all -Wl,--allow-undefined wasm_str_demo.ll _wrt_min.c -o wasm_str_demo.wasm 2>/dev/null
[ -f wasm_str_demo.wasm ] || { echo "FAIL forge_wasm_str: wasm link failed"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("wasm_str_demo.wasm"));
const imp={}; for(const i of WebAssembly.Module.imports(m)){(imp[i.module]=imp[i.module]||{})[i.name]=()=>0n;}
const x=new WebAssembly.Instance(m,imp).exports;
const h=x.hello_len(), c=x.combined();
console.log("hello_len="+h+" combined="+c);
process.exit((h===5n && c===14n)?0:1);
' && echo "PASS forge_wasm_str (NOVA string-literal len -> real wasm -> node: hello_len=5, combined=14)" || echo "FAIL forge_wasm_str"
