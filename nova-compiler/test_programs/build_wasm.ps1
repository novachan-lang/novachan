# Build a NOVA program to WebAssembly.
# Usage: .\build_wasm.ps1 <program.nova>
#
# Produces <program>.wasm. Runs via:
#   node wasm_run.js <program>.wasm
#
# Limitations: pure-compute programs only (no IO, threads, networking).
# The wasm runtime stub provides math/arith, everything else is a no-op.

param([Parameter(Mandatory)][string]$Source)

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$base = [System.IO.Path]::GetFileNameWithoutExtension($Source)
$ll = "$base.ll"
$wasmLl = "${base}_wasm.ll"
$wasm = "$base.wasm"

# 1. NOVA -> .ll
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments $Source -TimeoutMs 60000
if ($cr.ExitCode -ne 0) {
    Write-Host "compile failed"
    if ($cr.StdOut) { Write-Host $cr.StdOut }
    exit 1
}

# 2. Patch .ll for WASM compatibility
(Get-Content $ll) `
    -replace 'thread_local global', 'global' `
    -replace 'target datalayout.*', 'target triple = "wasm32-unknown-wasi"' `
    | Set-Content $wasmLl

# 3. clang + wasm runtime stub -> .wasm
$ClangPath = (Get-Command clang -ErrorAction SilentlyContinue).Source
$clangArgs = @(
    "--target=wasm32-wasip1",
    "-O2",
    "-nostdlib",
    "-Wl,--no-entry",
    "-Wl,--allow-undefined",
    "-Wl,--export=nova_user_main",
    "-o", $wasm,
    $wasmLl,
    "nova_runtime_wasm.c"
)
& $ClangPath @clangArgs 2>$null
if (-not (Test-Path $wasm)) {
    Write-Host "wasm link failed"
    exit 1
}

$wasmSize = (Get-Item $wasm).Length
Write-Host "Built $wasm ($wasmSize bytes)"
Write-Host "Run: node wasm_run.js $wasm"

Remove-Item "nova_runtime.c", $wasmLl -Force -ErrorAction SilentlyContinue
