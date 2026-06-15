$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$compiler = "$dir\gen4_test.exe"

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
