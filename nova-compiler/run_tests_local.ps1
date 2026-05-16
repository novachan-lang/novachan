Set-Location $PSScriptRoot
$testDir = "test_programs"
$excludeFiles = @('_error_samples.nova','mathlib.nova','shapes.nova','utils.nova','workers.nova','alloc_bench.nova','iter_bench.nova','bench_channel.nova','bench_spawn.nova','bench_string.nova','bench_dict.nova','bench_list_ops.nova')
$files = Get-ChildItem -Path "$testDir\*.nova" | Where-Object { $excludeFiles -notcontains $_.Name } | Sort-Object Name

$pass = 0; $fail = 0; $compile_fail = 0
$outDir = "$testDir\output"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

foreach ($f in $files) {
    $name = $f.Name
    $ll = "$outDir\$($name -replace '\.nova$','.ll')"

    $result = & java -jar build\libs\nova-compiler-0.1.0-all.jar $f.FullName $ll 2>&1
    $compileOk = $LASTEXITCODE -eq 0
    if (-not $compileOk) {
        Write-Host "COMPILE-FAIL  $name"
        $compile_fail++
        continue
    }

    $exe = $ll -replace '\.ll$','.exe'
    if (Test-Path $exe) {
        $output = & $exe 2>&1 | Out-String
        if ($LASTEXITCODE -eq 0) {
            Write-Host "PASS          $name"
            $pass++
        } else {
            Write-Host "RUNTIME-FAIL  $name (exit $LASTEXITCODE)"
            $fail++
        }
    } else {
        Write-Host "NO-EXE        $name"
        $fail++
    }
}
Write-Host ""
Write-Host "Results: $pass passed, $fail failed, $compile_fail compile errors out of $($files.Count) tests"
