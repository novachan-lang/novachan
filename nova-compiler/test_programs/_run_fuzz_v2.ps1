Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Fuzz v2: each test declares expected behavior.
# - "ok": should compile cleanly + run if executable produced
# - "err": should emit clean error[ECODE] + exit 1
# Anything else is a bug.

$cases = @(
    @{ name="empty";              expect="ok"  }  # empty file = no main, currently builds an exe with nothing
    @{ name="whitespace";         expect="ok"  }
    @{ name="only_comment";       expect="ok"  }
    @{ name="unbalanced_paren";   expect="err" }
    @{ name="unbalanced_bracket"; expect="err" }
    @{ name="unclosed_string";    expect="err" }
    @{ name="bad_indent";         expect="err" }
    @{ name="mixed_tabs";         expect="err" }
    @{ name="trailing_op";        expect="err" }
    @{ name="double_op";          expect="err" }
    @{ name="typo_ident";         expect="err" }  # "counte" undefined
    @{ name="divzero";            expect="ok"  }  # runtime, not compile-time
    @{ name="huge_int";           expect="err" }  # int overflow at parse
    @{ name="deep_nest";          expect="ok"  }
    @{ name="bad_escape";         expect="err" }  # \q is invalid escape
    @{ name="missing_fn_body";    expect="err" }
    @{ name="wrong_arity";        expect="err" }
    @{ name="too_few_args";       expect="err" }
    @{ name="unknown_field";      expect="err" }
    @{ name="duplicate_fn";       expect="err" }
    @{ name="no_main";            expect="err" }  # nothing to run
)

$pass = 0; $fail = 0
$failures = @()

Write-Host "=== Fuzz v2 ==="
Write-Host ""
foreach ($c in $cases) {
    $f = "$PSScriptRoot\fuzz_corpus\$($c.name).nova"
    if (!(Test-Path $f)) {
        Write-Host "MISSING: $($c.name)"
        $fail++
        continue
    }
    $r = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "`"$f`"" -TimeoutMs 15000
    $expect = $c.expect

    $actual = "?"
    if ($r.TimedOut) { $actual = "timeout" }
    elseif ($r.ExitCode -eq 0) { $actual = "ok" }
    elseif ($r.ExitCode -eq 1 -and $r.StdOut -match "error\[E\d+\]") { $actual = "err" }
    elseif ($r.ExitCode -eq 1) { $actual = "dirty-err" }
    else { $actual = "crash(exit=$($r.ExitCode))" }

    if ($actual -eq $expect) {
        Write-Host ("PASS  {0,-20} (expected={1}, got={2})" -f $c.name, $expect, $actual)
        $pass++
    } else {
        Write-Host ("FAIL  {0,-20} expected={1}, got={2}" -f $c.name, $expect, $actual)
        $first = ($r.StdOut -split "`n" | Select-Object -First 1).Trim()
        if ($first) { Write-Host "       output: $first" }
        $fail++
        $failures += $c.name
    }
}

# Cleanup
Get-ChildItem -Path "$PSScriptRoot\fuzz_corpus" -Filter "*.ll" -ErrorAction SilentlyContinue | Remove-Item -Force

Write-Host ""
Write-Host "=== Results: $pass / $($cases.Count) pass ==="
if ($fail -gt 0) {
    Write-Host "Failures: $($failures -join ', ')"
}
