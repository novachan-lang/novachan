Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$name = $args[0]
if (!$name) { Write-Host "Usage: _quick_test.ps1 <name>"; exit 1 }
Remove-Item "$name.ll","$name.exe" -Force -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments "$name.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL"; if ($cr.StdOut) { Write-Host $cr.StdOut.Substring(0,[Math]::Min(800,$cr.StdOut.Length)) }; exit 1 }
$linkArgs = "-O2 -o `"$name.exe`" `"$name.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path "$name.exe")) { Write-Host "LINK FAIL"; exit 1 }
$rr = Invoke-Timed -FilePath ".\$name.exe" -Arguments '' -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
if ($rr.TimedOut) { Write-Host "TIMEOUT"; exit 1 }
if ($rr.ExitCode -ne 0) { Write-Host "FAIL (exit=$($rr.ExitCode))"; if ($rr.StdOut) { Write-Host $rr.StdOut }; exit 1 }
if ($rr.StdOut) { Write-Host $rr.StdOut.Trim() }
if ($rr.StdErr -and $rr.StdErr -match "FAIL") { Write-Host "ASSERTION FAILED"; Write-Host $rr.StdErr; exit 1 }
Write-Host "PASS"
Remove-Item "$name.ll","$name.exe" -Force -ErrorAction SilentlyContinue
