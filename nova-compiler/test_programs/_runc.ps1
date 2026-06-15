param([string]$t)
$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$p=New-Object System.Diagnostics.ProcessStartInfo;$p.FileName="$dir\gen4_test.exe";$p.Arguments="$t.nova";$p.WorkingDirectory=$dir
$p.UseShellExecute=$false;$p.RedirectStandardOutput=$true;$p.RedirectStandardError=$true;$p.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$p;$pr.Start()|Out-Null
$o=$pr.StandardOutput.ReadToEndAsync();$e=$pr.StandardError.ReadToEndAsync()
if(-not $pr.WaitForExit(60000)){$pr.Kill();Write-Host "TIMEOUT";exit}
[System.Threading.Tasks.Task]::WaitAll($o,$e)
Write-Host "exit=$($pr.ExitCode)"; Write-Host $o.Result; Write-Host $e.Result
