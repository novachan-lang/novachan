$dir=$PSScriptRoot; $crashWithOutput=0; $crashNoOutput=0; $ok=0
for($i=0;$i -lt 40;$i++){
  $ps=New-Object System.Diagnostics.ProcessStartInfo
  $ps.FileName="$dir\_stk_exact.exe"; $ps.WorkingDirectory=$dir
  $ps.UseShellExecute=$false; $ps.RedirectStandardOutput=$true; $ps.RedirectStandardError=$true; $ps.CreateNoWindow=$true
  $pr=[System.Diagnostics.Process]::new(); $pr.StartInfo=$ps; $pr.Start()|Out-Null
  $o=$pr.StandardOutput.ReadToEndAsync(); $e=$pr.StandardError.ReadToEndAsync()
  if(-not $pr.WaitForExit(15000)){ $pr.Kill(); continue }
  [System.Threading.Tasks.Task]::WaitAll($o,$e)
  if($pr.ExitCode -eq 0){ $ok++ }
  elseif($o.Result -match "all passed"){ $crashWithOutput++ }
  else{ $crashNoOutput++ }
}
Write-Host "ok=$ok  crash-AFTER-all-passed(teardown)=$crashWithOutput  crash-BEFORE-output=$crashNoOutput"
