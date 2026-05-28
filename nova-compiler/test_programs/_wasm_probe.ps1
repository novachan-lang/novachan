Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Hand-crafted minimal valid WASM module:
#   (module (func (export "main") (result i32) i32.const 40  i32.const 2  i32.add))
# 40 bytes. Executing its bytecode must yield 40 + 2 = 42.
$wasm = [byte[]]@(
    0x00,0x61,0x73,0x6D, 0x01,0x00,0x00,0x00,            # magic + version
    0x01,0x05,0x01,0x60,0x00,0x01,0x7F,                  # type:  () -> i32
    0x03,0x02,0x01,0x00,                                 # func:  1 function, type 0
    0x07,0x08,0x01,0x04,0x6D,0x61,0x69,0x6E,0x00,0x00,   # export "main" -> func 0
    0x0A,0x09,0x01,0x07,0x00,0x41,0x28,0x41,0x02,0x6A,0x0B # code: const 40, const 2, add, end
)
[System.IO.File]::WriteAllBytes("$PSScriptRoot\add.wasm", $wasm)
Write-Host ("wrote add.wasm (" + $wasm.Length + " bytes)")

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtime  = "$PSScriptRoot\output\nova_runtime.c"
$cr = Invoke-Timed -FilePath $compiler -Arguments "wasm_test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o wasm_test.exe wasm_test.ll `"$runtime`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "wasm_test.exe")) { Write-Host "link failed"; exit 1 }
$rr = Invoke-Timed -FilePath "$PSScriptRoot\wasm_test.exe" -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "=== run exit=$($rr.ExitCode) ==="
Write-Host $rr.StdOut.TrimEnd()
if ($rr.StdErr.Trim()) { Write-Host "--- STDERR ---"; Write-Host $rr.StdErr.TrimEnd() }
Remove-Item "wasm_test.exe","wasm_test.ll","add.wasm" -Force -ErrorAction SilentlyContinue
if ($rr.ExitCode -ne 0 -or $rr.StdErr -match 'FAIL|mismatch|assert') { Write-Host "RESULT: FAIL"; exit 1 }
Write-Host "RESULT: PASS"
