# ─────────────────────────────────────────────────────────────────────────────
# FIELD-SLOT COLLISION GATE (WEAPON_PARITY_PLAN 1.4)
#
# `ir_fmap` is a FLAT field_name -> slot map with no struct qualification, so the
# last struct to register a name wins. Any access through a receiver whose struct
# type the inferrer cannot pin down therefore used a GUESSED slot.
#
# Measured before the fix: 15 genuinely ambiguous field names across
# forge/prism/std -- `body` alone resolves to 4 different slots (Response@3,
# MpPart@4, Request@7, PgMsg@2). A wrong-slot read returns a foreign field; a
# wrong-slot WRITE corrupts one.
#
# Reproduced pre-fix by this exact probe: untyped_a printed 300 (XsAlpha's slot-3
# field) instead of 1. untyped_b printed correctly -- BY LUCK, because XsBeta
# registered last. That asymmetry is why "on collision, fall back to slot 0" was
# tried and REVERTED: it would have broken the currently-correct half.
#
# Fix: an ambiguous name on an un-inferrable receiver resolves BY NAME against the
# object's own slot-0 type hash -- nova_rt_field_get on reads, and the new
# nova_rt_field_set_by_name on writes (slot -1 sentinel, so the emitter keeps
# deciding do_inc and ownership behaviour is unchanged).
#
# NOTE ON WHY THIS GATE EXISTS AT ALL: reconverge cannot catch this class of bug.
# The compiler has 8 ambiguous field names of its own (Stmt.name@2 vs Param.name@1,
# Expr.value@2 vs IrInst.value@5) yet is immune, because it destructures with
# `match Stmt(tag, name, ...)` -- positional, never consulting ir_fmap. Our deepest
# gate is structurally blind here, so this explicit probe is the only guard.
# ─────────────────────────────────────────────────────────────────────────────
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers

$compiler = ".\gen3_test.exe"
if (-not (Test-Path $compiler)) { Write-Host "SKIP: gen3_test.exe not found"; exit 0 }

$src = "_xm_slot_probe.nova"
$ll  = "_xm_slot_probe.ll"
$exe = "_xm_slot_probe.gate.exe"
Remove-Item $ll,$exe -Force -ErrorAction SilentlyContinue

Write-Host "=== Field-slot collision gate (ambiguous field name, untyped receiver) ==="

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

# XsAlpha: xs_shared@1, xs_a_two@2, xs_a_three@3   (built as 1, 200, 300)
# XsBeta : xs_b_one@1,  xs_b_two@2,  xs_shared@3   (built as 10, 20, 3)
$expected = @(
    'typed_a=1',      # control: receiver type known -> per-struct slot, always was right
    'typed_b=3',      # control
    'untyped_a=1',    # THE BUG: printed 300 (slot 3 of XsAlpha) before the fix
    'untyped_b=3',    # was right by luck (XsBeta registered last); must STAY right
    'wrote_a=91',     # write through an un-inferrable receiver lands in the right slot
    'wrote_b=93',
    'intact_a=300',   # independent witness: the neighbouring field was NOT clobbered
    'intact_b=10'     # (a wrong-slot write would show up here, not in wrote_*)
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

if ($bad -ne 0) { Write-Host "`n=== FIELD-SLOT COLLISION GATE FAILED ==="; exit 1 }
Write-Host "  PASS: all $($expected.Count) field-slot assertions correct (reads + writes, both structs)"
exit 0
