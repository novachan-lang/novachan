$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"

Write-Host "=== Compiling with gen5 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen5.exe" -ArgumentList "nova_compiler.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_d_err.txt" -RedirectStandardOutput "$dir\_d_out.txt"
$ok = $p.WaitForExit(450000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT gen5"; exit 1 }
if (Test-Path "$dir\nova_compiler.ll") {
    Copy-Item "$dir\nova_compiler.ll" "$dir\_gen5_output.ll" -Force
    Write-Host "gen5 output saved: $((Get-Item "$dir\_gen5_output.ll").Length) bytes"
} else {
    Write-Host "gen5 FAILED to compile"
    exit 1
}

Write-Host "=== Compiling with gen6 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$p2 = Start-Process -FilePath "$dir\gen6.exe" -ArgumentList "nova_compiler.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_d_err.txt" -RedirectStandardOutput "$dir\_d_out.txt"
$ok2 = $p2.WaitForExit(450000)
if (-not $ok2) { $p2.Kill(); Write-Host "TIMEOUT gen6"; exit 1 }
if (Test-Path "$dir\nova_compiler.ll") {
    Copy-Item "$dir\nova_compiler.ll" "$dir\_gen6_output.ll" -Force
    Write-Host "gen6 output saved: $((Get-Item "$dir\_gen6_output.ll").Length) bytes"
} else {
    Write-Host "gen6 FAILED to compile"
    exit 1
}

$h5 = (Get-FileHash "$dir\_gen5_output.ll" -Algorithm SHA256).Hash
$h6 = (Get-FileHash "$dir\_gen6_output.ll" -Algorithm SHA256).Hash
Write-Host "gen5 LL hash: $h5"
Write-Host "gen6 LL hash: $h6"
if ($h5 -eq $h6) {
    Write-Host "LL FILES MATCH"
} else {
    Write-Host "LL FILES DIFFER"
    $l5 = Get-Content "$dir\_gen5_output.ll"
    $l6 = Get-Content "$dir\_gen6_output.ll"
    Write-Host "gen5 lines: $($l5.Count), gen6 lines: $($l6.Count)"
    $diffCount = 0
    $maxLine = [Math]::Max($l5.Count, $l6.Count)
    for ($i = 0; $i -lt $maxLine -and $diffCount -lt 10; $i++) {
        $a = if ($i -lt $l5.Count) { $l5[$i] } else { "<MISSING>" }
        $b = if ($i -lt $l6.Count) { $l6[$i] } else { "<MISSING>" }
        if ($a -ne $b) {
            Write-Host "DIFF at line $($i+1):"
            Write-Host "  gen5: $a"
            Write-Host "  gen6: $b"
            $diffCount++
        }
    }
}
