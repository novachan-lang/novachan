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
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    $p.StandardOutput.ReadToEnd() | Out-Null; $ce = $p.StandardError.ReadToEnd()
    $exited = $p.WaitForExit(450000)
    if (-not $exited) { try { $p.Kill() } catch {}; Write-Host "$label TIMEOUT"; exit 1 }
    $timer.Stop(); Write-Host "$label $([int]$timer.Elapsed.TotalSeconds)s exit=$($p.ExitCode)"
    if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "$label FAILED: $ce"; exit 1 }
}

Write-Host "=== gen3 -> gen4 ==="
Invoke-Gen $gen3 "gen3"
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_new.exe" -O2 @linkFlags 2>"$dir\_ff_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen4 LINK FAILED"; exit 1 }

Write-Host "=== gen4 -> gen5 ==="
Invoke-Gen "$dir\gen4_new.exe" "gen4"
Copy-Item "$dir\nova_compiler.ll" "$dir\_gen5_ff.ll" -Force
$sha5 = (Get-FileHash "$dir\_gen5_ff.ll" -Algorithm SHA256).Hash
Write-Host "gen5 SHA: $sha5"
& clang "$dir\_gen5_ff.ll" $rtSrc -o "$dir\gen5_ff.exe" -O2 @linkFlags 2>"$dir\_ff_lerr2.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen5 LINK FAILED"; exit 1 }

Write-Host "=== gen5 -> gen6 ==="
Invoke-Gen "$dir\gen5_ff.exe" "gen5"
$sha6 = (Get-FileHash "$dir\nova_compiler.ll" -Algorithm SHA256).Hash
Write-Host "gen6 SHA: $sha6"

if ($sha5 -eq $sha6) {
    Write-Host "CONVERGED"
    Copy-Item "$dir\gen4_new.exe" "$dir\gen4_test.exe" -Force
    Write-Host "Installed gen4_test.exe"
} else {
    Write-Host "DIVERGED"
    exit 1
}

$compiler = "$dir\gen4_test.exe"
Write-Host ""
Write-Host "=== SMOKE TESTS ==="
foreach ($test in @("_floatfloat_probe", "_floatbox_map")) {
    Write-Host "--- $test ---"
    Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$test.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
    $co = $pr.StandardOutput.ReadToEnd(); $ce = $pr.StandardError.ReadToEnd()
    $ex = $pr.WaitForExit(60000)
    if (-not $ex) { try { $pr.Kill() } catch {}; Write-Host "$test COMPILE TIMEOUT"; exit 1 }
    if (-not (Test-Path "$dir\$test.ll")) { Write-Host "$test COMPILE FAIL: $co $ce"; exit 1 }
    & clang "$dir\$test.ll" $rtSrc -o "$dir\$test.exe" -O2 @linkFlags 2>"$dir\_ff_tlerr.txt"
    if ($LASTEXITCODE -ne 0) { Write-Host "$test LINK FAIL"; exit 1 }
    $ps2 = New-Object System.Diagnostics.ProcessStartInfo
    $ps2.FileName = "$dir\$test.exe"; $ps2.WorkingDirectory = $dir
    $ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
    $pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2; $pr2.Start() | Out-Null
    $o2 = $pr2.StandardOutput.ReadToEnd(); $pr2.StandardError.ReadToEnd() | Out-Null
    $ex2 = $pr2.WaitForExit(30000)
    if (-not $ex2) { try { $pr2.Kill() } catch {}; Write-Host "$test RUN TIMEOUT"; exit 1 }
    Write-Host $o2.Trim()
    if ($pr2.ExitCode -ne 0) { Write-Host "$test FAIL exit=$($pr2.ExitCode)"; exit 1 }
}

Write-Host ""
Write-Host "=== REGRESSION ==="
$pass = 0; $fail = 0; $total = 0
foreach ($f in (Get-ChildItem "$dir\selfhost_test*.nova" | Sort-Object Name)) {
    $tn = $f.BaseName; $total++
    Remove-Item "$dir\$tn.ll" -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$tn.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
    $pr.StandardOutput.ReadToEnd() | Out-Null; $pr.StandardError.ReadToEnd() | Out-Null
    $ex = $pr.WaitForExit(60000)
    if (-not $ex) { try { $pr.Kill() } catch {}; Write-Host "$tn COMPILE_TIMEOUT"; $fail++; continue }
    if (-not (Test-Path "$dir\$tn.ll")) { Write-Host "$tn COMPILE_FAIL"; $fail++; continue }
    & clang "$dir\$tn.ll" $rtSrc -o "$dir\$tn.exe" -O2 @linkFlags 2>$null
    if ($LASTEXITCODE -ne 0) { Write-Host "$tn LINK_FAIL"; $fail++; continue }
    $ps2 = New-Object System.Diagnostics.ProcessStartInfo
    $ps2.FileName = "$dir\$tn.exe"; $ps2.WorkingDirectory = $dir
    $ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
    $pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2; $pr2.Start() | Out-Null
    $pr2.StandardOutput.ReadToEnd() | Out-Null; $pr2.StandardError.ReadToEnd() | Out-Null
    $ex2 = $pr2.WaitForExit(30000)
    if (-not $ex2) { try { $pr2.Kill() } catch {}; Write-Host "$tn RUN_TIMEOUT"; $fail++; continue }
    if ($pr2.ExitCode -ne 0) { Write-Host "$tn FAIL"; $fail++; continue }
    $pass++
}
Write-Host ""
Write-Host "Regression: $pass/$total PASS, $fail fail"
if ($fail -gt 0) { exit 1 }
Write-Host "ALL GREEN"
