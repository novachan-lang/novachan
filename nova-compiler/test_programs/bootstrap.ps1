$base = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
$rt = "$base\output\nova_runtime.c"

Write-Host "=== NOVA Bootstrap Chain ==="
Set-Location $base

# Copy runtime to local dir to avoid space-in-path issues with clang
Copy-Item $rt ".\nova_runtime.c" -Force

function RunCompiler($exe, $outName) {
    if (Test-Path "nova_compiler.ll") { Remove-Item "nova_compiler.ll" -Force }
    $p = Start-Process -FilePath $exe -ArgumentList "nova_compiler.nova" -WorkingDirectory $base -RedirectStandardOutput "${outName}_stdout.txt" -RedirectStandardError "${outName}_err.txt" -PassThru -NoNewWindow
    if (-not $p.WaitForExit(60000)) {
        $p.Kill()
        Write-Host "TIMEOUT"
        return $false
    }
    if (-not (Test-Path "nova_compiler.ll")) {
        Write-Host "FAIL: no output"
        Get-Content "${outName}_err.txt" -ErrorAction SilentlyContinue
        return $false
    }
    Move-Item "nova_compiler.ll" "$outName.ll" -Force
    Write-Host "  $outName.ll: $((Get-Item "$outName.ll").Length) bytes"
    return $true
}

function CompileLL($llName, $exeName) {
    $proc = Start-Process -FilePath "clang" -ArgumentList "-O2 -o $exeName.exe $llName.ll nova_runtime.c -lws2_32" -WorkingDirectory $base -RedirectStandardOutput "${exeName}_cout.txt" -RedirectStandardError "${exeName}_cerr.txt" -PassThru -NoNewWindow
    if (-not $proc.WaitForExit(120000)) {
        $proc.Kill()
        Write-Host "TIMEOUT clang"
        return $false
    }
    if (-not (Test-Path "$exeName.exe")) {
        Write-Host "FAIL: clang produced no exe"
        Get-Content "${exeName}_cerr.txt" -ErrorAction SilentlyContinue | Select-Object -First 20
        return $false
    }
    Write-Host "  $exeName.exe: $((Get-Item "$exeName.exe").Length) bytes"
    return $true
}

Write-Host "[1/6] gen1_final_ipt.exe -> gen2_boot.ll ..."
if (-not (RunCompiler ".\gen1_final_ipt.exe" "gen2_boot")) { exit 1 }

Write-Host "[2/6] clang gen2_boot.ll -> gen2_boot.exe ..."
if (-not (CompileLL "gen2_boot" "gen2_boot")) { exit 1 }

Write-Host "[3/6] gen2_boot.exe -> gen3_boot.ll ..."
if (-not (RunCompiler ".\gen2_boot.exe" "gen3_boot")) { exit 1 }

Write-Host "[4/6] clang gen3_boot.ll -> gen3_boot.exe ..."
if (-not (CompileLL "gen3_boot" "gen3_boot")) { exit 1 }

Write-Host "[5/6] gen3_boot.exe -> gen4_boot.ll ..."
if (-not (RunCompiler ".\gen3_boot.exe" "gen4_boot")) { exit 1 }

Write-Host ""
Write-Host "[6/6] Convergence check"
$h3 = (Get-FileHash "gen3_boot.ll" -Algorithm SHA256).Hash
$h4 = (Get-FileHash "gen4_boot.ll" -Algorithm SHA256).Hash
$s3 = (Get-Item "gen3_boot.ll").Length
$s4 = (Get-Item "gen4_boot.ll").Length
Write-Host "  gen3 hash: $h3"
Write-Host "  gen4 hash: $h4"
Write-Host "  gen3 size: $s3"
Write-Host "  gen4 size: $s4"
if ($h3 -eq $h4) {
    Write-Host "*** CONVERGED *** gen3 == gen4"
    Copy-Item "gen3_boot.exe" "gen1_final_ipt.exe" -Force
    Write-Host "Production compiler updated: $((Get-Item 'gen1_final_ipt.exe').Length) bytes"
} else {
    Write-Host "*** DIVERGED *** (diff: $($s3 - $s4) bytes)"
}

Remove-Item ".\nova_runtime.c" -Force -ErrorAction SilentlyContinue
