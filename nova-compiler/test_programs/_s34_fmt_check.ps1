# #34 AST-reprint formatter gate: reprint is canonical, faithful (still compiles), idempotent,
# preserves comments IN PLACE, and falls back to the whitespace normalizer on unsupported code.
$ErrorActionPreference = "Continue"
function RunGet($exe, $a, $f) {
  $o = "$env:TEMP\s34o.txt"
  $p = Start-Process -FilePath (Resolve-Path $exe).Path -ArgumentList ($a + @($f)) -PassThru -NoNewWindow -RedirectStandardOutput $o -Wait
  return (Get-Content $o -Raw)
}
Remove-Item _t34v.nova,_t34v.ll,_t34fb.nova -ErrorAction SilentlyContinue
Copy-Item _s34_valid.nova _t34v.nova
# 1. format -> must use the AST path (not fallback)
$r1 = RunGet ".\gen3_test.exe" @("fmt") "_t34v.nova"
if ($r1 -notmatch "Formatted \(AST\)") { Write-Host "FAIL #34: AST path did not trigger on valid input: $r1"; exit 1 }
$after1 = Get-Content _t34v.nova -Raw
# 2. canonical reprint check (operator spacing normalized)
if ($after1 -notmatch "return n \* n") { Write-Host "FAIL #34: not canonicalized (expected 'return n \* n')"; exit 1 }
if ($after1 -notmatch "while i <= 5")  { Write-Host "FAIL #34: not canonicalized (expected 'while i <= 5')"; exit 1 }
# 3. comment preserved IN PLACE: '// accumulate squares' must be immediately before the while (indented), not at EOF
if ($after1 -notmatch "(?m)^    // accumulate squares\r?\n    while ") { Write-Host "FAIL #34: body comment not interleaved in place:`n$after1"; exit 1 }
# 4. faithfulness: formatted file still type-checks (no code loss)
$env:NOVA_NO_CACHE = "1"
$chk = RunGet ".\gen3_test.exe" @("check") "_t34v.nova"
if ($chk -match "type-check failed|parse error|error\[") { Write-Host "FAIL #34: formatted output does not compile:`n$chk"; exit 1 }
# 5. idempotent: a second format yields identical bytes
RunGet ".\gen3_test.exe" @("fmt") "_t34v.nova" | Out-Null
$after2 = Get-Content _t34v.nova -Raw
if ($after1 -ne $after2) { Write-Host "FAIL #34: formatter not idempotent"; exit 1 }
Remove-Item Env:NOVA_NO_CACHE -ErrorAction SilentlyContinue
# 6. fallback: lambda+match must use the whitespace normalizer, never lose code
@'
fn main()
    let f = x => x + 1
    match f(2)
        n => print(str(n))
'@ | Set-Content _t34fb.nova
$rfb = RunGet ".\gen3_test.exe" @("fmt") "_t34fb.nova"
if ($rfb -match "Formatted \(AST\)") { Write-Host "FAIL #34: unsupported code took the AST path (should fall back)"; exit 1 }
if ($rfb -notmatch "Formatted:") { Write-Host "FAIL #34: fallback did not run: $rfb"; exit 1 }
$fb = Get-Content _t34fb.nova -Raw
if ($fb -notmatch "match f\(2\)" -or $fb -notmatch "x => x \+ 1") { Write-Host "FAIL #34: fallback lost code:`n$fb"; exit 1 }
Remove-Item _t34v.nova,_t34v.ll,_t34fb.nova -ErrorAction SilentlyContinue
Write-Host "PASS #34 AST-reprint: canonical + faithful (compiles) + idempotent + comments in place + safe fallback"
exit 0
