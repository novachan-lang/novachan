# Cheap pre-check: compile a source file with the CURRENT gen3_test.exe (kill-on-timeout).
# Validates the source parses + type-checks before committing to a full ~20-min bootstrap.
param([string]$Src = "nova_compiler.nova")
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$compiler = "$PSScriptRoot\gen3_test.exe"
$base = [System.IO.Path]::GetFileNameWithoutExtension($Src)
$ll = "$PSScriptRoot\$base.ll"
Remove-Item $ll -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath $compiler -Arguments $Src -TimeoutMs 300000 -WorkingDirectory $PSScriptRoot
Write-Host "exit=$($cr.ExitCode) timedout=$($cr.TimedOut)"
if ($cr.StdOut) { Write-Host "STDOUT(tail):"; (($cr.StdOut -split "`n") | Select-Object -Last 25) | ForEach-Object { Write-Host $_ } }
if ($cr.StdErr) { Write-Host "STDERR(tail):"; (($cr.StdErr -split "`n") | Select-Object -Last 25) | ForEach-Object { Write-Host $_ } }
if (Test-Path $ll) { Write-Host "LL_OK bytes=$((Get-Item $ll).Length)" } else { Write-Host "NO_LL" }
