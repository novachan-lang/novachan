. "$PSScriptRoot/_proc_util.ps1"

# gen4_new compiles nova_compiler.nova -> gen5
Write-Host "=== gen4_new -> gen5 ==="
$r = Invoke-Timed -FilePath "$PSScriptRoot/gen4_new.exe" -Arguments "nova_compiler.nova" -TimeoutMs 120000
Write-Host "EXIT: $($r.ExitCode)"
if ($r.ExitCode -ne 0) { Write-Host $r.StdOut; Write-Host $r.StdErr; exit 1 }
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "nova_compiler.ll output/nova_runtime.o -o gen5_new.exe $NovaLinkFlags -O2" -TimeoutMs 120000
Write-Host "LINK: $($r2.ExitCode)"
if ($r2.ExitCode -ne 0) { Write-Host $r2.StdErr; exit 1 }

# Smoke test gen5
Write-Host "=== gen5 smoke ==="
$r3 = Invoke-Timed -FilePath "$PSScriptRoot/gen5_new.exe" -Arguments "hello.nova" -TimeoutMs 30000
Write-Host "SMOKE: $($r3.ExitCode) $($r3.StdOut)"
if ($r3.ExitCode -ne 0) { Write-Host $r3.StdErr; exit 1 }

# gen5 compiles parsec.nova - verify the fix survives bootstrap
Write-Host "=== gen5 parsec test ==="
$r4 = Invoke-Timed -FilePath "$PSScriptRoot/gen5_new.exe" -Arguments "parsec.nova" -TimeoutMs 30000
if ($r4.ExitCode -ne 0) { Write-Host "COMPILE FAIL"; Write-Host $r4.StdErr; exit 1 }
$r5 = Invoke-Timed -FilePath $ClangPath -Arguments "parsec.ll output/nova_runtime.o -o parsec_gen5.exe $NovaLinkFlags" -TimeoutMs 30000
if ($r5.ExitCode -ne 0) { Write-Host "LINK FAIL"; exit 1 }
$r6 = Invoke-Timed -FilePath "$PSScriptRoot/parsec_gen5.exe" -TimeoutMs 15000
Write-Host "PARSEC: $($r6.StdOut) (exit $($r6.ExitCode))"

# Install gen4_new as gen4_test
Write-Host "=== Installing gen4_new -> gen4_test ==="
Copy-Item gen4_new.exe gen4_test.exe -Force
Write-Host "Done"
