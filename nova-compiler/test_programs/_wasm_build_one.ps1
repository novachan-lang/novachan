param([Parameter(Mandatory)][string]$src)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$LLVM = "C:\Program Files\LLVM\bin"
Remove-Item "$src.ll","$src.o","$src.wasm" -Force -ErrorAction SilentlyContinue
$r = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile $src.nova --target wasm" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($r.ExitCode -ne 0) { Write-Host "NOVA compile FAIL exit=$($r.ExitCode)"; if($r.StdOut){Write-Host $r.StdOut}; exit 1 }
$c = Invoke-Timed -FilePath "$LLVM\clang.exe" -Arguments "--target=wasm32 -O2 -c $src.ll -o $src.o" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "$src.o")) { Write-Host "clang FAIL"; if($c.StdOut){Write-Host $c.StdOut}; exit 1 }
$l = Invoke-Timed -FilePath "$LLVM\wasm-ld.exe" -Arguments "--no-entry --export=nova_user_main --export=__heap_base --allow-undefined --gc-sections $src.o -o $src.wasm" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "$src.wasm")) { Write-Host "wasm-ld FAIL"; if($l.StdOut){Write-Host $l.StdOut}; exit 1 }
Write-Host ("built $src.wasm (" + (Get-Item "$src.wasm").Length + " bytes)")
