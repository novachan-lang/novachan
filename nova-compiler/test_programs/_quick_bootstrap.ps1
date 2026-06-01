Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Write-Host "Quick bootstrap: gen3 -> gen4 (compile only)..."
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
$r = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'nova_compiler.nova' -TimeoutMs 360000 -WorkingDirectory $PSScriptRoot
if ($r.ExitCode -ne 0) { Write-Host "FAIL"; if ($r.StdOut) { Write-Host $r.StdOut.Substring(0,[Math]::Min(500,$r.StdOut.Length)) }; exit 1 }
Write-Host "OK - compiled"
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
