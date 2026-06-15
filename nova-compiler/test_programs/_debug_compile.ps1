$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"

Write-Host "Compiler: $compiler"
Write-Host "Exists: $(Test-Path $compiler)"

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
Write-Host "STDOUT len: $($co.Length)"
Write-Host "STDERR len: $($ce.Length)"
if ($ce.Length -gt 0) { Write-Host "STDERR: $ce" }

$llFile = "$dir\simdx.ll"
Write-Host "simdx.ll exists: $(Test-Path $llFile)"
$llFile2 = "$dir\stdlib\simdx.ll"
Write-Host "stdlib/simdx.ll exists: $(Test-Path $llFile2)"

Get-ChildItem $dir -Filter "*.ll" | Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-2) } | ForEach-Object { Write-Host "Recent .ll: $($_.Name)" }
