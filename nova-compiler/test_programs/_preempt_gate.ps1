# 4.3 -- PREEMPTIVE SCHEDULING.
#
# Four assertions. The STRUCTURAL negative is the most important one and is checked first,
# because it is what protects the "match C" promise:
#
#   1. NEGATIVE: a program with no spawn emits ZERO preempt checks. If instrumentation ever
#      leaks into ordinary code, every GATE 4/5 benchmark pays a call per loop iteration.
#   2. POSITIVE: a spawn-reachable function DOES get the check at its loop header.
#   3. FAIRNESS: with ONE carrier, a CPU-bound task no longer starves a co-scheduled task.
#   4. KILL: a compute-bound task now observes a kill request (it never could before).
#
# Assertions 3 and 4 run with NOVA_CARRIERS=1 deliberately. With more carriers the two tasks
# land on different ones and both would pass with preemption entirely absent -- a fairness
# test that is green for the wrong reason is worse than none.
param([string]$Compiler = ".\gen3_test.exe")

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
if (-not $env:NOVA_HOME) { $env:NOVA_HOME = (Resolve-Path "$PSScriptRoot\..").Path }

$exe = Resolve-Path $Compiler -ErrorAction SilentlyContinue
if (-not $exe) { Write-Host "PREEMPT-GATE FAIL: compiler not found: $Compiler"; exit 1 }

$fail = 0
Write-Host "4.3 preemptive scheduling:"

# ---- 1. NEGATIVE: no spawn anywhere => no instrumentation at all --------------------
# _fa_bench is a pure compute benchmark. One preempt check in its inner loop would be a
# direct, permanent hit to the number GATE 5 reports.
$probe = "_fa_bench.nova"
if (-not (Test-Path $probe)) { $probe = "_f31_scalar_det.nova" }
if (Test-Path $probe) {
    $pll = [System.IO.Path]::ChangeExtension($probe, ".ll")
    Remove-Item -Force $pll -ErrorAction SilentlyContinue
    $pc = Invoke-Timed -FilePath $exe.Path -Arguments "$probe $pll" -TimeoutMs 240000
    if ($pc.ExitCode -ne 0 -or -not (Test-Path $pll)) {
        Write-Host "  FAIL could not emit $probe"; $fail++
    } else {
        $n = @(Select-String -Path $pll -Pattern "call i64 @nova_rt_preempt_check\(" -AllMatches).Count
        if ($n -eq 0) {
            Write-Host "  ok   spawn-free compute code is UNinstrumented (0 checks) -- GATE 4/5 unaffected"
        } else {
            Write-Host "  FAIL $n preempt checks leaked into spawn-free code -- this taxes every benchmark"; $fail++
        }
    }
} else {
    Write-Host "  FAIL no compute probe found to prove non-instrumentation"; $fail++
}

# ---- 2. POSITIVE: the spawned function IS instrumented -------------------------------
Remove-Item -Force _kat_preempt.ll -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath $exe.Path -Arguments "_kat_preempt.nova _kat_preempt.ll" -TimeoutMs 240000
if ($c.ExitCode -ne 0 -or -not (Test-Path _kat_preempt.ll)) {
    Write-Host "  FAIL emit (exit=$($c.ExitCode))"; Write-Host $c.StdOut; Write-Host $c.StdErr; exit 1
}
$m = @(Select-String -Path _kat_preempt.ll -Pattern "call i64 @nova_rt_preempt_check\(" -AllMatches).Count
if ($m -ge 1) {
    Write-Host "  ok   spawn-reachable loops ARE instrumented ($m check(s))"
} else {
    Write-Host "  FAIL no preempt check in spawn-reachable code -- the analysis found no roots"; $fail++
}

# ---- 3+4. BEHAVIOUR, single carrier ---------------------------------------------------
Remove-Item -Force _kat_preempt.exe -ErrorAction SilentlyContinue
$b = Invoke-Timed -FilePath $exe.Path -Arguments "build _kat_preempt.nova" -TimeoutMs 240000
if ($b.ExitCode -ne 0) { Write-Host "  FAIL build"; Write-Host $b.StdErr; exit 1 }

$env:NOVA_CARRIERS = "1"
$r = Invoke-Timed -FilePath (Resolve-Path ".\_kat_preempt.exe").Path -Arguments "" -TimeoutMs 180000
$out = $r.StdOut + $r.StdErr
Remove-Item Env:NOVA_CARRIERS -ErrorAction SilentlyContinue

if ($r.TimedOut) {
    Write-Host "  FAIL run TIMED OUT -- the hog never yielded, which IS the bug this closes"; $fail++
} else {
    if ($out -match "FAIR ok:")  { Write-Host "  ok   fairness: a hog no longer starves its carrier-mate" }
    else { Write-Host "  FAIL fairness: $(($out -split "`r?`n" | Where-Object { $_ -like 'FAIR*' }) -join ' ')"; $fail++ }

    if ($out -match "KILL ok:")  { Write-Host "  ok   kill() now reaches a compute-bound task (previously impossible)" }
    else { Write-Host "  FAIL kill: $(($out -split "`r?`n" | Where-Object { $_ -like 'KILL*' }) -join ' ')"; $fail++ }
}

# ---- 5. the escape hatch actually disables it ---------------------------------------
# NOVA_REDUCTIONS=0 exists so the instrumentation's own cost can be measured. If it did not
# really disable the yield, any measurement taken with it would be meaningless.
$env:NOVA_CARRIERS = "1"; $env:NOVA_REDUCTIONS = "0"
$r0 = Invoke-Timed -FilePath (Resolve-Path ".\_kat_preempt.exe").Path -Arguments "" -TimeoutMs 15000
$out0 = $r0.StdOut + $r0.StdErr
Remove-Item Env:NOVA_REDUCTIONS -ErrorAction SilentlyContinue
Remove-Item Env:NOVA_CARRIERS -ErrorAction SilentlyContinue
if ($r0.TimedOut -or $out0 -match "FAIR FAIL") {
    Write-Host "  ok   NOVA_REDUCTIONS=0 genuinely disables preemption (starvation returns)"
} else {
    Write-Host "  FAIL NOVA_REDUCTIONS=0 did not disable preemption -- the escape hatch is inert"; $fail++
}

if ($fail -eq 0) { Write-Host "PREEMPT-GATE PASS (5/5)"; exit 0 }
Write-Host "PREEMPT-GATE FAIL ($fail)"; exit 1
