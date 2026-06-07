param([int]$Timeout = 360)
$ErrorActionPreference = "Continue"
$tp = $Timeout * 1000

Write-Host "=== Bootstrap: gen4 -> gen5 ==="
Remove-Item gen5_test.exe, gen6_test.exe -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "./gen4_test.exe" -ArgumentList "nova_compiler.nova" -NoNewWindow -PassThru
$done = $p.WaitForExit($tp)
if (-not $done) { $p.Kill(); Write-Host "gen5 compile TIMEOUT"; exit 1 }
if (-not (Test-Path "nova_compiler.ll")) { Write-Host "gen5 compile FAILED"; exit 1 }
Copy-Item nova_compiler.ll gen5.ll
Write-Host "gen5 IR produced"

& clang -O2 -o gen5_test.exe gen5.ll output/nova_runtime.c -lws2_32 -ladvapi32 2>$null
if (-not (Test-Path "gen5_test.exe")) { Write-Host "gen5 link FAILED"; exit 1 }
Write-Host "gen5_test.exe built"

Write-Host "=== Bootstrap: gen5 -> gen6 ==="
Remove-Item nova_compiler.ll -ErrorAction SilentlyContinue
$p2 = Start-Process -FilePath "./gen5_test.exe" -ArgumentList "nova_compiler.nova" -NoNewWindow -PassThru
$done2 = $p2.WaitForExit($tp)
if (-not $done2) { $p2.Kill(); Write-Host "gen6 compile TIMEOUT"; exit 1 }
if (-not (Test-Path "nova_compiler.ll")) { Write-Host "gen6 compile FAILED"; exit 1 }
Copy-Item nova_compiler.ll gen6.ll
Write-Host "gen6 IR produced"

& clang -O2 -o gen6_test.exe gen6.ll output/nova_runtime.c -lws2_32 -ladvapi32 2>$null
if (-not (Test-Path "gen6_test.exe")) { Write-Host "gen6 link FAILED"; exit 1 }
Write-Host "gen6_test.exe built"

Write-Host "=== Comparing gen5 vs gen6 ==="
$h5 = (Get-FileHash gen5_test.exe -Algorithm SHA256).Hash
$h6 = (Get-FileHash gen6_test.exe -Algorithm SHA256).Hash
Write-Host "gen5: $h5"
Write-Host "gen6: $h6"
if ($h5 -eq $h6) {
    Write-Host "BOOTSTRAP CONVERGED (gen5 == gen6)"
    Copy-Item gen5_test.exe gen3_test.exe -Force
    Write-Host "gen3_test.exe updated"
} else {
    Write-Host "BOOTSTRAP DIVERGED - gen5 != gen6"
    exit 1
}
