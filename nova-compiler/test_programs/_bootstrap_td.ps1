$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir

function Run-Timed($exe, $argList, $timeout, $label) {
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

function Link-It($src, $out) {
    $ErrorActionPreference = "Continue"
    & clang -o $out $src output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1 | Out-Null
    $ErrorActionPreference = "Stop"
    if ($LASTEXITCODE -ne 0) { Write-Host "Link $out FAILED"; exit 1 }
}

# gen3 -> gen4
Write-Host "=== gen3 -> gen4 ==="
Run-Timed ".\gen3_test.exe" "nova_compiler.nova" 350000 "gen3"
Link-It "nova_compiler.ll" "gen4_td.exe"

# gen4 -> gen5
Write-Host "=== gen4 -> gen5 ==="
Run-Timed ".\gen4_td.exe" "nova_compiler.nova" 350000 "gen4"
Copy-Item "nova_compiler.ll" "gen5_td.ll" -Force
Link-It "gen5_td.ll" "gen5_td.exe"

# gen5 -> gen6 reconvergence
Write-Host "=== gen5 -> gen6 ==="
Run-Timed ".\gen5_td.exe" "nova_compiler.nova" 350000 "gen5"
Copy-Item "nova_compiler.ll" "gen6_td.ll" -Force
$h5 = (Get-FileHash "gen5_td.ll" -Algorithm SHA256).Hash
$h6 = (Get-FileHash "gen6_td.ll" -Algorithm SHA256).Hash
if ($h5 -ne $h6) { Write-Host "RECONVERGENCE FAILED: gen5 != gen6"; exit 1 }
Write-Host "gen5 == gen6 CONVERGED ($($h5.Substring(0,8)))"

# Smoke test: transitive deps
Write-Host "=== transitive deps test ==="
Run-Timed ".\gen5_td.exe" "trans_dep_test.nova" 30000 "compile"
Link-It "trans_dep_test.ll" "trans_dep_test.exe"
Run-Timed ".\trans_dep_test.exe" "" 10000 "run"
Get-Content "_bt_out.txt" -ErrorAction SilentlyContinue

# Smoke test: retroactive (existing)
Write-Host "=== retroactive test ==="
Run-Timed ".\gen5_td.exe" "retroactive_test.nova" 30000 "compile"
Link-It "retroactive_test.ll" "retroactive_test.exe"
Run-Timed ".\retroactive_test.exe" "" 10000 "run"
Get-Content "_bt_out.txt" -ErrorAction SilentlyContinue

# Install
Copy-Item "gen5_td.exe" "nova.exe" -Force
Write-Host "=== INSTALLED nova.exe ==="
