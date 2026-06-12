param([int]$runs = 100)
$dir = $PSScriptRoot
. "$dir\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
# build _p2.exe with current runtime
$c = Invoke-Timed -FilePath "$dir\gen4_test.exe" -Arguments "_p2.nova" -TimeoutMs 60000
if ($c.ExitCode -ne 0) { Write-Host "COMPILE-FAIL $($c.StdErr)"; exit 1 }
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$dir\_p2.exe`" `"$dir\_p2.ll`" `"$dir\output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 150000
if ($l.ExitCode -ne 0) { Write-Host "LINK-FAIL $($l.StdErr)"; exit 1 }
Write-Host "built _p2.exe; soaking $runs runs per carrier-count"
$errf = "$dir\_soak_err.txt"; $outf = "$dir\_soak_out.txt"
$env:NOVA_CARRIER_STATS = "1"
if ($env:WD -eq "1") { $env:NOVA_SCHED_WATCHDOG = "1" } else { Remove-Item Env:\NOVA_SCHED_WATCHDOG -ErrorAction SilentlyContinue }
foreach ($nc in @("2","4","8")) {
    $env:NOVA_CARRIERS = $nc
    $hangs = 0; $bad = 0; $maxpol = 0
    for ($i = 1; $i -le $runs; $i++) {
        if (Test-Path $errf) { Remove-Item $errf }
        $p = Start-Process -FilePath "$dir\_p2.exe" -RedirectStandardError $errf -RedirectStandardOutput $outf -PassThru -NoNewWindow
        $exited = $p.WaitForExit(10000)
        if (-not $exited) {
            $hangs++
            Write-Host "  N=$nc run $i HUNG"
            try { $p.Kill() } catch {}
            try { $p.WaitForExit(2000) | Out-Null } catch {}
        } else {
            $o = (Get-Content $outf -Raw)
            if ($o -notmatch "p2 OK") { $bad++; Write-Host "  N=$nc run $i WRONG-OUTPUT exit=$($p.ExitCode): $o" }
            $e = (Get-Content $errf -Raw)
            if ($e -match "pollution=(\d+)") { $pol = [int]$matches[1]; if ($pol -gt $maxpol) { $maxpol = $pol } }
            if ($e -match "BUG") { Write-Host "  N=$nc run $i DETECTOR: $e" }
        }
    }
    Write-Host "N=$nc : $runs runs -> hangs=$hangs wrong=$bad maxPollution=$maxpol"
}
Remove-Item Env:\NOVA_CARRIERS -ErrorAction SilentlyContinue
Remove-Item Env:\NOVA_CARRIER_STATS -ErrorAction SilentlyContinue
Remove-Item Env:\NOVA_SCHED_WATCHDOG -ErrorAction SilentlyContinue
Write-Host "SOAK DONE"
