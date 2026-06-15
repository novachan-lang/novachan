$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir

function Invoke-Timed($exe, $args, $timeout, $label) {
    $p = Start-Process -FilePath $exe -ArgumentList $args -NoNewWindow -PassThru -RedirectStandardOutput "_bf_out.txt" -RedirectStandardError "_bf_err.txt"
    if (-not $p.WaitForExit($timeout)) { $p.Kill(); Write-Host "$label TIMEOUT"; exit 1 }
    $ec = $p.ExitCode
    if ($null -ne $ec -and $ec -ne 0) {
        Write-Host "$label FAILED (exit $ec)"
        Get-Content "_bf_err.txt" -ErrorAction SilentlyContinue | Select-Object -Last 30
        exit 1
    }
    Write-Host "$label OK"
}

function Link-Nova($src, $out) {
    $ErrorActionPreference = "Continue"
    & clang -o $out $src output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1 | Out-Null
    $ErrorActionPreference = "Stop"
    if ($LASTEXITCODE -ne 0) { Write-Host "Link $out FAILED"; exit 1 }
    Write-Host "Linked $out"
}

# Step 1: gen3 -> gen4
Write-Host "=== STEP 1: gen3 -> gen4 ==="
Invoke-Timed ".\gen3_test.exe" "nova_compiler.nova" 120000 "gen3->gen4"
Link-Nova "nova_compiler.ll" "gen4_new.exe"

# Step 2: gen4 -> gen5 (self-compile)
Write-Host "=== STEP 2: gen4 -> gen5 ==="
Invoke-Timed ".\gen4_new.exe" "nova_compiler.nova" 120000 "gen4->gen5"
Copy-Item "nova_compiler.ll" "gen5.ll" -Force
Link-Nova "gen5.ll" "gen5_new.exe"

# Step 3: gen5 -> gen6 (reconvergence check)
Write-Host "=== STEP 3: gen5 -> gen6 ==="
Invoke-Timed ".\gen5_new.exe" "nova_compiler.nova" 120000 "gen5->gen6"
Copy-Item "nova_compiler.ll" "gen6.ll" -Force

# Step 4: Compare gen5 == gen6
Write-Host "=== STEP 4: reconvergence ==="
$h5 = (Get-FileHash "gen5.ll" -Algorithm SHA256).Hash
$h6 = (Get-FileHash "gen6.ll" -Algorithm SHA256).Hash
if ($h5 -ne $h6) { Write-Host "RECONVERGENCE FAILED: gen5 != gen6"; exit 1 }
Write-Host "gen5 == gen6 (converged)"

# Step 5: gen4 smoke test — compile+run hello
Write-Host "=== STEP 5: smoke test ==="
$ErrorActionPreference = "Continue"
Invoke-Timed ".\gen4_new.exe" "hello.nova" 30000 "smoke-compile"
Link-Nova "hello.ll" "hello_smoke.exe"
$p = Start-Process -FilePath ".\hello_smoke.exe" -NoNewWindow -PassThru -RedirectStandardOutput "_bf_smoke.txt" -RedirectStandardError "_bf_smokeerr.txt"
if (-not $p.WaitForExit(10000)) { $p.Kill(); Write-Host "smoke TIMEOUT"; exit 1 }
$out = Get-Content "_bf_smoke.txt" -ErrorAction SilentlyContinue
Write-Host "smoke output: $out"
$ErrorActionPreference = "Stop"

# Step 6: Install
Write-Host "=== STEP 6: install ==="
Copy-Item "gen5_new.exe" "nova.exe" -Force
Write-Host "Installed as nova.exe"
Write-Host "=== BOOTSTRAP COMPLETE ==="
