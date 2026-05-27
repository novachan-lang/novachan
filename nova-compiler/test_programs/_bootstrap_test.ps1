. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== Bootstrap convergence check ==="
Write-Host ""

# Step 1: gen3 compiles nova_compiler.nova
Write-Host "Step 1: gen3 compiles nova_compiler.nova..."
$r1 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 120000
if ($r1.ExitCode -ne 0) {
    Write-Host "FAIL: gen3 cannot compile nova_compiler.nova"
    Write-Host $r1.StdOut
    Write-Host $r1.StdErr
    exit 1
}
Copy-Item "$PSScriptRoot\nova_compiler.ll" "$PSScriptRoot\gen3_output.ll" -Force
$hash3 = (Get-FileHash "$PSScriptRoot\gen3_output.ll" -Algorithm MD5).Hash
Write-Host "  gen3.ll hash: $hash3"

# Step 2: Link gen4 from gen3's output
Write-Host "Step 2: Link gen4..."
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "gen3_output.ll output\nova_runtime.c -o gen4_test.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($r2.ExitCode -ne 0) {
    Write-Host "FAIL: cannot link gen4"
    Write-Host $r2.StdErr
    exit 1
}

# Step 3: gen4 compiles nova_compiler.nova
Write-Host "Step 3: gen4 compiles nova_compiler.nova..."
$r3 = Invoke-Timed -FilePath "$PSScriptRoot\gen4_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 120000
if ($r3.ExitCode -ne 0) {
    Write-Host "FAIL: gen4 cannot compile nova_compiler.nova"
    Write-Host $r3.StdOut
    Write-Host $r3.StdErr
    exit 1
}
Copy-Item "$PSScriptRoot\nova_compiler.ll" "$PSScriptRoot\gen4_output.ll" -Force
$hash4 = (Get-FileHash "$PSScriptRoot\gen4_output.ll" -Algorithm MD5).Hash
Write-Host "  gen4.ll hash: $hash4"

# Compare
Write-Host ""
if ($hash3 -eq $hash4) {
    Write-Host "BOOTSTRAP CONVERGED: gen3.ll == gen4.ll (hash: $hash3)"
} else {
    Write-Host "BOOTSTRAP DIVERGED: gen3.ll != gen4.ll"
    Write-Host "  gen3: $hash3"
    Write-Host "  gen4: $hash4"
}

# Cleanup
Remove-Item "$PSScriptRoot\gen3_output.ll","$PSScriptRoot\gen4_output.ll","$PSScriptRoot\gen4_test.exe" -Force -ErrorAction SilentlyContinue
