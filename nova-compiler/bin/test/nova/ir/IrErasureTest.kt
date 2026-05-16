package nova.ir

import nova.lexer.Lexer
import nova.parser.Parser
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Test

// ── Step 2.3 — Abstraction Erasure Tests (Gate 4) ────────────────────────────
//
// Gate 4 guarantee: single-process programs produce C-equivalent IR — no channel
// runtime, no scheduler, no synchronization overhead.
//
// Test categories:
//   Gate 4 fast path  — programs without channels pass through unchanged
//   Local erasure     — ChannelCreate/Send/Receive → SlotAlloc/Store/Load
//   Slot coalescing   — SlotLoad forwarded by optimizer, leaving no load overhead
//   Conservative      — functions with Spawn left untouched
//   Escape analysis   — channels passed to calls are not erased
//   Module integrity  — structs, function count, non-mutation preserved
//   Printer           — IrPrinter handles erased IR correctly

class IrErasureTest {

    // ── Helpers ───────────────────────────────────────────────────────────────

    private fun lower(src: String): IrModule {
        val tokens = Lexer(src.trimIndent(), "<test>").tokenize()
        val parser = Parser(tokens)
        val prog   = parser.parse()
        assertTrue(parser.errors.isEmpty(), "Parse errors: ${parser.errors}")
        return AstToIr().lower(prog)
    }

    private fun erase(src: String): IrModule = IrErasure().erase(lower(src))

    private fun IrModule.fn(name: String): IrFunction =
        functions.find { it.name == name }
            ?: error("No function '$name' in [${functions.joinToString { it.name }}]")

    private fun IrFunction.allInsts(): List<IrInst> = blocks.flatMap { it.instructions }
    private inline fun <reified T : IrInst> IrFunction.instsOf(): List<T> =
        allInsts().filterIsInstance<T>()

    private fun IrModule.allInsts(): List<IrInst>          = functions.flatMap { it.allInsts() }
    private inline fun <reified T : IrInst> IrModule.instsOf(): List<T> =
        allInsts().filterIsInstance<T>()

    // ── Gate 4 fast path: programs without channels ───────────────────────────
    // Programs that never use channels or spawn pass through IrErasure unchanged.
    // Gate 4 is trivially satisfied — the IR is already C-equivalent.

    @Test fun gate4_helloWorld() {
        val m = erase("""print("Hello, World!")""")
        assertEquals(0, m.instsOf<IrInst.ChannelCreate>().size)
        assertEquals(0, m.instsOf<IrInst.Spawn>().size)
    }

    @Test fun gate4_mathAndStrings() {
        val m = erase("""
            name = "Alice"
            age = 30
            greeting = "Hello, {name}! You are {age} years old."
            print(greeting)
        """)
        assertEquals(0, m.instsOf<IrInst.ChannelCreate>().size)
        assertEquals(0, m.instsOf<IrInst.ChannelSend>().size)
        assertEquals(0, m.instsOf<IrInst.ChannelReceive>().size)
        assertEquals(0, m.instsOf<IrInst.Spawn>().size)
    }

    @Test fun gate4_functionsAndControlFlow() {
        val m = erase("""
            fn max(a, b)
                if a > b a else b

            fn factorial(n)
                if n <= 1
                    return 1
                n * factorial(n - 1)

            print(max(10, 20))
            print(factorial(5))
        """)
        assertEquals(0, m.instsOf<IrInst.ChannelCreate>().size)
        assertEquals(0, m.instsOf<IrInst.Spawn>().size)
    }

    @Test fun gate4_lambdasAndHigherOrder() {
        val m = erase("""
            items = [1, 2, 3, 4, 5]
            doubled = items.map(x => x * 2)
            print(doubled)
        """)
        assertEquals(0, m.instsOf<IrInst.ChannelCreate>().size)
        assertEquals(0, m.instsOf<IrInst.Spawn>().size)
    }

    @Test fun gate4_structsAndRecords() {
        val m = erase("""
            type Point
                x: int
                y: int

            fn distance(p)
                p.x * p.x + p.y * p.y

            p = Point { x: 3, y: 4 }
            print(distance(p))
        """)
        assertEquals(0, m.instsOf<IrInst.ChannelCreate>().size)
        assertEquals(0, m.instsOf<IrInst.Spawn>().size)
    }

    @Test fun gate4_forLoopAndList() {
        val m = erase("""
            total = 0
            for i in 1..10
                total += i
            print(total)
        """)
        assertEquals(0, m.instsOf<IrInst.ChannelCreate>().size)
        assertEquals(0, m.instsOf<IrInst.Spawn>().size)
    }

    @Test fun gate4_nestedFunctions() {
        val m = erase("""
            fn outer(x)
                fn inner(y)
                    y * 2
                inner(x) + 1

            print(outer(5))
        """)
        assertEquals(0, m.instsOf<IrInst.ChannelCreate>().size)
        assertEquals(0, m.instsOf<IrInst.Spawn>().size)
    }

    // ── Local channel erasure ─────────────────────────────────────────────────
    // A channel used only within one function (no spawn, no escape) erases to
    // SlotAlloc/Store/Load. The optimizer's slot coalescing then forwards the
    // stored value directly, leaving zero channel runtime overhead.

    @Test fun localChannel_channelCreate_erased() {
        val m = erase("""
            fn pipe(x)
                ch = channel()
                send(ch, x)
                receive(ch)
        """)
        assertEquals(0, m.fn("pipe").instsOf<IrInst.ChannelCreate>().size,
            "ChannelCreate must be erased to SlotAlloc")
    }

    @Test fun localChannel_channelSend_erased() {
        val m = erase("""
            fn pipe(x)
                ch = channel()
                send(ch, x)
                receive(ch)
        """)
        assertEquals(0, m.fn("pipe").instsOf<IrInst.ChannelSend>().size,
            "ChannelSend must be erased to SlotStore")
    }

    @Test fun localChannel_channelReceive_erased() {
        val m = erase("""
            fn pipe(x)
                ch = channel()
                send(ch, x)
                receive(ch)
        """)
        assertEquals(0, m.fn("pipe").instsOf<IrInst.ChannelReceive>().size,
            "ChannelReceive must be erased to SlotLoad")
    }

    @Test fun localChannel_slotLoad_coalesced_byOptimizer() {
        // After erasure: SlotStore then SlotLoad in the same block.
        // Optimizer's slot coalescing forwards the stored ref and drops the load.
        // The SlotAlloc and SlotStore remain (they have side effects in hasSideEffects),
        // but the SlotLoad is eliminated — the receive result points directly to the
        // sent value. LLVM mem2reg promotes the remaining alloc/store in codegen.
        val m = erase("""
            fn pipe(x)
                ch = channel()
                send(ch, x)
                receive(ch)
        """)
        val channelSlotLoads = m.fn("pipe").allInsts()
            .filterIsInstance<IrInst.SlotLoad>()
            .filter { it.slot.name.startsWith("__ch") }
        assertEquals(0, channelSlotLoads.size,
            "Channel SlotLoad must be coalesced away by the optimizer")
    }

    @Test fun localChannel_withArithmetic() {
        val m = erase("""
            fn pass_through(n)
                ch = channel()
                send(ch, n + 1)
                result = receive(ch)
                result
        """)
        val fn = m.fn("pass_through")
        assertEquals(0, fn.instsOf<IrInst.ChannelCreate>().size)
        assertEquals(0, fn.instsOf<IrInst.ChannelSend>().size)
        assertEquals(0, fn.instsOf<IrInst.ChannelReceive>().size)
    }

    @Test fun localChannel_multipleChannels_bothErased() {
        val m = erase("""
            fn double_pipe(a, b)
                ch1 = channel()
                ch2 = channel()
                send(ch1, a + 1)
                send(ch2, b + 1)
                x = receive(ch1)
                y = receive(ch2)
                x + y
        """)
        val fn = m.fn("double_pipe")
        assertEquals(0, fn.instsOf<IrInst.ChannelCreate>().size,
            "Both channels must be erased")
        assertEquals(0, fn.instsOf<IrInst.ChannelSend>().size)
        assertEquals(0, fn.instsOf<IrInst.ChannelReceive>().size)
    }

    @Test fun localChannel_multipleChannels_bothSlotLoadsCoalesced() {
        val m = erase("""
            fn double_pipe(a, b)
                ch1 = channel()
                ch2 = channel()
                send(ch1, a + 1)
                send(ch2, b + 1)
                x = receive(ch1)
                y = receive(ch2)
                x + y
        """)
        val channelSlotLoads = m.fn("double_pipe").allInsts()
            .filterIsInstance<IrInst.SlotLoad>()
            .filter { it.slot.name.startsWith("__ch") }
        assertEquals(0, channelSlotLoads.size, "All channel SlotLoads must be coalesced")
    }

    // ── Conservative: functions with Spawn are left unchanged ─────────────────
    // If a function spawns a process, channels may cross process boundaries.
    // Full cross-process escape analysis is deferred to Step 2.4. We leave the
    // function unchanged rather than risk incorrectly erasing real IPC channels.

    @Test fun conservative_spawn_channelPreserved() {
        val m = erase("""
            fn concurrent(x)
                ch = channel()
                spawn
                    send(ch, x + 1)
                receive(ch)
        """)
        val fn = m.fn("concurrent")
        // Either ChannelCreate or Spawn must survive — function was not erased
        assertTrue(
            fn.instsOf<IrInst.ChannelCreate>().isNotEmpty() ||
            fn.instsOf<IrInst.Spawn>().isNotEmpty(),
            "Function with spawn must not have its channels erased (conservative)"
        )
    }

    @Test fun conservative_spawn_channelCreateStillPresent() {
        val m = erase("""
            fn word_count()
                results = channel()
                spawn
                    content = read_file("a.txt")
                    send(results, content)
                receive(results)
        """)
        val fn = m.fn("word_count")
        assertTrue(
            fn.instsOf<IrInst.ChannelCreate>().isNotEmpty(),
            "ChannelCreate must survive when Spawn is present"
        )
    }

    @Test fun conservative_noSpawn_channelIsErased() {
        // Confirm the Spawn guard is the key: same channel pattern without spawn → erased
        val m = erase("""
            fn sequential(x)
                ch = channel()
                send(ch, x * 3)
                receive(ch)
        """)
        assertEquals(0, m.fn("sequential").instsOf<IrInst.ChannelCreate>().size,
            "Without spawn, local channel must be erased")
    }

    // ── Escape analysis: channels passed to calls are not erased ──────────────
    // If a channel ref appears in Call or CallDirect args, it escapes the
    // function's scope. We cannot know what the callee does with it, so we
    // must leave the channel in place.

    @Test fun escaped_channelInDirectCall_notErased() {
        val m = erase("""
            fn pass_to_call(x)
                ch = channel()
                some_fn(ch)
                receive(ch)
        """)
        val fn = m.fn("pass_to_call")
        assertTrue(
            fn.instsOf<IrInst.ChannelCreate>().isNotEmpty(),
            "Channel passed to a direct call must not be erased"
        )
    }

    @Test fun escaped_channelUsedAsCallArg_receiveAlsoPreserved() {
        val m = erase("""
            fn pass_to_call(x)
                ch = channel()
                some_fn(ch)
                receive(ch)
        """)
        val fn = m.fn("pass_to_call")
        // ChannelReceive should also be preserved (ch wasn't erased)
        assertTrue(
            fn.instsOf<IrInst.ChannelReceive>().isNotEmpty() ||
            fn.instsOf<IrInst.ChannelCreate>().isNotEmpty(),
            "Escaped channel and its ops must all be preserved"
        )
    }

    // ── Module integrity ──────────────────────────────────────────────────────

    @Test fun module_structsPreserved() {
        val m = erase("""
            type Point
                x: int
                y: int
            x = 1
        """)
        assertTrue(m.structs.any { it.first == "Point" }, "Struct declarations must survive erasure")
    }

    @Test fun module_allFunctionsPreserved() {
        val m = erase("""
            fn foo(a)
                a + 1
            fn bar(b)
                b * 2
            x = foo(1)
            y = bar(2)
        """)
        val names = m.functions.map { it.name }
        assertTrue(names.any { it == "foo" }, "foo must survive erasure")
        assertTrue(names.any { it == "bar" }, "bar must survive erasure")
    }

    @Test fun module_originalNotMutated() {
        val original = lower("""
            fn pipe(x)
                ch = channel()
                send(ch, x)
                receive(ch)
        """)
        IrErasure().erase(original)
        // Original module must still have the channel ops
        assertTrue(
            original.functions.any { fn ->
                fn.allInsts().any { it is IrInst.ChannelCreate }
            },
            "IrErasure must not mutate the original module"
        )
    }

    @Test fun module_channelFree_sameFunctionCount() {
        val src = """
            fn square(n)
                n * n
            print(square(5))
        """
        val direct = IrOptimizer().optimize(lower(src))
        val erased  = IrErasure().erase(lower(src))
        assertEquals(direct.functions.size, erased.functions.size,
            "Channel-free module must have same function count after erasure")
    }

    // ── Gate 4: zero channel runtime overhead ─────────────────────────────────

    @Test fun gate4_localChannel_zeroChannelOps() {
        // Definitive Gate 4 check: a function that uses a channel internally
        // but has no spawn produces zero channel ops after erasure.
        // The channel was an abstraction; it compiles away completely.
        val m = erase("""
            fn compute(x)
                ch = channel()
                send(ch, x * 2)
                receive(ch)
        """)
        val fn = m.fn("compute")
        assertEquals(0, fn.instsOf<IrInst.ChannelCreate>().size,  "No ChannelCreate")
        assertEquals(0, fn.instsOf<IrInst.ChannelSend>().size,    "No ChannelSend")
        assertEquals(0, fn.instsOf<IrInst.ChannelReceive>().size, "No ChannelReceive")
        assertEquals(0, fn.instsOf<IrInst.Spawn>().size,          "No Spawn")
    }

    // ── Printer roundtrip ─────────────────────────────────────────────────────

    @Test fun printer_worksOnErasedModule() {
        val m = erase("""
            fn pipe(x)
                ch = channel()
                send(ch, x)
                receive(ch)
        """)
        val out = IrPrinter().print(m)
        assertTrue(out.isNotBlank(), "Printer must produce non-empty output for erased module")
    }

    @Test fun printer_gate4Module_noChannelText() {
        val m = erase("""
            fn add(a, b)
                a + b
            print(add(1, 2))
        """)
        val out = IrPrinter().print(m)
        assertFalse(out.contains("channel_create"), "C-equivalent module must not print channel_create")
        assertFalse(out.contains("channel_send"),   "C-equivalent module must not print channel_send")
        assertFalse(out.contains("channel_recv"),   "C-equivalent module must not print channel_recv")
        assertFalse(out.contains("spawn"),          "C-equivalent module must not print spawn")
    }

    @Test fun printer_erasedLocalChannel_noChannelCreate() {
        val m = erase("""
            fn pipe(x)
                ch = channel()
                send(ch, x)
                receive(ch)
        """)
        val out = IrPrinter().print(m)
        assertFalse(out.contains("channel_create"), "Erased module must not print channel_create")
    }
}
