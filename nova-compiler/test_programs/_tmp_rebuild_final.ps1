Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Rebuild compiler with bytes fix
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 60000
if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL"; exit 1 }
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen2_new.exe nova_compiler.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
if (!(Test-Path "gen2_new.exe")) { Write-Host "LINK FAIL"; exit 1 }
$compiler = (Resolve-Path ".\gen2_new.exe").Path

# Test bytes_test with new compiler
$cr2 = Invoke-Timed -FilePath $compiler -Arguments "bytes_test.nova" -TimeoutMs 30000
Write-Host "bytes_test compile: exit=$($cr2.ExitCode)"
if ($cr2.ExitCode -eq 0) {
    $lr2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o bytes_test.exe bytes_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (Test-Path "bytes_test.exe") {
        $rr = Invoke-Timed -FilePath (Resolve-Path ".\bytes_test.exe").Path -Arguments "" -TimeoutMs 10000
        Write-Host "bytes_test run: exit=$($rr.ExitCode) $($rr.StdOut.Trim())"
    } else {
        Write-Host "bytes_test: LINK FAIL"
    }
}
Remove-Item "bytes_test.exe","bytes_test.ll","gen2_new.exe","nova_compiler.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
