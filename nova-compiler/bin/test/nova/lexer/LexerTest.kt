package nova.lexer

import nova.lexer.TokenType.*
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.ValueSource

class LexerTest {

    // ── Helpers ───────────────────────────────────────────────────────────────

    private fun lex(src: String): List<Token> = Lexer(src, "<test>").tokenize()
    private fun types(src: String): List<TokenType> = lex(src).map { it.type }
    private fun values(src: String): List<String> = lex(src).map { it.value }

    private fun assertTypes(src: String, vararg expected: TokenType) {
        assertEquals(expected.toList(), types(src))
    }

    // ── Program 1: Hello World ────────────────────────────────────────────────

    @Test
    fun `program 1 - hello world`() {
        assertTypes(
            """print("Hello, World!")""",
            IDENT, LPAREN, STRING_LITERAL, RPAREN, NEWLINE, EOF
        )
    }

    @Test
    fun `program 1 - hello world value`() {
        val toks = lex("""print("Hello, World!")""")
        assertEquals("Hello, World!", toks[2].value)
    }

    // ── Program 2: Variables, Math, Strings ──────────────────────────────────

    @Test
    fun `program 2 - simple assignment`() {
        assertTypes("name = \"Alice\"", IDENT, ASSIGN, STRING_LITERAL, NEWLINE, EOF)
    }

    @Test
    fun `program 2 - integer and float literals`() {
        val toks = lex("age = 30\nheight = 1.75")
        assertEquals("30", toks.first { it.type == INT_LITERAL }.value)
        assertEquals("1.75", toks.first { it.type == FLOAT_LITERAL }.value)
    }

    @Test
    fun `program 2 - power operator`() {
        assertTypes(
            "area = 3.14159 * radius ** 2",
            IDENT, ASSIGN, FLOAT_LITERAL, STAR, IDENT, STAR_STAR, INT_LITERAL, NEWLINE, EOF
        )
    }

    @Test
    fun `program 2 - string interpolation single variable`() {
        // "Hello, {name}!"
        assertTypes(
            "\"Hello, {name}!\"",
            STRING_PART, INTERP_START, IDENT, INTERP_END, STRING_PART, NEWLINE, EOF
        )
    }

    @Test
    fun `program 2 - string interpolation values`() {
        val toks = lex("\"Hello, {name}!\"")
        assertEquals("Hello, ", toks[0].value)
        assertEquals("name",    toks[2].value)
        assertEquals("!",       toks[4].value)
    }

    @Test
    fun `program 2 - string interpolation two variables`() {
        // "Hello, {name}! You are {age} years old."
        assertTypes(
            "\"Hello, {name}! You are {age} years old.\"",
            STRING_PART, INTERP_START, IDENT, INTERP_END,
            STRING_PART, INTERP_START, IDENT, INTERP_END,
            STRING_PART, NEWLINE, EOF
        )
    }

    @Test
    fun `program 2 - lambda with fat arrow`() {
        // doubled = items.map(x => x * 2)
        assertTypes(
            "doubled = items.map(x => x * 2)",
            IDENT, ASSIGN, IDENT, DOT, IDENT, LPAREN,
            IDENT, FAT_ARROW, IDENT, STAR, INT_LITERAL,
            RPAREN, NEWLINE, EOF
        )
    }

    @Test
    fun `program 2 - boolean literal false`() {
        assertTypes("is_student = false", IDENT, ASSIGN, FALSE, NEWLINE, EOF)
    }

    // ── Program 3: Functions and Control Flow ─────────────────────────────────

    @Test
    fun `program 3 - fn keyword`() {
        val t = types("fn add(a, b)\n    return a + b")
        assertTrue(FN in t)
        assertTrue(RETURN in t)
        assertTrue(INDENT in t)
        assertTrue(DEDENT in t)
    }

    @Test
    fun `program 3 - function produces INDENT and DEDENT`() {
        val src = "fn greet(name)\n    print(name)"
        val t = types(src)
        assertEquals(listOf(FN, IDENT, LPAREN, IDENT, RPAREN, NEWLINE, INDENT, IDENT, LPAREN, IDENT, RPAREN, NEWLINE, DEDENT, EOF), t)
    }

    @Test
    fun `program 3 - nested blocks produce matching INDENT DEDENT pairs`() {
        val src = """
fn outer()
    fn inner()
        42
""".trimIndent()
        val t = types(src)
        val indents = t.count { it == INDENT }
        val dedents = t.count { it == DEDENT }
        assertEquals(indents, dedents)
    }

    @Test
    fun `program 3 - for in range`() {
        // for i in 1..n+1
        assertTypes(
            "for i in 1..n+1",
            FOR, IDENT, IN, INT_LITERAL, DOT_DOT, IDENT, PLUS, INT_LITERAL, NEWLINE, EOF
        )
    }

    @Test
    fun `program 3 - match keyword with fat arrow`() {
        // match (i % 3, i % 5)
        //     (0, 0) => print("FizzBuzz")
        val src = "match x\n    0 => print(\"Fizz\")"
        val t = types(src)
        assertTrue(MATCH in t)
        assertTrue(FAT_ARROW in t)
    }

    @Test
    fun `program 3 - inline if expression`() {
        // if a > b a else b
        assertTypes(
            "if a > b a else b",
            IF, IDENT, GT, IDENT, IDENT, ELSE, IDENT, NEWLINE, EOF
        )
    }

    @Test
    fun `program 3 - factorial recursive call`() {
        assertTypes(
            "n * factorial(n - 1)",
            IDENT, STAR, IDENT, LPAREN, IDENT, MINUS, INT_LITERAL, RPAREN, NEWLINE, EOF
        )
    }

    // ── Program 4: Error Handling ─────────────────────────────────────────────

    @Test
    fun `program 4 - else for error default (same line)`() {
        // config = read_file("config.txt") else "default"
        // Note: "{}" would start string interpolation in NOVA — use "\{\}" for literal braces.
        // This test focuses on ELSE as infix error-default operator.
        assertTypes(
            "config = read_file(\"config.txt\") else \"default\"",
            IDENT, ASSIGN, IDENT, LPAREN, STRING_LITERAL, RPAREN,
            ELSE, STRING_LITERAL, NEWLINE, EOF
        )
    }

    @Test
    fun `string interpolation - empty braces are treated as empty interpolation`() {
        // "{}" produces STRING_PART + INTERP_START + INTERP_END + STRING_PART
        // For literal {} in a string, NOVA requires \{ and \} escape sequences
        assertTypes(
            "\"{}\"",
            STRING_PART, INTERP_START, INTERP_END, STRING_PART, NEWLINE, EOF
        )
    }

    @Test
    fun `string interpolation - escaped braces are literal`() {
        // "\{\}" produces a literal string "{}"
        val toks = lex("\"\\{\\}\"")
        assertEquals(STRING_LITERAL, toks[0].type)
        assertEquals("{}", toks[0].value)
    }

    @Test
    fun `program 4 - else return pattern`() {
        // json = fetch(url) else return Error("msg")
        assertTypes(
            "json = fetch(url) else return Error(\"msg\")",
            IDENT, ASSIGN, IDENT, LPAREN, IDENT, RPAREN,
            ELSE, RETURN, IDENT, LPAREN, STRING_LITERAL, RPAREN, NEWLINE, EOF
        )
    }

    // ── Program 5: HTTP Server ────────────────────────────────────────────────

    @Test
    fun `program 5 - import statement`() {
        assertTypes("import http", IMPORT, IDENT, NEWLINE, EOF)
    }

    @Test
    fun `program 5 - nested lambdas with fat arrow`() {
        // routes.get("/", req => "Hello!")
        assertTypes(
            "routes.get(\"/\", req => \"Hello!\")",
            IDENT, DOT, IDENT, LPAREN, STRING_LITERAL, COMMA,
            IDENT, FAT_ARROW, STRING_LITERAL, RPAREN, NEWLINE, EOF
        )
    }

    // ── Program 6: Concurrent Processes ──────────────────────────────────────

    @Test
    fun `program 6 - channel and spawn keywords`() {
        val src = "results = channel()\nspawn worker()"
        val t = types(src)
        assertTrue(CHANNEL in t)
        assertTrue(SPAWN in t)
    }

    @Test
    fun `program 6 - send and receive`() {
        assertTypes(
            "send(results, (file, words))",
            SEND, LPAREN, IDENT, COMMA, LPAREN, IDENT, COMMA, IDENT, RPAREN, RPAREN, NEWLINE, EOF
        )
        assertTypes(
            "(name, count) = receive(results)",
            LPAREN, IDENT, COMMA, IDENT, RPAREN, ASSIGN, RECEIVE, LPAREN, IDENT, RPAREN, NEWLINE, EOF
        )
    }

    @Test
    fun `program 6 - plus-assign compound operator`() {
        assertTypes("total += count", IDENT, PLUS_ASSIGN, IDENT, NEWLINE, EOF)
    }

    @Test
    fun `program 6 - underscore wildcard is IDENT`() {
        assertTypes("for _ in 0..n", FOR, IDENT, IN, INT_LITERAL, DOT_DOT, IDENT, NEWLINE, EOF)
        assertEquals("_", lex("for _ in 0..n")[1].value)
    }

    // ── Program 7: AI Inference ───────────────────────────────────────────────

    @Test
    fun `program 7 - method chain dot operator`() {
        // predictions.top(5)
        assertTypes(
            "predictions.top(5)",
            IDENT, DOT, IDENT, LPAREN, INT_LITERAL, RPAREN, NEWLINE, EOF
        )
    }

    // ── Program 8: Full-Stack App ─────────────────────────────────────────────

    @Test
    fun `program 8 - at annotation`() {
        // @device(wasm)
        assertTypes("@device(wasm)", AT, IDENT, LPAREN, IDENT, RPAREN, NEWLINE, EOF)
    }

    @Test
    fun `program 8 - NEWLINE suppressed inside brackets`() {
        // Multi-line argument list should not produce NEWLINE/INDENT/DEDENT inside ()
        val src = "fn(\n    a,\n    b\n)"
        val t = types(src)
        assertTrue(INDENT !in t)
        assertTrue(DEDENT !in t)
        assertTrue(NEWLINE !in t.dropLast(2)) // only the final NEWLINE + EOF
    }

    // ── Program 9: Systems Level ──────────────────────────────────────────────

    @Test
    fun `program 9 - thin arrow for return type`() {
        // fn ring_buffer(capacity) -> RingBuffer
        assertTypes(
            "fn ring_buffer(capacity) -> RingBuffer",
            FN, IDENT, LPAREN, IDENT, RPAREN, THIN_ARROW, IDENT, NEWLINE, EOF
        )
    }

    @Test
    fun `program 9 - at low_level annotation`() {
        assertTypes("@low_level", AT, IDENT, NEWLINE, EOF)
        assertEquals("low_level", lex("@low_level")[1].value)
    }

    @Test
    fun `program 9 - colon in named argument`() {
        // { _handle: handle }
        assertTypes(
            "{ _handle: handle }",
            LBRACE, IDENT, COLON, IDENT, RBRACE, NEWLINE, EOF
        )
    }

    // ── Program 10: Distributed Service ──────────────────────────────────────

    @Test
    fun `program 10 - supervise keyword`() {
        val src = "supervise(w, restart = \"always\")"
        val t = types(src)
        assertTrue(SUPERVISE in t)
        assertTrue(ASSIGN in t)
    }

    @Test
    fun `program 10 - select keyword`() {
        assertTypes("select", SELECT, NEWLINE, EOF)
    }

    // ── Number literals ───────────────────────────────────────────────────────

    @Test
    fun `integer literal with underscores`() {
        val toks = lex("x = 1_000_000")
        assertEquals(INT_LITERAL, toks[2].type)
        assertEquals("1000000", toks[2].value)
    }

    @Test
    fun `float literal with exponent`() {
        val toks = lex("x = 1.5e10")
        assertEquals(FLOAT_LITERAL, toks[2].type)
        assertEquals("1.5e10", toks[2].value)
    }

    @Test
    fun `hex literal`() {
        val toks = lex("x = 0xFF")
        assertEquals(INT_LITERAL, toks[2].type)
        assertEquals("0xFF", toks[2].value)
    }

    // ── String edge cases ─────────────────────────────────────────────────────

    @Test
    fun `simple string no interpolation`() {
        assertTypes("\"hello\"", STRING_LITERAL, NEWLINE, EOF)
        assertEquals("hello", lex("\"hello\"")[0].value)
    }

    @Test
    fun `string escape sequences`() {
        val toks = lex("\"line1\\nline2\"")
        assertEquals(STRING_LITERAL, toks[0].type)
        assertEquals("line1\nline2", toks[0].value)
    }

    @Test
    fun `raw string no interpolation`() {
        val toks = lex("`hello {not interpolated}`")
        assertEquals(RAW_STRING, toks[0].type)
        assertEquals("hello {not interpolated}", toks[0].value)
    }

    @Test
    fun `interpolation with arithmetic expression`() {
        // "{x + 1}"
        assertTypes(
            "\"{x + 1}\"",
            STRING_PART, INTERP_START, IDENT, PLUS, INT_LITERAL, INTERP_END, STRING_PART, NEWLINE, EOF
        )
    }

    // ── Operators ─────────────────────────────────────────────────────────────

    @ParameterizedTest
    @ValueSource(strings = ["+=", "-=", "*=", "/=", "%="])
    fun `compound assignment operators`(op: String) {
        val types = types("x $op y")
        val expectedType = when (op) {
            "+=" -> PLUS_ASSIGN
            "-=" -> MINUS_ASSIGN
            "*=" -> STAR_ASSIGN
            "/=" -> SLASH_ASSIGN
            "%=" -> PERCENT_ASSIGN
            else -> error("unknown")
        }
        assertTrue(expectedType in types)
    }

    @Test
    fun `pipeline operator`() {
        assertTypes("x |> f", IDENT, PIPE_GT, IDENT, NEWLINE, EOF)
    }

    @Test
    fun `comparison operators`() {
        assertTypes("a == b", IDENT, EQ, IDENT, NEWLINE, EOF)
        assertTypes("a != b", IDENT, NEQ, IDENT, NEWLINE, EOF)
        assertTypes("a <= b", IDENT, LEQ, IDENT, NEWLINE, EOF)
        assertTypes("a >= b", IDENT, GEQ, IDENT, NEWLINE, EOF)
    }

    @Test
    fun `boolean keywords`() {
        assertTypes("true", TRUE, NEWLINE, EOF)
        assertTypes("false", FALSE, NEWLINE, EOF)
        assertTypes("a and b", IDENT, AND, IDENT, NEWLINE, EOF)
        assertTypes("a or b", IDENT, OR, IDENT, NEWLINE, EOF)
        assertTypes("not a", NOT, IDENT, NEWLINE, EOF)
    }

    // ── Indentation ───────────────────────────────────────────────────────────

    @Test
    fun `indentation - blank lines are ignored`() {
        val src = "fn foo()\n\n    42"
        val t = types(src)
        val indents = t.count { it == INDENT }
        val dedents = t.count { it == DEDENT }
        assertEquals(1, indents)
        assertEquals(1, dedents)
    }

    @Test
    fun `indentation - comment-only lines do not affect indentation`() {
        val src = "fn foo()\n    // comment\n    42"
        val t = types(src)
        assertEquals(1, t.count { it == INDENT })
        assertEquals(1, t.count { it == DEDENT })
    }

    @Test
    fun `indentation - multiple levels`() {
        val src = "if x\n    if y\n        42"
        val t = types(src)
        assertEquals(2, t.count { it == INDENT })
        assertEquals(2, t.count { it == DEDENT })
    }

    @Test
    fun `indentation - INDENT DEDENT balanced at EOF`() {
        val src = "fn foo()\n    a\n    b"
        val t = types(src)
        assertEquals(t.count { it == INDENT }, t.count { it == DEDENT })
    }

    // ── Error detection ───────────────────────────────────────────────────────

    @Test
    fun `tab character produces error token`() {
        val toks = lex("fn foo()\n\t42")
        assertTrue(toks.any { it.type == ERROR && it.value.contains("tab") })
    }

    @Test
    fun `unterminated string produces error`() {
        val toks = lex("\"unterminated")
        assertTrue(toks.any { it.type == ERROR })
    }

    @Test
    fun `unterminated string interpolation at EOF produces error`() {
        // "hello {name — { is never closed, EOF reached inside interpolation
        val toks = lex("\"hello {name")
        assertTrue(toks.any { it.type == ERROR && it.value.contains("interpolation") })
    }

    @Test
    fun `unknown character produces error and continues`() {
        val toks = lex("a $ b")
        assertTrue(toks.any { it.type == ERROR })
        // Lexer should continue and produce IDENT for 'b'
        assertTrue(toks.any { it.type == IDENT && it.value == "b" })
    }

    @Test
    fun `unterminated block comment produces error`() {
        val toks = lex("/* unterminated")
        assertTrue(toks.any { it.type == ERROR })
    }

    // ── Comments ─────────────────────────────────────────────────────────────

    @Test
    fun `line comments are skipped`() {
        assertTypes("x = 1 // this is a comment", IDENT, ASSIGN, INT_LITERAL, NEWLINE, EOF)
    }

    @Test
    fun `block comments are skipped`() {
        assertTypes("x /* comment */ = 1", IDENT, ASSIGN, INT_LITERAL, NEWLINE, EOF)
    }

    // ── Source location ───────────────────────────────────────────────────────

    @Test
    fun `token has correct line number`() {
        val toks = lex("a\nb")
        val secondIdent = toks.filter { it.type == IDENT }[1]
        assertEquals(2, secondIdent.span.start.line)
    }

    @Test
    fun `token has correct column number`() {
        val toks = lex("x = 42")
        assertEquals(1, toks[0].span.start.col) // x at col 1
        assertEquals(5, toks[2].span.start.col) // 42 at col 5
    }

    // ── All keywords recognized ───────────────────────────────────────────────

    @Test
    fun `all 22 core keywords are recognized`() {
        val keywords = listOf(
            "fn" to FN, "return" to RETURN, "if" to IF, "else" to ELSE,
            "for" to FOR, "while" to WHILE, "match" to MATCH,
            "break" to BREAK, "continue" to CONTINUE,
            "type" to TYPE, "enum" to ENUM,
            "spawn" to SPAWN, "send" to SEND, "receive" to RECEIVE, "channel" to CHANNEL,
            "or" to OR, "and" to AND, "not" to NOT,
            "copy" to COPY, "import" to IMPORT,
            "true" to TRUE, "false" to FALSE
        )
        for ((word, expected) in keywords) {
            val t = types(word)
            assertEquals(
                expected, t[0],
                "Expected '$word' to produce $expected but got ${t[0]}"
            )
        }
    }

    @Test
    fun `extra keywords - in, select, supervise`() {
        assertEquals(IN, types("in")[0])
        assertEquals(SELECT, types("select")[0])
        assertEquals(SUPERVISE, types("supervise")[0])
    }

    @Test
    fun `identifier that starts like keyword`() {
        // "format", "forall", "iffy" are NOT keywords
        assertEquals(IDENT, types("format")[0])
        assertEquals(IDENT, types("forall")[0])
        assertEquals(IDENT, types("iffy")[0])
    }
}
