Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

if (Test-Path "mini3_test.ll") { Remove-Item "mini3_test.ll" -Force }
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path ".\gen2_trait.exe").Path
$psi.Arguments = "mini3_test.nova"
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$proc = [System.Diagnostics.Process]::Start($psi)
$stdout = $proc.StandardOutput.ReadToEndAsync()
$stderr = $proc.StandardError.ReadToEndAsync()
$done = $proc.WaitForExit(10000)
if (!$done) { try { $proc.Kill() } catch {}; Write-Host "TIMEOUT" }
[System.Threading.Tasks.Task]::WaitAll($stdout, $stderr)
Write-Host "exit=$($proc.ExitCode) ll=$(Test-Path 'mini3_test.ll')"

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
