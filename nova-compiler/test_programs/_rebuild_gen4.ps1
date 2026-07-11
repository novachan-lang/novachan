. "$PSScriptRoot\_proc_util.ps1"
$base = $PSScriptRoot

Write-Host "=== Rebuilding gen4 (workerx.exe) from nova_compiler.nova ==="
$env:NOVA_NO_CACHE = "1"
$r = Invoke-Timed -FilePath "$base\gen3_test.exe" -Arguments "..\compiler\nova_compiler.nova nova_compiler.ll" -TimeoutMs 450000 -WorkingDirectory $base
$env:NOVA_NO_CACHE = $null
Write-Host "EXIT: $($r.ExitCode)"
Write-Host "TIMEOUT: $($r.TimedOut)"
if ($r.StdOut.Length -gt 200) {
    Write-Host "STDOUT (tail): ...$($r.StdOut.Substring($r.StdOut.Length - 200))"
} else {
    Write-Host "STDOUT: $($r.StdOut)"
}
if ($r.StdErr) { Write-Host "STDERR: $($r.StdErr)" }

if ($r.TimedOut) { Write-Host "COMPILE TIMEOUT"; exit 1 }
if (-not (Test-Path "$base\nova_compiler.ll")) { Write-Host "NO .ll FILE"; exit 1 }

Write-Host "=== Linking workerx.exe ==="
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$base\workerx.exe`" `"$base\nova_compiler.ll`" `"$base\..\compiler\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $base
Write-Host "LINK EXIT: $($r2.ExitCode)"
if ($r2.StdErr) { Write-Host "LINK STDERR: $($r2.StdErr)" }
if ($r2.ExitCode -ne 0) { Write-Host "LINK FAILED"; exit 1 }

$sz = (Get-Item "$base\workerx.exe").Length
Write-Host "workerx.exe rebuilt: $sz bytes"
