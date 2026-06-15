Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$tests = @(
    "bootstrap_10_match",
    "bootstrap_11_nested_struct",
    "struct_test",
    "auto_show_test",
    "from_json_test"
)

foreach ($t in $tests) {
    $file = "$t.nova"
    if (!(Test-Path "$PSScriptRoot\$file")) {
        Write-Host "SKIP $t (no file)"
        continue
    }
    Write-Host "=== $t ==="
    $cr = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments $file -TimeoutMs 30000
    Write-Host "exit=$($cr.ExitCode)"
    if ($cr.StdErr) {
        $errText = $cr.StdErr
        if ($errText.Length -gt 1500) { $errText = $errText.Substring(0, 1500) }
        Write-Host $errText
    }
    Write-Host ""
}
