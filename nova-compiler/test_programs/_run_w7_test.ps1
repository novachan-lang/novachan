Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== Test 1: Compile WITHOUT NOVA_AUTO_ARENA (baseline) ==="
$env:NOVA_AUTO_ARENA = $null
Remove-Item -Force "$PSScriptRoot\t8_w7_test.ll" -ErrorAction SilentlyContinue
$r1 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "t8_w7_test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "compile EXIT=$($r1.ExitCode)"
$baseline_has_call = (Get-Content "$PSScriptRoot\t8_w7_test.ll" | Select-String -Pattern "call void @nova_rt_set_arena_mode").Count
Write-Host "baseline arena CALL count: $baseline_has_call [expect 0]"

Write-Host ""
Write-Host "=== Test 2: Compile WITH NOVA_AUTO_ARENA=1 ==="
$env:NOVA_AUTO_ARENA = "1"
Remove-Item -Force "$PSScriptRoot\t8_w7_test.ll" -ErrorAction SilentlyContinue
$r2 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "t8_w7_test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "compile EXIT=$($r2.ExitCode)"
$auto_has_call = (Get-Content "$PSScriptRoot\t8_w7_test.ll" | Select-String -Pattern "call void @nova_rt_set_arena_mode").Count
Write-Host "auto arena CALL count: $auto_has_call [expect 1]"
$auto_comment = (Get-Content "$PSScriptRoot\t8_w7_test.ll" | Select-String -Pattern "AUTO-ARENA").Count
Write-Host "auto AUTO-ARENA comment: $auto_comment [expect 1]"

Write-Host ""
Write-Host "=== Test 3: Link and run auto-arena version ==="
$r3 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o t8_w7_test.exe t8_w7_test.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "link EXIT=$($r3.ExitCode)"
$r4 = Invoke-Timed -FilePath "$PSScriptRoot\t8_w7_test.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "run EXIT=$($r4.ExitCode)"
Write-Host "stdout:"
Write-Host $r4.StdOut

Write-Host ""
Write-Host "=== Test 4: Spawn program must NOT auto-arena ==="
Remove-Item -Force "$PSScriptRoot\spawn_test.ll" -ErrorAction SilentlyContinue
$env:NOVA_AUTO_ARENA = "1"
$r5 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "spawn_test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "compile EXIT=$($r5.ExitCode)"
$spawn_arena_call = (Get-Content "$PSScriptRoot\spawn_test.ll" | Select-String -Pattern "call void @nova_rt_set_arena_mode").Count
Write-Host "spawn_test arena CALL count: $spawn_arena_call [expect 0 because program has spawn]"

$env:NOVA_AUTO_ARENA = $null
Remove-Item -Force "$PSScriptRoot\t8_w7_test.ll","$PSScriptRoot\t8_w7_test.exe","$PSScriptRoot\spawn_test.ll" -ErrorAction SilentlyContinue
