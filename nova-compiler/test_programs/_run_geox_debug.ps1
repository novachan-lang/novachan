$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = "$dir\gen4_test.exe"; $ps.Arguments = "_geox_debug.nova"; $ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
$pr.Start() | Out-Null
$co = $pr.StandardOutput.ReadToEnd(); $ce = $pr.StandardError.ReadToEnd()
if (-not $pr.WaitForExit(60000)) { $pr.Kill(); Write-Host "TIMEOUT"; exit 1 }
if ($pr.ExitCode -ne 0) { Write-Host "COMPILE FAIL: $ce"; exit 1 }
& clang -O2 -o "$dir\_geox_debug.exe" "$dir\_geox_debug.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$ps2 = New-Object System.Diagnostics.ProcessStartInfo
$ps2.FileName = "$dir\_geox_debug.exe"; $ps2.WorkingDirectory = $dir
$ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
$pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2
$pr2.Start() | Out-Null
$ro = $pr2.StandardOutput.ReadToEnd(); $re = $pr2.StandardError.ReadToEnd()
if (-not $pr2.WaitForExit(10000)) { $pr2.Kill(); Write-Host "TIMEOUT" }
Write-Host $ro
if ($re.Length -gt 0) { Write-Host "ERR: $re" }
