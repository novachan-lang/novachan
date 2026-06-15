$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$compiler = "$dir\gen4_test.exe"
$test = "green_scale_test"
Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = $compiler; $ps.Arguments = "$test.nova"; $ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
$pr.StandardOutput.ReadToEnd() | Out-Null; $ce = $pr.StandardError.ReadToEnd()
$ex = $pr.WaitForExit(60000)
if (-not $ex) { try { $pr.Kill() } catch {}; Write-Host "COMPILE TIMEOUT"; exit 1 }
if (-not (Test-Path "$dir\$test.ll")) { Write-Host "COMPILE FAIL: $($ce.Trim())"; exit 1 }
& clang "$dir\$test.ll" $rtSrc -o "$dir\$test.exe" -O2 @linkFlags 2>"$dir\_gs_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAIL"; Get-Content "$dir\_gs_lerr.txt" | Select-Object -First 10; exit 1 }
$ps2 = New-Object System.Diagnostics.ProcessStartInfo
$ps2.FileName = "$dir\$test.exe"; $ps2.WorkingDirectory = $dir
$ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
$pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2; $pr2.Start() | Out-Null
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$o2 = $pr2.StandardOutput.ReadToEnd(); $e2 = $pr2.StandardError.ReadToEnd()
$ex2 = $pr2.WaitForExit(60000)
$sw.Stop()
if (-not $ex2) { try { $pr2.Kill() } catch {}; Write-Host "RUN TIMEOUT (deadlock?)"; exit 1 }
Write-Host $o2.Trim()
if ($e2) { Write-Host "ERR: $($e2.Trim())" }
Write-Host "exit=$($pr2.ExitCode) time=$([int]$sw.Elapsed.TotalMilliseconds)ms"
