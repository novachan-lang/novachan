# #30 real-interpreter gate: `nova eval` tree-walks expressions instantly (no LLVM compile).
$ErrorActionPreference = "Continue"
# NOTE: only quote-free expressions — PowerShell mangles inner " when passing args to a native
# exe (string-literal eval like len("hello")->5 and "a"+"b"->ab is verified manually, not via
# this CI shim). These exercise arithmetic, precedence, comparison, boolean, unary, %, and a
# builtin (abs) — the interpreter core.
$cases = @(
  @("2 + 3 * 4", "14"),
  @("(10 - 3) * 2", "14"),
  @("100 % 7", "2"),
  @("(2 < 4) and (3 == 3)", "1"),
  @("not (1 == 2)", "1"),
  @("abs(0 - 7)", "7"),
  @("7 - 2 * 3", "1"),
  @("(5 >= 5) or (1 > 9)", "1")
)
foreach ($c in $cases) {
  $expr = $c[0]; $want = $c[1]
  $got = (& .\gen3_test.exe eval $expr 2>$null | Out-String).Trim()
  if ($got -ne $want) { Write-Host "FAIL #30 eval [$expr] => [$got] (expected [$want])"; exit 1 }
}
Write-Host "PASS #30 interpreter: nova eval tree-walks $($cases.Count) expressions correctly (no compile)"
exit 0
