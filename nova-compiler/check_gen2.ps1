Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
$gen2path = "test_programs/nova_compiler.ll"
if (Test-Path $gen2path) {
    $content = Get-Content $gen2path
    $lineCount = $content.Length
    Write-Output "gen2 IR: $lineCount lines"
    Copy-Item $gen2path gen2.ll -Force
    Write-Output "Saved as gen2.ll"
} else {
    Write-Output "NOT FOUND: $gen2path"
}
