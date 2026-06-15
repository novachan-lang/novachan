$text = Get-Content "$PSScriptRoot\..\..\NOVA_DESIGN\REMAINING_FEATURES.md" -Raw
$sections = $text -split '(?m)(?=^### )'
foreach ($sec in $sections) {
    if ($sec -match '^### (.+)') {
        $title = $Matches[1]
        $chunk = $sec.Substring(0, [Math]::Min(500, $sec.Length))
        if ($chunk -notmatch 'DONE|DROPPED|DEFERRED') {
            Write-Host $title
        }
    }
}
