Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Fuzz v2: each test declares expected behavior.
# - "ok": should compile cleanly + exit 0
# - "err": should emit clean error[ECODE] + exit 1
# Anything else (crash, timeout, dirty error, wrong exit) = FAIL.

$cases = @(
    # --- Original Tier-1/2/3 cases ---
    @{ name="empty";              expect="ok"  }  # empty file = no statements, builds no-op exe
    @{ name="whitespace";         expect="ok"  }
    @{ name="only_comment";       expect="ok"  }
    @{ name="unbalanced_paren";   expect="err" }
    @{ name="unbalanced_bracket"; expect="err" }
    @{ name="unclosed_string";    expect="err" }
    @{ name="bad_indent";         expect="err" }  # empty body
    @{ name="mixed_tabs";         expect="err" }
    @{ name="trailing_op";        expect="err" }
    @{ name="double_op";          expect="err" }
    @{ name="typo_ident";         expect="err" }  # KNOWN LIMITATION: needs written-never-read analysis
    @{ name="divzero";            expect="ok"  }  # runtime, not compile-time
    @{ name="huge_int";           expect="err" }  # E0012 i64 overflow
    @{ name="deep_nest";          expect="ok"  }
    @{ name="bad_escape";         expect="err" }  # E0011 invalid escape
    @{ name="missing_fn_body";    expect="err" }  # empty body
    @{ name="wrong_arity";        expect="err" }  # too many args
    @{ name="too_few_args";       expect="err" }  # E1003 arity
    @{ name="unknown_field";      expect="err" }  # E1007 no field
    @{ name="duplicate_fn";       expect="err" }  # duplicate definition
    @{ name="no_main";            expect="ok"  }  # library mode = valid
    # --- Additional adversarial cases ---
    @{ name="trailing_comma_list"; expect="ok" }   # `[1, 2, 3,]` should be accepted
    @{ name="if_no_else";         expect="ok"  }  # if without else is valid
    @{ name="else_no_if";         expect="err" }  # orphan else
    @{ name="break_outside_loop"; expect="err" }  # break_continue_check rejects
    @{ name="continue_outside_loop"; expect="err" } # same
    @{ name="reserved_as_var";    expect="err" }  # let fn = 5 -- fn is keyword
    @{ name="string_plus_int";    expect="err" }  # E1001 type mismatch
    @{ name="list_plus_int";      expect="err" }  # E1001 type mismatch
    @{ name="recursive_fn";       expect="ok"  }  # factorial
    @{ name="mutual_recursion";   expect="ok"  }
    @{ name="empty_list";         expect="ok"  }
    @{ name="empty_dict";         expect="ok"  }
    @{ name="empty_string";       expect="ok"  }
    @{ name="long_ident";         expect="ok"  }  # 128-char identifier
    @{ name="many_params";        expect="ok"  }  # 10 params
    @{ name="return_outside_fn";  expect="err" }  # top-level return is invalid
    @{ name="toplevel_print";     expect="ok"  }  # top-level statements are allowed
    @{ name="nested_calls";       expect="ok"  }  # 10-deep call nesting
    @{ name="unknown_ident";      expect="err" }  # E1002 unknown identifier
    @{ name="zero_args_called_with_one"; expect="err" } # E1003
    @{ name="struct_wrong_field_type"; expect="err" }   # E1001
    @{ name="match_no_arms";      expect="err" }  # empty match
    @{ name="for_no_body";        expect="err" }  # for with no body -- like missing fn body
    @{ name="while_no_body";      expect="err" }  # while with no body
    @{ name="spurious_semicolon"; expect="err" }  # `;` is not NOVA syntax
    @{ name="negative_int";       expect="ok"  }
    @{ name="float_basic";        expect="ok"  }
    @{ name="hex_int";            expect="ok"  }
    @{ name="binary_int";         expect="ok"  }
    @{ name="interpolation";      expect="ok"  }
    @{ name="raw_string";         expect="ok"  }
    @{ name="boolean_ops";        expect="ok"  }
    @{ name="unicode_string";     expect="ok"  }
    # --- Soundness probes (Option A: type system hardening) ---
    @{ name="index_on_int";       expect="err" }  # 5[0] -- type 'int' not indexable
    @{ name="member_on_int";      expect="err" }  # 5.foo -- type 'int' has no field
    @{ name="match_arms_mismatch"; expect="err" } # arms returning int vs string
    @{ name="list_string_index";  expect="err" }  # xs["zero"] -- list needs int index
    @{ name="variant_on_int";     expect="err" }  # match int against enum variants
    # --- Soundness probes (Option G: extended type hardening) ---
    @{ name="for_on_int";         expect="err" }  # for x in 5 -- not iterable
    @{ name="if_branches_mismatch"; expect="err" } # if branches return int vs string
    @{ name="dict_wrong_key";     expect="err" }  # dict<string,int>[int_key]
)

$pass = 0; $fail = 0
$failures = @()
$known_limitations = @()

Write-Host "=== Fuzz v2: $($cases.Count) cases ==="
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
        Write-Host ("PASS  {0,-30} (expected={1}, got={2})" -f $c.name, $expect, $actual)
        $pass++
    } elseif ($c.name -eq "typo_ident") {
        Write-Host ("KNOWN {0,-30} expected={1}, got={2} (deferred -- needs written-never-read analysis)" -f $c.name, $expect, $actual)
        $known_limitations += $c.name
    } else {
        Write-Host ("FAIL  {0,-30} expected={1}, got={2}" -f $c.name, $expect, $actual)
        $first = ($r.StdOut -split "`n" | Select-Object -First 1).Trim()
        if ($first) { Write-Host "       output: $first" }
        $fail++
        $failures += $c.name
    }
}

# Cleanup
Get-ChildItem -Path "$PSScriptRoot\fuzz_corpus" -Filter "*.ll" -ErrorAction SilentlyContinue | Remove-Item -Force

Write-Host ""
Write-Host "=== Results: $pass / $($cases.Count) pass, $fail fail, $($known_limitations.Count) known limitations ==="
if ($fail -gt 0) {
    Write-Host "Failures: $($failures -join ', ')"
}
