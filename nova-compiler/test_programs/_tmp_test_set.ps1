Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Build with current gen2_move.exe + updated runtime
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 60000
if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL"; exit 1 }
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen2_new.exe nova_compiler.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
if (!(Test-Path "gen2_new.exe")) { Write-Host "LINK FAIL"; exit 1 }
$compiler = (Resolve-Path ".\gen2_new.exe").Path

# Test set_test
$cr2 = Invoke-Timed -FilePath $compiler -Arguments "set_test.nova" -TimeoutMs 30000
if ($cr2.ExitCode -ne 0) { Write-Host "set_test COMPILE FAIL"; Remove-Item "gen2_new.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue; exit 1 }
$lr2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o set_test.exe set_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
if (!(Test-Path "set_test.exe")) {
    Write-Host "set_test LINK FAIL"
    if ($lr2.StdErr) { $lr2.StdErr -split "`n" | Where-Object { $_ -match "error:" } | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" } }
    Remove-Item "gen2_new.exe","nova_runtime.c","set_test.ll" -Force -ErrorAction SilentlyContinue
    exit 1
}
$rr = Invoke-Timed -FilePath (Resolve-Path ".\set_test.exe").Path -Arguments "" -TimeoutMs 10000
Write-Host "set_test: exit=$($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut.Trim() }
Remove-Item "set_test.exe","set_test.ll","gen2_new.exe","nova_compiler.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
