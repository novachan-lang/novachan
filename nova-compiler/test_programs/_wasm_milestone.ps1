# WASM milestones — proves NOVA -> LLVM IR -> wasm32 -> runs in a browser-class
# runtime (Node's WebAssembly) for REAL programs, not just the legacy i32 interpreter.
#
#   M1: f64 arithmetic + a function call  (compute(1.5,2.5) = 5.25)   [pure SSA, 1 import]
#   M2: a static string + print           ("hello from wasm")         [data section + linear
#                                                                        memory + an I/O import]
#
# Pipeline: gen3_test.exe compile <f> --target wasm  ->  clang --target=wasm32 -O2 -c
#           ->  wasm-ld --no-entry --export=<fn> --gc-sections  ->  node WebAssembly.instantiate
#
# Requires clang (wasm32) + wasm-ld + node. Kept OUT of the native 407 regression so that
# suite needs no wasm toolchain; run this on demand to verify the wasm path end-to-end.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
$LLVM = "C:\Program Files\LLVM\bin"
$NODE = (Get-Command node).Source
$fail = 0

function Build-Wasm($src, $exportFn) {
    $r = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile $src.nova --target wasm" -TimeoutMs 60000
    if ($r.ExitCode -ne 0) { Write-Host "  FAIL: NOVA compile $src (exit=$($r.ExitCode))"; return $false }
    Invoke-Timed -FilePath "$LLVM\clang.exe" -Arguments "--target=wasm32 -O2 -c $src.ll -o $src.o" -TimeoutMs 60000 | Out-Null
    if (!(Test-Path "$src.o")) { Write-Host "  FAIL: clang wasm32 $src"; return $false }
    Invoke-Timed -FilePath "$LLVM\wasm-ld.exe" -Arguments "--no-entry --export=$exportFn --allow-undefined --gc-sections $src.o -o $src.wasm" -TimeoutMs 60000 | Out-Null
    if (!(Test-Path "$src.wasm")) { Write-Host "  FAIL: wasm-ld $src"; return $false }
    return $true
}

# M1 — f64 + function call
if (Build-Wasm "wasm_m1" "compute") {
    $n = Invoke-Timed -FilePath $NODE -Arguments "_wasm_run.cjs" -TimeoutMs 30000
    Write-Host ("  M1: " + $n.StdOut.Trim())
    if ($n.ExitCode -ne 0) { $fail = 1 }
} else { $fail = 1 }

# M2 — static string + print
if (Build-Wasm "wasm_m2" "nova_user_main") {
    $n = Invoke-Timed -FilePath $NODE -Arguments "_wasm_m2_run.cjs" -TimeoutMs 30000
    Write-Host ("  M2: " + $n.StdOut.Trim())
    if ($n.ExitCode -ne 0) { $fail = 1 }
} else { $fail = 1 }

Remove-Item wasm_m1.ll,wasm_m1.o,wasm_m1.wasm,wasm_m2.ll,wasm_m2.o,wasm_m2.wasm -ErrorAction SilentlyContinue
if ($fail -eq 0) { Write-Host "WASM MILESTONES OK: NOVA f64+call AND static-string+print run in wasm32" } else { Write-Host "WASM MILESTONE FAILURE"; exit 1 }
