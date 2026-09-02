Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
$SP = "C:\Users\mange\AppData\Local\Temp\claude\c--Users-mange-Crypto-AI-New-folder-New-folder\95756d95-6c7b-4f8e-89f3-258795f1c59b\scratchpad\lll"
$tests = @(
  "forge_pg_scram_test","_argon2id_test","_argon2id_kat","forge_jwt_test","_typename_test",
  "regex_full_test","regex_alt_test","dns_test","_schema_test","_tomlwrite_test","_pbwire_kat",
  "forge_grpc_client_kat","_kat_ubjson_fix","_kat_toml_parse_audit","_kat_yaml_parse_audit",
  "_kat_ini_parse_audit","_pbkdf2_native_test","forge_crypto_sha256_test","_bitpack_test",
  "int_ptr_soundness_repro","_bittricks_test","demo_frameworks_v2_test"
)
$ok=0; $bad=0
foreach ($t in $tests) {
  if (-not (Test-Path "$t.nova")) { Write-Host "MISSING $t"; continue }
  $r = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile $t.nova -o $SP\$t.ll --target linux" -TimeoutMs 300000
  if ($r.ExitCode -eq 0 -and (Test-Path "$SP\$t.ll")) { $ok++ } else { Write-Host "XC-FAIL $t"; $bad++ }
}
Write-Host "CROSS-COMPILED ok=$ok fail=$bad"
