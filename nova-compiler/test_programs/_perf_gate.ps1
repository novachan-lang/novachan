# NOVA perf-regression gate (#3). Compiles canonical perf probes and FAILS if a banked native-codegen
# win regresses to dynamic dispatch (a nova_rt_* math CALL on the hot path means a value got re-boxed /
# de-specialized). Performance is a headline NOVA claim with NO other automated guard, and multiple
# specialization attempts have silently regressed before -- this protects the scalar/struct C-level wins.
# Standalone exit code: 0 = all native, 1 = a regression. Run from nova_ci.ps1 or by hand.
Set-Location $PSScriptRoot
$compiler = (Resolve-Path ".\gen3_test.exe").Path
# each probe must have ZERO dynamic math calls AND >0 of its native-op signature
$probes = @(
  @{ name = "_perf_gate_int";    native = "mul i64|add i64" },
  @{ name = "_perf_gate_float";  native = "fmul double|fadd double" },
  @{ name = "_perf_gate_struct"; native = "fmul double|fadd double" }
)
$forbidden = 'call [^@]*@nova_rt_(mul|add|sub|div|fmul|fadd|fsub|fdiv)\b'
$fail = 0
Write-Host "=== NOVA perf-regression gate ==="
foreach ($p in $probes) {
    $ll = "$($p.name).ll"
    Remove-Item $ll -ErrorAction SilentlyContinue
    & $compiler "$($p.name).nova" | Out-Null
    if (-not (Test-Path $ll)) { Write-Host "  PERF FAIL: $($p.name) did not compile"; $fail++; continue }
    $txt = Get-Content $ll
    $dyn = ($txt | Select-String -Pattern $forbidden -AllMatches | ForEach-Object { $_.Matches.Count } | Measure-Object -Sum).Sum
    if (-not $dyn) { $dyn = 0 }
    $nat = ($txt | Select-String -Pattern $p.native -AllMatches | ForEach-Object { $_.Matches.Count } | Measure-Object -Sum).Sum
    if (-not $nat) { $nat = 0 }
    if ($dyn -gt 0)      { Write-Host "  PERF REGRESSION: $($p.name) has $dyn dynamic nova_rt math call(s) on the hot path (want 0 -- value re-boxed)"; $fail++ }
    elseif ($nat -eq 0) { Write-Host "  PERF FAIL: $($p.name) emitted no native ops (want >0)"; $fail++ }
    else                { Write-Host "  PERF OK: $($p.name) -- $nat native ops, 0 dynamic" }
    Remove-Item $ll -ErrorAction SilentlyContinue
}
if ($fail -gt 0) { Write-Host "=== PERF GATE FAILED: $fail probe(s) regressed ==="; exit 1 }
Write-Host "=== PERF GATE PASSED: scalar/float/struct stay C-level native ==="
exit 0
