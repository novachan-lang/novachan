# Build ONE generation (gen3_test.exe -> nova_p1.exe) from the CURRENT compiler
# source, without touching gen3_test.exe. Lets a probe run against fresh compiler
# edits while keeping the known-good compiler intact as a fallback.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers
$env:NOVA_NO_CACHE = "1"

Write-Host "[build] gen3_test.exe -> nova_p1.exe (current source)"
$r = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "..\compiler\nova_compiler.nova nova_compiler.ll" -TimeoutMs 900000
if ($r.ExitCode -ne 0) {
    Write-Host "FAIL: compiler source does not compile (exit=$($r.ExitCode)) timedout=$($r.TimedOut)"
    if ($r.StdOut) { Write-Host $r.StdOut }
    if ($r.StdErr) { Write-Host $r.StdErr }
    exit 1
}
Copy-Item nova_compiler.ll nova_p1.ll -Force
Remove-Item nova_p1.exe -Force -ErrorAction SilentlyContinue
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o nova_p1.exe nova_p1.ll ..\compiler\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
if (!(Test-Path nova_p1.exe)) { Write-Host "FAIL: link"; Write-Host $l.StdErr; exit 1 }
Write-Host "  nova_p1.exe ($((Get-Item nova_p1.exe).Length) bytes)"
Write-Host "BUILD-OK"
exit 0
