$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir

function Run-Timed2($exe, $argList, $timeout, $label) {
    if ($argList -and $argList -ne "") {
        $p = Start-Process -FilePath $exe -ArgumentList $argList -NoNewWindow -PassThru -RedirectStandardOutput "_bt_out.txt" -RedirectStandardError "_bt_err.txt"
    } else {
        $p = Start-Process -FilePath $exe -NoNewWindow -PassThru -RedirectStandardOutput "_bt_out.txt" -RedirectStandardError "_bt_err.txt"
    }
    if (-not $p.WaitForExit($timeout)) { $p.Kill(); Write-Host "$label TIMEOUT"; exit 1 }
    $ec = $p.ExitCode
    if ($null -ne $ec -and $ec -ne 0) {
        Write-Host "$label FAILED (exit $ec)"
        Get-Content "_bt_err.txt" -ErrorAction SilentlyContinue | Select-Object -Last 30
        exit 1
    }
    Write-Host "$label OK"
}

function Link-It2($src, $out) {
    $ErrorActionPreference = "Continue"
    & clang -o $out $src output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1 | Out-Null
    $ErrorActionPreference = "Stop"
    if ($LASTEXITCODE -ne 0) { Write-Host "Link $out FAILED"; exit 1 }
}

# gen3 -> gen4
Write-Host "=== gen3 -> gen4 ==="
Run-Timed2 ".\gen3_test.exe" "nova_compiler.nova" 300000 "gen3"
Link-It2 "nova_compiler.ll" "gen4_tp.exe"

# gen4 -> gen5 (self-compile)
Write-Host "=== gen4 -> gen5 ==="
Run-Timed2 ".\gen4_tp.exe" "nova_compiler.nova" 300000 "gen4"
Copy-Item "nova_compiler.ll" "gen5_tp.ll" -Force
Link-It2 "gen5_tp.ll" "gen5_tp.exe"

# gen5 -> gen6 (reconvergence)
Write-Host "=== gen5 -> gen6 ==="
Run-Timed2 ".\gen5_tp.exe" "nova_compiler.nova" 300000 "gen5"
Copy-Item "nova_compiler.ll" "gen6_tp.ll" -Force
$h5 = (Get-FileHash "gen5_tp.ll" -Algorithm SHA256).Hash
$h6 = (Get-FileHash "gen6_tp.ll" -Algorithm SHA256).Hash
if ($h5 -ne $h6) { Write-Host "RECONVERGENCE FAILED"; exit 1 }
Write-Host "gen5 == gen6 CONVERGED"

# Test type_pred_test
Write-Host "=== type_pred_test ==="
Run-Timed2 ".\gen5_tp.exe" "type_pred_test.nova" 30000 "compile"
Link-It2 "type_pred_test.ll" "type_pred_test.exe"
Run-Timed2 ".\type_pred_test.exe" "" 10000 "run"
Get-Content "_bt_out.txt" -ErrorAction SilentlyContinue

# Install
Copy-Item "gen5_tp.exe" "nova.exe" -Force
Write-Host "=== INSTALLED ==="
