Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== Bootstrap Fixpoint Check ==="

# Pass 1: gen3_test.exe compiles nova_compiler.nova
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
Write-Host "`n[1/4] gen3_test.exe -> nova_compiler.ll"
$r1 = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'nova_compiler.nova' -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($r1.ExitCode -ne 0) { Write-Host "FAIL pass 1 compile"; exit 1 }
Write-Host "  OK"

# Link pass 1
Write-Host "[2/4] link -> nova_p1.exe"
$linkArgs = "-O2 -o `"nova_p1.exe`" `"nova_compiler.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path ".\nova_p1.exe")) { Write-Host "FAIL pass 1 link"; exit 1 }
$s1 = (Get-Item ".\nova_p1.exe").Length
Write-Host "  OK ($s1 bytes)"

# Pass 2: nova_p1.exe compiles nova_compiler.nova
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
Write-Host "[3/4] nova_p1.exe -> nova_compiler.ll"
$r2 = Invoke-Timed -FilePath '.\nova_p1.exe' -Arguments 'nova_compiler.nova' -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($r2.ExitCode -ne 0) { Write-Host "FAIL pass 2 compile"; exit 1 }
Write-Host "  OK"

# Link pass 2
Write-Host "[4/4] link -> nova_p2.exe"
$linkArgs2 = "-O2 -o `"nova_p2.exe`" `"nova_compiler.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs2 -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path ".\nova_p2.exe")) { Write-Host "FAIL pass 2 link"; exit 1 }
$s2 = (Get-Item ".\nova_p2.exe").Length
Write-Host "  OK ($s2 bytes)"

# Compare
if ($s1 -eq $s2) {
    Write-Host "`n=== BOOTSTRAP FIXPOINT: PASS ($s1 bytes) ==="
    Copy-Item ".\nova_p1.exe" ".\gen3_test.exe" -Force
    Write-Host "Updated gen3_test.exe"
} else {
    Write-Host "`n=== BOOTSTRAP FIXPOINT: FAIL (pass1=$s1, pass2=$s2) ==="
    exit 1
}

Remove-Item nova_p1.exe, nova_p2.exe, nova_compiler.ll -Force -ErrorAction SilentlyContinue
