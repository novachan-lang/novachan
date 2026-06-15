. "$PSScriptRoot\_proc_util.ps1"
$base = $PSScriptRoot

Write-Host "=== Rebuilding gen4 ==="
$env:NOVA_NO_CACHE = "1"
$r = Invoke-Timed -FilePath "$base\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 450000 -WorkingDirectory $base
$env:NOVA_NO_CACHE = $null
if ($r.TimedOut -or $r.ExitCode -ne 0) {
    Write-Host "COMPILE FAIL (exit=$($r.ExitCode) timeout=$($r.TimedOut))"
    if ($r.StdOut) { Write-Host $r.StdOut.Substring(0, [Math]::Min(3000, $r.StdOut.Length)) }
    if ($r.StdErr) { Write-Host "STDERR: $($r.StdErr.Substring(0, [Math]::Min(1000, $r.StdErr.Length)))" }
    exit 1
}
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$base\workerx.exe`" `"$base\nova_compiler.ll`" `"$base\output\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $base
if ($r2.ExitCode -ne 0) { Write-Host "LINK FAIL"; Write-Host $r2.StdErr; exit 1 }
Write-Host "gen4 OK: workerx.exe ($((Get-Item "$base\workerx.exe").Length) bytes)"

Write-Host ""
Write-Host "=== Compiling error_context_test.nova ==="
$ll = "$base\error_context_test.ll"
if (Test-Path $ll) { Remove-Item $ll -Force }
$env:NOVA_NO_CACHE = "1"
$r3 = Invoke-Timed -FilePath "$base\workerx.exe" -Arguments "`"$base\error_context_test.nova`"" -TimeoutMs 60000 -WorkingDirectory $base
$env:NOVA_NO_CACHE = $null
Write-Host "COMPILE EXIT: $($r3.ExitCode)"
if ($r3.StdOut) { Write-Host $r3.StdOut.Substring(0, [Math]::Min(500, $r3.StdOut.Length)) }
if ($r3.StdErr) { Write-Host "STDERR: $($r3.StdErr.Substring(0, [Math]::Min(500, $r3.StdErr.Length)))" }
if ($r3.TimedOut -or $r3.ExitCode -ne 0) { Write-Host "COMPILE FAILED"; exit 1 }

$r4 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$base\error_context_test.exe`" `"$ll`" `"$base\output\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $base
Write-Host "LINK EXIT: $($r4.ExitCode)"
if ($r4.StdErr) { Write-Host "LINK STDERR: $($r4.StdErr)" }
if ($r4.TimedOut -or $r4.ExitCode -ne 0) { Write-Host "LINK FAILED"; exit 1 }

$r5 = Invoke-Timed -FilePath "$base\error_context_test.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $base
Write-Host ""
Write-Host "=== RUN ==="
Write-Host "EXIT: $($r5.ExitCode)  TIMEOUT: $($r5.TimedOut)"
Write-Host "STDOUT: $($r5.StdOut)"
if ($r5.StdErr) { Write-Host "STDERR: $($r5.StdErr)" }
