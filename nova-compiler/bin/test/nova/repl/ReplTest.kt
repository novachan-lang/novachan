package nova.repl

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue
import kotlin.test.assertNull
import kotlin.test.assertFalse

class ReplTest {

    private fun repl() = Repl(showTypes = true)
    private fun replNoTypes() = Repl(showTypes = false)

    // ── Basic expressions ────────────────────────────────────────────────────

    @Test fun evalIntLiteral() {
        val r = repl()
        val out = r.eval("42")
        assertTrue(out != null && out.contains("42"), "Expected 42, got: $out")
    }

    @Test fun evalStringLiteral() {
        val r = repl()
        val out = r.eval("""  "hello"  """.trim())
        assertTrue(out != null && out.contains("hello"), "Expected hello, got: $out")
    }

    @Test fun evalArithmetic() {
        val r = repl()
        val out = r.eval("3 + 4 * 2")
        assertTrue(out != null && out.contains("11"), "Expected 11, got: $out")
    }

    @Test fun evalBooleanExpr() {
        val r = repl()
        val out = r.eval("true and false")
        assertTrue(out != null && out.contains("false"), "Expected false, got: $out")
    }

    // ── Print produces output ────────────────────────────────────────────────

    @Test fun evalPrint() {
        val r = repl()
        val out = r.eval("""print("Hello, NOVA!")""")
        assertEquals("Hello, NOVA!", out)
    }

    @Test fun evalPrintMultiLine() {
        val r = repl()
        val out = r.eval("print(1)\nprint(2)\nprint(3)")
        assertEquals("1\n2\n3", out)
    }

    // ── State persists across evaluations ─────────────────────────────────────

    @Test fun statePersists() {
        val r = repl()
        r.eval("x = 10")
        r.eval("y = 20")
        val out = r.eval("x + y")
        assertTrue(out != null && out.contains("30"), "Expected 30, got: $out")
    }

    @Test fun functionPersists() {
        val r = repl()
        r.eval("fn double(n)\n    n * 2")
        val out = r.eval("double(21)")
        assertTrue(out != null && out.contains("42"), "Expected 42, got: $out")
    }

    @Test fun variableOverwrite() {
        val r = repl()
        r.eval("x = 5")
        r.eval("x = 10")
        val out = r.eval("x")
        assertTrue(out != null && out.contains("10"), "Expected 10, got: $out")
    }

    // ── Error handling ───────────────────────────────────────────────────────

    @Test fun undefinedVarError() {
        val r = repl()
        val out = r.eval("undefined_var")
        assertTrue(out != null && out.contains("error"), "Expected error, got: $out")
    }

    @Test fun errorDoesNotCrashRepl() {
        val r = repl()
        r.eval("bad_var")
        val out = r.eval("42")
        assertTrue(out != null && out.contains("42"), "Expected 42 after error, got: $out")
    }

    @Test fun parseErrorReported() {
        val r = repl()
        val out = r.eval("fn (")
        assertTrue(out != null && (out.contains("error") || out.contains("Error")),
            "Expected parse error, got: $out")
    }

    // ── Collections ──────────────────────────────────────────────────────────

    @Test fun evalList() {
        val r = repl()
        val out = r.eval("[1, 2, 3]")
        assertTrue(out != null && out.contains("[1, 2, 3]"), "Expected [1, 2, 3], got: $out")
    }

    @Test fun evalTuple() {
        val r = repl()
        val out = r.eval("(1, 2)")
        assertTrue(out != null && out.contains("(1, 2)"), "Expected (1, 2), got: $out")
    }

    // ── Lambda ───────────────────────────────────────────────────────────────

    @Test fun evalLambdaCall() {
        val r = repl()
        r.eval("add = (a, b) => a + b")
        val out = r.eval("add(3, 4)")
        assertTrue(out != null && out.contains("7"), "Expected 7, got: $out")
    }

    // ── String interpolation ─────────────────────────────────────────────────

    @Test fun evalStringInterpolation() {
        val r = repl()
        r.eval("name = \"World\"")
        val out = r.eval("""print("Hello, {name}!")""")
        assertEquals("Hello, World!", out)
    }

    // ── Type display ─────────────────────────────────────────────────────────

    @Test fun showsTypeForExpression() {
        val r = repl()
        val out = r.eval("42")
        assertTrue(out != null && out.contains("int"), "Expected type 'int', got: $out")
    }

    @Test fun noTypeWhenDisabled() {
        val r = replNoTypes()
        val out = r.eval("42")
        assertTrue(out != null && !out.contains(":"), "Expected no type, got: $out")
    }

    // ── Unit expressions produce no output ────────────────────────────────────

    @Test fun assignmentIsQuiet() {
        val r = repl()
        val out = r.eval("x = 42")
        assertNull(out, "Assignment should produce no output, got: $out")
    }

    // ── Multi-line detection ─────────────────────────────────────────────────

    @Test fun detectsIncompleteParens() {
        assertTrue(Repl.isIncomplete("fn foo("))
    }

    @Test fun detectsIncompleteBrackets() {
        assertTrue(Repl.isIncomplete("[1, 2,"))
    }

    @Test fun detectsTrailingOperator() {
        assertTrue(Repl.isIncomplete("x +"))
    }

    @Test fun completeExprNotIncomplete() {
        assertFalse(Repl.isIncomplete("42"))
    }

    @Test fun completeCallNotIncomplete() {
        assertFalse(Repl.isIncomplete("print(42)"))
    }

    // ── Complex multi-line ───────────────────────────────────────────────────

    @Test fun multiLineFunction() {
        val r = repl()
        r.eval("fn factorial(n)\n    if n <= 1\n        return 1\n    n * factorial(n - 1)")
        val out = r.eval("factorial(5)")
        assertTrue(out != null && out.contains("120"), "Expected 120, got: $out")
    }

    @Test fun forExprCollects() {
        val r = repl()
        r.eval("squares = for x in [1, 2, 3]\n    x * x")
        val out = r.eval("squares")
        assertTrue(out != null && out.contains("[1, 4, 9]"), "Expected [1, 4, 9], got: $out")
    }
}
