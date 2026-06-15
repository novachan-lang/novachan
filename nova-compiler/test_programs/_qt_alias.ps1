$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Remove-Item "$dir\_alias_test.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_alias_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_al_err.txt" -RedirectStandardOutput "$dir\_al_out.txt"
$ok = $p.WaitForExit(60000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
if (Test-Path "$dir\_al_out.txt") { $o = Get-Content "$dir\_al_out.txt" -Raw; if ($o) { Write-Host $o } }
if (-not (Test-Path "$dir\_alias_test.ll")) { Write-Host "COMPILE FAILED"; exit 1 }
Write-Host "Compile OK, linking..."
& clang "$dir\_alias_test.ll" $rtSrc -o "$dir\_alias_test.exe" -O2 @linkFlags 2>"$dir\_al_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_al_lerr.txt"; exit 1 }
$r = Start-Process -FilePath "$dir\_alias_test.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_al_rerr.txt" -RedirectStandardOutput "$dir\_al_rout.txt"
$rok = $r.WaitForExit(15000)
if (-not $rok) { $r.Kill(); Write-Host "TIMEOUT-RUN"; exit 1 }
Write-Host "OUTPUT:"
if (Test-Path "$dir\_al_rout.txt") { Get-Content "$dir\_al_rout.txt" }
Write-Host "STDERR:"
if (Test-Path "$dir\_al_rerr.txt") { Get-Content "$dir\_al_rerr.txt" }
