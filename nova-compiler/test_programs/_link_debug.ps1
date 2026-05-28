Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen2_new.exe nova_compiler.ll output\nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
Write-Host "Exit: $($lr.ExitCode)"
if ($lr.StdErr) {
    $errs = $lr.StdErr -split "`n" | Where-Object { $_ -match "error:" } | Select-Object -First 10
    foreach ($e in $errs) { Write-Host $e }
}
