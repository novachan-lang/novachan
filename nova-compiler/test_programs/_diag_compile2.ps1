Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$tests = @(
    "bootstrap_10_match",
    "struct_test",
    "auto_show_test"
)

foreach ($t in $tests) {
    $file = "$t.nova"
    Write-Host "=== $t ==="
    $cr = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments $file -TimeoutMs 30000
    Write-Host "exit=$($cr.ExitCode)"
    if ($cr.StdOut) {
        $outText = $cr.StdOut
        if ($outText.Length -gt 2000) { $outText = $outText.Substring(0, 2000) }
        Write-Host "STDOUT: $outText"
    }
    if ($cr.StdErr) {
        $errText = $cr.StdErr
        if ($errText.Length -gt 2000) { $errText = $errText.Substring(0, 2000) }
        Write-Host "STDERR: $errText"
    }
    Write-Host ""
}
