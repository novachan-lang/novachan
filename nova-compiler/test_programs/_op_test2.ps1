$env:NOVA_NO_CACHE = "1"

# Compile
& .\gen4.exe _op_overload_probe.nova 2>"_op_err.txt" 1>"_op_out.txt"
Get-Content "_op_out.txt"
if (-not (Test-Path "_op_overload_probe.ll")) {
    Write-Host "COMPILE FAILED - no .ll"
    Get-Content "_op_err.txt" | Select-Object -First 20
    exit 1
}
Write-Host "Compile OK"

# Link
$rtSrc = "$PSScriptRoot\output\nova_runtime.c"
& clang "_op_overload_probe.ll" "$rtSrc" -o "_op_overload_probe.exe" -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>"_op_link_err.txt"
if (-not (Test-Path "_op_overload_probe.exe") -or $LASTEXITCODE -ne 0) {
    Write-Host "LINK FAILED"
    Get-Content "_op_link_err.txt" | Select-Object -First 20
    exit 1
}
Write-Host "Link OK"

# Run
& .\_op_overload_probe.exe 2>"_op_runerr.txt"
Write-Host "Run exit=$LASTEXITCODE"
if (Test-Path "_op_runerr.txt") {
    $errContent = Get-Content "_op_runerr.txt"
    if ($errContent) { $errContent | Select-Object -First 10 }
}
