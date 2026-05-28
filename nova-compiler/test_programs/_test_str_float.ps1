Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "`"$PSScriptRoot\test_str_float.nova`"" -TimeoutMs 30000
if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL:"; $cr.StdOut | ForEach-Object { Write-Host $_ }; exit 1 }
Copy-Item "$PSScriptRoot\output\nova_runtime.c" "$PSScriptRoot\rt_tmp.c" -Force
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$PSScriptRoot\test_str_float.exe`" `"$PSScriptRoot\test_str_float.ll`" `"$PSScriptRoot\rt_tmp.c`" $NovaLinkFlags" -TimeoutMs 60000
if (!(Test-Path "$PSScriptRoot\test_str_float.exe")) { Write-Host "LINK FAIL"; exit 1 }
$rr = Invoke-Timed -FilePath (Resolve-Path "$PSScriptRoot\test_str_float.exe").Path -Arguments "" -TimeoutMs 10000
Write-Host "EXIT: $($rr.ExitCode)"
$rr.StdOut | ForEach-Object { Write-Host $_ }
Remove-Item "$PSScriptRoot\test_str_float.ll","$PSScriptRoot\test_str_float.exe","$PSScriptRoot\rt_tmp.c" -Force -ErrorAction SilentlyContinue
