Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "=== yield_test (no optimization) ==="
if (Test-Path "yield_test.exe") { Remove-Item "yield_test.exe" -Force }

$p4 = Start-Process -FilePath "clang" -ArgumentList "-O0 -o yield_test.exe yield_test.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "yield_link_err.txt" -PassThru -NoNewWindow
$done4 = $p4.WaitForExit(30000)
if (!$done4) { try { $p4.Kill() } catch {}; Write-Host "TIMEOUT: link"; exit 1 }
if (!(Test-Path "yield_test.exe")) { Write-Host "FAIL(link)"; Get-Content "yield_link_err.txt"; exit 1 }

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path ".\yield_test.exe").Path
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$proc = [System.Diagnostics.Process]::Start($psi)
$stdout = $proc.StandardOutput.ReadToEndAsync()
$stderr = $proc.StandardError.ReadToEndAsync()
$exited = $proc.WaitForExit(5000)
if (!$exited) { try { $proc.Kill() } catch {}; Write-Host "TIMEOUT: run"; exit 1 }
[System.Threading.Tasks.Task]::WaitAll($stdout, $stderr)
Write-Host "Exit: $($proc.ExitCode)"
Write-Host "Output:"
Write-Host $stdout.Result
if ($stderr.Result.Length -gt 0) { Write-Host "STDERR: $($stderr.Result)" }

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
