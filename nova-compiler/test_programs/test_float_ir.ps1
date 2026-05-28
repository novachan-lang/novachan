Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

if (Test-Path "float_test.ll") { Remove-Item "float_test.ll" -Force }
$p = Start-Process -FilePath ".\gen1_final_ipt.exe" -ArgumentList "float_test.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "ft_cout.txt" -RedirectStandardError "ft_cerr.txt" -PassThru -NoNewWindow
$p.WaitForExit(30000) | Out-Null
if (!(Test-Path "float_test.ll")) { Write-Host "FAIL compile"; Get-Content "ft_cerr.txt" -ErrorAction SilentlyContinue; exit 1 }
Write-Host "Compiled OK"

$p2 = Start-Process -FilePath "clang" -ArgumentList "-O2 -o float_test.exe float_test.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "ft_link_err.txt" -PassThru -NoNewWindow
$p2.WaitForExit(30000) | Out-Null
if (!(Test-Path "float_test.exe")) { Write-Host "FAIL link"; Get-Content "ft_link_err.txt"; exit 1 }

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path ".\float_test.exe").Path
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$proc = [System.Diagnostics.Process]::Start($psi)
$stdout = $proc.StandardOutput.ReadToEndAsync()
$stderr = $proc.StandardError.ReadToEndAsync()
$proc.WaitForExit(5000) | Out-Null
[System.Threading.Tasks.Task]::WaitAll($stdout, $stderr)
Write-Host "Exit: $($proc.ExitCode)"
Write-Host "=== Output ==="
Write-Host $stdout.Result
if ($stderr.Result.Length -gt 0) { Write-Host "STDERR: $($stderr.Result)" }
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
