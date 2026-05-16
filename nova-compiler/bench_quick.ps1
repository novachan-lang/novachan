Set-Location $PSScriptRoot
Write-Host "Warming up..."
& test_programs\output\bench_string.exe | Out-Null
& test_programs\output\bench_string.exe | Out-Null

Write-Host "bench_string:"
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & test_programs\output\bench_string.exe | Out-Null }).TotalMilliseconds
    Write-Host "  $([math]::Round($t, 1)) ms"
}

Write-Host "bench_dict:"
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & test_programs\output\bench_dict.exe | Out-Null }).TotalMilliseconds
    Write-Host "  $([math]::Round($t, 1)) ms"
}

Write-Host "bench_list_ops:"
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & test_programs\output\bench_list_ops.exe | Out-Null }).TotalMilliseconds
    Write-Host "  $([math]::Round($t, 1)) ms"
}
