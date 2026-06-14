Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
# Build the sqlite bind demo: pre-build sqlite3_test.o (once), gen3-compile the demo,
# link .ll + sqlite3_test.o + nova_runtime.o, run with kill-on-timeout.
$sqObj = "$PSScriptRoot\output\sqlite3_test.o"
if (!(Test-Path $sqObj)) {
    Write-Host "Pre-compiling sqlite3.c -> sqlite3_test.o (9MB amalgamation, ~minutes)..."
    $sqc = Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 -DSQLITE_THREADSAFE=0 `"$PSScriptRoot\output\sqlite3.c`" -o `"$sqObj`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 300000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path $sqObj)) { Write-Host "FAIL: sqlite3.c compile (exit=$($sqc.ExitCode))"; exit 1 }
}
Write-Host "sqlite3_test.o ready ($((Get-Item $sqObj).Length) bytes)"
Remove-Item demo_sqlite_bind_test.ll, __sqb.exe -Force -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "demo_sqlite_bind_test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0 -or !(Test-Path "demo_sqlite_bind_test.ll")) { Write-Host "COMPILE FAIL exit=$($cr.ExitCode)"; Write-Host $cr.StdOut; Write-Host $cr.StdErr; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o __sqb.exe demo_sqlite_bind_test.ll `"$sqObj`" output\nova_runtime.o -lws2_32 -lbcrypt -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "__sqb.exe")) { Write-Host "LINK FAIL"; Write-Host $lr.StdErr; exit 1 }
$rr = Invoke-Timed -FilePath ".\__sqb.exe" -Arguments "" -TimeoutMs 20000 -WorkingDirectory $PSScriptRoot
if ($rr.TimedOut) { Write-Host "RUN TIMEOUT"; exit 1 }
Write-Host $rr.StdOut.TrimEnd()
if ($rr.StdErr.Trim()) { Write-Host "STDERR: $($rr.StdErr.TrimEnd())" }
Write-Host "run exit=$($rr.ExitCode)"
Remove-Item demo_sqlite_bind_test.ll, __sqb.exe -Force -ErrorAction SilentlyContinue
if ($rr.ExitCode -eq 0 -and $rr.StdOut -match "sqlite bind demo passed") { Write-Host "SQLITE_BIND_OK" } else { Write-Host "SQLITE_BIND_FAIL"; exit 1 }
