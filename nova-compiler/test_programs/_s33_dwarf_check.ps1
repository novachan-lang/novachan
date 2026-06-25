# #33 DWARF-variable emission gate: NOVA_DWARF_VARS makes the compiler emit DILocalVariable +
# llvm.dbg.declare (typed nova_value, FullDebug) so lldb can inspect NOVA locals; default-off is
# byte-identical line-tables-only DWARF (no reconverge/perf impact). The nova_lldb.py summary
# renders a nova_value via the runtime formatter.
$ErrorActionPreference = "Continue"
$prog = "_s33_prog.nova"
@'
fn greet(name: string) -> string
    let msg = "hello, " + name
    return msg

fn main()
    let who = "nova"
    let g = greet(who)
    print(g)
'@ | Set-Content $prog
# 1. flag ON -> the .ll carries variable debug info
Remove-Item _s33_prog.ll -ErrorAction SilentlyContinue
$env:NOVA_DWARF_VARS = "1"; $env:NOVA_NO_CACHE = "1"
& .\gen3_test.exe $prog *> $null
Remove-Item Env:NOVA_DWARF_VARS -ErrorAction SilentlyContinue
if (-not (Test-Path _s33_prog.ll)) { Write-Host "FAIL #33: program did not compile (flag on)"; exit 1 }
$on = Get-Content _s33_prog.ll -Raw
if ($on -notmatch "DILocalVariable")  { Write-Host "FAIL #33: no DILocalVariable emitted under NOVA_DWARF_VARS"; exit 1 }
if ($on -notmatch "llvm\.dbg\.declare") { Write-Host "FAIL #33: no llvm.dbg.declare emitted"; exit 1 }
if ($on -notmatch "nova_value")       { Write-Host "FAIL #33: no nova_value DIBasicType"; exit 1 }
if ($on -notmatch "FullDebug")        { Write-Host "FAIL #33: emissionKind not FullDebug under flag"; exit 1 }
# the named locals must appear as DILocalVariables
if ($on -notmatch 'DILocalVariable\(name: "msg"') { Write-Host "FAIL #33: local 'msg' not described"; exit 1 }
if ($on -notmatch 'DILocalVariable\(name: "who"') { Write-Host "FAIL #33: local 'who' not described"; exit 1 }
# 2. flag OFF -> byte-identical line-tables-only (no variable debug info leaks)
Remove-Item _s33_prog.ll -ErrorAction SilentlyContinue
& .\gen3_test.exe $prog *> $null
$off = Get-Content _s33_prog.ll -Raw
if ($off -match "DILocalVariable")   { Write-Host "FAIL #33: flag-off leaked DILocalVariable (not byte-identical!)"; exit 1 }
if ($off -match "llvm\.dbg\.declare") { Write-Host "FAIL #33: flag-off leaked dbg.declare"; exit 1 }
if ($off -notmatch "LineTablesOnly") { Write-Host "FAIL #33: flag-off lost line-tables DWARF"; exit 1 }
Remove-Item Env:NOVA_NO_CACHE -ErrorAction SilentlyContinue
Remove-Item _s33_prog.nova,_s33_prog.ll -ErrorAction SilentlyContinue
Write-Host "PASS #33 DWARF vars: flag-on emits DILocalVariable+dbg.declare+nova_value (FullDebug); flag-off byte-identical line-tables"
exit 0
