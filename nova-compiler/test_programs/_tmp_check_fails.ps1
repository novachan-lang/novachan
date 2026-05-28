Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$compiler = (Resolve-Path ".\gen2_move.exe").Path

# bytes_test: check compile error
$cr = Invoke-Timed -FilePath $compiler -Arguments "bytes_test.nova" -TimeoutMs 30000
Write-Host "bytes_test compile exit=$($cr.ExitCode)"
if ($cr.StdOut) { $cr.StdOut -split "`n" | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" } }
if ($cr.StdErr) { $cr.StdErr -split "`n" | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" } }

# set_test: compile + link + run
Write-Host ""
$cr2 = Invoke-Timed -FilePath $compiler -Arguments "set_test.nova" -TimeoutMs 30000
Write-Host "set_test compile exit=$($cr2.ExitCode)"
if ($cr2.ExitCode -eq 0) {
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o set_test.exe set_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (Test-Path "set_test.exe") {
        $rr = Invoke-Timed -FilePath (Resolve-Path ".\set_test.exe").Path -Arguments "" -TimeoutMs 10000
        Write-Host "set_test run exit=$($rr.ExitCode)"
        if ($rr.StdOut) { $rr.StdOut -split "`n" | Select-Object -Last 5 | ForEach-Object { Write-Host "  $_" } }
    }
}
Remove-Item "set_test.exe","set_test.ll" -Force -ErrorAction SilentlyContinue

# stdlib_collections_test
Write-Host ""
$cr3 = Invoke-Timed -FilePath $compiler -Arguments "stdlib_collections_test.nova" -TimeoutMs 30000
Write-Host "stdlib_collections_test compile exit=$($cr3.ExitCode)"
if ($cr3.ExitCode -eq 0) {
    $lr2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o stdlib_collections_test.exe stdlib_collections_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (Test-Path "stdlib_collections_test.exe") {
        $rr2 = Invoke-Timed -FilePath (Resolve-Path ".\stdlib_collections_test.exe").Path -Arguments "" -TimeoutMs 10000
        Write-Host "stdlib_collections_test run exit=$($rr2.ExitCode)"
        if ($rr2.StdOut) { $rr2.StdOut -split "`n" | Select-Object -Last 5 | ForEach-Object { Write-Host "  $_" } }
    }
}
Remove-Item "stdlib_collections_test.exe","stdlib_collections_test.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
