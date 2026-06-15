$ErrorActionPreference = "Continue"
$env:NOVA_NO_CACHE = "1"
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$dir = $PSScriptRoot
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")

function Run-Stage($exe, $label) {
    Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
    Write-Host "=== $label ($($sw.ElapsedMilliseconds)ms) ==="
    $p = Start-Process -FilePath $exe -ArgumentList "nova_compiler.nova" `
        -NoNewWindow -PassThru -WorkingDirectory $dir `
        -RedirectStandardError "$dir\_bs3_err.txt" -RedirectStandardOutput "$dir\_bs3_out.txt"
    $finished = $p.WaitForExit(450000)
    if (-not $finished) {
        $p.Kill(); Write-Host "TIMEOUT"; return $false
    }
    $content = Get-Content "$dir\_bs3_out.txt" -Raw
    if ($content -match "Compiled") { Write-Host $content.Trim() }
    if (-not (Test-Path "$dir\nova_compiler.ll")) {
        Write-Host "ERROR: nova_compiler.ll not generated"
        Get-Content "$dir\_bs3_err.txt" | Select-Object -First 5
        return $false
    }
    return $true
}

# gen3 -> gen4
$ok = Run-Stage "$dir\gen3_test.exe" "gen3 -> gen4"
if (-not $ok) { Write-Host "gen3->gen4 FAILED"; exit 1 }
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_test.exe" -O2 @linkFlags 2>"$dir\_bs3_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen4 link FAILED"; Get-Content "$dir\_bs3_lerr.txt" | Select-Object -First 10; exit 1 }
Write-Host "gen4 built ($($sw.ElapsedMilliseconds)ms)"

# gen4 -> gen5
$ok = Run-Stage "$dir\gen4_test.exe" "gen4 -> gen5"
if (-not $ok) { Write-Host "gen4->gen5 FAILED"; exit 1 }
Copy-Item "$dir\nova_compiler.ll" "$dir\gen5.ll" -Force
& clang "$dir\gen5.ll" $rtSrc -o "$dir\gen5.exe" -O2 @linkFlags 2>"$dir\_bs3_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen5 link FAILED"; Get-Content "$dir\_bs3_lerr.txt" | Select-Object -First 10; exit 1 }
Write-Host "gen5 built ($($sw.ElapsedMilliseconds)ms)"

# gen5 -> gen6
$ok = Run-Stage "$dir\gen5.exe" "gen5 -> gen6"
if (-not $ok) { Write-Host "gen5->gen6 FAILED"; exit 1 }
Copy-Item "$dir\nova_compiler.ll" "$dir\gen6.ll" -Force
Write-Host "gen6 built ($($sw.ElapsedMilliseconds)ms)"

# Verify convergence
$hash5 = (Get-FileHash "$dir\gen5.ll" -Algorithm SHA256).Hash
$hash6 = (Get-FileHash "$dir\gen6.ll" -Algorithm SHA256).Hash
if ($hash5 -eq $hash6) {
    Write-Host "BOOTSTRAP CONVERGED: gen5==gen6 SHA256=$hash5"
    Copy-Item "$dir\gen4_test.exe" "$dir\gen4.exe" -Force
    Write-Host "gen4.exe installed"
} else {
    Write-Host "DIVERGED: gen5=$hash5 gen6=$hash6"
    exit 1
}
Write-Host "Total time: $($sw.ElapsedMilliseconds)ms"
