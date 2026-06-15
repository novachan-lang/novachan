Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$compiler = ".\nova.exe"
$tests = @("tomlx","cfg_test","reflect_test","parsec")
$pass = 0; $fail = 0
foreach ($t in $tests) {
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0) {
        Write-Host "FAIL compile $t"
        Write-Host ($cr.Stderr | Select-Object -Last 5)
        $fail++; continue
    }
    $ErrorActionPreference = "Continue"
    & clang -o "$t.exe" "$t.ll" output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1 | Out-Null
    $ErrorActionPreference = "Stop"
    if ($LASTEXITCODE -ne 0) { Write-Host "FAIL link $t"; $fail++; continue }
    $rr = Invoke-Timed -FilePath ".\$t.exe" -TimeoutMs 15000
    if ($rr.ExitCode -ne 0) {
        Write-Host "FAIL run $t"
        $fail++; continue
    }
    Write-Host "PASS $t"
    $pass++
}
Write-Host "`n$pass PASS, $fail FAIL"
