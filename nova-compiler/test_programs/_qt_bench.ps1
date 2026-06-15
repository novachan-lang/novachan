$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$compiler = "$dir\gen4_test.exe"
foreach ($test in @("num_bench","fib_bench","bench_list_ops","bench_dict","iter_bench")) {
    if (-not (Test-Path "$dir\$test.nova")) { Write-Host "$test SKIP"; continue }
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
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $o2 = $pr2.StandardOutput.ReadToEnd(); $pr2.StandardError.ReadToEnd() | Out-Null
    $ex2 = $pr2.WaitForExit(30000)
    $sw.Stop()
    if (-not $ex2) { try { $pr2.Kill() } catch {}; Write-Host "$test RUN_TIMEOUT"; continue }
    $ms = [int]$sw.Elapsed.TotalMilliseconds
    Write-Host "$test exit=$($pr2.ExitCode) time=${ms}ms"
}
