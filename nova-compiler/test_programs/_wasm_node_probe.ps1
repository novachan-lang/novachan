# NOVA -> WebAssembly -> run in Node (proves the browser/frontend leg, one language).
# Uses gen3_test.exe (the good compiler), not gen2_move.exe.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$prog = "wasm_compute"

# 1. NOVA -> wasm-targeted LLVM IR
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile --target wasm -o $prog.ll $prog.nova" -TimeoutMs 60000
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }

# 2. wasm has no thread-local storage -> demote thread_local globals to plain globals
(Get-Content "$prog.ll") -replace 'thread_local global', 'global' | Set-Content "${prog}_wasm.ll"

# 3. clang -> .wasm (freestanding; link the compute-only wasm runtime stub)
$clangArgs = "--target=wasm32-wasip1 -O2 -nostdlib -Wl,--no-entry -Wl,--allow-undefined -Wl,--export=nova_user_main -o $prog.wasm ${prog}_wasm.ll nova_runtime_wasm.c"
$lr = Invoke-Timed -FilePath $ClangPath -Arguments $clangArgs -TimeoutMs 90000
if (!(Test-Path "$prog.wasm")) { Write-Host "wasm link failed"; Write-Host $lr.StdErr; exit 1 }
Write-Host "built $prog.wasm ($((Get-Item "$prog.wasm").Length) bytes)"

# 4. run in Node
$node = (Get-Command node -ErrorAction SilentlyContinue).Source
$nr = Invoke-Timed -FilePath $node -Arguments "wasm_run.js $prog.wasm" -TimeoutMs 30000
Write-Host "=== node output ==="
Write-Host $nr.StdOut.Trim()
if ($nr.StdErr.Trim()) { Write-Host "stderr:"; Write-Host $nr.StdErr.Trim() }
Remove-Item "$prog.ll","${prog}_wasm.ll","$prog.wasm" -Force -ErrorAction SilentlyContinue
if ($nr.StdOut -match "Return value:\s*5050") { Write-Host "RESULT: PASS (NOVA -> WASM -> Node = 5050)" } else { Write-Host "RESULT: FAIL"; exit 1 }
