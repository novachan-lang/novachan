$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"

Write-Host "Compiling geox..."
$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = $compiler; $ps.Arguments = "geox.nova"; $ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true
$ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
$pr.Start() | Out-Null
$co = $pr.StandardOutput.ReadToEnd(); $ce = $pr.StandardError.ReadToEnd()
if (-not $pr.WaitForExit(60000)) { $pr.Kill(); Write-Host "TIMEOUT"; exit 1 }
if ($pr.ExitCode -ne 0) { Write-Host "COMPILE FAIL: $co $ce"; exit 1 }
Write-Host "Compile OK"

Write-Host "Linking..."
& clang -O2 -o "$dir\geox.exe" "$dir\geox.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null

Write-Host "Running..."
$ps2 = New-Object System.Diagnostics.ProcessStartInfo
$ps2.FileName = "$dir\geox.exe"; $ps2.WorkingDirectory = $dir
$ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true
$ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
$pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2
$pr2.Start() | Out-Null
$sout = $pr2.StandardOutput.ReadToEndAsync()
$serr = $pr2.StandardError.ReadToEndAsync()
if (-not $pr2.WaitForExit(15000)) {
    $pr2.Kill(); $pr2.WaitForExit(3000)
    Write-Host "RUN TIMEOUT"
}
[System.Threading.Tasks.Task]::WaitAll($sout, $serr)
Write-Host "=== STDOUT ==="
Write-Host $sout.Result
Write-Host "=== STDERR ==="
Write-Host $serr.Result
Write-Host "EXIT: $($pr2.ExitCode)"
