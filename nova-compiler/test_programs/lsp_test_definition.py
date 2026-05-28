import json, subprocess, os, re

HERE = os.path.dirname(os.path.abspath(__file__))
LSP = os.path.join(HERE, "lsp_server.exe")
COMPILER = os.path.join(HERE, "gen2_move.exe")

def make_msg(body):
    b = body.encode("utf-8")
    return "Content-Length: {}\r\n\r\n{}".format(len(b), body)

def escape_json(s):
    return s.replace("\\","\\\\").replace('"','\\"').replace("\n","\\n").replace("\r","\\r").replace("\t","\\t")

# A test NOVA program with several symbols
nova_code = (
    "fn add(a, b)\n"
    "    a + b\n"
    "\n"
    "fn multiply(x, y)\n"
    "    x * y\n"
    "\n"
    "type Point\n"
    "    x: int\n"
    "    y: int\n"
    "\n"
    "fn main()\n"
    "    let result = add(2, 3)\n"
    "    let prod = multiply(4, 5)\n"
    "    print(result)\n"
)

e = escape_json(nova_code)
init = make_msg('{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":null,"capabilities":{}}}')
inited = make_msg('{"jsonrpc":"2.0","method":"initialized","params":{}}')
didopen = make_msg('{"jsonrpc":"2.0","method":"textDocument/didOpen","params":{"textDocument":{"uri":"file:///t.nova","languageId":"nova","version":1,"text":"' + e + '"}}}')

# Test 1: definition of `add` (used on line 11, col 17)
# Line 11 (0-indexed) is "    let result = add(2, 3)"
# Column of 'add' = 17
def_add = make_msg('{"jsonrpc":"2.0","id":2,"method":"textDocument/definition","params":{"textDocument":{"uri":"file:///t.nova"},"position":{"line":11,"character":17}}}')

# Test 2: definition of `multiply` (line 12, col 16)
def_mul = make_msg('{"jsonrpc":"2.0","id":3,"method":"textDocument/definition","params":{"textDocument":{"uri":"file:///t.nova"},"position":{"line":12,"character":16}}}')

# Test 3: hover on `add`
hover_add = make_msg('{"jsonrpc":"2.0","id":4,"method":"textDocument/hover","params":{"textDocument":{"uri":"file:///t.nova"},"position":{"line":11,"character":17}}}')

shutdown = make_msg('{"jsonrpc":"2.0","id":5,"method":"shutdown"}')
exit_m = make_msg('{"jsonrpc":"2.0","method":"exit"}')
payload = init + inited + didopen + def_add + def_mul + hover_add + shutdown + exit_m

proc = subprocess.Popen(
    [LSP, COMPILER],
    stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE
)
out, err = proc.communicate(payload.encode("utf-8"), timeout=15)
stdout = out.decode("utf-8", errors="replace")

print("=== LSP Definition + Hover Test ===\n")

# Parse out each response by id
def find_response(stdout, response_id):
    # Each response is a complete JSON object after a Content-Length header
    pattern = r'\{"jsonrpc":"2\.0","id":' + str(response_id) + r',"result":(.*?)\}\}|\{"jsonrpc":"2\.0","id":' + str(response_id) + r',"result":null\}'
    m = re.search(pattern, stdout)
    if m:
        return m.group(0)
    return None

# Find each id'd response
def grab(rid):
    # Match the response with given id, capture the result portion
    idx = stdout.find('"id":' + str(rid))
    if idx < 0:
        return None
    # Walk forward to find the end of this JSON object (balanced braces)
    # Easier: find start of "{" before idx
    start = stdout.rfind("{", 0, idx)
    if start < 0:
        return None
    depth = 0
    i = start
    while i < len(stdout):
        if stdout[i] == "{":
            depth += 1
        elif stdout[i] == "}":
            depth -= 1
            if depth == 0:
                return stdout[start:i+1]
        i += 1
    return None

r_add = grab(2)
r_mul = grab(3)
r_hov = grab(4)

print("Test 1: go-to-definition of `add`")
if r_add and '"line":0' in r_add and '"character":3' in r_add:
    print("  [PASS] returned line 0, col 3 (the `add` in `fn add(a, b)`)")
    print("         {}".format(r_add[:200]))
else:
    print("  [FAIL] expected line 0 col 3, got:")
    print("         {}".format(r_add))

print()
print("Test 2: go-to-definition of `multiply`")
if r_mul and '"line":3' in r_mul and '"character":3' in r_mul:
    print("  [PASS] returned line 3, col 3 (the `multiply` in `fn multiply(x, y)`)")
    print("         {}".format(r_mul[:200]))
else:
    print("  [FAIL] expected line 3 col 3, got:")
    print("         {}".format(r_mul))

print()
print("Test 3: hover on `add`")
if r_hov and "add" in r_hov:
    print("  [PASS] hover returned content containing 'add'")
    print("         {}".format(r_hov[:200]))
else:
    print("  [FAIL] hover empty or no 'add':")
    print("         {}".format(r_hov))
