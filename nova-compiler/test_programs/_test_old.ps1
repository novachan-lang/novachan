Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"

foreach ($t in @('trait_test','closure_test','generics_test')) {
    $nova = "$PSScriptRoot\$t.nova"
    $ll   = "$PSScriptRoot\$t.ll"
    $exe  = "$PSScriptRoot\$t.exe"
    if (!(Test-Path $nova)) { continue }
    Write-Host "=== $t (gen3_test.exe) ==="
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
    if ($cr.TimedOut -or $cr.ExitCode -ne 0) {
        Write-Host "FAIL compile (exit=$($cr.ExitCode))"
        if ($cr.StdOut) { Write-Host $cr.StdOut.Substring(0, [Math]::Min(300, $cr.StdOut.Length)) }
        continue
    }
    if (!(Test-Path $ll)) { Write-Host "no .ll"; continue }
    $linkArgs = "-O2 -o `"$exe`" `"$ll`" `"$runtimeSrc`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
    Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot | Out-Null
    if (!(Test-Path $exe)) { Write-Host "FAIL link"; Remove-Item $ll -Force -ErrorAction SilentlyContinue; continue }
    $rr = Invoke-Timed -FilePath $exe -Arguments '' -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
    Remove-Item $exe,$ll -Force -ErrorAction SilentlyContinue
    if ($rr.ExitCode -eq 0) { Write-Host "PASS" } else { Write-Host "FAIL run (exit=$($rr.ExitCode))" }
}
