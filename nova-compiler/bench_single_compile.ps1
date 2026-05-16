Set-Location $PSScriptRoot
$t = (Measure-Command {
    java -jar build\libs\nova-compiler-0.1.0-all.jar test_programs\combined_test.nova test_programs\output\combined_test.ll 2>&1 | Out-Null
}).TotalMilliseconds
$lines = (Get-Content test_programs\combined_test.nova).Count
Write-Host "Compiled $lines lines in $([math]::Round($t))ms (includes JVM startup)"
Write-Host "Effective: $([math]::Round($lines * 1000 / $t)) lines/sec"
