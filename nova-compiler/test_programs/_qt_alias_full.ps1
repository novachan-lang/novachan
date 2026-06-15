$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"
$sw = [System.Diagnostics.Stopwatch]::StartNew()

Write-Host "=== gen3 -> gen4_new ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen3_test.exe" -ArgumentList "nova_compiler.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_af_err.txt" -RedirectStandardOutput "$dir\_af_out.txt"
$ok = $p.WaitForExit(450000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT gen3"; exit 1 }
if (-not (Test-Path "$dir\nova_compiler.ll")) {
    Write-Host "gen3 FAILED"
    if (Test-Path "$dir\_af_out.txt") { Get-Content "$dir\_af_out.txt" }
    if (Test-Path "$dir\_af_err.txt") { Get-Content "$dir\_af_err.txt" }
    exit 1
}
Write-Host "gen3 compiled ($($sw.ElapsedMilliseconds)ms)"
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_new.exe" -O2 @linkFlags 2>"$dir\_af_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_af_lerr.txt"; exit 1 }
Write-Host "gen4_new built ($($sw.ElapsedMilliseconds)ms)"

Write-Host "=== Testing _alias_test.nova with gen4_new ==="
Remove-Item "$dir\_alias_test.ll" -Force -ErrorAction SilentlyContinue
$t = Start-Process -FilePath "$dir\gen4_new.exe" -ArgumentList "_alias_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_al_err.txt" -RedirectStandardOutput "$dir\_al_out.txt"
$tok = $t.WaitForExit(60000)
if (-not $tok) { $t.Kill(); Write-Host "TIMEOUT test"; exit 1 }
if (Test-Path "$dir\_al_out.txt") { $out = Get-Content "$dir\_al_out.txt" -Raw; if ($out) { Write-Host $out } }
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
Write-Host "`nTotal: $($sw.ElapsedMilliseconds)ms"
