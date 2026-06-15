param([string]$exe)
$dir=$PSScriptRoot
$sw=[System.Diagnostics.Stopwatch]::StartNew()
$p=New-Object System.Diagnostics.ProcessStartInfo;$p.FileName="$dir\$exe";$p.WorkingDirectory=$dir
$p.UseShellExecute=$false;$p.RedirectStandardOutput=$true;$p.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$p;$pr.Start()|Out-Null
$o=$pr.StandardOutput.ReadToEndAsync()
if(-not $pr.WaitForExit(60000)){$pr.Kill();Write-Host "TIMEOUT";exit}
$sw.Stop()
Write-Host ("{0,-26} {1,8:N0} ms   out={2}" -f $exe, $sw.Elapsed.TotalMilliseconds, $o.Result.Trim())
