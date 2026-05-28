param([string]$exe)
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path $exe).Path
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$p = [System.Diagnostics.Process]::Start($psi)
$stdout = $p.StandardOutput.ReadToEnd()
$stderr = $p.StandardError.ReadToEnd()
$done = $p.WaitForExit(5000)
if (!$done) { try { $p.Kill() } catch {}; Write-Host "TIMEOUT"; exit 1 }
Write-Host $stdout
if ($stderr) { Write-Host "STDERR: $stderr" }
exit $p.ExitCode
