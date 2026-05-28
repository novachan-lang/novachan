filepath = r'c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\nova_compiler.nova'
with open(filepath, 'rb') as f:
    data = f.read(500)

# Check for BOM
if data[:3] == b'\xef\xbb\xbf':
    print("Has UTF-8 BOM")
else:
    print("No BOM")

# Check line endings
crlf = data.count(b'\r\n')
lf = data.count(b'\n') - crlf
cr = data.count(b'\r') - crlf
print(f"In first 500 bytes: CRLF={crlf}, LF-only={lf}, CR-only={cr}")

# Count total
with open(filepath, 'rb') as f:
    all_data = f.read()
total_crlf = all_data.count(b'\r\n')
total_lf = all_data.count(b'\n') - total_crlf
print(f"Total: CRLF={total_crlf}, LF-only={total_lf}")
print(f"File size: {len(all_data)} bytes")
