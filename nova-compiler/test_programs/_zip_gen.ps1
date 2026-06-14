Set-Location $PSScriptRoot
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
# Generate a real .zip (2 entries) via .NET ZipArchive as the oracle for zipx.nova.
# story.txt is long+varied -> forces DEFLATE (method 8); hello.txt is short.
$hello = "Hello, ZIP world!"
$story = "The quick brown fox jumps over the lazy dog. Pack my box with five dozen liquor jugs. " +
         "How vexingly quick daft zebras jump! Sphinx of black quartz, judge my vow. " +
         "The five boxing wizards jump quickly. NOVA reads ZIP archives now."
$ms = New-Object System.IO.MemoryStream
$zip = New-Object System.IO.Compression.ZipArchive($ms, [System.IO.Compression.ZipArchiveMode]::Create, $true)
function AddEntry($z, $name, $text) {
    $e = $z.CreateEntry($name, [System.IO.Compression.CompressionLevel]::Optimal)
    $w = New-Object System.IO.StreamWriter($e.Open())
    $w.Write($text); $w.Close()
}
AddEntry $zip "hello.txt" $hello
AddEntry $zip "story.txt" $story
$zip.Dispose()
$out = $ms.ToArray()
Write-Host ("zip len=" + $out.Length)
Write-Host "HELLO_TXT:"
Write-Host $hello
Write-Host "STORY_TXT:"
Write-Host $story
Write-Host "ZIP_BYTES:"
Write-Host ([string]::Join(",", $out))
