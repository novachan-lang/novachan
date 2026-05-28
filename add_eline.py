filepath = r'c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\nova_compiler_min.nova'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Add eline: int to Expr type definition
content = content.replace(
    'type Expr\n    tag: string\n    value: string\n    num: int\n    children: list\n    fields: list\n',
    'type Expr\n    tag: string\n    value: string\n    num: int\n    children: list\n    fields: list\n    eline: int\n'
)

lines = content.split('\n')
new_lines = []
expr_5_count = 0
expr_6_count = 0

for i, line in enumerate(lines):
    stripped = line.lstrip()

    # Fix Expr constructors: Expr("...", ..., ..., ..., ...) -> Expr("...", ..., ..., ..., ..., 0)
    # Look for Expr( that has exactly 5 args
    if 'Expr(' in line and 'type Expr' not in line and 'fn null_expr' not in line:
        # Simple heuristic: find Expr( and count its args
        idx = line.find('Expr(')
        if idx >= 0:
            # Find the matching closing paren
            depth = 0
            start = idx + 4  # position of (
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
                inner = line[start+1:end]
                # Count commas at depth 0
                d = 0
                commas = 0
                for c in inner:
                    if c == '(' or c == '[' or c == '{':
                        d += 1
                    elif c == ')' or c == ']' or c == '}':
                        d -= 1
                    elif c == ',' and d == 0:
                        commas += 1
                # 5 fields = 4 commas
                if commas == 4:
                    new_line = line[:end] + ', 0' + line[end:]
                    new_lines.append(new_line)
                    expr_5_count += 1
                    continue

    # Fix Expr pattern matches: Expr(a, b, c, d, e) => -> Expr(a, b, c, d, e, _eln) =>
    if ') =>' in line and 'Expr(' in line:
        idx = line.find('Expr(')
        if idx >= 0:
            arrow_idx = line.find(') =>')
            if arrow_idx >= 0:
                inner = line[idx+5:arrow_idx]
                d = 0
                commas = 0
                for c in inner:
                    if c == '(' or c == '[' or c == '{':
                        d += 1
                    elif c == ')' or c == ']' or c == '}':
                        d -= 1
                    elif c == ',' and d == 0:
                        commas += 1
                if commas == 4:
                    new_line = line[:arrow_idx] + ', _eln) =>' + line[arrow_idx+4:]
                    new_lines.append(new_line)
                    expr_6_count += 1
                    continue

    new_lines.append(line)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write('\n'.join(new_lines))

print(f'Updated {expr_5_count} Expr constructors (added , 0)')
print(f'Updated {expr_6_count} Expr pattern matches (added , _eln)')
