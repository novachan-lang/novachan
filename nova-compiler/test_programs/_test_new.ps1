Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$compiler = ".\nova.exe"
$tests = @("parsec", "reflect_test", "parsec_satisfy_test", "parsec_test")
$pass = 0; $fail = 0
foreach ($t in $tests) {
    if (!(Test-Path "$t.nova")) { Write-Host "SKIP $t (no .nova)"; continue }
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0 -or !(Test-Path "$t.ll")) { Write-Host "FAIL compile: $t"; $fail++; continue }
    $ErrorActionPreference = "Continue"
    & clang -o "$t.exe" "$t.ll" output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1 | Out-Null
    $ErrorActionPreference = "Stop"
    if ($LASTEXITCODE -ne 0) { Write-Host "FAIL link: $t"; $fail++; continue }
    $rr = Invoke-Timed -FilePath ".\$t.exe" -Arguments "" -TimeoutMs 15000
    if ($rr.ExitCode -ne 0) { Write-Host "FAIL run: $t (exit=$($rr.ExitCode))"; Write-Host $rr.Stderr; $fail++; continue }
    Write-Host "PASS $t : $($rr.Stdout)"
    $pass++
}
Write-Host "`nResults: $pass PASS, $fail FAIL"
