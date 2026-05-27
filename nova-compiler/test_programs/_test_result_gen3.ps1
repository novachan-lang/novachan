Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "=== Compile result_test.nova with gen3 ==="
$r1 = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "result_test.nova" -TimeoutMs 30000
if ($r1.ExitCode -ne 0) { Write-Host "FAIL compile: $($r1.StdOut) $($r1.StdErr)"; exit 1 }

$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o result_test.exe result_test.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
if ($r2.ExitCode -ne 0) { Write-Host "FAIL link: $($r2.StdErr)"; exit 1 }

$r3 = Invoke-Timed -FilePath ".\result_test.exe" -Arguments "" -TimeoutMs 10000
Write-Host "EXIT=$($r3.ExitCode)"
Write-Host $r3.StdOut
if ($r3.StdErr -ne "") { Write-Host "STDERR: $($r3.StdErr)" }

Remove-Item "result_test.ll","result_test.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
