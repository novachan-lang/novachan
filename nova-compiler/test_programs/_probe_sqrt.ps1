$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = "$dir\gen4_new.exe"; $ps.Arguments = "_sqrt_loop_probe.nova"; $ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true
$ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
$pr.Start() | Out-Null
$co = $pr.StandardOutput.ReadToEndAsync(); $ce = $pr.StandardError.ReadToEndAsync()
if (-not $pr.WaitForExit(60000)) { $pr.Kill(); $pr.WaitForExit(3000); Write-Host "COMPILE TIMEOUT"; exit 1 }
[System.Threading.Tasks.Task]::WaitAll($co, $ce)
Write-Host "compile exit=$($pr.ExitCode)"
if ($pr.ExitCode -ne 0) { Write-Host $ce.Result }
