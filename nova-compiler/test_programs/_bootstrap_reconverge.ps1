Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# After a CODEGEN change, gen4 (built by the still-old gen3) carries the old
# codegen for any latent for-in+continue loop in the compiler itself. The fix
# only takes full effect at gen5. So we run THREE passes and require gen5==gen6
# (byte-identical .ll) before installing gen5 as the new gen3_test.exe.

function Compile-Link {
    param([string]$compiler, [string]$outExe, [string]$saveLl)
    Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
    $r = Invoke-Timed -FilePath $compiler -Arguments 'nova_compiler.nova' -TimeoutMs 180000 -WorkingDirectory $PSScriptRoot
    if ($r.TimedOut -or $r.ExitCode -ne 0) { Write-Host "FAIL compile via $compiler (exit=$($r.ExitCode) timedout=$($r.TimedOut))"; if ($r.StdOut) { Write-Host $r.StdOut.Substring(0,[Math]::Min(800,$r.StdOut.Length)) }; exit 1 }
    if (!(Test-Path nova_compiler.ll)) { Write-Host "FAIL: no .ll from $compiler"; exit 1 }
    if ($saveLl) { Copy-Item nova_compiler.ll $saveLl -Force }
    $linkArgs = "-O2 -o `"$outExe`" `"nova_compiler.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
    Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot | Out-Null
    if (!(Test-Path $outExe)) { Write-Host "FAIL link -> $outExe"; exit 1 }
    $sz = (Get-Item $outExe).Length
    Write-Host "  $outExe ($sz bytes)"
}

Write-Host "=== Bootstrap Reconverge (3-pass) ==="
Write-Host "[pass 1] gen3_test.exe -> gen4 (nova_p1.exe)"
Compile-Link -compiler '.\gen3_test.exe' -outExe 'nova_p1.exe' -saveLl 'gen4.ll'

Write-Host "[pass 2] gen4 -> gen5 (nova_p2.exe)"
Compile-Link -compiler '.\nova_p1.exe' -outExe 'nova_p2.exe' -saveLl 'gen5.ll'

Write-Host "[pass 3] gen5 -> gen6 (nova_p3.exe)"
Compile-Link -compiler '.\nova_p2.exe' -outExe 'nova_p3.exe' -saveLl 'gen6.ll'

$h5 = (Get-FileHash gen5.ll -Algorithm SHA256).Hash
$h6 = (Get-FileHash gen6.ll -Algorithm SHA256).Hash
Write-Host "`ngen5.ll SHA256: $h5"
Write-Host "gen6.ll SHA256: $h6"

if ($h5 -eq $h6) {
    Write-Host "`n=== RECONVERGED: gen5 == gen6 (byte-identical) ==="
    Copy-Item 'nova_p2.exe' 'gen3_test.exe' -Force
    Write-Host "Installed gen5 as gen3_test.exe"
    Remove-Item nova_p1.exe, nova_p2.exe, nova_p3.exe, gen4.ll, gen5.ll, gen6.ll, nova_compiler.ll -Force -ErrorAction SilentlyContinue
    exit 0
} else {
    Write-Host "`n=== NOT CONVERGED: gen5 != gen6 ==="
    Write-Host "Keeping artifacts for inspection (gen4.ll, gen5.ll, gen6.ll)"
    exit 1
}
