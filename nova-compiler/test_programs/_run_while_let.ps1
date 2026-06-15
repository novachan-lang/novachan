. "$PSScriptRoot\_proc_util.ps1"
$base = $PSScriptRoot

$r = Invoke-Timed -FilePath "$base\workerx.exe" -Arguments "`"$base\while_let_test.nova`"" -TimeoutMs 60000 -WorkingDirectory $base
Write-Host "=== COMPILE ==="
Write-Host "EXIT: $($r.ExitCode)  TIMEOUT: $($r.TimedOut)"
Write-Host "STDOUT: $($r.StdOut)"
if ($r.StdErr) { Write-Host "STDERR: $($r.StdErr)" }
if ($r.TimedOut -or $r.ExitCode -ne 0) { Write-Host "COMPILE FAILED"; exit 1 }

$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$base\while_let_test.exe`" `"$base\while_let_test.ll`" `"$base\output\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $base
Write-Host "=== LINK ==="
Write-Host "EXIT: $($r2.ExitCode)"
if ($r2.StdErr) { Write-Host "STDERR: $($r2.StdErr)" }
if ($r2.TimedOut -or $r2.ExitCode -ne 0) { Write-Host "LINK FAILED"; exit 1 }

$r3 = Invoke-Timed -FilePath "$base\while_let_test.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $base
Write-Host "=== RUN ==="
Write-Host "EXIT: $($r3.ExitCode)  TIMEOUT: $($r3.TimedOut)"
Write-Host "STDOUT: $($r3.StdOut)"
if ($r3.StdErr) { Write-Host "STDERR: $($r3.StdErr)" }
