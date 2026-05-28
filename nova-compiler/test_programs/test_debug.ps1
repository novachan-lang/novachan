Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path ".\gen2_trait.exe").Path
$psi.Arguments = "struct_test.nova"
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$proc = [System.Diagnostics.Process]::Start($psi)
$stdout = $proc.StandardOutput.ReadToEndAsync()
$stderr = $proc.StandardError.ReadToEndAsync()
$done = $proc.WaitForExit(15000)
if (!$done) { try { $proc.Kill() } catch {}; Write-Host "TIMEOUT" }
[System.Threading.Tasks.Task]::WaitAll($stdout, $stderr)
Write-Host "Exit: $($proc.ExitCode)"
if ($stdout.Result.Length -gt 0) { Write-Host "STDOUT: $($stdout.Result.Substring(0, [Math]::Min(500, $stdout.Result.Length)))" }
if ($stderr.Result.Length -gt 0) { Write-Host "STDERR: $($stderr.Result.Substring(0, [Math]::Min(500, $stderr.Result.Length)))" }
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
