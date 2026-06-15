. "$PSScriptRoot\_proc_util.ps1"
$base = $PSScriptRoot

function Build-Gen {
    param([string]$Compiler, [string]$OutputExe, [string]$Label)

    Write-Host "=== ${Label} - Compiling nova_compiler.nova ==="
    $env:NOVA_NO_CACHE = "1"
    $r = Invoke-Timed -FilePath $Compiler -Arguments "nova_compiler.nova" -TimeoutMs 450000 -WorkingDirectory $base
    $env:NOVA_NO_CACHE = $null

    if ($r.TimedOut) { Write-Host "${Label} COMPILE TIMEOUT"; exit 1 }
    if ($r.ExitCode -ne 0) {
        Write-Host "${Label} COMPILE FAIL"
        Write-Host $r.StdOut.Substring(0, [Math]::Min(2000, $r.StdOut.Length))
        exit 1
    }

    $llFile = "$base\nova_compiler_${Label}.ll"
    Copy-Item "$base\nova_compiler.ll" $llFile -Force

    Write-Host "=== ${Label} - Linking $OutputExe ==="
    $r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$base\$OutputExe`" `"$base\nova_compiler.ll`" `"$base\output\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $base
    if ($r2.ExitCode -ne 0) { Write-Host "${Label} LINK FAIL"; Write-Host $r2.StdErr; exit 1 }

    $sz = (Get-Item "$base\$OutputExe").Length
    Write-Host "${Label} OK - $OutputExe ($sz bytes)"
    return $llFile
}

$gen5_ll = Build-Gen -Compiler "$base\workerx.exe" -OutputExe "gen5_iflet.exe" -Label "gen5"
$gen6_ll = Build-Gen -Compiler "$base\gen5_iflet.exe" -OutputExe "gen6_iflet.exe" -Label "gen6"

$hash5 = (Get-FileHash $gen5_ll -Algorithm SHA256).Hash
$hash6 = (Get-FileHash $gen6_ll -Algorithm SHA256).Hash

Write-Host ""
Write-Host "=== Bootstrap Convergence Check ==="
Write-Host "gen5 IR hash: $hash5"
Write-Host "gen6 IR hash: $hash6"

if ($hash5 -eq $hash6) {
    Write-Host "CONVERGED - gen5 == gen6 (bootstrap is sound)"
    Copy-Item "$base\gen5_iflet.exe" "$base\gen3_test.exe" -Force
    $newSz = (Get-Item "$base\gen3_test.exe").Length
    Write-Host "Installed gen5 as gen3_test.exe ($newSz bytes)"
} else {
    Write-Host "DIVERGED - gen5 != gen6 -- bootstrap FAILED"
    exit 1
}
