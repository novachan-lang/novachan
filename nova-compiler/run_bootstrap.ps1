Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"

# Find runtime
$rtPath = "nova_runtime.c"
if (-not (Test-Path $rtPath)) {
    $rtPath = "bench/nova_runtime.c"
}
Write-Output "Runtime: $rtPath"

# Link gen2.ll -> gen2.exe
Write-Output "Linking gen2.ll -> gen2.exe..."
$linkProc = Start-Process -FilePath "clang" -ArgumentList "-O2 -w gen2.ll $rtPath -o gen2.exe -lws2_32 -lwinhttp" -NoNewWindow -PassThru -Wait -RedirectStandardOutput link2_out.txt -RedirectStandardError link2_err.txt
Write-Output ("clang exit: " + $linkProc.ExitCode)
if ($linkProc.ExitCode -ne 0) {
    if (Test-Path link2_err.txt) {
        Get-Content link2_err.txt | Select-Object -Last 20
    }
    Write-Output "Linking gen2 failed"
    exit 1
}

# gen2 compiles nova_compiler.nova -> gen3
Write-Output "Running gen2 to compile nova_compiler.nova..."
$p2 = Start-Process -FilePath ".\gen2.exe" -ArgumentList "test_programs/nova_compiler.nova" -NoNewWindow -PassThru -RedirectStandardOutput gen2_run_out.txt -RedirectStandardError gen2_run_err.txt
$done2 = $p2.WaitForExit(120000)
if (-not $done2) {
    $p2.Kill()
    Write-Output "TIMEOUT after 120s"
    exit 1
}
Write-Output ("gen2 exit: " + $p2.ExitCode)
if (Test-Path gen2_run_out.txt) {
    Get-Content gen2_run_out.txt | Select-Object -Last 5
}
if (Test-Path gen2_run_err.txt) {
    $err = Get-Content gen2_run_err.txt
    if ($err.Length -gt 0) {
        Write-Output "--- gen2 stderr ---"
        $err | Select-Object -Last 20
    }
}

# Check gen3
$gen3path = "test_programs/nova_compiler.ll"
if (Test-Path $gen3path) {
    $g3 = Get-Content $gen3path
    Write-Output ("gen3 IR: " + $g3.Length + " lines")
    Copy-Item $gen3path gen3.ll -Force
    Write-Output "Saved as gen3.ll"
} else {
    Write-Output "ERROR: no gen3 output"
    exit 1
}

# Compare gen2.ll and gen3.ll
Write-Output ""
Write-Output "=== CONVERGENCE CHECK ==="
$diff = Compare-Object (Get-Content gen2.ll) (Get-Content gen3.ll)
if ($diff.Count -eq 0) {
    Write-Output 'SUCCESS: gen2.ll == gen3.ll -- BOOTSTRAP CONVERGED!'
} else {
    $dc = $diff.Count
    Write-Output "DIVERGENCE: $dc differences"
    $diff | Select-Object -First 20
}
