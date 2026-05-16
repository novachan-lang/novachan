Set-Location $PSScriptRoot
clang -O2 test_c_loop.c -o test_c_loop.exe 2>&1 | Out-Null

if (-not (Test-Path test_c_loop.exe)) {
    Write-Host "C compile failed"
    exit 1
}

$times = @()
for ($i = 0; $i -lt 5; $i++) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    .\test_c_loop.exe | Out-Null
    $sw.Stop()
    $times += $sw.ElapsedMilliseconds
}
Write-Host "C loop times (ms): $($times -join ', ')"
Write-Host "Average: $([math]::Round(($times | Measure-Object -Average).Average, 1)) ms"
