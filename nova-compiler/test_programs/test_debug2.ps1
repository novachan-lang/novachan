Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path ".\gen1_final_ipt.exe").Path
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
Write-Host "gen1 exit: $($proc.ExitCode)"

if (Test-Path "struct_test.ll") {
    Write-Host "gen1 compiled OK"
    Remove-Item "struct_test.ll" -Force
}

$psi2 = New-Object System.Diagnostics.ProcessStartInfo
$psi2.FileName = (Resolve-Path ".\gen2_trait.exe").Path
$psi2.Arguments = "struct_test.nova"
$psi2.UseShellExecute = $false
$psi2.RedirectStandardOutput = $true
$psi2.RedirectStandardError = $true
$psi2.CreateNoWindow = $true
$proc2 = [System.Diagnostics.Process]::Start($psi2)
$stdout2 = $proc2.StandardOutput.ReadToEndAsync()
$stderr2 = $proc2.StandardError.ReadToEndAsync()
$done2 = $proc2.WaitForExit(15000)
if (!$done2) { try { $proc2.Kill() } catch {}; Write-Host "TIMEOUT" }
[System.Threading.Tasks.Task]::WaitAll($stdout2, $stderr2)
Write-Host "gen2 exit: $($proc2.ExitCode)"
if ($stderr2.Result.Length -gt 0) { Write-Host "STDERR: $($stderr2.Result.Substring(0, [Math]::Min(500, $stderr2.Result.Length)))" }

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
