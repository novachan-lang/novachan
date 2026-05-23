Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$compiler = ".\gen2_move.exe"
$test = "move_tiny_test"
$cr = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$test.nova" -TimeoutMs 30000
Write-Host "Compile exit: $($cr.ExitCode) Timeout: $($cr.TimedOut)"
if ($cr.StdErr) { Write-Host "Stderr: $($cr.StdErr.Substring(0, [Math]::Min(500, $cr.StdErr.Length)))" }
if (Test-Path "$test.ll") { Write-Host "LL generated OK" } else { Write-Host "FAIL: no .ll" }
Remove-Item "$test.ll","$test.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
