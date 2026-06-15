$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$ps=New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName="$dir\gen4_test.exe";$ps.Arguments="stacktracex.nova";$ps.WorkingDirectory=$dir
$ps.UseShellExecute=$false;$ps.RedirectStandardOutput=$true;$ps.RedirectStandardError=$true;$ps.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$ps;$pr.Start()|Out-Null
$o=$pr.StandardOutput.ReadToEndAsync();$e=$pr.StandardError.ReadToEndAsync()
if(-not $pr.WaitForExit(60000)){$pr.Kill();Write-Host "TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($o,$e)
Write-Host "compile exit=$($pr.ExitCode)"
