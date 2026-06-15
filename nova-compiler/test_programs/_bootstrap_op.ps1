$ErrorActionPreference = "Continue"
$env:NOVA_NO_CACHE = "1"
$src = "$PSScriptRoot\nova_compiler.nova"
$rtSrc = "$PSScriptRoot\output\nova_runtime.c"
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$linkFlags = "-lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w"

function Invoke-Timed($FilePath, $Arguments, $TimeoutMs = 450000) {
    $p = Start-Process -FilePath $FilePath -ArgumentList $Arguments -NoNewWindow -PassThru -RedirectStandardError "$PSScriptRoot\_bs_err.txt" -RedirectStandardOutput "$PSScriptRoot\_bs_out.txt"
    if (-not $p.WaitForExit($TimeoutMs)) {
        $p.Kill()
        Write-Host "TIMEOUT after ${TimeoutMs}ms"
        return $false
    }
    $exitCode = $p.ExitCode
    if ($exitCode -ne 0) {
        Write-Host "FAILED exit=$exitCode"
        Get-Content "$PSScriptRoot\_bs_err.txt" | Select-Object -First 10
        Get-Content "$PSScriptRoot\_bs_out.txt" | Select-Object -First 10
        return $false
    }
    return $true
}

# gen3 -> gen4
Write-Host "=== gen3 -> gen4 ($($sw.ElapsedMilliseconds)ms) ==="
$ok = Invoke-Timed ".\gen3_test.exe" "$src"
if (-not $ok) { Write-Host "gen3->gen4 FAILED"; exit 1 }
Get-Content "$PSScriptRoot\_bs_out.txt" | Select-Object -First 2
# gen3 outputs .ll to CWD
if (-not (Test-Path "$PSScriptRoot\nova_compiler.ll")) {
    Write-Host "ERROR: nova_compiler.ll not found"; exit 1
}
& clang "$PSScriptRoot\nova_compiler.ll" "$rtSrc" -o "$PSScriptRoot\gen4_test.exe" -O2 $linkFlags.Split(" ") 2>"$PSScriptRoot\_bs_link_err.txt"
if ($LASTEXITCODE -ne 0) {
    Write-Host "gen4 link FAILED"
    Get-Content "$PSScriptRoot\_bs_link_err.txt" | Select-Object -First 10
    exit 1
}
Write-Host "gen4 built ($($sw.ElapsedMilliseconds)ms)"

# gen4 -> gen5
Write-Host "=== gen4 -> gen5 ($($sw.ElapsedMilliseconds)ms) ==="
$ok = Invoke-Timed ".\gen4_test.exe" "$src"
if (-not $ok) { Write-Host "gen4->gen5 FAILED"; exit 1 }
Get-Content "$PSScriptRoot\_bs_out.txt" | Select-Object -First 2
Copy-Item "$PSScriptRoot\nova_compiler.ll" "$PSScriptRoot\gen5.ll" -Force
& clang "$PSScriptRoot\gen5.ll" "$rtSrc" -o "$PSScriptRoot\gen5.exe" -O2 $linkFlags.Split(" ") 2>"$PSScriptRoot\_bs_link_err.txt"
if ($LASTEXITCODE -ne 0) {
    Write-Host "gen5 link FAILED"
    Get-Content "$PSScriptRoot\_bs_link_err.txt" | Select-Object -First 10
    exit 1
}
Write-Host "gen5 built ($($sw.ElapsedMilliseconds)ms)"

# gen5 -> gen6
Write-Host "=== gen5 -> gen6 ($($sw.ElapsedMilliseconds)ms) ==="
$ok = Invoke-Timed ".\gen5.exe" "$src"
if (-not $ok) { Write-Host "gen5->gen6 FAILED"; exit 1 }
Get-Content "$PSScriptRoot\_bs_out.txt" | Select-Object -First 2
Copy-Item "$PSScriptRoot\nova_compiler.ll" "$PSScriptRoot\gen6.ll" -Force
Write-Host "gen6 built ($($sw.ElapsedMilliseconds)ms)"

# Verify gen5 == gen6 (byte-identical)
$hash5 = (Get-FileHash "$PSScriptRoot\gen5.ll" -Algorithm SHA256).Hash
$hash6 = (Get-FileHash "$PSScriptRoot\gen6.ll" -Algorithm SHA256).Hash
if ($hash5 -eq $hash6) {
    Write-Host "BOOTSTRAP CONVERGED: gen5==gen6 SHA256=$hash5"
    # Install gen4
    Copy-Item "$PSScriptRoot\gen4_test.exe" "$PSScriptRoot\gen4.exe" -Force
    Write-Host "gen4.exe installed"
} else {
    Write-Host "DIVERGED: gen5=$hash5 gen6=$hash6"
    exit 1
}
Write-Host "Total time: $($sw.ElapsedMilliseconds)ms"
