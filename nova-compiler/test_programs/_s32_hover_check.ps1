# #32 semantic-LSP gate: hover returns the REAL function signature (not bare "function").
param([string]$Exe = ".\gen3_test.exe")
$ErrorActionPreference = "Continue"
function Frame($j){ $n=[Text.Encoding]::UTF8.GetByteCount($j); return "Content-Length: $n`r`n`r`n$j" }
$init  = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"capabilities":{}}}'
$inited= '{"jsonrpc":"2.0","method":"initialized","params":{}}'
$text  = 'fn add(a: int, b: int) -> int\n    a + b\n'
$open  = '{"jsonrpc":"2.0","method":"textDocument/didOpen","params":{"textDocument":{"uri":"file:///t.nova","languageId":"nova","version":1,"text":"' + $text + '"}}}'
$hov   = '{"jsonrpc":"2.0","id":2,"method":"textDocument/hover","params":{"textDocument":{"uri":"file:///t.nova"},"position":{"line":0,"character":4}}}'
$payload = (Frame $init)+(Frame $inited)+(Frame $open)+(Frame $hov)+(Frame '{"jsonrpc":"2.0","id":3,"method":"shutdown"}')+(Frame '{"jsonrpc":"2.0","method":"exit"}')
$psi = New-Object Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path $Exe).Path; $psi.Arguments = "lsp"
$psi.RedirectStandardInput = $true; $psi.RedirectStandardOutput = $true; $psi.UseShellExecute = $false
$p = [Diagnostics.Process]::Start($psi)
$p.StandardInput.Write($payload); $p.StandardInput.Close()
$ot = $p.StandardOutput.ReadToEndAsync()
if (-not $p.WaitForExit(8000)) { $p.Kill() }
$resp = $ot.Result
$val = ""
foreach ($chunk in ($resp -split "Content-Length:")) {
  if ($chunk -match '"id":2' -and $chunk -match '"value":"([^"]*)"') { $val = $matches[1] }
}
Write-Host "hover value = [$val]"
if ($val -match 'a: int' -and $val -match '-> int') { Write-Host "PASS #32 semantic LSP: hover shows real signature (add(a: int, b: int) -> int)"; exit 0 }
Write-Host "FAIL #32 hover: signature not shown"; exit 1
