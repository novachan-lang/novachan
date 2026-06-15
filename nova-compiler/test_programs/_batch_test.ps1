param([string[]]$Tests)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$compiler = ".\nova.exe"
$pass = 0; $fail = 0
foreach ($t in $Tests) {
    if (!(Test-Path "$t.nova")) { Write-Host "SKIP $t"; continue }
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0 -or !(Test-Path "$t.ll")) {
        Write-Host "FAIL compile: $t"
        if ($cr.Stderr) { Write-Host ($cr.Stderr | Select-Object -Last 10) }
        $fail++; continue
    }
    $ErrorActionPreference = "Continue"
    & clang -o "$t.exe" "$t.ll" output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1 | Out-Null
    $ErrorActionPreference = "Stop"
    if ($LASTEXITCODE -ne 0) { Write-Host "FAIL link: $t"; $fail++; continue }
    $rr = Invoke-Timed -FilePath ".\$t.exe" -Arguments "" -TimeoutMs 15000
    if ($rr.ExitCode -ne 0) {
        Write-Host "FAIL run: $t"
        if ($rr.Stderr) { Write-Host ($rr.Stderr | Select-Object -Last 5) }
        if ($rr.Stdout) { Write-Host ($rr.Stdout | Select-Object -Last 5) }
        $fail++; continue
    }
    Write-Host "PASS $t : $($rr.Stdout | Select-Object -Last 1)"
    $pass++
}
Write-Host "`n$pass PASS, $fail FAIL"
