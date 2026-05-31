Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$tests = @(
    'track7_encoding_test',
    'track7_logging_test',
    'track7_random_test',
    'track7_datetime_test',
    'track7_path_test',
    'track7_collections_lib_test'
)

$pass = 0; $fail = 0; $failures = @()

foreach ($t in $tests) {
    Write-Host "`n--- $t ---"

    $cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "$t.nova" -TimeoutMs 60000
    if ($cr.ExitCode -ne 0) {
        Write-Host "COMPILE FAIL (exit=$($cr.ExitCode))"
        if ($cr.StdErr) {
            $lines = $cr.StdErr -split "`n" | Select-Object -First 5
            foreach ($l in $lines) { Write-Host "  $l" }
        }
        $failures += "$t (COMPILE)"
        $fail++; continue
    }
    if (!(Test-Path "$t.ll")) {
        Write-Host "NO .ll produced"
        $failures += "$t (NO .ll)"
        $fail++; continue
    }

    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000
    if (!(Test-Path "$t.exe")) {
        Write-Host "LINK FAIL"
        if ($lr.StdErr) {
            $lines = $lr.StdErr -split "`n" | Where-Object { $_ -match "error" } | Select-Object -First 5
            foreach ($l in $lines) { Write-Host "  $l" }
        }
        $failures += "$t (LINK)"
        $fail++
        Remove-Item "$t.ll" -Force -ErrorAction SilentlyContinue
        continue
    }

    $rr = Invoke-Timed -FilePath (Resolve-Path ".\$t.exe").Path -TimeoutMs 15000
    Write-Host "Exit: $($rr.ExitCode) Timeout: $($rr.TimedOut)"
    if ($rr.StdOut) { Write-Host $rr.StdOut }
    if ($rr.StdErr) { Write-Host "stderr: $($rr.StdErr)" }

    Remove-Item "$t.ll","$t.exe" -Force -ErrorAction SilentlyContinue

    if ($rr.ExitCode -eq 0 -and -not $rr.TimedOut) {
        $pass++
    } else {
        $failures += "$t (RUN exit=$($rr.ExitCode))"
        $fail++
    }
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
Write-Host "`n=== TRACK 7 MODULE TESTS: $pass PASS, $fail FAIL ==="
if ($failures.Count -gt 0) {
    Write-Host "Failures:"
    foreach ($f in $failures) { Write-Host "  $f" }
}
if ($fail -gt 0) { exit 1 }
