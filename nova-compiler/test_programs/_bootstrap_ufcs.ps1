Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== gen3 -> gen4 ==="
$c1 = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile nova_compiler.nova" -TimeoutMs 450000
Write-Host "gen3 EXIT=$($c1.ExitCode)"
if ($c1.ExitCode -ne 0) { Write-Host $c1.Stderr; exit 1 }
Move-Item -Force nova_compiler.ll gen4.ll
& clang -o gen4.exe gen4.ll output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "gen4 link FAILED"; exit 1 }
Write-Host "gen4 linked"

Write-Host "=== gen4 -> gen5 ==="
$c2 = Invoke-Timed -FilePath (Resolve-Path ".\gen4.exe").Path -Arguments "compile nova_compiler.nova" -TimeoutMs 450000
Write-Host "gen4 EXIT=$($c2.ExitCode)"
if ($c2.ExitCode -ne 0) { Write-Host $c2.Stderr; exit 1 }
Move-Item -Force nova_compiler.ll gen5.ll
& clang -o gen5.exe gen5.ll output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "gen5 link FAILED"; exit 1 }
Write-Host "gen5 linked"

Write-Host "=== gen5 -> gen6 ==="
$c3 = Invoke-Timed -FilePath (Resolve-Path ".\gen5.exe").Path -Arguments "compile nova_compiler.nova" -TimeoutMs 450000
Write-Host "gen5 EXIT=$($c3.ExitCode)"
if ($c3.ExitCode -ne 0) { Write-Host $c3.Stderr; exit 1 }
Move-Item -Force nova_compiler.ll gen6.ll

Write-Host "=== Reconvergence ==="
$h5 = (Get-FileHash gen5.ll -Algorithm MD5).Hash
$h6 = (Get-FileHash gen6.ll -Algorithm MD5).Hash
Write-Host "gen5: $h5"
Write-Host "gen6: $h6"
if ($h5 -ne $h6) { Write-Host "RECONVERGENCE FAILED"; exit 1 }
Write-Host "RECONVERGED"

Write-Host "=== Smoke ==="
$smoke = Invoke-Timed -FilePath (Resolve-Path ".\gen5.exe").Path -Arguments "compile hello.nova" -TimeoutMs 30000
if ($smoke.ExitCode -ne 0) { Write-Host $smoke.Stderr; exit 1 }
& clang -o hello_smoke.exe hello.ll output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1 | Out-Null
$run = Invoke-Timed -FilePath (Resolve-Path ".\hello_smoke.exe").Path -TimeoutMs 10000
Write-Host "smoke: $($run.Stdout.Trim())"

Copy-Item -Force gen5.exe nova.exe
Write-Host "DONE"
