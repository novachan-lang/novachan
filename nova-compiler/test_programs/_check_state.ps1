Set-Location $PSScriptRoot
Write-Host "=== File timestamps ==="
if (Test-Path gen3_test.exe) { Write-Host "gen3_test.exe: $((Get-Item gen3_test.exe).LastWriteTime)" }
if (Test-Path gen4_test.exe) { Write-Host "gen4_test.exe: $((Get-Item gen4_test.exe).LastWriteTime)" }
if (Test-Path memo_test.exe) { Write-Host "memo_test.exe: $((Get-Item memo_test.exe).LastWriteTime)" }
if (Test-Path memo_test.ll) { Write-Host "memo_test.ll:  $((Get-Item memo_test.ll).LastWriteTime)" } else { Write-Host "memo_test.ll:  DOES NOT EXIST" }
if (Test-Path nova_compiler.ll) { Write-Host "nova_compiler.ll: $((Get-Item nova_compiler.ll).LastWriteTime)" }
Write-Host ""
Write-Host "=== nova_compiler.nova size ==="
Write-Host "$((Get-Item nova_compiler.nova).Length) bytes"
Write-Host ""
Write-Host "=== Verify __memo_cache wired in compiler ==="
$content = Get-Content nova_compiler.nova -Raw
if ($content -match '__memo_cache') { Write-Host "FOUND __memo_cache in source" } else { Write-Host "MISSING __memo_cache!" }
if ($content -match 'nova_rt_memo_cache') { Write-Host "FOUND nova_rt_memo_cache mapping" } else { Write-Host "MISSING nova_rt_memo_cache mapping!" }
Write-Host ""
Write-Host "=== Verify runtime has memo_cache ==="
$rt = Get-Content output/nova_runtime.c -Raw
if ($rt -match 'nova_rt_memo_cache') { Write-Host "FOUND nova_rt_memo_cache in runtime" } else { Write-Host "MISSING from runtime!" }
