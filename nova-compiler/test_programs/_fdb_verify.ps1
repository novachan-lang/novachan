# Verify the forge_db data layer: compile forge_db_test (imports forge_db -> sqlitex, resolved from
# $NOVA_HOME/lib via _proc_util), link with the runtime + sqlite3 objects, run the DB round-trip.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$gen3 = Join-Path $PSScriptRoot "gen3_test.exe"
$t = "forge_db_test"
Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 output\nova_runtime.c -o output\nova_runtime.o -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path "output\sqlite3.o")) {
    Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 -DSQLITE_THREADSAFE=0 output\sqlite3.c -o output\sqlite3.o -w" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot | Out-Null
}
Remove-Item "$t.ll","$t.exe","_fdb_test.db" -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath $gen3 -Arguments "$t.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "$t.ll")) { Write-Host "COMPILE FAIL exit=$($c.ExitCode)"; if($c.StdOut){Write-Host $c.StdOut}; exit 1 }
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll output\nova_runtime.o output\sqlite3.o -lws2_32 -ladvapi32 -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "$t.exe")) { Write-Host "LINK FAIL"; if($l.StdOut){Write-Host $l.StdOut}; exit 1 }
$r = Invoke-Timed -FilePath ".\$t.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "STDOUT: $($r.StdOut)"
Write-Host "STDERR: $($r.StdErr)"
Write-Host "exit=$($r.ExitCode)"
