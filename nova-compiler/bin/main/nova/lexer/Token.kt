package nova.lexer

// ─── Source location ─────────────────────────────────────────────────────────

data class SourcePos(val line: Int, val col: Int)

data class SourceSpan(
    val file: String,
    val start: SourcePos,
    val end: SourcePos,
) {
    override fun toString(): String = "$file:${start.line}:${start.col}"
}

// ─── Token types ─────────────────────────────────────────────────────────────

enum class TokenType {
    // ── Keywords ─────────────────────────────────────────────────────────────
    // Core (22 from programs_final.md)
    FN, RETURN, IF, ELSE, FOR, WHILE, MATCH, BREAK, CONTINUE,
    TYPE, ENUM, SPAWN, SEND, RECEIVE, CHANNEL,
    OR, AND, NOT, COPY, IMPORT, TRUE, FALSE,
    // Additional required by syntax (not in original 22 list but unambiguously keywords)
    IN,         // `for i in list`
    AS,         // `import http as h`
    SELECT,     // `select` multiplexing construct
    SUPERVISE,  // `supervise worker restart: always`
    TRY,        // `try expr` — propagate error to caller
    CATCH,      // `expr catch e { block }` — handle error with binding

    // ── Literals ─────────────────────────────────────────────────────────────
    INT_LITERAL,    // 42, 1_000_000
    FLOAT_LITERAL,  // 3.14, 1.0e10
    // Simple string with no interpolation: "hello"
    STRING_LITERAL,
    // Interpolated string segments: "hello {name}!" → STRING_PART INTERP_START IDENT INTERP_END STRING_PART
    STRING_PART,    // literal segment inside interpolated string
    INTERP_START,   // the { that begins an interpolated expression (inside a string)
    INTERP_END,     // the } that ends an interpolated expression (inside a string)
    // Raw string: `no {escapes} here`
    RAW_STRING,

    // ── Identifiers ──────────────────────────────────────────────────────────
    IDENT,      // includes `_` wildcard (parser distinguishes)

    // ── Arithmetic operators ──────────────────────────────────────────────────
    PLUS,       // +
    MINUS,      // -
    STAR,       // *
    SLASH,      // /
    PERCENT,    // %
    STAR_STAR,  // **  (power)

    // ── Comparison operators ──────────────────────────────────────────────────
    EQ,         // ==
    NEQ,        // !=
    LT,         // <
    GT,         // >
    LEQ,        // <=
    GEQ,        // >=

    // ── Assignment ───────────────────────────────────────────────────────────
    ASSIGN,         // =
    PLUS_ASSIGN,    // +=
    MINUS_ASSIGN,   // -=
    STAR_ASSIGN,    // *=
    SLASH_ASSIGN,   // /=
    PERCENT_ASSIGN, // %=

    // ── Arrow operators ──────────────────────────────────────────────────────
    FAT_ARROW,  // =>  (lambdas, match arms)
    THIN_ARROW, // ->  (return type annotations)

    // ── Pipeline ─────────────────────────────────────────────────────────────
    PIPE_GT,    // |>

    // ── Range ────────────────────────────────────────────────────────────────
    DOT_DOT,    // ..   (inclusive range: 1..5 means 1,2,3,4,5)

    // ── Member access ────────────────────────────────────────────────────────
    DOT,        // .

    // ── Delimiters ───────────────────────────────────────────────────────────
    COMMA,      // ,
    COLON,      // :  (type annotations, named args)
    AT,         // @  (annotations: @device, @stack, @low_level)
    QUESTION,   // ?  (reserved for future optional chaining)

    // ── Brackets ─────────────────────────────────────────────────────────────
    LPAREN,     // (
    RPAREN,     // )
    LBRACKET,   // [
    RBRACKET,   // ]
    LBRACE,     // {   (dicts, type bodies; NOT string interpolation—that's INTERP_START)
    RBRACE,     // }

    // ── Layout tokens (indentation-based blocks) ─────────────────────────────
    NEWLINE,    // logical end of statement (suppressed inside brackets)
    INDENT,     // block opened (suppressed inside brackets)
    DEDENT,     // block closed (suppressed inside brackets)

    // ── Special ──────────────────────────────────────────────────────────────
    EOF,
    ERROR,      // invalid character — carries message in value, lexer continues
}

// ─── Token ───────────────────────────────────────────────────────────────────

data class Token(
    val type: TokenType,
    val value: String,  // raw source text for this token (or error message for ERROR tokens)
    val span: SourceSpan,
) {
    override fun toString(): String = "${type.name}(${value.take(40)}) @ $span"
}

// ─── Keyword map ─────────────────────────────────────────────────────────────

val KEYWORDS: Map<String, TokenType> = mapOf(
    "fn"        to TokenType.FN,
    "return"    to TokenType.RETURN,
    "if"        to TokenType.IF,
    "else"      to TokenType.ELSE,
    "for"       to TokenType.FOR,
    "while"     to TokenType.WHILE,
    "match"     to TokenType.MATCH,
    "break"     to TokenType.BREAK,
    "continue"  to TokenType.CONTINUE,
    "type"      to TokenType.TYPE,
    "enum"      to TokenType.ENUM,
    "spawn"     to TokenType.SPAWN,
    "send"      to TokenType.SEND,
    "receive"   to TokenType.RECEIVE,
    "channel"   to TokenType.CHANNEL,
    "or"        to TokenType.OR,
    "and"       to TokenType.AND,
    "not"       to TokenType.NOT,
    "copy"      to TokenType.COPY,
    "import"    to TokenType.IMPORT,
    "true"      to TokenType.TRUE,
    "false"     to TokenType.FALSE,
    "in"        to TokenType.IN,
    "as"        to TokenType.AS,
    "select"    to TokenType.SELECT,
    "supervise" to TokenType.SUPERVISE,
    "try"       to TokenType.TRY,
    "catch"     to TokenType.CATCH,
)
