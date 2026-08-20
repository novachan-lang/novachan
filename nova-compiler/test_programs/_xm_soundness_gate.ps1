# ─────────────────────────────────────────────────────────────────────────────
# CROSS-MODULE SOUNDNESS GATE (WEAPON_PARITY_PLAN Phase 1.1-1.3)
#
# Three holes existed at the MODULE BOUNDARY that did not exist inside a single
# file, because ti_infer_program_named's import scan only ever processed
# `mtag == "fn"`:
#
#   1.1  an IMPORTED enum never populated ti_enum_variants/ti_variant_enum, so
#        E1009 exhaustiveness could not fire across the boundary  (covered by
#        _neg_type_tests.ps1 -> _xm_exhaustive_neg.nova)
#   1.2  a bare constructor of an imported enum's variant was E1002
#   1.3  a defaulted param was dropped at the boundary: ti_min_arity was set to
#        len(params) instead of counting non-defaulted params (=> E1003), and
#        compile_module_ir never wrote ir_fn_defaults + the module-qualified IR
#        call path never padded the actuals with the defaults.
#
# WHY THIS GATE ASSERTS VALUES, NOT JUST EXIT CODES:
#   The first cut of the 1.3 fix repaired ONLY the type checker. The program
#   then compiled and ran cleanly -- and printed ", World" for greet("World")
#   and 1 for add(1) (expected "Hello, World" and 111), because the IR side
#   still passed 0/null for every omitted argument. A loud E1003 had become a
#   SILENT WRONG ANSWER. An exit-code-only gate is green for that bug.
#   So: every line of expected output is asserted exactly.
# ─────────────────────────────────────────────────────────────────────────────
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers

$compiler = ".\gen3_test.exe"
if (-not (Test-Path $compiler)) { Write-Host "SKIP: gen3_test.exe not found"; exit 0 }

$src = "_xm_ctor_default.nova"
$ll  = "_xm_ctor_default.ll"
$exe = "_xm_ctor_default.probe.exe"
Remove-Item $ll,$exe -Force -ErrorAction SilentlyContinue

Write-Host "=== Cross-module soundness gate (imported enum ctor + default params) ==="

$c = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$src $ll" -TimeoutMs 120000
if ($c.TimedOut -or $c.ExitCode -ne 0) {
    Write-Host "  FAIL: compile of $src failed (exit=$($c.ExitCode) timedout=$($c.TimedOut))"
    if ($c.StdOut) { Write-Host $c.StdOut }
    if ($c.StdErr) { Write-Host $c.StdErr }
    exit 1
}

$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $exe $ll ..\compiler\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
if (-not (Test-Path $exe)) {
    Write-Host "  FAIL: link failed"
    if ($l.StdErr) { Write-Host $l.StdErr }
    exit 1
}

$r = Invoke-Timed -FilePath (Resolve-Path ".\$exe").Path -Arguments "" -TimeoutMs 30000
if ($r.TimedOut -or $r.ExitCode -ne 0) {
    Write-Host "  FAIL: run failed (exit=$($r.ExitCode) timedout=$($r.TimedOut))"
    exit 1
}

# Exact expected output, in order. Each line pins one behaviour:
$expected = @(
    'ctor-ok red 7',      # 1.2  bare ctor of an imported enum variant, payload intact
    'mod-ok blue 3',      # 1.1  exhaustive match over an imported enum from a module fn
    'Hello, World',       # 1.3  omitted defaulted arg gets the DECLARED default (not null)
    'Hi, World',          # 1.3  explicit arg still overrides the default
    'add1=111',           # 1.3  both defaults applied  (1 + 10 + 100)
    'add2=103',           # 1.3  one default applied    (1 +  2 + 100)
    'add3=6',             # 1.3  no defaults applied    (1 +  2 +   3)
    'struct=11/22',       # 1.2b bare ctor of an imported PLAIN STRUCT + field reads
    'wrapper=11/22'       # 1.2b the wrapper-fn route still works, unchanged
)

$got = @($r.StdOut -split "`r?`n" | Where-Object { $_.Trim() -ne "" })

$bad = 0
if ($got.Count -ne $expected.Count) {
    Write-Host "  FAIL: expected $($expected.Count) output lines, got $($got.Count)"
    Write-Host "  --- got ---"; $got | ForEach-Object { Write-Host "    $_" }
    $bad = 1
} else {
    for ($i = 0; $i -lt $expected.Count; $i++) {
        if ($got[$i].Trim() -ne $expected[$i]) {
            Write-Host "  FAIL line $($i+1): expected '$($expected[$i])' got '$($got[$i].Trim())'"
            $bad = 1
        }
    }
}

Remove-Item $exe -Force -ErrorAction SilentlyContinue

if ($bad -ne 0) { Write-Host "`n=== CROSS-MODULE SOUNDNESS GATE FAILED ==="; exit 1 }
Write-Host "  PASS: all $($expected.Count) cross-module assertions correct"
exit 0
