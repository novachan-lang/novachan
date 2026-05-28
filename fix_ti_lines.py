filepath = r'c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\nova_compiler.nova'
with open(filepath, 'r', encoding='utf-8') as f:
    lines = f.read().split('\n')

# Track which function we're in to choose eline vs sline
current_fn = None
modified = 0
new_lines = []

for i, line in enumerate(lines):
    stripped = line.lstrip()

    # Track function context
    if stripped.startswith('fn ti_infer_expr_inner('):
        current_fn = 'expr'
    elif stripped.startswith('fn ti_infer_stmt_inner('):
        current_fn = 'stmt'
    elif stripped.startswith('fn ti_infer_pattern('):
        current_fn = 'pattern'
    elif stripped.startswith('fn ') and not stripped.startswith('fn ti_'):
        current_fn = None

    # Replace ti_constrain(..., 0) with proper line variable
    if 'ti_constrain(st,' in line and ', 0)' in line:
        if current_fn == 'expr' or current_fn == 'pattern':
            new_line = line.replace('ti_constrain(st,', 'ti_constrain(st,', 1)
            # Replace the last ', 0)' on the line
            idx = line.rfind(', 0)')
            if idx >= 0:
                new_line = line[:idx] + ', eline)' + line[idx+4:]
                new_lines.append(new_line)
                modified += 1
                continue
        elif current_fn == 'stmt':
            idx = line.rfind(', 0)')
            if idx >= 0:
                new_line = line[:idx] + ', sline)' + line[idx+4:]
                new_lines.append(new_line)
                modified += 1
                continue

    new_lines.append(line)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write('\n'.join(new_lines))

print(f'Modified {modified} ti_constrain calls')
