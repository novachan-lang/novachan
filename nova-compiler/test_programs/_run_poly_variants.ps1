Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

foreach ($f in @("poly_one_call")) {
    Write-Host "=== $f ==="
    $cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "$f.nova" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL"; continue }
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $f.exe $f.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (!(Test-Path "$f.exe")) { Write-Host "LINK FAIL"; continue }
    $rr = Invoke-Timed -FilePath (Resolve-Path ".\$f.exe").Path -Arguments "" -TimeoutMs 10000
    if ($rr.ExitCode -ne 0) {
        Write-Host "FAIL (exit=$($rr.ExitCode))"
        if ($rr.StdOut) { Write-Host "  stdout: $($rr.StdOut.Trim())" }
        if ($rr.StdErr) { Write-Host "  stderr: $($rr.StdErr.Substring(0, [Math]::Min(200, $rr.StdErr.Length)))" }
    } else {
        Write-Host "PASS: $($rr.StdOut.Trim())"
    }
    # Check what str() became
    $ir_str_call = Select-String -Path "$f.ll" -Pattern "int_to_str|any_to_str" | ForEach-Object { $_.Line.Trim() }
    Write-Host "  str() in IR: $ir_str_call"
    Remove-Item "$f.ll","$f.exe" -Force -ErrorAction SilentlyContinue
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
