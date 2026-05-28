Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Compile modified source
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 60000
if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL"; exit 1 }
Write-Host "Compile OK"

# Link gen2_new
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen2_new.exe nova_compiler.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
if (!(Test-Path "gen2_new.exe")) { Write-Host "LINK FAIL"; exit 1 }
Write-Host "Link OK"

# Test with gen2_new
$tests = @{
    "generic_identity" = @"
fn identity(x)
    return x

fn main()
    let a = identity(42)
    let b = identity("hello")
    assert(a == 42, "a got: " + str(a))
    assert(b == "hello", "b got: " + str(b))
    print("OK: " + str(a) + " " + str(b))
"@
    "poly_noanno" = "USE_FILE"
    "push_debug" = "USE_FILE"
}

foreach ($name in $tests.Keys) {
    if ($tests[$name] -eq "USE_FILE") {
        if (!(Test-Path "$name.nova")) { continue }
    } else {
        Set-Content "$name.nova" $tests[$name]
    }
    $cr2 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_new.exe").Path -Arguments "$name.nova" -TimeoutMs 30000
    if ($cr2.ExitCode -ne 0) { Write-Host "FAIL $name : compile"; continue }
    $lr2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $name.exe $name.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (!(Test-Path "$name.exe")) { Write-Host "FAIL $name : link"; continue }
    $rr = Invoke-Timed -FilePath (Resolve-Path ".\$name.exe").Path -Arguments "" -TimeoutMs 10000
    if ($rr.ExitCode -ne 0) {
        Write-Host "FAIL $name : exit=$($rr.ExitCode) out=$($rr.StdOut)"
    } else {
        Write-Host "PASS $name : $($rr.StdOut.Trim())"
    }
    if ($tests[$name] -ne "USE_FILE") { Remove-Item "$name.nova" -Force -ErrorAction SilentlyContinue }
    Remove-Item "$name.exe","$name.ll" -Force -ErrorAction SilentlyContinue
}
Remove-Item "gen2_new.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
