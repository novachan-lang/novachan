$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"

$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = $compiler; $ps.Arguments = "_bbox_test.nova"; $ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true
$ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
$pr.Start() | Out-Null
$co = $pr.StandardOutput.ReadToEnd(); $ce = $pr.StandardError.ReadToEnd()
if (-not $pr.WaitForExit(60000)) { $pr.Kill(); Write-Host "TIMEOUT"; exit 1 }
if ($pr.ExitCode -ne 0) { Write-Host "COMPILE FAIL: $co $ce"; exit 1 }

& clang -O2 -o "$dir\_bbox_test.exe" "$dir\_bbox_test.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null

$ps2 = New-Object System.Diagnostics.ProcessStartInfo
$ps2.FileName = "$dir\_bbox_test.exe"; $ps2.WorkingDirectory = $dir
$ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true
$ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
$pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2
$pr2.Start() | Out-Null
$sout = $pr2.StandardOutput.ReadToEndAsync()
$serr = $pr2.StandardError.ReadToEndAsync()
if (-not $pr2.WaitForExit(15000)) { $pr2.Kill(); $pr2.WaitForExit(3000); Write-Host "TIMEOUT" }
[System.Threading.Tasks.Task]::WaitAll($sout, $serr)
Write-Host $sout.Result
if ($serr.Result.Length -gt 0) { Write-Host "STDERR: $($serr.Result)" }
Write-Host "exit=$($pr2.ExitCode)"
