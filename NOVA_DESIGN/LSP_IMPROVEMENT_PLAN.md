# NOVA VS Code Extension — LSP Improvement Plan

> **Goal:** Make NOVA's editor experience match or beat what Java/TypeScript/Rust developers expect — hover shows real types, Ctrl+Click always finds definitions, completions are context-aware.
> **Files:** `nova-vscode/` (TypeScript extension), `nova-compiler/.../lsp/LspAnalyzer.kt` + `LspServer.kt` (Kotlin LSP server)

---

## Current State (what works today)

| Feature | Status | Quality |
|---------|--------|---------|
| Syntax highlighting | DONE | Good — keywords, strings, interpolation, numbers, types |
| Diagnostics (errors on save) | DONE | Good — real parser + HM type errors shown inline |
| Hover (all identifiers) | **DONE (2026-07-07)** | **Good — shows inferred types for all identifiers, params, locals, struct fields** |
| Hover (fn signatures) | **DONE (2026-07-07)** | **Good — full fn signature with inferred param types + return type** |
| Hover (builtins) | **DONE (2026-07-07)** | **Good — 70+ builtins with one-line documentation** |
| Goto-definition (Ctrl+Click) | **DONE (2026-07-07)** | **Good — finds all local bindings including match arms, try/catch, tuple destructuring** |
| Completions | DONE | Enhanced — shows inferred types in completion detail |
| Document symbols (outline) | DONE | Good — fn, type, enum, trait, top-level variables |
| Debugger (DAP) | DONE | Working — compile → lldb-dap with DWARF breakpoints |
| Cross-module goto-def | **DONE (2026-07-07)** | **Good — searches forge/ subdirectory + import path fix** |

---

## What's Missing / Weak (priority order)

### P0 — Must Fix (users will notice immediately)

#### 1. Hover: Show inferred types for ALL identifiers
**Current:** Only shows types for top-level fns and stdlib. Local variables, function params, struct fields — no hover info.
**Needed:** When hovering over ANY identifier, show its inferred type. The HM inferer already computes this (`nodeTypes: Map<Expr, NovaType>`) — it's just not being looked up properly.

**Fix in `LspAnalyzer.kt`:**
- `findNodeTypeAt()` currently does an exact line+col match — this misses most expressions because the span covers multiple columns. Need to match "cursor is WITHIN the span" (col >= start.col AND col < end.col, or the word at cursor matches an Ident node).
- For local variables: walk into `FnDecl.body` to find `AssignStmt` targets and their inferred types.
- For function params: show `paramName: InferredType` (from `nodeTypes` on the param's `Ident` node).
- For struct field access `obj.field`: resolve the struct type, show `field: FieldType`.

**Example of what should work:**
```
let x = 42          // hover on 'x' → "x: int"
let name = "hello"  // hover on 'name' → "name: string"
let xs = [1, 2, 3]  // hover on 'xs' → "xs: List<int>"
let p = Point{...}  // hover on 'p' → "p: Point"
```

---

#### 2. Hover: Show full function signature with inferred param types
**Current:** Shows `fn foo(a, b)` — just param names, no types (unless source-annotated).
**Needed:** Show `fn foo(a: int, b: string) -> Result<int>` using the inferer's resolved types.

**Fix:** After the `FnDecl` match in `getHover()`, look up each param's inferred type from `nodeTypes`. The inferer already resolves these — wire them into the display string.

---

#### 3. Hover: Show struct/type field info with types
**Current:** Shows `type Point { x: Int, y: Int }` — raw source type names.
**Needed:** When hovering on a struct constructor or type name, show all fields with their resolved types. When hovering on a field access like `p.x`, show which struct it belongs to and the field type.

---

#### 4. Goto-definition: Find local variable definitions inside functions
**Current:** `findLocalDefRecursive` exists but only finds `AssignStmt` and `ForStmt`. Misses `let` bindings nested in `match` arms, `try/catch` blocks, `if-let` patterns.
**Needed:** Handle all statement types that introduce bindings. Also: when Ctrl+Clicking a function CALL like `fib(n)`, jump to the `fn fib(...)` definition (already works for top-level, but verify it works for all call patterns including method calls `obj.method()`).

---

#### 5. Goto-definition: Cross-file for Forge modules and stdlib
**Current:** Follows `import` statements to find module files. But Forge modules (`forge_http`, `forge_json`, etc.) live in a specific directory and many builtins (`spawn`, `channel`, `send`, `receive`, `pmap`, `monitor`) have no source location.
**Needed:**
- For builtins: show a hover with the signature + "(builtin)" label instead of jumping nowhere.
- For Forge modules: resolve `import forge_http` → `forge/forge_http.nova` (or `lib/forge_http.nova`).
- For `import X as Y`: resolve `Y.func` → definition in `X.nova`.

---

### P1 — Important (makes the experience feel professional)

#### 6. Completions: Context-aware suggestions
**Current:** Returns ALL keywords + ALL stdlib + ALL top-level symbols, always. No filtering.
**Needed:**
- After a dot (`obj.`): show only fields/methods of that struct type.
- Inside a function: show local variables + params + in-scope imports.
- After `import `: show available module names (scan `lib/` directory).
- After `match x` → suggest enum variants of x's type.

---

#### 7. Completions: Show type info in completion items
**Current:** Completion items show `"detail": "fn foo(a, b)"` — no types.
**Needed:** Show inferred types in completion detail: `"detail": "fn foo(a: int, b: int) -> int"`.

---

#### 8. Hover: Show documentation for builtins
**Current:** Stdlib functions show the type scheme — `"print: (any) -> unit"`.
**Needed:** Add a one-line description:
```
fn spawn(closure) -> int
Spawns a new green process. Returns the process ID (pid).
```
This would be a hardcoded doc-string map for the ~50 builtins (spawn, channel, send, receive, select, monitor, pmap, pfilter, map, filter, reduce, push, pop, len, str, int, float, sort, contains, starts_with, ends_with, split, join, replace, trim, time_ms, sleep_ms, cpu_count, channel_bounded, assert, assert_eq, assert_near, panic, type_of, ...).

---

#### 9. Find References / Rename Symbol
**Current:** Not implemented.
**Needed:** "Find All References" (Shift+F12) — scan the current file for all uses of a symbol. "Rename Symbol" (F2) — rename all occurrences. These are standard LSP features (`textDocument/references`, `textDocument/rename`).

**Fix in `LspServer.kt`:** Add capability declarations + handlers. In `LspAnalyzer.kt`: walk the AST and collect all `Ident` nodes matching the target name + scope.

---

#### 10. Signature Help (parameter hints)
**Current:** Not implemented.
**Needed:** When typing `foo(` → show `fn foo(a: int, b: string)` with the current parameter highlighted. Standard LSP `textDocument/signatureHelp`.

---

### P2 — Nice to Have (polish)

#### 11. Semantic Tokens (richer highlighting)
**Current:** TextMate grammar only (regex-based). Can't distinguish between function calls, type names, variables, and struct fields.
**Needed:** LSP semantic tokens (`textDocument/semanticTokens/full`) — the server tells VS Code "this identifier is a function call" / "this is a type name" / "this is a struct field". Enables much richer color themes.

---

#### 12. Code Actions (quick fixes)
- "Import module" when using an unimported name.
- "Add type annotation" on a function param.
- "Wrap in try/catch" around an expression that can fail.

---

#### 13. Workspace Symbol Search (Ctrl+T)
**Current:** Not implemented.
**Needed:** `workspace/symbol` — search across all `.nova` files in the workspace for functions, types, enums by name.

---

#### 14. Inlay Hints (inline type display)
Show inferred types inline next to variable names (like Rust/TypeScript):
```
let x /*: int*/ = 42
let name /*: string*/ = "hello"
```
LSP `textDocument/inlayHint`.

---

## Architecture Notes

### What DOESN'T need to change
- `LspServer.kt` — the JSON-RPC plumbing is solid. Just add new `when` branches for new methods.
- `extension.ts` — the VS Code client is standard `vscode-languageclient`. New server capabilities are picked up automatically.
- `nova.tmLanguage.json` — syntax highlighting is good enough. Semantic tokens (P2) would enhance, not replace.

### What DOES need to change
- **`LspAnalyzer.kt`** — this is where 90% of the work is:
  - Better hover: resolve types for all expressions, not just top-level declarations.
  - Better goto-def: recursive AST walk with scope tracking.
  - Context-aware completions: resolve the type at cursor position, suggest members.
  - New features: references, rename, signature help.
- **Stdlib.kt (or new file)** — a builtin documentation map (name → signature + one-line doc).
- **`LspServer.kt`** — add capability declarations for new features (references, rename, signatureHelp, semanticTokens, inlayHint) + handler methods.

### Build & Test
```bash
# Build the LSP server (Kotlin/Gradle)
cd nova-compiler && ./gradlew build

# Copy the binary to the extension
cp build/libs/nova-compiler.jar ../nova-vscode/bin/nova-compiler.exe

# Build the VS Code extension
cd ../nova-vscode && npm run compile

# Test: open a .nova file in VS Code, check Output → NOVA Language Server
```

---

## Priority Summary

| # | Feature | Impact | Effort | Status |
|---|---------|--------|--------|--------|
| 1 | Hover: inferred types for all identifiers | HIGH | MEDIUM | **✅ DONE** |
| 2 | Hover: full fn signature with inferred types | HIGH | LOW | **✅ DONE** |
| 3 | Hover: struct/type/enum/trait field info | HIGH | LOW | **✅ DONE** |
| 4 | Goto-def: all local bindings (match/try/tuple) | HIGH | MEDIUM | **✅ DONE** |
| 5 | Goto-def: Forge modules + import path fix | HIGH | MEDIUM | **✅ DONE** |
| 6 | Completions: context-aware (dot, imports) | HIGH | HIGH | **✅ DONE** |
| 7 | Completions: show inferred types | MEDIUM | LOW | **✅ DONE** |
| 8 | Hover: builtin documentation (70+ builtins) | MEDIUM | LOW | **✅ DONE** |
| 9 | Find references + rename | MEDIUM | HIGH | **✅ DONE** |
| 10 | Signature help (param hints on `(`) | MEDIUM | MEDIUM | **✅ DONE** |
| 11 | Semantic tokens | LOW | HIGH | **✅ DONE** |
| 12 | Code actions | LOW | HIGH | **✅ DONE** |
| 13 | Workspace symbols | LOW | MEDIUM | **✅ DONE** |
| 14 | Inlay hints (inline type display) | LOW | MEDIUM | **✅ DONE** |

**ALL 14 features DONE.** Server version 0.4.0. Full feature set: hover (all identifiers, fn signatures, builtins), goto-def, signature help, inlay hints, dot completions, find refs + rename, semantic tokens, code actions (auto-import/wrap-try/add-type-annotation), workspace symbols (Ctrl+T cross-file search).
