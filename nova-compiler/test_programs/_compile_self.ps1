Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$r = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'nova_compiler.nova' -TimeoutMs 300000 -WorkingDirectory $PSScriptRoot
Write-Host "Exit: $($r.ExitCode)"
Write-Host "Timeout: $($r.TimedOut)"
if ($r.StdErr) {
    $s = $r.StdErr
    if ($s.Length -gt 800) { $s = $s.Substring($s.Length - 800) }
    Write-Host "STDERR: $s"
}
if ($r.ExitCode -eq 0 -and (Test-Path "$PSScriptRoot\nova_compiler.ll")) {
    Write-Host "SUCCESS: nova_compiler.ll produced"
} else {
    Write-Host "FAILED"
    exit 1
}
