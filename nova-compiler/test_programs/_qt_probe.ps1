param([string]$test = "_floatfloat_probe")
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$compiler = "$dir\gen4_test.exe"
Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = $compiler; $ps.Arguments = "$test.nova"; $ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
$co = $pr.StandardOutput.ReadToEnd(); $ce = $pr.StandardError.ReadToEnd()
$ex = $pr.WaitForExit(60000)
if (-not $ex) { try { $pr.Kill() } catch {}; Write-Host "COMPILE TIMEOUT"; exit 1 }
if (-not (Test-Path "$dir\$test.ll")) { Write-Host "COMPILE FAIL: $co $ce"; exit 1 }
& clang "$dir\$test.ll" $rtSrc -o "$dir\$test.exe" -O2 @linkFlags 2>"$dir\_probe_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAIL"; Get-Content "$dir\_probe_lerr.txt"; exit 1 }
$ps2 = New-Object System.Diagnostics.ProcessStartInfo
$ps2.FileName = "$dir\$test.exe"; $ps2.WorkingDirectory = $dir
$ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
$pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2; $pr2.Start() | Out-Null
$o2 = $pr2.StandardOutput.ReadToEnd(); $e2 = $pr2.StandardError.ReadToEnd()
$ex2 = $pr2.WaitForExit(30000)
if (-not $ex2) { try { $pr2.Kill() } catch {}; Write-Host "RUN TIMEOUT"; exit 1 }
Write-Host "STDOUT:"
Write-Host $o2.Trim()
if ($e2) { Write-Host "STDERR: $e2" }
Write-Host "EXIT: $($pr2.ExitCode)"
