Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "=== trait_bounds_test (should pass) ==="
$r1 = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "trait_bounds_test.nova" -TimeoutMs 30000
Write-Host "COMPILE EXIT=$($r1.ExitCode)"
if ($r1.StdOut -ne "") { Write-Host $r1.StdOut }
if ($r1.StdErr -ne "") { Write-Host $r1.StdErr }
if ($r1.ExitCode -eq 0 -and (Test-Path "trait_bounds_test.ll")) {
    $l1 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o trait_bounds_test.exe trait_bounds_test.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
    if (Test-Path "trait_bounds_test.exe") {
        $t1 = Invoke-Timed -FilePath (Resolve-Path ".\trait_bounds_test.exe").Path -Arguments "" -TimeoutMs 10000
        Write-Host "RUN EXIT=$($t1.ExitCode)"
        Write-Host $t1.StdOut
    }
    Remove-Item "trait_bounds_test.ll","trait_bounds_test.exe" -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "=== trait_bounds_fail_test (should fail compile) ==="
$r2 = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "trait_bounds_fail_test.nova" -TimeoutMs 30000
Write-Host "COMPILE EXIT=$($r2.ExitCode)"
if ($r2.StdOut -ne "") { Write-Host $r2.StdOut }
if ($r2.StdErr -ne "") { Write-Host $r2.StdErr }

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
