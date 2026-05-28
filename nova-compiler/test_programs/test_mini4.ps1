Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

if (Test-Path "mini4_test.ll") { Remove-Item "mini4_test.ll" -Force }
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path ".\gen2_trait.exe").Path
$psi.Arguments = "mini4_test.nova"
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$proc = [System.Diagnostics.Process]::Start($psi)
$proc.WaitForExit(10000) | Out-Null
Write-Host "exit=$($proc.ExitCode) ll=$(Test-Path 'mini4_test.ll')"

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
