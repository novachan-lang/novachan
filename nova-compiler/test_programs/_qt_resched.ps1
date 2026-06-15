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
    $ex = $p.WaitForExit(450000)
    if (-not $ex) { try { $p.Kill() } catch {}; Write-Host "$label TIMEOUT"; exit 1 }
    $t.Stop(); Write-Host "$label $([int]$t.Elapsed.TotalSeconds)s exit=$($p.ExitCode)"
    if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "$label FAILED: $ce"; exit 1 }
}
function Run-Test($compiler, $test, $runTimeout) {
    Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$test.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
    $co = $pr.StandardOutput.ReadToEnd(); $ce = $pr.StandardError.ReadToEnd()
    if (-not $pr.WaitForExit(60000)) { try { $pr.Kill() } catch {}; Write-Host "$test COMPILE_TIMEOUT"; return $false }
    if (-not (Test-Path "$dir\$test.ll")) { Write-Host "$test COMPILE_FAIL: $($ce.Trim())"; return $false }
    & clang "$dir\$test.ll" $rtSrc -o "$dir\$test.exe" -O2 @linkFlags 2>$null
    if ($LASTEXITCODE -ne 0) { Write-Host "$test LINK_FAIL"; return $false }
    $ps2 = New-Object System.Diagnostics.ProcessStartInfo
    $ps2.FileName = "$dir\$test.exe"; $ps2.WorkingDirectory = $dir
    $ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
    $pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2; $pr2.Start() | Out-Null
    $o2 = $pr2.StandardOutput.ReadToEnd(); $pr2.StandardError.ReadToEnd() | Out-Null
    if (-not $pr2.WaitForExit($runTimeout)) { try { $pr2.Kill() } catch {}; Write-Host "$test RUN_TIMEOUT"; return $false }
    Write-Host ($o2.Trim())
    if ($pr2.ExitCode -ne 0) { Write-Host "$test FAIL exit=$($pr2.ExitCode)"; return $false }
    return $true
}

Write-Host "=== gen3 -> gen4 ==="; Invoke-Gen $gen3 "gen3"
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_new.exe" -O2 @linkFlags 2>"$dir\_rs_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen4 LINK FAILED"; Get-Content "$dir\_rs_lerr.txt" | Select-Object -First 15; exit 1 }
Write-Host "=== gen4 -> gen5 ==="; Invoke-Gen "$dir\gen4_new.exe" "gen4"
Copy-Item "$dir\nova_compiler.ll" "$dir\_gen5_rs.ll" -Force
$sha5 = (Get-FileHash "$dir\_gen5_rs.ll" -Algorithm SHA256).Hash; Write-Host "gen5 SHA: $sha5"
& clang "$dir\_gen5_rs.ll" $rtSrc -o "$dir\gen5_rs.exe" -O2 @linkFlags 2>$null
Write-Host "=== gen5 -> gen6 ==="; Invoke-Gen "$dir\gen5_rs.exe" "gen5"
$sha6 = (Get-FileHash "$dir\nova_compiler.ll" -Algorithm SHA256).Hash; Write-Host "gen6 SHA: $sha6"
if ($sha5 -ne $sha6) { Write-Host "DIVERGED"; exit 1 }
Write-Host "CONVERGED"; Copy-Item "$dir\gen4_new.exe" "$dir\gen4_test.exe" -Force; Write-Host "Installed gen4_test.exe"
$compiler = "$dir\gen4_test.exe"

Write-Host ""; Write-Host "=== reschedule_test ==="
Run-Test $compiler "reschedule_test" 30000 | Out-Null
Write-Host ""; Write-Host "=== sched_test (scheduler unchanged) ==="
Run-Test $compiler "sched_test" 30000 | Out-Null
Write-Host ""; Write-Host "=== green_scale_test (scale unchanged) ==="
Run-Test $compiler "green_scale_test" 60000 | Out-Null

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
    if (-not $pr.WaitForExit(60000)) { try { $pr.Kill() } catch {}; Write-Host "$tn CT"; $fail++; continue }
    if (-not (Test-Path "$dir\$tn.ll")) { Write-Host "$tn CF"; $fail++; continue }
    & clang "$dir\$tn.ll" $rtSrc -o "$dir\$tn.exe" -O2 @linkFlags 2>$null
    if ($LASTEXITCODE -ne 0) { Write-Host "$tn LF"; $fail++; continue }
    $ps2 = New-Object System.Diagnostics.ProcessStartInfo
    $ps2.FileName = "$dir\$tn.exe"; $ps2.WorkingDirectory = $dir
    $ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
    $pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2; $pr2.Start() | Out-Null
    $pr2.StandardOutput.ReadToEnd() | Out-Null; $pr2.StandardError.ReadToEnd() | Out-Null
    if (-not $pr2.WaitForExit(30000)) { try { $pr2.Kill() } catch {}; Write-Host "$tn RT"; $fail++; continue }
    if ($pr2.ExitCode -ne 0) { Write-Host "$tn FAIL"; $fail++; continue }
    $pass++
}
Write-Host "Regression: $pass PASS, $fail fail"
if ($fail -gt 0) { exit 1 }
Write-Host "ALL GREEN"
