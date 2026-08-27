# 2.5 -- COMPILE-TIME EVALUATION.
#
# The whole feature is INVISIBLE to a value-only test: a folded const and an unfolded one
# compute the same answer, so `_kat_comptime` passing proves correctness but says nothing
# about whether any evaluation happened. This gate therefore asserts on the emitted IR:
#
#   * the comptime-only functions must NOT be CALLED at run time (they were evaluated)
#   * the folded values must be PRESENT as constants
#   * the two fail-closed cases must still be real calls -- an impure function that got
#     folded would freeze a clock reading into the binary, and a folded float would be
#     wrong in its last bits
#
# The negatives are what give this gate teeth. An implementation that folded EVERYTHING
# would pass every positive assertion here and be badly unsound.
param([string]$Compiler = ".\gen3_test.exe")

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
if (-not $env:NOVA_HOME) { $env:NOVA_HOME = (Resolve-Path "$PSScriptRoot\..").Path }

$exe = Resolve-Path $Compiler -ErrorAction SilentlyContinue
if (-not $exe) { Write-Host "COMPTIME-GATE FAIL: compiler not found: $Compiler"; exit 1 }

$fail = 0
Write-Host "2.5 compile-time evaluation:"

Remove-Item -Force _kat_comptime.ll -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath $exe.Path -Arguments "_kat_comptime.nova _kat_comptime.ll" -TimeoutMs 300000
if ($c.ExitCode -ne 0 -or -not (Test-Path _kat_comptime.ll)) {
    Write-Host "  FAIL emit (exit=$($c.ExitCode))"; Write-Host $c.StdOut; Write-Host $c.StdErr; exit 1
}
$ll = Get-Content _kat_comptime.ll -Raw

# ---- POSITIVE: evaluated, therefore not called -------------------------------------
# ct_fib is recursive, so it necessarily still calls ITSELF inside its own body if the body
# is emitted at all. What must not exist is a call from anywhere else -- i.e. the const's
# initializer. Counting is the wrong tool here; check that main does not reach it.
foreach ($fn in @("ct_squares", "ct_first_over", "ct_collatz_len", "ct_banner", "ct_grid")) {
    if ($ll -match "call i64 @$fn\(") {
        Write-Host "  FAIL $fn is still CALLED at run time -- it was not folded"; $fail++
    } else {
        Write-Host "  ok   $fn evaluated at compile time (no runtime call)"
    }
}

# ---- POSITIVE: recursion is the discriminator for ct_fib ---------------------------
# ct_fib cannot be checked with "is it called at all" -- it calls ITSELF twice, and that
# body is emitted whether or not the const folded. Exactly TWO calls means the only callers
# left are the two recursive ones, i.e. the const initializer was evaluated away. Three or
# more means the initializer is still a runtime call.
#
# NOTE: an earlier version of this gate asserted `$ll -match "6765"` and `-match "abababab"`
# instead. Both PASSED against a build that folded NOTHING, because those literals appear in
# the KAT's own comparisons (`if FIB20 == 6765`). A gate that greps for a value the test
# already writes down is not testing the compiler. Structure is the honest signal here.
$fibCalls = @(Select-String -Path _kat_comptime.ll -Pattern "call i64 @ct_fib\(" -AllMatches).Count
if ($fibCalls -eq 2) {
    Write-Host "  ok   ct_fib called exactly twice (its own recursion) -- the const was folded"
} else {
    Write-Host "  FAIL ct_fib has $fibCalls call sites, want 2 -- the const initializer survived"; $fail++
}

# ---- NEGATIVE: impurity must NOT be folded ----------------------------------------
# If time_ms() were evaluated at compile time, every run of the binary would report the
# same instant. This is the assertion that separates "folds pure code" from "folds code".
if ($ll -match "call i64 @nova_rt_time_ms\(") {
    Write-Host "  ok   an impure initializer stayed a runtime call (clock not frozen in)"
} else {
    Write-Host "  FAIL time_ms() was folded at compile time -- unsound"; $fail++
}

# ---- NEGATIVE: a float result must NOT be baked -----------------------------------
if ($ll -match "call i64 @ct_half\(") {
    Write-Host "  ok   a float result fell back to runtime (no lossy decimal literal)"
} else {
    Write-Host "  FAIL a float result was baked -- the value can differ in its last bits"; $fail++
}

# ---- BEHAVIOUR: every value correct, folded and unfolded alike --------------------
Remove-Item -Force _kat_comptime.exe -ErrorAction SilentlyContinue
$b = Invoke-Timed -FilePath $exe.Path -Arguments "build _kat_comptime.nova" -TimeoutMs 300000
if ($b.ExitCode -ne 0) { Write-Host "  FAIL build"; Write-Host $b.StdErr; exit 1 }
$r = Invoke-Timed -FilePath (Resolve-Path ".\_kat_comptime.exe").Path -Arguments "" -TimeoutMs 120000
$out = $r.StdOut + $r.StdErr
if ($out -like "*COMPTIME PASS*") {
    Write-Host "  ok   8/8 values: int, table, break/continue, while, string, nested list, 2 fallbacks"
} else {
    $line = ($out.Trim() -split "`r?`n" | Where-Object { $_ -like "FAIL*" -or $_ -like "COMPTIME*" }) -join " | "
    Write-Host "  FAIL kat (exit=$($r.ExitCode)): $line"; $fail++
}

if ($fail -eq 0) { Write-Host "COMPTIME-GATE PASS (9/9)"; exit 0 }
Write-Host "COMPTIME-GATE FAIL ($fail)"; exit 1
