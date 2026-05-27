Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "=== gen2_move ==="
$r = Invoke-Timed -FilePath ".\gen2_move.exe" -Arguments "result_test.nova" -TimeoutMs 30000
if ($r.ExitCode -ne 0) {
    Write-Host "COMPILE FAIL"
    Write-Host $r.StdOut
} else {
    $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o result_test_g2.exe result_test.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
    $t = Invoke-Timed -FilePath ".\result_test_g2.exe" -Arguments "" -TimeoutMs 10000
    Write-Host "EXIT=$($t.ExitCode)"
    Write-Host $t.StdOut
    if ($t.StdErr -ne "") { Write-Host "STDERR: $($t.StdErr)" }
    Remove-Item "result_test.ll","result_test_g2.exe" -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "=== gen3_test ==="
$r2 = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "result_test.nova" -TimeoutMs 30000
if ($r2.ExitCode -ne 0) {
    Write-Host "COMPILE FAIL"
    Write-Host $r2.StdOut
} else {
    $l2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o result_test_g3.exe result_test.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
    $t2 = Invoke-Timed -FilePath ".\result_test_g3.exe" -Arguments "" -TimeoutMs 10000
    Write-Host "EXIT=$($t2.ExitCode)"
    Write-Host $t2.StdOut
    if ($t2.StdErr -ne "") { Write-Host "STDERR: $($t2.StdErr)" }
    Remove-Item "result_test.ll","result_test_g3.exe" -Force -ErrorAction SilentlyContinue
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
