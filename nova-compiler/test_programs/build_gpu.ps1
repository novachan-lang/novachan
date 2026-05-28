# Compile a NOVA program to NVPTX (NVIDIA GPU) assembly.
# Usage: .\build_gpu.ps1 <program.nova>
#
# Produces <program>.ptx — NVIDIA's GPU assembly format.
# This demonstrates the LLVM->GPU compilation path. Actually launching
# the kernel on a GPU requires CUDA runtime integration (host code that
# calls cuLaunchKernel etc.), which is the next layer up.
#
# Limitations:
# - The NOVA program must be pure-compute (no IO/threads/runtime calls).
# - The output is NVPTX assembly, not a launchable kernel.

param([Parameter(Mandatory)][string]$Source)

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$base = [System.IO.Path]::GetFileNameWithoutExtension($Source)
$ll = "$base.ll"
$gpuLl = "${base}_gpu.ll"
$ptx = "$base.ptx"

# 1. NOVA -> .ll
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments $Source -TimeoutMs 60000
if ($cr.ExitCode -ne 0) {
    Write-Host "NOVA compile failed"
    if ($cr.StdOut) { Write-Host $cr.StdOut }
    exit 1
}

# 2. Patch .ll for NVPTX
(Get-Content $ll) `
    -replace 'thread_local global', 'global' `
    -replace 'target datalayout.*', 'target triple = "nvptx64-nvidia-cuda"' `
    | Set-Content $gpuLl

# 3. clang -> .ptx (NVPTX backend emits PTX assembly text)
$ClangPath = (Get-Command clang -ErrorAction SilentlyContinue).Source
$clangArgs = @(
    "--target=nvptx64-nvidia-cuda",
    "-O2",
    "-S",
    "-o", $ptx,
    $gpuLl
)
& $ClangPath @clangArgs 2>&1 | Where-Object { $_ -match "error:" } | ForEach-Object { Write-Host $_ }

if (-not (Test-Path $ptx)) {
    Write-Host "NVPTX compile failed (no .ptx produced)"
    exit 1
}

$ptxSize = (Get-Item $ptx).Length
$linesCount = (Get-Content $ptx | Measure-Object -Line).Lines
Write-Host "Built $ptx ($ptxSize bytes, $linesCount lines of PTX assembly)"
Write-Host ""
Write-Host "First 25 lines of PTX:"
Get-Content $ptx | Select-Object -First 25 | ForEach-Object { Write-Host "  $_" }

Remove-Item "nova_runtime.c", $gpuLl -Force -ErrorAction SilentlyContinue
