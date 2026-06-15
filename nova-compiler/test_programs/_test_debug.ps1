Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== Compiling debug_demo.nova with NOVA_DBG=1 ==="
$env:NOVA_DBG = "1"
$c = Invoke-Timed -FilePath (Resolve-Path ".\nova.exe").Path -Arguments "compile debug_demo.nova" -TimeoutMs 30000
$env:NOVA_DBG = ""
Write-Host $c.Stdout
if ($c.Stderr.Length -gt 0) { Write-Host "STDERR: $($c.Stderr)" }
Write-Host "COMPILE EXIT=$($c.ExitCode)"
if ($c.ExitCode -ne 0) { exit 1 }

Write-Host ""
Write-Host "=== Linking ==="
& clang -o debug_demo.exe debug_demo.ll output\nova_runtime.o -lws2_32 -ladvapi32 -O0 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; exit 1 }
Write-Host "Link OK"

Write-Host ""
Write-Host "=== Verifying debug_demo.ll contains dbg_hook calls ==="
$hookCount = (Select-String -Path "debug_demo.ll" -Pattern "nova_rt_dbg_hook" | Measure-Object).Count
$pushCount = (Select-String -Path "debug_demo.ll" -Pattern "nova_rt_dbg_push_frame" | Measure-Object).Count
$popCount = (Select-String -Path "debug_demo.ll" -Pattern "nova_rt_dbg_pop_frame" | Measure-Object).Count
$enableCount = (Select-String -Path "debug_demo.ll" -Pattern "nova_rt_dbg_enable" | Measure-Object).Count
Write-Host "dbg_hook calls: $hookCount"
Write-Host "dbg_push_frame calls: $pushCount"
Write-Host "dbg_pop_frame calls: $popCount"
Write-Host "dbg_enable calls: $enableCount"

if ($hookCount -gt 0 -and $pushCount -gt 0 -and $popCount -gt 0 -and $enableCount -gt 0) {
    Write-Host ""
    Write-Host "SUCCESS: Debug auto-instrumentation is working!"
    Write-Host "The compiler auto-injected $hookCount hook calls, $pushCount push_frame, $popCount pop_frame"
} else {
    Write-Host ""
    Write-Host "ISSUE: Some instrumentation calls are missing"
}
