$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test_bak.exe"
if (-not (Test-Path $compiler)) { $compiler = "$dir\gen4_test.exe" }

$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = $compiler; $ps.Arguments = "_iopoll_minimal.nova"; $ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
$pr.Start() | Out-Null
$co = $pr.StandardOutput.ReadToEnd(); $ce = $pr.StandardError.ReadToEnd()
if (-not $pr.WaitForExit(60000)) { $pr.Kill(); Write-Host "COMPILE TIMEOUT"; exit 1 }
if ($pr.ExitCode -ne 0) { Write-Host "COMPILE FAIL: $ce"; exit 1 }
& clang -O2 -o "$dir\_iopoll_minimal.exe" "$dir\_iopoll_minimal.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$ps2 = New-Object System.Diagnostics.ProcessStartInfo
$ps2.FileName = "$dir\_iopoll_minimal.exe"; $ps2.WorkingDirectory = $dir
$ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
$pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2
$pr2.Start() | Out-Null
$stdout2 = $pr2.StandardOutput.ReadToEndAsync()
$stderr2 = $pr2.StandardError.ReadToEndAsync()
if (-not $pr2.WaitForExit(15000)) {
    $pr2.Kill(); $pr2.WaitForExit(5000)
    Write-Host "RUN TIMEOUT"
}
[System.Threading.Tasks.Task]::WaitAll($stdout2, $stderr2)
Write-Host $stdout2.Result
if ($stderr2.Result.Length -gt 0) { Write-Host "ERR: $($stderr2.Result)" }
Write-Host "exit=$($pr2.ExitCode)"
