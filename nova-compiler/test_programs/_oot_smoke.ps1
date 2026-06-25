. "$PSScriptRoot\_proc_util.ps1"   # sets NOVA_HOME + syncs stdlib -> lib/
$ootDir = Join-Path $PSScriptRoot "_oot"
New-Item -ItemType Directory -Force -Path $ootDir | Out-Null
$prog = Join-Path $ootDir "app.nova"
@"
import corex
import matrixx
fn main()
    print("oot bsearch=" + str(corex.binary_search([2,4,6,8], 6)))
    let m = matrixx.mat_transpose([[1,2,3],[4,5,6]])
    print("oot transpose rows=" + str(matrixx.mat_rows(m)))
    print("oot_smoke passed")
"@ | Set-Content -Encoding ASCII $prog
$compiler = (Resolve-Path "$PSScriptRoot\nova.exe").Path
$c = Invoke-Timed -FilePath $compiler -Arguments "app.nova" -TimeoutMs 60000 -WorkingDirectory $ootDir
if (-not (Test-Path (Join-Path $ootDir "app.ll"))) { Write-Host "OOT COMPILE FAIL (stdlib not resolving from lib/?)"; Write-Host $c.StdOut; exit 1 }
$rt = "$PSScriptRoot\nova_runtime.o"
$exe = Join-Path $ootDir "app.exe"
Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$exe`" `"$(Join-Path $ootDir 'app.ll')`" `"$rt`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $ootDir | Out-Null
$r = Invoke-Timed -FilePath $exe -TimeoutMs 20000 -WorkingDirectory $ootDir
Write-Host $r.StdOut
