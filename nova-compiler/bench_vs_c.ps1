Set-Location $PSScriptRoot

Write-Host "=== NOVA vs C (-O2) ==="
Write-Host ""

Write-Host "--- fib(40) ---"
$novaTimes = @()
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & test_programs\output\fib_bench.exe | Out-Null }).TotalMilliseconds
    $novaTimes += [math]::Round($t, 1)
}
$cTimes = @()
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & bench\gate4_fib_O2.exe | Out-Null }).TotalMilliseconds
    $cTimes += [math]::Round($t, 1)
}
$novaAvg = [math]::Round(($novaTimes | Measure-Object -Minimum).Minimum, 1)
$cAvg = [math]::Round(($cTimes | Measure-Object -Minimum).Minimum, 1)
Write-Host "NOVA best: $novaAvg ms"
Write-Host "C -O2 best: $cAvg ms"
Write-Host "Ratio: $([math]::Round($novaAvg / $cAvg, 2))x"
Write-Host ""

Write-Host "--- num loop (10M iterations) ---"
$novaTimes = @()
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & test_programs\output\num_bench.exe | Out-Null }).TotalMilliseconds
    $novaTimes += [math]::Round($t, 1)
}
$cTimes = @()
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & bench\gate4_loop_O2.exe | Out-Null }).TotalMilliseconds
    $cTimes += [math]::Round($t, 1)
}
$novaAvg = [math]::Round(($novaTimes | Measure-Object -Minimum).Minimum, 1)
$cAvg = [math]::Round(($cTimes | Measure-Object -Minimum).Minimum, 1)
Write-Host "NOVA best: $novaAvg ms"
Write-Host "C -O2 best: $cAvg ms"
Write-Host "Ratio: $([math]::Round($novaAvg / $cAvg, 2))x"
