Set-Location "$PSScriptRoot\..\test_programs"
. "$PSScriptRoot\..\test_programs\_proc_util.ps1"

$examples = @("01_hello", "02_data_processing", "04_crypto_web_token", "05_file_processor")
$pass = 0; $fail = 0

foreach ($ex in $examples) {
    $src = "$PSScriptRoot\$ex.nova"
    Write-Host "=== $ex ==="
    $cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "`"$src`"" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0) {
        Write-Host "  COMPILE FAIL: $($cr.StdOut | Select-Object -First 2)"
        $fail++
        continue
    }

    $llFile = "$PSScriptRoot\$ex.ll"
    if (!(Test-Path $llFile)) { Write-Host "  NO .ll"; $fail++; continue }

    Copy-Item "output\nova_runtime.c" "rt_tmp.c" -Force
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$ex.exe`" `"$llFile`" `"rt_tmp.c`" $NovaLinkFlags" -TimeoutMs 60000
    if (!(Test-Path "$ex.exe")) { Write-Host "  LINK FAIL"; Remove-Item $llFile -Force; $fail++; continue }

    # Run file_processor from examples dir so dir_walk is bounded
    $workDir = if ($ex -eq "05_file_processor") { $PSScriptRoot } else { (Get-Location).Path }
    $savedDir = Get-Location
    Set-Location $workDir
    $rr = Invoke-Timed -FilePath (Resolve-Path "$savedDir\$ex.exe").Path -Arguments "" -TimeoutMs 15000
    Set-Location $savedDir

    if ($rr.ExitCode -ne 0) {
        Write-Host "  RUN FAIL (exit=$($rr.ExitCode)):"
        Write-Host "  $($rr.StdOut | Select-Object -First 3)"
        $fail++
    } else {
        $lines = ($rr.StdOut -split "`n" | Select-Object -First 5)
        foreach ($l in $lines) { Write-Host "  $($l.Trim())" }
        Write-Host "  ... PASS"
        $pass++
    }
    Remove-Item "$llFile","$ex.exe","rt_tmp.c" -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Examples: $pass PASS, $fail FAIL"
