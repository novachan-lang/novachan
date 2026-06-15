Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path

# Run the same compiler on the same input twice, check if .ll output is identical
Write-Host "Test: compile nova_compiler.nova twice with same compiler..."

$cr1 = Invoke-Timed -FilePath $compiler -Arguments "nova_compiler.nova" -TimeoutMs 600000
Write-Host "Run 1: exit=$($cr1.ExitCode)"
Copy-Item "$PSScriptRoot\nova_compiler.ll" "$PSScriptRoot\nova_compiler_run1.ll" -Force

$cr2 = Invoke-Timed -FilePath $compiler -Arguments "nova_compiler.nova" -TimeoutMs 600000
Write-Host "Run 2: exit=$($cr2.ExitCode)"
Copy-Item "$PSScriptRoot\nova_compiler.ll" "$PSScriptRoot\nova_compiler_run2.ll" -Force

$h1 = (Get-FileHash "$PSScriptRoot\nova_compiler_run1.ll" -Algorithm SHA256).Hash
$h2 = (Get-FileHash "$PSScriptRoot\nova_compiler_run2.ll" -Algorithm SHA256).Hash

Write-Host "Run 1 .ll hash: $h1"
Write-Host "Run 2 .ll hash: $h2"

if ($h1 -eq $h2) {
    Write-Host "DETERMINISTIC: same compiler, same input = same output"
    Write-Host "Non-convergence is because different compiler binaries produce different output"
} else {
    Write-Host "NON-DETERMINISTIC: same compiler, same input = DIFFERENT output!"
    Write-Host "Finding first diff..."
    $lines1 = Get-Content "$PSScriptRoot\nova_compiler_run1.ll"
    $lines2 = Get-Content "$PSScriptRoot\nova_compiler_run2.ll"
    Write-Host "Lines in run1: $($lines1.Count), run2: $($lines2.Count)"
    for ($i = 0; $i -lt [Math]::Min($lines1.Count, $lines2.Count); $i++) {
        if ($lines1[$i] -ne $lines2[$i]) {
            Write-Host "First diff at line $($i+1):"
            Write-Host "  Run1: $($lines1[$i])"
            Write-Host "  Run2: $($lines2[$i])"
            break
        }
    }
}

Remove-Item "$PSScriptRoot\nova_compiler_run1.ll","$PSScriptRoot\nova_compiler_run2.ll","$PSScriptRoot\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
