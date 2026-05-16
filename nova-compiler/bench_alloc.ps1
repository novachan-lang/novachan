Set-Location $PSScriptRoot
$src = "test_programs\alloc_bench.nova"
$ll = "test_programs\output\alloc_bench.ll"
$exe = "test_programs\output\alloc_bench.exe"

$result = & java -jar build\libs\nova-compiler-0.1.0-all.jar $src $ll 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "COMPILE FAILED:"
    Write-Host $result
    exit 1
}

if (-not (Test-Path $exe)) {
    Write-Host "No exe produced"
    exit 1
}

$times = @()
for ($i = 0; $i -lt 5; $i++) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    & $exe | Out-Null
    $sw.Stop()
    $times += $sw.ElapsedMilliseconds
}
Write-Host "alloc_bench times (ms): $($times -join ', ')"
Write-Host "Average: $([math]::Round(($times | Measure-Object -Average).Average, 1)) ms"
