Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$compiler = (Resolve-Path ".\gen2_move.exe").Path

# Quick test: regex_test
$cr = Invoke-Timed -FilePath $compiler -Arguments "regex_test.nova" -TimeoutMs 30000
if ($cr.ExitCode -ne 0) { Write-Host "FAIL regex: compile"; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o regex_test.exe regex_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
if (!(Test-Path "regex_test.exe")) { Write-Host "FAIL regex: link"; exit 1 }
$rr = Invoke-Timed -FilePath (Resolve-Path ".\regex_test.exe").Path -Arguments "" -TimeoutMs 15000
Write-Host "regex_test: exit=$($rr.ExitCode) $($rr.StdOut.Trim())"
Remove-Item "regex_test.exe","regex_test.ll" -Force -ErrorAction SilentlyContinue

# Quick test: generic_identity (soundness)
Set-Content "generic_identity.nova" @"
fn identity(x)
    return x
fn main()
    let a = identity(42)
    let b = identity("hello")
    assert(str(a) == "42", "a: " + str(a))
    assert(str(b) == "hello", "b: " + str(b))
    print("OK: " + str(a) + " " + str(b))
"@
$cr2 = Invoke-Timed -FilePath $compiler -Arguments "generic_identity.nova" -TimeoutMs 30000
$lr2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o generic_identity.exe generic_identity.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
$rr2 = Invoke-Timed -FilePath (Resolve-Path ".\generic_identity.exe").Path -Arguments "" -TimeoutMs 10000
Write-Host "generic_identity: exit=$($rr2.ExitCode) $($rr2.StdOut.Trim())"
Remove-Item "generic_identity.nova","generic_identity.exe","generic_identity.ll" -Force -ErrorAction SilentlyContinue

# Quick test: polymorphic_call
Set-Content "polymorphic_call.nova" @"
fn first(items) -> string
    return str(items[0])
fn main()
    let r1 = first([42, 99])
    let r2 = first(["hello", "world"])
    assert(r1 == "42", "got: " + r1)
    assert(r2 == "hello", "got: " + r2)
    print("OK: " + r1 + " " + r2)
"@
$cr3 = Invoke-Timed -FilePath $compiler -Arguments "polymorphic_call.nova" -TimeoutMs 30000
$lr3 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o polymorphic_call.exe polymorphic_call.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
$rr3 = Invoke-Timed -FilePath (Resolve-Path ".\polymorphic_call.exe").Path -Arguments "" -TimeoutMs 10000
Write-Host "polymorphic_call: exit=$($rr3.ExitCode) $($rr3.StdOut.Trim())"
Remove-Item "polymorphic_call.nova","polymorphic_call.exe","polymorphic_call.ll" -Force -ErrorAction SilentlyContinue

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
