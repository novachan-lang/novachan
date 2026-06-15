# Bootstrap gen4 from gen3 with reflection changes, then compile reflect_test
$ErrorActionPreference = "Stop"
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Step 1: gen3 compiles nova_compiler.nova -> gen4 LLVM IR
Write-Host "=== Step 1: gen3 -> gen4 ==="
$proc = Start-Process -FilePath "$dir\gen3_test.exe" -ArgumentList "nova_compiler.nova" -WorkingDirectory $dir -NoNewWindow -PassThru -RedirectStandardOutput "$dir\gen4_out.txt" -RedirectStandardError "$dir\gen4_err.txt"
$done = $proc.WaitForExit(120000)
if (-not $done) { $proc.Kill(); Write-Host "TIMEOUT gen3"; exit 1 }
if ($proc.ExitCode -ne 0) {
    Write-Host "gen3 FAILED (exit $($proc.ExitCode))"
    Get-Content "$dir\gen4_err.txt" -ErrorAction SilentlyContinue | Select-Object -Last 40
    exit 1
}
Write-Host "gen3 OK"

# Step 2: Link gen4
Write-Host "=== Step 2: link gen4 ==="
$llc = & clang -o "$dir\gen4_reflect.exe" "$dir\output.ll" "$dir\output\nova_runtime.o" -lws2_32 -ladvapi32 -O2 2>&1
if ($LASTEXITCODE -ne 0) { Write-Host "link FAILED: $llc"; exit 1 }
Write-Host "gen4 linked OK"

# Step 3: gen4 compiles reflect_test.nova
Write-Host "=== Step 3: gen4 compiles reflect_test ==="
$proc2 = Start-Process -FilePath "$dir\gen4_reflect.exe" -ArgumentList "reflect_test.nova" -WorkingDirectory $dir -NoNewWindow -PassThru -RedirectStandardOutput "$dir\rt_out.txt" -RedirectStandardError "$dir\rt_err.txt"
$done2 = $proc2.WaitForExit(60000)
if (-not $done2) { $proc2.Kill(); Write-Host "TIMEOUT gen4"; exit 1 }
if ($proc2.ExitCode -ne 0) {
    Write-Host "gen4 compile FAILED (exit $($proc2.ExitCode))"
    Get-Content "$dir\rt_err.txt" -ErrorAction SilentlyContinue | Select-Object -Last 40
    exit 1
}
Write-Host "gen4 compile OK"

# Step 4: Link reflect_test
Write-Host "=== Step 4: link reflect_test ==="
& clang -o "$dir\reflect_test.exe" "$dir\output.ll" "$dir\output\nova_runtime.o" -lws2_32 -ladvapi32 -O2 2>&1
if ($LASTEXITCODE -ne 0) { Write-Host "link reflect_test FAILED"; exit 1 }
Write-Host "reflect_test linked OK"

# Step 5: Run reflect_test
Write-Host "=== Step 5: run reflect_test ==="
$proc3 = Start-Process -FilePath "$dir\reflect_test.exe" -WorkingDirectory $dir -NoNewWindow -PassThru -RedirectStandardOutput "$dir\rt_run_out.txt" -RedirectStandardError "$dir\rt_run_err.txt"
$done3 = $proc3.WaitForExit(15000)
if (-not $done3) { $proc3.Kill(); Write-Host "TIMEOUT reflect_test"; exit 1 }
Get-Content "$dir\rt_run_out.txt" -ErrorAction SilentlyContinue
if ($proc3.ExitCode -ne 0) {
    Write-Host "reflect_test FAILED (exit $($proc3.ExitCode))"
    Get-Content "$dir\rt_run_err.txt" -ErrorAction SilentlyContinue
    exit 1
}
Write-Host "=== ALL PASSED ==="
