param([string]$TestFile)
$env:NOVA_NO_CACHE = "1"
$dir = $PSScriptRoot
$rtSrc = "$dir\output\nova_runtime.c"
$base = [System.IO.Path]::GetFileNameWithoutExtension($TestFile)
Remove-Item "$dir\$base.ll","$dir\$base.exe" -Force -ErrorAction SilentlyContinue

$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList $TestFile `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qt3_err.txt" -RedirectStandardOutput "$dir\_qt3_out.txt"
if (-not $p.WaitForExit(30000)) { $p.Kill(); Write-Host "COMPILE TIMEOUT"; exit 1 }
Get-Content "$dir\_qt3_out.txt"
if (-not (Test-Path "$dir\$base.ll")) {
    Write-Host "COMPILE FAILED"
    Get-Content "$dir\_qt3_err.txt" | Select-Object -First 20
    exit 1
}
& clang "$dir\$base.ll" $rtSrc -o "$dir\$base.exe" -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>"$dir\_qt3_lerr.txt"
if ($LASTEXITCODE -ne 0) {
    Write-Host "LINK FAILED"
    Get-Content "$dir\_qt3_lerr.txt" | Select-Object -First 20
    exit 1
}
$r = Start-Process -FilePath "$dir\$base.exe" -NoNewWindow -PassThru `
    -RedirectStandardError "$dir\_qt3_rerr.txt" -RedirectStandardOutput "$dir\_qt3_rout.txt" `
    -WorkingDirectory $dir
if (-not $r.WaitForExit(10000)) { $r.Kill(); Write-Host "RUN TIMEOUT"; exit 1 }
Get-Content "$dir\_qt3_rout.txt"
$e = Get-Content "$dir\_qt3_rerr.txt" -ErrorAction SilentlyContinue
if ($e) { $e | Select-Object -First 5 }
Write-Host "exit=$($r.ExitCode)"
