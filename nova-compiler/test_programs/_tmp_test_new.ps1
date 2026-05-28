Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Build new compiler
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 60000
if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL"; if ($cr.StdOut) { Write-Host $cr.StdOut }; exit 1 }
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen2_new.exe nova_compiler.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
if (!(Test-Path "gen2_new.exe")) { Write-Host "LINK FAIL"; exit 1 }
$compiler = (Resolve-Path ".\gen2_new.exe").Path
Write-Host "New compiler built"

# Test set_test
$cr2 = Invoke-Timed -FilePath $compiler -Arguments "set_test.nova" -TimeoutMs 30000
Write-Host "set_test compile: $($cr2.ExitCode)"
if ($cr2.ExitCode -eq 0) {
    $lr2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o set_test.exe set_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (Test-Path "set_test.exe") {
        $rr = Invoke-Timed -FilePath (Resolve-Path ".\set_test.exe").Path -Arguments "" -TimeoutMs 10000
        Write-Host "set_test: exit=$($rr.ExitCode) $($rr.StdOut.Trim())"
    } else {
        Write-Host "set_test: LINK FAIL"
        if ($lr2.StdErr) { $lr2.StdErr -split "`n" | Where-Object { $_ -match "error:" } | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" } }
    }
}
Remove-Item "set_test.exe","set_test.ll" -Force -ErrorAction SilentlyContinue

# Test stdlib_collections_test
$cr3 = Invoke-Timed -FilePath $compiler -Arguments "stdlib_collections_test.nova" -TimeoutMs 30000
Write-Host "stdlib_collections compile: $($cr3.ExitCode)"
if ($cr3.ExitCode -eq 0) {
    $lr3 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o stdlib_collections_test.exe stdlib_collections_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (Test-Path "stdlib_collections_test.exe") {
        $rr2 = Invoke-Timed -FilePath (Resolve-Path ".\stdlib_collections_test.exe").Path -Arguments "" -TimeoutMs 10000
        Write-Host "stdlib_collections: exit=$($rr2.ExitCode) $($rr2.StdOut.Trim())"
    } else {
        Write-Host "stdlib_collections: LINK FAIL"
        if ($lr3.StdErr) { $lr3.StdErr -split "`n" | Where-Object { $_ -match "error:" } | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" } }
    }
}
Remove-Item "stdlib_collections_test.exe","stdlib_collections_test.ll" -Force -ErrorAction SilentlyContinue

# Test bytes_test
$cr4 = Invoke-Timed -FilePath $compiler -Arguments "bytes_test.nova" -TimeoutMs 30000
Write-Host "bytes_test compile: $($cr4.ExitCode)"
if ($cr4.ExitCode -eq 0) {
    $lr4 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o bytes_test.exe bytes_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (Test-Path "bytes_test.exe") {
        $rr3 = Invoke-Timed -FilePath (Resolve-Path ".\bytes_test.exe").Path -Arguments "" -TimeoutMs 10000
        Write-Host "bytes_test: exit=$($rr3.ExitCode) $($rr3.StdOut.Trim())"
    } else {
        Write-Host "bytes_test: LINK FAIL"
    }
}
Remove-Item "bytes_test.exe","bytes_test.ll","gen2_new.exe","nova_compiler.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
