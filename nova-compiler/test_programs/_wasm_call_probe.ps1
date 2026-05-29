Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Hand-crafted recursive factorial module (2 functions). See wasm_call_test.nova.
# func0 main() -> i32 : const 5, call 1
# func1 fac(n) -> i32 : recursive (if n<=1 then 1 else n*fac(n-1))
$wasm = [byte[]]@(
    0x00,0x61,0x73,0x6D, 0x01,0x00,0x00,0x00,                # magic + version
    0x01,0x0A,0x02, 0x60,0x00,0x01,0x7F, 0x60,0x01,0x7F,0x01,0x7F, # types: ()->i32 , (i32)->i32
    0x03,0x03,0x02,0x00,0x01,                                # funcs: f0:t0, f1:t1
    0x07,0x08,0x01,0x04,0x6D,0x61,0x69,0x6E,0x00,0x00,       # export "main" -> func 0
    0x0A,0x20,0x02,                                          # code: size 0x20, 2 funcs
        0x06, 0x00, 0x41,0x05, 0x10,0x01, 0x0B,              #  func0: const 5, call 1, end
        0x17, 0x00,                                          #  func1: body_size 23, locals 0
            0x20,0x00, 0x41,0x01, 0x4C,                      #   n <= 1
            0x04,0x7F,                                       #   if (result i32)
                0x41,0x01,                                   #     1
            0x05,                                            #   else
                0x20,0x00, 0x20,0x00, 0x41,0x01, 0x6B,       #     n, n-1
                0x10,0x01, 0x6C,                             #     fac(n-1), n*..
            0x0B,                                            #   end if
        0x0B                                                 #  end func
)
[System.IO.File]::WriteAllBytes("$PSScriptRoot\fac.wasm", $wasm)
Write-Host ("wrote fac.wasm (" + $wasm.Length + " bytes)")

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtime  = "$PSScriptRoot\output\nova_runtime.c"
$cr = Invoke-Timed -FilePath $compiler -Arguments "wasm_call_test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o wasm_call_test.exe wasm_call_test.ll `"$runtime`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "wasm_call_test.exe")) { Write-Host "link failed"; Write-Host $lr.StdErr; exit 1 }
$rr = Invoke-Timed -FilePath "$PSScriptRoot\wasm_call_test.exe" -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "=== run exit=$($rr.ExitCode) ==="
Write-Host $rr.StdOut.TrimEnd()
if ($rr.StdErr.Trim()) { Write-Host "--- STDERR ---"; Write-Host $rr.StdErr.TrimEnd() }
Remove-Item "wasm_call_test.exe","wasm_call_test.ll","fac.wasm" -Force -ErrorAction SilentlyContinue
if ($rr.ExitCode -ne 0 -or $rr.StdErr -match 'FAIL|mismatch|assert') { Write-Host "RESULT: FAIL"; exit 1 }
Write-Host "RESULT: PASS"
