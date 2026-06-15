. "$PSScriptRoot/_proc_util.ps1"

# Step 1: gen3 compiles nova_compiler.nova -> gen4 (with the fix)
Write-Host "=== gen3 -> gen4 ==="
$r = Invoke-Timed -FilePath "$PSScriptRoot/gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 120000
Write-Host "EXIT: $($r.ExitCode)"
if ($r.ExitCode -ne 0) { Write-Host $r.StdOut; Write-Host $r.StdErr; exit 1 }
Write-Host "Compiled OK"

# Link gen4
Write-Host "=== Linking gen4 ==="
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "nova_compiler.ll output/nova_runtime.o -o gen4_new.exe $NovaLinkFlags -O2" -TimeoutMs 120000
Write-Host "EXIT: $($r2.ExitCode)"
if ($r2.ExitCode -ne 0) { Write-Host $r2.StdErr; exit 1 }

# Step 2: gen4_new compiles parsec.nova with original `close` param
Write-Host "=== Testing parsec.nova with gen4_new ==="
$r3 = Invoke-Timed -FilePath "$PSScriptRoot/gen4_new.exe" -Arguments "parsec.nova" -TimeoutMs 30000
Write-Host "COMPILE EXIT: $($r3.ExitCode)"
if ($r3.ExitCode -ne 0) { Write-Host $r3.StdOut; Write-Host $r3.StdErr; exit 1 }
Write-Host $r3.StdOut

# Link and run parsec
$r4 = Invoke-Timed -FilePath $ClangPath -Arguments "parsec.ll output/nova_runtime.o -o parsec_new.exe $NovaLinkFlags" -TimeoutMs 30000
if ($r4.ExitCode -ne 0) { Write-Host "LINK FAIL"; Write-Host $r4.StdErr; exit 1 }

$r5 = Invoke-Timed -FilePath "$PSScriptRoot/parsec_new.exe" -TimeoutMs 15000
Write-Host "RUN: $($r5.StdOut)"
Write-Host "EXIT: $($r5.ExitCode)"

# Step 3: Smoke test - compile a simple program
Write-Host "=== Smoke: hello.nova ==="
$r6 = Invoke-Timed -FilePath "$PSScriptRoot/gen4_new.exe" -Arguments "hello.nova" -TimeoutMs 30000
Write-Host "SMOKE EXIT: $($r6.ExitCode)"
Write-Host $r6.StdOut

Write-Host "=== Done ==="
