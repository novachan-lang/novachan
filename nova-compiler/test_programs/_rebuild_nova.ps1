$p = Start-Process -FilePath './gen3_test.exe' -ArgumentList 'nova_compiler.nova' -RedirectStandardOutput '_b_out.txt' -RedirectStandardError '_b_err.txt' -PassThru -NoNewWindow
if (-not $p.WaitForExit(450000)) {
    $p.Kill()
    Write-Host "TIMEOUT"
    exit 1
}
if ($p.ExitCode -ne 0) {
    Write-Host "COMPILE FAILED (exit $($p.ExitCode))"
    Get-Content '_b_err.txt' | Select-Object -Last 20
    exit 1
}
Write-Host "gen4 compile OK"

# Check for output LL
if (Test-Path 'nova_compiler.ll') {
    Write-Host "nova_compiler.ll exists, size: $((Get-Item 'nova_compiler.ll').Length)"
} else {
    # Check _b_out.txt for IR
    if (Test-Path '_b_out.txt') {
        Move-Item '_b_out.txt' 'nova_compiler.ll' -Force
        Write-Host "nova_compiler.ll from stdout, size: $((Get-Item 'nova_compiler.ll').Length)"
    }
}

# Link with clang
$clang = Start-Process -FilePath 'clang' -ArgumentList '-O2 -o nova_new.exe nova_compiler.ll output/nova_runtime.c -lws2_32 -ladvapi32' -RedirectStandardOutput '_bc_out.txt' -RedirectStandardError '_bc_err.txt' -PassThru -NoNewWindow
if (-not $clang.WaitForExit(120000)) {
    $clang.Kill()
    Write-Host "CLANG TIMEOUT"
    exit 1
}
if ($clang.ExitCode -ne 0) {
    Write-Host "CLANG FAILED"
    Get-Content '_bc_err.txt' | Select-Object -Last 20
    exit 1
}
Write-Host "clang link OK"

# Quick smoke: compile a trivial test
$smoke = Start-Process -FilePath './nova_new.exe' -ArgumentList 'hello.nova' -RedirectStandardOutput '_bf_smoke.txt' -RedirectStandardError '_bf_smokeerr.txt' -PassThru -NoNewWindow
if (-not $smoke.WaitForExit(30000)) {
    $smoke.Kill()
    Write-Host "SMOKE TIMEOUT"
    exit 1
}
if ($smoke.ExitCode -ne 0) {
    Write-Host "SMOKE FAILED"
    Get-Content '_bf_smokeerr.txt' | Select-Object -Last 10
    exit 1
}
Write-Host "smoke test OK — installing as nova.exe"
Copy-Item 'nova_new.exe' 'nova.exe' -Force
Write-Host "DONE — nova.exe rebuilt"
