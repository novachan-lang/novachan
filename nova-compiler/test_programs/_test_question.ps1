. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "=== Compile question_test.nova ==="
$r1 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "question_test.nova" -TimeoutMs 15000
Write-Host "compile: EXIT=$($r1.ExitCode)"
if ($r1.ExitCode -ne 0) {
    Write-Host $r1.StdOut
    Write-Host $r1.StdErr
    Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
    exit 1
}

$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o question_test.exe question_test.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
if ($r2.ExitCode -ne 0) {
    Write-Host "link: FAIL"
    Write-Host $r2.StdErr
    Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
    exit 1
}

Write-Host "=== Run ==="
$r3 = Invoke-Timed -FilePath "$PSScriptRoot\question_test.exe" -Arguments "" -TimeoutMs 10000
Write-Host "EXIT=$($r3.ExitCode)"
Write-Host $r3.StdOut
if ($r3.StdErr -ne "") { Write-Host "STDERR: $($r3.StdErr)" }

Remove-Item "question_test.ll","question_test.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
