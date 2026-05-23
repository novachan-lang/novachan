Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen2_move.exe').Path -Arguments 'nova_compiler.nova' -TimeoutMs 120000
Write-Host "Exit: $($r.ExitCode) Timeout: $($r.TimedOut)"
if ($r.StdErr) {
    $errLen = [Math]::Min(2000, $r.StdErr.Length)
    Write-Host "STDERR: $($r.StdErr.Substring(0, $errLen))"
}
if (Test-Path 'nova_compiler.ll') {
    Write-Host "LL size: $((Get-Item nova_compiler.ll).Length)"
} else {
    Write-Host 'NO LL FILE'
}
