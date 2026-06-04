Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
Write-Host "Compiling nova_compiler.nova (5-minute timeout)..."
$r = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'nova_compiler.nova' -TimeoutMs 300000 -WorkingDirectory $PSScriptRoot
Write-Host "Exit: $($r.ExitCode)  TimedOut: $($r.TimedOut)"
if ($r.StdOut) { Write-Host $r.StdOut.Substring(0, [Math]::Min(800, $r.StdOut.Length)) }
if ($r.StdErr) { Write-Host $r.StdErr.Substring(0, [Math]::Min(400, $r.StdErr.Length)) }
