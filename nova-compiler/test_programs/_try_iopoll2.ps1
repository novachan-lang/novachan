$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"
$rtObj = "$dir\_rt_cached.o"

$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = $compiler; $ps.Arguments = "_iopoll_diag2.nova"; $ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
$pr.Start() | Out-Null
$cout = $pr.StandardOutput.ReadToEnd()
$cerr = $pr.StandardError.ReadToEnd()
$pr.WaitForExit(120000) | Out-Null
if ($pr.ExitCode -ne 0) { Write-Host "COMPILE FAIL: $cerr"; exit 1 }
Write-Host "Compiled"

& clang "$dir\_iopoll_diag2.ll" $rtObj -o "$dir\_iopoll_diag2.exe" -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>&1
Write-Host "Linked"

$rps = New-Object System.Diagnostics.ProcessStartInfo
$rps.FileName = "$dir\_iopoll_diag2.exe"; $rps.WorkingDirectory = $dir
$rps.UseShellExecute = $false; $rps.RedirectStandardOutput = $true; $rps.RedirectStandardError = $true; $rps.CreateNoWindow = $true
$rpr = [System.Diagnostics.Process]::new(); $rpr.StartInfo = $rps
$rpr.Start() | Out-Null
$rout = $rpr.StandardOutput.ReadToEndAsync()
$rerr = $rpr.StandardError.ReadToEndAsync()
if (-not $rpr.WaitForExit(10000)) { $rpr.Kill(); $rpr.WaitForExit(3000); Write-Host "TIMEOUT" }
[System.Threading.Tasks.Task]::WaitAll($rout, $rerr)
Write-Host "Exit: $($rpr.ExitCode)"
Write-Host "OUT: $($rout.Result)"
if ($rerr.Result.Length -gt 0) { Write-Host "ERR: $($rerr.Result.Substring(0, [Math]::Min(500, $rerr.Result.Length)))" }
