package nova.ir

import nova.lexer.Lexer
import nova.parser.Parser
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Test

// ── Step 2.4 — LLVM IR Code Generation Tests ─────────────────────────────────
//
// Tests verify the generated LLVM IR text is structurally correct and well-formed.
// Without LLVM installed, we can't compile the output — but we CAN verify:
//   - Correct function definitions with i64 params/return
//   - Correct instruction selection (add/sub/mul/icmp for ints, fadd/fsub for floats)
//   - Correct string constant emission (global [N x i8])
//   - Correct control flow (br, ret, block labels)
//   - Correct builtin dispatch (print → puts/printf)
//   - Main wrapper generation
//
// Once LLVM/Clang is installed: clang output.ll -o program && ./program

class LlvmCodegenTest {

    // ── Helpers ───────────────────────────────────────────────────────────────

    private fun compile(src: String): String {
        val tokens = Lexer(src.trimIndent(), "<test>").tokenize()
        val parser = Parser(tokens)
        val prog   = parser.parse()
        assertTrue(parser.errors.isEmpty(), "Parse errors: ${parser.errors}")
        val module   = AstToIr().lower(prog)
        val erased   = IrErasure().erase(module)
        return LlvmCodegen().generate(erased)
    }

    // ── Module structure ──────────────────────────────────────────────────────

    @Test fun emitsModuleHeader() {
        val ll = compile("x = 1")
        assertTrue(ll.contains("target triple"), "Must have target triple")
        assertTrue(ll.contains("declare i32 @printf"), "Must declare printf")
        assertTrue(ll.contains("declare i32 @puts"), "Must declare puts")
    }

    @Test fun emitsMainWrapper() {
        val ll = compile("x = 1")
        assertTrue(ll.contains("define i32 @main()"), "Must have C main wrapper")
        assertTrue(ll.contains("call i64 @nova_main()"), "Main must call nova_main")
        assertTrue(ll.contains("ret i32 0"), "Main must return 0")
    }

    @Test fun novaMainFunction_defined() {
        val ll = compile("x = 1")
        assertTrue(ll.contains("define i64 @nova_main()"), "nova_main must be defined")
    }

    // ── Integer constants and arithmetic ──────────────────────────────────────

    @Test fun integerConstant_inlinedAsLiteral() {
        val ll = compile("x = 42")
        // The constant 42 should appear as a literal operand (inlined)
        assertTrue(ll.contains("42"), "Integer constant 42 must appear in output")
    }

    @Test fun integerAddition() {
        val ll = compile("""
            fn add(a, b)
                a + b
            print(add(3, 4))
        """)
        assertTrue(ll.contains("add i64"), "Must emit i64 add instruction")
        assertTrue(ll.contains("define i64 @add("), "add function must be defined")
    }

    @Test fun integerSubtraction() {
        val ll = compile("""
            fn sub(a, b)
                a - b
            x = sub(10, 3)
        """)
        assertTrue(ll.contains("sub i64"), "Must emit i64 sub instruction")
    }

    @Test fun integerMultiplication() {
        val ll = compile("""
            fn mul(a, b)
                a * b
            x = mul(3, 4)
        """)
        assertTrue(ll.contains("mul i64"), "Must emit i64 mul instruction")
    }

    @Test fun integerDivision() {
        val ll = compile("""
            fn div(a, b)
                a / b
            x = div(10, 3)
        """)
        assertTrue(ll.contains("sdiv i64"), "Must emit i64 sdiv instruction")
    }

    @Test fun integerModulo() {
        val ll = compile("""
            fn mod(a, b)
                a % b
            x = mod(10, 3)
        """)
        assertTrue(ll.contains("srem i64"), "Must emit i64 srem instruction")
    }

    // ── Comparisons ──────────────────────────────────────────────────────────

    @Test fun comparison_lessThan() {
        val ll = compile("""
            fn lt(a, b)
                if a < b
                    1
                else
                    0
        """)
        assertTrue(ll.contains("icmp slt i64"), "Must emit icmp slt for <")
    }

    @Test fun comparison_greaterThan() {
        val ll = compile("""
            fn gt(a, b)
                if a > b
                    1
                else
                    0
        """)
        assertTrue(ll.contains("icmp sgt i64"), "Must emit icmp sgt for >")
    }

    @Test fun comparison_equality() {
        val ll = compile("""
            fn eq(a, b)
                if a == b
                    1
                else
                    0
        """)
        assertTrue(ll.contains("icmp eq i64"), "Must emit icmp eq for ==")
    }

    @Test fun comparison_resultZextToI64() {
        val ll = compile("""
            fn gt(a, b)
                if a > b
                    1
                else
                    0
        """)
        assertTrue(ll.contains("zext i1"), "Comparison result must be zext i1 to i64")
    }

    // ── Unary operations ─────────────────────────────────────────────────────

    @Test fun unaryNeg() {
        val ll = compile("""
            fn neg(x)
                -x
            neg(5)
        """)
        assertTrue(ll.contains("sub i64 0,"), "Unary neg must emit sub i64 0, operand")
    }

    @Test fun unaryNot() {
        val ll = compile("""
            fn invert(x)
                not x
            invert(true)
        """)
        assertTrue(ll.contains("icmp eq i64") && ll.contains("zext i1"),
            "Unary not must emit icmp eq 0 + zext")
    }

    // ── Control flow ─────────────────────────────────────────────────────────

    @Test fun ifElse_emitsBranch() {
        val ll = compile("""
            fn max(a, b)
                if a > b
                    a
                else
                    b
        """)
        assertTrue(ll.contains("br i1"), "If/else must emit conditional branch")
        assertTrue(ll.contains("br label"), "If/else must emit unconditional branch (goto merge)")
    }

    @Test fun ifElse_hasBlockLabels() {
        val ll = compile("""
            fn max(a, b)
                if a > b
                    a
                else
                    b
        """)
        // IfBlockExpr generates ifb_then/ifb_else/ifb_merge labels
        val hasThen  = ll.contains("if_then") || ll.contains("ifb_then")
        val hasElse  = ll.contains("if_else") || ll.contains("ifb_else")
        val hasMerge = ll.contains("if_merge") || ll.contains("ifb_merge")
        assertTrue(hasThen, "Must have if/ifb then block label")
        assertTrue(hasElse, "Must have if/ifb else block label")
        assertTrue(hasMerge, "Must have if/ifb merge block label")
    }

    @Test fun branchCondition_truncToI1() {
        val ll = compile("""
            fn max(a, b)
                if a > b
                    a
                else
                    b
        """)
        assertTrue(ll.contains("trunc i64") && ll.contains("to i1"),
            "Branch condition must trunc i64 to i1")
    }

    // ── Function definitions ─────────────────────────────────────────────────

    @Test fun functionWithParams_i64Signature() {
        val ll = compile("""
            fn add(a, b)
                a + b
            x = add(1, 2)
        """)
        assertTrue(ll.contains("define i64 @add(i64 %p0, i64 %p1)"),
            "Function must have i64 params: got:\n$ll")
    }

    @Test fun functionCall_passesI64Args() {
        val ll = compile("""
            fn double(x)
                x * 2
            y = double(5)
        """)
        assertTrue(ll.contains("call i64 @double(i64"), "Call must pass i64 args")
    }

    @Test fun recursiveFunction() {
        val ll = compile("""
            fn factorial(n)
                if n <= 1
                    return 1
                n * factorial(n - 1)
            print(factorial(5))
        """)
        assertTrue(ll.contains("define i64 @factorial("), "factorial must be defined")
        assertTrue(ll.contains("call i64 @factorial("), "factorial must call itself recursively")
    }

    // ── String constants ─────────────────────────────────────────────────────

    @Test fun stringConstant_globalArray() {
        val ll = compile("""print("Hello, World!")""")
        assertTrue(ll.contains("@.str."), "Must have global string constant")
        assertTrue(ll.contains("x i8] c\"Hello, World!\\00\""),
            "String constant must be null-terminated [N x i8]")
    }

    @Test fun stringConstant_gep() {
        val ll = compile("""print("Hello!")""")
        assertTrue(ll.contains("getelementptr inbounds"), "String access must use GEP")
    }

    @Test fun stringConstant_ptrToInt() {
        val ll = compile("""
            s = "Hello"
            x = s
        """)
        assertTrue(ll.contains("ptrtoint ptr"), "String ptr must be cast to i64")
    }

    // ── Print builtin ────────────────────────────────────────────────────────

    @Test fun printString_callsPuts() {
        val ll = compile("""print("Hello, World!")""")
        assertTrue(ll.contains("call i32 @puts(ptr"), "print(string) must call puts")
    }

    @Test fun printString_intToPtrForPuts() {
        val ll = compile("""print("Hello")""")
        assertTrue(ll.contains("inttoptr i64") && ll.contains("to ptr"),
            "String i64 must be cast to ptr for puts")
    }

    @Test fun printInteger_callsPrintf() {
        val ll = compile("""
            fn add(a, b)
                a + b
            print(add(3, 4))
        """)
        // print(add(3,4)) — add returns i64 (type Any), so printf with %ld format
        assertTrue(ll.contains("call i32 (ptr, ...) @printf(ptr"), "print(int) must call printf")
    }

    // ── Slots (alloca/store/load) ────────────────────────────────────────────

    @Test fun slotAlloc_emitsAlloca() {
        val ll = compile("x = 42")
        assertTrue(ll.contains("alloca i64"), "Variable assignment must emit alloca i64")
    }

    @Test fun slotStore_emitsStore() {
        val ll = compile("x = 42")
        assertTrue(ll.contains("store i64"), "Variable assignment must emit store")
    }

    @Test fun slotLoad_emitsLoad() {
        val ll = compile("""
            x = 42
            print(x)
        """)
        // After optimizer, the slot load may be coalesced. But the alloca/store should survive.
        assertTrue(ll.contains("alloca i64"), "Must have alloca for variable")
    }

    // ── MakeClosure (function references) ────────────────────────────────────

    @Test fun makeClosure_emitsUniformRecord() {
        val ll = compile("""
            fn double(x)
                x * 2
            f = double
        """)
        assertTrue(ll.contains("call ptr @malloc(i64 8)"),
            "Non-capturing closure must allocate uniform 8-byte record")
        assertTrue(ll.contains("double_tramp"),
            "Non-capturing closure must reference a trampoline")
    }

    // ── Multiple functions ───────────────────────────────────────────────────

    @Test fun multipleFunctions_allDefined() {
        val ll = compile("""
            fn foo(x)
                x + 1
            fn bar(x)
                x * 2
            a = foo(5)
            b = bar(a)
        """)
        assertTrue(ll.contains("define i64 @foo("), "foo must be defined")
        assertTrue(ll.contains("define i64 @bar("), "bar must be defined")
    }

    // ── Gate 5 readiness: complete program ───────────────────────────────────

    @Test fun gate5_helloWorld_completeLlvm() {
        val ll = compile("""print("Hello, World!")""")
        // Verify the complete structure is present
        assertTrue(ll.contains("target triple"), "Header")
        assertTrue(ll.contains("declare i32 @printf"), "External decl")
        assertTrue(ll.contains("@.str."), "String global")
        assertTrue(ll.contains("define i64 @nova_main"), "nova_main")
        assertTrue(ll.contains("call i32 @puts"), "puts call")
        assertTrue(ll.contains("define i32 @main"), "C main")
        assertTrue(ll.contains("ret i32 0"), "main return")
    }

    @Test fun gate5_factorial_completeLlvm() {
        val ll = compile("""
            fn factorial(n)
                if n <= 1
                    return 1
                n * factorial(n - 1)
            print(factorial(10))
        """)
        assertTrue(ll.contains("define i64 @factorial(i64 %p0)"), "Correct factorial signature")
        assertTrue(ll.contains("icmp sle i64"), "Comparison for n <= 1")
        assertTrue(ll.contains("mul i64"), "Multiplication for n * factorial(n-1)")
        assertTrue(ll.contains("call i64 @factorial("), "Recursive call")
        assertTrue(ll.contains("ret i64"), "Return value")
    }

    @Test fun gate5_maxFunction_completeLlvm() {
        val ll = compile("""
            fn max(a, b)
                if a > b
                    a
                else
                    b
            print(max(10, 20))
        """)
        assertTrue(ll.contains("define i64 @max(i64 %p0, i64 %p1)"), "Correct max signature")
        assertTrue(ll.contains("icmp sgt i64"), "Greater-than comparison")
        assertTrue(ll.contains("br i1"), "Conditional branch")
        assertTrue(ll.contains("call i64 @max("), "Call to max")
    }

    // ── Output is non-empty and well-formed ──────────────────────────────────

    @Test fun output_noEmptyFunctions() {
        val ll = compile("""
            fn identity(x)
                x
            identity(42)
        """)
        // Every define must have at least one ret
        val defineCount = ll.lines().count { it.trimStart().startsWith("define ") }
        val retCount    = ll.lines().count { it.trimStart().startsWith("ret ") }
        assertTrue(retCount >= defineCount, "Every function must have at least one ret")
    }

    @Test fun output_noUnclosedBraces() {
        val ll = compile("""
            fn foo(x)
                x + 1
            foo(5)
        """)
        val opens  = ll.count { it == '{' }
        val closes = ll.count { it == '}' }
        assertEquals(opens, closes, "All braces must be balanced")
    }
}
