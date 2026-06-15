. "$PSScriptRoot\_proc_util.ps1"
$base = $PSScriptRoot

$ll = "$base\error_context_test.ll"
if (Test-Path $ll) { Remove-Item $ll -Force }
$env:NOVA_NO_CACHE = "1"
$r = Invoke-Timed -FilePath "$base\gen3_test.exe" -Arguments "`"$base\error_context_test.nova`"" -TimeoutMs 60000 -WorkingDirectory $base
$env:NOVA_NO_CACHE = $null
Write-Host "COMPILE EXIT: $($r.ExitCode)"
if ($r.TimedOut -or $r.ExitCode -ne 0) { Write-Host "COMPILE FAILED"; if ($r.StdOut) { Write-Host $r.StdOut.Substring(0, [Math]::Min(500, $r.StdOut.Length)) }; exit 1 }

$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$base\error_context_test.exe`" `"$ll`" `"$base\output\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $base
Write-Host "LINK EXIT: $($r2.ExitCode)"
if ($r2.TimedOut -or $r2.ExitCode -ne 0) { Write-Host "LINK FAILED"; exit 1 }

$r3 = Invoke-Timed -FilePath "$base\error_context_test.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $base
Write-Host "RUN EXIT: $($r3.ExitCode)  TIMEOUT: $($r3.TimedOut)"
Write-Host "STDOUT: $($r3.StdOut)"
if ($r3.StdErr) { Write-Host "STDERR: $($r3.StdErr)" }
