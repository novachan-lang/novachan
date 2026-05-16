Set-Location $PSScriptRoot
$benches = @('bench_channel','bench_spawn','bench_string','bench_dict','bench_list_ops')
foreach ($b in $benches) {
    java -jar build\libs\nova-compiler-0.1.0-all.jar "test_programs\$b.nova" "test_programs\output\$b.ll" 2>&1 | Out-Null
    Write-Host "Built $b"
}
