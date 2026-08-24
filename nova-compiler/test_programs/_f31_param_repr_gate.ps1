# 3.1 — declared-scalar parameter REPRESENTATION gate.
#
# Guards the rule: a parameter DECLARED `float` is guaranteed raw bits, so passing a raw
# float to it must never allocate, and conversion from `any` happens at the CALL SITE.
#
# The bug this locks out: param types were derived purely from call sites and any conflict
# collapsed to "any", so ONE caller passing a boxed/`val` argument -- anywhere in the
# program -- degraded the parameter for EVERY other caller, each of which then emitted
# nova_rt_box_float (a HEAP ALLOCATION) to pass a float into a `float` parameter.
# Measured cost of that on a hot loop: 669 ms -> 18 ms, a 37x difference, with the ONLY
# difference being an unrelated call site. Hidden cost + action-at-a-distance, both of
# which NOVA's design rules forbid.
#
# Asserts STRUCTURE (no box at a raw call site) and VALUES (the boxed path still correct) --
# structure alone would pass if the coercion were simply dropped, which would be far worse.
param([string]$Compiler = ".\gen3_test.exe")

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"

$exe = Resolve-Path $Compiler -ErrorAction SilentlyContinue
if (-not $exe) { Write-Host "PARAM-REPR-GATE FAIL: compiler not found: $Compiler"; exit 1 }

$fail = 0
Remove-Item -Force _f31_poison_probe.ll, _f31_poison_probe.exe -ErrorAction SilentlyContinue

# --- emit IR and inspect the call sites -------------------------------------------------
$c = Invoke-Timed -FilePath $exe.Path -Arguments "_f31_poison_probe.nova _f31_poison_probe.ll" -TimeoutMs 240000
if ($c.ExitCode -ne 0 -or -not (Test-Path _f31_poison_probe.ll)) {
    Write-Host "PARAM-REPR-GATE FAIL: compile (exit=$($c.ExitCode))"
    Write-Host $c.StdOut; Write-Host $c.StdErr; exit 1
}
$ll = Get-Content _f31_poison_probe.ll

Write-Host "3.1 declared-scalar param representation:"

# clean_f and poisoned_f have IDENTICAL signatures. Neither may box at a RAW call site.
foreach ($fn in @("clean_f", "poisoned_f")) {
    $boxed = @($ll | Where-Object { $_ -match "call i64 @$fn\(i64 %wbox" })
    if ($boxed.Count -eq 0) { Write-Host "  ok   $fn : no heap box at a raw call site" }
    else { Write-Host "  FAIL $fn : $($boxed.Count) call site(s) heap-box a float param"; $fail++ }
}

# The callee must stay BOX-TOLERANT. That defensive unbox is what makes it safe to declare
# the parameter raw without inserting any call-site coercion -- a boxed argument from a
# genuinely `any` call site is handled by the callee itself. An earlier cut added
# nova_rt_to_float at the call site instead and broke nn + optimizers_lib_test, because a
# "val" register can already hold RAW double bits and to_float converted them numerically.
$tolerant = @($ll | Where-Object { $_ -match "call i64 @nova_rt_unbox" })
if ($tolerant.Count -ge 1) { Write-Host "  ok   callee stays box-tolerant (defensive unbox retained)" }
else { Write-Host "  FAIL callee no longer unboxes -- a boxed arg would be read as a pointer"; $fail++ }

# --- values must still be right, including through the boxed path -----------------------
$b = Invoke-Timed -FilePath $exe.Path -Arguments "build _f31_poison_probe.nova" -TimeoutMs 240000
if ($b.ExitCode -ne 0) { Write-Host "PARAM-REPR-GATE FAIL: build"; Write-Host $b.StdErr; exit 1 }
$r = Invoke-Timed -FilePath (Resolve-Path ".\_f31_poison_probe.exe").Path -Arguments "" -TimeoutMs 120000
if ($r.ExitCode -ne 0) { Write-Host "PARAM-REPR-GATE FAIL: run exit=$($r.ExitCode)"; exit 1 }
$out = $r.StdOut.Trim()
# clean_f(3.5)=7  clean_f(7.25)=14.5  poisoned_f(3.5)=7  poisoned_f(7.25)=14.5  poisoned_f(1.5)=3
if ($out -like "*7.0 14.5 7.0 14.5 3.0*") { Write-Host "  ok   values correct (raw AND boxed paths)" }
else { Write-Host "  FAIL values wrong: '$out' (want '7.0 14.5 7.0 14.5 3.0')"; $fail++ }

# --- RULE 2: the builtin raw-float ABI -------------------------------------------------
# A declared-`float` param handed to a runtime fn that reads its arg as `any` must be BOXED.
# float_to_bits -> nova_elem_to_double converts a RAW i64 numerically, so an unboxed 1.0 came
# back as 4.6e18 (bits 4886396799603965952) instead of 4607182418800017408. This is a VALUE
# assertion on purpose: the failure mode is a silently wrong number, never a crash.
# Regression origin: _avro_kat_test encoded double(1.0) as 00 00 00 00 00 F8 CF 43.
if ($out -like "*bits 4607182418800017408 4607182418800017408*") {
    Write-Host "  ok   builtin raw-float ABI: any-reading builtin gets a boxed float"
} else {
    $got = ($out -split "`n" | Where-Object { $_ -like "bits *" }) -join ""
    Write-Host "  FAIL builtin raw-float ABI: '$got' (want 'bits 4607182418800017408 4607182418800017408')"
    $fail++
}

# --- RULE 3: int literal → declared-float param conversion ----------------
# An int literal (3) passed to a declared-float param (poisoned_f(x: float))
# must be converted to float at the call site. poisoned_f(3) = 3.0 * 2.0 = 6.0.
# Without the conversion, raw i64 3 is bitcast to double → 1.5e-323.
if ($out -like "*itof 6.0*") {
    Write-Host "  ok   int-to-float: int literal at declared-float call site converted"
} else {
    $got = ($out -split "`n" | Where-Object { $_ -like "itof *" }) -join ""
    Write-Host "  FAIL int-to-float: '$got' (want 'itof 6.0')"
    $fail++
}

# --- RULE 4: an unannotated struct param keeps its type through a forwarding call ---------
# STRUCTURAL, and it has to be: sdot returns 14.5 whether it lowers to fmul/fadd or to
# nova_rt_mul/nova_rt_add, so no value assertion can see this regression. It is the one 3.1
# cares about -- dynamic dispatch on every float operation in the body.
$body = @()
$in = $false
foreach ($line in $ll) {
    if ($line -match "^define .*@sdot\(") { $in = $true; continue }
    if ($in) { if ($line -match "^\}") { break }; $body += $line }
}
$dyn = @($body | Where-Object { $_ -match "@nova_rt_(mul|add)\(" })
$nat = @($body | Where-Object { $_ -match "= (fmul|fadd) double " })
if ($body.Count -eq 0) {
    Write-Host "  FAIL struct-param dispatch: @sdot not found in IR"; $fail++
} elseif ($dyn.Count -eq 0 -and $nat.Count -ge 3) {
    Write-Host "  ok   struct-param dispatch: @sdot lowers native (fmul/fadd, no nova_rt_*)"
} else {
    Write-Host "  FAIL struct-param dispatch: @sdot has $($dyn.Count) dynamic op(s), $($nat.Count) native (want 0 / >=3)"
    $fail++
}
# BOTH must be 14.5: the direct call and the one forwarded through fwd's untyped params.
if ($out -like "*sdot 14.5 14.5*") { Write-Host "  ok   struct-param value correct, direct AND forwarded (14.5)" }
else {
    $got = ($out -split "`n" | Where-Object { $_ -like "sdot *" }) -join ""
    Write-Host "  FAIL struct-param value: '$got' (want 'sdot 14.5 14.5')"; $fail++
}

# --- RULE 5: a parameter DECLARED `any` is never narrowed from its call sites --------------
# anyfmt(v: any) is reached with a float literal and, via passthru, with an int the call site
# cannot type. Narrowing it to float reinterprets that int's bits -- forge_statsd put 1 on the
# wire as 4.94065645841247e-324. Value assertion: the failure is a wrong number, never a crash.
if ($out -like "*anyp 2.5 7*") {
    Write-Host "  ok   declared-any param not narrowed (float and int both render correctly)"
} else {
    $got = ($out -split "`n" | Where-Object { $_ -like "anyp *" }) -join ""
    Write-Host "  FAIL declared-any narrowed: '$got' (want 'anyp 2.5 7')"; $fail++
}

if ($fail -gt 0) { Write-Host "PARAM-REPR-GATE FAIL ($fail)"; exit 1 }
Write-Host "PARAM-REPR-GATE OK (9/9 assertions)"
exit 0
