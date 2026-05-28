filepath = r'c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\nova_compiler.nova'
with open(filepath, 'r', encoding='utf-8') as f:
    raw_lines = f.read().split('\n')

# First pass: remove any previously added 'let ln = tl(tokens, pos)' lines
lines = []
removed = 0
for line in raw_lines:
    if line.strip() == 'let ln = tl(tokens, pos)':
        removed += 1
        continue
    lines.append(line)
print(f'Removed {removed} existing "let ln" lines')

# Parser functions that have (tokens, pos, ...) signature
parser_fns = [
    'fn parse_expr(tokens',
    'fn parse_prefix(tokens',
    'fn parse_call_args(tokens',
    'fn parse_index(tokens',
    'fn parse_if_expr(tokens',
    'fn parse_match_expr(tokens',
    'fn parse_pattern(tokens',
    'fn parse_for_expr(tokens',
    'fn parse_stmt(tokens',
    'fn parse_block(tokens',
    'fn parse_fn_def(tokens',
    'fn parse_type_def(tokens',
    'fn parse_if_stmt(tokens',
    'fn parse_while_stmt(tokens',
    'fn parse_for_stmt(tokens',
    'fn parse_match_stmt(tokens',
    'fn parse_import(tokens',
]

in_parser_fn = False
fn_indent = 0
modified_constructors = 0
added_ln_vars = 0

new_lines = []
i = 0
while i < len(lines):
    line = lines[i]
    stripped = line.lstrip()

    # Detect parser function definition
    is_parser_fn = any(stripped.startswith(fn) for fn in parser_fns)
    if is_parser_fn:
        in_parser_fn = True
        fn_indent = len(line) - len(stripped)
        new_lines.append(line)
        i += 1
        # Add 'let ln = tl(tokens, pos)' as first line of function body
        indent_str = ' ' * (fn_indent + 4)
        new_lines.append(indent_str + 'let ln = tl(tokens, pos)')
        added_ln_vars += 1
        continue

    # Detect end of parser function
    if in_parser_fn and stripped and not stripped.startswith('//'):
        current_indent = len(line) - len(stripped)
        if current_indent <= fn_indent:
            # Check if this is a new function def or top-level code
            if stripped.startswith('fn ') or stripped.startswith('type ') or stripped.startswith('//') or current_indent == 0:
                in_parser_fn = False

    # Replace ', 0)' with ', ln)' in Expr/Stmt constructors inside parser functions
    if in_parser_fn and ('Expr("' in line or 'Stmt("' in line):
        # Find the constructor and track parens
        for constructor_prefix in ['Expr("', 'Stmt("']:
            if constructor_prefix not in line:
                continue
            idx = line.index(constructor_prefix)
            type_name = constructor_prefix[:4]  # 'Expr' or 'Stmt'

            depth = 0
            start = idx + len(type_name)  # position of '('
            end = -1
            for j in range(start, len(line)):
                if line[j] == '(':
                    depth += 1
                elif line[j] == ')':
                    depth -= 1
                    if depth == 0:
                        end = j
                        break

            if end > 3 and line[end-3:end+1] == ', 0)':
                line = line[:end-3] + ', ln)' + line[end+1:]
                modified_constructors += 1

    new_lines.append(line)
    i += 1

with open(filepath, 'w', encoding='utf-8') as f:
    f.write('\n'.join(new_lines))

print(f'Added {added_ln_vars} "let ln" declarations')
print(f'Modified {modified_constructors} constructors (0 -> ln)')
