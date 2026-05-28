Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "=== mutual_recur_test ==="
$r1 = Invoke-Timed -FilePath ".\gen2_move.exe" -Arguments "mutual_recur_test.nova" -TimeoutMs 30000
if ($r1.ExitCode -eq 0) {
    $l1 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o mutual_recur_test.exe mutual_recur_test.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
    $t1 = Invoke-Timed -FilePath (Resolve-Path ".\mutual_recur_test.exe").Path -Arguments "" -TimeoutMs 10000
    Write-Host $t1.StdOut
    Write-Host "EXIT=$($t1.ExitCode)"
    Remove-Item "mutual_recur_test.ll","mutual_recur_test.exe" -Force -ErrorAction SilentlyContinue
} else { Write-Host "COMPILE FAIL: $($r1.StdErr)" }

Write-Host ""
Write-Host "=== forward_infer_test ==="
$r2 = Invoke-Timed -FilePath ".\gen2_move.exe" -Arguments "forward_infer_test.nova" -TimeoutMs 30000
if ($r2.ExitCode -eq 0) {
    $l2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o forward_infer_test.exe forward_infer_test.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
    $t2 = Invoke-Timed -FilePath (Resolve-Path ".\forward_infer_test.exe").Path -Arguments "" -TimeoutMs 10000
    Write-Host $t2.StdOut
    Write-Host "EXIT=$($t2.ExitCode)"
    Remove-Item "forward_infer_test.ll","forward_infer_test.exe" -Force -ErrorAction SilentlyContinue
} else { Write-Host "COMPILE FAIL: $($r2.StdErr)" }

Write-Host ""
Write-Host "=== forward_type_err_test (should fail compile) ==="
$r3 = Invoke-Timed -FilePath ".\gen2_move.exe" -Arguments "forward_type_err_test.nova" -TimeoutMs 30000
if ($r3.ExitCode -ne 0) {
    Write-Host "CORRECTLY REJECTED:"
    Write-Host $r3.StdOut
} else { Write-Host "BUG: should have been rejected" }

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
