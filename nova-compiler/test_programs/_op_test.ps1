$env:NOVA_NO_CACHE = "1"
$sw = [System.Diagnostics.Stopwatch]::StartNew()

# Compile
$p = Start-Process -FilePath ".\gen4.exe" -ArgumentList "_op_overload_probe.nova" -NoNewWindow -PassThru -RedirectStandardError "_op_err.txt" -RedirectStandardOutput "_op_out.txt"
if (-not $p.WaitForExit(30000)) { $p.Kill(); Write-Host "COMPILE TIMEOUT"; exit 1 }
Write-Host "compile exit=$($p.ExitCode) time=$($sw.ElapsedMilliseconds)ms"
if ($p.ExitCode -ne 0) {
    if (Test-Path "_op_err.txt") { Get-Content "_op_err.txt" | Select-Object -First 30 }
    if (Test-Path "_op_out.txt") { Get-Content "_op_out.txt" | Select-Object -First 10 }
    exit 1
}

# Link
$rtSrc = "$PSScriptRoot\output\nova_runtime.c"
$llFile = "_op_overload_probe.ll"
if (-not (Test-Path $llFile)) {
    Write-Host "ERROR: $llFile not found"
    exit 1
}
$clang = Start-Process -FilePath "clang" -ArgumentList "$llFile `"$rtSrc`" -o _op_overload_probe.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -NoNewWindow -PassThru -RedirectStandardError "_op_link_err.txt"
if (-not $clang.WaitForExit(60000)) { $clang.Kill(); Write-Host "LINK TIMEOUT"; exit 1 }
Write-Host "link exit=$($clang.ExitCode) time=$($sw.ElapsedMilliseconds)ms"
if ($clang.ExitCode -ne 0) {
    if (Test-Path "_op_link_err.txt") { Get-Content "_op_link_err.txt" | Select-Object -First 20 }
    exit 1
}

# Run
$run = Start-Process -FilePath ".\_op_overload_probe.exe" -NoNewWindow -PassThru -RedirectStandardError "_op_runerr.txt" -RedirectStandardOutput "_op_runout.txt"
if (-not $run.WaitForExit(10000)) { $run.Kill(); Write-Host "RUN TIMEOUT"; exit 1 }
Write-Host "run exit=$($run.ExitCode) time=$($sw.ElapsedMilliseconds)ms"
if (Test-Path "_op_runout.txt") { Get-Content "_op_runout.txt" }
if (Test-Path "_op_runerr.txt") { Get-Content "_op_runerr.txt" | Select-Object -First 10 }
