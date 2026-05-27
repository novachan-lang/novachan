Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "=== gen2 ==="
$r1 = Invoke-Timed -FilePath ".\gen2_move.exe" -Arguments "try_unwrap_debug.nova" -TimeoutMs 30000
$l1 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o try_g2.exe try_unwrap_debug.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
$t1 = Invoke-Timed -FilePath ".\try_g2.exe" -Arguments "" -TimeoutMs 10000
Write-Host $t1.StdOut
Remove-Item "try_unwrap_debug.ll","try_g2.exe" -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "=== gen3 ==="
$r2 = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "try_unwrap_debug.nova" -TimeoutMs 30000
$l2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o try_g3.exe try_unwrap_debug.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
$t2 = Invoke-Timed -FilePath ".\try_g3.exe" -Arguments "" -TimeoutMs 10000
Write-Host $t2.StdOut

Write-Host ""
Write-Host "=== gen3 -O0 ==="
$l3 = Invoke-Timed -FilePath $ClangPath -Arguments "-O0 -o try_g3_o0.exe try_unwrap_debug.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
$t3 = Invoke-Timed -FilePath ".\try_g3_o0.exe" -Arguments "" -TimeoutMs 10000
Write-Host $t3.StdOut

Remove-Item "try_unwrap_debug.ll","try_g3.exe","try_g3_o0.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
