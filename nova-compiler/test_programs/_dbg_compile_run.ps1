Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$name = $args[0]
Remove-Item "$name.ll","$name.exe" -Force -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments "$name.nova" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL"; Write-Host $cr.StdOut; exit 1 }
Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$name.exe`" `"$name.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path "$name.exe")) { Write-Host "LINK FAIL"; exit 1 }
$rr = Invoke-Timed -FilePath ".\$name.exe" -Arguments '' -TimeoutMs 6000 -WorkingDirectory $PSScriptRoot
Write-Host "Exit=$($rr.ExitCode) TimedOut=$($rr.TimedOut)"
Write-Host "Out: $($rr.StdOut)"
Remove-Item "$name.ll","$name.exe" -Force -ErrorAction SilentlyContinue
