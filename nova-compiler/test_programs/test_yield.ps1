Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "Building gen2 with yield support..."
if (Test-Path "nova_compiler.ll") { Remove-Item "nova_compiler.ll" -Force }
$p = Start-Process -FilePath ".\gen1_final_ipt.exe" -ArgumentList "nova_compiler.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "gen2_cout.txt" -RedirectStandardError "gen2_cerr.txt" -PassThru -NoNewWindow
$done = $p.WaitForExit(60000)
if (!$done) { try { $p.Kill() } catch {}; Write-Host "TIMEOUT: gen2 compile"; exit 1 }
if (!(Test-Path "nova_compiler.ll")) { Write-Host "FAIL: gen2 compile"; Get-Content "gen2_cerr.txt" -ErrorAction SilentlyContinue; exit 1 }
Move-Item "nova_compiler.ll" "gen2_yield.ll" -Force

$p2 = Start-Process -FilePath "clang" -ArgumentList "-O2 -o gen2_yield.exe gen2_yield.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "gen2_link_err.txt" -PassThru -NoNewWindow
$done2 = $p2.WaitForExit(120000)
if (!$done2) { try { $p2.Kill() } catch {}; Write-Host "TIMEOUT: gen2 link"; exit 1 }
if (!(Test-Path "gen2_yield.exe")) { Write-Host "FAIL: gen2 link"; Get-Content "gen2_link_err.txt"; exit 1 }
Write-Host "gen2_yield.exe: $((Get-Item 'gen2_yield.exe').Length) bytes"

Write-Host ""
Write-Host "=== yield_test ==="
if (Test-Path "yield_test.ll") { Remove-Item "yield_test.ll" -Force }
$p3 = Start-Process -FilePath ".\gen2_yield.exe" -ArgumentList "yield_test.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "yield_cout.txt" -RedirectStandardError "yield_cerr.txt" -PassThru -NoNewWindow
$done3 = $p3.WaitForExit(15000)
if (!$done3) { try { $p3.Kill() } catch {}; Write-Host "TIMEOUT: yield compile"; exit 1 }
if (!(Test-Path "yield_test.ll")) { Write-Host "FAIL(compile): yield_test"; Get-Content "yield_cerr.txt" -ErrorAction SilentlyContinue; exit 1 }
Write-Host "Compiled OK: $((Get-Item 'yield_test.ll').Length) bytes"

$p4 = Start-Process -FilePath "clang" -ArgumentList "-O2 -o yield_test.exe yield_test.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "yield_link_err.txt" -PassThru -NoNewWindow
$done4 = $p4.WaitForExit(30000)
if (!$done4) { try { $p4.Kill() } catch {}; Write-Host "TIMEOUT: yield link"; exit 1 }
if (!(Test-Path "yield_test.exe")) { Write-Host "FAIL(link): yield_test"; Get-Content "yield_link_err.txt"; exit 1 }

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
if (!$exited) { try { $proc.Kill() } catch {}; Write-Host "TIMEOUT: yield_test run"; exit 1 }
Write-Host "Exit: $($proc.ExitCode)"
Write-Host "Output:"
[System.Threading.Tasks.Task]::WaitAll($stdout, $stderr)
Write-Host $stdout.Result
if ($stderr.Result.Length -gt 0) { Write-Host "STDERR: $($stderr.Result)" }

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
