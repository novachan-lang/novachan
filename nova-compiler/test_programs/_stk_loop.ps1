param([int]$N=30, [string]$exe="_stk_exact.exe")
$dir=$PSScriptRoot; $crashes=0; $codes=@{}
for($i=0;$i -lt $N;$i++){
  $ps=New-Object System.Diagnostics.ProcessStartInfo
  $ps.FileName="$dir\$exe"; $ps.WorkingDirectory=$dir
  $ps.UseShellExecute=$false; $ps.RedirectStandardOutput=$true; $ps.RedirectStandardError=$true; $ps.CreateNoWindow=$true
  $pr=[System.Diagnostics.Process]::new(); $pr.StartInfo=$ps; $pr.Start()|Out-Null
  $o=$pr.StandardOutput.ReadToEndAsync(); $e=$pr.StandardError.ReadToEndAsync()
  if(-not $pr.WaitForExit(15000)){ $pr.Kill(); $crashes++; continue }
  [System.Threading.Tasks.Task]::WaitAll($o,$e)
  if($pr.ExitCode -ne 0){ $crashes++; $h=("0x{0:X8}" -f ($pr.ExitCode -band 0xFFFFFFFF)); $codes[$h]=($codes[$h]+1) }
}
Write-Host "$exe : crashes $crashes / $N"
$codes.GetEnumerator() | ForEach-Object { Write-Host "  $($_.Key): $($_.Value)" }
