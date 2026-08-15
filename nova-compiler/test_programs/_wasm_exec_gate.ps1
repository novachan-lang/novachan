# _wasm_exec_gate.ps1 -- WASM EXECUTION gate (Prism roadmap M0.1).
#
# Compiles each case to BOTH native and wasm32, runs both, and fails if they disagree.
#
# ── WHY THIS GATE EXISTS, AND WHAT IT ALREADY CAUGHT ──────────────────────────────────────────
# Before this, nothing in the CI ever RAN a wasm module and compared its answer to native. The
# existing [CI 2l] wasm sub-gate is a stack-guard probe: valuable, but it asserts a failure MODE,
# not arithmetic. The first cross-target comparison ever run found the wasm target computing
# silently wrong answers:
#     i % 2   ->  0 on wasm, correct on native
#     Collatz(300) step count -> 16 native, 8 wasm (the odd branch never fired)
#     odd_count(10) -> 5 native, 0 wasm
# Cause: nova_rt_mod was not defined in nova_runtime_wasm.c; `-Wl,--allow-undefined` turned it into
# a wasm IMPORT instead of a link error; and the harness then filled that import with a
# zero-returning stub. No link error, no trap, no failing test.
#
# ── THE STRUCTURAL CHECK IS THE IMPORTANT HALF ────────────────────────────────────────────────
# Comparing values only catches functions a test happens to exercise. Asserting the module's
# IMPORT LIST catches every missing runtime function whether exercised or not -- so a future
# nova_rt_* that this build forgets fails here immediately rather than after someone writes a test
# that happens to hit it. That is why _wasm_exec_run.js refuses to fabricate imports.
#
# ── HOW THE VALUE CROSSES ─────────────────────────────────────────────────────────────────────
# The wasm runtime is still a compute-only shim with no strings and no allocator, so a wasm module
# cannot print. Each case therefore reports its result twice: native PRINTS it, wasm RETURNS it
# from nova_user_main(). Same number, two channels. Once M0.3 lands a real wasm runtime this can
# compare stdout directly.

$ErrorActionPreference = "Continue"   # clang writes a benign triple warning to stderr; see _prism_kat_gate.ps1
. (Join-Path $PSScriptRoot "_proc_util.ps1")

$here    = $PSScriptRoot
$LLVM    = "C:\Program Files\LLVM\bin"
$nova    = Join-Path $here "gen3_test.exe"
$runtime = Join-Path $here "..\compiler\nova_runtime.o"
$env:NOVA_HOME = (Resolve-Path (Join-Path $here "..")).Path
$env:NOVA_NO_CACHE = "1"

# Cases live in _wasm_exec_cases\*.nova. Discovered, not listed -- a hard-coded list is a second
# place to remember whose failure mode is silent (same reasoning as _prism_kat_gate.ps1).
$caseDir = Join-Path $here "_wasm_exec_cases"
if (-not (Test-Path $caseDir)) { Write-Host "  [wasm] no case directory -- nothing to gate"; exit 0 }
$cases = Get-ChildItem -Path $caseDir -Filter "*.nova" | Sort-Object Name
if ($cases.Count -eq 0) { Write-Host "  [wasm] case directory is EMPTY -- treating as FAILURE"; exit 1 }

$failed = 0
$ran    = 0

foreach ($c in $cases) {
    $name = [System.IO.Path]::GetFileNameWithoutExtension($c.Name)
    $src  = Join-Path $here "$name.nova"
    Copy-Item $c.FullName $src -Force

    # ── native ──
    Remove-Item (Join-Path $here "$name.ll"), (Join-Path $here "$name.exe") -Force -ErrorAction SilentlyContinue
    Invoke-Timed -FilePath $nova -Arguments "$name.nova" -TimeoutMs 120000 -WorkingDirectory $here | Out-Null
    if (-not (Test-Path (Join-Path $here "$name.ll"))) { Write-Host "  FAIL $name -- native compile"; $failed++; continue }
    & clang -O2 -o (Join-Path $here "$name.exe") (Join-Path $here "$name.ll") $runtime -lws2_32 -ladvapi32 2>&1 | Out-Null
    if (-not (Test-Path (Join-Path $here "$name.exe"))) { Write-Host "  FAIL $name -- native link"; $failed++; continue }
    $nr = Invoke-Timed -FilePath (Join-Path $here "$name.exe") -TimeoutMs 60000 -WorkingDirectory $here
    $native = "$($nr.StdOut)".Trim()

    # ── wasm ──
    Remove-Item (Join-Path $here "$name.w.ll"), (Join-Path $here "$name.w2.ll"), (Join-Path $here "$name.wasm") -Force -ErrorAction SilentlyContinue
    Invoke-Timed -FilePath $nova -Arguments "compile --target wasm -o $name.w.ll $name.nova" -TimeoutMs 120000 -WorkingDirectory $here | Out-Null
    if (-not (Test-Path (Join-Path $here "$name.w.ll"))) { Write-Host "  FAIL $name -- wasm compile"; $failed++; continue }
    # wasm has no thread-local storage; demote (same step every other wasm probe here takes)
    (Get-Content (Join-Path $here "$name.w.ll")) -replace 'thread_local global', 'global' | Set-Content (Join-Path $here "$name.w2.ll")
    $wargs = "--target=wasm32-wasip1 -O2 -nostdlib -Wl,--no-entry -Wl,--allow-undefined " +
             "-Wl,--export=nova_user_main -Wl,--export=memory -o $name.wasm $name.w2.ll nova_runtime_wasm.c"
    Invoke-Timed -FilePath "$LLVM\clang.exe" -Arguments $wargs -TimeoutMs 180000 -WorkingDirectory $here | Out-Null
    if (-not (Test-Path (Join-Path $here "$name.wasm"))) { Write-Host "  FAIL $name -- wasm link"; $failed++; continue }

    $wr = Invoke-Timed -FilePath "node" -Arguments "_wasm_exec_run.js $name.wasm" -TimeoutMs 60000 -WorkingDirectory $here
    $ran++
    $wout = "$($wr.StdOut)"

    # Structural check first: an unexpected import means a runtime function is missing, which would
    # produce a wrong ANSWER rather than an error if anything auto-stubbed it.
    if ($wout -match 'UNRESOLVED\s+(\S+)') {
        Write-Host "  FAIL $name -- wasm module imports functions the runtime does not define: $($Matches[1])"
        Write-Host "         (a missing nova_rt_* becomes an import under --allow-undefined and would"
        Write-Host "          silently compute 0 if the host stubbed it -- see this script's header)"
        $failed++; continue
    }
    if ($wout -match 'TRAP\s+(.*)') { Write-Host "  FAIL $name -- wasm trapped: $($Matches[1])"; $failed++; continue }
    if ($wout -notmatch 'VALUE\s+(-?\d+)') { Write-Host "  FAIL $name -- wasm produced no value`n$wout"; $failed++; continue }
    $wasm = $Matches[1]

    if ($native -eq $wasm) {
        Write-Host "  pass  $name  (native == wasm == $native)"
    } else {
        Write-Host "  FAIL  $name  -- NATIVE=$native  WASM=$wasm  (same source, different answer)"
        $failed++
    }

    Remove-Item $src, (Join-Path $here "$name.ll"), (Join-Path $here "$name.exe"),
                (Join-Path $here "$name.w.ll"), (Join-Path $here "$name.w2.ll"), (Join-Path $here "$name.wasm") -Force -ErrorAction SilentlyContinue
}

Write-Host "  [wasm] $ran case(s) run, $failed failed"
if ($failed -gt 0) { exit 1 }
exit 0
