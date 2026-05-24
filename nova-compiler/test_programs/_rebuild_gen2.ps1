Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== Compile nova_compiler.nova ==="
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 240000
Write-Host "Compile exit: $($cr.ExitCode)"
if ($cr.ExitCode -ne 0) {
    Write-Host "STDOUT: $($cr.StdOut)"
    if ($cr.StdErr) { Write-Host "STDERR: $($cr.StdErr)" }
    exit 1
}

Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
Write-Host "=== Link ==="
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen2_new.exe nova_compiler.ll nova_runtime.c -lws2_32" -TimeoutMs 240000
Write-Host "Link exit: $($lr.ExitCode)"
if (!(Test-Path "gen2_new.exe")) {
    Write-Host "Link failed"
    if ($lr.StdErr) {
        $errs = $lr.StdErr -split "`n" | Where-Object { $_ -match "error" } | Select-Object -Last 10
        foreach ($l in $errs) { Write-Host "  $l" }
    }
    exit 1
}

Copy-Item "gen2_new.exe" "gen2_move.exe" -Force
Remove-Item "gen2_new.exe","nova_compiler.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
Write-Host "gen2_move.exe updated ($((Get-Item gen2_move.exe).Length) bytes)"
