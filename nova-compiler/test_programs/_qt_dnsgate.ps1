$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$gen3 = "$dir\gen3_test.exe"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")

function Invoke-Gen($exe, $label) {
    Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $exe; $psi.Arguments = "nova_compiler.nova"; $psi.WorkingDirectory = $dir
    $psi.UseShellExecute = $false; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; $psi.CreateNoWindow = $true
    $p = [System.Diagnostics.Process]::new(); $p.StartInfo = $psi; $p.Start() | Out-Null
    $t = [System.Diagnostics.Stopwatch]::StartNew()
    $p.StandardOutput.ReadToEnd() | Out-Null; $ce = $p.StandardError.ReadToEnd()
    if (-not $p.WaitForExit(450000)) { try { $p.Kill() } catch {}; Write-Host "$label TIMEOUT"; exit 1 }
    $t.Stop(); Write-Host "$label $([int]$t.Elapsed.TotalSeconds)s exit=$($p.ExitCode)"
    if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "$label FAILED: $ce"; exit 1 }
}
Write-Host "=== gen3 -> gen4 ==="; Invoke-Gen $gen3 "gen3"
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_new.exe" -O2 @linkFlags 2>"$dir\_dg_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen4 LINK FAILED"; Get-Content "$dir\_dg_lerr.txt" | Select-Object -First 20; exit 1 }
Write-Host "=== gen4 -> gen5 ==="; Invoke-Gen "$dir\gen4_new.exe" "gen4"
Copy-Item "$dir\nova_compiler.ll" "$dir\_gen5_dg.ll" -Force
$sha5 = (Get-FileHash "$dir\_gen5_dg.ll" -Algorithm SHA256).Hash; Write-Host "gen5 SHA: $sha5"
& clang "$dir\_gen5_dg.ll" $rtSrc -o "$dir\gen5_dg.exe" -O2 @linkFlags 2>$null
Write-Host "=== gen5 -> gen6 ==="; Invoke-Gen "$dir\gen5_dg.exe" "gen5"
$sha6 = (Get-FileHash "$dir\nova_compiler.ll" -Algorithm SHA256).Hash; Write-Host "gen6 SHA: $sha6"
if ($sha5 -ne $sha6) { Write-Host "DIVERGED"; exit 1 }
Write-Host "CONVERGED"; Copy-Item "$dir\gen4_new.exe" "$dir\gen4_test.exe" -Force; Write-Host "Installed gen4_test.exe"
$compiler = "$dir\gen4_test.exe"

$tests = @("dns_offload_test","green_netpoll_test","sched_test","green_scale_test","reschedule_test",
    "fiber_test","spawn_test","spawn_multi_test","bounded_chan_test","select_test","monitor_test",
    "green_monitor_test","green_supervisor_test","supervisor_test","supcrash_test","atomicx_test",
    "parallel_test","async_test","t8_channel_test","ws_sched_test")
Write-Host ""; Write-Host "=== CONCURRENCY + DNS ==="
$cp = 0; $cf = 0
foreach ($test in $tests) {
    if (-not (Test-Path "$dir\$test.nova")) { continue }
    Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$test.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
    $pr.StandardOutput.ReadToEnd() | Out-Null; $ce = $pr.StandardError.ReadToEnd()
    if (-not $pr.WaitForExit(60000)) { try { $pr.Kill() } catch {}; Write-Host "$test CT"; $cf++; continue }
    if (-not (Test-Path "$dir\$test.ll")) { Write-Host "$test CF: $($ce.Trim())"; $cf++; continue }
    & clang "$dir\$test.ll" $rtSrc -o "$dir\$test.exe" -O2 @linkFlags 2>$null
    if ($LASTEXITCODE -ne 0) { Write-Host "$test LF"; $cf++; continue }
    $ps2 = New-Object System.Diagnostics.ProcessStartInfo
    $ps2.FileName = "$dir\$test.exe"; $ps2.WorkingDirectory = $dir
    $ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
    $pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2; $pr2.Start() | Out-Null
    $pr2.StandardOutput.ReadToEnd() | Out-Null; $pr2.StandardError.ReadToEnd() | Out-Null
    if (-not $pr2.WaitForExit(40000)) { try { $pr2.Kill() } catch {}; Write-Host "$test RUN_TIMEOUT (deadlock?)"; $cf++; continue }
    if ($pr2.ExitCode -ne 0) { Write-Host "$test FAIL exit=$($pr2.ExitCode)"; $cf++; continue }
    Write-Host "$test PASS"; $cp++
}
Write-Host "Concurrency+DNS: $cp PASS, $cf FAIL"

Write-Host ""; Write-Host "=== REGRESSION (selfhost) ==="
$pass = 0; $fail = 0
foreach ($f in (Get-ChildItem "$dir\selfhost_test*.nova" | Sort-Object Name)) {
    $tn = $f.BaseName
    Remove-Item "$dir\$tn.ll" -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$tn.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
    $pr.StandardOutput.ReadToEnd() | Out-Null; $pr.StandardError.ReadToEnd() | Out-Null
    if (-not $pr.WaitForExit(60000)) { try { $pr.Kill() } catch {}; $fail++; continue }
    if (-not (Test-Path "$dir\$tn.ll")) { Write-Host "$tn CF"; $fail++; continue }
    & clang "$dir\$tn.ll" $rtSrc -o "$dir\$tn.exe" -O2 @linkFlags 2>$null
    if ($LASTEXITCODE -ne 0) { Write-Host "$tn LF"; $fail++; continue }
    $ps2 = New-Object System.Diagnostics.ProcessStartInfo
    $ps2.FileName = "$dir\$tn.exe"; $ps2.WorkingDirectory = $dir
    $ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
    $pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2; $pr2.Start() | Out-Null
    $pr2.StandardOutput.ReadToEnd() | Out-Null; $pr2.StandardError.ReadToEnd() | Out-Null
    if (-not $pr2.WaitForExit(30000)) { try { $pr2.Kill() } catch {}; $fail++; continue }
    if ($pr2.ExitCode -ne 0) { Write-Host "$tn FAIL"; $fail++; continue }
    $pass++
}
Write-Host "Regression: $pass PASS, $fail fail"
if ($cf -gt 0 -or $fail -gt 0) { Write-Host "GATE FAIL"; exit 1 }
Write-Host "ALL GREEN"
