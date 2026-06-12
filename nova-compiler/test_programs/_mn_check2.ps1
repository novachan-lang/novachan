param([string[]]$tests = @("sched_test","greenx","green_netpoll_test","demo_forge_test"))
$dir = $PSScriptRoot
. "$dir\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
foreach ($t in $tests) {
    if (-not (Test-Path "$dir\$t.nova")) { Write-Host "SKIP $t (no .nova)"; continue }
    $c = Invoke-Timed -FilePath "$dir\gen3_test.exe" -Arguments "$t.nova" -TimeoutMs 90000
    if ($c.ExitCode -ne 0) { Write-Host "=== $t ===`n  COMPILE-FAIL exit=$($c.ExitCode) $($c.StdErr)"; continue }
    $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$dir\_c2_$t.exe`" `"$dir\$t.ll`" `"$dir\output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 150000
    if ($l.ExitCode -ne 0) { Write-Host "=== $t ===`n  LINK-FAIL $($l.StdErr)"; continue }
    Remove-Item Env:\NOVA_CARRIERS -ErrorAction SilentlyContinue
    $r1 = Invoke-Timed -FilePath "$dir\_c2_$t.exe" -TimeoutMs 15000
    $env:NOVA_CARRIERS = "2"
    $r2 = Invoke-Timed -FilePath "$dir\_c2_$t.exe" -TimeoutMs 15000
    $env:NOVA_CARRIERS = "4"
    $r4 = Invoke-Timed -FilePath "$dir\_c2_$t.exe" -TimeoutMs 15000
    Remove-Item Env:\NOVA_CARRIERS -ErrorAction SilentlyContinue
    $o1 = ($r1.StdOut -replace "\s+"," ").Trim(); if ($o1.Length -gt 60) { $o1 = $o1.Substring(0,60) }
    $o2 = ($r2.StdOut -replace "\s+"," ").Trim(); if ($o2.Length -gt 60) { $o2 = $o2.Substring(0,60) }
    $o4 = ($r4.StdOut -replace "\s+"," ").Trim(); if ($o4.Length -gt 60) { $o4 = $o4.Substring(0,60) }
    Write-Host "=== $t ==="
    Write-Host "  N=1 exit=$($r1.ExitCode) to=$($r1.TimedOut) | $o1"
    Write-Host "  N=2 exit=$($r2.ExitCode) to=$($r2.TimedOut) | $o2"
    Write-Host "  N=4 exit=$($r4.ExitCode) to=$($r4.TimedOut) | $o4"
}
Write-Host "DONE"
