$dir=$PSScriptRoot
for($i=0;$i -lt 80;$i++){
  $ps=New-Object System.Diagnostics.ProcessStartInfo
  $ps.FileName="$dir\_stk_exact.exe";$ps.WorkingDirectory=$dir
  $ps.UseShellExecute=$false;$ps.RedirectStandardOutput=$true;$ps.RedirectStandardError=$true;$ps.CreateNoWindow=$true
  $pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$ps;$pr.Start()|Out-Null
  $o=$pr.StandardOutput.ReadToEndAsync();$e=$pr.StandardError.ReadToEndAsync()
  if(-not $pr.WaitForExit(15000)){$pr.Kill();continue}
  [System.Threading.Tasks.Task]::WaitAll($o,$e)
  if($pr.ExitCode -ne 0){
    Write-Host "CRASH iter $i exit=$('0x{0:X8}' -f ($pr.ExitCode -band 0xFFFFFFFF))"
    Write-Host "STDOUT: [$($o.Result.Trim())]"
    Write-Host "STDERR: [$($e.Result.Trim())]"
    exit 0
  }
}
Write-Host "no crash in 80 runs"
