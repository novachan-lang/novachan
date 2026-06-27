#!/bin/bash
# NOVA -> REAL WebAssembly -> node. The NOVA compiler emits LLVM IR; for the native-compute subset (fns the
# type-specializer lowers to native i64/f64 ops, with NO runtime calls) that IR compiles straight to wasm32
# via `clang --target=wasm32`, and runs in node's WASM engine (V8 -- the same engine browsers use). This is
# the first REAL increment of the WASM frontend (previously absent; the runtime only had a wasm LOADER).
# SCOPE: pure scalar compute works today; strings/lists/dicts/IO need a wasm port of nova_runtime.c (the
# nova_rt_* fns use malloc/sockets/threads -> here they become unused dummy imports). Tracked.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe wasm_demo.nova >/dev/null 2>&1
[ -f wasm_demo.ll ] || { echo "FAIL forge_wasm: NOVA->LLVM compile failed"; exit 1; }
clang --target=wasm32 -O2 -nostdlib -Wl,--no-entry -Wl,--export-all -Wl,--allow-undefined wasm_demo.ll -o wasm_demo.wasm 2>/dev/null
[ -f wasm_demo.wasm ] || { echo "FAIL forge_wasm: LLVM->wasm32 link failed"; exit 1; }
R=$(node _wrun.js 2>&1)
echo "$R" | grep -vE "^WASM-(PASS|FAIL)$"
if echo "$R" | grep -q "WASM-PASS"; then
    echo "PASS forge_wasm (NOVA pure-scalar fns -> real WebAssembly -> run in node V8: add=5, mul=20, poly=43)"
else
    echo "FAIL forge_wasm (wasm ran but produced wrong values)"
fi
