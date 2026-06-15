$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"
$results = @()

function Test-Nova($name, $file) {
    Remove-Item "$dir\$file.ll" -Force -ErrorAction SilentlyContinue
    Remove-Item "$dir\$file.exe" -Force -ErrorAction SilentlyContinue
    $p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "$file.nova" `
        -NoNewWindow -PassThru -WorkingDirectory $dir `
        -RedirectStandardError "$dir\_vfy_err.txt" -RedirectStandardOutput "$dir\_vfy_out.txt"
    $ok = $p.WaitForExit(60000)
    if (-not $ok) { $p.Kill(); return "TIMEOUT" }
    if (-not (Test-Path "$dir\$file.ll")) { return "COMPILE FAILED" }
    & clang "$dir\$file.ll" $rtSrc -o "$dir\$file.exe" -O2 @linkFlags 2>"$dir\_vfy_lerr.txt"
    if ($LASTEXITCODE -ne 0) { return "LINK FAILED" }
    $r = Start-Process -FilePath "$dir\$file.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
        -RedirectStandardOutput "$dir\_vfy_rout.txt" -RedirectStandardError "$dir\_vfy_rerr.txt"
    $rok = $r.WaitForExit(15000)
    if (-not $rok) { $r.Kill(); return "RUN TIMEOUT" }
    $out = ""
    if (Test-Path "$dir\_vfy_rout.txt") { $out = (Get-Content "$dir\_vfy_rout.txt" -Raw).Trim() }
    return $out
}

Write-Host "=== Testing round() fix ==="
$out = Test-Nova "round" "_round_probe"
Write-Host $out

Write-Host ""
Write-Host "=== Testing string multiplication ==="
$out = Test-Nova "strmul" "_strmul_probe"
Write-Host $out

Write-Host ""
Write-Host "=== Testing list multiplication ==="
$out = Test-Nova "listmul" "_listmul_probe"
Write-Host $out

Write-Host ""
Write-Host "=== Testing aliases (reversed/sorted/strip/min/max) ==="
$out = Test-Nova "alias" "_alias_test"
Write-Host $out

Write-Host ""
Write-Host "=== Testing ergonomics (pipe/enumerate/zip/reduce/filter) ==="
$out = Test-Nova "ergo" "_ergonomics_probe"
Write-Host $out

Write-Host ""
Write-Host "DONE"
