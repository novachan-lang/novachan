param([string]$exe)
$dir=$PSScriptRoot
$p=New-Object System.Diagnostics.ProcessStartInfo;$p.FileName="$dir\$exe";$p.WorkingDirectory=$dir
$p.UseShellExecute=$false;$p.RedirectStandardOutput=$true;$p.RedirectStandardError=$true;$p.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$p;$pr.Start()|Out-Null
$o=$pr.StandardOutput.ReadToEndAsync();$e=$pr.StandardError.ReadToEndAsync()
if(-not $pr.WaitForExit(10000)){$pr.Kill();Write-Host "TIMEOUT";exit}
[System.Threading.Tasks.Task]::WaitAll($o,$e)
Write-Host "exit=$($pr.ExitCode)"
Write-Host $o.Result
if($e.Result){Write-Host "ERR: $($e.Result)"}
