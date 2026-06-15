param([string]$t)
$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$ps=New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName="$dir\gen4_test.exe";$ps.Arguments="$t.nova";$ps.WorkingDirectory=$dir
$ps.UseShellExecute=$false;$ps.RedirectStandardOutput=$true;$ps.RedirectStandardError=$true;$ps.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$ps;$pr.Start()|Out-Null
$co=$pr.StandardOutput.ReadToEndAsync();$ce=$pr.StandardError.ReadToEndAsync()
if(-not $pr.WaitForExit(60000)){$pr.Kill();$pr.WaitForExit(3000);Write-Host "COMPILE TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($co,$ce)
Write-Host "exit code: $($pr.ExitCode)"
Write-Host "--- STDOUT ---"; Write-Host $co.Result
Write-Host "--- STDERR ---"; Write-Host $ce.Result
