package nova.ownership

import nova.lexer.Lexer
import nova.parser.Parser
import nova.types.TypeInferer
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class OwnershipCheckerTest {

    // ── Helpers ───────────────────────────────────────────────────────────────

    private fun check(source: String): OwnershipResult {
        val tokens = Lexer(source, "<test>").tokenize()
        val program = Parser(tokens).parse()
        val typeResult = TypeInferer().infer(program)
        return OwnershipChecker(typeResult.nodeTypes).check(program)
    }

    private fun checkClean(source: String): OwnershipResult {
        val r = check(source)
        assertTrue(r.errors.isEmpty(), "Expected no ownership errors, got: ${r.errors}")
        return r
    }

    private fun checkErrors(source: String, count: Int): OwnershipResult {
        val r = check(source)
        assertEquals(count, r.errors.size,
            "Expected $count ownership error(s), got ${r.errors.size}: ${r.errors}")
        return r
    }

    // ── Programs 1-10: all must pass with zero ownership errors ───────────────

    @Test fun program1HelloWorld() = checkClean("""print("Hello, World!")""").let {}

    @Test fun program2VariablesMathStrings() = checkClean("""
name = "Alice"
age = 30
height = 1.75
is_student = false
radius = 5.0
area = 3.14159 * radius
items = [1, 2, 3, 4, 5]
doubled = items.map(x => x * 2)
    """.trimIndent()).let {}

    @Test fun program3FunctionsControlFlow() = checkClean("""
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
    """.trimIndent()).let {}

    @Test fun program4ErrorHandling() = checkClean("""
config = read_file("config.txt") else "\{\}"
port = parse_int("8080") else 8080
    """.trimIndent()).let {}

    @Test fun program5HttpServer() = checkClean("""
import http
    """.trimIndent()).let {}

    @Test fun program6ConcurrentWordCount() = checkClean("""
fn word_count(files)
    results = channel()
    for file in files
        spawn
            content = read_file(file)
            words = content.split(" ").length
            send(results, (file, words))
    total = 0
    for _ in 0..files.length
        (name, count) = receive(results)
        print("{name}: {count} words")
        total += count
    print("Total: {total} words")
    """.trimIndent()).let {}

    @Test fun program7AiInference() = checkClean("""
import ai
    """.trimIndent()).let {}

    @Test fun program9SystemsMemory() = checkClean("""
type RingBuffer
    _handle: int

fn ring_buffer(capacity) -> RingBuffer
    RingBuffer { _handle: 0 }

fn push(rb: RingBuffer, val: byte) -> bool
    true

fn pop(rb: RingBuffer) -> byte
    byte(0)

fn free_buffer(rb: RingBuffer)
    print("freed")

rb = ring_buffer(1024)
free_buffer(rb)
    """.trimIndent()).let {}

    @Test fun program10DistributedService() = checkClean("""
fn fetch_from_db(id)
    result_ch = channel()
    spawn
        result = "data"
        send(result_ch, result)
    receive(result_ch) else "timeout"
    """.trimIndent()).let {}

    // ── Channel is never moved — Rule 2 exception ─────────────────────────────

    @Test fun channelSentThenUsedIsOk() = checkClean("""
ch = channel()
send(ch, 42)
val = receive(ch)
    """.trimIndent()).let {}

    @Test fun channelPassedToMultipleSends() = checkClean("""
ch = channel()
send(ch, 1)
send(ch, 2)
send(ch, 3)
    """.trimIndent()).let {}

    // ── copy() prevents move ──────────────────────────────────────────────────

    @Test fun copyPreventsMoveAllowsReuse() = checkClean("""
ch = channel()
ch2 = channel()
data = [1, 2, 3]
send(ch, copy(data))
send(ch2, copy(data))
    """.trimIndent()).let {}

    // ── Reassignment resets to Live ───────────────────────────────────────────

    @Test fun reassignmentAfterSendResetsToLive() = checkClean("""
ch = channel()
data = [1, 2, 3]
send(ch, data)
data = [4, 5, 6]
send(ch, data)
    """.trimIndent()).let {}

    // ── Spawn block: outer vars implicitly copied — no move ───────────────────

    @Test fun spawnBlockDoesNotMoveOuterVar() = checkClean("""
ch = channel()
data = [1, 2, 3]
spawn
    send(ch, data)
send(ch, data)
    """.trimIndent()).let {}

    @Test fun spawnBlockCapturedVarStillLiveAfter() = checkClean("""
ch = channel()
x = 42
spawn
    send(ch, x)
print(x)
    """.trimIndent()).let {}

    // ── Ownership violation 1: use after send ─────────────────────────────────

    @Test fun useAfterSendIsError() {
        val r = checkErrors("""
ch = channel()
data = [1, 2, 3]
send(ch, data)
print(data)
        """.trimIndent(), 1)
        assertTrue(r.errors[0].message.contains("`data`"))
        assertTrue(r.errors[0].message.contains("copy"))
    }

    // ── Ownership violation 2: double send ────────────────────────────────────

    @Test fun doubleSendIsError() {
        val r = checkErrors("""
ch = channel()
ch2 = channel()
data = [1, 2, 3]
send(ch, data)
send(ch2, data)
        """.trimIndent(), 1)
        assertTrue(r.errors[0].message.contains("`data`"))
        assertTrue(r.errors[0].message.contains("already sent"))
    }

    // ── Ownership violation 3: member access after send ───────────────────────

    @Test fun memberAccessAfterSendIsError() {
        val r = checkErrors("""
ch = channel()
items = [1, 2, 3]
send(ch, items)
n = items.length
        """.trimIndent(), 1)
        assertTrue(r.errors[0].message.contains("`items`"))
    }

    // ── Ownership violation 4: use after send in expression ───────────────────

    @Test fun useInExprAfterSendIsError() {
        val r = checkErrors("""
ch = channel()
y = [1, 2]
send(ch, y)
z = y
        """.trimIndent(), 1)
        assertTrue(r.errors[0].message.contains("`y`"))
    }

    // ── Ownership violation 5: double send via function call ──────────────────

    @Test fun sendThenPassToFunctionIsError() {
        val r = checkErrors("""
ch = channel()
buf = [0, 1, 2]
send(ch, buf)
process(buf)
        """.trimIndent(), 1)
        assertTrue(r.errors[0].message.contains("`buf`"))
    }

    // ── No false positives on common patterns ─────────────────────────────────

    @Test fun primitivesSentAndReusedNoError() = checkClean("""
ch = channel()
n = 42
send(ch, n)
print(n)
    """.trimIndent()).let {}

    @Test fun loopVariableUsedInBodyNoError() = checkClean("""
ch = channel()
items = [1, 2, 3]
for x in items
    send(ch, x)
    """.trimIndent()).let {}

    @Test fun tupleDestructuringIsLive() = checkClean("""
ch = channel()
pair = (1, "hello")
(a, b) = pair
print(a)
print(b)
    """.trimIndent()).let {}

    @Test fun sendTupleConstantNoError() = checkClean("""
ch = channel()
send(ch, (1, "hello"))
    """.trimIndent()).let {}

    @Test fun multipleChannelsNoInterference() = checkClean("""
ch1 = channel()
ch2 = channel()
x = [1]
y = [2]
send(ch1, x)
send(ch2, y)
    """.trimIndent()).let {}
}
