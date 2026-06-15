$file = "$PSScriptRoot\..\..\NOVA_DESIGN\REMAINING_FEATURES.md"
$lines = Get-Content $file
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match 'PARTIAL' -and $lines[$i] -match 'status:') {
        $ln = $i + 1
        $t = $lines[$i].Substring(0, [Math]::Min(150, $lines[$i].Length))
        Write-Host "${ln}: $t"
    }
}
