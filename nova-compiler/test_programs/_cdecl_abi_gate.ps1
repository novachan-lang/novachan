# 7.3 — @cdecl C-callback ABI gate.
#
# Compiles _kat_cdecl.nova (library mode: @export renames `main` away) and links it against
# _kat_cdecl_host.c, a REAL C program with its own main that declares every NOVA callback
# with its TRUE C prototype. That is the only honest way to test an ABI -- a wrapper whose
# prototype disagrees with the caller is broken in a way no NOVA-side test can observe.
#
# Covers: i64 callbacks (qsort comparator, no-prior-init entry), sized signed/unsigned ints
# (sext vs zext), double params+returns (XMM registers), and 32-bit float (fpext/fptrunc).
param([string]$Compiler = ".\gen3_test.exe")

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"

$exe = Resolve-Path $Compiler -ErrorAction SilentlyContinue
if (-not $exe) { Write-Host "CDECL-GATE FAIL: compiler not found: $Compiler"; exit 1 }

Remove-Item -Force _kat_cdecl.ll, _kat_cdecl_host.exe -ErrorAction SilentlyContinue

$c = Invoke-Timed -FilePath $exe.Path -Arguments "_kat_cdecl.nova _kat_cdecl.ll" -TimeoutMs 240000
if ($c.ExitCode -ne 0 -or -not (Test-Path _kat_cdecl.ll)) {
    Write-Host "CDECL-GATE FAIL: NOVA compile (exit=$($c.ExitCode))"
    if ($c.StdOut) { Write-Host $c.StdOut }
    if ($c.StdErr) { Write-Host $c.StdErr }
    exit 1
}

# The emitted wrapper prototypes must match the C host's declarations exactly. clang warns
# loudly on a mismatch, so do NOT pass -w here — that warning IS part of the check.
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o _kat_cdecl_host.exe _kat_cdecl.ll _kat_cdecl_host.c ..\compiler\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS" -TimeoutMs 300000
if (-not (Test-Path _kat_cdecl_host.exe)) {
    Write-Host "CDECL-GATE FAIL: link"
    if ($l.StdOut) { Write-Host $l.StdOut }
    if ($l.StdErr) { Write-Host $l.StdErr }
    exit 1
}

$r = Invoke-Timed -FilePath (Resolve-Path ".\_kat_cdecl_host.exe").Path -Arguments "" -TimeoutMs 120000
Write-Host $r.StdOut
if ($r.StdErr) { Write-Host "stderr: $($r.StdErr)" }
if ($r.TimedOut) { Write-Host "CDECL-GATE FAIL: host timed out"; exit 1 }
if ($r.ExitCode -ne 0) { Write-Host "CDECL-GATE FAIL: host exit=$($r.ExitCode)"; exit 1 }

# Assert on CONTENT, not just exit code — a silently-wrong ABI can still exit 0.
$out = $r.StdOut
$need = @(
    "event(21) = 42",
    "sorted: 1 2 3 5 7 9",
    "ok   narrow_i32(-7, 3) = -4",
    "ok   narrow_u8(200) = 200",
    "ok   dmul(2.5, 4.0) = 10",
    "ok   dmul(-1.5, 3.0) = -4.5",
    "ok   fhalf(3.0f) = 1.5",
    "CDECL ABI OK"
)
$missing = @()
foreach ($n in $need) { if ($out -notlike "*$n*") { $missing += $n } }
if ($missing.Count -gt 0) {
    Write-Host "CDECL-GATE FAIL: missing expected output:"
    foreach ($m in $missing) { Write-Host "  - $m" }
    exit 1
}

Write-Host "CDECL-GATE OK (8/8 assertions)"
exit 0
