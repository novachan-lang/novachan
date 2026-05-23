Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$r = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen2_move.exe nova_compiler.ll nova_runtime.c -lws2_32" -TimeoutMs 120000
Write-Host "Link exit: $($r.ExitCode) Timeout: $($r.TimedOut)"
if ($r.StdErr) {
    $errLen = [Math]::Min(2000, $r.StdErr.Length)
    Write-Host "STDERR: $($r.StdErr.Substring(0, $errLen))"
}
if (Test-Path 'gen2_move.exe') {
    Write-Host "gen2_move.exe size: $((Get-Item gen2_move.exe).Length)"
} else {
    Write-Host 'NO EXE'
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
