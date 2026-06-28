#!/bin/bash
# Full-stack gate: Forge (NOVA backend) serves the NOVA-compiled wasm FRONTEND -- GET / -> the counter HTML,
# GET /counter.wasm -> the wasm with application/wasm (binary-safe via forge.file's read_bytes+resp_bytes path).
# Rebuilds the wasm first so _counter.wasm exists. ONE language, front + back. Kill-on-timeout via _fdb_one.
cd "$(dirname "$0")" || exit 1
[ -f _counter.wasm ] || { clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c output/nova_runtime_wasm.c -o output/nova_runtime_wasm.o 2>/dev/null; ./gen3_test.exe _wasm_counter.nova >/dev/null 2>&1; clang --target=wasm32 -O2 -fno-builtin -nostdlib -c _wasm_counter.ll -o _cprog.o 2>/dev/null; wasm-ld --no-entry --export-all --allow-undefined --gc-sections _cprog.o output/nova_runtime_wasm.o -o _counter.wasm 2>/dev/null; }
powershell -NoProfile -ExecutionPolicy Bypass -File ./_fdb_one.ps1 _forge_wasm_demo 2>&1 | grep -qE "PASS forge_wasm_demo" && echo "PASS forge_wasm_demo (Forge serves the NOVA wasm frontend: html + application/wasm)" || echo "FAIL forge_wasm_demo"
