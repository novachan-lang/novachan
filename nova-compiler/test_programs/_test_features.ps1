Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = "$PSScriptRoot\gen4_fix.exe"
$tests = @("range_pat_test.nova", "triple_quote_test.nova", "str_repeat_test.nova")
$pass = 0
$fail = 0

foreach ($test in $tests) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($test)
    Write-Host "--- $test ---"

    $r = Invoke-Timed -FilePath $compiler -Arguments $test -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
    if ($r.TimedOut -or $r.ExitCode -ne 0) {
        Write-Host "COMPILE FAIL: $test"
        if ($r.StdOut) { Write-Host $r.StdOut.Substring(0, [Math]::Min(2000, $r.StdOut.Length)) }
        $fail++
        continue
    }

    $ll = "$base.ll"
    if (!(Test-Path "$PSScriptRoot\$ll")) { Write-Host "NO .ll"; $fail++; continue }

    $exe = "$base.exe"
    $cr = Invoke-Timed -FilePath "clang" -Arguments "-O2 -o $exe $ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if ($cr.ExitCode -ne 0) { Write-Host "LINK FAIL: $test"; Write-Host $cr.StdErr; $fail++; continue }

    $rr = Invoke-Timed -FilePath "$PSScriptRoot\$exe" -Arguments '' -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
    if ($rr.TimedOut) { Write-Host "RUN TIMEOUT: $test"; $fail++; continue }
    if ($rr.ExitCode -ne 0) { Write-Host "RUN FAIL: $test exit=$($rr.ExitCode)"; Write-Host $rr.StdOut; $fail++; continue }
    Write-Host $rr.StdOut
    $pass++
}

Write-Host "`n=== $pass/$($pass + $fail) passed ==="
if ($fail -gt 0) { exit 1 }
