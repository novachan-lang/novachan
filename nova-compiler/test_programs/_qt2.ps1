param([string]$TestFile)
$env:NOVA_NO_CACHE = "1"
$rtSrc = "$PSScriptRoot\output\nova_runtime.c"
$base = [System.IO.Path]::GetFileNameWithoutExtension($TestFile)
Remove-Item "$base.ll","$base.exe" -Force -ErrorAction SilentlyContinue

& .\gen4.exe $TestFile 2>"_qt_err.txt" 1>"_qt_out.txt"
Get-Content "_qt_out.txt"
if (-not (Test-Path "$base.ll")) {
    Write-Host "COMPILE FAILED"
    Get-Content "_qt_err.txt" | Select-Object -First 20
    exit 1
}
& clang "$base.ll" "$rtSrc" -o "$base.exe" -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>"_qt_lerr.txt"
if ($LASTEXITCODE -ne 0) {
    Write-Host "LINK FAILED"
    Get-Content "_qt_lerr.txt" | Select-Object -First 20
    exit 1
}
$p = Start-Process -FilePath ".\$base.exe" -NoNewWindow -PassThru -RedirectStandardError "_qt_rerr.txt" -RedirectStandardOutput "_qt_rout.txt"
if (-not $p.WaitForExit(10000)) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
Get-Content "_qt_rout.txt"
if (Test-Path "_qt_rerr.txt") {
    $e = Get-Content "_qt_rerr.txt"
    if ($e) { $e | Select-Object -First 5 }
}
Write-Host "exit=$($p.ExitCode)"
