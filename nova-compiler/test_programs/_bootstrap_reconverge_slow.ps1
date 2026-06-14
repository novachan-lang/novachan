Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
# Slow-environment variant of _bootstrap_reconverge.ps1: identical logic, but compile
# timeouts bumped 450000 -> 900000 (15 min) and link 120000 -> 240000 (4 min) so the
# ~9-min nova_compiler.nova compile (memory-pressure-starved on this host) does not hit
# the wall. Kill-on-timeout still MANDATORY (Invoke-Timed). Confirms gen5.ll==gen6.ll
# and installs gen5 as gen3_test.exe.
$env:NOVA_NO_CACHE = "1"
Write-Host "=== Bootstrap Reconverge (3-pass, SLOW timeouts) ==="

Write-Host "[pass 1] gen3_test.exe -> gen4 (nova_p1.exe)"
$r1 = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 900000
if ($r1.ExitCode -ne 0) { Write-Host "FAIL pass 1 (exit=$($r1.ExitCode)) timedout=$($r1.TimedOut)"; exit 1 }
Copy-Item nova_compiler.ll nova_p1.ll -Force
$l1 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o nova_p1.exe nova_p1.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
if (!(Test-Path nova_p1.exe)) { Write-Host "FAIL link p1"; exit 1 }
Write-Host "  nova_p1.exe ($((Get-Item nova_p1.exe).Length) bytes)"

Write-Host "[pass 2] gen4 -> gen5 (nova_p2.exe)"
$r2 = Invoke-Timed -FilePath (Resolve-Path ".\nova_p1.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 900000
if ($r2.ExitCode -ne 0) { Write-Host "FAIL pass 2 (exit=$($r2.ExitCode)) timedout=$($r2.TimedOut)"; exit 1 }
Copy-Item nova_compiler.ll nova_p2.ll -Force
$l2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o nova_p2.exe nova_p2.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
if (!(Test-Path nova_p2.exe)) { Write-Host "FAIL link p2"; exit 1 }
Write-Host "  nova_p2.exe ($((Get-Item nova_p2.exe).Length) bytes)"

Write-Host "[pass 3] gen5 -> gen6 (nova_p3.exe)"
$r3 = Invoke-Timed -FilePath (Resolve-Path ".\nova_p2.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 900000
if ($r3.ExitCode -ne 0) { Write-Host "FAIL pass 3 (exit=$($r3.ExitCode)) timedout=$($r3.TimedOut)"; exit 1 }
Copy-Item nova_compiler.ll nova_p3.ll -Force
$l3 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o nova_p3.exe nova_p3.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
if (!(Test-Path nova_p3.exe)) { Write-Host "FAIL link p3"; exit 1 }
Write-Host "  nova_p3.exe ($((Get-Item nova_p3.exe).Length) bytes)"

$h5 = (Get-FileHash nova_p2.ll -Algorithm SHA256).Hash
$h6 = (Get-FileHash nova_p3.ll -Algorithm SHA256).Hash
Write-Host ""
Write-Host "gen5.ll SHA256: $h5"
Write-Host "gen6.ll SHA256: $h6"

if ($h5 -eq $h6) {
    Write-Host ""
    Write-Host "=== RECONVERGED: gen5 == gen6 (byte-identical) ==="
    Copy-Item nova_p2.exe gen3_test.exe -Force
    Copy-Item nova_p2.exe nova.exe -Force
    Write-Host "Installed gen5 as gen3_test.exe + nova.exe"
} else {
    Write-Host ""
    Write-Host "*** DIVERGED: gen5 != gen6 ***"
    exit 1
}
