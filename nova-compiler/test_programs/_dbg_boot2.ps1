Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
$r = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'nova_compiler.nova' -TimeoutMs 180000 -WorkingDirectory $PSScriptRoot
Write-Host "Exit: $($r.ExitCode)"
if ($r.StdOut) {
    $lines = $r.StdOut -split "`n"
    foreach ($l in $lines) { Write-Host $l }
}
