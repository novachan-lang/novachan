$root = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
$jar = "$root\build\libs\nova-compiler-0.1.0-all.jar"
$src = "$root\bench\test_json_io.nova"
$out = "$root\bench\test_json_io.ll"
$exe = "$root\bench\test_json_io.exe"
$rt  = "$root\runtime\nova_runtime.c"

Write-Host "Compiling NOVA..."
$result = & java -jar $jar $src $out 2>&1
if ($LASTEXITCODE -ne 0) { Write-Host "NOVA compile FAILED: $result"; exit 1 }
Write-Host "  -> IR generated"

Write-Host "Linking..."
$link = & clang -O1 -o $exe $out $rt 2>&1
if ($LASTEXITCODE -ne 0) { Write-Host "clang FAILED: $link"; exit 1 }
Write-Host "  -> exe linked"

Write-Host "Running..."
Push-Location $root\bench
$output = & $exe 2>&1
Write-Host $output
Pop-Location
