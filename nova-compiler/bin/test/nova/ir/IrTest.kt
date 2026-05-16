package nova.ir

import nova.lexer.Lexer
import nova.parser.Parser
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue
import kotlin.test.assertNotNull

class IrTest {

    // ── Helpers ───────────────────────────────────────────────────────────────

    private fun lower(src: String): IrModule {
        val tokens = Lexer(src.trimIndent(), "<test>").tokenize()
        val parser = Parser(tokens)
        val prog = parser.parse()
        assertTrue(parser.errors.isEmpty(), "Parse errors: ${parser.errors}")
        return AstToIr().lower(prog)
    }

    private fun IrModule.fn(name: String): IrFunction =
        functions.find { it.name == name }
            ?: error("No function '$name' in [${functions.joinToString { it.name }}]")

    private fun IrFunction.allInsts(): List<IrInst> = blocks.flatMap { it.instructions }
    private fun IrModule.allInsts(): List<IrInst> = functions.flatMap { it.allInsts() }

    private inline fun <reified T : IrInst> IrFunction.instsOf(): List<T> =
        allInsts().filterIsInstance<T>()

    private inline fun <reified T : IrInst> IrModule.instsOf(): List<T> =
        allInsts().filterIsInstance<T>()

    private inline fun <reified T : IrTerminator> IrFunction.terminatorsOf(): List<T> =
        blocks.mapNotNull { it.terminator }.filterIsInstance<T>()

    // ── Smoke tests: all 10 validation programs lower without errors ───────────

    @Test fun program1_helloWorld() {
        val m = lower("""print("Hello, World!")""")
        assertNotNull(m.fn("nova_main"))
        assertEquals(1, m.functions.size)
    }

    @Test fun program2_variablesMathStrings() {
        val m = lower("""
            name = "Alice"
            age = 30
            radius = 5.0
            area = 3.14159 * radius ** 2
            greeting = "Hello, {name}! You are {age} years old."
            print(greeting)
            items = [1, 2, 3, 4, 5]
        """)
        assertNotNull(m.fn("nova_main"))
        assertTrue(m.instsOf<IrInst.SlotAlloc>().isNotEmpty())
    }

    @Test fun program3_functionsAndControlFlow() {
        val m = lower("""
            fn greet(name)
                print("Hello, {name}!")

            fn max(a, b)
                if a > b a else b

            fn factorial(n)
                if n <= 1
                    return 1
                n * factorial(n - 1)

            greet("World")
        """)
        assertNotNull(m.fn("greet"))
        assertNotNull(m.fn("max"))
        assertNotNull(m.fn("factorial"))
        assertNotNull(m.fn("nova_main"))
    }

    @Test fun program4_errorHandling() {
        val m = lower("""
            fn load_user(id)
                json = fetch("api") else 0
                json

            port = parse_int("8080") else 8080
        """)
        assertNotNull(m.fn("load_user"))
        assertNotNull(m.fn("nova_main"))
        assertTrue(m.instsOf<IrInst.IsError>().isNotEmpty(),
            "else operator should produce IsError instructions")
    }

    @Test fun program5_httpServer() {
        val m = lower("""
            import http
            http.serve(8080, routes =>
                routes.get("/", req => "Hello!")
            )
        """)
        assertNotNull(m.fn("nova_main"))
    }

    @Test fun program6_concurrentChannels() {
        val m = lower("""
            fn word_count(files)
                results = channel()
                for file in files
                    spawn
                        send(results, file)
                total = 0

            word_count(["a.txt", "b.txt"])
        """)
        assertNotNull(m.fn("word_count"))
        assertTrue(m.instsOf<IrInst.ChannelCreate>().isNotEmpty())
        assertTrue(m.instsOf<IrInst.ChannelSend>().isNotEmpty())
        assertTrue(m.instsOf<IrInst.Spawn>().isNotEmpty())
    }

    @Test fun program7_aiInference() {
        val m = lower("""
            import ai
            model = ai.load("resnet50.onnx")
            image = read_file("photo.jpg")
            predictions = model.predict(image)
        """)
        assertNotNull(m.fn("nova_main"))
    }

    @Test fun program8_fullStackSkeleton() {
        val m = lower("""
            import http
            model = load("classifier")
            spawn http.serve(8080, routes =>
                routes.get("/api", req => model.predict(req))
            )
        """)
        assertNotNull(m.fn("nova_main"))
        assertTrue(m.instsOf<IrInst.Spawn>().isNotEmpty())
    }

    @Test fun program9_systemsMemory() {
        val m = lower("""
            type RingBuffer
                _handle: int

            fn ring_buffer(capacity)
                capacity

            rb = ring_buffer(1024)
        """)
        assertNotNull(m.fn("ring_buffer"))
        assertTrue(m.structs.any { it.first == "RingBuffer" })
    }

    @Test fun program10_distributedService() {
        val m = lower("""
            import http

            fn main()
                result_ch = channel()
                spawn
                    send(result_ch, "done")
                val = receive(result_ch)

            main()
        """)
        assertNotNull(m.fn("main"))
        assertTrue(m.instsOf<IrInst.ChannelCreate>().isNotEmpty())
        assertTrue(m.instsOf<IrInst.ChannelReceive>().isNotEmpty())
    }

    // ── Slot allocation invariant ─────────────────────────────────────────────
    // LLVM's mem2reg requires all allocas to be in the entry block.

    @Test fun slotsAlwaysAllocatedInEntryBlock() {
        val m = lower("""
            x = 42
            if true
                y = 10
            z = x + 1
        """)
        val main = m.fn("nova_main")
        val entryBlock = main.blocks.first()
        val allSlotAllocs = main.allInsts().filterIsInstance<IrInst.SlotAlloc>()
        val entrySlotAllocs = entryBlock.instructions.filterIsInstance<IrInst.SlotAlloc>()
        assertEquals(allSlotAllocs.size, entrySlotAllocs.size,
            "All SlotAlloc instructions must be in the entry block (mem2reg invariant)")
    }

    // ── Assignment and variable tests ─────────────────────────────────────────

    @Test fun variableAssignmentProducesSlotOps() {
        val m = lower("x = 42")
        val main = m.fn("nova_main")
        assertTrue(main.instsOf<IrInst.SlotAlloc>().any { it.slot.name == "x" })
        assertTrue(main.instsOf<IrInst.SlotStore>().isNotEmpty())
    }

    @Test fun variableReadProducesSlotLoad() {
        val m = lower("x = 42\ny = x + 1")
        val main = m.fn("nova_main")
        assertTrue(main.instsOf<IrInst.SlotLoad>().any { it.slot.name == "x" })
    }

    @Test fun compoundAssignmentUsesAddBinaryOp() {
        val m = lower("total = 0\ntotal += 5")
        val main = m.fn("nova_main")
        assertTrue(main.instsOf<IrInst.Binary>().any { it.op == BinOp.ADD })
    }

    // ── Expression lowering tests ─────────────────────────────────────────────

    @Test fun binaryOpsLower() {
        val m = lower("x = 3 + 4 * 2")
        val main = m.fn("nova_main")
        assertTrue(main.instsOf<IrInst.Binary>().any { it.op == BinOp.ADD })
        assertTrue(main.instsOf<IrInst.Binary>().any { it.op == BinOp.MUL })
    }

    @Test fun stringInterpolationProducesStringConcat() {
        val m = lower("""
            name = "Alice"
            msg = "Hello, {name}!"
        """)
        val main = m.fn("nova_main")
        assertTrue(main.instsOf<IrInst.StringConcat>().isNotEmpty(),
            "String interpolation must produce StringConcat")
        assertTrue(main.instsOf<IrInst.ToString>().isNotEmpty(),
            "Embedded expression must be converted with ToString")
    }

    @Test fun listLiteralProducesMakeList() {
        val m = lower("xs = [1, 2, 3]")
        val main = m.fn("nova_main")
        assertTrue(main.instsOf<IrInst.MakeList>().any { it.elems.size == 3 })
    }

    @Test fun tupleLiteralProducesMakeTuple() {
        val m = lower("pair = (1, 2)")
        val main = m.fn("nova_main")
        assertTrue(main.instsOf<IrInst.MakeTuple>().any { it.elems.size == 2 })
    }

    // ── Control flow tests ────────────────────────────────────────────────────

    @Test fun ifExprProducesBranch() {
        val m = lower("x = if true 1 else 2")
        val main = m.fn("nova_main")
        assertTrue(main.terminatorsOf<IrTerminator.Branch>().isNotEmpty())
    }

    @Test fun ifBlockExprProducesBranch() {
        val m = lower("""
            x = 5
            if x > 3
                print("big")
            else
                print("small")
        """)
        val main = m.fn("nova_main")
        assertTrue(main.terminatorsOf<IrTerminator.Branch>().isNotEmpty())
    }

    @Test fun whileLoopProducesBranchAndBackEdge() {
        val m = lower("""
            i = 0
            while i < 10
                i += 1
        """)
        val main = m.fn("nova_main")
        assertTrue(main.terminatorsOf<IrTerminator.Branch>().isNotEmpty(),
            "While loop needs Branch for condition check")
        assertTrue(main.terminatorsOf<IrTerminator.Goto>().isNotEmpty(),
            "While loop needs Goto back to header")
    }

    @Test fun forLoopProducesBranchAndBackEdge() {
        val m = lower("""
            total = 0
            for x in [1, 2, 3]
                total += x
        """)
        val main = m.fn("nova_main")
        assertTrue(main.terminatorsOf<IrTerminator.Branch>().isNotEmpty())
        assertTrue(main.terminatorsOf<IrTerminator.Goto>().isNotEmpty())
    }

    @Test fun forExprCollectsWithListAppend() {
        val m = lower("squares = for x in [1, 2, 3] x * x")
        val main = m.fn("nova_main")
        assertTrue(main.instsOf<IrInst.ListAppend>().isNotEmpty(),
            "For-expression must produce ListAppend to accumulate results")
    }

    @Test fun matchExprProducesMultipleBlocks() {
        val m = lower("""
            x = 1
            y = match x
                1 => "one"
                2 => "two"
                _ => "other"
        """)
        val main = m.fn("nova_main")
        assertTrue(main.blocks.size > 4, "Match with 3 arms should produce at least 5 blocks")
    }

    // ── Function lowering tests ───────────────────────────────────────────────

    @Test fun fnDeclHoistedToModule() {
        val m = lower("""
            fn add(a, b)
                a + b
            result = add(1, 2)
        """)
        assertNotNull(m.fn("add"))
        assertNotNull(m.fn("nova_main"))
        assertEquals(2, m.functions.size)
    }

    @Test fun fnHasReturnTerminator() {
        val m = lower("""
            fn double(n)
                n * 2
        """)
        val fn = m.fn("double")
        assertTrue(fn.terminatorsOf<IrTerminator.Return>().isNotEmpty())
    }

    @Test fun mainHasReturnTerminator() {
        val m = lower("""print("hi")""")
        assertTrue(m.fn("nova_main").terminatorsOf<IrTerminator.Return>().isNotEmpty())
    }

    @Test fun nestedFnHoistedWithQualifiedName() {
        val m = lower("""
            fn outer()
                fn inner()
                    42
                inner()
        """)
        assertTrue(m.functions.any { it.name == "outer\$inner" },
            "Nested fn 'inner' inside 'outer' should be hoisted as 'outer\$inner'")
    }

    @Test fun lambdaLiftedAsMakeClosure() {
        val m = lower("double = x => x * 2")
        val main = m.fn("nova_main")
        assertTrue(main.instsOf<IrInst.MakeClosure>().any { it.funcName.contains("lambda") },
            "Lambda must produce MakeClosure pointing to a lifted function")
        assertTrue(m.functions.any { it.name.contains("lambda") },
            "Lifted lambda must appear as a top-level IrFunction")
    }

    @Test fun memberCallExpandsToCallDirect() {
        val m = lower("items = [1, 2, 3]\nitems.push(4)")
        val main = m.fn("nova_main")
        assertTrue(main.instsOf<IrInst.CallDirect>().any { it.funcName == "nova_rt_push" },
            "obj.method(args) should expand to CallDirect(nova_rt_method, ...)")
    }

    // ── Channel / process tests ───────────────────────────────────────────────

    @Test fun channelBuiltinProducesChannelCreate() {
        val m = lower("ch = channel()")
        val creates = m.fn("nova_main").instsOf<IrInst.ChannelCreate>()
        assertEquals(1, creates.size)
    }

    @Test fun sendBuiltinProducesChannelSend() {
        val m = lower("ch = channel()\nsend(ch, 42)")
        assertTrue(m.fn("nova_main").instsOf<IrInst.ChannelSend>().isNotEmpty())
    }

    @Test fun receiveBuiltinProducesChannelReceive() {
        val m = lower("ch = channel()\nval = receive(ch)")
        assertTrue(m.fn("nova_main").instsOf<IrInst.ChannelReceive>().isNotEmpty())
    }

    @Test fun spawnBlockProducesSpawnAndLiftedFn() {
        val m = lower("""
            ch = channel()
            spawn
                send(ch, "done")
        """)
        val main = m.fn("nova_main")
        assertTrue(main.instsOf<IrInst.Spawn>().isNotEmpty())
        assertTrue(m.functions.size > 1, "Spawn body must be lifted to a top-level function")
    }

    // ── ElseOp (error-default) tests ──────────────────────────────────────────

    @Test fun elseOpProducesIsError() {
        val m = lower("""x = parse_int("42") else 0""")
        assertTrue(m.fn("nova_main").instsOf<IrInst.IsError>().isNotEmpty())
    }

    @Test fun elseOpProducesUnwrapError() {
        val m = lower("""x = parse_int("42") else 0""")
        assertTrue(m.fn("nova_main").instsOf<IrInst.UnwrapError>().isNotEmpty())
    }

    @Test fun elseOpProducesBranch() {
        val m = lower("""x = parse_int("42") else 0""")
        assertTrue(m.fn("nova_main").terminatorsOf<IrTerminator.Branch>().isNotEmpty())
    }

    // ── Type / enum declarations ──────────────────────────────────────────────

    @Test fun typeDeclAddsStructToModule() {
        val m = lower("""
            type Point
                x: float
                y: float
        """)
        assertTrue(m.structs.any { it.first == "Point" })
        assertEquals(2, m.structs.first { it.first == "Point" }.second.size,
            "Point struct should have 2 fields")
    }

    @Test fun enumDeclAddsVariantsAsStructs() {
        val m = lower("""
            enum Color
                Red
                Green
                Blue
        """)
        assertTrue(m.structs.any { it.first == "Red" })
        assertTrue(m.structs.any { it.first == "Green" })
        assertTrue(m.structs.any { it.first == "Blue" })
    }

    // ── IrPrinter tests ───────────────────────────────────────────────────────

    @Test fun printerProducesValidOutput() {
        val m = lower("""print("Hello!")""")
        val output = IrPrinter().print(m)
        assertTrue(output.isNotEmpty())
        assertTrue(output.contains("nova_main"))
        assertTrue(output.startsWith("module nova"))
    }

    @Test fun printerShowsSlotAndConstInstructions() {
        val m = lower("x = 42")
        val output = IrPrinter().print(m)
        assertTrue(output.contains("const"))
        assertTrue(output.contains("slot_alloc"))
        assertTrue(output.contains("store"))
    }

    @Test fun printerShowsChannelInstructions() {
        val m = lower("ch = channel()\nsend(ch, 1)")
        val output = IrPrinter().print(m)
        assertTrue(output.contains("channel_create"))
        assertTrue(output.contains("channel_send"))
    }

    @Test fun printerShowsListAppendForForExpr() {
        val m = lower("xs = for i in [1, 2] i * 2")
        val output = IrPrinter().print(m)
        assertTrue(output.contains("list_append"))
    }

    @Test fun printerShowsFunctionSignatureWithParams() {
        val m = lower("""
            fn add(a, b)
                a + b
        """)
        val output = IrPrinter().print(m)
        assertTrue(output.contains("function add("))
        assertTrue(output.contains("a:") || output.contains("a: "))
    }

    @Test fun printerShowsReturnTerminators() {
        val m = lower("x = 1")
        val output = IrPrinter().print(m)
        assertTrue(output.contains("return"))
    }
}
