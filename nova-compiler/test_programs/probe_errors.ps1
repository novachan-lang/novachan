Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$progs = @("err_syntax", "err_undef", "err_type", "err_garbage", "err_listarg", "err_return", "err_match", "err_generic", "err_catch")
foreach ($p in $progs) {
    Write-Host "======== $p.nova ========"
    if (Test-Path "$p.ll") { Remove-Item "$p.ll" -Force -ErrorAction SilentlyContinue }
    $r = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "$p.nova" -TimeoutMs 30000
    Write-Host "  exit=$($r.ExitCode)  timedout=$($r.TimedOut)  ll_produced=$(Test-Path "$p.ll")"
    Write-Host "  --- STDOUT ---"
    Write-Host $r.StdOut
    if ($r.StdErr) { Write-Host "  --- STDERR ---"; Write-Host $r.StdErr }
    Write-Host ""
    if (Test-Path "$p.ll") { Remove-Item "$p.ll" -Force -ErrorAction SilentlyContinue }
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
