. (Join-Path $PSScriptRoot "_proc_util.ps1")
$env:NOVA_NO_CACHE = "1"

$name = "_prz_kat_wire"
$src = Join-Path $PSScriptRoot "$name.nova"
$ll  = Join-Path $PSScriptRoot "$name.ll"
$exe = Join-Path $PSScriptRoot "$name.exe"

Remove-Item $src, $ll, $exe -Force -ErrorAction SilentlyContinue
Copy-Item (Join-Path $PSScriptRoot "..\..\prism\kat\_kat_prism_wire.nova") $src -Force

Write-Host "=== COMPILE ==="
& (Join-Path $PSScriptRoot "gen3_test.exe") "$name.nova" 2>&1 | Out-String | Write-Host
if (-not (Test-Path $ll)) {
    Write-Host "FAIL -- compile produced no IR"
    exit 1
}

Write-Host "=== LINK ==="
& clang -O2 -o $exe $ll (Join-Path $PSScriptRoot "..\compiler\nova_runtime.o") -lws2_32 -ladvapi32 2>&1 | Out-String | Write-Host
if (-not (Test-Path $exe)) {
    Write-Host "FAIL -- link failed"
    exit 1
}

Write-Host "=== RUN ==="
$r = Invoke-Timed -FilePath $exe -TimeoutMs 60000
Write-Host $r.StdOut
if ($r.StdErr) { Write-Host "STDERR:"; Write-Host $r.StdErr }
Write-Host "ExitCode=$($r.ExitCode) TimedOut=$($r.TimedOut)"

Remove-Item $src, $ll, $exe -Force -ErrorAction SilentlyContinue
