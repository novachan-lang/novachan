Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== Bootstrap Convergence Test ==="

# Step 1: Compile nova_compiler.nova with gen2 → gen3.ll
Write-Host "`n[1/4] Compiling nova_compiler.nova with gen2 → gen3.ll"
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 180000
if ($cr.ExitCode -ne 0) { Write-Host "FAIL: gen3 compile (exit=$($cr.ExitCode))"; exit 1 }
Copy-Item "nova_compiler.ll" "gen3.ll" -Force
Write-Host "OK"

# Step 2: Link gen3.ll → gen3.exe
Write-Host "[2/4] Linking gen3.exe"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen3.exe gen3.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 180000
if (!(Test-Path "gen3.exe")) { Write-Host "FAIL: gen3 link"; exit 1 }
Write-Host "OK"

# Step 3: Compile nova_compiler.nova with gen3 → gen4.ll
Write-Host "[3/4] Compiling nova_compiler.nova with gen3 → gen4.ll"
$cr2 = Invoke-Timed -FilePath (Resolve-Path ".\gen3.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 180000
if ($cr2.ExitCode -ne 0) { Write-Host "FAIL: gen4 compile (exit=$($cr2.ExitCode))"; exit 1 }
Copy-Item "nova_compiler.ll" "gen4.ll" -Force
Write-Host "OK"

# Step 4: Compare gen3.ll and gen4.ll
Write-Host "[4/4] Comparing gen3.ll vs gen4.ll"
$h3 = (Get-FileHash "gen3.ll" -Algorithm SHA256).Hash
$h4 = (Get-FileHash "gen4.ll" -Algorithm SHA256).Hash
$s3 = (Get-Item "gen3.ll").Length
$s4 = (Get-Item "gen4.ll").Length

Write-Host "gen3.ll: $s3 bytes, SHA256: $h3"
Write-Host "gen4.ll: $s4 bytes, SHA256: $h4"

if ($h3 -eq $h4) {
    Write-Host "`nBOOTSTRAP CONVERGED: gen3.ll == gen4.ll"
} else {
    Write-Host "`nBOOTSTRAP DIVERGED: gen3.ll != gen4.ll"
    # Show diff stats
    $lines3 = (Get-Content gen3.ll).Count
    $lines4 = (Get-Content gen4.ll).Count
    Write-Host "Lines: gen3=$lines3 gen4=$lines4"
}

Remove-Item "gen3.ll","gen4.ll","gen3.exe","nova_compiler.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
