Set-Location $PSScriptRoot
Copy-Item "../compiler/nova_runtime.c" "nova_runtime.c" -Force

$benches = @(
    @{ name="primes_seq"; file="bench_g5_primes_seq.nova"; c_ms=820 },
    @{ name="sieve10m";   file="bench_g5_sieve10m.nova";   c_ms=45 },
    @{ name="matmul";     file="bench_g5_matmul.nova";     c_ms=280 }
)

foreach ($b in $benches) {
    $name = $b.name
    $file = $b.file

    if (-not (Test-Path $file)) {
        Write-Host "$name : SKIP (file not found)"
        continue
    }

    # Compile
    if (Test-Path "$name.ll") { Remove-Item "$name.ll" -Force }
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = (Resolve-Path ".\gen1_final_ipt.exe").Path
    $psi.Arguments = $file
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $proc = [System.Diagnostics.Process]::Start($psi)
    $proc.WaitForExit(30000) | Out-Null

    $ll_name = [System.IO.Path]::GetFileNameWithoutExtension($file) + ".ll"
    if (-not (Test-Path $ll_name)) {
        Write-Host "$name : COMPILE FAILED"
        continue
    }

    # Link
    & clang -O2 -o "$name.exe" $ll_name "nova_runtime.c" -lws2_32 2>$null
    if (-not (Test-Path "$name.exe")) {
        Write-Host "$name : LINK FAILED"
        Remove-Item $ll_name -Force -ErrorAction SilentlyContinue
        continue
    }

    # Run 3 times, take best
    $best = 999999
    for ($i = 0; $i -lt 3; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $rpsi = New-Object System.Diagnostics.ProcessStartInfo
        $rpsi.FileName = (Resolve-Path ".\$name.exe").Path
        $rpsi.UseShellExecute = $false
        $rpsi.RedirectStandardOutput = $true
        $rpsi.RedirectStandardError = $true
        $rpsi.CreateNoWindow = $true
        $rproc = [System.Diagnostics.Process]::Start($rpsi)
        $rproc.WaitForExit(30000) | Out-Null
        $sw.Stop()
        $ms = $sw.ElapsedMilliseconds
        if ($ms -lt $best) { $best = $ms }
    }

    $c_ms = $b.c_ms
    $ratio = [math]::Round($best / $c_ms, 2)
    Write-Host "$name : ${best}ms (C ref: ${c_ms}ms, ratio: ${ratio}x)"

    Remove-Item $ll_name -Force -ErrorAction SilentlyContinue
    Remove-Item "$name.exe" -Force -ErrorAction SilentlyContinue
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
