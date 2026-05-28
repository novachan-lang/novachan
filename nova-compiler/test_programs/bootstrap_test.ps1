Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "=== Bootstrap Convergence Test ==="
Write-Host ""

function Cleanup {
    Remove-Item "nova_compiler.ll" -Force -ErrorAction SilentlyContinue
    Remove-Item "nova_runtime.c"   -Force -ErrorAction SilentlyContinue
    Remove-Item "gen3.ll" -Force -ErrorAction SilentlyContinue
    Remove-Item "gen4.ll" -Force -ErrorAction SilentlyContinue
    Remove-Item "gen3.exe" -Force -ErrorAction SilentlyContinue
}

# Step 1: gen2 compiles nova_compiler.nova -> gen3 IR
Write-Host "Step 1: gen2 -> gen3 IR..."
if (Test-Path "nova_compiler.ll") { Remove-Item "nova_compiler.ll" -Force }
$r1 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_trait.exe").Path `
                   -Arguments "nova_compiler.nova" -TimeoutMs 120000
if ($r1.TimedOut) { Write-Host "FAILED: gen2 compile TIMED OUT (process killed)"; Cleanup; exit 1 }
if (-not (Test-Path "nova_compiler.ll")) {
    Write-Host "FAILED: gen2 couldn't compile nova_compiler.nova"; Cleanup; exit 1
}
Copy-Item "nova_compiler.ll" "gen3.ll" -Force
Write-Host "  gen3.ll: $((Get-Item 'gen3.ll').Length) bytes"

# Step 2: Link gen3
Write-Host "Step 2: Linking gen3..."
$lr = Invoke-Timed -FilePath $ClangPath `
                   -Arguments "-O2 -o gen3.exe nova_compiler.ll nova_runtime.c -lws2_32" `
                   -TimeoutMs 120000
if ($lr.TimedOut -or (-not (Test-Path "gen3.exe"))) {
    Write-Host "FAILED: gen3 link failed"; Cleanup; exit 1
}
Write-Host "  gen3.exe: $((Get-Item 'gen3.exe').Length) bytes"

# Step 3: gen3 compiles nova_compiler.nova -> gen4 IR
Write-Host "Step 3: gen3 -> gen4 IR..."
if (Test-Path "nova_compiler.ll") { Remove-Item "nova_compiler.ll" -Force }
$r2 = Invoke-Timed -FilePath (Resolve-Path ".\gen3.exe").Path `
                   -Arguments "nova_compiler.nova" -TimeoutMs 120000
if ($r2.TimedOut) { Write-Host "FAILED: gen3 compile TIMED OUT (process killed)"; Cleanup; exit 1 }
if (-not (Test-Path "nova_compiler.ll")) {
    Write-Host "FAILED: gen3 couldn't compile nova_compiler.nova"; Cleanup; exit 1
}
Copy-Item "nova_compiler.ll" "gen4.ll" -Force
Write-Host "  gen4.ll: $((Get-Item 'gen4.ll').Length) bytes"

# Step 4: Compare gen3 and gen4 IR
Write-Host ""
Write-Host "Step 4: Comparing gen3.ll vs gen4.ll..."
$gen3_hash = (Get-FileHash "gen3.ll" -Algorithm SHA256).Hash
$gen4_hash = (Get-FileHash "gen4.ll" -Algorithm SHA256).Hash
Write-Host "  gen3.ll SHA256: $gen3_hash"
Write-Host "  gen4.ll SHA256: $gen4_hash"
Write-Host ""
if ($gen3_hash -eq $gen4_hash) {
    Write-Host "BOOTSTRAP CONVERGED: gen3 == gen4 (identical IR)"
} else {
    Write-Host "BOOTSTRAP DIVERGED: gen3 != gen4"
}

Cleanup
