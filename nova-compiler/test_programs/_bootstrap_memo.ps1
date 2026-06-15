Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"

Write-Host "=== Stage 1: gen4 compiles nova_compiler.nova -> gen5 ==="
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
$r1 = Invoke-Timed -FilePath (Resolve-Path '.\gen4_test.exe').Path -Arguments 'nova_compiler.nova' -TimeoutMs 450000 -WorkingDirectory $PSScriptRoot
if ($r1.TimedOut) { Write-Host "gen5 COMPILE TIMEOUT"; exit 1 }
if ($r1.ExitCode -ne 0) { Write-Host "gen5 COMPILE FAIL: $($r1.ExitCode)"; if ($r1.StdOut) { Write-Host $r1.StdOut.Substring(0,[Math]::Min(2000,$r1.StdOut.Length)) }; exit 1 }
if (!(Test-Path nova_compiler.ll)) { Write-Host "NO gen5 .ll"; exit 1 }
$gen5_hash = (Get-FileHash nova_compiler.ll -Algorithm SHA256).Hash
Write-Host "gen5 .ll SHA256: $gen5_hash"
Copy-Item nova_compiler.ll gen5_compiler.ll -Force
$link1 = Invoke-Timed -FilePath 'clang' -Arguments '-O2 -o gen5_test.exe nova_compiler.ll output/nova_runtime.o -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w' -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if ($link1.ExitCode -ne 0) { Write-Host "gen5 LINK FAIL"; exit 1 }
Write-Host "gen5_test.exe built: $((Get-Item gen5_test.exe).Length) bytes"

Write-Host ""
Write-Host "=== Stage 2: gen5 compiles nova_compiler.nova -> gen6 ==="
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
$r2 = Invoke-Timed -FilePath (Resolve-Path '.\gen5_test.exe').Path -Arguments 'nova_compiler.nova' -TimeoutMs 450000 -WorkingDirectory $PSScriptRoot
if ($r2.TimedOut) { Write-Host "gen6 COMPILE TIMEOUT"; exit 1 }
if ($r2.ExitCode -ne 0) { Write-Host "gen6 COMPILE FAIL: $($r2.ExitCode)"; if ($r2.StdOut) { Write-Host $r2.StdOut.Substring(0,[Math]::Min(2000,$r2.StdOut.Length)) }; exit 1 }
if (!(Test-Path nova_compiler.ll)) { Write-Host "NO gen6 .ll"; exit 1 }
$gen6_hash = (Get-FileHash nova_compiler.ll -Algorithm SHA256).Hash
Write-Host "gen6 .ll SHA256: $gen6_hash"

Write-Host ""
if ($gen5_hash -eq $gen6_hash) {
    Write-Host "BOOTSTRAP CONVERGED: gen5 == gen6"
} else {
    Write-Host "BOOTSTRAP DIVERGED: gen5 != gen6"
    exit 1
}
