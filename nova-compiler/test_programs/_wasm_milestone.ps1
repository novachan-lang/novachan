# WASM milestone 1 — proves NOVA -> LLVM IR -> wasm32 -> runs in a browser-class
# runtime (Node's WebAssembly) for REAL computation (f64 arithmetic + a function
# call), not just the legacy i32 interpreter. Reproducible end-to-end check.
#
# Pipeline: gen3_test.exe compile <f> --target wasm  ->  clang --target=wasm32 -O2 -c
#           ->  wasm-ld --no-entry --export --gc-sections  ->  node WebAssembly.instantiate
#
# Requires: clang (wasm32 target), wasm-ld, node. Kept OUT of the native 407 regression
# so that suite needs no wasm toolchain; run this on demand to verify the wasm path.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
$LLVM = "C:\Program Files\LLVM\bin"
$src = "wasm_m1"

# 1) NOVA -> wasm32 LLVM IR
$r = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile $src.nova --target wasm" -TimeoutMs 60000
if ($r.ExitCode -ne 0) { Write-Host "FAIL: NOVA compile (exit=$($r.ExitCode))"; exit 1 }

# 2) IR -> wasm object (-O2 promotes the alloca slots so compute is pure SSA f64)
$o = Invoke-Timed -FilePath "$LLVM\clang.exe" -Arguments "--target=wasm32 -O2 -c $src.ll -o $src.o" -TimeoutMs 60000
if (!(Test-Path "$src.o")) { Write-Host "FAIL: clang wasm32 compile"; Write-Host $o.StdErr; exit 1 }

# 3) link -> .wasm (gc-sections strips main/nova_main + their runtime refs; only the
#    exported compute + its one import survive)
$w = Invoke-Timed -FilePath "$LLVM\wasm-ld.exe" -Arguments "--no-entry --export=compute --allow-undefined --gc-sections $src.o -o $src.wasm" -TimeoutMs 60000
if (!(Test-Path "$src.wasm")) { Write-Host "FAIL: wasm-ld"; Write-Host $w.StdErr; exit 1 }

# 4) run in Node, verify the f64 result
$n = Invoke-Timed -FilePath (Get-Command node).Source -Arguments "_wasm_run.cjs" -TimeoutMs 30000
Write-Host $n.StdOut.Trim()
if ($n.ExitCode -ne 0) { Write-Host "FAIL: wasm result mismatch / node error"; Write-Host $n.StdErr; exit 1 }
Write-Host "WASM MILESTONE 1 OK: NOVA f64+call -> wasm32 -> Node = correct"
# cleanup generated artifacts (the .nova + scripts are the committed sources)
Remove-Item "$src.ll","$src.o","$src.wasm" -ErrorAction SilentlyContinue
