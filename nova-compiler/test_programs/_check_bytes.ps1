$path = "$PSScriptRoot\_comp_range_test.nova"
$bytes = [System.IO.File]::ReadAllBytes($path)
$lines = (Get-Content $path)
for ($i = 0; $i -lt [Math]::Min($lines.Count, 5); $i++) {
    $line = $lines[$i]
    $hasTab = $line.Contains("`t")
    Write-Host "Line $($i+1): hasTab=$hasTab len=$($line.Length) [$line]"
}
Write-Host "First 100 bytes:"
Write-Host ($bytes[0..99] -join ",")
