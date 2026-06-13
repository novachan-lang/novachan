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
    Invoke-Timed -FilePath "$LLVM\wasm-ld.exe" -Arguments "--no-entry --export=$exportFn --export=__heap_base --allow-undefined --gc-sections $src.o -o $src.wasm" -TimeoutMs 60000 | Out-Null
    if (!(Test-Path "$src.wasm")) { Write-Host "  FAIL: wasm-ld $src"; return $false }
    return $true
}

# Build + run a program NATIVELY (for cross-checking the wasm output).
function Run-Native($src) {
    $r = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "$src.nova" -TimeoutMs 60000
    if ($r.ExitCode -ne 0) { return $null }
    Invoke-Timed -FilePath "$LLVM\clang.exe" -Arguments "-O2 -o $src`_n.exe $src.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 | Out-Null
    if (!(Test-Path "$src`_n.exe")) { return $null }
    $n = Invoke-Timed -FilePath (Resolve-Path ".\$src`_n.exe").Path -Arguments "" -TimeoutMs 20000
    if ($n.TimedOut) { return $null }
    return $n.StdOut
}
# Normalize output to a comparable form (trimmed non-empty lines).
function Norm($s) { (($s -split "`r?`n") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }) -join "`n" }

# Run a linear-memory program in wasm (reusable runtime) AND native; pass iff outputs match.
function Wasm-VsNative($label, $src) {
    $nativeOut = Run-Native $src
    if ($null -eq $nativeOut) { Write-Host "  $label : native build/run FAIL"; return $false }
    if (-not (Build-Wasm $src "nova_user_main")) { return $false }
    $w = Invoke-Timed -FilePath $NODE -Arguments "_wasm_load.cjs $src.wasm" -TimeoutMs 30000
    if ($w.ExitCode -ne 0) { Write-Host "  $label : wasm run FAIL"; Write-Host $w.StdErr; return $false }
    if ((Norm $w.StdOut) -eq (Norm $nativeOut)) {
        Write-Host ("  $label : wasm == native  [" + ((Norm $w.StdOut) -split "`n" | Select-Object -First 1) + " ...]")
        return $true
    } else {
        Write-Host "  $label : MISMATCH"; Write-Host ("    native: " + (Norm $nativeOut)); Write-Host ("    wasm:   " + (Norm $w.StdOut)); return $false
    }
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

# M3 — a real loop computing in wasm + a DYNAMIC string printed via a JS-hosted runtime
if (Build-Wasm "wasm_m3" "nova_user_main") {
    $n = Invoke-Timed -FilePath $NODE -Arguments "_wasm_m3_run.cjs" -TimeoutMs 30000
    Write-Host ("  M3: " + $n.StdOut.Trim())
    if ($n.ExitCode -ne 0) { $fail = 1 }
} else { $fail = 1 }

# M4 — a REAL list-using algorithm (Sieve of Eratosthenes, n=1000 -> 168 primes) runs
# in wasm via a JS-MANAGED LINEAR-MEMORY runtime (bump heap + list_create/append over
# instance.exports.memory; the list lives in wasm linear memory, indexed by inlined wasm).
if (Build-Wasm "wasm_sieve" "nova_user_main") {
    $n = Invoke-Timed -FilePath $NODE -Arguments "_wasm_sieve_run.cjs" -TimeoutMs 30000
    Write-Host ("  M4: " + ($n.StdOut.Trim().Split([char]10) | Select-Object -Last 1))
    if ($n.ExitCode -ne 0) { $fail = 1 }
} else { $fail = 1 }

# M5 — a real STRING program (reverse + concat-in-loop + len) via the REUSABLE runtime,
# cross-checked against a native NOVA run (output must be byte-identical).
if (-not (Wasm-VsNative "M5(strings)" "wasm_strs")) { $fail = 1 }

# M6 — a real FLOAT program (harmonic series + average) via the reusable runtime,
# cross-checked against native (verifies float-to-str formatting matches exactly).
if (-not (Wasm-VsNative "M6(floats)" "wasm_floats")) { $fail = 1 }

Remove-Item wasm_m1.ll,wasm_m1.o,wasm_m1.wasm,wasm_m2.ll,wasm_m2.o,wasm_m2.wasm,wasm_m3.ll,wasm_m3.o,wasm_m3.wasm,wasm_sieve.ll,wasm_sieve.o,wasm_sieve.wasm,wasm_strs.ll,wasm_strs.o,wasm_strs.wasm,wasm_strs_n.exe,wasm_floats.ll,wasm_floats.o,wasm_floats.wasm,wasm_floats_n.exe -ErrorAction SilentlyContinue
if ($fail -eq 0) { Write-Host "WASM MILESTONES OK: f64+call, static-string, loop+dynamic-string, list-sieve, AND real string + float programs (reusable runtime, output == native) run in wasm32" } else { Write-Host "WASM MILESTONE FAILURE"; exit 1 }
