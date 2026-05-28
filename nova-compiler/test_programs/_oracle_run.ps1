param([Parameter(Mandatory=$true)][string]$Test)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtime  = "$PSScriptRoot\output\nova_runtime.c"
$nova = "$PSScriptRoot\$Test.nova"
$ll   = "$PSScriptRoot\$Test.ll"
$exe  = "$PSScriptRoot\$Test.exe"

if (!(Test-Path $nova)) { Write-Host "NO SUCH TEST: $nova"; exit 1 }

$cr = Invoke-Timed -FilePath $compiler -Arguments "$Test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($cr.TimedOut -or $cr.ExitCode -ne 0) {
    Write-Host "COMPILE FAILED (exit=$($cr.ExitCode))"
    Write-Host $cr.StdErr
    exit 1
}
if (!(Test-Path $ll)) { Write-Host "NO .ll PRODUCED"; exit 1 }

$linkArgs = "-O2 -o `"$exe`" `"$ll`" `"$runtime`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w"
$lr = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path $exe)) {
    Write-Host "LINK FAILED"
    $lr.StdErr -split "`n" | Where-Object { $_ -match 'error:' } | ForEach-Object { Write-Host "  $_" }
    Remove-Item $ll -Force -ErrorAction SilentlyContinue
    exit 1
}

$rr = Invoke-Timed -FilePath $exe -Arguments '' -TimeoutMs 20000 -WorkingDirectory $PSScriptRoot
Write-Host "=== run exit=$($rr.ExitCode) ==="
Write-Host $rr.StdOut.TrimEnd()
if ($rr.StdErr.Trim()) { Write-Host "--- STDERR ---"; Write-Host $rr.StdErr.TrimEnd() }
Remove-Item $exe,$ll -Force -ErrorAction SilentlyContinue

if ($rr.TimedOut) { Write-Host "RESULT: TIMEOUT"; exit 1 }
if ($rr.ExitCode -ne 0) { Write-Host "RESULT: FAIL (nonzero exit)"; exit 1 }
if ($rr.StdErr -match 'FAIL|mismatch|assert') { Write-Host "RESULT: FAIL (assertion in stderr)"; exit 1 }
Write-Host "RESULT: PASS"
