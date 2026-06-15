$ErrorActionPreference = "Stop"
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir

Write-Host "=== gen3 -> gen4 ==="
$p = Start-Process -FilePath ".\gen3_test.exe" -ArgumentList "nova_compiler.nova" -NoNewWindow -PassThru -RedirectStandardOutput "_b_out.txt" -RedirectStandardError "_b_err.txt"
if (-not $p.WaitForExit(120000)) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
$ec = $p.ExitCode
if ($null -ne $ec -and $ec -ne 0) { Get-Content "_b_err.txt" | Select-Object -Last 20; exit 1 }
Write-Host "gen3 compile OK"

Write-Host "=== link gen4 ==="
$ErrorActionPreference = "Continue"
& clang -o gen4_r.exe nova_compiler.ll output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1
$ErrorActionPreference = "Stop"
if ($LASTEXITCODE -ne 0) { Write-Host "link FAILED"; exit 1 }
Write-Host "gen4 linked"

Write-Host "=== gen4 compiles reflect_test ==="
$p2 = Start-Process -FilePath ".\gen4_r.exe" -ArgumentList "reflect_test.nova" -NoNewWindow -PassThru -RedirectStandardOutput "_b_out2.txt" -RedirectStandardError "_b_err2.txt"
if (-not $p2.WaitForExit(60000)) { $p2.Kill(); Write-Host "TIMEOUT"; exit 1 }
$ec2 = $p2.ExitCode
Get-Content "_b_out2.txt" -ErrorAction SilentlyContinue
if ($null -ne $ec2 -and $ec2 -ne 0) { Get-Content "_b_err2.txt" -ErrorAction SilentlyContinue | Select-Object -Last 40; exit 1 }
Write-Host "reflect_test compile OK"

Write-Host "=== link reflect_test ==="
$ErrorActionPreference = "Continue"
& clang -o reflect_test.exe reflect_test.ll output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1
$ErrorActionPreference = "Stop"
if ($LASTEXITCODE -ne 0) { Write-Host "link FAILED"; exit 1 }
Write-Host "linked"

Write-Host "=== run reflect_test ==="
$p3 = Start-Process -FilePath ".\reflect_test.exe" -NoNewWindow -PassThru -RedirectStandardOutput "_b_run.txt" -RedirectStandardError "_b_runerr.txt"
if (-not $p3.WaitForExit(15000)) { $p3.Kill(); Write-Host "RUN TIMEOUT"; exit 1 }
Get-Content "_b_run.txt" -ErrorAction SilentlyContinue
Get-Content "_b_runerr.txt" -ErrorAction SilentlyContinue
if ($null -ne $p3.ExitCode -and $p3.ExitCode -ne 0) { Write-Host "FAIL exit $($p3.ExitCode)"; exit 1 }
Write-Host "=== ALL PASSED ==="
