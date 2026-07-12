param([string]$Test)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$c = "$PSScriptRoot\gen3_test.exe"; $ll="$PSScriptRoot\$Test.ll"; $exe="$PSScriptRoot\$Test.exe"
Remove-Item $ll,$exe -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath $c -Arguments "$Test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "compile exit=$($cr.ExitCode)"
if ($cr.StdErr) { Write-Host "CERR: $($cr.StdErr)" }
if (!(Test-Path $ll)) { Write-Host "NO .ll"; ($cr.StdOut -split "`n" | Select-Object -Last 8) | ForEach-Object { Write-Host $_ }; exit 1 }
$la="-O2 -o `"$exe`" `"$ll`" `"..\compiler\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $la -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path $exe)) { Write-Host "NO exe"; exit 1 }
$rr = Invoke-Timed -FilePath $exe -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "run exit=$($rr.ExitCode)"; Write-Host "OUT: $($rr.StdOut)"; if($rr.StdErr){Write-Host "ERR: $($rr.StdErr)"}
Remove-Item $ll,$exe -ErrorAction SilentlyContinue
