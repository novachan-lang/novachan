. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "=== Compile error_test.nova with gen3 ==="
$r1 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "error_test.nova" -TimeoutMs 15000
if ($r1.ExitCode -ne 0) { Write-Host "FAIL compile: $($r1.StdOut)"; exit 1 }
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o error_test_gen3.exe error_test.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
if ($r2.ExitCode -ne 0) { Write-Host "FAIL link: $($r2.StdErr)"; exit 1 }

Write-Host "=== Run (gen3) ==="
$r3 = Invoke-Timed -FilePath "$PSScriptRoot\error_test_gen3.exe" -Arguments "" -TimeoutMs 10000
Write-Host "EXIT=$($r3.ExitCode)"
Write-Host $r3.StdOut

Write-Host ""
Write-Host "=== Compile error_test.nova with gen2_move ==="
$r4 = Invoke-Timed -FilePath "$PSScriptRoot\gen2_move.exe" -Arguments "error_test.nova" -TimeoutMs 15000
if ($r4.ExitCode -ne 0) { Write-Host "FAIL compile: $($r4.StdOut)"; exit 1 }
$r5 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o error_test_gen2.exe error_test.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
if ($r5.ExitCode -ne 0) { Write-Host "FAIL link: $($r5.StdErr)"; exit 1 }

Write-Host "=== Run (gen2) ==="
$r6 = Invoke-Timed -FilePath "$PSScriptRoot\error_test_gen2.exe" -Arguments "" -TimeoutMs 10000
Write-Host "EXIT=$($r6.ExitCode)"
Write-Host $r6.StdOut

Remove-Item "error_test.ll","error_test_gen3.exe","error_test_gen2.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
