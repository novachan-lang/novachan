param([string]$drop="0")
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_T8_DROP = $drop
Remove-Item w5b_drop_test.ll, __w5d.exe -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "w5b_drop_test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path w5b_drop_test.ll)) { Write-Host "COMPILE FAIL"; exit 1 }
Invoke-Timed -FilePath "C:\Program Files\LLVM\bin\clang.exe" -Arguments "-O2 -o __w5d.exe w5b_drop_test.ll output\nova_runtime.c -lws2_32 -lwinhttp -ladvapi32 -lbcrypt -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path __w5d.exe)) { Write-Host "LINK FAIL"; exit 1 }
$r = Invoke-Timed -FilePath ".\__w5d.exe" -Arguments "" -TimeoutMs 20000 -WorkingDirectory $PSScriptRoot
Write-Host "NOVA_T8_DROP=$drop -> $($r.StdOut.Trim()) (exit $($r.ExitCode))"
Remove-Item __w5d.exe -Force -ErrorAction SilentlyContinue
