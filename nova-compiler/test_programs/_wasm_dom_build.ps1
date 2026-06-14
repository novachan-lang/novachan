Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$LLVM = "C:\Program Files\LLVM\bin"
$NODE = (Get-Command node).Source
$src = "_wasm_dom_demo"
Remove-Item "$src.ll","$src.o","$src.wasm" -Force -ErrorAction SilentlyContinue
$r = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile $src.nova --target wasm" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($r.ExitCode -ne 0) { Write-Host "NOVA compile FAIL exit=$($r.ExitCode)"; if ($r.StdOut){Write-Host $r.StdOut}; if ($r.StdErr){Write-Host $r.StdErr}; exit 1 }
if (!(Test-Path "$src.ll")) { Write-Host "no .ll"; exit 1 }
$c = Invoke-Timed -FilePath "$LLVM\clang.exe" -Arguments "--target=wasm32 -O2 -c $src.ll -o $src.o" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "$src.o")) { Write-Host "clang wasm32 FAIL"; if($c.StdOut){Write-Host $c.StdOut}; if($c.StdErr){Write-Host $c.StdErr}; exit 1 }
$l = Invoke-Timed -FilePath "$LLVM\wasm-ld.exe" -Arguments "--no-entry --export=nova_user_main --export=__heap_base --allow-undefined --gc-sections $src.o -o $src.wasm" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "$src.wasm")) { Write-Host "wasm-ld FAIL"; if($l.StdOut){Write-Host $l.StdOut}; if($l.StdErr){Write-Host $l.StdErr}; exit 1 }
Write-Host ("built $src.wasm (" + (Get-Item "$src.wasm").Length + " bytes)")
# inspect the import section
$insp = Invoke-Timed -FilePath $NODE -Arguments "-e `"const fs=require('fs');WebAssembly.compile(fs.readFileSync('$src.wasm')).then(m=>{const i=WebAssembly.Module.imports(m);console.log(JSON.stringify(i));}).catch(e=>{console.log('ERR '+e);process.exit(1)})`"" -TimeoutMs 20000 -WorkingDirectory $PSScriptRoot
Write-Host "=== IMPORTS ==="
Write-Host $insp.StdOut
if ($insp.StdErr) { Write-Host "stderr: $($insp.StdErr)" }
