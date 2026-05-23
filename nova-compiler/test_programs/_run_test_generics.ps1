Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "generics_test.nova" -TimeoutMs 30000
Write-Host "Compile exit: $($cr.ExitCode)"
if ($cr.StdErr) { Write-Host "Stderr: $($cr.StdErr.Substring(0, [Math]::Min(1000, $cr.StdErr.Length)))" }
if ($cr.StdOut) { Write-Host "Stdout: $($cr.StdOut.Substring(0, [Math]::Min(500, $cr.StdOut.Length)))" }
# Also test with gen1
$cr2 = Invoke-Timed -FilePath (Resolve-Path ".\gen1_final_ipt.exe").Path -Arguments "generics_test.nova" -TimeoutMs 30000
Write-Host "gen1 exit: $($cr2.ExitCode)"
Remove-Item "generics_test.ll" -Force -ErrorAction SilentlyContinue
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
