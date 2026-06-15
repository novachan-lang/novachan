# iter-90 arena harness: validate transparent arena (struct + cycle) non-ASAN + ASAN.
param([switch]$AsanOnly)
$dir = $PSScriptRoot
$CLANG = "C:\Program Files\LLVM\bin\clang.exe"
if (-not $AsanOnly) {
  & $CLANG -O2 -o "$dir\_arena_harness.exe" "$dir\_arena_harness.c" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
  & "$dir\_arena_harness.exe"; Write-Host "  (non-ASAN exit=$LASTEXITCODE)"
  Remove-Item "$dir\_arena_harness.exe" -Force -ErrorAction SilentlyContinue
}
& $CLANG -fsanitize=address -g -O1 -o "$dir\_arena_harness_asan.exe" "$dir\_arena_harness.c" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$env:ASAN_OPTIONS = "abort_on_error=0"
# Capture STDERR separately: real ASAN findings print to stderr, so a benign
# success message on stdout can never false-positive the check.
& "$dir\_arena_harness_asan.exe" 1>"$dir\_arena_aout.txt" 2>"$dir\_arena_aerr.txt"
$ec = $LASTEXITCODE
$err = Get-Content "$dir\_arena_aerr.txt" -Raw -ErrorAction SilentlyContinue
if ($err -and ($err -match "ERROR: AddressSanitizer|heap-use-after-free|attempting double-free|heap-buffer-overflow")) {
  Write-Host "  ARENA ASAN *** FINDING ***"; Write-Host $err
} else { Write-Host "  ARENA ASAN clean (exit=$ec)" }
Remove-Item "$dir\_arena_harness_asan.exe","$dir\_arena_aout.txt","$dir\_arena_aerr.txt" -Force -ErrorAction SilentlyContinue
