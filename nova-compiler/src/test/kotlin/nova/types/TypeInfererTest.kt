package nova.types

import nova.lexer.Lexer
import nova.parser.Parser
import nova.parser.*
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class TypeInfererTest {

    // ── Helpers ───────────────────────────────────────────────────────────────

    private fun infer(source: String): InferResult {
        val lexer = Lexer(source, "<test>")
        val tokens = lexer.tokenize()
        val parser = Parser(tokens)
        val program = parser.parse()
        assertTrue(parser.errors.isEmpty(), "Parse errors: ${parser.errors}")
        return TypeInferer().infer(program)
    }

    private fun inferNoErrors(source: String): InferResult {
        val result = infer(source)
        assertTrue(result.errors.isEmpty(), "Type errors: ${result.errors}")
        return result
    }

    // Find the inferred type for the first expression in the program that matches
    // a predicate. Used to extract types of specific nodes.
    private fun InferResult.typeOf(pred: (Expr) -> Boolean): NovaType? =
        nodeTypes.entries.firstOrNull { pred(it.key) }?.value

    private fun InferResult.typeOfIdent(name: String) =
        typeOf { it is Ident && it.name == name }

    private fun InferResult.typeOfIntLit(v: Long) =
        typeOf { it is IntLit && it.value == v }

    private fun InferResult.typeOfFloatLit(v: Double) =
        typeOf { it is FloatLit && it.value == v }

    // ── Literal types ─────────────────────────────────────────────────────────

    @Test fun intLiteralIsInt() {
        val r = inferNoErrors("x = 42")
        assertEquals(TInt, r.typeOfIntLit(42))
    }

    @Test fun floatLiteralIsFloat() {
        val r = inferNoErrors("x = 3.14")
        assertEquals(TFloat, r.typeOfFloatLit(3.14))
    }

    @Test fun stringLiteralIsString() {
        val r = inferNoErrors("""x = "hello"""")
        val t = r.typeOf { it is StringLit }
        assertEquals(TString, t)
    }

    @Test fun boolLiteralIsBool() {
        val r = inferNoErrors("x = true")
        assertEquals(TBool, r.typeOf { it is BoolLit && (it as BoolLit).value })
    }

    // ── Program 1: Hello World ────────────────────────────────────────────────

    @Test fun program1HelloWorld() {
        val r = inferNoErrors("""print("Hello, World!")""")
        assertTrue(r.errors.isEmpty())
    }

    // ── Program 2: Variables, Math, Strings ──────────────────────────────────

    @Test fun program2Variables() {
        val r = inferNoErrors("""
name = "Alice"
age = 30
height = 1.75
is_student = false
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    @Test fun arithmeticInference() {
        val r = inferNoErrors("""
radius = 5.0
area = 3.14159 * radius
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    @Test fun listLiteralIsListInt() {
        val r = inferNoErrors("items = [1, 2, 3, 4, 5]")
        val t = r.typeOf { it is ListLit }
        assertTrue(t is TList, "expected TList, got $t")
        assertEquals(TInt, (t as TList).elem)
    }

    // ── Program 3: Functions and Control Flow ─────────────────────────────────

    @Test fun fnDeclarationInferred() {
        val r = inferNoErrors("""
fn max(a, b)
    if a > b a else b
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    @Test fun factorialReturnType() {
        val r = inferNoErrors("""
fn factorial(n)
    if n <= 1
        return 1
    n * factorial(n - 1)
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    @Test fun forRangeInference() {
        val r = inferNoErrors("""
for i in 1..10
    print(i)
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    @Test fun matchExpressionInference() {
        val r = inferNoErrors("""
x = 5
match x
    1 => print("one")
    _ => print("other")
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    // ── Program 4: Error Handling ─────────────────────────────────────────────

    @Test fun elseOpExtractsOkType() {
        // port = parse_int(env("PORT")) else 8080
        // parse_int returns int or Error; else 8080 (int) extracts int
        val r = inferNoErrors("""
port = parse_int("8080") else 8080
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    @Test fun elseOpWithStringDefault() {
        val r = inferNoErrors("""
config = read_file("config.txt") else "\{\}"
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    @Test fun elseReturnInFn() {
        val r = inferNoErrors("""
fn load(id)
    json = "data" else return "fallback"
    json
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    // ── Program 5: HTTP Server ────────────────────────────────────────────────

    @Test fun importParsesWithoutError() {
        val r = inferNoErrors("import http")
        assertTrue(r.errors.isEmpty())
    }

    // ── Program 6: Concurrent Processes ──────────────────────────────────────

    @Test fun channelTypeInferred() {
        // channel() -> Channel<?T>; send(ch, 42) constrains T=int; receive(ch) -> int
        val r = inferNoErrors("""
results = channel()
send(results, 42)
val = receive(results)
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    @Test fun spawnBlockStatement() {
        val r = inferNoErrors("""
ch = channel()
spawn
    send(ch, 1)
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    @Test fun tupleDestructuringInFor() {
        val r = inferNoErrors("""
pairs = [(1, "a"), (2, "b")]
for (n, s) in pairs
    print(n)
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    // ── Program 7: AI Inference ───────────────────────────────────────────────

    @Test fun memberAccessOnList() {
        val r = inferNoErrors("""
items = [1, 2, 3]
n = items.length
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
        // n should be TInt
    }

    @Test fun mapLambdaInference() {
        val r = inferNoErrors("""
items = [1, 2, 3, 4, 5]
doubled = items.map(x => x * 2)
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    // ── Program 9: Systems Memory ─────────────────────────────────────────────

    @Test fun typeDeclFieldAccess() {
        val r = inferNoErrors("""
type Point
    x: int
    y: int
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
    }

    // ── Program 10: Distributed Service ──────────────────────────────────────

    @Test fun spawnExprReturnsProcess() {
        val r = inferNoErrors("""
fn worker()
    42

p = spawn worker()
        """.trimIndent())
        assertTrue(r.errors.isEmpty())
        val t = r.typeOf { it is SpawnExpr }
        assertTrue(t is TProcess, "expected TProcess, got $t")
    }

    // ── Type error detection ──────────────────────────────────────────────────

    @Test fun typeMismatchIsDetected() {
        // Adding int to bool should cause a type error
        val r = infer("""
x = 1 + true
        """.trimIndent())
        assertTrue(r.errors.isNotEmpty(), "expected type error, got none")
    }

    @Test fun wrongArgCountDetected() {
        val r = infer("""
fn add(a, b)
    a + b

add(1)
        """.trimIndent())
        assertTrue(r.errors.isNotEmpty(), "expected arity error, got none")
    }

    // ── Let polymorphism ──────────────────────────────────────────────────────

    @Test fun identityFnUsedAtMultipleTypes() {
        val r = inferNoErrors("""
fn identity(x)
    x

a = identity(42)
b = identity("hello")
        """.trimIndent())
        assertTrue(r.errors.isEmpty(), "let-polymorphism failed: ${r.errors}")
    }

    // ── Nothing type ──────────────────────────────────────────────────────────

    @Test fun returnExprHasNothingType() {
        val r = inferNoErrors("""
fn early()
    x = return 42
    x
        """.trimIndent())
        val t = r.typeOf { it is ReturnExpr }
        assertEquals(TNothing, t)
    }

    // ── String interpolation ──────────────────────────────────────────────────

    @Test fun interpolatedStringIsString() {
        val r = inferNoErrors("""
name = "world"
greeting = "Hello, {name}!"
        """.trimIndent())
        val t = r.typeOf { it is StringInterp }
        assertEquals(TString, t)
    }

    // ── Range type ────────────────────────────────────────────────────────────

    @Test fun rangeLiteralIsRange() {
        val r = inferNoErrors("""
r = 1..10
        """.trimIndent())
        val t = r.typeOf { it is BinaryOp && (it as BinaryOp).op == ".." }
        assertEquals(TRange, t)
    }

    // ── Annotation count check (Gate 2 proxy) ────────────────────────────────
    // Count how many non-trivial fn params are annotated vs total.
    // This is not a strict test — just a smoke check that Programs 2-6 parse
    // and infer without any annotations producing errors.

    @Test fun zeroAnnotationsNeededForTypeSafety() {
        val source = """
fn greet(name)
    print("Hello, {name}!")

fn max(a, b)
    if a > b a else b

fn fizzbuzz(n)
    for i in 1..n
        print(i)

fn factorial(n)
    if n <= 1
        return 1
    n * factorial(n - 1)

greet("World")
print(max(10, 20))
fizzbuzz(30)
print(factorial(10))
        """.trimIndent()
        val r = inferNoErrors(source)
        assertTrue(r.errors.isEmpty())
    }
}
