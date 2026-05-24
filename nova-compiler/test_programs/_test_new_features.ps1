Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path ".\gen2_move.exe").Path
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$tests = @("buffer_test", "arena_test", "semver_test")
$pass = 0; $fail = 0; $failures = @()

foreach ($t in $tests) {
    Write-Host "--- $t ---"
    $tc = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000
    if ($tc.ExitCode -ne 0) {
        Write-Host "  COMPILE FAIL"
        if ($tc.StdOut) { $tc.StdOut -split "`n" | Select-Object -First 10 | ForEach-Object { Write-Host "  $_" } }
        $failures += "$t (COMPILE)"; $fail++; continue
    }
    if (!(Test-Path "$t.ll")) {
        Write-Host "  NO .ll FILE"
        $failures += "$t (NO .ll)"; $fail++; continue
    }

    $tl = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (!(Test-Path "$t.exe")) {
        Write-Host "  LINK FAIL"
        if ($tl.StdErr) { $tl.StdErr -split "`n" | Where-Object { $_ -match "error:" } | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" } }
        $failures += "$t (LINK)"; $fail++; continue
    }

    $tr = Invoke-Timed -FilePath (Resolve-Path ".\$t.exe").Path -Arguments "" -TimeoutMs 15000
    if ($tr.ExitCode -ne 0) {
        Write-Host "  RUN FAIL (exit=$($tr.ExitCode))"
        if ($tr.StdOut) { $tr.StdOut -split "`n" | Select-Object -First 10 | ForEach-Object { Write-Host "  $_" } }
        $failures += "$t (exit=$($tr.ExitCode))"; $fail++
    } else {
        if ($tr.StdOut) { Write-Host "  $($tr.StdOut.Trim())" }
        $pass++
    }
    Remove-Item "$t.exe","$t.ll" -Force -ErrorAction SilentlyContinue
}

Write-Host "`nNew features: $pass PASS, $fail FAIL"
if ($failures.Count -gt 0) { Write-Host "Failures:"; foreach ($f in $failures) { Write-Host "  $f" }; exit 1 }
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
