$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$gen3 = "$dir\gen3_test.exe"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")

Write-Host "=== gen3 -> gen4 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $gen3; $psi.Arguments = "nova_compiler.nova"; $psi.WorkingDirectory = $dir
$psi.UseShellExecute = $false; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; $psi.CreateNoWindow = $true
$p = [System.Diagnostics.Process]::new(); $p.StartInfo = $psi; $p.Start() | Out-Null
$timer = [System.Diagnostics.Stopwatch]::StartNew()
$p.StandardOutput.ReadToEnd() | Out-Null; $ce = $p.StandardError.ReadToEnd()
$exited = $p.WaitForExit(450000)
if (-not $exited) { try { $p.Kill() } catch {}; Write-Host "gen3 TIMEOUT"; exit 1 }
$timer.Stop(); Write-Host "gen3 $([int]$timer.Elapsed.TotalSeconds)s exit=$($p.ExitCode)"
if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "gen3 FAILED: $ce"; exit 1 }
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_new.exe" -O2 @linkFlags 2>"$dir\_ex_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen4 LINK FAILED"; exit 1 }

Write-Host "=== gen4 -> gen5 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$psi2 = New-Object System.Diagnostics.ProcessStartInfo
$psi2.FileName = "$dir\gen4_new.exe"; $psi2.Arguments = "nova_compiler.nova"; $psi2.WorkingDirectory = $dir
$psi2.UseShellExecute = $false; $psi2.RedirectStandardOutput = $true; $psi2.RedirectStandardError = $true; $psi2.CreateNoWindow = $true
$p2 = [System.Diagnostics.Process]::new(); $p2.StartInfo = $psi2; $p2.Start() | Out-Null
$timer2 = [System.Diagnostics.Stopwatch]::StartNew()
$p2.StandardOutput.ReadToEnd() | Out-Null; $p2.StandardError.ReadToEnd() | Out-Null
$exited2 = $p2.WaitForExit(450000)
if (-not $exited2) { try { $p2.Kill() } catch {}; Write-Host "gen4 TIMEOUT"; exit 1 }
$timer2.Stop(); Write-Host "gen4 $([int]$timer2.Elapsed.TotalSeconds)s exit=$($p2.ExitCode)"
if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "gen4 FAILED"; exit 1 }
Copy-Item "$dir\nova_compiler.ll" "$dir\_gen5_ex.ll" -Force
$sha5 = (Get-FileHash "$dir\_gen5_ex.ll" -Algorithm SHA256).Hash
Write-Host "gen5 SHA: $sha5"
& clang "$dir\_gen5_ex.ll" $rtSrc -o "$dir\gen5_ex.exe" -O2 @linkFlags 2>"$dir\_ex_lerr2.txt"

Write-Host "=== gen5 -> gen6 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$psi3 = New-Object System.Diagnostics.ProcessStartInfo
$psi3.FileName = "$dir\gen5_ex.exe"; $psi3.Arguments = "nova_compiler.nova"; $psi3.WorkingDirectory = $dir
$psi3.UseShellExecute = $false; $psi3.RedirectStandardOutput = $true; $psi3.RedirectStandardError = $true; $psi3.CreateNoWindow = $true
$p3 = [System.Diagnostics.Process]::new(); $p3.StartInfo = $psi3; $p3.Start() | Out-Null
$timer3 = [System.Diagnostics.Stopwatch]::StartNew()
$p3.StandardOutput.ReadToEnd() | Out-Null; $p3.StandardError.ReadToEnd() | Out-Null
$exited3 = $p3.WaitForExit(450000)
if (-not $exited3) { try { $p3.Kill() } catch {}; Write-Host "gen5 TIMEOUT"; exit 1 }
$timer3.Stop(); Write-Host "gen5 $([int]$timer3.Elapsed.TotalSeconds)s exit=$($p3.ExitCode)"
if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "gen5 FAILED"; exit 1 }
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
Write-Host "=== POSITIVE TESTS (must compile + pass) ==="
foreach ($test in @("_exhaust_test", "_exhaust_userenum")) {
    Write-Host "--- $test ---"
    Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$test.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
    $co = $pr.StandardOutput.ReadToEnd(); $ce = $pr.StandardError.ReadToEnd()
    $ex = $pr.WaitForExit(60000)
    if (-not $ex) { try { $pr.Kill() } catch {}; Write-Host "$test COMPILE TIMEOUT"; exit 1 }
    if (-not (Test-Path "$dir\$test.ll")) { Write-Host "$test COMPILE FAIL (UNEXPECTED): $co $ce"; exit 1 }
    & clang "$dir\$test.ll" $rtSrc -o "$dir\$test.exe" -O2 @linkFlags 2>"$dir\_ex_tlerr.txt"
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
Write-Host "=== NEGATIVE TESTS (must be REJECTED at compile time) ==="
foreach ($test in @("_exhaust_neg_result", "_exhaust_neg_option")) {
    Write-Host "--- $test ---"
    Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$test.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
    $co = $pr.StandardOutput.ReadToEnd(); $ce = $pr.StandardError.ReadToEnd()
    $ex = $pr.WaitForExit(60000)
    if (-not $ex) { try { $pr.Kill() } catch {}; Write-Host "$test COMPILE TIMEOUT"; exit 1 }
    if (Test-Path "$dir\$test.ll") { Write-Host "$test WRONGLY COMPILED (should be rejected)"; exit 1 }
    $msg = "$co $ce"
    if ($msg -match "non-exhaustive match on (Result|Option)") {
        Write-Host "$test correctly REJECTED: $($msg.Trim())"
    } else {
        Write-Host "$test rejected but WRONG message: $($msg.Trim())"
        exit 1
    }
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
