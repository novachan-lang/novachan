Set-Location $PSScriptRoot
$files = Get-ChildItem "test_programs\*.nova" | Where-Object { $_.Name -notmatch '^_' }
$totalLines = 0
foreach ($f in $files) { $totalLines += (Get-Content $f.FullName).Count }

$times = @()
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command {
        foreach ($f in $files) {
            $out = "test_programs\output\$($f.BaseName).ll"
            & java -jar build\libs\nova-compiler-0.1.0-all.jar $f.FullName $out 2>&1 | Out-Null
        }
    }).TotalMilliseconds
    $times += [math]::Round($t)
}
$avg = ($times | Measure-Object -Average).Average
$lps = [math]::Round($totalLines * 1000 / $avg)
Write-Host "Total source lines: $totalLines"
Write-Host "Compile times (ms): $($times -join ', ')"
Write-Host "Average: $([math]::Round($avg)) ms"
Write-Host "Throughput: $lps lines/sec"
