. "$PSScriptRoot\_proc_util.ps1"

# Self-rebuild: gen3_test.exe compiles nova_compiler.nova → new gen3.
# Use gen3_test.exe (NOT gen2_move.exe — it truncates if-else chains at ~60 branches).

Write-Host "=== Self-compile: gen3_test.exe → nova_compiler.ll ==="
$r = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 180000
Write-Host "EXIT=$($r.ExitCode) TIMEOUT=$($r.TimedOut)"
if ($r.ExitCode -ne 0) {
    Write-Host "--- COMPILE ERRORS ---"
    Write-Host $r.StdErr
    exit 1
}

Write-Host "=== Link gen3_test_new.exe ==="
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "nova_compiler.ll output\nova_runtime.c -o gen3_test_new.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
Write-Host "EXIT=$($r2.ExitCode) TIMEOUT=$($r2.TimedOut)"
if ($r2.ExitCode -ne 0) {
    Write-Host "--- LINK ERRORS ---"
    Write-Host $r2.StdOut
    Write-Host $r2.StdErr
    exit 1
}

Write-Host "=== Swap gen3_test.exe ← gen3_test_new.exe ==="
Move-Item -Force "$PSScriptRoot\gen3_test_new.exe" "$PSScriptRoot\gen3_test.exe"
Write-Host "=== Done. gen3_test.exe rebuilt ($((Get-Item $PSScriptRoot\gen3_test.exe).Length) bytes) ==="
