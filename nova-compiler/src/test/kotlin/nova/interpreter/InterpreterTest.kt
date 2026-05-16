package nova.interpreter

import nova.lexer.Lexer
import nova.parser.Parser
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class InterpreterTest {

    // ── Helpers ───────────────────────────────────────────────────────────────

    private fun run(source: String): List<String> {
        val tokens = Lexer(source, "<test>").tokenize()
        val parser = Parser(tokens)
        val program = parser.parse()
        assertTrue(parser.errors.isEmpty(), "Parse errors: ${parser.errors}")
        val interp = Interpreter()
        interp.run(program)
        return interp.output
    }

    // ── Program 1: Hello World ────────────────────────────────────────────────

    @Test fun program1HelloWorld() {
        val out = run("""print("Hello, World!")""")
        assertEquals(listOf("Hello, World!"), out)
    }

    // ── Program 2: Variables, Math, Strings ──────────────────────────────────

    @Test fun program2Variables() {
        val out = run("""
name = "Alice"
age = 30
greeting = "Hello, {name}! You are {age} years old."
print(greeting)
        """.trimIndent())
        assertEquals(listOf("Hello, Alice! You are 30 years old."), out)
    }

    @Test fun program2Arithmetic() {
        val out = run("""
radius = 5.0
area = 3.14159 * radius ** 2
print(area)
        """.trimIndent())
        assertTrue(out.isNotEmpty())
        val area = out[0].toDouble()
        assertTrue(area > 78.5 && area < 78.6, "Expected ~78.54, got $area")
    }

    @Test fun program2ListMapSum() {
        val out = run("""
items = [1, 2, 3, 4, 5]
total = items.sum()
doubled = items.map(x => x * 2)
print("Sum: {total}, Doubled: {doubled}")
        """.trimIndent())
        assertEquals(listOf("Sum: 15, Doubled: [2, 4, 6, 8, 10]"), out)
    }

    // ── Program 3: Functions and Control Flow ─────────────────────────────────

    @Test fun program3Greet() {
        val out = run("""
fn greet(name)
    print("Hello, {name}!")
greet("World")
        """.trimIndent())
        assertEquals(listOf("Hello, World!"), out)
    }

    @Test fun program3Max() {
        val out = run("""
fn max(a, b)
    if a > b a else b
print(max(10, 20))
print(max(30, 5))
        """.trimIndent())
        assertEquals(listOf("20", "30"), out)
    }

    @Test fun program3FizzBuzz() {
        val out = run("""
fn fizzbuzz(n)
    for i in 1..n+1
        match (i % 3, i % 5)
            (0, 0) => print("FizzBuzz")
            (0, _) => print("Fizz")
            (_, 0) => print("Buzz")
            _      => print(i)
fizzbuzz(15)
        """.trimIndent())
        assertEquals(listOf("1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz",
                            "11","Fizz","13","14","FizzBuzz"), out)
    }

    @Test fun program3Factorial() {
        val out = run("""
fn factorial(n)
    if n <= 1
        return 1
    n * factorial(n - 1)
print(factorial(10))
        """.trimIndent())
        assertEquals(listOf("3628800"), out)
    }

    // ── Program 4: Error Handling ─────────────────────────────────────────────

    @Test fun program4ElseDefault() {
        val out = run("""
port = parse_int("8080") else 8080
print(port)
        """.trimIndent())
        assertEquals(listOf("8080"), out)
    }

    @Test fun program4ElseDefaultFallback() {
        val out = run("""
port = parse_int("not_a_number") else 9090
print(port)
        """.trimIndent())
        assertEquals(listOf("9090"), out)
    }

    @Test fun program4ElseDefaultString() {
        val out = run("""
config = read_file("__no_such_file__.txt") else "\{\}"
print(config)
        """.trimIndent())
        assertEquals(listOf("{}"), out)
    }

    // ── Program 6: Concurrent Processes and Channels ──────────────────────────

    @Test fun program6ChannelSendReceive() {
        val out = run("""
ch = channel()
send(ch, 42)
val = receive(ch)
print(val)
        """.trimIndent())
        assertEquals(listOf("42"), out)
    }

    @Test fun program6SpawnAndChannel() {
        val out = run("""
results = channel()
spawn
    send(results, "hello from spawn")
msg = receive(results)
print(msg)
        """.trimIndent())
        // Give spawn time to run.
        Thread.sleep(200)
        assertEquals(listOf("hello from spawn"), out)
    }

    @Test fun program6WordCount() {
        val out = run("""
fn word_count_test(words_list)
    results = channel()
    for w in words_list
        spawn
            send(results, w.length)
    total = 0
    for _ in 0..words_list.length
        count = receive(results)
        total += count
    print(total)

word_count_test(["hello", "world", "nova"])
        """.trimIndent())
        Thread.sleep(500)
        assertEquals(listOf("14"), out)
    }

    // ── Program 7: AI-like iteration ──────────────────────────────────────────

    @Test fun program7ListTop() {
        val out = run("""
predictions = [("cat", 0.9), ("dog", 0.7), ("bird", 0.3)]
top = predictions.top(2)
print(top.length)
        """.trimIndent())
        assertEquals(listOf("2"), out)
    }

    // ── Program 9: Systems-level ──────────────────────────────────────────────

    @Test fun program9RingBuffer() {
        val out = run("""
fn ring_buffer(capacity)
    capacity

fn push(rb, val)
    true

fn pop(rb)
    byte(0)

fn free_buffer(rb)
    print("freed")

rb = ring_buffer(1024)
push(rb, byte(66))
value = pop(rb)
free_buffer(rb)
print("Got: {value}")
        """.trimIndent())
        assertEquals(listOf("freed", "Got: 0"), out)
    }

    // ── Core language features ────────────────────────────────────────────────

    @Test fun whileLoop() {
        val out = run("""
i = 0
while i < 5
    print(i)
    i += 1
        """.trimIndent())
        assertEquals(listOf("0","1","2","3","4"), out)
    }

    @Test fun closureCapture() {
        val out = run("""
x = 10
add = n => n + x
print(add(5))
        """.trimIndent())
        assertEquals(listOf("15"), out)
    }

    @Test fun matchOnInt() {
        val out = run("""
n = 2
match n
    1 => print("one")
    2 => print("two")
    _ => print("other")
        """.trimIndent())
        assertEquals(listOf("two"), out)
    }

    @Test fun matchOnTuple() {
        val out = run("""
pair = (3, 5)
match pair
    (0, _) => print("zero first")
    (_, 0) => print("zero second")
    _      => print("neither")
        """.trimIndent())
        assertEquals(listOf("neither"), out)
    }

    @Test fun tupleDestructuring() {
        val out = run("""
pair = (10, "hello")
(n, s) = pair
print("{n} {s}")
        """.trimIndent())
        assertEquals(listOf("10 hello"), out)
    }

    @Test fun forExprCollectsResults() {
        val out = run("""
squares = for x in [1, 2, 3, 4, 5]
    x * x
print(squares)
        """.trimIndent())
        assertEquals(listOf("[1, 4, 9, 16, 25]"), out)
    }

    @Test fun rangeIteration() {
        val out = run("""
total = 0
for i in 1..6
    total += i
print(total)
        """.trimIndent())
        assertEquals(listOf("15"), out)
    }

    @Test fun nestedFunctions() {
        val out = run("""
fn outer(x)
    fn inner(y)
        x + y
    inner(10)
print(outer(5))
        """.trimIndent())
        assertEquals(listOf("15"), out)
    }

    @Test fun listMapFilter() {
        val out = run("""
nums = [1, 2, 3, 4, 5, 6]
evens = nums.filter(x => x % 2 == 0)
doubled = evens.map(x => x * 2)
print(doubled)
        """.trimIndent())
        assertEquals(listOf("[4, 8, 12]"), out)
    }

    @Test fun stringInterpolation() {
        val out = run("""
a = 3
b = 4
print("Sum of {a} and {b} is {a + b}")
        """.trimIndent())
        assertEquals(listOf("Sum of 3 and 4 is 7"), out)
    }

    @Test fun elseChaining() {
        val out = run("""
result = parse_int("bad") else parse_int("also_bad") else 42
print(result)
        """.trimIndent())
        assertEquals(listOf("42"), out)
    }

    @Test fun booleanOperators() {
        val out = run("""
print(true and false)
print(true or false)
print(not true)
        """.trimIndent())
        assertEquals(listOf("false", "true", "false"), out)
    }

    @Test fun breakInForLoop() {
        val out = run("""
for i in 0..10
    if i == 5
        break
    print(i)
        """.trimIndent())
        assertEquals(listOf("0","1","2","3","4"), out)
    }

    @Test fun continueInForLoop() {
        val out = run("""
for i in 0..5
    if i % 2 == 0
        continue
    print(i)
        """.trimIndent())
        assertEquals(listOf("1","3"), out)
    }
}
