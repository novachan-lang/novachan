$ErrorActionPreference = "Continue"
Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"

# Save gen1
Copy-Item output.exe gen1.exe -Force
Copy-Item output.ll gen1.ll -Force
Write-Output "gen1 saved ($($(Get-Item gen1.exe).Length) bytes)"

# gen1 compiles nova_compiler.nova → gen2
Write-Output "Running gen1 to produce gen2..."
$proc = Start-Process -FilePath ".\gen1.exe" -ArgumentList "test_programs/nova_compiler.nova" -NoNewWindow -PassThru -RedirectStandardOutput gen1_stdout.txt -RedirectStandardError gen1_stderr.txt
$completed = $proc.WaitForExit(120000)
if (-not $completed) {
    $proc.Kill()
    Write-Output "TIMEOUT after 120s"
    exit 1
}
Write-Output "gen1 exit code: $($proc.ExitCode)"

if (Test-Path gen1_stdout.txt) {
    Write-Output "--- gen1 stdout (last 10 lines) ---"
    Get-Content gen1_stdout.txt | Select-Object -Last 10
}
if (Test-Path gen1_stderr.txt) {
    $stderr = Get-Content gen1_stderr.txt
    if ($stderr.Length -gt 0) {
        Write-Output "--- gen1 stderr (last 10 lines) ---"
        $stderr | Select-Object -Last 10
    }
}

if ($proc.ExitCode -ne 0) {
    Write-Output "gen1 failed, stopping bootstrap"
    exit 1
}

# Check if output.ll was regenerated
if (Test-Path output.ll) {
    $gen2lines = (Get-Content output.ll).Length
    Write-Output "gen2 output.ll: $gen2lines lines"
    Copy-Item output.ll gen2.ll -Force
    Copy-Item output.exe gen2.exe -Force
    Write-Output "gen2 saved"
} else {
    Write-Output "ERROR: no output.ll produced by gen1"
    exit 1
}

# gen2 compiles nova_compiler.nova → gen3
Write-Output "Running gen2 to produce gen3..."
$proc2 = Start-Process -FilePath ".\gen2.exe" -ArgumentList "test_programs/nova_compiler.nova" -NoNewWindow -PassThru -RedirectStandardOutput gen2_stdout.txt -RedirectStandardError gen2_stderr.txt
$completed2 = $proc2.WaitForExit(120000)
if (-not $completed2) {
    $proc2.Kill()
    Write-Output "TIMEOUT after 120s"
    exit 1
}
Write-Output "gen2 exit code: $($proc2.ExitCode)"

if (Test-Path gen2_stdout.txt) {
    Write-Output "--- gen2 stdout (last 10 lines) ---"
    Get-Content gen2_stdout.txt | Select-Object -Last 10
}

if ($proc2.ExitCode -ne 0) {
    Write-Output "gen2 failed, stopping bootstrap"
    exit 1
}

if (Test-Path output.ll) {
    $gen3lines = (Get-Content output.ll).Length
    Write-Output "gen3 output.ll: $gen3lines lines"
    Copy-Item output.ll gen3.ll -Force
    Write-Output "gen3 saved"
} else {
    Write-Output "ERROR: no output.ll produced by gen2"
    exit 1
}

# Compare gen2.ll and gen3.ll for convergence
Write-Output ""
Write-Output "=== BOOTSTRAP CONVERGENCE CHECK ==="
$diff = Compare-Object (Get-Content gen2.ll) (Get-Content gen3.ll)
if ($diff.Count -eq 0) {
    Write-Output 'SUCCESS: gen2.ll == gen3.ll -- BOOTSTRAP CONVERGED!'
} else {
    $dc = $diff.Count
    Write-Output ('DIVERGENCE: ' + $dc + ' differences between gen2.ll and gen3.ll')
    $diff | Select-Object -First 20
}
