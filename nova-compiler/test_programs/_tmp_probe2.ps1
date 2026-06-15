Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen4_test.exe').Path -Arguments '_builtin_probe.nova' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
Write-Host "EXIT: $($r.ExitCode)"
if ($r.StdOut) { Write-Host "OUT: $($r.StdOut)" }
if ($r.StdErr) { Write-Host "ERR: $($r.StdErr)" }
if ($r.ExitCode -eq 0) {
    Write-Host ""
    Write-Host "=== file_exists dispatch ==="
    Select-String 'file_exists|slot\.__memo|memo_cache|nova_rt_file' _builtin_probe.ll | ForEach-Object { Write-Host $_.Line.Trim() }
}
