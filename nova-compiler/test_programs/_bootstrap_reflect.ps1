. "$PSScriptRoot/_proc_util.ps1"

# gen3 compiles nova_compiler.nova with reflection dispatch
Write-Host "=== gen3 -> gen4 ==="
$r = Invoke-Timed -FilePath "$PSScriptRoot/gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 120000
Write-Host "EXIT: $($r.ExitCode)"
if ($r.ExitCode -ne 0) { Write-Host $r.StdOut.Substring([Math]::Max(0,$r.StdOut.Length-500)); Write-Host $r.StdErr; exit 1 }

$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "nova_compiler.ll output/nova_runtime.o -o gen4_reflect.exe $NovaLinkFlags -O2" -TimeoutMs 120000
Write-Host "LINK: $($r2.ExitCode)"
if ($r2.ExitCode -ne 0) { Write-Host $r2.StdErr; exit 1 }

# Test reflect_test with the new compiler
Write-Host "=== reflect_test ==="
$r3 = Invoke-Timed -FilePath "$PSScriptRoot/gen4_reflect.exe" -Arguments "reflect_test.nova" -TimeoutMs 30000
Write-Host "COMPILE: $($r3.ExitCode) $($r3.StdOut)"
if ($r3.ExitCode -ne 0) { Write-Host $r3.StdErr; exit 1 }

$r4 = Invoke-Timed -FilePath $ClangPath -Arguments "reflect_test.ll output/nova_runtime.o -o reflect_test.exe $NovaLinkFlags" -TimeoutMs 30000
if ($r4.ExitCode -ne 0) { Write-Host "LINK FAIL"; Write-Host $r4.StdErr; exit 1 }

$r5 = Invoke-Timed -FilePath "$PSScriptRoot/reflect_test.exe" -TimeoutMs 15000
Write-Host "RUN: $($r5.StdOut)"
Write-Host "EXIT: $($r5.ExitCode)"
if ($r5.StdErr) { Write-Host "STDERR: $($r5.StdErr)" }

# Smoke test
Write-Host "=== smoke: hello.nova ==="
$r6 = Invoke-Timed -FilePath "$PSScriptRoot/gen4_reflect.exe" -Arguments "hello.nova" -TimeoutMs 30000
Write-Host "SMOKE: $($r6.ExitCode) $($r6.StdOut)"

Write-Host "=== Done ==="
