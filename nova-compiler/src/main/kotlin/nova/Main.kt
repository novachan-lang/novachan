package nova

import nova.interpreter.Interpreter
import nova.lexer.Lexer
import nova.parser.Parser
import nova.repl.Repl

fun main(args: Array<String>) {
    if (args.isEmpty()) {
        Repl().start()
        return
    }
    val file = args[0]
    val source = java.io.File(file).readText()
    val tokens = Lexer(source, file).tokenize()
    val parser = Parser(tokens)
    val program = parser.parse()
    if (parser.errors.isNotEmpty()) {
        parser.errors.forEach { System.err.println("Parse error: ${it.message} at ${it.span}") }
        System.exit(1)
    }
    val interp = Interpreter()
    try {
        interp.run(program)
    } catch (e: nova.interpreter.RuntimeError) {
        System.err.println("Runtime error: ${e.message}")
        System.exit(1)
    }
}
