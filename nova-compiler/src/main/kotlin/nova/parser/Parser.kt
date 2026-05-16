package nova.parser

import nova.lexer.SourceSpan
import nova.lexer.Token
import nova.lexer.TokenType
import nova.lexer.TokenType.*

data class ParseError(val message: String, val span: SourceSpan)

class Parser(private val tokens: List<Token>) {

    private var pos = 0
    val errors = mutableListOf<ParseError>()

    // ── Navigation ────────────────────────────────────────────────────────────
    private fun cur(): Token = tokens.getOrElse(pos) { tokens.last() }
    private fun peek(n: Int = 1): Token = tokens.getOrElse(pos + n) { tokens.last() }

    private fun advance(): Token {
        val t = cur()
        if (t.type != EOF) pos++
        return t
    }

    private fun check(vararg types: TokenType) = cur().type in types
    private fun checkIdent(name: String) = cur().type == IDENT && cur().value == name

    private fun eat(type: TokenType): Token? = if (cur().type == type) advance() else null

    private fun expect(type: TokenType): Token {
        if (cur().type == type) return advance()
        val t = cur()
        addError("expected ${type.name} but got '${t.value}' (${t.type.name})", t.span)
        return Token(type, "", t.span)
    }

    private fun skipNewlines() { while (cur().type == NEWLINE) advance() }

    private fun spanFrom(start: SourceSpan) =
        SourceSpan(start.file, start.start, cur().span.start)

    private fun addError(msg: String, span: SourceSpan) {
        errors.add(ParseError(msg, span))
    }

    // Skip tokens to the next statement boundary for error recovery.
    private fun sync() {
        while (!check(NEWLINE, INDENT, DEDENT, EOF,
                       FN, TYPE, ENUM, IMPORT, RETURN, BREAK, CONTINUE)) {
            advance()
        }
        eat(NEWLINE)
    }

    // ── Entry point ───────────────────────────────────────────────────────────
    fun parse(): Program {
        val start = cur().span
        val stmts = mutableListOf<Stmt>()
        skipNewlines()
        while (!check(EOF)) {
            try {
                stmts.add(parseStmt())
            } catch (_: Exception) {
                addError("unexpected parse failure near '${cur().value}'", cur().span)
                sync()
            }
            skipNewlines()
        }
        return Program(stmts, spanFrom(start))
    }

    // ── Statement dispatch ────────────────────────────────────────────────────
    private fun parseStmt(): Stmt {
        val start = cur().span

        // @annotation
        if (check(AT)) {
            val ann = parseAnnotation()
            // Check for @low_level block BEFORE consuming the NEWLINE
            if (ann.name == "low_level" && check(NEWLINE)) {
                advance()
                return LowLevelBlock(parseBlock(), spanFrom(start))
            }
            skipNewlines()
            return AnnotatedStmt(ann, parseStmt(), spanFrom(start))
        }

        return when (cur().type) {
            FN       -> parseFnDecl(start)
            TYPE     -> parseTypeDecl(start)
            ENUM     -> parseEnumDecl(start)
            IMPORT   -> parseImport(start)
            SPAWN    -> parseSpawnStmt(start)
            FOR      -> parseForStmt(start)
            WHILE    -> parseWhileStmt(start)
            RETURN   -> parseReturnStmt(start)
            BREAK    -> { advance(); eat(NEWLINE); BreakStmt(spanFrom(start)) }
            CONTINUE -> { advance(); eat(NEWLINE); ContinueStmt(spanFrom(start)) }
            // IF and all expressions: parse as expression-or-assignment
            else     -> parseExprOrAssignStmt(start)
        }
    }

    // Parses "expr [OP= expr]" — handles assignments and plain expression statements.
    // IF falls here so that single-line `if cond expr else expr` and multi-line
    // `if cond\n  block` are both handled uniformly through parseExpr → parsePrefix.
    private fun parseExprOrAssignStmt(start: SourceSpan): Stmt {
        val lhs = parseExpr(0)
        val op = when (cur().type) {
            ASSIGN         -> "=";  PLUS_ASSIGN    -> "+="
            MINUS_ASSIGN   -> "-="; STAR_ASSIGN    -> "*="
            SLASH_ASSIGN   -> "/="; PERCENT_ASSIGN -> "%="
            else -> null
        }
        return if (op != null) {
            advance()
            val rhs = parseExpr(0)
            eat(NEWLINE)
            AssignStmt(lhs, op, rhs, spanFrom(start))
        } else {
            eat(NEWLINE)
            ExprStmt(lhs, spanFrom(start))
        }
    }

    // ── fn ────────────────────────────────────────────────────────────────────
    private fun parseFnDecl(start: SourceSpan, annotations: List<Annotation> = emptyList()): FnDecl {
        expect(FN)
        val firstName = expect(IDENT).value
        var receiverType: String? = null
        val name: String
        if (check(DOT)) {
            advance()
            name = expect(IDENT).value
            receiverType = firstName
        } else {
            name = firstName
        }
        expect(LPAREN)
        val params = parseParamList()
        expect(RPAREN)
        val returnType = if (check(THIN_ARROW)) { advance(); parseTypeExpr() } else null
        eat(NEWLINE)
        val body = parseBlock()
        return FnDecl(annotations, name, params, returnType, body, spanFrom(start), receiverType)
    }

    private fun parseParamList(): List<Param> {
        val out = mutableListOf<Param>()
        while (!check(RPAREN, EOF)) {
            val ps = cur().span
            val pname = expect(IDENT).value
            val ptype = if (check(COLON)) { advance(); parseTypeExpr() } else null
            val pdefault = if (check(ASSIGN)) { advance(); parseExpr(0) } else null
            out.add(Param(pname, ptype, spanFrom(ps), pdefault))
            if (eat(COMMA) == null) break
        }
        return out
    }

    // ── type ──────────────────────────────────────────────────────────────────
    private fun parseTypeDecl(start: SourceSpan): TypeDecl {
        expect(TYPE)
        val name = expect(IDENT).value
        eat(NEWLINE)
        val fields = mutableListOf<Field>()
        if (check(INDENT)) {
            advance()
            while (!check(DEDENT, EOF)) {
                skipNewlines()
                if (check(DEDENT, EOF)) break
                val fs = cur().span
                val fn_ = expect(IDENT).value
                expect(COLON)
                val ft = parseTypeExpr()
                fields.add(Field(fn_, ft, spanFrom(fs)))
                eat(NEWLINE)
            }
            eat(DEDENT)
        }
        return TypeDecl(name, fields, spanFrom(start))
    }

    // ── enum ──────────────────────────────────────────────────────────────────
    private fun parseEnumDecl(start: SourceSpan): EnumDecl {
        expect(ENUM)
        val name = expect(IDENT).value
        eat(NEWLINE)
        val variants = mutableListOf<EnumVariant>()
        if (check(INDENT)) {
            advance()
            while (!check(DEDENT, EOF)) {
                skipNewlines()
                if (check(DEDENT, EOF)) break
                val vs = cur().span
                val vname = expect(IDENT).value
                val vfields = if (check(LPAREN)) {
                    advance()
                    val fs = mutableListOf<Field>()
                    while (!check(RPAREN, EOF)) {
                        val ffs = cur().span
                        val ffname = expect(IDENT).value
                        expect(COLON)
                        val fft = parseTypeExpr()
                        fs.add(Field(ffname, fft, spanFrom(ffs)))
                        if (eat(COMMA) == null) break
                    }
                    expect(RPAREN)
                    fs
                } else emptyList()
                variants.add(EnumVariant(vname, vfields, spanFrom(vs)))
                eat(NEWLINE)
            }
            eat(DEDENT)
        }
        return EnumDecl(name, variants, spanFrom(start))
    }

    // ── import ────────────────────────────────────────────────────────────────
    // Supported forms:
    //   import math                    → whole module, qualified as math.fn()
    //   import math as m               → aliased, qualified as m.fn()
    //   import math.{sin, cos}         → selective, unqualified sin(), cos()
    //   import net.http                → sub-module, qualified as http.fn()
    //   import net.http as h           → aliased sub-module
    private fun parseImport(start: SourceSpan): ImportStmt {
        expect(IMPORT)
        val path = mutableListOf(expect(IDENT).value)
        while (check(DOT)) {
            advance()
            // Selective import: import math.{sin, cos}
            if (check(LBRACE)) {
                advance()
                val names = mutableListOf<String>()
                while (!check(RBRACE, EOF)) {
                    names.add(expect(IDENT).value)
                    if (eat(COMMA) == null) break
                }
                expect(RBRACE)
                eat(NEWLINE)
                return ImportStmt(path, null, names, spanFrom(start))
            }
            path.add(expect(IDENT).value)
        }
        val alias = if (check(AS)) { advance(); expect(IDENT).value } else null
        eat(NEWLINE)
        return ImportStmt(path, alias, null, spanFrom(start))
    }

    // ── spawn (statement) ─────────────────────────────────────────────────────
    private fun parseSpawnStmt(start: SourceSpan): Stmt {
        expect(SPAWN)
        if (check(NEWLINE)) {
            advance()
            return SpawnBlockStmt(parseBlock(), spanFrom(start))
        }
        val expr = parseExpr(0)
        eat(NEWLINE)
        return SpawnStmt(expr, spanFrom(start))
    }

    // ── for (statement) ───────────────────────────────────────────────────────
    private fun parseForStmt(start: SourceSpan): ForStmt {
        expect(FOR)
        val v = parsePattern()
        expect(IN)
        val iter = parseExpr(0)
        eat(NEWLINE)
        val body = parseBlock()
        return ForStmt(v, iter, body, spanFrom(start))
    }

    // ── while ─────────────────────────────────────────────────────────────────
    private fun parseWhileStmt(start: SourceSpan): WhileStmt {
        expect(WHILE)
        val cond = parseExpr(0)
        eat(NEWLINE)
        return WhileStmt(cond, parseBlock(), spanFrom(start))
    }

    // ── return (statement) ────────────────────────────────────────────────────
    private fun parseReturnStmt(start: SourceSpan): ReturnStmt {
        expect(RETURN)
        val v = if (!check(NEWLINE, EOF, DEDENT)) parseExpr(0) else null
        eat(NEWLINE)
        return ReturnStmt(v, spanFrom(start))
    }

    // ── Block (INDENT … DEDENT) ───────────────────────────────────────────────
    private fun parseBlock(): Block {
        val start = cur().span
        expect(INDENT)
        val stmts = mutableListOf<Stmt>()
        skipNewlines()
        while (!check(DEDENT, EOF)) {
            stmts.add(parseStmt())
            skipNewlines()
        }
        eat(DEDENT)
        return Block(stmts, spanFrom(start))
    }

    // ── Annotation ────────────────────────────────────────────────────────────
    private fun parseAnnotation(): Annotation {
        val start = cur().span
        expect(AT)
        val name = expect(IDENT).value
        val args = if (check(LPAREN)) {
            advance()
            val list = mutableListOf<Expr>()
            while (!check(RPAREN, EOF)) {
                list.add(parseExpr(0))
                if (eat(COMMA) == null) break
            }
            expect(RPAREN)
            list
        } else emptyList()
        return Annotation(name, args, spanFrom(start))
    }

    // ── Pratt expression parser ───────────────────────────────────────────────
    //
    // Binding powers (lbp consumed by Pratt loop, rbp passed to recursive call):
    //   FAT_ARROW =>  lbp=2,  rbp=1   lambda (right-assoc, lowest infix)
    //   else          lbp=4,  rbp=3   error-default (right-assoc)
    //   catch         lbp=4,  rbp=3   error-catch (right-assoc, same level as else)
    //   or            lbp=6,  rbp=7   boolean or / type union (left-assoc)
    //   and           lbp=8,  rbp=9   boolean and (left-assoc)
    //   |>            lbp=10, rbp=11  pipe (left-assoc)
    //   .. (range)    lbp=12, rbp=13  range — right side parses greedy (+/- bind)
    //   ==,!=,<,> etc lbp=14, rbp=15  comparison (non-assoc effectively)
    //   +, -          lbp=16, rbp=17  additive (left-assoc)
    //   *, /, %       lbp=18, rbp=19  multiplicative (left-assoc)
    //   **            lbp=20, rbp=19  power (right-assoc)
    //   . () []       lbp=24          postfix (left-assoc, highest)
    //
    // NOTE: thenExpr and elseExpr of single-line if use minBp=5 so that `else`
    // (lbp=4 < 5) does NOT bind inside them. The outer Pratt loop handles the
    // second `else` as error-default. This implements C1 correctly.
    // `catch` has the same binding power as `else` for the same reason.

    private fun infixBp(type: TokenType): Pair<Int, Int>? = when (type) {
        FAT_ARROW              -> Pair(2, 1)
        ELSE                   -> Pair(4, 3)
        CATCH                  -> Pair(4, 3)
        OR                     -> Pair(6, 7)
        AND                    -> Pair(8, 9)
        PIPE_GT                -> Pair(10, 11)
        DOT_DOT                -> Pair(12, 13)
        EQ, NEQ, LT, GT,
        LEQ, GEQ, IN           -> Pair(14, 15)
        PLUS, MINUS            -> Pair(16, 17)
        STAR, SLASH, PERCENT   -> Pair(18, 19)
        STAR_STAR              -> Pair(20, 19)
        DOT                    -> Pair(24, 25)
        LPAREN                 -> Pair(24, 0)
        LBRACKET               -> Pair(24, 0)
        else                   -> null
    }

    fun parseExpr(minBp: Int): Expr {
        var lhs = parsePrefix()
        while (true) {
            // Struct literal: TypeName { field: val, ... } — same precedence as call (24)
            if (cur().type == LBRACE && lhs is Ident && 24 >= minBp) {
                advance()
                val fields = mutableListOf<RecordField>()
                while (!check(RBRACE, EOF)) {
                    val fs = cur().span
                    val name = expect(IDENT).value
                    expect(COLON)
                    val value = parseExpr(0)
                    fields.add(RecordField(name, value, spanFrom(fs)))
                    if (eat(COMMA) == null) break
                }
                expect(RBRACE)
                lhs = StructLit(lhs.name, fields, spanFrom(lhs.span))
                continue
            }
            val (lbp, rbp) = infixBp(cur().type) ?: break
            if (lbp < minBp) break
            val opTok = advance()
            lhs = when (opTok.type) {
                DOT -> {
                    val member = expect(IDENT).value
                    MemberAccess(lhs, member, spanFrom(lhs.span))
                }
                LPAREN -> {
                    val args = parseCallArgs()
                    expect(RPAREN)
                    Call(lhs, args, spanFrom(lhs.span))
                }
                LBRACKET -> {
                    if (check(COLON)) {
                        // [:end]
                        advance()
                        val end = if (check(RBRACKET)) null else parseExpr(0)
                        expect(RBRACKET)
                        Slice(lhs, null, end, spanFrom(lhs.span))
                    } else {
                        val first = parseExpr(0)
                        if (check(COLON)) {
                            // [start:end] or [start:]
                            advance()
                            val end = if (check(RBRACKET)) null else parseExpr(0)
                            expect(RBRACKET)
                            Slice(lhs, first, end, spanFrom(lhs.span))
                        } else {
                            expect(RBRACKET)
                            Index(lhs, first, spanFrom(lhs.span))
                        }
                    }
                }
                FAT_ARROW -> {
                    // lambda: lhs => body
                    val params = exprToLambdaParams(lhs)
                    val body = parseLambdaBody()
                    Lambda(params, body, spanFrom(lhs.span))
                }
                ELSE -> {
                    // error-default operator
                    val default = parseExpr(rbp)
                    ElseOp(lhs, default, spanFrom(lhs.span))
                }
                CATCH -> {
                    // expr catch e { block } — handle error with bound message variable
                    val errorVar = expect(IDENT).value
                    eat(NEWLINE)
                    val handler = parseBlock()
                    TryCatchExpr(lhs, errorVar, handler, spanFrom(lhs.span))
                }
                else -> {
                    val rhs = parseExpr(rbp)
                    BinaryOp(lhs, opTok.value, rhs, spanFrom(lhs.span))
                }
            }
        }
        return lhs
    }

    // ── Prefix (nud) ─────────────────────────────────────────────────────────
    private fun parsePrefix(): Expr {
        val start = cur().span
        return when (cur().type) {
            INT_LITERAL -> {
                val tok = advance()
                val raw = tok.value.replace("_", "")
                val v = when {
                    raw.startsWith("0x") || raw.startsWith("0X") ->
                        raw.substring(2).toLong(16)
                    else -> raw.toLong()
                }
                IntLit(v, tok.span)
            }
            FLOAT_LITERAL -> { val tok = advance(); FloatLit(tok.value.toDouble(), tok.span) }
            STRING_LITERAL -> { val tok = advance(); StringLit(tok.value, tok.span) }
            STRING_PART    -> parseStringInterp(start)
            RAW_STRING     -> { val tok = advance(); RawStringLit(tok.value, tok.span) }
            TRUE           -> { advance(); BoolLit(true, start) }
            FALSE          -> { advance(); BoolLit(false, start) }

            IDENT -> { val tok = advance(); Ident(tok.value, tok.span) }

            // Keywords that appear in call position — emit as Ident so the Pratt
            // LPAREN handler turns them into Call nodes.
            SEND, CHANNEL, SUPERVISE, SELECT -> {
                val tok = advance()
                Ident(tok.value, tok.span)
            }

            MINUS -> { advance(); UnaryOp("-", parseExpr(22), spanFrom(start)) }
            NOT   -> { advance(); UnaryOp("not", parseExpr(22), spanFrom(start)) }

            COPY -> {
                advance()
                expect(LPAREN)
                val inner = parseExpr(0)
                expect(RPAREN)
                UnaryOp("copy", inner, spanFrom(start))
            }

            // return in expression position: `expr else return something`
            RETURN -> {
                advance()
                val v = if (canStartExpr()) parseExpr(0) else null
                ReturnExpr(v, spanFrom(start))
            }

            // try expr — evaluate expr; if it errored, propagate error to caller and return
            // minBp=5 so that `else`/`catch` (lbp=4) don't bind inside the try expression
            TRY -> {
                advance()
                val inner = parseExpr(5)
                TryExpr(inner, spanFrom(start))
            }

            LPAREN -> parseParen(start)
            LBRACKET -> parseListLit(start)
            LBRACE   -> parseRecordLit(start)

            // if: unified handler — single-line or multi-line depending on NEWLINE
            IF -> parseIfAny(start)

            FOR -> {
                advance()
                val v = parsePattern()
                expect(IN)
                val iter = parseExpr(0)
                val body: ForExprBody = if (check(NEWLINE)) {
                    advance(); BlockBody(parseBlock(), spanFrom(start))
                } else {
                    ExprBody(parseExpr(0), spanFrom(start))
                }
                ForExpr(v, iter, body, spanFrom(start))
            }

            MATCH -> parseMatchExpr(start)

            // fn(params) body — anonymous function (lambda with fn keyword)
            FN -> {
                advance()
                expect(LPAREN)
                val params = mutableListOf<LambdaParam>()
                while (!check(RPAREN, EOF)) {
                    val pStart = cur().span
                    val name = expect(IDENT).value
                    params.add(LambdaParam(name, pStart))
                    if (eat(COMMA) == null) break
                }
                expect(RPAREN)
                val body = parseLambdaBody()
                Lambda(params, body, spanFrom(start))
            }

            // spawn in expression position
            SPAWN -> { advance(); SpawnExpr(parseExpr(0), spanFrom(start)) }

            RECEIVE -> {
                advance()
                expect(LPAREN)
                val ch = parseExpr(0)
                expect(RPAREN)
                ReceiveExpr(ch, spanFrom(start))
            }

            else -> {
                val tok = advance()
                addError("unexpected token '${tok.value}' in expression", tok.span)
                ErrorExpr("unexpected '${tok.value}'", tok.span)
            }
        }
    }

    // ── Unified if parser ─────────────────────────────────────────────────────
    // C3: NEWLINE after condition → multi-line (IfBlockExpr).
    // No NEWLINE → single-line (IfExpr). Both can appear in statement or expression position.
    //
    // C1: thenExpr and elseExpr are parsed at minBp=5 so `else` (lbp=4) does NOT
    // consume them. The outer Pratt loop sees any subsequent `else` as error-default.
    private fun parseIfAny(start: SourceSpan): Expr {
        advance() // consume if
        val cond = parseExpr(5) // stop before else
        return if (check(NEWLINE)) {
            // Multi-line if
            advance()
            val thenBlock = parseBlock()
            val elseClause: ElseClause? = if (check(ELSE)) {
                val es = cur().span
                advance()
                if (check(IF)) {
                    ElseIf(parseIfAny(cur().span), spanFrom(es))
                } else {
                    eat(NEWLINE)
                    ElseBlock(parseBlock(), spanFrom(es))
                }
            } else null
            IfBlockExpr(cond, thenBlock, elseClause, spanFrom(start))
        } else {
            // Single-line if
            val thenExpr = parseExpr(5)
            val elseExpr: Expr? = if (eat(ELSE) != null) parseExpr(5) else null
            IfExpr(cond, thenExpr, elseExpr, spanFrom(start))
        }
    }

    // ── match expression ──────────────────────────────────────────────────────
    private fun parseMatchExpr(start: SourceSpan): MatchExpr {
        advance() // consume match
        val subject = parseExpr(0)
        eat(NEWLINE)
        expect(INDENT)
        val arms = mutableListOf<MatchArm>()
        skipNewlines()
        while (!check(DEDENT, EOF)) {
            val as_ = cur().span
            val pat = parsePattern()
            expect(FAT_ARROW)
            val body: ForExprBody = if (check(NEWLINE)) {
                advance(); BlockBody(parseBlock(), spanFrom(as_))
            } else {
                val e = parseExpr(0)
                eat(NEWLINE)
                ExprBody(e, spanFrom(as_))
            }
            arms.add(MatchArm(pat, body, spanFrom(as_)))
            skipNewlines()
        }
        eat(DEDENT)
        return MatchExpr(subject, arms, spanFrom(start))
    }

    // ── String interpolation ──────────────────────────────────────────────────
    // Lexer token sequence: STRING_PART [INTERP_START expr INTERP_END STRING_PART]*
    private fun parseStringInterp(start: SourceSpan): Expr {
        val parts = mutableListOf<InterpPart>()
        while (check(STRING_PART)) {
            val tok = advance()
            parts.add(StringPart(tok.value, tok.span))
            if (check(INTERP_START)) {
                val is_ = cur().span
                advance() // consume INTERP_START
                if (check(INTERP_END)) {
                    // Empty {}: not valid — use \{ \} for literal braces.
                    // Recover by emitting an empty string part.
                    addError("empty string interpolation '{}'; use '\\{\\}' for literal braces", is_)
                    advance()
                } else {
                    val expr = parseExpr(0)
                    expect(INTERP_END)
                    parts.add(ExprPart(expr, spanFrom(is_)))
                }
            }
        }
        return StringInterp(parts, spanFrom(start))
    }

    // ── Paren / tuple ─────────────────────────────────────────────────────────
    private fun parseParen(start: SourceSpan): Expr {
        advance() // (
        if (check(RPAREN)) { advance(); return TupleLit(emptyList(), spanFrom(start)) }
        val first = parseExpr(0)
        return if (check(COMMA)) {
            val elems = mutableListOf(first)
            while (eat(COMMA) != null) {
                if (check(RPAREN)) break
                elems.add(parseExpr(0))
            }
            expect(RPAREN)
            TupleLit(elems, spanFrom(start))
        } else {
            expect(RPAREN)
            first
        }
    }

    // ── List literal ──────────────────────────────────────────────────────────
    private fun parseListLit(start: SourceSpan): Expr {
        advance() // [
        val elems = mutableListOf<Expr>()
        while (!check(RBRACKET, EOF)) {
            elems.add(parseExpr(0))
            if (eat(COMMA) == null) break
        }
        expect(RBRACKET)
        return ListLit(elems, spanFrom(start))
    }

    // ── Record literal { name: val, … } or dict literal { "key": val, … } ──────
    // Disambiguation rule:
    //   {}              → DictLit (empty dict — most common intent for an empty brace literal)
    //   {"str": val}    → DictLit (first key is STRING_LITERAL → dict)
    //   {name: val}     → RecordLit (first key is IDENT → anonymous record)
    private fun parseRecordLit(start: SourceSpan): Expr {
        advance() // {
        // Empty {} → empty dict literal
        if (check(RBRACE)) { advance(); return DictLit(emptyList(), spanFrom(start)) }
        // String key → dict literal (arbitrary expression keys)
        if (check(STRING_LITERAL, STRING_PART)) {
            val entries = mutableListOf<Pair<Expr, Expr>>()
            while (!check(RBRACE, EOF)) {
                val key = parseExpr(0)
                expect(COLON)
                val value = parseExpr(0)
                entries.add(key to value)
                if (eat(COMMA) == null) break
            }
            expect(RBRACE)
            return DictLit(entries, spanFrom(start))
        }
        // IDENT key → anonymous record literal
        val fields = mutableListOf<RecordField>()
        while (!check(RBRACE, EOF)) {
            val fs = cur().span
            val name = expect(IDENT).value
            expect(COLON)
            val value = parseExpr(0)
            fields.add(RecordField(name, value, spanFrom(fs)))
            if (eat(COMMA) == null) break
        }
        expect(RBRACE)
        return RecordLit(fields, spanFrom(start))
    }

    // ── Lambda body ───────────────────────────────────────────────────────────
    // Called after consuming `=>`. Body is a block if NEWLINE follows; otherwise a single expr.
    // Inside brackets (no NEWLINE tokens), if consecutive expressions follow, they form
    // a multi-statement block.
    private fun parseLambdaBody(): LambdaBody {
        val start = cur().span
        return if (check(NEWLINE)) {
            advance()
            BlockBody(parseBlock(), spanFrom(start))
        } else {
            val expr = parseExpr(0)
            // If the next token can start a new expression (inside brackets without NEWLINEs),
            // keep collecting statements for a multi-statement block body.
            if (canStartExpr() && !check(RPAREN, RBRACKET, RBRACE, COMMA, EOF)) {
                val stmts = mutableListOf<Stmt>(ExprStmt(expr, expr.span))
                while (canStartExpr() && !check(RPAREN, RBRACKET, RBRACE, COMMA, EOF)) {
                    val lhs = parseExpr(0)
                    val op = when (cur().type) {
                        ASSIGN -> "="; PLUS_ASSIGN -> "+="; MINUS_ASSIGN -> "-="
                        STAR_ASSIGN -> "*="; SLASH_ASSIGN -> "/="; PERCENT_ASSIGN -> "%="
                        else -> null
                    }
                    stmts += if (op != null) {
                        advance()
                        val rhs = parseExpr(0)
                        AssignStmt(lhs, op, rhs, spanFrom(lhs.span))
                    } else {
                        ExprStmt(lhs, lhs.span)
                    }
                }
                BlockBody(Block(stmts, spanFrom(start)), spanFrom(start))
            } else {
                ExprBody(expr, spanFrom(start))
            }
        }
    }

    // ── Lambda param conversion ───────────────────────────────────────────────
    private fun exprToLambdaParams(expr: Expr): List<LambdaParam> = when (expr) {
        is Ident -> listOf(LambdaParam(expr.name, expr.span))
        is TupleLit -> expr.elements.map { e ->
            if (e is Ident) LambdaParam(e.name, e.span)
            else { addError("lambda parameter must be an identifier", e.span); LambdaParam("_", e.span) }
        }
        else -> {
            addError("invalid lambda parameter expression", expr.span)
            listOf(LambdaParam("_", expr.span))
        }
    }

    // ── Call argument list ────────────────────────────────────────────────────
    // Named args: IDENT = value  (IDENT = is NOT IDENT =>)
    private fun parseCallArgs(): List<Arg> {
        val args = mutableListOf<Arg>()
        while (!check(RPAREN, EOF)) {
            val as_ = cur().span
            val name: String? = if (check(IDENT) && peek().type == ASSIGN) {
                val n = advance().value; advance(); n
            } else null
            val value = parseExpr(0)
            args.add(Arg(name, value, spanFrom(as_)))
            if (eat(COMMA) == null) break
        }
        return args
    }

    // ── Pattern parsing ───────────────────────────────────────────────────────
    private fun parsePattern(): Pattern {
        val start = cur().span
        return when {
            // Wildcard: identifier with name "_"
            check(IDENT) && cur().value == "_" -> { advance(); WildcardPat(spanFrom(start)) }

            // Tuple pattern
            check(LPAREN) -> {
                advance()
                if (check(RPAREN)) { advance(); return TuplePat(emptyList(), spanFrom(start)) }
                val pats = mutableListOf(parsePattern())
                while (eat(COMMA) != null) {
                    if (check(RPAREN)) break
                    pats.add(parsePattern())
                }
                expect(RPAREN)
                TuplePat(pats, spanFrom(start))
            }

            check(INT_LITERAL) -> {
                val t = advance()
                LiteralPat(IntLit(t.value.toLong(), t.span), t.span)
            }
            check(FLOAT_LITERAL) -> {
                val t = advance()
                LiteralPat(FloatLit(t.value.toDouble(), t.span), t.span)
            }
            check(STRING_LITERAL) -> {
                val t = advance()
                LiteralPat(StringLit(t.value, t.span), t.span)
            }
            check(TRUE)  -> { val t = advance(); LiteralPat(BoolLit(true, t.span), t.span) }
            check(FALSE) -> { val t = advance(); LiteralPat(BoolLit(false, t.span), t.span) }

            // Identifier or constructor: UPPERCASE(pat) or lowercase
            check(IDENT) -> {
                val tok = advance()
                if (tok.value[0].isUpperCase() && check(LPAREN)) {
                    advance()
                    val inner = if (!check(RPAREN)) {
                        val first = parsePattern()
                        if (check(COMMA)) {
                            val pats = mutableListOf(first)
                            while (eat(COMMA) != null) {
                                if (check(RPAREN)) break
                                pats.add(parsePattern())
                            }
                            TuplePat(pats, spanFrom(start))
                        } else first
                    } else null
                    expect(RPAREN)
                    ConstructorPat(tok.value, inner, spanFrom(start))
                } else {
                    IdentPat(tok.value, tok.span)
                }
            }

            else -> {
                val tok = advance()
                addError("expected pattern, got '${tok.value}'", tok.span)
                WildcardPat(spanFrom(start))
            }
        }
    }

    // ── Type expression ───────────────────────────────────────────────────────
    // name  or  name or name  (union type)
    private fun parseTypeExpr(): TypeExpr {
        val start = cur().span
        val name = expect(IDENT).value
        var t: TypeExpr = if (check(LT)) {
            advance()
            val args = mutableListOf(parseTypeExpr())
            while (check(COMMA)) { advance(); args.add(parseTypeExpr()) }
            expect(GT)
            GenericType(name, args, spanFrom(start))
        } else {
            NamedType(name, start)
        }
        while (check(OR)) {
            advance()
            val rname = expect(IDENT).value
            t = UnionType(t, NamedType(rname, cur().span), spanFrom(start))
        }
        return t
    }

    // ── Utility ───────────────────────────────────────────────────────────────
    private fun canStartExpr(): Boolean = cur().type in EXPR_STARTERS

    companion object {
        private val EXPR_STARTERS = setOf(
            IDENT, INT_LITERAL, FLOAT_LITERAL, STRING_LITERAL, STRING_PART,
            RAW_STRING, TRUE, FALSE, LPAREN, LBRACKET, LBRACE,
            MINUS, NOT, IF, FOR, WHILE, MATCH, SPAWN, RECEIVE, RETURN,
            SEND, CHANNEL, SUPERVISE, SELECT, FN, AT, COPY, TRY
        )
    }
}
