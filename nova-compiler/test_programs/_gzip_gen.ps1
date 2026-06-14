Set-Location $PSScriptRoot
# Generate a real DYNAMIC-Huffman gzip stream (via .NET GZipStream) to use as the
# oracle for NOVA's dynamic-Huffman inflate. Prints the BTYPE (want 2=dynamic) and the
# byte vector to embed in the deflatex self-test.
$plain = "The quick brown fox jumps over the lazy dog. " +
         "Pack my box with five dozen liquor jugs. " +
         "How vexingly quick daft zebras jump! " +
         "Sphinx of black quartz, judge my vow. " +
         "The five boxing wizards jump quickly. " +
         "Compression of varied English text forces a dynamic Huffman block."
$bytesIn = [System.Text.Encoding]::ASCII.GetBytes($plain)
$ms = New-Object System.IO.MemoryStream
$gz = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionLevel]::Optimal, $true)
$gz.Write($bytesIn, 0, $bytesIn.Length)
$gz.Close()
$out = $ms.ToArray()
# header FLG is byte 3; .NET writes FLG=0 -> body starts at byte 10
$flg = $out[3]
$bodyStart = 10
$btype = ($out[$bodyStart] -shr 1) -band 3
Write-Host ("plaintext len=" + $bytesIn.Length + "  gz len=" + $out.Length + "  FLG=" + $flg + "  BTYPE=" + $btype + " (2=dynamic)")
Write-Host "PLAINTEXT:"
Write-Host $plain
Write-Host "GZ_BYTES:"
Write-Host ([string]::Join(",", $out))
