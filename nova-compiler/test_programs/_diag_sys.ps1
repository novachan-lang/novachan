Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$compiler = (Resolve-Path ".\gen2_move.exe").Path
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath $compiler -Arguments "sys_test.nova" -TimeoutMs 30000
Write-Host "Compile: exit=$($cr.ExitCode)"
if ($cr.StdOut) { $cr.StdOut -split "`n" | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" } }

if (Test-Path "sys_test.ll") {
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o sys_test.exe sys_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    Write-Host "Link: exit=$($lr.ExitCode)"
    if ($lr.StdErr) { $lr.StdErr -split "`n" | Where-Object { $_ -match "error:|undefined" } | Select-Object -First 10 | ForEach-Object { Write-Host "  $_" } }
}
Remove-Item "sys_test.exe","sys_test.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
