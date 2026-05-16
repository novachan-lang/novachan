# Phase 1: Pre-Implementation Fixes

**Adversarial review found 8 CRITICAL, 12 SERIOUS, 4 CONCERN issues.**
**ALL critical and serious issues resolved here before any code is written.**

---

## CRITICAL FIXES

### C1: `else` Disambiguation — Lexer + Parser Rules

**Problem:** `else` serves two roles: `if/else` blocks AND inline error-default. Same token, different semantics.

**Fix: Positional disambiguation. The lexer emits ONE `else` token. The parser disambiguates by context.**

Rule: `else` is an **error-default operator** when:
- It appears on the SAME LINE as its left-hand expression (no NEWLINE token between them)
- OR it appears after a NEWLINE but the left-hand expression is NOT an `if` block

`else` is an **if/else block terminator** when:
- It appears at the START of a line (after NEWLINE), following an `if` block body

**The concrete rule the parser uses:**

When parsing an `if` expression:
1. Parse `if COND BODY`
2. If next token is `NEWLINE` followed by `else` at SAME INDENT LEVEL → this is an if/else block. Consume the `else` and parse the else-body.
3. If next token is `else` (same line, no NEWLINE in between) → this is a single-line if/else expression. Consume `else` and parse `ELSE_EXPR`.

When parsing any other expression:
- After parsing `EXPR`, if the next token (possibly after NEWLINE) is `else` at LOWER or SAME indent level → this is an error-default. Parse `DEFAULT_EXPR`.

**Composition rule** — `if ... else ... else ...`:
```nova
result = if cond compute() else default_value else other_default
```
This parses as: `(if cond compute() else default_value) else other_default`.
The if/else captures the FIRST `else`. The outer error-default captures the SECOND `else`.
This is valid: the if/else expression itself might be failable (if compute() is failable).

**The parser NEVER needs to backtrack.** It determines which `else` role applies from:
1. Whether it is currently inside an `if` expression (if yes, first `else` is if/else)
2. Whether a NEWLINE with DEDENT appears before `else` (if yes and not in if → error-default on outer scope)

---

### C2: String Interpolation Nested Braces — Lexer Algorithm

**Problem:** `"Result: {map_fn({"key": value})}"` has nested braces inside interpolation.

**Fix: The lexer tracks brace depth when inside string interpolation.**

The lexer has these states for strings:
```
STRING_NORMAL       — scanning regular string characters
STRING_INTERPOLATED — inside { } of an interpolation expression
```

When lexing a `"..."` string:
1. Scan characters normally, collecting them
2. When `\{` is seen → emit literal `{` into the string content (escaped)
3. When `{` is seen (not escaped):
   - `brace_depth = 1`
   - Emit STRING_PART token (everything scanned so far)
   - Enter INTERPOLATION mode: scan tokens normally (recursive lex call) until `brace_depth == 0`
   - When `{` seen inside interpolation → `brace_depth++`
   - When `}` seen inside interpolation → `brace_depth--`; if `brace_depth == 0` → emit INTERP_END, resume STRING
4. When `"` is seen → string is complete

**Token sequence for `"Hello {name}, you have {count} items"`:**
```
STRING_PART("Hello ")
INTERP_START
IDENTIFIER(name)
INTERP_END
STRING_PART(", you have ")
INTERP_START
IDENTIFIER(count)
INTERP_END
STRING_PART(" items")
STRING_END
```

**Why this works for nested braces:**
- `{fn({"key": val})}` → `{` opens interp (depth=1), `{` inside fn arg (depth=2), `}` closes map (depth=1), `)` closes fn, `}` closes interp (depth=0). Correct.

**For Phase 1 interpreter simplification:** The interpreter can treat STRING_PART + INTERP tokens as a single string at evaluation time. The type inference engine only needs to know the final type is `string`.

---

### C3: Single-Line vs Multi-Line `if` — Explicit Newline Rule

**Problem:** Parser doesn't know if `if a > b a else b` is single-line until it parses the whole thing.

**Fix: The NEWLINE token is the deterministic boundary.**

Rule: **If a NEWLINE token appears inside an `if` expression BEFORE the `else`, it is a MULTI-LINE if.**

```
if COND NEWLINE → multi-line: expect INDENT, parse block body, expect DEDENT
if COND [no NEWLINE] EXPR → single-line: parse EXPR as then-branch, expect `else`, parse EXPR as else-branch
```

The parser NEVER backtracks. It peeks at the token after `COND`:
- If next token after COND is NEWLINE → multi-line if
- Otherwise → single-line if (must have `else` before any NEWLINE, else compile error)

Single-line if WITHOUT else:
```nova
if a > b print("yes")    // ← no else: valid as statement (returns Nothing)
```

Single-line if WITH else:
```nova
result = if a > b a else b    // ← must have else to return a value
```

**The parser enforces:** single-line if used as an expression (in assignment, return, argument position) MUST have an `else` branch. Without `else`, a single-line if is a statement (void).

---

### C4: Sum-Type Unification for `else` — Inference Algorithm Extension

**Problem:** Standard HM unification doesn't handle `(A or Error) else A → A`.

**Fix: Add `else` as a first-class inference rule, not a function call.**

The inference engine handles `expr else default` as a SPECIAL FORM with its own constraint rule:

```
Rule ELSE:
  If typeof(expr) = T1 or T2,
  and typeof(default) = T1,
  then typeof(expr else default) = T1

  Constraint generated:
    fresh T_success
    constrain: T_expr = T_success or T_error  (for any T_error)
    constrain: T_default = T_success
    result type = T_success
```

**For nested `else` through function calls** (`parse_int(env("PORT")) else 8080`):

The inference engine propagates "failable context" through the expression tree:

1. `env("PORT")` → type `string or Error`. In failable context → the `string` part flows to the outer call.
2. `parse_int(string)` → type `int or Error`. The entire expression `parse_int(env("PORT"))` has type `int or Error`.
3. `... else 8080` → unwraps to `int`. Constraint: T_default = int. Solved: result = int.

**The key insight:** `else` applies to the ENTIRE left expression, not just the outermost function call. The constraint solver sees `parse_int(env("PORT"))` as a potentially-failable expression producing `int or Error`, and `else 8080` unwraps it.

**Implementation:** The `else` case in the constraint generator is NOT a binary operator lookup. It is a special case that:
1. Infers the type of the left expression
2. Checks if it's a sum type containing an error variant
3. Generates the unwrapping constraint
4. Sets result type to the non-error variant

---

### C5: Cross-Process Channel Inference — Phase 1 Scope

**Problem:** Module-level inference boundaries conflict with cross-process channel type inference.

**Fix: Phase 1 interpreter uses WHOLE-PROGRAM inference. All functions in scope simultaneously.**

For the interpreter, there are no module boundaries. Every function definition in the same program is visible to the inference engine simultaneously. Cross-process channel inference works because:
- `ch` variable is shared (by reference in the environment)
- All constraints from all processes that use `ch` are collected in one constraint set
- Unification runs once over the entire constraint set

Module-level boundaries are a Phase 2+ concern. The Phase 1 gate explicitly says "single-file programs." This is correct and sufficient for validating the inference algorithm.

**What this means for implementation:** The type inference engine in Phase 1 does a SINGLE PASS over the entire program's AST, collecting ALL constraints, then solves them all at once. No incremental inference, no module interfaces.

---

### C6: Ownership Checking Timing — Static, Conservative

**Problem:** Interpreter doesn't specify when ownership is checked: compile-time (static) or run-time (dynamic).

**Fix: Static ownership analysis, conservative, runs BEFORE execution.**

The interpreter has TWO phases:
1. **Analysis phase:** Parse → Type Inference → Ownership Analysis → validates all rules
2. **Execution phase:** Evaluates the typed, ownership-checked AST

Ownership analysis is CONSERVATIVE: if ANY branch might send a value, the value is considered sent on ALL branches.

```nova
data = [1, 2, 3]
if condition
    send(ch, data)
print(data)    // COMPILE ERROR — data might be sent on the if branch
```

This matches the compiler's behavior. Programs that pass the interpreter's ownership check will also pass the compiler's ownership check.

**Why conservative is correct:** The alternative (runtime checking) would let programs pass the interpreter that the compiler later rejects. That makes the interpreter useless as a validation tool.

**Implementation:** Ownership analysis is a separate pass over the typed AST. It produces an OwnershipMap: `variable → {live | dead (sent at line N)}`. Any use of a dead variable is a compile error.

---

### C7: Process Simulation — OS Threads, Not Coroutines

**Problem:** Kotlin coroutines share heap, have no isolation, diverge from NOVA process semantics.

**Fix: Simulate NOVA processes as OS threads (Java Thread). Deep-clone all values on channel send.**

**Why OS threads, not coroutines:**
- OS threads have separate stacks — memory isolation is closer to NOVA processes
- A crash (unhandled exception) in one thread doesn't corrupt others
- Deep clone on send ensures the sender and receiver have INDEPENDENT copies

**Channel implementation:** `LinkedBlockingQueue<Any>` — correct FIFO semantics.

**Deep clone on send:** When `send(ch, value)` is evaluated:
1. Deep-clone the value (recursive copy of all sub-values)
2. Put the clone in the channel queue
3. Mark the ORIGINAL variable as dead in the ownership map
4. The sender cannot access the original after this point (enforced by ownership check from C6)

**Why deep clone and not move:** In the interpreter, values are Kotlin objects on the JVM heap. "Moving" a Kotlin object between threads without cloning would share the reference — violating isolation. Deep clone is the only way to enforce independence. Yes, it's expensive. The interpreter prioritizes CORRECTNESS over performance.

**Supervision simulation:** Each process thread registers with a supervisor thread. The supervisor catches `Throwable` from child threads and applies the restart strategy.

```kotlin
class ProcessSupervisor {
    fun supervise(process: Thread, strategy: RestartStrategy) {
        process.setUncaughtExceptionHandler { _, error ->
            when (strategy) {
                RestartStrategy.ALWAYS -> restartProcess(process)
                RestartStrategy.NEVER -> recordCrash(error)
                RestartStrategy.TRANSIENT -> if (error !is NormalExit) restartProcess(process)
            }
        }
    }
}
```

---

### C8: Concurrent Program Testing — Non-Determinism Strategy

**Problem:** Programs 6, 8, 10 are concurrent. Tests on concurrent programs are non-deterministic.

**Fix: Three-layer testing strategy for concurrent programs.**

**Layer 1: Order-independent assertions**

For Program 6 (word_count), the test checks TOTAL word count, not the ORDER of per-file results:
```kotlin
@Test fun wordCountTotalIsCorrect() {
    val output = runProgram(PROGRAM_6)
    assertContains(output, "Total: 9 words")  // sum of all files
    // NOT: assertOrderedOutput(["a.txt: 3 words", "b.txt: 3 words", "c.txt: 3 words"])
}
```

**Layer 2: Repeat for flakiness detection**

Any concurrent test runs 5 times. If it fails even once, it fails the gate.
```kotlin
@RepeatedTest(5) fun concurrentWordCount() { ... }
```

**Layer 3: Deterministic subset tests**

For each concurrent program, also write a DETERMINISTIC version with a single process, testing the business logic without concurrency. This is the primary correctness test. The concurrent version tests the scheduling and channel semantics.

**Programs 5, 7, 8: Stub stdlib modules** (see S9 fix below).

---

## SERIOUS FIXES

### S1: INDENT/DEDENT Suppression Inside Brackets

**Rule:** The lexer tracks `bracket_depth`:
- `(`, `[`, `{` → `bracket_depth++`
- `)`, `]`, `}` → `bracket_depth--`
- When `bracket_depth > 0`: suppress NEWLINE, INDENT, DEDENT tokens
- When `bracket_depth == 0`: normal indentation processing

**Tab characters:** Tab characters in source code → COMPILE ERROR: "Tab characters are not allowed. Use 4 spaces for indentation." Error includes file name, line number, column number. No silent conversion.

**Multiline strings (`"""..."""`):** The lexer enters a MULTILINE_STRING state when it sees `"""`. In this state, ALL whitespace (including NEWLINE) is part of the string content until the closing `"""`. INDENT/DEDENT suppressed.

---

### S2: `for` Expression vs Statement — Parser Context Rule

**Rule:** `for` is an EXPRESSION when it appears in:
- Assignment position: `result = for ...`
- Return position: `return for ...`
- Argument position: `fn(for ...)`
- Any position where an expression is expected

`for` is a STATEMENT when it appears as a standalone statement (not assigned, not returned, not passed).

**Parser implementation:** The parser determines expression vs statement context BEFORE parsing the `for`. If it sees `for` at the start of a statement, it's a statement. If it sees `for` while parsing an expression, it's an expression. This is a standard recursive descent context.

---

### S3: `else` Operator Precedence

**Fix:** Add `else` to the precedence table.

Complete operator precedence (lowest to highest):
```
Level 1:  = (assignment) — RIGHT associative
Level 2:  else (error-default) — RIGHT associative
Level 3:  or (boolean or, type union)
Level 4:  and
Level 5:  not (unary)
Level 6:  == != < > <= >=
Level 7:  + - (binary)
Level 8:  * / %
Level 9:  ** (power) — RIGHT associative
Level 10: unary - not
Level 11: . () [] (member access, call, index)
```

`else` at level 2 (just above assignment) means:
```nova
result = a + try_thing() else default * 2
```
Parses as: `result = ((a + try_thing()) else (default * 2))`

Which is: try `a + try_thing()` (as a whole), if it fails, use `default * 2`. Correct.

---

### S4: Stdlib Type Registry — Required for Phase 1

**Fix:** Phase 1 includes a built-in type registry for all stdlib functions used in the 10 programs.

The type registry is a Kotlin map: `String → FunctionType`. It covers:

```kotlin
val STDLIB_TYPES = mapOf(
    "print" to FunctionType(params = listOf(Type.PRINTABLE), ret = Type.NOTHING),
    "read_file" to FunctionType(params = listOf(Type.STRING), ret = Type.STRING_OR_ERROR),
    "env" to FunctionType(params = listOf(Type.STRING), ret = Type.STRING_OR_ERROR),
    "parse_int" to FunctionType(params = listOf(Type.STRING), ret = Type.INT_OR_ERROR),
    "http.serve" to FunctionType(params = listOf(Type.INT, Type.ROUTES_FN), ret = Type.NOTHING),
    "routes.get" to FunctionType(params = listOf(Type.STRING, Type.HANDLER_FN), ret = Type.NOTHING),
    "routes.post" to FunctionType(params = listOf(Type.STRING, Type.HANDLER_FN), ret = Type.NOTHING),
    "ai.load" to FunctionType(params = listOf(Type.STRING), ret = Type.AI_MODEL),
    "channel" to FunctionType(params = listOf(), ret = Type.CHANNEL_GENERIC),
    "spawn" to FunctionType(params = listOf(Type.PROCESS_FN), ret = Type.PROCESS_HANDLE),
    "send" to FunctionType(params = listOf(Type.CHANNEL_GENERIC, Type.ANY), ret = Type.NOTHING),
    "receive" to FunctionType(params = listOf(Type.CHANNEL_GENERIC), ret = Type.ANY),
    "supervise" to FunctionType(params = listOf(Type.PROCESS_HANDLE, Type.VARARGS), ret = Type.NOTHING),
    "cpu_count" to FunctionType(params = listOf(), ret = Type.INT),
    // ... complete for all stdlib functions used in 10 programs
)
```

---

### S5: Stub Stdlib Modules for Programs 5, 7, 8

**Fix:** Phase 1 includes minimal stub implementations of `http`, `ai`, `web`.

**`http` stub:**
- `http.serve(port, fn)` → starts a real HTTP server using Java's `HttpServer`. Handler closure runs in a thread per request. Validates that the routing syntax works.
- `http.json(value)` → converts value to JSON string, returns as HTTP response.

**`ai` stub:**
- `ai.load(path)` → returns a `StubAiModel` that ignores the path
- `StubAiModel.predict(input)` → returns a fixed `Predictions` object with deterministic labels/confidences. Validates that the AI inference syntax and type flow works.

**`web` stub:**
- `web.app(fn)` → calls fn with a stub `UiBuilder` that records UI operations to a string
- Validates that the web DSL syntax compiles and type-checks correctly

These stubs validate LANGUAGE SEMANTICS, not actual functionality. Programs 5, 7, 8 run and produce meaningful output. The validation gate is about language correctness, not http server correctness.

---

### S6: JVM Shared Heap — Deep Clone on Channel Send

Already addressed in C7. All channel sends deep-clone values. Sender's variable is marked dead.

---

### S7: `select` Implementation for Phase 1

**Fix:** `select` implemented as polling with bounded retry.

```kotlin
fun select(vararg channels: NovaChannel<*>): Pair<Int, Any?> {
    val random = Random()
    while (true) {
        val shuffled = channels.indices.toMutableList().also { it.shuffle(random) }
        for (idx in shuffled) {
            val value = channels[idx].queue.poll()  // non-blocking poll
            if (value != null) return Pair(idx + 1, value)
        }
        Thread.sleep(1)  // 1ms sleep between polls to avoid busy-waiting
    }
}
```

This is correct but uses polling, not efficient waiting. For Phase 1 interpreter, this is acceptable. Phase 3 runtime uses efficient kernel-level wait.

The 1ms sleep means `select` has up to 1ms latency. For the 10 validation programs (which test correctness, not latency), this is fine.

---

### S8: REPL Continuation Detection

**Fix:** REPL uses explicit continuation rules without colons.

The REPL determines "input is complete" by these rules in order:

1. **Empty line at indent level 0** → input complete
2. **Token balance:** if any of `(`, `[`, `{` is unclosed → more input expected (implicit continuation)
3. **After block-opening keyword at end of line:** if the last meaningful token before NEWLINE is `fn NAME(ARGS)`, `if COND`, `for VAR in EXPR`, `while COND`, `match EXPR`, `type NAME`, `enum NAME` → next line should be indented → wait for body
4. **Otherwise** → input is complete

The "block-opening keyword at end of line" rule handles:
```
nova> fn add(a, b)
...>     a + b          ← REPL shows "..." prompt, waiting for body
...>                    ← blank line or DEDENT signals end
```

For `else` continuation (R2 concern): the REPL does NOT try to predict whether `else` follows an expression. It evaluates after each complete expression. If the user wants `expr else default`, they write it on ONE LINE. Multi-line `else` for error-default is not supported in REPL mode (works in file mode). This is a documented REPL limitation, not a language limitation.

---

### S9: `continue` Keyword — Add Test Program

Add Program 11 to the validation suite (REPL-only test, not in the 10 core programs):

```nova
// Test: continue keyword
for i in 0..10
    if i % 2 == 0
        continue
    print(i)    // prints: 1 3 5 7 9
```

This validates that `continue` works in the interpreter. Not required for Gate 1-3 validation but required before Phase 1 is declared complete.

---

### S10: `for` Expression List Comprehension — Type Inference

**Fix:** When `for` is used as an expression, its type is `List<T>` where T is the type of the loop body expression.

```nova
doubled = for x in [1, 2, 3]
    x * 2
// typeof(doubled) = List<int>
// type rule: typeof(for var in List<T> body) = List<typeof(body with var: T)]
```

Constraint generated:
```
T_var = element_type(T_iterable)
T_body = infer_in_scope(body, var → T_var)
typeof(for_expr) = List<T_body>
```

---

## DOCUMENT FIXES

### D1: Mark step01_syntax_design.md as Superseded

Add to the top of `step01_syntax_design.md`:
```
⚠ SUPERSEDED — This document contains the ORIGINAL syntax design.
Many decisions were changed by adversarial review.
The AUTHORITATIVE source is: programs_final.md + syntax_fixes.md
Do not use this document for implementation.
```

### D2: Update Engineering Blueprint for Kotlin

The blueprint says "Java" throughout. Change all references:
- "compiler written in Java" → "compiler written in Kotlin (JVM)"  
- "interpreter in Java" → "interpreter in Kotlin"
- "Java threads for process simulation" → "JVM threads (kotlin.concurrent.thread)"
- "Java BlockingQueue" → "java.util.concurrent.LinkedBlockingQueue (used from Kotlin)"
- "JUnit" → "JUnit 5 (with Kotlin test extensions)"

---

## SUMMARY: WHAT PHASE 1 CODE MUST DO

Before writing code, the implementation plan is now:

| Component | Approach | Key fix applied |
|---|---|---|
| Lexer | Hand-written scanner | L2 (string interpolation brace tracking), L3 (bracket depth suppression), S1 (tab = error) |
| Parser | Recursive descent + Pratt | C1 (else disambiguation), C3 (newline boundary for if), P2 (for ctx), S3 (else precedence) |
| Type Inference | Whole-program HM | C4 (else unwrapping rule), C5 (whole-program), S4 (stdlib registry), S10 (for expr type) |
| Ownership Analysis | Static, conservative, pre-execution | C6 (static conservative) |
| Interpreter | JVM threads, deep clone on send | C7 (threads not coroutines), S6 (deep clone), S7 (select polling) |
| Testing | Order-independent + repeated | C8 (flakiness strategy), TEST2 (stub stdlib) |
| REPL | Blank-line signals complete | S8 (continuation rules) |
| Stdlib | Minimal stubs | S5 (http/ai/web stubs) |

**Gate 1 (Phase 1): All 10 programs parse correctly.**
**Gate 2 (Phase 1): All 10 programs type-check correctly with <5% annotations.**
**Gate 3 (Phase 1): All 10 programs pass ownership analysis.**
**Gate 4 (Phase 1): All 10 programs execute correctly in the interpreter and produce expected output.**
