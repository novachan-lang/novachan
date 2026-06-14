# nova build --target web (bundler, script form): turn a .nova into a self-contained, servable
# web/ directory -- the proven Stages 0-3 frontend pipeline packaged into ONE command.
# Usage: .\_wasm_build_web.ps1 <program.nova> [comma-separated extra fn exports e.g. on_click]
# Output: web_<program>/ containing <program>.wasm + _wasm_runtime_browser.mjs + index.html.
param([Parameter(Mandatory)][string]$Source, [string]$Exports = "")
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$LLVM = "C:\Program Files\LLVM\bin"
$base = [System.IO.Path]::GetFileNameWithoutExtension($Source)
$out  = "web_$base"
Remove-Item "$base.ll","$base.o","$base.wasm" -Force -ErrorAction SilentlyContinue
# 1. NOVA -> wasm (the proven pipeline)
$r = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile $base.nova --target wasm" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($r.ExitCode -ne 0) { Write-Host "NOVA compile FAIL exit=$($r.ExitCode)"; if($r.StdOut){Write-Host $r.StdOut}; exit 1 }
$c = Invoke-Timed -FilePath "$LLVM\clang.exe" -Arguments "--target=wasm32 -O2 -c $base.ll -o $base.o" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "$base.o")) { Write-Host "clang wasm32 FAIL"; exit 1 }
$exp = "--export=nova_user_main --export=__heap_base"
foreach ($e in ($Exports -split ',' | Where-Object { $_ -ne '' })) { $exp += " --export=$($e.Trim())" }
$l = Invoke-Timed -FilePath "$LLVM\wasm-ld.exe" -Arguments "--no-entry $exp --allow-undefined --gc-sections $base.o -o $base.wasm" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "$base.wasm")) { Write-Host "wasm-ld FAIL"; exit 1 }
# 2. assemble the self-contained web directory
New-Item -ItemType Directory -Force -Path $out | Out-Null
Copy-Item "$base.wasm" "$out\$base.wasm" -Force
Copy-Item "_wasm_runtime_browser.mjs" "$out\_wasm_runtime_browser.mjs" -Force
$html = @"
<!doctype html><html><head><meta charset="utf-8"><title>$base (NOVA -> wasm)</title></head>
<body>
  <h1>$base</h1>
  <div id="app"></div>
  <script type="module">
    import { runDom } from "./_wasm_runtime_browser.mjs";
    runDom("./$base.wasm").catch(e => { document.getElementById("app").textContent = "ERROR: " + e; });
  </script>
</body></html>
"@
Set-Content -Path "$out\index.html" -Value $html -Encoding UTF8
Remove-Item "$base.ll","$base.o" -Force -ErrorAction SilentlyContinue
Write-Host "built $out/ ->"
Get-ChildItem $out | ForEach-Object { Write-Host ("  " + $_.Name + " (" + $_.Length + " bytes)") }
Write-Host "serve it: cd $out; python -m http.server  (then open index.html)"
