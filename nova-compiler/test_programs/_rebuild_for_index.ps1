. "$PSScriptRoot\_proc_util.ps1"
$base = $PSScriptRoot

Write-Host "=== Rebuilding gen4 (workerx.exe) from modified nova_compiler.nova ==="
$env:NOVA_NO_CACHE = "1"
$r = Invoke-Timed -FilePath "$base\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 450000 -WorkingDirectory $base
$env:NOVA_NO_CACHE = $null
Write-Host "COMPILE EXIT: $($r.ExitCode)  TIMEOUT: $($r.TimedOut)"
if ($r.StdOut) { Write-Host $r.StdOut.Substring(0, [Math]::Min(500, $r.StdOut.Length)) }
if ($r.StdErr) { Write-Host "STDERR: $($r.StdErr.Substring(0, [Math]::Min(500, $r.StdErr.Length)))" }
if ($r.TimedOut -or $r.ExitCode -ne 0) { Write-Host "COMPILE FAILED"; exit 1 }

$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$base\workerx.exe`" `"$base\nova_compiler.ll`" `"$base\output\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $base
Write-Host "LINK EXIT: $($r2.ExitCode)"
if ($r2.StdErr) { Write-Host "STDERR: $($r2.StdErr)" }
if ($r2.TimedOut -or $r2.ExitCode -ne 0) { Write-Host "LINK FAILED"; exit 1 }

$sz = (Get-Item "$base\workerx.exe").Length
Write-Host "gen4 rebuilt: workerx.exe ($sz bytes)"

Write-Host ""
Write-Host "=== Compiling for_index_test.nova with new gen4 ==="
$ll = "$base\for_index_test.ll"
if (Test-Path $ll) { Remove-Item $ll -Force }
$env:NOVA_NO_CACHE = "1"
$r3 = Invoke-Timed -FilePath "$base\workerx.exe" -Arguments "`"$base\for_index_test.nova`"" -TimeoutMs 60000 -WorkingDirectory $base
$env:NOVA_NO_CACHE = $null
Write-Host "COMPILE EXIT: $($r3.ExitCode)  TIMEOUT: $($r3.TimedOut)"
if ($r3.StdOut) { Write-Host $r3.StdOut.Substring(0, [Math]::Min(500, $r3.StdOut.Length)) }
if ($r3.StdErr) { Write-Host "STDERR: $($r3.StdErr.Substring(0, [Math]::Min(500, $r3.StdErr.Length)))" }
if ($r3.TimedOut -or $r3.ExitCode -ne 0) { Write-Host "COMPILE FAILED"; exit 1 }

$r4 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$base\for_index_test.exe`" `"$ll`" `"$base\output\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $base
Write-Host "LINK EXIT: $($r4.ExitCode)"
if ($r4.StdErr) { Write-Host "STDERR: $($r4.StdErr)" }
if ($r4.TimedOut -or $r4.ExitCode -ne 0) { Write-Host "LINK FAILED"; exit 1 }

$r5 = Invoke-Timed -FilePath "$base\for_index_test.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $base
Write-Host ""
Write-Host "=== RUN ==="
Write-Host "EXIT: $($r5.ExitCode)  TIMEOUT: $($r5.TimedOut)"
Write-Host "STDOUT: $($r5.StdOut)"
if ($r5.StdErr) { Write-Host "STDERR: $($r5.StdErr)" }
