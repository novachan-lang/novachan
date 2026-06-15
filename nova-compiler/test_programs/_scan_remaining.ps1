$c = Get-Content "$PSScriptRoot\..\..\NOVA_DESIGN\REMAINING_FEATURES.md" -Raw
$partial = [regex]::Matches($c, '(?m)status:\*\*\s*PARTIAL')
$missing = [regex]::Matches($c, '(?m)status:\*\*\s*MISSING')
Write-Host "PARTIAL: $($partial.Count)"
Write-Host "MISSING: $($missing.Count)"

# Find them
$lines = Get-Content "$PSScriptRoot\..\..\NOVA_DESIGN\REMAINING_FEATURES.md"
$section = ""
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^### (.+)') { $section = $Matches[1] }
    if ($lines[$i] -match 'status:\*\*\s*(PARTIAL|MISSING)') {
        Write-Host "$($Matches[1]): $section"
    }
}
