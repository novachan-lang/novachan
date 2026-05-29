Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Hand-crafted WASM module with a real loop (sum 1..10 -> 55). See wasm_loop_test.nova.
# body (38 bytes): locals[2 i32] then the loop program; code section size = 0x28 (40).
$wasm = [byte[]]@(
    0x00,0x61,0x73,0x6D, 0x01,0x00,0x00,0x00,            # magic + version
    0x01,0x05,0x01,0x60,0x00,0x01,0x7F,                  # type: () -> i32
    0x03,0x02,0x01,0x00,                                 # func: 1 func, type 0
    0x07,0x08,0x01,0x04,0x6D,0x61,0x69,0x6E,0x00,0x00,   # export "main" -> func 0
    0x0A,0x28,0x01,0x26,                                 # code: 1 func, body_size=38
        0x01,0x02,0x7F,                                  #  locals: 2 x i32
        0x41,0x00, 0x21,0x01,                            #  acc(local1)=0
        0x41,0x01, 0x21,0x00,                            #  i(local0)=1
        0x03,0x40,                                       #  loop (void)
            0x20,0x01, 0x20,0x00, 0x6A, 0x21,0x01,       #   acc += i
            0x20,0x00, 0x41,0x01, 0x6A, 0x21,0x00,       #   i += 1
            0x20,0x00, 0x41,0x0B, 0x48,                  #   i < 11
            0x0D,0x00,                                   #   br_if 0
        0x0B,                                            #  end loop
        0x20,0x01,                                       #  push acc
    0x0B                                                 # end func
)
[System.IO.File]::WriteAllBytes("$PSScriptRoot\loop.wasm", $wasm)
Write-Host ("wrote loop.wasm (" + $wasm.Length + " bytes)")

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtime  = "$PSScriptRoot\output\nova_runtime.c"
$cr = Invoke-Timed -FilePath $compiler -Arguments "wasm_loop_test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o wasm_loop_test.exe wasm_loop_test.ll `"$runtime`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "wasm_loop_test.exe")) { Write-Host "link failed"; Write-Host $lr.StdErr; exit 1 }
$rr = Invoke-Timed -FilePath "$PSScriptRoot\wasm_loop_test.exe" -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "=== run exit=$($rr.ExitCode) ==="
Write-Host $rr.StdOut.TrimEnd()
if ($rr.StdErr.Trim()) { Write-Host "--- STDERR ---"; Write-Host $rr.StdErr.TrimEnd() }
Remove-Item "wasm_loop_test.exe","wasm_loop_test.ll","loop.wasm" -Force -ErrorAction SilentlyContinue
if ($rr.ExitCode -ne 0 -or $rr.StdErr -match 'FAIL|mismatch|assert') { Write-Host "RESULT: FAIL"; exit 1 }
Write-Host "RESULT: PASS"
