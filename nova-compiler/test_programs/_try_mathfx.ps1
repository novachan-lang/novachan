$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"
$rtObj = "$dir\_rt_cached.o"

$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = $compiler; $ps.Arguments = "mathfx.nova"; $ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
$pr.Start() | Out-Null
$pr.StandardOutput.ReadToEnd() | Out-Null
$pr.StandardError.ReadToEnd() | Out-Null
$pr.WaitForExit(120000) | Out-Null
if ($pr.ExitCode -ne 0) { Write-Host "COMPILE FAIL"; exit 1 }

& clang "$dir\mathfx.ll" $rtObj -o "$dir\mathfx.exe" -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>&1

Write-Host "=== distance_2d in IR ==="
$lines = Get-Content "$dir\mathfx.ll"
$inFn = $false
foreach ($l in $lines) {
    if ($l -match '^define.*@distance_2d\(') { $inFn = $true }
    if ($inFn) {
        Write-Host $l
        if ($l -match '^\}') { $inFn = $false; break }
    }
}

Write-Host ""
Write-Host "=== Running ==="
$rps = New-Object System.Diagnostics.ProcessStartInfo
$rps.FileName = "$dir\mathfx.exe"; $rps.WorkingDirectory = $dir
$rps.UseShellExecute = $false; $rps.RedirectStandardOutput = $true; $rps.RedirectStandardError = $true; $rps.CreateNoWindow = $true
$rpr = [System.Diagnostics.Process]::new(); $rpr.StartInfo = $rps
$rpr.Start() | Out-Null
$rout = $rpr.StandardOutput.ReadToEndAsync()
$rerr = $rpr.StandardError.ReadToEndAsync()
if (-not $rpr.WaitForExit(10000)) { $rpr.Kill(); $rpr.WaitForExit(3000); Write-Host "TIMEOUT" }
[System.Threading.Tasks.Task]::WaitAll($rout, $rerr)
Write-Host "Exit: $($rpr.ExitCode)"
Write-Host $rout.Result
if ($rerr.Result.Length -gt 0) { Write-Host "STDERR: $($rerr.Result.Substring(0, [Math]::Min(500, $rerr.Result.Length)))" }
