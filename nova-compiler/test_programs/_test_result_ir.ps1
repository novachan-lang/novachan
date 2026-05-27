Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$r1 = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "result_test.nova" -TimeoutMs 30000
if ($r1.ExitCode -ne 0) { Write-Host "FAIL compile"; exit 1 }

# Show propagate_example function
$lines = Get-Content "result_test.ll"
$inFn = $false
foreach ($line in $lines) {
    if ($line -match "define.*@propagate_example") { $inFn = $true }
    if ($inFn) {
        Write-Host $line
        if ($line -match "^\}") { $inFn = $false; break }
    }
}

Write-Host ""
Write-Host "=== test_question_mark ==="
$inFn2 = $false
foreach ($line in $lines) {
    if ($line -match "define.*@test_question_mark") { $inFn2 = $true }
    if ($inFn2) {
        Write-Host $line
        if ($line -match "^\}") { $inFn2 = $false; break }
    }
}

Remove-Item "result_test.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
