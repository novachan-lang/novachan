# ─────────────────────────────────────────────────────────────────────────────
# PATTERN-MATCHING GATE (WEAPON_PARITY_PLAN 2.1 nested patterns, 2.2 guards)
#
# 2.1 NESTED CONSTRUCTOR PATTERNS. parse_pattern's pat_ctor branch used to read
#     exactly ONE token per field and always wrap it as a binder, so
#     `Wrap(IntVal(n))` read `IntVal` as a variable and then met `(` where it
#     expected `,` or `)`. Nesting is what makes ADTs compose -- Result-of-Option,
#     tree children, protocol payloads -- and without it every layer cost a
#     separate nested `match`, i.e. exactly the ceremony NOVA claims to remove.
#     Now: the parser recurses, ti_infer_pattern recurses with the payload's
#     declared type (both the user-enum and the built-in-sum branch), and
#     ir_destructure_ctor emits a runtime tag test per nesting level, branching to
#     the arm's existing mismatch label so no new control flow is introduced.
#
# 2.2 PATTERN GUARDS were listed as TODO in the plan but were ALREADY implemented
#     (parsed ~3688, lowered at all three match sites). Verified here rather than
#     assumed -- and now gated, since an implemented-but-untested feature is one
#     refactor away from silently regressing.
#
# Coverage that matters:
#   - depth 3 (L1(L2(L3(n)))), proving the recursion is not special-cased to 2
#   - nesting inside a built-in Result sum, which takes the is_sum_match branch in
#     ti_infer_pattern -- a DIFFERENT code path from user enums
#   - NOTE: the old n7/n8 pair pinned the outer-level-only limitation (a match
#     missing an inner case compiled and fell through to ""). Item 2.9 turned that
#     into a compile error, so those two assertions were deliberately REMOVED and
#     the case now lives in _neg_type_tests.ps1 as _negty_nested_exhaustive.nova.
# ─────────────────────────────────────────────────────────────────────────────
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers

$compiler = ".\gen3_test.exe"
if (-not (Test-Path $compiler)) { Write-Host "SKIP: gen3_test.exe not found"; exit 0 }

$cases = @(
    @{ src = "_p2_guards.nova"; expected = @(
        'g1=negative',       # guard on the FIRST arm
        'g2=zero',           # unguarded literal arm still reachable after a guard
        'g3=huge',           # guard on a MIDDLE arm
        'g4=small',          # falls past both guards to the catch-all binder
        'g5=big circle',     # guard on a CTOR pattern; binder in scope in the guard
        'g6=small circle',   # same ctor, guard false -> next arm
        'g7=big square',
        'g8=small square'
    )},
    @{ src = "_p2_nested.nova"; expected = @(
        'n1=int:42',         # 2 levels, user enum
        'n2=str:hi',         # sibling inner ctor -> second arm
        'n3=empty',          # zero-payload outer ctor unaffected
        'n4=7',              # THREE levels deep
        'n5=ok-int:5',       # nested inside built-in Result (is_sum_match path)
        'n6=err:bad'         # Err arm of the same match
    )}
)

Write-Host "=== Pattern gate (2.1 nested constructor patterns, 2.2 guards) ==="
$bad = 0

foreach ($case in $cases) {
    $src = $case.src
    $base = [System.IO.Path]::GetFileNameWithoutExtension($src)
    $ll = "$base.ll"
    $exe = "$base.gate.exe"
    Remove-Item $ll,$exe -Force -ErrorAction SilentlyContinue

    $c = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$src $ll" -TimeoutMs 120000
    if ($c.TimedOut -or $c.ExitCode -ne 0) {
        Write-Host "  FAIL $src : compile failed (exit=$($c.ExitCode) timedout=$($c.TimedOut))"
        if ($c.StdOut) { Write-Host $c.StdOut }
        $bad = 1; continue
    }
    $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $exe $ll ..\compiler\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
    if (-not (Test-Path $exe)) {
        Write-Host "  FAIL $src : link failed"
        if ($l.StdErr) { Write-Host $l.StdErr }
        $bad = 1; continue
    }
    $r = Invoke-Timed -FilePath (Resolve-Path ".\$exe").Path -Arguments "" -TimeoutMs 30000
    if ($r.TimedOut -or $r.ExitCode -ne 0) {
        Write-Host "  FAIL $src : run failed (exit=$($r.ExitCode) timedout=$($r.TimedOut))"
        $bad = 1
        Remove-Item $exe -Force -ErrorAction SilentlyContinue
        continue
    }

    $exp = $case.expected
    $got = @($r.StdOut -split "`r?`n" | Where-Object { $_.Trim() -ne "" })
    if ($got.Count -ne $exp.Count) {
        Write-Host "  FAIL $src : expected $($exp.Count) lines, got $($got.Count)"
        $got | ForEach-Object { Write-Host "      $_" }
        $bad = 1
    } else {
        for ($i = 0; $i -lt $exp.Count; $i++) {
            if ($got[$i].Trim() -ne $exp[$i]) {
                Write-Host "  FAIL $src line $($i+1): expected '$($exp[$i])' got '$($got[$i].Trim())'"
                $bad = 1
            }
        }
    }
    if ($bad -eq 0) { Write-Host "  PASS $src ($($exp.Count) assertions)" }
    Remove-Item $exe -Force -ErrorAction SilentlyContinue
}

if ($bad -ne 0) { Write-Host "`n=== PATTERN GATE FAILED ==="; exit 1 }
Write-Host "  PASS: nested patterns (depth 3, user enum + built-in sum) and guards all correct"
exit 0
