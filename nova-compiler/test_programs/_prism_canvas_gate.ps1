# _prism_canvas_gate.ps1 -- Prism Canvas2D backend gate (WEAPON PARITY 5.6: Prism -> Canvas for
# the browser).
#
# Every assertion here checks CONTENT, never exit code alone -- a renderer can exit 0 while
# emitting plausible garbage, which is exactly the failure mode an "it linked" check cannot catch.
#
# THREE stages, matching the task's three required assertions:
#   1. NATIVE: the small known tree's draw-command stream matches hand-derived expected values
#      EXACTLY (compile+link+run _kat_prism_render_canvas.nova, scan its own pass/FAIL output).
#   2. WASM IMPORT LIST: prism_render_canvas.nova's wasm output pulls in ONLY expected
#      nova_rt_*/nova_rc_* value-model primitives -- no network/file/thread/process symbol. See the
#      memory-noted danger this guards against: under `--allow-undefined`, a genuinely missing
#      nova_rt_* becomes an IMPORT that a host silently stubs to 0 -- wrong answers, no error.
#   3. NODE HARNESS: prism_canvas_host.js decodes a real (natively-produced) word stream into
#      fillRect/text/hit calls and a Canvas2D adapter call sequence, checked against the SAME
#      exact expected values stage 1 proves by hand arithmetic.
#
# ── WHY STAGE 2/3 DO NOT PULL A LIVE, EXECUTING WASM INSTANCE ─────────────────────────────────
# They try to (see the "best-effort" block below) -- but as of this writing, the FULL value-model
# wasm runtime carve (nova-compiler/compiler/nova_runtime_wasm.c, dated 2026-06-28) has drifted
# behind nova_runtime.c's subsequent growth and fails to compile (missing sigjmp_buf/pthread_once/
# PTHREAD_ONCE_INIT/lgamma/erf/getpeername/socket-option constants, and likely more once those are
# resolved -- nova_runtime.c is a single translation unit, so ANY new unguarded symbol breaks the
# WHOLE carve regardless of what a given program actually calls). This is a pre-existing
# infrastructure gap, unrelated to prism_render_canvas.nova's own content, and it is explicitly OUT
# OF SCOPE for this task's hard constraints (no edits to nova_compiler.nova or nova_runtime.c, and
# nova_runtime_wasm.c's needed fix is large enough -- and nova_runtime.c is under concurrent edit --
# that patching it here would be irresponsible surgery, not a rendering-backend task). So this gate
# proves everything that IS in scope for real: the program's OWN wasm compile+link surface (by
# linking the program object alone against wasm-ld with --allow-undefined and NO runtime -- this
# enumerates the exact closure of runtime symbols the renderer needs, independent of whether the
# runtime carve currently builds) and the JS decoder (against a real, natively-produced word
# stream). If the runtime carve DOES compile in this environment (checked below, non-fatally), the
# gate automatically upgrades stage 3 to a genuine live-wasm pull and reports that upgrade.
#
# Kill-on-timeout: every binary run goes through Invoke-Timed.

$ErrorActionPreference = "Continue"   # clang writes a benign target-triple warning to stderr
. (Join-Path $PSScriptRoot "_proc_util.ps1")   # also syncs prism/**/*.nova -> $NOVA_HOME/lib

$here    = $PSScriptRoot
$repoRoot = Resolve-Path (Join-Path $here "..\..")
$LLVM    = "C:\Program Files\LLVM\bin"
$nova    = Join-Path $here "gen3_test.exe"
$runtime = Join-Path $here "..\compiler\nova_runtime.o"
$env:NOVA_HOME = (Resolve-Path (Join-Path $here "..")).Path
$env:NOVA_NO_CACHE = "1"

$failed = 0
function Note-Fail([string]$msg) { Write-Host "  FAIL  $msg"; $script:failed++ }
function Note-Pass([string]$msg) { Write-Host "  pass  $msg" }

Write-Host "== stage 1: native -- exact draw-command stream for a known small tree =="
$katSrc = Join-Path $repoRoot "prism\kat\_kat_prism_render_canvas.nova"
if (-not (Test-Path $katSrc)) { Note-Fail "KAT source missing: $katSrc"; exit 1 }
Copy-Item $katSrc (Join-Path $here "_kat_prism_render_canvas.nova") -Force
Remove-Item (Join-Path $here "_kat_prism_render_canvas.ll"), (Join-Path $here "_kat_prism_render_canvas.exe") -Force -ErrorAction SilentlyContinue
Invoke-Timed -FilePath $nova -Arguments "_kat_prism_render_canvas.nova" -TimeoutMs 60000 -WorkingDirectory $here | Out-Null
if (-not (Test-Path (Join-Path $here "_kat_prism_render_canvas.ll"))) { Note-Fail "KAT did not compile"; exit 1 }
& clang -O2 -o (Join-Path $here "_kat_prism_render_canvas.exe") (Join-Path $here "_kat_prism_render_canvas.ll") $runtime -lws2_32 -ladvapi32 2>&1 | Out-Null
if (-not (Test-Path (Join-Path $here "_kat_prism_render_canvas.exe"))) { Note-Fail "KAT did not link"; exit 1 }
$katRun = Invoke-Timed -FilePath (Join-Path $here "_kat_prism_render_canvas.exe") -TimeoutMs 30000 -WorkingDirectory $here
$sawFail = ($katRun.StdOut -cmatch '(?m)^\s*FAIL\b')
if ($katRun.ExitCode -ne 0 -or $sawFail -or ($katRun.StdOut -notmatch 'ALL PASS')) {
    Note-Fail "KAT reported a failure (exit=$($katRun.ExitCode))"
    Write-Host $katRun.StdOut
    if ($katRun.StdErr) { Write-Host $katRun.StdErr }
} else {
    Note-Pass "KAT: all draw-command, framing, hit-test and event assertions passed (see _kat_prism_render_canvas.nova for the hand-derived arithmetic)"
}

Write-Host ""
Write-Host "== stage 2: wasm -- the renderer's own import surface is clean =="
$probeSrc = Join-Path $here "_wasm_canvas_probe.nova"
Remove-Item (Join-Path $here "_wasm_canvas_probe.w.ll"), (Join-Path $here "_wasm_canvas_probe.w2.ll"),
            (Join-Path $here "_wcprog.o"), (Join-Path $here "_wcprobe_noruntime.wasm") -Force -ErrorAction SilentlyContinue
Invoke-Timed -FilePath $nova -Arguments "compile --target wasm -o _wasm_canvas_probe.w.ll _wasm_canvas_probe.nova" -TimeoutMs 60000 -WorkingDirectory $here | Out-Null
if (-not (Test-Path (Join-Path $here "_wasm_canvas_probe.w.ll"))) {
    Note-Fail "wasm compile of _wasm_canvas_probe.nova failed"
} else {
    (Get-Content (Join-Path $here "_wasm_canvas_probe.w.ll")) -replace 'thread_local global', 'global' |
        Set-Content (Join-Path $here "_wasm_canvas_probe.w2.ll")
    & "$LLVM\clang.exe" --target=wasm32 -O2 -fno-builtin -nostdlib -c (Join-Path $here "_wasm_canvas_probe.w2.ll") -o (Join-Path $here "_wcprog.o") 2>&1 | Out-Null
    if (-not (Test-Path (Join-Path $here "_wcprog.o"))) {
        Note-Fail "wasm codegen of _wasm_canvas_probe.nova's LLVM IR failed"
    } else {
        # Program object alone, no runtime: --allow-undefined turns every nova_rt_*/nova_rc_* call
        # into an import instead of a link error, which is exactly what makes this the complete,
        # honest closure of what the renderer's wasm output needs -- see this file's header.
        & "$LLVM\wasm-ld.exe" --no-entry --export-all --allow-undefined --gc-sections (Join-Path $here "_wcprog.o") -o (Join-Path $here "_wcprobe_noruntime.wasm") 2>&1 | Out-Null
        if (-not (Test-Path (Join-Path $here "_wcprobe_noruntime.wasm"))) {
            Note-Fail "wasm-ld failed to link the program object"
        } else {
            $ic = Invoke-Timed -FilePath "node" -Arguments "_prism_canvas_import_check.js _wcprobe_noruntime.wasm" -TimeoutMs 30000 -WorkingDirectory $here
            Write-Host $ic.StdOut
            if ($ic.ExitCode -ne 0 -or $ic.StdOut -notmatch 'VERDICT PASS') {
                Note-Fail "wasm import list contains an unexpected or denied symbol (see IMPORT/UNEXPECTED/DENIED lines above)"
            } else {
                Note-Pass "wasm import surface: every symbol is an expected nova_rt_*/nova_rc_*/strcmp value-model primitive"
            }
        }
    }
}

# ── best-effort: is the FULL value-model wasm runtime buildable in this environment right now? ──
# Non-fatal either way -- see this file's header for why a failure here does not fail the gate.
Write-Host ""
Write-Host "-- best-effort: is the value-model wasm runtime (compiler/nova_runtime_wasm.c) currently buildable? --"
$outDir = Join-Path $here "output"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$rtBuild = Invoke-Timed -FilePath "$LLVM\clang.exe" -Arguments "--target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c ..\compiler\nova_runtime_wasm.c -o output\nova_runtime_wasm.o" -TimeoutMs 120000 -WorkingDirectory $here
$liveWasm = $false
if (Test-Path (Join-Path $outDir "nova_runtime_wasm.o")) {
    Write-Host "  runtime carve compiles -- attempting a REAL linked module + live execution"
    & "$LLVM\wasm-ld.exe" --no-entry --export-all --allow-undefined --gc-sections (Join-Path $here "_wcprog.o") (Join-Path $outDir "nova_runtime_wasm.o") -o (Join-Path $here "_wasm_canvas_probe.wasm") 2>&1 | Out-Null
    if (Test-Path (Join-Path $here "_wasm_canvas_probe.wasm")) {
        $liveWasm = $true
        Copy-Item (Join-Path $here "_wasm_canvas_probe.wasm") (Join-Path $repoRoot "prism\backend\canvas\_wasm_canvas_probe.wasm") -Force
        Write-Host "  LIVE WASM BUILD SUCCEEDED -- copied to prism/backend/canvas/_wasm_canvas_probe.wasm for the HTML harness"
    } else {
        Write-Host "  runtime carve compiled but the full link failed -- staying on the fallback path"
    }
} else {
    Write-Host "  KNOWN BLOCKER (tracked, not this backend's defect): the value-model wasm runtime carve does not"
    Write-Host "  currently compile against the present nova_runtime.c. Tail of the compiler error:"
    ($rtBuild.StdErr -split "`n" | Select-Object -Last 12) | ForEach-Object { Write-Host "    $_" }
    Write-Host "  See NOVA_DESIGN/WEAPON_PARITY_PLAN.md item 5.6 for the full explanation and what fixing it needs."
}

Write-Host ""
Write-Host "== stage 3: node harness -- decodes a real word stream into draw calls, checked exactly =="
Remove-Item (Join-Path $here "_canvas_words_dump.ll"), (Join-Path $here "_canvas_words_dump.exe"), (Join-Path $here "_canvas_words.txt") -Force -ErrorAction SilentlyContinue
Invoke-Timed -FilePath $nova -Arguments "_canvas_words_dump.nova" -TimeoutMs 60000 -WorkingDirectory $here | Out-Null
if (-not (Test-Path (Join-Path $here "_canvas_words_dump.ll"))) {
    Note-Fail "_canvas_words_dump.nova did not compile"
} else {
    & clang -O2 -o (Join-Path $here "_canvas_words_dump.exe") (Join-Path $here "_canvas_words_dump.ll") $runtime -lws2_32 -ladvapi32 2>&1 | Out-Null
    if (-not (Test-Path (Join-Path $here "_canvas_words_dump.exe"))) {
        Note-Fail "_canvas_words_dump.nova did not link"
    } else {
        $dumpRun = Invoke-Timed -FilePath (Join-Path $here "_canvas_words_dump.exe") -TimeoutMs 15000 -WorkingDirectory $here
        Set-Content -Path (Join-Path $here "_canvas_words.txt") -Value $dumpRun.StdOut -NoNewline
        $dc = Invoke-Timed -FilePath "node" -Arguments "_prism_canvas_decode_check.js _canvas_words.txt" -TimeoutMs 30000 -WorkingDirectory $here
        Write-Host $dc.StdOut
        if ($dc.ExitCode -ne 0 -or $dc.StdOut -notmatch 'ALL PASS') {
            Note-Fail "Node decode check reported a failure"
        } else {
            Note-Pass "Node harness: decoded stream matches expected draw calls exactly"
        }
    }
}

if ($liveWasm) {
    Write-Host ""
    Write-Host "-- bonus: live wasm execution (runtime carve was buildable in this environment) --"
    $liveCheck = Invoke-Timed -FilePath "node" -Arguments "-e `"const h=require('../../prism/backend/canvas/prism_canvas_host.js'); const fs=require('fs'); (async()=>{ const m=new WebAssembly.Module(fs.readFileSync('_wasm_canvas_probe.wasm')); const imp={}; for(const i of WebAssembly.Module.imports(m)){(imp[i.module]=imp[i.module]||{})[i.name]=()=>0n;} const inst=new WebAssembly.Instance(m,imp); const words=h.pullWordsFromWasmExports(inst.exports); const v=h.verify(words); console.log('live wasm words:', words.length, 'verify:', JSON.stringify(v)); process.exit(v.ok && v.cmdCount===6 ? 0 : 1); })();`"" -TimeoutMs 30000 -WorkingDirectory $here
    Write-Host $liveCheck.StdOut
    if ($liveCheck.ExitCode -ne 0) { Note-Fail "live wasm execution produced an invalid or unexpected stream" }
    else { Note-Pass "live wasm execution: real wasm instance produced the correct 6-command stream" }
}

# cleanup
Remove-Item (Join-Path $here "_kat_prism_render_canvas.nova"), (Join-Path $here "_kat_prism_render_canvas.ll"), (Join-Path $here "_kat_prism_render_canvas.exe"),
            (Join-Path $here "_wasm_canvas_probe.w.ll"), (Join-Path $here "_wasm_canvas_probe.w2.ll"), (Join-Path $here "_wcprog.o"),
            (Join-Path $here "_canvas_words_dump.ll"), (Join-Path $here "_canvas_words_dump.exe"), (Join-Path $here "_canvas_words.txt") -Force -ErrorAction SilentlyContinue

Write-Host ""
if (-not $liveWasm) {
    Write-Host "NOTE: live wasm execution is BLOCKED by the value-model runtime carve gap documented above -- this"
    Write-Host "is a real, tracked limitation (see WEAPON_PARITY_PLAN.md 5.6), not a silent skip: every check that"
    Write-Host "IS possible today (native exact-match, wasm import-surface, JS decoder) ran for real."
}
Write-Host "[prism-canvas] $failed check group(s) failed"
if ($failed -gt 0) { exit 1 }
exit 0
