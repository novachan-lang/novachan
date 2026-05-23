Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Adversarial input fuzz test. Each input should either:
#   - Compile successfully (exit 0), OR
#   - Emit a clean error message (exit 1, with error[ECODE]) and exit
# Anything else (crash, timeout, exit code other than 0/1, no output) = FAIL.

$corpus_dir = "$PSScriptRoot\fuzz_corpus"
$files = Get-ChildItem -Path $corpus_dir -Filter "*.nova" | Sort-Object Name

$pass = 0
$crash = 0
$timeout = 0
$dirty = 0  # non-clean error output

Write-Host "=== Fuzz: $($files.Count) inputs ==="
Write-Host ""

foreach ($f in $files) {
    $name = $f.BaseName
    $r = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "`"$($f.FullName)`"" -TimeoutMs 15000
    $status = "?"
    $detail = ""
    if ($r.TimedOut) {
        $status = "TIMEOUT"
        $timeout++
    } elseif ($r.ExitCode -eq 0) {
        $status = "OK"
        $pass++
    } elseif ($r.ExitCode -eq 1) {
        # Should be a clean error
        if ($r.StdOut -match "error\[E\d+\]") {
            $status = "CLEAN-ERR"
            $pass++
        } else {
            $status = "DIRTY-ERR"
            $dirty++
            $firstLine = ($r.StdOut -split "`n" | Select-Object -First 1).Trim()
            $detail = "  $firstLine"
        }
    } else {
        $status = "CRASH(exit=$($r.ExitCode))"
        $crash++
        $errFirst = ($r.StdErr -split "`n" | Select-Object -First 1).Trim()
        if ($errFirst) { $detail = "  STDERR: $errFirst" }
    }
    Write-Host ("{0,-12} {1}" -f $status, $name)
    if ($detail) { Write-Host $detail }
}

Write-Host ""
Write-Host "=== Summary ==="
Write-Host "Clean: $pass / $($files.Count)"
Write-Host "Dirty errors: $dirty"
Write-Host "Crashes: $crash"
Write-Host "Timeouts: $timeout"

# Cleanup any stray .ll files
Get-ChildItem -Path $corpus_dir -Filter "*.ll" -ErrorAction SilentlyContinue | Remove-Item -Force
