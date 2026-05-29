Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Hand-crafted minimal valid GGUF v3 file (little-endian): header + 1 metadata KV
# (answer:uint32=42) + 1 tensor info (name "w", 1 dim [3], type F32). See gguf_test.nova.
$g = [byte[]]@(
    0x47,0x47,0x55,0x46,                              # magic "GGUF"
    0x03,0x00,0x00,0x00,                              # version 3
    0x01,0,0,0,0,0,0,0,                               # tensor_count = 1 (u64)
    0x01,0,0,0,0,0,0,0,                               # metadata_kv_count = 1 (u64)
    0x06,0,0,0,0,0,0,0, 0x61,0x6e,0x73,0x77,0x65,0x72,# key "answer" (len 6 + bytes)
    0x04,0x00,0x00,0x00,                              # value_type = 4 (UINT32)
    0x2a,0x00,0x00,0x00,                              # value = 42
    0x01,0,0,0,0,0,0,0, 0x77,                         # tensor name "w" (len 1 + 'w')
    0x01,0x00,0x00,0x00,                              # n_dims = 1
    0x03,0,0,0,0,0,0,0,                               # dims[0] = 3 (u64)
    0x00,0x00,0x00,0x00,                              # type = 0 (F32)
    0x00,0,0,0,0,0,0,0                                # offset = 0 (u64)
)
[System.IO.File]::WriteAllBytes("$PSScriptRoot\test.gguf", $g)
Write-Host ("wrote test.gguf (" + $g.Length + " bytes)")

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "gguf_test.nova" -TimeoutMs 60000
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gguf_test.exe gguf_test.ll output/nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000
if (!(Test-Path "gguf_test.exe")) { Write-Host "link failed"; Write-Host $lr.StdErr; exit 1 }
$rr = Invoke-Timed -FilePath (Resolve-Path ".\gguf_test.exe").Path -Arguments "" -TimeoutMs 15000
Write-Host $rr.StdOut.Trim()
if ($rr.StdErr.Trim()) { Write-Host "STDERR:"; Write-Host $rr.StdErr.Trim() }
Remove-Item "gguf_test.exe","gguf_test.ll","test.gguf" -Force -ErrorAction SilentlyContinue
if ($rr.ExitCode -ne 0 -or $rr.StdErr -match 'FAIL|assert') { Write-Host "RESULT: FAIL"; exit 1 }
Write-Host "RESULT: PASS"
