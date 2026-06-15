. "$PSScriptRoot\_proc_util.ps1"
$base = $PSScriptRoot
$compiler = "$base\gen3_test.exe"
$pass = 0; $fail = 0

$tests = @("for_index_test", "for_destructure_test", "for_guard_test", "for_continue_test", "for_else_test", "for_test", "comprehension_test", "if_let_test", "while_let_test", "iter_test", "lambda_shorthand_test")

foreach ($t in $tests) {
    $novaFile = "$base\$t.nova"
    $llFile = "$base\$t.ll"
    $exeFile = "$base\$t.exe"
    if (Test-Path $llFile) { Remove-Item $llFile -Force }

    $env:NOVA_NO_CACHE = "1"
    $cr = Invoke-Timed -FilePath $compiler -Arguments "`"$novaFile`"" -TimeoutMs 60000 -WorkingDirectory $base
    $env:NOVA_NO_CACHE = $null

    if ($cr.TimedOut -or $cr.ExitCode -ne 0) { Write-Host "FAIL compile $t"; $fail++; continue }
    if (!(Test-Path $llFile)) { Write-Host "FAIL compile (no .ll) $t"; $fail++; continue }

    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$exeFile`" `"$llFile`" `"$base\output\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $base
    if ($lr.ExitCode -ne 0) { Write-Host "FAIL link $t"; $fail++; continue }

    $rr = Invoke-Timed -FilePath $exeFile -Arguments "" -TimeoutMs 15000 -WorkingDirectory $base
    if ($rr.TimedOut) { Write-Host "FAIL run (timeout) $t"; $fail++; continue }

    $hasFail = $false
    if ($rr.StdErr -and $rr.StdErr -match "FAIL assert") { $hasFail = $true }
    if ($rr.ExitCode -ne 0 -or $hasFail) {
        Write-Host "FAIL run $t"
        if ($rr.StdErr) { Write-Host "  stderr: $($rr.StdErr.Trim())" }
        $fail++
    } else {
        $lastLine = ($rr.StdOut -split "`n" | Where-Object { $_.Trim() } | Select-Object -Last 1)
        Write-Host "PASS $t -- $lastLine"
        $pass++
    }
}

Write-Host ""
Write-Host "=== SMOKE: $pass PASS, $fail FAIL (of $($tests.Count)) ==="
if ($fail -gt 0) { exit 1 }
