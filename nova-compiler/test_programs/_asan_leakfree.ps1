param([string]$t)
$dir=$PSScriptRoot
$env:ASAN_OPTIONS="detect_leaks=0:abort_on_error=0:print_stats=0"
$crash=0;$ok=0;$codes=@()
for($i=1;$i -le 8;$i++){
  $p2=New-Object System.Diagnostics.ProcessStartInfo
  $p2.FileName="$dir\${t}_asan.exe";$p2.WorkingDirectory=$dir
  $p2.UseShellExecute=$false;$p2.RedirectStandardOutput=$true;$p2.RedirectStandardError=$true;$p2.CreateNoWindow=$true
  $pp=[System.Diagnostics.Process]::new();$pp.StartInfo=$p2;$pp.Start()|Out-Null
  $o=$pp.StandardOutput.ReadToEndAsync();$ee=$pp.StandardError.ReadToEndAsync()
  if(-not $pp.WaitForExit(15000)){$pp.Kill();$codes+="TIMEOUT";continue}
  [System.Threading.Tasks.Task]::WaitAll($o,$ee)
  $codes+=$pp.ExitCode
  if($pp.ExitCode -eq 0){$ok++}else{$crash++; if($ee.Result.Length -gt 5 -and $crash -eq 1){Write-Host "REPORT($t):"; Write-Host ($ee.Result.Substring(0,[Math]::Min(1800,$ee.Result.Length)))}}
}
Write-Host "${t}: ok=$ok crash=$crash codes=$($codes -join ',')"
