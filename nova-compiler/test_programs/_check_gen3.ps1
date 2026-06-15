$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen3_test.exe" -ArgumentList "nova_compiler.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_chk_err.txt" -RedirectStandardOutput "$dir\_chk_out.txt"
if (-not $p.WaitForExit(450000)) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
Write-Host "exit=$($p.ExitCode)"
Get-Content "$dir\_chk_out.txt"
Get-Content "$dir\_chk_err.txt" | Select-Object -First 5
if (Test-Path "$dir\nova_compiler.ll") {
    $s = Select-String -Path "$dir\nova_compiler.ll" -Pattern "_dpow" -SimpleMatch
    if ($s) { Write-Host "FOUND _dpow in .ll:"; $s | Select-Object -First 5 }
    else { Write-Host "NO _dpow in .ll" }
    $s2 = Select-String -Path "$dir\nova_compiler.ll" -Pattern "parse_program" -SimpleMatch
    if ($s2) { Write-Host "FOUND parse_program in .ll:"; $s2 | Select-Object -First 3 }
    else { Write-Host "NO parse_program in .ll" }
} else {
    Write-Host "nova_compiler.ll NOT GENERATED"
}
