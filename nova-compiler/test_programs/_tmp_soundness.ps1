Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$compiler = (Resolve-Path ".\gen2_move.exe").Path
Write-Host "Soundness probe with gen2_move.exe"

$tests = @{
    "for_str_in_list" = @"
fn main()
    let items = ["alpha", "beta", "gamma"]
    let result = ""
    for x in items
        result = result + x + ","
    assert(result == "alpha,beta,gamma,", "got: " + result)
    print("for_str_in_list: " + result)
"@
    "for_mixed_list" = @"
fn main()
    let items = [10, "hello", 30]
    let out = ""
    for x in items
        out = out + str(x) + "|"
    assert(out == "10|hello|30|", "got: " + out)
    print("for_mixed_list: " + out)
"@
    "dict_iter_values" = @"
fn main()
    let d = {"a": "one", "b": "two"}
    let out = ""
    let ks = keys(d)
    for k in ks
        out = out + str(d[k]) + ","
    print("dict_iter_values: " + out)
"@
    "nested_list_access" = @"
fn get_inner(data, i, j) -> string
    let row = data[i]
    return str(row[j])

fn main()
    let matrix = [[1, 2], [3, 4]]
    let r = get_inner(matrix, 0, 1)
    assert(r == "2", "got: " + r)
    print("nested_list_access: " + r)
"@
    "str_from_dict_val" = @"
fn lookup(d, key) -> string
    return str(d[key])

fn main()
    let config = {"host": "localhost", "port": "8080"}
    let h = lookup(config, "host")
    let p = lookup(config, "port")
    assert(h == "localhost", "host got: " + h)
    assert(p == "8080", "port got: " + p)
    print("str_from_dict_val: " + h + ":" + p)
"@
    "intlist_sum_after_push" = @"
fn main()
    let data = [10, 20, 30]
    push(data, 40)
    let total = 0
    for x in data
        total = total + x
    assert(total == 100, "got: " + str(total))
    print("intlist_sum_after_push: " + str(total))
"@
    "list_contains_str" = @"
fn main()
    let fruits = ["apple", "banana", "cherry"]
    let has_b = contains(fruits, "banana")
    let has_x = contains(fruits, "mango")
    assert(has_b == true, "should contain banana")
    assert(has_x == false, "should not contain mango")
    print("list_contains_str: " + str(has_b) + " " + str(has_x))
"@
    "generic_identity" = @"
fn identity(x)
    return x

fn main()
    let a = identity(42)
    let b = identity("hello")
    assert(a == 42, "a got: " + str(a))
    assert(b == "hello", "b got: " + str(b))
    print("generic_identity: " + str(a) + " " + str(b))
"@
}

$pass = 0; $fail = 0
foreach ($name in $tests.Keys) {
    Set-Content "$name.nova" $tests[$name]
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$name.nova" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0) {
        Write-Host "FAIL compile: $name"
        if ($cr.StdErr) { Write-Host "  $($cr.StdErr.Substring(0, [Math]::Min(200,$cr.StdErr.Length)))" }
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
        else { Write-Host "PASS $name" }
        $pass++
    }
    Remove-Item "$name.nova","$name.ll","$name.exe" -Force -ErrorAction SilentlyContinue
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
Write-Host "`nResults: $pass PASS, $fail FAIL"
