$file = "$PSScriptRoot\..\..\NOVA_DESIGN\REMAINING_FEATURES.md"
$lines = Get-Content $file
for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ($line -match '^\- \*\*status') {
        if ($line -notmatch 'DONE' -and $line -notmatch 'DROPPED') {
            $ln = $i + 1
            $sec = ""
            for ($j = $i - 1; $j -ge 0; $j--) {
                if ($lines[$j] -match '^###') { $sec = $lines[$j].Substring(0, [Math]::Min(80, $lines[$j].Length)); break }
            }
            Write-Host "${ln}: $sec"
        }
    }
}
