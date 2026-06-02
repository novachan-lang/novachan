# Build gen4 from the nova_compiler.ll produced by the pre-check, then exercise the
# auto-show feature on a small program (cheap feature validation before full bootstrap).
param([string]$Test = "auto_show_test")
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
if (!(Test-Path "$PSScriptRoot\nova_compiler.ll")) { Write-Host "NO nova_compiler.ll - run _precheck_compile.ps1 first"; exit 1 }

$linkArgs = "-O2 -o `"gen4.exe`" `"nova_compiler.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
$lr = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 150000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "$PSScriptRoot\gen4.exe")) { Write-Host "FAIL link gen4"; Write-Host $lr.StdErr; exit 1 }
Write-Host "gen4.exe built ($((Get-Item gen4.exe).Length) bytes)"

Remove-Item "$Test.ll","$Test.exe" -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath "$PSScriptRoot\gen4.exe" -Arguments "$Test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "compile exit=$($cr.ExitCode) timedout=$($cr.TimedOut)"
if ($cr.StdErr) { Write-Host "CERR: $($cr.StdErr)" }
if (!(Test-Path "$Test.ll")) { Write-Host "NO .ll"; Write-Host $cr.StdOut; exit 1 }

$linkArgs2 = "-O2 -o `"$Test.exe`" `"$Test.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs2 -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path "$Test.exe")) { Write-Host "FAIL link $Test"; exit 1 }
$rr = Invoke-Timed -FilePath "$PSScriptRoot\$Test.exe" -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "run exit=$($rr.ExitCode) timedout=$($rr.TimedOut)"
Write-Host "STDOUT:"; Write-Host $rr.StdOut
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr)" }
Remove-Item "$Test.ll","$Test.exe" -ErrorAction SilentlyContinue
