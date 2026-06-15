$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$gen3 = "$dir\gen3_test.exe"
$rtSrc = "$dir\output\nova_runtime.c"
$rtObj = "$dir\output\nova_runtime.o"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")

Write-Host "=== BOOTSTRAP gen3 -> gen4 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $gen3; $psi.Arguments = "nova_compiler.nova"; $psi.WorkingDirectory = $dir
$psi.UseShellExecute = $false; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; $psi.CreateNoWindow = $true
$p = [System.Diagnostics.Process]::new(); $p.StartInfo = $psi; $p.Start() | Out-Null
$timer = [System.Diagnostics.Stopwatch]::StartNew()
$co = $p.StandardOutput.ReadToEnd(); $ce = $p.StandardError.ReadToEnd()
$exited = $p.WaitForExit(450000)
if (-not $exited) { try { $p.Kill() } catch {}; Write-Host "gen3 TIMEOUT"; exit 1 }
$timer.Stop(); Write-Host "gen3 took $([int]$timer.Elapsed.TotalSeconds)s (exit $($p.ExitCode))"
if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "gen3 FAILED: $ce"; exit 1 }
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_new.exe" -O2 @linkFlags 2>"$dir\_dm_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen4 LINK FAILED"; exit 1 }
Write-Host "gen4 built OK"

Write-Host "=== BOOTSTRAP gen4 -> gen5 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$psi2 = New-Object System.Diagnostics.ProcessStartInfo
$psi2.FileName = "$dir\gen4_new.exe"; $psi2.Arguments = "nova_compiler.nova"; $psi2.WorkingDirectory = $dir
$psi2.UseShellExecute = $false; $psi2.RedirectStandardOutput = $true; $psi2.RedirectStandardError = $true; $psi2.CreateNoWindow = $true
$p2 = [System.Diagnostics.Process]::new(); $p2.StartInfo = $psi2; $p2.Start() | Out-Null
$timer2 = [System.Diagnostics.Stopwatch]::StartNew()
$co2 = $p2.StandardOutput.ReadToEnd(); $ce2 = $p2.StandardError.ReadToEnd()
$exited2 = $p2.WaitForExit(450000)
if (-not $exited2) { try { $p2.Kill() } catch {}; Write-Host "gen4 TIMEOUT"; exit 1 }
$timer2.Stop(); Write-Host "gen4 took $([int]$timer2.Elapsed.TotalSeconds)s (exit $($p2.ExitCode))"
if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "gen4 FAILED: $ce2"; exit 1 }
Copy-Item "$dir\nova_compiler.ll" "$dir\_gen5.ll" -Force
$sha5 = (Get-FileHash "$dir\_gen5.ll" -Algorithm SHA256).Hash
Write-Host "gen5 SHA: $sha5"
& clang "$dir\_gen5.ll" $rtSrc -o "$dir\gen5_new.exe" -O2 @linkFlags 2>"$dir\_dm_lerr2.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen5 LINK FAILED"; exit 1 }

Write-Host "=== BOOTSTRAP gen5 -> gen6 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$psi3 = New-Object System.Diagnostics.ProcessStartInfo
$psi3.FileName = "$dir\gen5_new.exe"; $psi3.Arguments = "nova_compiler.nova"; $psi3.WorkingDirectory = $dir
$psi3.UseShellExecute = $false; $psi3.RedirectStandardOutput = $true; $psi3.RedirectStandardError = $true; $psi3.CreateNoWindow = $true
$p3 = [System.Diagnostics.Process]::new(); $p3.StartInfo = $psi3; $p3.Start() | Out-Null
$timer3 = [System.Diagnostics.Stopwatch]::StartNew()
$co3 = $p3.StandardOutput.ReadToEnd(); $ce3 = $p3.StandardError.ReadToEnd()
$exited3 = $p3.WaitForExit(450000)
if (-not $exited3) { try { $p3.Kill() } catch {}; Write-Host "gen5 TIMEOUT"; exit 1 }
$timer3.Stop(); Write-Host "gen5 took $([int]$timer3.Elapsed.TotalSeconds)s (exit $($p3.ExitCode))"
if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "gen5 FAILED: $ce3"; exit 1 }
$sha6 = (Get-FileHash "$dir\nova_compiler.ll" -Algorithm SHA256).Hash
Write-Host "gen6 SHA: $sha6"

if ($sha5 -eq $sha6) {
    Write-Host "CONVERGED (gen5 == gen6)"
    Copy-Item "$dir\gen4_new.exe" "$dir\gen4_test.exe" -Force
    Write-Host "Installed gen4_test.exe"
} else {
    Write-Host "DIVERGED gen5 != gen6"
    exit 1
}

Write-Host ""
Write-Host "=== SMOKE: _divmod_test ==="
$compiler = "$dir\gen4_test.exe"
$test = "_divmod_test"
Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
$psi4 = New-Object System.Diagnostics.ProcessStartInfo
$psi4.FileName = $compiler; $psi4.Arguments = "$test.nova"; $psi4.WorkingDirectory = $dir
$psi4.UseShellExecute = $false; $psi4.RedirectStandardOutput = $true; $psi4.RedirectStandardError = $true; $psi4.CreateNoWindow = $true
$p4 = [System.Diagnostics.Process]::new(); $p4.StartInfo = $psi4; $p4.Start() | Out-Null
$co4 = $p4.StandardOutput.ReadToEnd(); $ce4 = $p4.StandardError.ReadToEnd()
$exited4 = $p4.WaitForExit(60000)
if (-not $exited4) { try { $p4.Kill() } catch {}; Write-Host "COMPILE TIMEOUT"; exit 1 }
if (-not (Test-Path "$dir\$test.ll")) { Write-Host "COMPILE FAILED: $ce4"; exit 1 }
& clang "$dir\$test.ll" $rtSrc -o "$dir\$test.exe" -O2 @linkFlags 2>"$dir\_dm_lerr3.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; exit 1 }
$psi5 = New-Object System.Diagnostics.ProcessStartInfo
$psi5.FileName = "$dir\$test.exe"; $psi5.WorkingDirectory = $dir
$psi5.UseShellExecute = $false; $psi5.RedirectStandardOutput = $true; $psi5.RedirectStandardError = $true; $psi5.CreateNoWindow = $true
$p5 = [System.Diagnostics.Process]::new(); $p5.StartInfo = $psi5; $p5.Start() | Out-Null
$o5 = $p5.StandardOutput.ReadToEnd(); $e5 = $p5.StandardError.ReadToEnd()
$exited5 = $p5.WaitForExit(30000)
if (-not $exited5) { try { $p5.Kill() } catch {}; Write-Host "RUN TIMEOUT"; exit 1 }
Write-Host $o5.Trim()
if ($p5.ExitCode -ne 0) { Write-Host "TEST FAILED (exit=$($p5.ExitCode))"; exit 1 }
Write-Host "_divmod_test PASS"

Write-Host ""
Write-Host "=== REGRESSION ==="
$compiler = "$dir\gen4_test.exe"
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
