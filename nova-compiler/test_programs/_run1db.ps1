param([string]$Test)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$c = "$PSScriptRoot\gen3_test.exe"; $ll="$PSScriptRoot\$Test.ll"; $exe="$PSScriptRoot\$Test.exe"
$sqObj = "$PSScriptRoot\output\sqlite3_test.o"; $sqSrc = "$PSScriptRoot\..\compiler\sqlite3.c"
Remove-Item $ll,$exe -ErrorAction SilentlyContinue
if (!(Test-Path $sqObj) -and (Test-Path $sqSrc)) {
    Write-Host "Pre-compiling sqlite3.c -> sqlite3_test.o (one time)..."
    Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 -DSQLITE_THREADSAFE=0 `"$sqSrc`" -o `"$sqObj`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 300000 -WorkingDirectory $PSScriptRoot | Out-Null
}
$cr = Invoke-Timed -FilePath $c -Arguments "$Test.nova" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
Write-Host "compile exit=$($cr.ExitCode)"
if ($cr.StdErr) { Write-Host "CERR: $($cr.StdErr)" }
if (!(Test-Path $ll)) { Write-Host "NO .ll"; ($cr.StdOut -split "`n" | Select-Object -Last 8) | ForEach-Object { Write-Host $_ }; exit 1 }
$xsrc = ""
if ((Select-String -Path $ll -Pattern '@sqlite3_' -Quiet) -and (Test-Path $sqObj)) { $xsrc = " `"$sqObj`"" }
$la="-O2 -o `"$exe`" `"$ll`" `"..\compiler\nova_runtime.c`"$xsrc $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $la -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path $exe)) { Write-Host "NO exe (link failed)"; exit 1 }
$rr = Invoke-Timed -FilePath $exe -Arguments '' -TimeoutMs 20000 -WorkingDirectory $PSScriptRoot
Write-Host "run exit=$($rr.ExitCode)"; Write-Host "OUT: $($rr.StdOut)"; if($rr.StdErr){Write-Host "ERR: $($rr.StdErr)"}
Remove-Item $ll,$exe -ErrorAction SilentlyContinue
