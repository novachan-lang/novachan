Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"
$runtimeObj = "$PSScriptRoot\output\nova_runtime.o"

# Pre-compile runtime if needed
if (!(Test-Path $runtimeObj) -or (Get-Item $runtimeSrc).LastWriteTimeUtc -gt (Get-Item $runtimeObj).LastWriteTimeUtc) {
    Write-Host "Compiling runtime .o..."
    $cr = Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 -o `"$runtimeObj`" `"$runtimeSrc`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
    if (!(Test-Path $runtimeObj)) { Write-Host "FATAL: runtime compile failed"; exit 1 }
}

# Step 1: gen3 compiles nova_compiler.nova -> nova_compiler.ll
Write-Host "gen3 -> gen4..."
$cr = Invoke-Timed -FilePath $compiler -Arguments "nova_compiler.nova" -TimeoutMs 600000
Write-Host "  compile exit=$($cr.ExitCode)"
if ($cr.ExitCode -ne 0) {
    Write-Host "FATAL: gen3 compilation failed"
    if ($cr.StdErr) { Write-Host $cr.StdErr.Substring(0, [Math]::Min(1000, $cr.StdErr.Length)) }
    exit 1
}

# Link gen4
$gen4 = "$PSScriptRoot\gen4_bootstrap.exe"
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$gen4`" nova_compiler.ll `"$runtimeObj`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
if (!(Test-Path $gen4)) { Write-Host "FATAL: gen4 link failed"; exit 1 }
Write-Host "  gen4 ready: $((Get-Item $gen4).Length) bytes"

# Step 2: gen4 compiles nova_compiler.nova -> gen5
Write-Host "gen4 -> gen5..."
$cr2 = Invoke-Timed -FilePath $gen4 -Arguments "nova_compiler.nova" -TimeoutMs 600000
Write-Host "  compile exit=$($cr2.ExitCode)"
if ($cr2.ExitCode -ne 0) { Write-Host "FATAL: gen4 compilation failed"; exit 1 }

$gen5 = "$PSScriptRoot\gen5_bootstrap.exe"
$lr2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$gen5`" nova_compiler.ll `"$runtimeObj`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
if (!(Test-Path $gen5)) { Write-Host "FATAL: gen5 link failed"; exit 1 }
Write-Host "  gen5 ready: $((Get-Item $gen5).Length) bytes"

# Step 3: gen5 compiles nova_compiler.nova -> gen6
Write-Host "gen5 -> gen6..."
$cr3 = Invoke-Timed -FilePath $gen5 -Arguments "nova_compiler.nova" -TimeoutMs 600000
Write-Host "  compile exit=$($cr3.ExitCode)"
if ($cr3.ExitCode -ne 0) { Write-Host "FATAL: gen5 compilation failed"; exit 1 }

$gen6 = "$PSScriptRoot\gen6_bootstrap.exe"
$lr3 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$gen6`" nova_compiler.ll `"$runtimeObj`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
if (!(Test-Path $gen6)) { Write-Host "FATAL: gen6 link failed"; exit 1 }
Write-Host "  gen6 ready: $((Get-Item $gen6).Length) bytes"

# Check convergence: gen5 == gen6
$hash5 = (Get-FileHash $gen5 -Algorithm SHA256).Hash
$hash6 = (Get-FileHash $gen6 -Algorithm SHA256).Hash
Write-Host ""
Write-Host "gen5 hash: $hash5"
Write-Host "gen6 hash: $hash6"
if ($hash5 -eq $hash6) {
    Write-Host "CONVERGED! Installing as gen3_test.exe + gen4_test.exe"
    Copy-Item $gen5 "$PSScriptRoot\gen3_test.exe" -Force
    Copy-Item $gen5 "$PSScriptRoot\gen4_test.exe" -Force
} else {
    Write-Host "NOT CONVERGED - gen5 != gen6"
    exit 1
}

# Cleanup
Remove-Item $gen4, $gen5, $gen6 -Force -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
Write-Host "Bootstrap complete."
