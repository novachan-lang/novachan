$dir=$PSScriptRoot
$env:ASAN_OPTIONS="abort_on_error=0:print_stacktrace=1"
$p=New-Object System.Diagnostics.ProcessStartInfo
$p.FileName="$dir\_stk_asan.exe";$p.WorkingDirectory=$dir
$p.UseShellExecute=$false;$p.RedirectStandardOutput=$true;$p.RedirectStandardError=$true;$p.CreateNoWindow=$true
$pp=[System.Diagnostics.Process]::new();$pp.StartInfo=$p;$pp.Start()|Out-Null
$o=$pp.StandardOutput.ReadToEndAsync();$ee=$pp.StandardError.ReadToEndAsync()
$pp.WaitForExit(20000)|Out-Null
[System.Threading.Tasks.Task]::WaitAll($o,$ee)
Write-Host "exit=$($pp.ExitCode)"
Write-Host "STDOUT-tail:"; Write-Host $o.Result
Write-Host "STDERR:"; Write-Host $ee.Result
