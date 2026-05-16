package nova.ir

import nova.lexer.Lexer
import nova.parser.Parser
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue
import kotlin.test.assertFalse

class IrOptimizerTest {

    // ── Helpers ───────────────────────────────────────────────────────────────

    private fun lowerAndOptimize(src: String): Pair<IrModule, IrModule> {
        val tokens = Lexer(src.trimIndent(), "<test>").tokenize()
        val parser = Parser(tokens)
        val prog = parser.parse()
        assertTrue(parser.errors.isEmpty(), "Parse errors: ${parser.errors}")
        val original  = AstToIr().lower(prog)
        val optimized = IrOptimizer().optimize(original)
        return original to optimized
    }

    private fun optimized(src: String): IrModule = lowerAndOptimize(src).second
    private fun original(src: String): IrModule  = lowerAndOptimize(src).first

    private fun IrModule.fn(name: String): IrFunction =
        functions.find { it.name == name }
            ?: error("No function '$name' in [${functions.joinToString { it.name }}]")

    private fun IrFunction.allInsts(): List<IrInst> = blocks.flatMap { it.instructions }
    private fun IrModule.allInsts(): List<IrInst>   = functions.flatMap { it.allInsts() }

    private inline fun <reified T : IrInst> IrFunction.instsOf(): List<T> =
        allInsts().filterIsInstance<T>()

    private inline fun <reified T : IrInst> IrModule.instsOf(): List<T> =
        allInsts().filterIsInstance<T>()

    private inline fun <reified T : IrTerminator> IrFunction.terminatorsOf(): List<T> =
        blocks.mapNotNull { it.terminator }.filterIsInstance<T>()

    // ── Dead Block Elimination ────────────────────────────────────────────────

    @Test fun dce_deadBlockAfterReturn_isRemoved() {
        val (orig, opt) = lowerAndOptimize("""
            fn early()
                return 1
                x = 999
        """)
        val origBlocks = orig.fn("early").blocks.size
        val optBlocks  = opt.fn("early").blocks.size
        assertTrue(optBlocks < origBlocks,
            "Expected fewer blocks after DCE: $optBlocks < $origBlocks")
    }

    @Test fun dce_entryBlockAlwaysReachable() {
        val opt = optimized("x = 42")
        assertTrue(opt.fn("nova_main").blocks.isNotEmpty())
    }

    @Test fun dce_whileLoopBlocksSurvive() {
        val opt = optimized("""
            i = 0
            while i < 10
                i += 1
        """)
        val main = opt.fn("nova_main")
        // header, body, exit blocks must survive
        assertTrue(main.blocks.size >= 3,
            "While loop blocks must not be eliminated")
    }

    @Test fun dce_ifBlocksSurvive() {
        val opt = optimized("""
            if true
                x = 1
            else
                x = 2
        """)
        val main = opt.fn("nova_main")
        assertTrue(main.blocks.size >= 3, "If-else must preserve then/else/merge blocks")
    }

    @Test fun dce_noUnreachableBlocksRemain() {
        val opt = optimized("""
            fn multi()
                if true
                    return 1
                return 2
        """)
        val fn = opt.fn("multi")
        // All surviving blocks must be reachable from entry
        val reachable = buildSet<BlockId> {
            val queue = ArrayDeque<BlockId>()
            queue.add(fn.blocks.first().id)
            while (queue.isNotEmpty()) {
                val id = queue.removeFirst()
                if (!add(id)) continue
                val block = fn.blocks.find { it.id == id } ?: continue
                when (val t = block.terminator) {
                    is IrTerminator.Goto   -> queue.add(t.target)
                    is IrTerminator.Branch -> { queue.add(t.thenBlock); queue.add(t.elseBlock) }
                    else -> {}
                }
            }
        }
        assertEquals(fn.blocks.size, reachable.size,
            "Every surviving block must be reachable")
    }

    // ── Constant Folding — integers ───────────────────────────────────────────

    @Test fun fold_intAddition() {
        val opt = optimized("x = 3 + 4")
        val consts = opt.fn("nova_main").instsOf<IrInst.Const>()
        assertTrue(consts.any { it.value == IrConst.Int(7) },
            "3 + 4 must fold to const 7")
        assertFalse(opt.fn("nova_main").instsOf<IrInst.Binary>().any { it.op == BinOp.ADD },
            "Binary ADD must be eliminated after folding")
    }

    @Test fun fold_intMultiplication() {
        val opt = optimized("x = 6 * 7")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Int(42) })
        assertFalse(opt.fn("nova_main").instsOf<IrInst.Binary>().any { it.op == BinOp.MUL })
    }

    @Test fun fold_intSubtraction() {
        val opt = optimized("x = 10 - 3")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Int(7) })
    }

    @Test fun fold_intDivision() {
        val opt = optimized("x = 10 / 2")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Int(5) })
    }

    @Test fun fold_intModulo() {
        val opt = optimized("x = 10 % 3")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Int(1) })
    }

    @Test fun fold_intComparisonGt() {
        val opt = optimized("x = 3 > 2")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Bool(true) })
        assertFalse(opt.fn("nova_main").instsOf<IrInst.Binary>().any { it.op == BinOp.GT })
    }

    @Test fun fold_intComparisonEq() {
        val opt = optimized("x = 42 == 42")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Bool(true) })
    }

    @Test fun fold_intComparisonNe() {
        val opt = optimized("x = 1 != 2")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Bool(true) })
    }

    @Test fun fold_intComparisonLt() {
        val opt = optimized("x = 1 < 2")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Bool(true) })
    }

    // ── Constant Folding — floats ─────────────────────────────────────────────

    @Test fun fold_floatAddition() {
        val opt = optimized("x = 1.5 + 2.5")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Float(4.0) })
    }

    @Test fun fold_floatMultiplication() {
        val opt = optimized("x = 2.0 * 3.5")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Float(7.0) })
    }

    // ── Constant Folding — booleans ───────────────────────────────────────────

    @Test fun fold_boolAnd_falseResult() {
        val opt = optimized("x = true and false")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Bool(false) })
        assertFalse(opt.fn("nova_main").instsOf<IrInst.Binary>().any { it.op == BinOp.AND })
    }

    @Test fun fold_boolOr_trueResult() {
        val opt = optimized("x = false or true")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Bool(true) })
    }

    @Test fun fold_boolAnd_trueResult() {
        val opt = optimized("x = true and true")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Bool(true) })
    }

    // ── Constant Folding — unary ──────────────────────────────────────────────

    @Test fun fold_unaryNegInt() {
        val opt = optimized("x = -5")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Int(-5) },
            "Unary NEG on literal must fold to const -5")
        assertFalse(opt.fn("nova_main").instsOf<IrInst.Unary>().any { it.op == UnOp.NEG })
    }

    @Test fun fold_unaryNot() {
        val opt = optimized("x = not true")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Bool(false) })
        assertFalse(opt.fn("nova_main").instsOf<IrInst.Unary>().any { it.op == UnOp.NOT })
    }

    // ── Constant Folding — chained expressions ────────────────────────────────

    @Test fun fold_chainedArithmetic() {
        // 3 + 4 * 2 → 3 + 8 → 11 (MUL folds first, then ADD)
        val opt = optimized("x = 3 + 4 * 2")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Int(11) })
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Binary>().isEmpty(),
            "All binary ops should be folded for constant expressions")
    }

    @Test fun fold_boolChained() {
        val opt = optimized("x = true and false or true")
        // (true and false) or true = false or true = true
        assertTrue(opt.fn("nova_main").instsOf<IrInst.Const>().any { it.value == IrConst.Bool(true) })
    }

    // ── Slot Coalescing ───────────────────────────────────────────────────────

    @Test fun slotCoalesce_elimsLoadWhenStoreKnown() {
        val (orig, opt) = lowerAndOptimize("""
            x = 42
            y = x + 1
        """)
        val origLoads = orig.fn("nova_main").instsOf<IrInst.SlotLoad>()
        val optLoads  = opt.fn("nova_main").instsOf<IrInst.SlotLoad>()
        assertTrue(optLoads.size < origLoads.size,
            "SlotLoad for x should be eliminated: ${optLoads.size} < ${origLoads.size}")
    }

    @Test fun slotCoalesce_paramLoadEliminated() {
        val opt = optimized("""
            fn double(n)
                n * 2
        """)
        // The parameter n is stored into slot::n and then loaded.
        // After coalescing, the load should be gone within the entry block.
        val fn = opt.fn("double")
        val entryLoads = fn.blocks.first().instructions.filterIsInstance<IrInst.SlotLoad>()
        assertTrue(entryLoads.isEmpty(),
            "SlotLoad for parameter 'n' in entry block should be coalesced away")
    }

    @Test fun slotCoalesce_resultIsCorrect() {
        // x = 3 + 4 = 7; y = x + 0 → should fold y = 7
        // (x stored as const 7, load of x replaced with 7, then 7+0=7)
        val opt = optimized("""
            x = 3 + 4
            y = x
        """)
        val main = opt.fn("nova_main")
        // x = 7 (const fold), y = x = 7 (slot coalesce) → y slot gets value 7
        assertTrue(main.instsOf<IrInst.Const>().any { it.value == IrConst.Int(7) })
    }

    // ── Instruction count reduction ────────────────────────────────────────────

    @Test fun instructionCount_reducedAfterOptimization() {
        val (orig, opt) = lowerAndOptimize("""
            x = 3 + 4
            y = x * 2
        """)
        val origCount = orig.allInsts().size
        val optCount  = opt.allInsts().size
        assertTrue(optCount < origCount,
            "Optimized IR must have fewer instructions: $optCount < $origCount")
    }

    @Test fun instructionCount_fnWithConstBody() {
        // fn that just returns a constant — all binary ops should disappear
        val (orig, opt) = lowerAndOptimize("""
            fn compute()
                100 * 100
        """)
        val origBinaries = orig.fn("compute").instsOf<IrInst.Binary>()
        val optBinaries  = opt.fn("compute").instsOf<IrInst.Binary>()
        assertTrue(optBinaries.size < origBinaries.size,
            "Constant binary ops inside function must be folded")
    }

    // ── Semantic preservation ─────────────────────────────────────────────────

    @Test fun semantics_allPrograms_optimizeWithoutErrors() {
        val programs = listOf(
            """print("Hello, World!")""",
            """
                name = "Alice"
                age = 30
                greeting = "Hello, {name}!"
                print(greeting)
            """,
            """
                fn greet(name)
                    print("Hello, {name}!")
                fn max(a, b)
                    if a > b a else b
                greet("World")
            """,
            """
                fn load(id)
                    json = fetch("api") else 0
                    json
                port = 8080
            """,
            """
                fn word_count(files)
                    results = channel()
                    for file in files
                        spawn
                            send(results, file)
                    total = 0
                word_count(["a.txt"])
            """,
            """
                type Point
                    x: float
                    y: float
                p = Point { x: 1.0, y: 2.0 }
            """
        )
        for (src in programs) {
            val (_, opt) = lowerAndOptimize(src)
            assertTrue(opt.functions.isNotEmpty(), "Optimized module must have functions")
        }
    }

    @Test fun semantics_returnTerminatorsPreserved() {
        val opt = optimized("""
            fn add(a, b)
                a + b
        """)
        assertTrue(opt.fn("add").terminatorsOf<IrTerminator.Return>().isNotEmpty(),
            "Return terminator must survive optimization")
    }

    @Test fun semantics_branchTerminatorsPreserved() {
        val opt = optimized("""
            fn clamp(x)
                if x > 100
                    100
                else
                    x
        """)
        // x > 100 has a runtime operand — Branch must survive optimization
        assertTrue(opt.fn("clamp").terminatorsOf<IrTerminator.Branch>().isNotEmpty())
    }

    @Test fun semantics_channelOpsPreserved() {
        val opt = optimized("""
            ch = channel()
            send(ch, 42)
            val = receive(ch)
        """)
        val main = opt.fn("nova_main")
        assertTrue(main.instsOf<IrInst.ChannelCreate>().isNotEmpty())
        assertTrue(main.instsOf<IrInst.ChannelSend>().isNotEmpty())
        assertTrue(main.instsOf<IrInst.ChannelReceive>().isNotEmpty())
    }

    @Test fun semantics_spawnPreserved() {
        val opt = optimized("""
            ch = channel()
            spawn
                send(ch, "done")
        """)
        assertTrue(opt.instsOf<IrInst.Spawn>().isNotEmpty())
    }

    @Test fun semantics_slotAllocPreserved() {
        // SlotAllocs are side effects — they must never be removed
        val opt = optimized("x = 42")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.SlotAlloc>().isNotEmpty())
    }

    @Test fun semantics_slotStorePreserved() {
        val opt = optimized("x = 42")
        assertTrue(opt.fn("nova_main").instsOf<IrInst.SlotStore>().isNotEmpty())
    }

    @Test fun semantics_functionCountPreserved() {
        val (orig, opt) = lowerAndOptimize("""
            fn add(a, b)
                a + b
            fn sub(a, b)
                a - b
            add(1, 2)
        """)
        assertEquals(orig.functions.size, opt.functions.size,
            "Optimizer must not add or remove functions")
    }

    @Test fun semantics_moduleStructsPreserved() {
        val (orig, opt) = lowerAndOptimize("""
            type Point
                x: float
                y: float
        """)
        assertEquals(orig.structs, opt.structs)
    }

    // ── Non-mutation of original ───────────────────────────────────────────────

    @Test fun originalModule_notMutated() {
        val (orig, _) = lowerAndOptimize("x = 3 + 4")
        // Original must still have the Binary ADD
        val origBinaries = orig.fn("nova_main").instsOf<IrInst.Binary>()
        assertTrue(origBinaries.any { it.op == BinOp.ADD },
            "Optimizer must not mutate the original module")
    }

    // ── IrPrinter works on optimized output ───────────────────────────────────

    @Test fun printer_worksOnOptimizedModule() {
        val opt = optimized("x = 3 + 4")
        val output = IrPrinter().print(opt)
        assertTrue(output.isNotEmpty())
        assertTrue(output.contains("nova_main"))
        // The folded const 7 must appear in the printer output
        assertTrue(output.contains("7"), "Folded constant must appear in printed IR")
    }

    @Test fun printer_optimizedModuleIsSmaller() {
        val src = "x = 1 + 2 + 3 + 4 + 5"
        val origOutput = IrPrinter().print(original(src))
        val optOutput  = IrPrinter().print(optimized(src))
        assertTrue(optOutput.length < origOutput.length,
            "Optimized IR text must be shorter than original")
    }

    // ── Constant folding in functions ─────────────────────────────────────────

    @Test fun fold_insideFunction_constParams_notFolded() {
        // Parameters are runtime values — optimizer must NOT fold them
        val opt = optimized("""
            fn add(a, b)
                a + b
        """)
        // Since a and b are not constants, the Binary ADD must remain
        assertTrue(opt.fn("add").instsOf<IrInst.Binary>().any { it.op == BinOp.ADD },
            "Runtime-value expressions must not be folded")
    }

    @Test fun fold_mixedConstAndRuntime_notFolded() {
        // Only one operand is constant — Binary must NOT be folded
        val opt = optimized("""
            fn add_one(x)
                x + 1
        """)
        // x is a runtime value; 1 is a const — partial fold is not supported
        assertTrue(opt.fn("add_one").instsOf<IrInst.Binary>().any { it.op == BinOp.ADD },
            "Partial constant folding must not happen")
    }
}
