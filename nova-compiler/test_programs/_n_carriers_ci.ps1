# N>1 multi-core scheduler regression gate (#12a). The audit flagged that the M:N scheduler -- fixed via
# no-migration task pinning (71a651d) -- has ZERO regression coverage (the 552-test suite runs N=1 only).
# This gate runs the concurrency flagships under NOVA_CARRIERS=4 AND 8 with kill-on-timeout, so a future
# change that re-introduces the migration deadlock / a lost-wakeup / a double-resume is caught, not shipped.
# Script-only (no compiler/runtime change). Exit 0 = all clean, 1 = any hang/abort/wrong-output.
# Usage: powershell -ExecutionPolicy Bypass -File ./_n_carriers_ci.ps1  [-Iters 3] [-TimeoutSec 20]
param([int]$Iters = 3, [int]$TimeoutSec = 20)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"   # sets NOVA_HOME (+ syncs std/ & forge/) so tests importing std/ modules resolve
$compiler = (Resolve-Path ".\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\..\compiler\nova_runtime.c"
$clang = "clang"
$lflags = "-lws2_32 -ladvapi32 -lkernel32 -D_CRT_SECURE_NO_WARNINGS -w"

# test -> the substring that proves a CORRECT, COMPLETE run (not just a clean exit)
$tests = @(
    @{ name = "green_scale_test"; ok = "GREEN SCALE PASS" },
    @{ name = "_mn_stress_test";  ok = "MN_STRESS_OK" },
    @{ name = "_mn_churn";        ok = "MN CHURN OK" },  # sequential slot-reuse + reclaim-bounds-the-pool proof (default reclaim ON at N>1)
    @{ name = "showcase_concurrency_test"; ok = "showcase_concurrency_test passed" }  # std/sync semaphore + channel-serialized counter: no lost updates + ceiling never exceeded under N>1
)

$fail = 0
foreach ($t in $tests) {
    $nova = "$($t.name).nova"
    if (-not (Test-Path $nova)) { Write-Host "  SKIP $($t.name) (no source)"; continue }
    $ll = "$($t.name).ll"; $exe = "$($t.name).ncc.exe"
    Remove-Item $ll, $exe -ErrorAction SilentlyContinue
    & $compiler $nova *> $null
    if (-not (Test-Path $ll)) { Write-Host "  FAIL $($t.name): did not compile"; $fail++; continue }
    & $clang -O2 -o $exe $ll $runtimeSrc $lflags.Split(' ') *> $null
    Remove-Item $ll -ErrorAction SilentlyContinue
    if (-not (Test-Path $exe)) { Write-Host "  FAIL $($t.name): did not link"; $fail++; continue }
    foreach ($ncar in 4, 8) {
        $env:NOVA_CARRIERS = "$ncar"
        for ($i = 1; $i -le $Iters; $i++) {
            & "$PSScriptRoot\_safe_scale_run.ps1" -Exe ".\$exe" -TimeoutSec $TimeoutSec *> $null
            $out = Get-Content "$exe.scaleout.txt" -Raw -ErrorAction SilentlyContinue
            if ($out -match [regex]::Escape($t.ok)) {
                # clean
            } else {
                Write-Host "  FAIL $($t.name) @ N=$ncar iter $i (hang / abort / wrong output)"
                $fail++
            }
        }
        Write-Host "  $($t.name) @ N=$ncar : $Iters run(s) checked"
    }
    Remove-Item Env:NOVA_CARRIERS -ErrorAction SilentlyContinue
    Remove-Item $exe, "$exe.scaleout.txt", "$exe.scaleerr.txt" -ErrorAction SilentlyContinue
}
if ($fail -gt 0) { Write-Host "=== N>1 GATE FAILED: $fail problem(s) ==="; exit 1 }
Write-Host "=== N>1 GATE PASSED: concurrency flagships clean at NOVA_CARRIERS=4 and 8 ==="
exit 0
