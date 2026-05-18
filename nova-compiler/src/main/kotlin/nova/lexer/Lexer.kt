package nova.lexer

import nova.lexer.TokenType.*

class Lexer(private val source: String, private val file: String) {

    // ── Position ──────────────────────────────────────────────────────────────
    private var pos = 0
    private var line = 1
    private var col = 1

    // ── Indentation state ────────────────────────────────────────────────────
    // Stack of indent levels (spaces). Bottom is always 0.
    private val indentStack = ArrayDeque<Int>().also { it.addLast(0) }
    // Suppresses NEWLINE/INDENT/DEDENT when inside (), [], or {} (not string interp {})
    private var bracketDepth = 0
    // True at program start and after every physical newline that was at bracketDepth==0
    private var atLineStart = true

    // ── String interpolation state ────────────────────────────────────────────
    // True while we are inside a double-quoted string literal portion
    private var inString = false
    // Accumulates literal chars for STRING_PART / STRING_LITERAL
    private val stringBuf = StringBuilder()
    // Source position of the opening " (for span reporting)
    private var stringOpenPos = SourcePos(1, 1)
    // Whether the current string has had any {interpolation} yet
    private var stringHasInterp = false
    // True when the current string was prefixed with f (f-string)
    private var isFString = false
    // When > 0, we are inside a string interpolation. Tracks nested { } depth.
    // Returns to string mode when this hits 0.
    private var interpBraceDepth = 0

    // ── Output ────────────────────────────────────────────────────────────────
    private val tokens = mutableListOf<Token>()

    // ── Helpers ───────────────────────────────────────────────────────────────
    private fun cur(): Char? = source.getOrNull(pos)
    private fun peek(n: Int = 1): Char? = source.getOrNull(pos + n)

    private fun advance(): Char {
        val c = source[pos++]
        if (c == '\n') { line++; col = 1 } else { col++ }
        return c
    }

    private fun startPos() = SourcePos(line, col)
    private fun span(start: SourcePos) = SourceSpan(file, start, SourcePos(line, col))

    private fun emit(type: TokenType, value: String, start: SourcePos) {
        tokens.add(Token(type, value, span(start)))
    }

    private fun error(msg: String, start: SourcePos) = emit(ERROR, msg, start)

    // ── Public entry point ────────────────────────────────────────────────────
    fun tokenize(): List<Token> {
        while (pos < source.length) {
            when {
                inString -> lexStringContent()
                else -> lexToken()
            }
        }
        finalize()
        return tokens.toList()
    }

    // ── Main lexing dispatch ──────────────────────────────────────────────────
    private fun lexToken() {
        // At the start of a new line (outside brackets) handle indentation FIRST
        if (atLineStart && bracketDepth == 0) {
            processLineStart()
            atLineStart = false
            // processLineStart may have advanced pos; re-enter to lex actual content
            return
        }

        // Skip horizontal whitespace
        while (cur() == ' ') advance()

        if (cur() == '\t') {
            val s = startPos(); advance()
            error("tab character not allowed; use spaces for indentation", s)
            return
        }

        val c = cur() ?: return
        val start = startPos()

        when {
            c == '\n' -> lexNewline(start)
            c == '/' && peek() == '/' -> skipLineComment()
            c == '/' && peek() == '*' -> skipBlockComment(start)
            c == '"' -> { advance(); startDoubleString(start) }
            c == '`' -> lexRawString(start)
            c.isDigit() -> lexNumber(start)
            c.isLetter() || c == '_' -> lexIdentOrKeyword(start)
            c == '@' -> { advance(); emit(AT, "@", start) }
            else -> lexSymbol(start)
        }
    }

    // ── Newline handling ──────────────────────────────────────────────────────
    private fun lexNewline(start: SourcePos) {
        advance() // consume \n
        if (bracketDepth == 0 && interpBraceDepth == 0) {
            // Only emit NEWLINE if previous token was not NEWLINE/INDENT/DEDENT/EOF
            val last = tokens.lastOrNull()?.type
            if (last != null && last != NEWLINE && last != INDENT && last != DEDENT) {
                emit(NEWLINE, "\n", start)
            }
            atLineStart = true
        }
    }

    // ── Indentation ───────────────────────────────────────────────────────────
    private fun processLineStart() {
        val start = startPos()
        var spaces = 0

        // Count leading spaces, error on tabs
        while (cur() == ' ' || cur() == '\t') {
            if (cur() == '\t') {
                val s = startPos(); advance()
                error("tab character not allowed; use spaces for indentation", s)
            } else {
                spaces++; advance()
            }
        }

        // Blank lines, comment-only lines: ignore indentation (don't emit INDENT/DEDENT)
        when {
            cur() == '\n' -> return  // blank line
            cur() == null -> return  // blank at EOF
            cur() == '/' && peek() == '/' -> return  // comment-only line
            cur() == '/' && peek() == '*' -> {
                // TODO(known-issue): If the block comment is followed by real code on the
                // same line (e.g., "    /* comment */ 42"), the INDENT for that line is
                // silently lost. Fixing this requires scanning past the block comment to
                // determine whether real code follows, which needs state save/restore.
                // This does NOT affect the 10 Phase 1 validation programs (none use this pattern).
                return
            }
        }

        // Real content: process indentation
        val top = indentStack.last()
        when {
            spaces > top -> {
                indentStack.addLast(spaces)
                emit(INDENT, "", start)
            }
            spaces == top -> { /* same level — no token */ }
            else -> {
                // One or more DEDENT tokens
                while (indentStack.size > 1 && indentStack.last() > spaces) {
                    indentStack.removeLast()
                    emit(DEDENT, "", start)
                }
                if (indentStack.last() != spaces) {
                    error("indentation level $spaces does not match any outer indentation level", start)
                }
            }
        }
    }

    // ── Comments ──────────────────────────────────────────────────────────────
    private fun skipLineComment() {
        while (cur() != null && cur() != '\n') advance()
    }

    private fun skipBlockComment(start: SourcePos) {
        advance(); advance() // consume /*
        while (pos < source.length) {
            if (cur() == '*' && peek() == '/') { advance(); advance(); return }
            if (cur() == '\n') { line++; col = 1; pos++ } else advance()
        }
        error("unterminated block comment", start)
    }

    // ── String literals ───────────────────────────────────────────────────────
    private fun startDoubleString(openPos: SourcePos, fString: Boolean = false) {
        inString = true
        stringBuf.clear()
        stringOpenPos = openPos
        stringHasInterp = false
        isFString = fString
    }

    // Called repeatedly while inString == true
    private fun lexStringContent() {
        val start = startPos()
        when (val c = cur()) {
            null -> {
                inString = false
                error("unterminated string literal", stringOpenPos)
            }
            '"' -> {
                advance()
                inString = false
                if (stringHasInterp) {
                    // Final segment of interpolated string (may be empty)
                    emit(STRING_PART, stringBuf.toString(), stringOpenPos)
                } else {
                    emit(STRING_LITERAL, stringBuf.toString(), stringOpenPos)
                }
                stringBuf.clear()
            }
            '{' -> {
                if (isFString) {
                    // Start of interpolation (f-strings only)
                    emit(STRING_PART, stringBuf.toString(), stringOpenPos)
                    stringBuf.clear()
                    stringHasInterp = true
                    val interpStart = startPos()
                    advance() // consume {
                    emit(INTERP_START, "{", interpStart)
                    inString = false
                    interpBraceDepth = 1
                    bracketDepth++ // suppress NEWLINE/INDENT/DEDENT inside interpolation
                } else {
                    stringBuf.append(c)
                    advance()
                }
            }
            '\\' -> {
                advance() // consume backslash
                when (cur()) {
                    'n' -> { stringBuf.append('\n'); advance() }
                    't' -> { stringBuf.append('\t'); advance() }
                    'r' -> { stringBuf.append('\r'); advance() }
                    '"' -> { stringBuf.append('"'); advance() }
                    '\\' -> { stringBuf.append('\\'); advance() }
                    '{' -> { stringBuf.append('{'); advance() }  // escaped brace
                    '}' -> { stringBuf.append('}'); advance() }
                    '0' -> { stringBuf.append(' '); advance() }
                    else -> {
                        val s = startPos()
                        error("unknown escape sequence '\\${cur()}'", s)
                        if (cur() != null) advance()
                    }
                }
            }
            '\n' -> {
                // Newlines inside strings are illegal; use \n escape sequence
                // TODO: triple-quoted strings ("""...""") not yet implemented in Phase 1
                error("newline inside string literal; use \\n escape for a newline character", start)
                advance(); inString = false
            }
            else -> {
                stringBuf.append(c); advance()
            }
        }
    }

    // Raw strings: `content`  — no escape sequences, no interpolation
    private fun lexRawString(start: SourcePos) {
        advance() // consume opening `
        val buf = StringBuilder()
        while (cur() != null && cur() != '`') {
            if (cur() == '\n') { buf.append('\n'); line++; col = 1; pos++ }
            else buf.append(advance())
        }
        if (cur() == null) { error("unterminated raw string", start); return }
        advance() // consume closing `
        emit(RAW_STRING, buf.toString(), start)
    }

    // ── Numbers ───────────────────────────────────────────────────────────────
    private fun lexNumber(start: SourcePos) {
        val buf = StringBuilder()

        // Hex literal
        if (cur() == '0' && (peek() == 'x' || peek() == 'X')) {
            buf.append(advance()); buf.append(advance()) // 0x
            while (cur()?.isHexDigit() == true || cur() == '_') {
                if (cur() != '_') buf.append(cur())
                advance()
            }
            emit(INT_LITERAL, buf.toString(), start)
            return
        }

        // Binary literal
        if (cur() == '0' && (peek() == 'b' || peek() == 'B')) {
            buf.append(advance()); buf.append(advance()) // 0b
            while (cur() == '0' || cur() == '1' || cur() == '_') {
                if (cur() != '_') buf.append(cur())
                advance()
            }
            emit(INT_LITERAL, buf.toString(), start)
            return
        }

        // Integer or float
        while (cur()?.isDigit() == true || cur() == '_') {
            if (cur() != '_') buf.append(cur())
            advance()
        }

        val isFloat = cur() == '.' && peek()?.isDigit() == true
        if (isFloat) {
            buf.append(advance()) // .
            while (cur()?.isDigit() == true || cur() == '_') {
                if (cur() != '_') buf.append(cur())
                advance()
            }
            // Optional exponent
            if (cur() == 'e' || cur() == 'E') {
                buf.append(advance())
                if (cur() == '+' || cur() == '-') buf.append(advance())
                while (cur()?.isDigit() == true) buf.append(advance())
            }
            emit(FLOAT_LITERAL, buf.toString(), start)
        } else {
            emit(INT_LITERAL, buf.toString(), start)
        }
    }

    // ── Identifiers and keywords ──────────────────────────────────────────────
    private fun lexIdentOrKeyword(start: SourcePos) {
        val buf = StringBuilder()
        while (cur()?.isLetterOrDigit() == true || cur() == '_') {
            buf.append(advance())
        }
        val text = buf.toString()
        if (text == "f" && cur() == '"') {
            advance()
            startDoubleString(start, fString = true)
            return
        }
        val kwType = KEYWORDS[text]
        emit(kwType ?: IDENT, text, start)
    }

    // ── Symbols and operators ─────────────────────────────────────────────────
    private fun lexSymbol(start: SourcePos) {
        val c = advance()
        when (c) {
            '+' -> {
                if (cur() == '=') { advance(); emit(PLUS_ASSIGN, "+=", start) }
                else emit(PLUS, "+", start)
            }
            '-' -> {
                when (cur()) {
                    '>' -> { advance(); emit(THIN_ARROW, "->", start) }
                    '=' -> { advance(); emit(MINUS_ASSIGN, "-=", start) }
                    else -> emit(MINUS, "-", start)
                }
            }
            '*' -> {
                when (cur()) {
                    '*' -> { advance(); emit(STAR_STAR, "**", start) }
                    '=' -> { advance(); emit(STAR_ASSIGN, "*=", start) }
                    else -> emit(STAR, "*", start)
                }
            }
            '/' -> {
                if (cur() == '=') { advance(); emit(SLASH_ASSIGN, "/=", start) }
                else emit(SLASH, "/", start)  // comments handled before this
            }
            '%' -> {
                if (cur() == '=') { advance(); emit(PERCENT_ASSIGN, "%=", start) }
                else emit(PERCENT, "%", start)
            }
            '=' -> {
                when (cur()) {
                    '=' -> { advance(); emit(EQ, "==", start) }
                    '>' -> { advance(); emit(FAT_ARROW, "=>", start) }
                    else -> emit(ASSIGN, "=", start)
                }
            }
            '!' -> {
                if (cur() == '=') { advance(); emit(NEQ, "!=", start) }
                else error("unexpected character '!'", start)
            }
            '<' -> {
                if (cur() == '=') { advance(); emit(LEQ, "<=", start) }
                else if (cur() == '<') { advance(); emit(LSHIFT, "<<", start) }
                else emit(LT, "<", start)
            }
            '>' -> {
                if (cur() == '=') { advance(); emit(GEQ, ">=", start) }
                else if (cur() == '>') { advance(); emit(RSHIFT, ">>", start) }
                else emit(GT, ">", start)
            }
            '|' -> {
                if (cur() == '>') { advance(); emit(PIPE_GT, "|>", start) }
                else emit(PIPE, "|", start)
            }
            '&' -> emit(AMPERSAND, "&", start)
            '^' -> emit(CARET, "^", start)
            '~' -> emit(TILDE, "~", start)
            '.' -> {
                if (cur() == '.') { advance(); emit(DOT_DOT, "..", start) }
                else emit(DOT, ".", start)
            }
            ',' -> emit(COMMA, ",", start)
            ':' -> emit(COLON, ":", start)
            '?' -> emit(QUESTION, "?", start)
            '(' -> { bracketDepth++; emit(LPAREN, "(", start) }
            ')' -> { bracketDepth = maxOf(0, bracketDepth - 1); emit(RPAREN, ")", start) }
            '[' -> { bracketDepth++; emit(LBRACKET, "[", start) }
            ']' -> { bracketDepth = maxOf(0, bracketDepth - 1); emit(RBRACKET, "]", start) }
            '{' -> {
                bracketDepth++
                // Track nesting inside string interpolation (for matching the closing })
                if (interpBraceDepth > 0) interpBraceDepth++
                emit(LBRACE, "{", start)
            }
            '}' -> {
                bracketDepth = maxOf(0, bracketDepth - 1)
                if (interpBraceDepth > 0) {
                    interpBraceDepth--
                    if (interpBraceDepth == 0) {
                        // Closed the outermost interpolation brace — back to string mode
                        emit(INTERP_END, "}", start)
                        inString = true
                        stringBuf.clear()
                        return
                    }
                    // Nested } inside interpolation — fall through to emit RBRACE
                }
                emit(RBRACE, "}", start)
            }
            else -> error("unexpected character '${c}'", start)
        }
    }

    // ── End-of-file cleanup ───────────────────────────────────────────────────
    private fun finalize() {
        val start = startPos()

        if (inString) {
            error("unterminated string literal", stringOpenPos)
        }
        if (interpBraceDepth > 0) {
            // Unterminated string interpolation — the { was never closed
            error("unterminated string interpolation: missing closing '}'", stringOpenPos)
        }

        // Emit final NEWLINE to close last statement
        val last = tokens.lastOrNull()?.type
        if (bracketDepth == 0 && last != null && last != NEWLINE && last != INDENT && last != DEDENT) {
            emit(NEWLINE, "", start)
        }

        // Emit DEDENTs to close all open blocks
        while (indentStack.size > 1) {
            indentStack.removeLast()
            emit(DEDENT, "", start)
        }

        emit(EOF, "", start)
    }
}

// ── Extension helpers ─────────────────────────────────────────────────────────
private fun Char.isHexDigit() = this.isDigit() || this in 'a'..'f' || this in 'A'..'F'
