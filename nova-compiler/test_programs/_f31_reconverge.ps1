# 3.1 reconverge — canonical 3-pass, with two deliberate deviations, both forced and both safe:
#   1. SEED = _gen3_clean.exe. Byte-identical to the COMMITTED gen3_test.exe (blob 8a6928fb,
#      verified with git hash-object). The working-tree gen3_test.exe is a contaminated build
#      carrying the reverted call-site narrowing, so seeding from it would prove nothing.
#   2. INSTALL -> _gen3_new.exe, not gen3_test.exe, which is write-locked by the Antigravity
#      Nova LSP. Swapped in separately once that handle is released.
# Everything else is _bootstrap_reconverge.ps1 unchanged.
#
# Runs strictly SERIAL. Nothing else may build while this is running: a concurrent clang -O2
# over the 22 MB IR exhausted commit charge on 2026-08-23 and killed a CI run mid-flight
# (STATUS_COMMITMENT_LIMIT, 0xC000012D).
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers

$env:NOVA_NO_CACHE = "1"
Write-Host "=== 3.1 Reconverge (3-pass, seed=_gen3_clean.exe) ==="

function Pass($n, $exe, $llOut, $exeOut) {
    Write-Host "[pass $n] $exe -> $exeOut"
    $r = Invoke-Timed -FilePath (Resolve-Path ".\$exe").Path -Arguments "..\compiler\nova_compiler.nova $llOut" -TimeoutMs 1800000
    if ($r.TimedOut) { Write-Host "FAIL pass $n TIMEOUT"; exit 1 }
    if ($r.ExitCode -ne 0) { Write-Host "FAIL pass $n (exit=$($r.ExitCode))"; Write-Host $r.StdOut; Write-Host $r.StdErr; exit 1 }
    if (!(Test-Path $llOut) -or (Get-Item $llOut).Length -lt 1000000) { Write-Host "FAIL pass $n : bad IR"; exit 1 }
    Remove-Item $exeOut -Force -ErrorAction SilentlyContinue
    $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $exeOut $llOut ..\compiler\nova_runtime.c -lws2_32 -ladvapi32 -lkernel32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 600000
    if ($l.ExitCode -ne 0 -or !(Test-Path $exeOut)) { Write-Host "FAIL link p$n (exit=$($l.ExitCode))"; Write-Host $l.StdOut; Write-Host $l.StdErr; exit 1 }
    Write-Host "  $exeOut ($((Get-Item $exeOut).Length) bytes), IR $((Get-Item $llOut).Length) bytes"
}

Pass 1 "_gen3_clean.exe" "_rc_p1.ll" "_rc_p1.exe"
Pass 2 "_rc_p1.exe"      "_rc_p2.ll" "_rc_p2.exe"
Pass 3 "_rc_p2.exe"      "_rc_p3.ll" "_rc_p3.exe"

$h4 = (Get-FileHash _rc_p1.ll -Algorithm SHA256).Hash
$h5 = (Get-FileHash _rc_p2.ll -Algorithm SHA256).Hash
$h6 = (Get-FileHash _rc_p3.ll -Algorithm SHA256).Hash
Write-Host ""
Write-Host "gen4.ll SHA256: $h4"
Write-Host "gen5.ll SHA256: $h5"
Write-Host "gen6.ll SHA256: $h6"
Write-Host ""
if ($h5 -eq $h6) {
    Write-Host "=== RECONVERGED: gen5 == gen6 (byte-identical) ==="
    Copy-Item _rc_p2.exe _gen3_new.exe -Force
    Write-Host "Installed gen5 as _gen3_new.exe (gen3_test.exe is LSP-locked; swap pending)"
    exit 0
} else {
    Write-Host "*** DIVERGED: gen5 != gen6 ***"
    exit 1
}
