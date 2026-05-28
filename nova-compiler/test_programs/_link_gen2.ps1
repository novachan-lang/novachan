Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$r = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen2_new.exe nova_compiler.ll output\nova_runtime.c -lws2_32" -TimeoutMs 120000
Write-Host "Link exit: $($r.ExitCode) Timeout: $($r.TimedOut)"
if (Test-Path "gen2_new.exe") {
    $sz = (Get-Item "gen2_new.exe").Length
    Write-Host "gen2_new.exe size: $sz bytes"
    Copy-Item "gen2_new.exe" "gen2_move.exe" -Force
    Write-Host "Copied to gen2_move.exe"
} else {
    Write-Host "LINK FAILED"
    if ($r.StdErr) {
        $lines = $r.StdErr -split "`n" | Where-Object { $_ -notmatch "loop not (unrolled|vectorized)" -and $_ -notmatch "^\s*$" }
        foreach ($line in $lines) {
            Write-Host "  $line"
        }
    }
    exit 1
}
