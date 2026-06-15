$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$compiler = "$dir\gen4_test.exe"
foreach ($test in @("green_netpoll_test","io_poll_test","demo_reactor_test")) {
    if (-not (Test-Path "$dir\$test.nova")) { Write-Host "$test SKIP (no file)"; continue }
    Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$test.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
    $pr.StandardOutput.ReadToEnd() | Out-Null; $ce = $pr.StandardError.ReadToEnd()
    $ex = $pr.WaitForExit(60000)
    if (-not $ex) { try { $pr.Kill() } catch {}; Write-Host "$test COMPILE_TIMEOUT"; continue }
    if (-not (Test-Path "$dir\$test.ll")) { Write-Host "$test COMPILE_FAIL: $($ce.Trim())"; continue }
    & clang "$dir\$test.ll" $rtSrc -o "$dir\$test.exe" -O2 @linkFlags 2>$null
    if ($LASTEXITCODE -ne 0) { Write-Host "$test LINK_FAIL"; continue }
    $ps2 = New-Object System.Diagnostics.ProcessStartInfo
    $ps2.FileName = "$dir\$test.exe"; $ps2.WorkingDirectory = $dir
    $ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
    $pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2; $pr2.Start() | Out-Null
    $o2 = $pr2.StandardOutput.ReadToEnd(); $e2 = $pr2.StandardError.ReadToEnd()
    $ex2 = $pr2.WaitForExit(20000)
    if (-not $ex2) { try { $pr2.Kill() } catch {}; Write-Host "$test RUN_TIMEOUT"; continue }
    Write-Host "--- $test (exit=$($pr2.ExitCode)) ---"
    Write-Host $o2.Trim()
    if ($e2) { Write-Host "ERR: $($e2.Trim())" }
}
Write-Host "DONE"
