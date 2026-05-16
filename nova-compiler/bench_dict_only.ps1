Set-Location $PSScriptRoot
# Warmup
for ($w = 0; $w -lt 3; $w++) { & test_programs\output\bench_dict.exe | Out-Null }

$times = @()
for ($i = 0; $i -lt 7; $i++) {
    $t = (Measure-Command { & test_programs\output\bench_dict.exe | Out-Null }).TotalMilliseconds
    $times += [math]::Round($t, 1)
}
$sorted = $times | Sort-Object
Write-Host "bench_dict: best=$($sorted[0]) median=$($sorted[3]) all=($($times -join ', '))"
