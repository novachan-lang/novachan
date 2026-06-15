Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$t = $args[0]
if (!$t) { Write-Host "Usage: _diag_single.ps1 <test_name>"; exit 1 }

$file = "$t.nova"
Write-Host "=== $t ==="
$cr = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments $file -TimeoutMs 30000
Write-Host "exit=$($cr.ExitCode)"
if ($cr.StdOut) { Write-Host "STDOUT:" ; Write-Host $cr.StdOut }
if ($cr.StdErr) { Write-Host "STDERR:" ; Write-Host $cr.StdErr }
