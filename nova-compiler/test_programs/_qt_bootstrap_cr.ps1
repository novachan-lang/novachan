$ErrorActionPreference = "Continue"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"
$sw = [System.Diagnostics.Stopwatch]::StartNew()

function Invoke-Timed($exe, $args2, $wd, $timeout, $label) {
    $p = Start-Process -FilePath $exe -ArgumentList $args2 -NoNewWindow -PassThru -WorkingDirectory $wd `
        -RedirectStandardError "$dir\_bs_err.txt" -RedirectStandardOutput "$dir\_bs_out.txt"
    $ok = $p.WaitForExit($timeout)
    if (-not $ok) {
        $p.Kill()
        Write-Host "TIMEOUT ($label) after ${timeout}ms"
        if (Test-Path "$dir\_bs_err.txt") { Get-Content "$dir\_bs_err.txt" -ErrorAction SilentlyContinue }
        exit 1
    }
    return $p
}

Write-Host "=== gen3 -> gen4 ($($sw.ElapsedMilliseconds)ms) ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
Invoke-Timed "$dir\gen3_test.exe" "nova_compiler.nova" $dir 450000 "gen3->gen4"
if (-not (Test-Path "$dir\nova_compiler.ll")) {
    Write-Host "gen3 COMPILE FAILED"
    if (Test-Path "$dir\_bs_out.txt") { Get-Content "$dir\_bs_out.txt" }
    exit 1
}
Write-Host "Compiled (IR): nova_compiler.nova -> nova_compiler.ll"
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4.exe" -O2 @linkFlags 2>"$dir\_bs_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen4 LINK FAILED"; Get-Content "$dir\_bs_lerr.txt"; exit 1 }
Write-Host "gen4 built ($($sw.ElapsedMilliseconds)ms)"

Write-Host "=== gen4 -> gen5 ($($sw.ElapsedMilliseconds)ms) ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
Invoke-Timed "$dir\gen4.exe" "nova_compiler.nova" $dir 450000 "gen4->gen5"
if (-not (Test-Path "$dir\nova_compiler.ll")) {
    Write-Host "gen4 COMPILE FAILED"
    if (Test-Path "$dir\_bs_out.txt") { Get-Content "$dir\_bs_out.txt" }
    exit 1
}
Write-Host "Compiled (IR): nova_compiler.nova -> nova_compiler.ll"
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen5.exe" -O2 @linkFlags 2>"$dir\_bs_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen5 LINK FAILED"; exit 1 }
Write-Host "gen5 built ($($sw.ElapsedMilliseconds)ms)"

Write-Host "=== gen5 -> gen6 ($($sw.ElapsedMilliseconds)ms) ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
Invoke-Timed "$dir\gen5.exe" "nova_compiler.nova" $dir 450000 "gen5->gen6"
if (-not (Test-Path "$dir\nova_compiler.ll")) {
    Write-Host "gen5 COMPILE FAILED"
    if (Test-Path "$dir\_bs_out.txt") { Get-Content "$dir\_bs_out.txt" }
    exit 1
}
Write-Host "Compiled (IR): nova_compiler.nova -> nova_compiler.ll"
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen6.exe" -O2 @linkFlags 2>"$dir\_bs_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen6 LINK FAILED"; exit 1 }
Write-Host "gen6 built ($($sw.ElapsedMilliseconds)ms)"

$h5 = (Get-FileHash "$dir\gen5.exe" -Algorithm SHA256).Hash
$h6 = (Get-FileHash "$dir\gen6.exe" -Algorithm SHA256).Hash
if ($h5 -eq $h6) {
    Write-Host "BOOTSTRAP CONVERGED: gen5==gen6 SHA256=$h5"
    Copy-Item "$dir\gen4.exe" "$dir\gen4_test.exe" -Force
    Write-Host "gen4.exe installed"
} else {
    Write-Host "BOOTSTRAP DIVERGED: gen5=$h5 gen6=$h6"
    exit 1
}
Write-Host "Total time: $($sw.ElapsedMilliseconds)ms"
