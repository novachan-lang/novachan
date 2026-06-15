$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"

$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = $compiler
$ps.Arguments = "stdlib/simdx.nova"
$ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false
$ps.RedirectStandardOutput = $true
$ps.RedirectStandardError = $true
$ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new()
$pr.StartInfo = $ps
$pr.Start() | Out-Null
$co = $pr.StandardOutput.ReadToEnd()
$ce = $pr.StandardError.ReadToEnd()
if (-not $pr.WaitForExit(60000)) { $pr.Kill(); Write-Host "TIMEOUT" }
Write-Host "EXIT: $($pr.ExitCode)"
Write-Host "STDOUT: [$co]"
Write-Host "STDERR: [$ce]"

Write-Host "`n--- Try direct path ---"
$ps2 = New-Object System.Diagnostics.ProcessStartInfo
$ps2.FileName = $compiler
$ps2.Arguments = "stdlib\simdx.nova"
$ps2.WorkingDirectory = $dir
$ps2.UseShellExecute = $false
$ps2.RedirectStandardOutput = $true
$ps2.RedirectStandardError = $true
$ps2.CreateNoWindow = $true
$pr2 = [System.Diagnostics.Process]::new()
$pr2.StartInfo = $ps2
$pr2.Start() | Out-Null
$co2 = $pr2.StandardOutput.ReadToEnd()
$ce2 = $pr2.StandardError.ReadToEnd()
if (-not $pr2.WaitForExit(60000)) { $pr2.Kill(); Write-Host "TIMEOUT" }
Write-Host "EXIT: $($pr2.ExitCode)"
Write-Host "STDOUT: [$co2]"
Write-Host "STDERR: [$ce2]"
