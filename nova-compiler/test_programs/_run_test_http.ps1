Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "http_demo.nova" -TimeoutMs 60000
Write-Host "Compile exit: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host "Compile stdout:" ; Write-Host $cr.StdOut.Substring(0, [Math]::Min(3000, $cr.StdOut.Length)) }
if ($cr.StdErr) { Write-Host "Compile stderr:" ; Write-Host $cr.StdErr.Substring(0, [Math]::Min(3000, $cr.StdErr.Length)) }
if (!(Test-Path "http_demo.ll")) { Write-Host "FAIL: no .ll"; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o http_demo.exe http_demo.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode)"
if ($lr.StdErr) {
    $lines = $lr.StdErr -split "`n"
    $errors = $lines | Where-Object { $_ -match "error:" }
    if ($errors.Count -gt 0) {
        Write-Host "LINK ERRORS:"
        foreach ($e in $errors) { Write-Host $e.Trim() }
    }
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
