Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$file = $args[0]
if (!$file) { Write-Host "Usage: _compile_single.ps1 <file.nova>"; exit 1 }
$ll = $file -replace '\.nova$','.ll'
Remove-Item $ll -Force -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments $file -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "Exit: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host $cr.StdOut }
if ($cr.StdErr) { Write-Host $cr.StdErr }
