# General read-set analysis gate (PRISM M3.4 step 1). readset_of() is a PRISM-agnostic
# compiler capability -- for a function F and a struct-typed parameter p, the set of leaf
# field-paths of p that F reads, transitively through callees, sliced through positional
# reconstructors. See NOVA_DESIGN/PRISM_M3_4_REACTIVITY_DESIGN.md §15 for the spec and
# nova_compiler.nova's "Read-set analysis (PRISM M3.4 step 1)" section for the implementation.
#
# The 6-case KAT (direct read, nested chain, alias, call-graph traversal, reconstructor
# slice, negative) lives inside run_self_test() and is exercised by `nova self-test` --
# there is no separate CLI entry point for this (§15.4: "exercised by a KAT rather than by
# end-user syntax; there is no `face` keyword yet"). This gate just runs self-test and
# checks for the KAT's own success marker, so a future regression in readset_of specifically
# (not just the pre-existing lexer/parser/codegen self-test checks) fails CI by name.
$ErrorActionPreference = "Continue"
Set-Location $PSScriptRoot
. ".\_proc_util.ps1"

$compilerName = if ($env:NOVA_REGRESSION_COMPILER) { $env:NOVA_REGRESSION_COMPILER } else { "gen3_test.exe" }
if (-not (Test-Path ".\$compilerName")) { Write-Host "FAIL readset gate: $compilerName not found"; exit 1 }
$compiler = (Resolve-Path ".\$compilerName").Path

$r = Invoke-Timed -FilePath $compiler -Arguments "self-test" -TimeoutMs 60000
if ($r.TimedOut) { Write-Host "FAIL readset gate: '$compilerName self-test' hung (killed after 60s)"; exit 1 }
if ($r.ExitCode -ne 0) {
    Write-Host "FAIL readset gate: '$compilerName self-test' exit=$($r.ExitCode)"
    Write-Host $r.StdOut
    Write-Host $r.StdErr
    exit 1
}
if ($r.StdOut -notmatch "readset_of: ALL 6 KAT CASES PASSED") {
    Write-Host "FAIL readset gate: KAT success marker not found in self-test output"
    Write-Host $r.StdOut
    exit 1
}
if ($r.StdOut -notmatch "NOVA Self-Hosting Compiler: ALL TESTS PASSED") {
    Write-Host "FAIL readset gate: self-test suite did not report overall PASSED (readset KAT may have passed but a LATER assertion in run_self_test aborted first, hiding it)"
    Write-Host $r.StdOut
    exit 1
}
Write-Host "PASS readset gate: readset_of 6-case KAT (direct read / nested chain / alias / call-graph / reconstructor slice / negative)"
exit 0
