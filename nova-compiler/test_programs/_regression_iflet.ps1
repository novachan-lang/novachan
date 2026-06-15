. "$PSScriptRoot\_proc_util.ps1"
$base = $PSScriptRoot
$compiler = "$base\gen3_test.exe"
$pass = 0; $fail = 0; $skip = 0

$tests = Get-ChildItem "$base\*_test.nova" | ForEach-Object { $_.BaseName }

foreach ($t in $tests) {
    $novaFile = "$base\$t.nova"
    $llFile = "$base\$t.ll"
    $exeFile = "$base\$t.exe"

    # Delete cached .ll
    if (Test-Path $llFile) { Remove-Item $llFile -Force }

    # Compile
    $env:NOVA_NO_CACHE = "1"
    $cr = Invoke-Timed -FilePath $compiler -Arguments "`"$novaFile`"" -TimeoutMs 60000 -WorkingDirectory $base
    $env:NOVA_NO_CACHE = $null

    if ($cr.TimedOut) { Write-Host "FAIL compile (timeout) $t"; $fail++; continue }
    if ($cr.ExitCode -ne 0 -or !(Test-Path $llFile)) {
        Write-Host "FAIL compile $t"
        $fail++; continue
    }

    # Link
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$exeFile`" `"$llFile`" `"$base\output\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $base
    if ($lr.ExitCode -ne 0) { Write-Host "FAIL link $t"; $fail++; continue }

    # Run
    $rr = Invoke-Timed -FilePath $exeFile -Arguments "" -TimeoutMs 15000 -WorkingDirectory $base
    if ($rr.TimedOut) { Write-Host "FAIL run (timeout) $t"; $fail++; continue }

    # Check for FAIL in stderr (assert_eq failures)
    $hasFail = $false
    if ($rr.StdErr -and $rr.StdErr -match "FAIL assert") { $hasFail = $true }

    if ($rr.ExitCode -ne 0) {
        Write-Host "FAIL run (exit=$($rr.ExitCode)) $t"
        $fail++
    } elseif ($hasFail) {
        Write-Host "FAIL assert $t"
        Write-Host "  stderr: $($rr.StdErr.Trim())"
        $fail++
    } else {
        $lastLine = ($rr.StdOut -split "`n" | Where-Object { $_.Trim() } | Select-Object -Last 1)
        Write-Host "PASS $t -- $lastLine"
        $pass++
    }
}

Write-Host ""
Write-Host "=== REGRESSION RESULTS ==="
Write-Host "$pass PASS, $fail FAIL, $skip SKIP (out of $($tests.Count) tests)"
if ($fail -gt 0) { exit 1 }
