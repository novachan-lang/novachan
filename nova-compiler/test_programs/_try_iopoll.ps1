$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"
$rtObj = "$dir\_rt_cached.o"

# Compile
Write-Host "Compiling io_poll_test..."
$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = $compiler; $ps.Arguments = "io_poll_test.nova"; $ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
$pr.Start() | Out-Null
$cout = $pr.StandardOutput.ReadToEnd()
$cerr = $pr.StandardError.ReadToEnd()
if (-not $pr.WaitForExit(120000)) { $pr.Kill(); Write-Host "COMPILE TIMEOUT"; exit 1 }
if ($pr.ExitCode -ne 0) { Write-Host "COMPILE FAIL exit=$($pr.ExitCode)"; Write-Host $cerr; exit 1 }
if (-not (Test-Path "$dir\io_poll_test.ll")) { Write-Host "NO LL"; exit 1 }
Write-Host "Compiled OK"

# Link
& clang "$dir\io_poll_test.ll" $rtObj -o "$dir\io_poll_test.exe" -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>&1
if (-not (Test-Path "$dir\io_poll_test.exe")) { Write-Host "LINK FAIL"; exit 1 }
Write-Host "Linked OK"

# Run
Write-Host "Running io_poll_test..."
$rps = New-Object System.Diagnostics.ProcessStartInfo
$rps.FileName = "$dir\io_poll_test.exe"; $rps.Arguments = ""; $rps.WorkingDirectory = $dir
$rps.UseShellExecute = $false; $rps.RedirectStandardOutput = $true; $rps.RedirectStandardError = $true; $rps.CreateNoWindow = $true
$rpr = [System.Diagnostics.Process]::new(); $rpr.StartInfo = $rps
$rpr.Start() | Out-Null
$rout = $rpr.StandardOutput.ReadToEndAsync()
$rerr = $rpr.StandardError.ReadToEndAsync()
if (-not $rpr.WaitForExit(15000)) { $rpr.Kill(); $rpr.WaitForExit(3000); Write-Host "RUN TIMEOUT" }
[System.Threading.Tasks.Task]::WaitAll($rout, $rerr)
Write-Host "Exit code: $($rpr.ExitCode)"
Write-Host "STDOUT:"
Write-Host $rout.Result
if ($rerr.Result.Length -gt 0) { Write-Host "STDERR:"; Write-Host $rerr.Result.Substring(0, [Math]::Min(500, $rerr.Result.Length)) }
