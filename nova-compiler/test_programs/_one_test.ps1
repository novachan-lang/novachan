param([Parameter(Mandatory=$true)][string]$Test)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$compiler = "$PSScriptRoot\gen3_test.exe"
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"
$nova = "$PSScriptRoot\$Test.nova"
$ll   = "$PSScriptRoot\$Test.ll"
$exe  = "$PSScriptRoot\$Test.exe"
Remove-Item $ll,$exe -ErrorAction SilentlyContinue
if (!(Test-Path $nova)) { Write-Host "NO SUCH TEST: $nova"; exit 2 }

$cr = Invoke-Timed -FilePath $compiler -Arguments "$Test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($cr.TimedOut -or $cr.ExitCode -ne 0) { Write-Host "FAIL compile (exit=$($cr.ExitCode))"; Write-Host $cr.StdErr; exit 1 }
if (!(Test-Path $ll)) { Write-Host "FAIL compile (no .ll)"; exit 1 }
Write-Host "compiled"

$extraLibs = ""
$isWin = $IsWindows -or ($env:OS -eq 'Windows_NT')
$skipLibs = @(); if ($isWin) { $skipLibs = @('m','pthread','dl','rt') }
Get-Content $ll | Where-Object { $_ -match '^; LINK_LIB: (\S+)' } | ForEach-Object {
    $libName = $matches[1]; if ($skipLibs -notcontains $libName) { $extraLibs += " -l$libName" }
}
$linkArgs = "-O2 -o `"$exe`" `"$ll`" `"$runtimeSrc`" $NovaLinkFlags$extraLibs -D_CRT_SECURE_NO_WARNINGS -w"
$lr = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path $exe)) { Write-Host "FAIL link"; Write-Host $lr.StdErr; Remove-Item $ll -ErrorAction SilentlyContinue; exit 1 }
Write-Host "linked"

$rr = Invoke-Timed -FilePath $exe -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "exit=$($rr.ExitCode) timedout=$($rr.TimedOut)"
if ($rr.StdOut) { Write-Host "STDOUT: $($rr.StdOut.Trim())" }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr.Trim())" }
Remove-Item $ll,$exe -ErrorAction SilentlyContinue
if ($rr.TimedOut -or $rr.ExitCode -ne 0 -or ($rr.StdErr -match 'FAIL assert')) { exit 1 }
Write-Host "OK"
