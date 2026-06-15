$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir

function Run-Timed($exe, $argList, $timeout, $label) {
    $p = Start-Process -FilePath $exe -ArgumentList $argList -NoNewWindow -PassThru -RedirectStandardOutput "_bc_out.txt" -RedirectStandardError "_bc_err.txt"
    if (-not $p.WaitForExit($timeout)) { $p.Kill(); Write-Host "$label TIMEOUT"; exit 1 }
    $ec = $p.ExitCode
    if ($null -ne $ec -and $ec -ne 0) {
        Write-Host "$label FAILED (exit $ec)"
        Get-Content "_bc_err.txt" -ErrorAction SilentlyContinue | Select-Object -Last 30
        exit 1
    }
    Write-Host "$label OK"
}

function Link-It($src, $out) {
    $ErrorActionPreference = "Continue"
    & clang -o $out $src output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1 | Out-Null
    $ErrorActionPreference = "Stop"
    if ($LASTEXITCODE -ne 0) { Write-Host "Link $out FAILED"; exit 1 }
}

# gen3 -> gen4
Write-Host "=== gen3 -> gen4 ==="
Run-Timed ".\gen3_test.exe" "nova_compiler.nova" 120000 "gen3"
Link-It "nova_compiler.ll" "gen4_cfg.exe"

# gen4 -> gen5
Write-Host "=== gen4 -> gen5 ==="
Run-Timed ".\gen4_cfg.exe" "nova_compiler.nova" 120000 "gen4"
Copy-Item "nova_compiler.ll" "gen5_cfg.ll" -Force
Link-It "gen5_cfg.ll" "gen5_cfg.exe"

# gen5 -> gen6 (reconvergence)
Write-Host "=== gen5 -> gen6 ==="
Run-Timed ".\gen5_cfg.exe" "nova_compiler.nova" 120000 "gen5"
Copy-Item "nova_compiler.ll" "gen6_cfg.ll" -Force

$h5 = (Get-FileHash "gen5_cfg.ll" -Algorithm SHA256).Hash
$h6 = (Get-FileHash "gen6_cfg.ll" -Algorithm SHA256).Hash
if ($h5 -ne $h6) { Write-Host "RECONVERGENCE FAILED"; exit 1 }
Write-Host "gen5 == gen6 CONVERGED"

# Test cfg_test
Write-Host "=== cfg_test ==="
Run-Timed ".\gen5_cfg.exe" "cfg_test.nova" 30000 "compile cfg"
Link-It "cfg_test.ll" "cfg_test.exe"
Run-Timed ".\cfg_test.exe" "" 10000 "run cfg"
Get-Content "_bc_out.txt" -ErrorAction SilentlyContinue

# Install
Copy-Item "gen5_cfg.exe" "nova.exe" -Force
Write-Host "=== INSTALLED ==="
