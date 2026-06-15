$dir=$PSScriptRoot
$p=New-Object System.Diagnostics.ProcessStartInfo;$p.FileName="$dir\_probe_lto.exe";$p.WorkingDirectory=$dir
$p.UseShellExecute=$false;$p.RedirectStandardOutput=$true;$p.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$p;$pr.Start()|Out-Null
$o=$pr.StandardOutput.ReadToEndAsync()
if(-not $pr.WaitForExit(10000)){$pr.Kill();Write-Host "TIMEOUT"}else{Write-Host "exit=$($pr.ExitCode)";Write-Host $o.Result}
