$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"
$sw = [System.Diagnostics.Stopwatch]::StartNew()

function Build-Stage($inExe, $outExe, $label) {
    Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
    $p = Start-Process -FilePath $inExe -ArgumentList "nova_compiler.nova" `
        -NoNewWindow -PassThru -WorkingDirectory $dir `
        -RedirectStandardError "$dir\_bs_err.txt" -RedirectStandardOutput "$dir\_bs_out.txt"
    $ok = $p.WaitForExit(450000)
    if (-not $ok) { $p.Kill(); Write-Host "$label TIMEOUT"; exit 1 }
    if (-not (Test-Path "$dir\nova_compiler.ll")) {
        Write-Host "$label COMPILE FAILED"
        if (Test-Path "$dir\_bs_out.txt") { Get-Content "$dir\_bs_out.txt" }
        exit 1
    }
    Copy-Item "$dir\nova_compiler.ll" "$dir\${label}.ll" -Force
    & clang "$dir\nova_compiler.ll" $rtSrc -o $outExe -O2 @linkFlags 2>"$dir\_bs_lerr.txt"
    if ($LASTEXITCODE -ne 0) { Write-Host "$label LINK FAILED"; exit 1 }
    Write-Host "$label done ($($sw.ElapsedMilliseconds)ms)"
}

Write-Host "=== gen3 -> gen4 ==="
Build-Stage "$dir\gen3_test.exe" "$dir\gen4.exe" "gen4"

Write-Host "=== gen4 -> gen5 ==="
Build-Stage "$dir\gen4.exe" "$dir\gen5.exe" "gen5"

Write-Host "=== gen5 -> gen6 ==="
Build-Stage "$dir\gen5.exe" "$dir\gen6.exe" "gen6"

Write-Host "`n=== LL convergence check ==="
$h5 = (Get-FileHash "$dir\gen5.ll" -Algorithm SHA256).Hash
$h6 = (Get-FileHash "$dir\gen6.ll" -Algorithm SHA256).Hash
Write-Host "gen5.ll: $h5"
Write-Host "gen6.ll: $h6"
if ($h5 -eq $h6) {
    Write-Host "CONVERGED"
    Copy-Item "$dir\gen6.exe" "$dir\gen4_test.exe" -Force
    Write-Host "Installed gen6 as gen4_test.exe"
} else {
    Write-Host "DIVERGED"
    $d = & fc.exe "$dir\gen5.ll" "$dir\gen6.ll" 2>&1
    $lines = ($d | Measure-Object -Line).Lines
    Write-Host "Diff lines: $lines"
}

Write-Host "`n=== Verify tests with new gen4_test ==="
Remove-Item "$dir\_alias_test.ll","$dir\_ergonomics_probe.ll","$dir\_pipe_test.ll" -Force -ErrorAction SilentlyContinue
foreach ($f in @("_alias_test","_ergonomics_probe","_pipe_test")) {
    $t = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "${f}.nova" `
        -NoNewWindow -PassThru -WorkingDirectory $dir `
        -RedirectStandardError "$dir\_vt_err.txt" -RedirectStandardOutput "$dir\_vt_out.txt"
    $t.WaitForExit(60000) | Out-Null
    if (-not (Test-Path "$dir\${f}.ll")) { Write-Host "$f COMPILE FAILED"; continue }
    & clang "$dir\${f}.ll" $rtSrc -o "$dir\${f}.exe" -O2 @linkFlags 2>$null
    $r = Start-Process -FilePath "$dir\${f}.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
        -RedirectStandardOutput "$dir\_vt_rout.txt" -RedirectStandardError "$dir\_vt_rerr.txt"
    $r.WaitForExit(15000) | Out-Null
    $out = if (Test-Path "$dir\_vt_rout.txt") { Get-Content "$dir\_vt_rout.txt" -Raw } else { "" }
    if ($out -match "PASSED") { Write-Host "$f : PASS" } else { Write-Host "$f : FAIL"; Write-Host $out }
}

Write-Host "`nTotal: $($sw.ElapsedMilliseconds)ms"
