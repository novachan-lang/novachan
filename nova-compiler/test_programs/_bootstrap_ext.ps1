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

function Compile-Gen($inputExe, $outputExe, $label) {
    Write-Host "$label..."
    $cr = Invoke-Timed -FilePath $inputExe -Arguments "nova_compiler.nova" -TimeoutMs 600000
    Write-Host "  compile exit=$($cr.ExitCode)"
    if ($cr.ExitCode -ne 0) {
        Write-Host "FATAL: $label compilation failed"
        if ($cr.StdErr) { Write-Host $cr.StdErr.Substring(0, [Math]::Min(2000, $cr.StdErr.Length)) }
        exit 1
    }
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$outputExe`" nova_compiler.ll `"$runtimeObj`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
    if (!(Test-Path $outputExe)) { Write-Host "FATAL: $label link failed"; exit 1 }
    Write-Host "  $outputExe ready: $((Get-Item $outputExe).Length) bytes"
}

$gen4 = "$PSScriptRoot\gen4_bootstrap.exe"
$gen5 = "$PSScriptRoot\gen5_bootstrap.exe"
$gen6 = "$PSScriptRoot\gen6_bootstrap.exe"
$gen7 = "$PSScriptRoot\gen7_bootstrap.exe"

Compile-Gen $compiler $gen4 "gen3 -> gen4"
Compile-Gen $gen4 $gen5 "gen4 -> gen5"
Compile-Gen $gen5 $gen6 "gen5 -> gen6"

$hash5 = (Get-FileHash $gen5 -Algorithm SHA256).Hash
$hash6 = (Get-FileHash $gen6 -Algorithm SHA256).Hash
Write-Host ""
Write-Host "gen5 hash: $hash5"
Write-Host "gen6 hash: $hash6"

if ($hash5 -eq $hash6) {
    Write-Host "CONVERGED at gen5==gen6! Installing..."
    Copy-Item $gen5 "$PSScriptRoot\gen3_test.exe" -Force
    Copy-Item $gen5 "$PSScriptRoot\gen4_test.exe" -Force
} else {
    Write-Host "gen5 != gen6, trying one more generation..."
    Compile-Gen $gen6 $gen7 "gen6 -> gen7"

    $hash7 = (Get-FileHash $gen7 -Algorithm SHA256).Hash
    Write-Host "gen6 hash: $hash6"
    Write-Host "gen7 hash: $hash7"

    if ($hash6 -eq $hash7) {
        Write-Host "CONVERGED at gen6==gen7! Installing..."
        Copy-Item $gen6 "$PSScriptRoot\gen3_test.exe" -Force
        Copy-Item $gen6 "$PSScriptRoot\gen4_test.exe" -Force
    } else {
        Write-Host "STILL NOT CONVERGED after 4 generations"
        Write-Host "This usually means non-deterministic output in the compiler"
        Write-Host "Checking if gen5==gen7 (2-cycle)..."
        $hash5b = (Get-FileHash $gen5 -Algorithm SHA256).Hash
        if ($hash5b -eq $hash7) {
            Write-Host "gen5==gen7: 2-cycle detected. Likely non-deterministic hash-map iteration."
        }
        exit 1
    }
}

# Cleanup
Remove-Item $gen4, $gen5, $gen6, $gen7 -Force -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
Write-Host "Bootstrap complete."
