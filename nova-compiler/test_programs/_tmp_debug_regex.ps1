Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$compiler = (Resolve-Path ".\gen2_move.exe").Path

$cr = Invoke-Timed -FilePath $compiler -Arguments "regex_test.nova" -TimeoutMs 30000
Write-Host "Compile: exit=$($cr.ExitCode)"
if ($cr.ExitCode -ne 0) { exit 1 }

$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o regex_test.exe regex_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
Write-Host "Link: exit=$($lr.ExitCode)"
if ($lr.StdErr) {
    $errs = $lr.StdErr -split "`n" | Where-Object { $_ -match "error:|undefined" } | Select-Object -First 10
    foreach ($e in $errs) { Write-Host "  $e" }
}
Remove-Item "regex_test.exe","regex_test.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
