# 1.6 BLAST-RADIUS MEASUREMENT — run the full regression with NOVA_FIRSTCLASS_NULL=1.
#
# This is the whole point of the flag. `null` currently lowers to a raw 0, so `null` and
# integer 0 are indistinguishable -- the last real soundness hole. The runtime already
# has a distinct null (NOVA_BOX_NULL singleton, built for JSON), so closing the hole is a
# one-line lowering change plus a migration. The MIGRATION is the risk: `== null` appears
# 510 times across std/forge/tests/compiler, and an unknown number of those rely on
# null == 0.
#
# Rather than estimate that number, measure it: compile and run the entire suite with the
# new lowering ON and let it report. Every failure is then either
#   (a) a real latent bug the old semantics were hiding, or
#   (b) intentional null-as-zero that needs migrating.
# Both are findings. Neither is a guess.
#
# NOTE: this is a MEASUREMENT, not a gate -- it is expected to fail initially, and that
# failure list IS the deliverable. Do not wire it into nova_ci.ps1.
#
# Run it ALONE. Two concurrent CI runs clobber the shared gen3_test.exe and *_test.o and
# produce hundreds of bogus LINK failures (learned the hard way 2026-08-21).
param([switch]$Quick)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers

Write-Host "=== 1.6 blast radius: full regression with NOVA_FIRSTCLASS_NULL=1 ==="
Write-Host "    (expected to FAIL; the failure list is the deliverable)"
Write-Host ""

$env:NOVA_FIRSTCLASS_NULL = "1"
# Force a full rebuild: the incremental cache keys on source mtime, and the flag changes
# CODEGEN without changing any source byte -- so a cached .ll would silently be the OLD
# lowering and the whole measurement would be a no-op reporting a false all-clear.
$env:NOVA_NO_CACHE = "1"
Remove-Item Env:NOVA_T8_FULLRC -ErrorAction SilentlyContinue

& .\_run_final_regression.ps1
$rc = $LASTEXITCODE

Remove-Item Env:NOVA_FIRSTCLASS_NULL -ErrorAction SilentlyContinue
Remove-Item Env:NOVA_NO_CACHE -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "=== blast-radius run finished (regression exit=$rc) ==="
Write-Host "    Triage each FAIL as: (a) latent bug exposed, or (b) intentional null-as-zero to migrate."
exit 0
