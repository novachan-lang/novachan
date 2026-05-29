# Safe self-bootstrap: rebuild the compiler from the (edited) nova_compiler.nova
# using the CURRENT canonical gen3_test.exe (NOT gen2_move.exe, which truncates
# large if-else chains). Validates a deterministic fixpoint. Does NOT auto-promote.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "=== Stage 1: gen25 (gen3_test.exe) compiles edited nova_compiler.nova ==="
if (Test-Path "nova_compiler.ll") { Remove-Item "nova_compiler.ll" -Force }
$r1 = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 180000
if ($r1.TimedOut -or $r1.ExitCode -ne 0 -or !(Test-Path "nova_compiler.ll")) {
    Write-Host "FAIL stage1 compile (exit=$($r1.ExitCode) timeout=$($r1.TimedOut))"; Write-Host $r1.StdErr; exit 1
}
Move-Item "nova_compiler.ll" "self_a.ll" -Force
$r1b = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen_next.exe self_a.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
if (!(Test-Path "gen_next.exe")) { Write-Host "FAIL stage1 link"; Write-Host $r1b.StdErr; exit 1 }
Write-Host "gen_next.exe: $((Get-Item 'gen_next.exe').Length) bytes"

Write-Host "=== Stage 2: gen_next compiles nova_compiler.nova (fixpoint check) ==="
if (Test-Path "nova_compiler.ll") { Remove-Item "nova_compiler.ll" -Force }
$r2 = Invoke-Timed -FilePath (Resolve-Path ".\gen_next.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 180000
if ($r2.TimedOut -or $r2.ExitCode -ne 0 -or !(Test-Path "nova_compiler.ll")) {
    Write-Host "FAIL stage2 compile (exit=$($r2.ExitCode) timeout=$($r2.TimedOut))"; Write-Host $r2.StdErr; exit 1
}
Move-Item "nova_compiler.ll" "self_b.ll" -Force

$ha = (Get-FileHash "self_a.ll" -Algorithm SHA256).Hash
$hb = (Get-FileHash "self_b.ll" -Algorithm SHA256).Hash
Write-Host "self_a.ll (gen25 of new src): $ha"
Write-Host "self_b.ll (gen_next of new src): $hb"
if ($ha -eq $hb) {
    Write-Host "FIXPOINT OK: deterministic. gen_next.exe is a valid new canonical compiler."
} else {
    Write-Host "FIXPOINT DIVERGED: gen_next is NOT stable. Do NOT promote."
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
