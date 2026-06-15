$ErrorActionPreference = "Continue"
$env:NOVA_NO_CACHE = "1"
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$dir = $PSScriptRoot
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")

function Invoke-Timed($exe, $argStr, $timeout=450000) {
    $p = Start-Process -FilePath $exe -ArgumentList $argStr -NoNewWindow -PassThru `
        -RedirectStandardError "$dir\_bs2_err.txt" -RedirectStandardOutput "$dir\_bs2_out.txt" `
        -WorkingDirectory $dir
    if (-not $p.WaitForExit($timeout)) {
        $p.Kill(); Write-Host "TIMEOUT after ${timeout}ms"; return $false
    }
    if ($p.ExitCode -ne 0) {
        Write-Host "FAILED exit=$($p.ExitCode)"
        Get-Content "$dir\_bs2_err.txt" | Select-Object -First 10
        Get-Content "$dir\_bs2_out.txt" | Select-Object -First 10
        return $false
    }
    return $true
}

# Delete old .ll so we know if gen3 actually produced new output
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue

# gen3 -> gen4
Write-Host "=== gen3 -> gen4 ($($sw.ElapsedMilliseconds)ms) ==="
$ok = Invoke-Timed "$dir\gen3_test.exe" "nova_compiler.nova"
if (-not $ok) { Write-Host "gen3->gen4 FAILED"; exit 1 }
Get-Content "$dir\_bs2_out.txt" | Select-Object -First 3
if (-not (Test-Path "$dir\nova_compiler.ll")) {
    Write-Host "ERROR: nova_compiler.ll not generated"; exit 1
}
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_test.exe" -O2 @linkFlags 2>"$dir\_bs2_lerr.txt"
if ($LASTEXITCODE -ne 0) {
    Write-Host "gen4 link FAILED"; Get-Content "$dir\_bs2_lerr.txt" | Select-Object -First 10; exit 1
}
Write-Host "gen4 built ($($sw.ElapsedMilliseconds)ms)"

# gen4 -> gen5
Write-Host "=== gen4 -> gen5 ($($sw.ElapsedMilliseconds)ms) ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$ok = Invoke-Timed "$dir\gen4_test.exe" "nova_compiler.nova"
if (-not $ok) { Write-Host "gen4->gen5 FAILED"; exit 1 }
Get-Content "$dir\_bs2_out.txt" | Select-Object -First 3
Copy-Item "$dir\nova_compiler.ll" "$dir\gen5.ll" -Force
& clang "$dir\gen5.ll" $rtSrc -o "$dir\gen5.exe" -O2 @linkFlags 2>"$dir\_bs2_lerr.txt"
if ($LASTEXITCODE -ne 0) {
    Write-Host "gen5 link FAILED"; Get-Content "$dir\_bs2_lerr.txt" | Select-Object -First 10; exit 1
}
Write-Host "gen5 built ($($sw.ElapsedMilliseconds)ms)"

# gen5 -> gen6
Write-Host "=== gen5 -> gen6 ($($sw.ElapsedMilliseconds)ms) ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$ok = Invoke-Timed "$dir\gen5.exe" "nova_compiler.nova"
if (-not $ok) { Write-Host "gen5->gen6 FAILED"; exit 1 }
Get-Content "$dir\_bs2_out.txt" | Select-Object -First 3
Copy-Item "$dir\nova_compiler.ll" "$dir\gen6.ll" -Force
Write-Host "gen6 built ($($sw.ElapsedMilliseconds)ms)"

# Verify gen5 == gen6
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
