Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$tests = @("float_test", "struct_advanced_test")
foreach ($t in $tests) {
    Write-Host "=== $t ==="
    $cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "`"$PSScriptRoot\$t.nova`"" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0) { Write-Host "  COMPILE FAIL"; continue }
    Copy-Item "$PSScriptRoot\output\nova_runtime.c" "$PSScriptRoot\rt_tmp.c" -Force
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$PSScriptRoot\$t.exe`" `"$PSScriptRoot\$t.ll`" `"$PSScriptRoot\rt_tmp.c`" $NovaLinkFlags" -TimeoutMs 60000
    Write-Host "LINK EXIT: $($lr.ExitCode)"
    if ($lr.StdOut) { $lr.StdOut | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" } }
    if ($lr.StdErr) { $lr.StdErr | Select-Object -First 10 | ForEach-Object { Write-Host "  $_" } }
    Remove-Item "$PSScriptRoot\$t.ll","$PSScriptRoot\$t.exe","$PSScriptRoot\rt_tmp.c" -Force -ErrorAction SilentlyContinue
}
