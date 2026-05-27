. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== Building gen3 from nova_compiler.nova ==="
$r = Invoke-Timed -FilePath "$PSScriptRoot\gen2_move.exe" -Arguments "nova_compiler.nova" -TimeoutMs 120000
Write-Host "EXIT=$($r.ExitCode) TIMEOUT=$($r.TimedOut)"
if ($r.StdOut -ne "") { Write-Host $r.StdOut }
if ($r.ExitCode -ne 0) {
    Write-Host "--- COMPILE ERRORS ---"
    Write-Host $r.StdErr
    exit 1
}

Write-Host "=== Linking gen3 ==="
# Use relative paths to avoid spaces-in-path issues with clang
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "nova_compiler.ll output\nova_runtime.c -o gen3_test.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "EXIT=$($r2.ExitCode) TIMEOUT=$($r2.TimedOut)"
if ($r2.ExitCode -ne 0) {
    Write-Host "--- LINK ERRORS ---"
    Write-Host $r2.StdOut
    Write-Host $r2.StdErr
    exit 1
}

Write-Host "=== gen3 built successfully ==="
