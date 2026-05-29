Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# i64.wasm: main()->i64 = 1000000 * 1000000 (i64.const sleb of 1000000 = C0 84 3D)
$i64 = [byte[]]@(
    0x00,0x61,0x73,0x6D, 0x01,0x00,0x00,0x00,
    0x01,0x05,0x01,0x60,0x00,0x01,0x7E,                  # type ()->i64
    0x03,0x02,0x01,0x00,
    0x07,0x08,0x01,0x04,0x6D,0x61,0x69,0x6E,0x00,0x00,
    0x0A,0x0D,0x01,0x0B,                                 # code size 0x0D, body 0x0B(11)
        0x00,
        0x42,0xC0,0x84,0x3D,                             #  i64.const 1000000
        0x42,0xC0,0x84,0x3D,                             #  i64.const 1000000
        0x7E,                                            #  i64.mul
    0x0B
)
[System.IO.File]::WriteAllBytes("$PSScriptRoot\i64.wasm", $i64)

# f64.wasm: main()->i32 = trunc(3.5 + 1.5) = 5  (3.5=...0C40 LE, 1.5=...F83F LE)
$f64 = [byte[]]@(
    0x00,0x61,0x73,0x6D, 0x01,0x00,0x00,0x00,
    0x01,0x05,0x01,0x60,0x00,0x01,0x7F,                  # type ()->i32
    0x03,0x02,0x01,0x00,
    0x07,0x08,0x01,0x04,0x6D,0x61,0x69,0x6E,0x00,0x00,
    0x0A,0x18,0x01,0x16,                                 # code size 0x18, body 0x16(22)
        0x00,
        0x44,0x00,0x00,0x00,0x00,0x00,0x00,0x0C,0x40,    #  f64.const 3.5
        0x44,0x00,0x00,0x00,0x00,0x00,0x00,0xF8,0x3F,    #  f64.const 1.5
        0xA0,                                            #  f64.add
        0xAA,                                            #  i32.trunc_f64_s
    0x0B
)
[System.IO.File]::WriteAllBytes("$PSScriptRoot\f64.wasm", $f64)
Write-Host ("wrote i64.wasm (" + $i64.Length + ") + f64.wasm (" + $f64.Length + ")")

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtime  = "$PSScriptRoot\output\nova_runtime.c"
$cr = Invoke-Timed -FilePath $compiler -Arguments "wasm_num_test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o wasm_num_test.exe wasm_num_test.ll `"$runtime`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "wasm_num_test.exe")) { Write-Host "link failed"; Write-Host $lr.StdErr; exit 1 }
$rr = Invoke-Timed -FilePath "$PSScriptRoot\wasm_num_test.exe" -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "=== run exit=$($rr.ExitCode) ==="
Write-Host $rr.StdOut.TrimEnd()
if ($rr.StdErr.Trim()) { Write-Host "--- STDERR ---"; Write-Host $rr.StdErr.TrimEnd() }
Remove-Item "wasm_num_test.exe","wasm_num_test.ll","i64.wasm","f64.wasm" -Force -ErrorAction SilentlyContinue
if ($rr.ExitCode -ne 0 -or $rr.StdErr -match 'FAIL|mismatch|assert') { Write-Host "RESULT: FAIL"; exit 1 }
Write-Host "RESULT: PASS"
