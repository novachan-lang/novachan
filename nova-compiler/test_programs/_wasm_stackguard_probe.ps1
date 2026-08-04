# WASM stack-overflow containment gate.
#
# WASM has neither signals nor SEH, so the software depth counter emitted for wasm targets is
# the ONLY containment available there -- an unbounded recursion otherwise dies in an opaque
# engine trap. Native targets deliberately emit NO counter (the hardware guard page catches the
# fault for free), so this gate also asserts that the native output is untouched.
#
# Proves three things, by EXECUTION under Node, not by inspection:
#   1. native codegen emits zero guard calls
#   2. a recursion UNDER the limit returns normally through the guard
#   3. a recursion OVER the limit is CONTAINED and identifies itself via the exported flag
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$ErrorActionPreference = "Continue"
$LLVM = "C:\Program Files\LLVM\bin"
$nova = (Resolve-Path ".\gen3_test.exe").Path
$fail = 0

function Build-Wasm($srcNova, $out) {
    Remove-Item "$out.ll","$out.2.ll","$out.wasm" -Force -ErrorAction SilentlyContinue
    $c = Invoke-Timed -FilePath $nova -Arguments "compile --target wasm -o $out.ll $srcNova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path "$out.ll")) { return $false }
    # wasm has no thread-local storage -> demote thread_local globals (same step the other probes take)
    (Get-Content "$out.ll") -replace 'thread_local global', 'global' | Set-Content "$out.2.ll"
    $args = "--target=wasm32-wasip1 -O2 -nostdlib -Wl,--no-entry -Wl,--allow-undefined " +
            "-Wl,--export=nova_user_main -Wl,--export=nova_rt_stack_overflowed -Wl,--export=memory " +
            "-o $out.wasm $out.2.ll nova_runtime_wasm.c"
    Invoke-Timed -FilePath "$LLVM\clang.exe" -Arguments $args -TimeoutMs 180000 -WorkingDirectory $PSScriptRoot | Out-Null
    return (Test-Path "$out.wasm")
}

# 1. native must be UNCHANGED -- zero guard calls
Invoke-Timed -FilePath $nova -Arguments "wasm_stackguard_test.nova _sgnative.ll" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot | Out-Null
if (Test-Path "_sgnative.ll") {
    $n = (Select-String -Path "_sgnative.ll" -Pattern 'call void @nova_rt_stack_enter' -AllMatches).Count
    if ($n -eq 0) { Write-Host "  PASS native emits no stack-guard calls" }
    else { Write-Host "  FAIL native emitted $n guard calls (must be 0 -- perf regression)"; $fail++ }
} else { Write-Host "  FAIL native compile"; $fail++ }

# 2 + 3. under and over the limit, run for real
foreach ($case in @(@{d=5000; want='RETURNED'}, @{d=20000; want='GUARD FIRED'})) {
    (Get-Content "wasm_stackguard_test.nova") -replace 'deep\(100000\)', "deep($($case.d))" | Set-Content "_sgcase.nova"
    if (-not (Build-Wasm "_sgcase.nova" "_sgcase")) { Write-Host "  FAIL wasm build (depth $($case.d))"; $fail++; continue }
    $r = Invoke-Timed -FilePath "node" -Arguments "_wsg_run.js _sgcase.wasm" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    $out = "$($r.StdOut)".Trim()
    if ($out -like "*$($case.want)*") { Write-Host "  PASS depth $($case.d): $out" }
    else { Write-Host "  FAIL depth $($case.d): expected '$($case.want)', got '$out'"; $fail++ }
}

Remove-Item "_sgcase.nova","_sgcase.ll","_sgcase.2.ll","_sgcase.wasm","_sgnative.ll" -Force -ErrorAction SilentlyContinue
if ($fail -gt 0) { Write-Host "WASM STACK-GUARD GATE: $fail FAILED"; exit 1 }
Write-Host "WASM STACK-GUARD GATE: ALL PASS"
exit 0
