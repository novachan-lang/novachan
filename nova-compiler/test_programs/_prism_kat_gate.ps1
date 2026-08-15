# _prism_kat_gate.ps1 -- Prism KAT gate (PRISM_ROADMAP.md milestone MA.8).
#
# Compiles, links and runs every KAT under <repo>/prism/kat/, and fails the CI if any one of them
# reports a failure or exits non-zero.
#
# ── WHY THE KATs ARE DISCOVERED, NOT LISTED ───────────────────────────────────────────────────
# This script globs prism/kat/_kat_*.nova rather than hard-coding the current ten. A hard-coded
# list is a second place to remember, and the failure mode of forgetting it is SILENT: the new
# module's KAT simply never runs while the CI still reports all-green. Discovery makes adding a
# KAT sufficient to have it gated.
#
# ── WHY THE KATs ARE COPIED IN RATHER THAN RUN IN PLACE ───────────────────────────────────────
# The canonical KAT source lives ONLY in prism/kat/ (committing a second copy under
# test_programs/ would create two sources of truth that drift -- the MA.2 precedent). But
# gen3_test.exe compiles a main program relative to test_programs/, so each KAT is copied in,
# built, run, and removed again. Imports resolve because _proc_util.ps1's Prism block installs
# prism/**/*.nova into $NOVA_HOME/lib first.
#
# ── KILL-ON-TIMEOUT IS MANDATORY ──────────────────────────────────────────────────────────────
# Every binary runs under Invoke-Timed. A runaway or crashing KAT binary would otherwise hang the
# CI host, which has happened before on this project.

# Deliberately NOT "Stop": clang writes a benign target-triple warning to stderr, and under Stop
# PowerShell raises that as a NativeCommandError and aborts the whole loop -- silently gating far
# fewer KATs than it appears to. Every step's outcome is checked explicitly below (artifact
# existence + exit code + FAIL-line scan), so failures are caught by inspection rather than by
# exception propagation.
$ErrorActionPreference = "Continue"
. (Join-Path $PSScriptRoot "_proc_util.ps1")

$here     = $PSScriptRoot
$repoRoot = Resolve-Path (Join-Path $here "..\..")
$katDir   = Join-Path $repoRoot "prism\kat"
$runtime  = Join-Path $here "..\compiler\nova_runtime.o"

if (-not (Test-Path $katDir)) {
    Write-Host "  [prism] no prism/kat directory -- nothing to gate"
    exit 0
}

$kats = Get-ChildItem -Path $katDir -Filter "_kat_*.nova" | Sort-Object Name
if ($kats.Count -eq 0) {
    Write-Host "  [prism] prism/kat exists but contains no _kat_*.nova -- treating as a FAILURE"
    Write-Host "  (an empty KAT set almost certainly means a broken path, not zero tests)"
    exit 1
}

$env:NOVA_HOME = (Resolve-Path (Join-Path $here "..")).Path
$env:NOVA_NO_CACHE = "1"

$failed = 0
$ran    = 0

foreach ($k in $kats) {
    $name = [System.IO.Path]::GetFileNameWithoutExtension($k.Name)
    $src  = Join-Path $here "$name.nova"
    $ll   = Join-Path $here "$name.ll"
    $exe  = Join-Path $here "$name.exe"

    Copy-Item $k.FullName $src -Force

    & (Join-Path $here "gen3_test.exe") "$name.nova" 2>&1 | Out-Null
    if (-not (Test-Path $ll)) {
        Write-Host "  FAIL  $name -- compile produced no IR"
        $failed++
        Remove-Item $src -Force -ErrorAction SilentlyContinue
        continue
    }

    & clang -O2 -o $exe $ll $runtime -lws2_32 -ladvapi32 2>&1 | Out-Null
    if (-not (Test-Path $exe)) {
        Write-Host "  FAIL  $name -- link failed"
        $failed++
        Remove-Item $src, $ll -Force -ErrorAction SilentlyContinue
        continue
    }

    $r = Invoke-Timed -FilePath $exe -TimeoutMs 60000
    $ran++
    # Two independent conditions, because a KAT could in principle print a failure line and still
    # exit 0 if its own accounting were wrong. Both must be clean.
    #
    # -cmatch (case-SENSITIVE) and line-anchored, deliberately. A plain `-match "FAIL"` is
    # case-insensitive in PowerShell, so it matched the word "failed" inside a KAT's own prose --
    # `== 2. a failed build leaks NOTHING ==` -- and reported a fully-passing KAT as FAIL. A gate
    # that cries wolf gets ignored, which is the same end state as a gate that cannot fail. The
    # KATs' failure convention is an uppercase `FAIL` token at the start of a line.
    $sawFail = ($r.StdOut -cmatch '(?m)^\s*FAIL\b')
    if ($r.ExitCode -ne 0 -or $sawFail) {
        Write-Host "  FAIL  $name  (exit=$($r.ExitCode))"
        Write-Host $r.StdOut
        if ($r.StdErr) { Write-Host $r.StdErr }
        $failed++
    } else {
        Write-Host "  pass  $name"
    }

    Remove-Item $src, $ll, $exe -Force -ErrorAction SilentlyContinue
}

Write-Host "  [prism] $ran KAT(s) run, $failed failed"
if ($failed -gt 0) { exit 1 }
exit 0
