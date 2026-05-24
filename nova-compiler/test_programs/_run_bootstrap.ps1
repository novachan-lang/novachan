Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# gen2 compiles nova_compiler.nova -> gen3.ll
Write-Host "=== gen2 -> gen3 ==="
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 180000
Write-Host "Compile exit: $($cr.ExitCode) Timeout: $($cr.TimedOut)"
if (!(Test-Path "nova_compiler.ll")) { Write-Host "FAIL: no gen3.ll"; exit 1 }
Copy-Item "nova_compiler.ll" "gen3.ll" -Force

# Link gen3
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen3.exe gen3.ll nova_runtime.c -lws2_32 -ladvapi32" -TimeoutMs 120000
Write-Host "Link gen3: exit=$($lr.ExitCode)"
if (!(Test-Path "gen3.exe")) { Write-Host "FAIL: no gen3.exe"; exit 1 }

# gen3 compiles nova_compiler.nova -> gen4.ll
Write-Host "=== gen3 -> gen4 ==="
Remove-Item "nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$cr2 = Invoke-Timed -FilePath (Resolve-Path ".\gen3.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 180000
Write-Host "Compile exit: $($cr2.ExitCode) Timeout: $($cr2.TimedOut)"
if (!(Test-Path "nova_compiler.ll")) { Write-Host "FAIL: no gen4.ll"; exit 1 }
Copy-Item "nova_compiler.ll" "gen4.ll" -Force

# Compare gen3.ll and gen4.ll
$h3 = (Get-FileHash "gen3.ll" -Algorithm SHA256).Hash
$h4 = (Get-FileHash "gen4.ll" -Algorithm SHA256).Hash
Write-Host "gen3.ll SHA256: $h3"
Write-Host "gen4.ll SHA256: $h4"
if ($h3 -eq $h4) {
    Write-Host "BOOTSTRAP CONVERGED: gen3.ll == gen4.ll"
} else {
    Write-Host "BOOTSTRAP DIVERGED: gen3.ll != gen4.ll"
    Write-Host "gen3.ll size: $((Get-Item gen3.ll).Length)"
    Write-Host "gen4.ll size: $((Get-Item gen4.ll).Length)"
}

Remove-Item "nova_compiler.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
