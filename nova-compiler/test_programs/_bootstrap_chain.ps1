Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"

Write-Host "=== Bootstrap: gen4 -> gen5 ==="
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
$r5 = Invoke-Timed -FilePath (Resolve-Path '.\gen4_chain.exe').Path -Arguments 'nova_compiler.nova' -TimeoutMs 450000 -WorkingDirectory $PSScriptRoot
Write-Host "gen4->gen5 compile EXIT: $($r5.ExitCode)"
if ($r5.StdErr) { Write-Host "STDERR: $($r5.StdErr)" }
if ($r5.ExitCode -ne 0) { Write-Host "FAILED"; exit 1 }
Copy-Item nova_compiler.ll gen5_chain.ll -Force
$l5 = Invoke-Timed -FilePath 'clang' -Arguments 'gen5_chain.ll output/nova_runtime.o -o gen5_chain.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w' -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
Write-Host "gen5 link EXIT: $($l5.ExitCode)"
if ($l5.ExitCode -ne 0) { Write-Host "LINK FAILED"; exit 1 }

Write-Host "=== Bootstrap: gen5 -> gen6 ==="
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
$r6 = Invoke-Timed -FilePath (Resolve-Path '.\gen5_chain.exe').Path -Arguments 'nova_compiler.nova' -TimeoutMs 450000 -WorkingDirectory $PSScriptRoot
Write-Host "gen5->gen6 compile EXIT: $($r6.ExitCode)"
if ($r6.StdErr) { Write-Host "STDERR: $($r6.StdErr)" }
if ($r6.ExitCode -ne 0) { Write-Host "FAILED"; exit 1 }
Copy-Item nova_compiler.ll gen6_chain.ll -Force

Write-Host "=== SHA256 comparison ==="
$h5 = (Get-FileHash gen5_chain.ll -Algorithm SHA256).Hash
$h6 = (Get-FileHash gen6_chain.ll -Algorithm SHA256).Hash
Write-Host "gen5: $h5"
Write-Host "gen6: $h6"
if ($h5 -eq $h6) {
    Write-Host "BOOTSTRAP CONVERGED - gen5 == gen6"
} else {
    Write-Host "BOOTSTRAP DIVERGED - gen5 != gen6"
    exit 1
}
