Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Hand-crafted module with 1 page of linear memory. See wasm_mem_test.nova.
# main(): store 10@0, store 20@4, return load(0) + load(4) = 30.
$wasm = [byte[]]@(
    0x00,0x61,0x73,0x6D, 0x01,0x00,0x00,0x00,            # magic + version
    0x01,0x05,0x01,0x60,0x00,0x01,0x7F,                  # type: () -> i32
    0x03,0x02,0x01,0x00,                                 # func: 1 func, type 0
    0x05,0x03,0x01,0x00,0x01,                            # memory: 1 mem, flags 0, min 1 page
    0x07,0x08,0x01,0x04,0x6D,0x61,0x69,0x6E,0x00,0x00,   # export "main" -> func 0
    0x0A,0x1D,0x01,0x1B,                                 # code: size 0x1D, 1 func, body 27
        0x00,                                            #  locals: 0
        0x41,0x00, 0x41,0x0A, 0x36,0x02,0x00,            #  store 10 @ mem[0]
        0x41,0x04, 0x41,0x14, 0x36,0x02,0x00,            #  store 20 @ mem[4]
        0x41,0x00, 0x28,0x02,0x00,                       #  load mem[0]
        0x41,0x04, 0x28,0x02,0x00,                       #  load mem[4]
        0x6A,                                            #  add
    0x0B                                                 # end
)
[System.IO.File]::WriteAllBytes("$PSScriptRoot\mem.wasm", $wasm)
Write-Host ("wrote mem.wasm (" + $wasm.Length + " bytes)")

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtime  = "$PSScriptRoot\output\nova_runtime.c"
$cr = Invoke-Timed -FilePath $compiler -Arguments "wasm_mem_test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o wasm_mem_test.exe wasm_mem_test.ll `"$runtime`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "wasm_mem_test.exe")) { Write-Host "link failed"; Write-Host $lr.StdErr; exit 1 }
$rr = Invoke-Timed -FilePath "$PSScriptRoot\wasm_mem_test.exe" -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "=== run exit=$($rr.ExitCode) ==="
Write-Host $rr.StdOut.TrimEnd()
if ($rr.StdErr.Trim()) { Write-Host "--- STDERR ---"; Write-Host $rr.StdErr.TrimEnd() }
Remove-Item "wasm_mem_test.exe","wasm_mem_test.ll","mem.wasm" -Force -ErrorAction SilentlyContinue
if ($rr.ExitCode -ne 0 -or $rr.StdErr -match 'FAIL|mismatch|assert') { Write-Host "RESULT: FAIL"; exit 1 }
Write-Host "RESULT: PASS"
