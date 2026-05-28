Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# Adversarial type system tests — programs that might trigger silent miscompiles
$tests = @{
    "polymorphic_call" = @"
// Same function called with intlist and string list - fpt should not assume intlist
fn first(items: list) -> string
    return str(items[0])

fn main()
    let nums = [42, 99]
    let strs = ["hello", "world"]
    let r1 = first(nums)
    let r2 = first(strs)
    assert(r1 == "42", "first(nums) should be 42, got: " + r1)
    assert(r2 == "hello", "first(strs) should be hello, got: " + r2)
    print("polymorphic_call: " + r1 + " " + r2)
"@
    "intlist_str_push" = @"
// Push a string into what was an intlist - must not native-add on elements after
fn main()
    let data = [1, 2, 3]
    push(data, "four")
    let last = data[3]
    assert(last == "four", "last should be four")
    print("intlist_str_push: " + str(last))
"@
    "empty_list_for" = @"
// Empty list iteration should not crash
fn sum_all(items: list) -> int
    let total = 0
    for x in items
        total = total + x
    return total

fn main()
    let empty = []
    let r = sum_all(empty)
    assert(r == 0, "sum of empty should be 0")
    let filled = [5, 10, 15]
    let r2 = sum_all(filled)
    assert(r2 == 30, "sum should be 30")
    print("empty_list_for: " + str(r) + " " + str(r2))
"@
    "list_from_fn" = @"
// List returned from a function - does intlist propagate through return types?
fn make_data() -> list
    return [100, 200, 300]

fn total(items: list) -> int
    let s = 0
    for x in items
        s = s + x
    return s

fn main()
    let data = make_data()
    let r = total(data)
    assert(r == 600, "total should be 600")
    print("list_from_fn: " + str(r))
"@
}

$pass = 0; $fail = 0
foreach ($name in $tests.Keys) {
    Set-Content "$name.nova" $tests[$name]
    $cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "$name.nova" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0) {
        Write-Host "FAIL compile: $name"
        $fail++; continue
    }
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $name.exe $name.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (!(Test-Path "$name.exe")) {
        Write-Host "FAIL link: $name"
        $fail++; continue
    }
    $rr = Invoke-Timed -FilePath (Resolve-Path ".\$name.exe").Path -Arguments "" -TimeoutMs 10000
    if ($rr.ExitCode -ne 0) {
        Write-Host "FAIL run: $name (exit=$($rr.ExitCode))"
        if ($rr.StdOut) { Write-Host "  stdout: $($rr.StdOut.Trim())" }
        if ($rr.StdErr) { Write-Host "  stderr: $($rr.StdErr.Substring(0, [Math]::Min(200,$rr.StdErr.Length)))" }
        $fail++
    } else {
        if ($rr.StdOut) { Write-Host "PASS $name : $($rr.StdOut.Trim())" }
        $pass++
    }
    Remove-Item "$name.nova","$name.ll","$name.exe" -Force -ErrorAction SilentlyContinue
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
Write-Host "`nResults: $pass PASS, $fail FAIL"
