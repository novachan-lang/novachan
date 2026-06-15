param([string]$TestFile)
$ErrorActionPreference = "Stop"

# Step 1: Compile test with gen4
$p1 = Start-Process -FilePath "./gen4_test.exe" -ArgumentList $TestFile -NoNewWindow -PassThru -RedirectStandardOutput "output/test_stdout.txt" -RedirectStandardError "output/test_stderr.txt"
$done1 = $p1.WaitForExit(30000)
if (-not $done1) { $p1.Kill(); Write-Host "COMPILE TIMEOUT"; exit 1 }
$base = [System.IO.Path]::GetFileNameWithoutExtension($TestFile)
$llFile = "$base.ll"
if (-not (Test-Path $llFile)) {
    Write-Host "COMPILE FAILED - no $llFile"
    Get-Content "output/test_stderr.txt" -ErrorAction SilentlyContinue
    exit 1
}
Write-Host "Compiled $TestFile -> $llFile"

# Step 2: Build exe
$exeName = "${base}_run.exe"
$p2 = Start-Process -FilePath "clang" -ArgumentList "-O2","-o",$exeName,$llFile,"output/nova_runtime.c","-lws2_32","-ladvapi32" -NoNewWindow -PassThru -RedirectStandardError "output/clang_test_err.txt"
$done2 = $p2.WaitForExit(60000)
if (-not $done2) { $p2.Kill(); Write-Host "CLANG TIMEOUT"; exit 1 }
if ($p2.ExitCode -ne 0) {
    Write-Host "CLANG FAILED"
    Get-Content "output/clang_test_err.txt" -Tail 20
    exit 1
}
Write-Host "Built $exeName"

# Step 3: Run with timeout
$p3 = Start-Process -FilePath "./$exeName" -NoNewWindow -PassThru -RedirectStandardOutput "output/run_stdout.txt" -RedirectStandardError "output/run_stderr.txt"
$done3 = $p3.WaitForExit(10000)
if (-not $done3) { $p3.Kill(); Write-Host "RUN TIMEOUT - possible infinite loop"; exit 1 }
$out = Get-Content "output/run_stdout.txt" -Raw
$err = Get-Content "output/run_stderr.txt" -Raw -ErrorAction SilentlyContinue
Write-Host $out
if ($err) { Write-Host "STDERR: $err" }
if ($p3.ExitCode -ne 0) { Write-Host "EXIT CODE: $($p3.ExitCode)"; exit 1 }
Write-Host "PASS: $TestFile"
