Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
# Oracle for nova_link's SQLite auto-link (iter-75): `nova run` a program that imports
# sqlitex + calls @sqlite3_ -> nova_link detects it, compiles+caches output/sqlite3.o, and
# links it automatically (no manual link, no regression special path). Proves modular FFI
# (iter-74) is usable end-to-end via the standard build command.
Remove-Item _sqlapp.exe, _sqlapp.ll -Force -ErrorAction SilentlyContinue
# First run may build the ~9MB sqlite3.o (cached after); allow time + kill-on-timeout.
$r = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "run _sqlapp.nova" -TimeoutMs 300000 -WorkingDirectory $PSScriptRoot
Write-Host ("exit=" + $r.ExitCode + " timedout=" + $r.TimedOut)
Write-Host $r.StdOut.TrimEnd()
if ($r.StdErr -and $r.StdErr.Trim()) { Write-Host ("STDERR: " + $r.StdErr.TrimEnd()) }
Remove-Item _sqlapp.exe, _sqlapp.ll -Force -ErrorAction SilentlyContinue
if (-not $r.TimedOut -and $r.ExitCode -eq 0 -and $r.StdOut -match "x = 42") { Write-Host "SQLITE_AUTOLINK_OK" } else { Write-Host "SQLITE_AUTOLINK_FAIL"; exit 1 }
