# #32b semantic-LSP diagnostics gate: the self-hosted `nova lsp` publishes diagnostics from the REAL
# current inferer (ti_infer_program_named), NOT a stale frontend. This gate proves CORE_GAP 6.4 stays
# closed: (1) a genuine type error IS reported, and (2) a CORRECT modern-feature program (spawn+channel)
# produces ZERO diagnostics — i.e. no false positives for features "added since May" (the 6.4 fear).
param([string]$Exe = ".\gen3_test.exe")
$ErrorActionPreference = "Continue"
if (-not (Test-Path $Exe)) { Write-Host "SKIP: $Exe not found"; exit 0 }

function Frame($j){ $n=[Text.Encoding]::UTF8.GetByteCount($j); return "Content-Length: $n`r`n`r`n$j" }
function LspDiags($text) {
  $init  = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"capabilities":{}}}'
  $inited= '{"jsonrpc":"2.0","method":"initialized","params":{}}'
  $open  = '{"jsonrpc":"2.0","method":"textDocument/didOpen","params":{"textDocument":{"uri":"file:///t.nova","languageId":"nova","version":1,"text":"' + $text + '"}}}'
  $payload = (Frame $init)+(Frame $inited)+(Frame $open)+(Frame '{"jsonrpc":"2.0","id":9,"method":"shutdown"}')+(Frame '{"jsonrpc":"2.0","method":"exit"}')
  $psi = New-Object Diagnostics.ProcessStartInfo
  $psi.FileName = (Resolve-Path $Exe).Path; $psi.Arguments = "lsp"
  $psi.RedirectStandardInput = $true; $psi.RedirectStandardOutput = $true; $psi.UseShellExecute = $false
  $p = [Diagnostics.Process]::Start($psi)
  $p.StandardInput.Write($payload); $p.StandardInput.Close()
  $ot = $p.StandardOutput.ReadToEndAsync()
  if (-not $p.WaitForExit(10000)) { $p.Kill(); return $null }
  $resp = $ot.Result
  $diags = ""
  foreach ($chunk in ($resp -split "Content-Length:")) {
    if ($chunk -match 'publishDiagnostics' -and $chunk -match '"diagnostics":\[(.*)\]') { $diags = $matches[1] }
  }
  return $diags
}

$fail = 0

# (1) genuine arity error must be reported
$errDiag = LspDiags 'fn add(a: int, b: int) -> int\n    a + b\nfn main()\n    let r = add(1)\n    print(r)\n'
if ($errDiag -match 'E1003' -or ($errDiag -ne '' -and $errDiag -match 'argument')) {
    Write-Host "PASS #32b diag: real arity error reported ($errDiag)"
} else {
    Write-Host "FAIL #32b diag: arity error NOT reported (got [$errDiag])"; $fail = 1
}

# (2) correct spawn+channel program must produce ZERO diagnostics (no false positive)
$okDiag = LspDiags 'fn worker(ch: channel)\n    send(ch, 42)\nfn main()\n    let ch = channel()\n    spawn worker(ch)\n    let v = recv(ch)\n    print(v)\n'
if ($okDiag -eq '') {
    Write-Host "PASS #32b diag: correct spawn+channel program has ZERO diagnostics (no false positive)"
} else {
    Write-Host "FAIL #32b diag: false positive on correct modern-feature code (got [$okDiag])"; $fail = 1
}

if ($fail -ne 0) { exit 1 }
Write-Host "PASS #32b semantic-LSP diagnostics gate (real errors flagged, modern features clean)"
exit 0
