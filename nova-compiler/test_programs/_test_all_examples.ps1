Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$examples = @("01_hello", "02_data_processing", "04_crypto_web_token", "05_file_processor")
$pass = 0; $fail = 0

foreach ($ex in $examples) {
    $src = "$PSScriptRoot\..\examples\$ex.nova"
    Write-Host "=== $ex ==="
    $cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "`"$src`"" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0) {
        Write-Host "  COMPILE FAIL (exit=$($cr.ExitCode)):"
        $cr.StdOut | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" }
        $fail++
        continue
    }

    $llFile = "$PSScriptRoot\..\examples\$ex.ll"
    if (!(Test-Path $llFile)) { Write-Host "  NO .ll produced"; $fail++; continue }

    Copy-Item "$PSScriptRoot\output\nova_runtime.c" "$PSScriptRoot\rt_tmp.c" -Force
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$PSScriptRoot\$ex.exe`" `"$llFile`" `"$PSScriptRoot\rt_tmp.c`" $NovaLinkFlags" -TimeoutMs 60000
    if (!(Test-Path "$PSScriptRoot\$ex.exe")) {
        Write-Host "  LINK FAIL:"
        if ($lr.StdOut) { $lr.StdOut | Select-Object -First 3 | ForEach-Object { Write-Host "  $_" } }
        if ($lr.StdErr) { $lr.StdErr | Select-Object -First 3 | ForEach-Object { Write-Host "  $_" } }
        $fail++
        Remove-Item $llFile -Force -ErrorAction SilentlyContinue
        continue
    }

    $exeFullPath = (Resolve-Path "$PSScriptRoot\$ex.exe").Path
    $workDir = if ($ex -eq "05_file_processor") { "$PSScriptRoot\..\examples" } else { $PSScriptRoot }
    $savedDir = Get-Location
    Set-Location $workDir
    $rr = Invoke-Timed -FilePath $exeFullPath -Arguments "" -TimeoutMs 15000
    Set-Location $savedDir
    if ($rr.ExitCode -ne 0) {
        Write-Host "  RUN FAIL (exit=$($rr.ExitCode)):"
        $rr.StdOut | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" }
        $fail++
    } else {
        $lines = $rr.StdOut -split "`n" | Select-Object -First 8
        foreach ($l in $lines) { Write-Host "  $($l.Trim())" }
        Write-Host "  ... PASS"
        $pass++
    }
    Remove-Item $llFile,"$PSScriptRoot\$ex.exe" -Force -ErrorAction SilentlyContinue
}

Remove-Item "$PSScriptRoot\rt_tmp.c" -Force -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "Examples: $pass PASS, $fail FAIL"
