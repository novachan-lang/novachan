Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$file = $args[0]
if (-not $file) { Write-Host "Usage: _compile_one.ps1 <file.nova>"; exit 1 }
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments $file -TimeoutMs 30000
if ($cr.ExitCode -ne 0) {
    Write-Host "COMPILE FAIL (exit=$($cr.ExitCode))"
    if ($cr.StdErr) { Write-Host $cr.StdErr.Substring(0, [Math]::Min(500, $cr.StdErr.Length)) }
    exit 1
}
Write-Host "COMPILE OK"
