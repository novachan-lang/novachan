$kotlinLib = 'C:\Users\mange\.gradle\caches\modules-2\files-2.1\org.jetbrains.kotlin\kotlin-stdlib\2.0.21\618b539767b4899b4660a83006e052b63f1db551\kotlin-stdlib-2.0.21.jar'
$cp = "$kotlinLib;build\libs\nova-compiler-0.1.0.jar"
$failures = @()
$pass = 0

Get-ChildItem test_programs\*.nova | ForEach-Object {
    $name = $_.BaseName
    $src = $_.FullName
    $ll = "test_programs\$name.ll"
    $result = java -cp $cp nova.EmitLlvmKt $src $ll 2>&1
    if ($LASTEXITCODE -ne 0) {
        $failures += "COMPILE FAIL: $name"
    } else {
        $exe = ".\test_programs\$name.exe"
        if (Test-Path $exe) {
            & $exe | Out-Null
            if ($LASTEXITCODE -ne 0) {
                $failures += "RUN FAIL: $name (exit $LASTEXITCODE)"
            } else {
                $pass++
                Write-Host "PASS: $name"
            }
        } else {
            $failures += "NO EXE: $name"
        }
    }
}

Write-Host ""
if ($failures.Count -gt 0) {
    Write-Host "FAILURES:"
    $failures | ForEach-Object { Write-Host "  $_" }
}
Write-Host "$pass / $(Get-ChildItem test_programs\*.nova | Measure-Object | Select-Object -ExpandProperty Count) programs pass"
