import json, subprocess, sys, os, re

LSP = os.path.join(os.path.dirname(__file__), "lsp_server.exe")
COMPILER = os.path.abspath(os.path.join(os.path.dirname(__file__), "gen2_move.exe"))

def make_msg(body):
    b = body.encode("utf-8")
    return "Content-Length: {}\r\n\r\n{}".format(len(b), body)

def escape_json(s):
    s = s.replace("\\", "\\\\")
    s = s.replace('"', '\\"')
    s = s.replace("\n", "\\n")
    s = s.replace("\r", "\\r")
    s = s.replace("\t", "\\t")
    return s

def run_lsp(nova_code, label):
    escaped = escape_json(nova_code)
    init = make_msg('{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":null,"capabilities":{}}}')
    inited = make_msg('{"jsonrpc":"2.0","method":"initialized","params":{}}')
    didopen = make_msg('{"jsonrpc":"2.0","method":"textDocument/didOpen","params":{"textDocument":{"uri":"file:///test.nova","languageId":"nova","version":1,"text":"' + escaped + '"}}}')
    shutdown = make_msg('{"jsonrpc":"2.0","id":2,"method":"shutdown"}')
    exit_m = make_msg('{"jsonrpc":"2.0","method":"exit"}')
    payload = init + inited + didopen + shutdown + exit_m

    proc = subprocess.Popen(
        [LSP, COMPILER],
        stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    out, err = proc.communicate(payload.encode("utf-8"), timeout=15)
    stdout = out.decode("utf-8", errors="replace")

    diag_match = re.search(r'"diagnostics":\[([^\]]*)\]', stdout)
    diag_content = diag_match.group(1) if diag_match else "(none)"
    msg_count = len(re.findall(r'"message"', diag_content))

    if msg_count == 0:
        print("  [CLEAN] {}: 0 diagnostics".format(label))
    else:
        print("  [ERROR] {}: {} diagnostic(s)".format(label, msg_count))
        print("          {}".format(diag_content[:300]))

files = [
    "struct_test.nova", "trait_test.nova", "match_test.nova",
    "spawn_test.nova", "closure_test.nova", "dict_test.nova",
    "enum_test.nova", "for_test.nova", "match_guard_test.nova",
    "destructure_test.nova", "nova_compiler.nova"
]

print("=== LSP False-Positive Check ===")
print("    LSP:      {}".format(LSP))
print("    Compiler: {}".format(COMPILER))
print()

for f in files:
    fpath = os.path.join(os.path.dirname(__file__), f)
    if not os.path.exists(fpath):
        print("  [SKIP] {}: not found".format(f))
        continue
    with open(fpath, "r", encoding="utf-8") as fh:
        code = fh.read()
    run_lsp(code, f)
