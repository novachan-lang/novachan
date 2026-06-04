Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_w5b_new.exe").Path

foreach ($t in @('trait_test','closure_test','generics_test')) {
    $nova = "$PSScriptRoot\$t.nova"
    if (!(Test-Path $nova)) { continue }
    Write-Host "=== $t ==="
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
    Write-Host "Exit: $($cr.ExitCode)"
    if ($cr.StdOut) { Write-Host "STDOUT: $($cr.StdOut.Substring(0, [Math]::Min(500, $cr.StdOut.Length)))" }
    if ($cr.StdErr) { Write-Host "STDERR: $($cr.StdErr.Substring(0, [Math]::Min(500, $cr.StdErr.Length)))" }
    Write-Host ""
}
