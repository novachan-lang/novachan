# 3.1 FLOAT-ARRAY GATE — the element read must stay INLINED, and stay CORRECT.
#
# History this pins down. A float element read used to be `call nova_rt_list_get_f` per element,
# which was the entire array gap. Measured on _fa_bench (2M doubles x 50 reps), best-of-3, quiet box:
#     call per element ................ 145 ms   1.60x C
#     + -flto (inlines the call) ...... 133 ms   1.39x C
#     inlined, NO checks ..............  96 ms   1.00x C   <- the ceiling
#     inlined, bounds + kind checked ..  99 ms   1.03x C   <- the design
#     inlined but result NOT marked
#       proven-float (regression) ..... 120 ms   1.28x C   <- see below
# C is ~95 ms.
#
# Two things are asserted, and the SECOND is the one that would rot silently:
#   1. the inlined fast path is present (structural);
#   2. the fadd consumes the read DIRECTLY, with no nova_rt_unbox in between.
# (2) matters because the emitter recognises `call nova_rt_list_get_f` as proven-raw but does NOT
# recognise a `phi`. When the inline first landed without ire_mark_float, the emitter inserted a
# defensive unbox before every fadd -- trading one call per element for a different call per element,
# and giving back two thirds of the win while every correctness test stayed green. A structural
# assertion is the only thing that catches that.
#
# Wall-clock is NOT asserted: CI runners are shared and a timing gate would flake. The structure
# above is what actually determines the speed, so structure is what gets checked.
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$root = (Resolve-Path "..").Path
$env:NOVA_NO_CACHE = "1"
$env:NOVA_HOME = $root
$nova = if (Test-Path "$PSScriptRoot\_gen4.exe") { (Resolve-Path "$PSScriptRoot\_gen4.exe").Path } else { (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path }
$fail = 0

Remove-Item -Force _fa_bench.ll -ErrorAction SilentlyContinue
$e = Invoke-Timed -FilePath $nova -Arguments "_fa_bench.nova _fa_bench.ll" -TimeoutMs 300000 -WorkingDirectory $PSScriptRoot
if (-not (Test-Path _fa_bench.ll)) { Write-Host "FARRAY-GATE FAIL: emit"; exit 1 }
$ll = Get-Content _fa_bench.ll

# 1. the inlined fast path exists
$nfast = @($ll | Where-Object { $_ -match "^fa_fast\d+:" }).Count
if ($nfast -ge 1) { Write-Host "  ok   inlined fast path present ($nfast site(s))" }
else { Write-Host "  FAIL no inlined fast path -- the per-element call is back (1.60x C)"; $fail++ }

# 2. bounds check present -- the safety half of the design
if ($ll | Where-Object { $_ -match "icmp ult i64 .*, %fasz" }) {
    Write-Host "  ok   bounds check present (icmp ult covers negative AND >= size)"
} else { Write-Host "  FAIL bounds check missing -- inlining must not drop it"; $fail++ }

# 3. elem_kind guard present -- a kind=0 boxed list MUST take the slow path
if ($ll | Where-Object { $_ -match "icmp eq i64 %faek\d+, 2" }) {
    Write-Host "  ok   elem_kind==2 guard present (boxed lists route to the runtime)"
} else { Write-Host "  FAIL elem_kind guard missing -- a boxed list would be read as raw doubles"; $fail++ }

# 4. the slow path is still the real runtime function
if ($ll | Where-Object { $_ -match "fa_slow\d+:" }) {
    if ($ll | Where-Object { $_ -match "call i64 @nova_rt_list_get_f" }) {
        Write-Host "  ok   slow path still calls nova_rt_list_get_f (errors/negatives/boxes preserved)"
    } else { Write-Host "  FAIL slow path no longer calls the runtime -- error reporting lost"; $fail++ }
} else { Write-Host "  FAIL no slow path block"; $fail++ }

# 5. NO defensive unbox between the read and the fadd (the silent 1.28x regression)
$joined = ($ll -join "`n")
if ($joined -match "phi i64 \[ %fav\d+.*\n\s*%\w+\.af = bitcast[^\n]*\n\s*%\w+\.bf\.ub = call i64 @nova_rt_unbox") {
    Write-Host "  FAIL a nova_rt_unbox sits between the inlined read and the fadd -- gives back 2/3 of the win"; $fail++
} else {
    Write-Host "  ok   no defensive unbox after the inlined read (result is marked proven-float)"
}

# 6. VALUE correctness -- the benchmark must still compute the right sum
Remove-Item -Force _fa_bench.exe -ErrorAction SilentlyContinue
$b = Invoke-Timed -FilePath $nova -Arguments "build _fa_bench.nova" -TimeoutMs 300000 -WorkingDirectory $PSScriptRoot
if ($b.ExitCode -ne 0) { Write-Host "  FAIL build"; $fail++ }
else {
    $r = Invoke-Timed -FilePath (Resolve-Path ".\_fa_bench.exe").Path -Arguments "" -TimeoutMs 300000
    $last = ($r.StdOut.Trim() -split "`r?`n")[-1]
    if ($last -match "^149999925000000") { Write-Host "  ok   sum is correct ($last)" }
    else { Write-Host "  FAIL sum '$last' want 149999925000000.0 -- fast path computes the WRONG value"; $fail++ }
}

# 7. a BOXED (kind=0) float list must still read correctly -- exercises the slow path
@'
fn main()
    let d = {}
    d["k"] = 2.5
    let xs = []
    push(xs, d["k"])
    push(xs, "str")
    push(xs, 4.0)
    let a = xs[0] * 1.0
    print("boxed0=" + str(a))
    print("boxed2=" + str(xs[2] * 1.0))
    let ys = [1.5, 2.5]
    print("typed=" + str(ys[0] + ys[1]))
'@ | Set-Content -NoNewline -Encoding ascii "$PSScriptRoot\_fa_mixed_probe.nova"
Remove-Item -Force _fa_mixed_probe.exe -ErrorAction SilentlyContinue
$mb = Invoke-Timed -FilePath $nova -Arguments "build _fa_mixed_probe.nova" -TimeoutMs 300000 -WorkingDirectory $PSScriptRoot
if ($mb.ExitCode -ne 0) { Write-Host "  FAIL mixed-list probe build"; $fail++ }
else {
    $mr = Invoke-Timed -FilePath (Resolve-Path ".\_fa_mixed_probe.exe").Path -Arguments "" -TimeoutMs 60000
    $mo = $mr.StdOut.Trim() -replace "`r",""
    foreach ($w in @("boxed0=2.5","boxed2=4.0","typed=4.0")) {
        if ($mo -match [regex]::Escape($w)) { Write-Host "  ok   $w" }
        else { Write-Host "  FAIL mixed/boxed list: missing '$w' in: $($mo -replace "`n",' | ')"; $fail++ }
    }
}

Remove-Item -Force _fa_bench.ll,_fa_mixed_probe.nova,_fa_mixed_probe.exe -ErrorAction SilentlyContinue
if ($fail -gt 0) { Write-Host "FARRAY-GATE FAIL ($fail)"; exit 1 }
Write-Host "FARRAY-GATE OK (11/11 assertions)"
exit 0
