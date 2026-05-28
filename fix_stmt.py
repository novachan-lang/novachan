filepath = r'c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\nova_compiler.nova'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
modified = 0
new_lines = []

for i, line in enumerate(lines):
    # Skip pattern matches (they already have 8 fields with sline/ssln/asln)
    if '=>' in line and 'Stmt(' in line:
        new_lines.append(line)
        continue

    # Skip type definition line
    if line.strip() == 'type Stmt':
        new_lines.append(line)
        continue

    # Find Stmt constructor calls with string first arg
    if 'Stmt("' in line:
        idx = line.index('Stmt("')
        depth = 0
        start = idx + 4  # skip 'Stmt'
        end = -1
        for j in range(start, len(line)):
            if line[j] == '(':
                depth += 1
            elif line[j] == ')':
                depth -= 1
                if depth == 0:
                    end = j
                    break
        if end > 0:
            new_line = line[:end] + ', 0' + line[end:]
            new_lines.append(new_line)
            modified += 1
            continue

    new_lines.append(line)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write('\n'.join(new_lines))

print(f'Modified {modified} Stmt constructors')
