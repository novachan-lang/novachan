$lines = Get-Content "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\nova_compiler.nova"
$i = 0
foreach ($line in $lines) {
    $i++
    if ($line -match '== "\{"|== "{"') {
        $trimmed = $line.TrimStart()
        if ($trimmed.Length -gt 120) { $trimmed = $trimmed.Substring(0, 120) }
        Write-Host "${i}: $trimmed"
    }
}
