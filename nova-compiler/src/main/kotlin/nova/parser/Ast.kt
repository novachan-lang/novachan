package nova.parser

import nova.lexer.SourceSpan

// ── Top level ─────────────────────────────────────────────────────────────────
data class Program(val stmts: List<Stmt>, val span: SourceSpan)

// ── Statements ────────────────────────────────────────────────────────────────
sealed class Stmt { abstract val span: SourceSpan }

data class FnDecl(
    val annotations: List<Annotation>,
    val name: String,
    val params: List<Param>,
    val returnType: TypeExpr?,
    val body: Block,
    override val span: SourceSpan,
    val receiverType: String? = null,
    val typeParams: List<String> = emptyList()
) : Stmt()

data class TypeDecl(
    val name: String,
    val fields: List<Field>,
    override val span: SourceSpan,
    val typeParams: List<String> = emptyList()
) : Stmt()

data class EnumDecl(
    val name: String,
    val variants: List<EnumVariant>,
    override val span: SourceSpan
) : Stmt()

data class TraitDecl(
    val name: String,
    val methods: List<TraitMethod>,
    override val span: SourceSpan
) : Stmt()

data class TraitMethod(val name: String, val params: List<Param>, val returnType: TypeExpr?, val span: SourceSpan)

data class ImportStmt(
    val path: List<String>,
    val alias: String?,
    val selectiveNames: List<String>?,
    override val span: SourceSpan
) : Stmt()

// spawn EXPR  (keeps the process handle)
data class SpawnStmt(val expr: Expr, override val span: SourceSpan) : Stmt()

// spawn NEWLINE INDENT stmts DEDENT  (anonymous block process)
data class SpawnBlockStmt(val body: Block, override val span: SourceSpan) : Stmt()

data class ForStmt(
    val variable: Pattern,
    val iterable: Expr,
    val body: Block,
    override val span: SourceSpan
) : Stmt()

data class WhileStmt(
    val condition: Expr,
    val body: Block,
    override val span: SourceSpan
) : Stmt()

// NOTE: IfStmt is intentionally unused — all ifs parse as IfExpr or IfBlockExpr (Expr),
// wrapped in ExprStmt when at statement level. Kept as a potential future convenience node.
// Do NOT use in type inference or interpreter — use IfBlockExpr instead.

data class ReturnStmt(val value: Expr?, override val span: SourceSpan) : Stmt()
data class YieldStmt(val value: Expr, override val span: SourceSpan) : Stmt()
data class BreakStmt(override val span: SourceSpan) : Stmt()
data class ContinueStmt(override val span: SourceSpan) : Stmt()

data class AssignStmt(
    val target: Expr,
    val op: String,
    val value: Expr,
    override val span: SourceSpan
) : Stmt()

data class ExprStmt(val expr: Expr, override val span: SourceSpan) : Stmt()

data class AnnotatedStmt(
    val annotation: Annotation,
    val stmt: Stmt,
    override val span: SourceSpan
) : Stmt()

data class LowLevelBlock(val body: Block, override val span: SourceSpan) : Stmt()

data class ErrorStmt(val message: String, override val span: SourceSpan) : Stmt()

// ── Else clauses ──────────────────────────────────────────────────────────────
sealed class ElseClause { abstract val span: SourceSpan }
data class ElseBlock(val body: Block, override val span: SourceSpan) : ElseClause()
// Holds the chained if-expression (IfBlockExpr or IfExpr)
data class ElseIf(val ifExpr: Expr, override val span: SourceSpan) : ElseClause()

// ── Block ─────────────────────────────────────────────────────────────────────
data class Block(val stmts: List<Stmt>, val span: SourceSpan)

// ── Expressions ──────────────────────────────────────────────────────────────
sealed class Expr { abstract val span: SourceSpan }

data class IntLit(val value: Long, override val span: SourceSpan) : Expr()
data class FloatLit(val value: Double, override val span: SourceSpan) : Expr()
data class StringLit(val value: String, override val span: SourceSpan) : Expr()
data class StringInterp(val parts: List<InterpPart>, override val span: SourceSpan) : Expr()
data class RawStringLit(val value: String, override val span: SourceSpan) : Expr()
data class BoolLit(val value: Boolean, override val span: SourceSpan) : Expr()
data class Ident(val name: String, override val span: SourceSpan) : Expr()

data class BinaryOp(
    val left: Expr,
    val op: String,
    val right: Expr,
    override val span: SourceSpan
) : Expr()

data class UnaryOp(
    val op: String,
    val operand: Expr,
    override val span: SourceSpan
) : Expr()

// expr else default  — error-default operator (NOT if/else)
data class ElseOp(val expr: Expr, val default: Expr, override val span: SourceSpan) : Expr()

data class Call(val callee: Expr, val args: List<Arg>, override val span: SourceSpan) : Expr()
data class Index(val target: Expr, val index: Expr, override val span: SourceSpan) : Expr()
data class Slice(val target: Expr, val start: Expr?, val end: Expr?, override val span: SourceSpan) : Expr()
data class MemberAccess(val target: Expr, val member: String, override val span: SourceSpan) : Expr()

data class Lambda(
    val params: List<LambdaParam>,
    val body: LambdaBody,
    override val span: SourceSpan
) : Expr()

// Single-line if: if COND THEN_EXPR [else ELSE_EXPR]
// elseExpr is null only when used as a statement (void if).
data class IfExpr(
    val condition: Expr,
    val thenExpr: Expr,
    val elseExpr: Expr?,
    override val span: SourceSpan
) : Expr()

// Multi-line if: if COND\n block [else block | else if ...]
// Used in both statement and expression position.
data class IfBlockExpr(
    val condition: Expr,
    val thenBlock: Block,
    val elseClause: ElseClause?,
    override val span: SourceSpan
) : Expr()

data class ForExpr(
    val variable: Pattern,
    val iterable: Expr,
    val body: ForExprBody,
    override val span: SourceSpan
) : Expr()

data class MatchExpr(
    val subject: Expr,
    val arms: List<MatchArm>,
    override val span: SourceSpan
) : Expr()

data class TupleLit(val elements: List<Expr>, override val span: SourceSpan) : Expr()
data class ListLit(val elements: List<Expr>, override val span: SourceSpan) : Expr()

// { key: value, ... }  (anonymous record literal — IDENT keys)
data class RecordLit(val fields: List<RecordField>, override val span: SourceSpan) : Expr()

// { "key": value, ... }  (dict/map literal — arbitrary expression keys, typically string literals)
data class DictLit(val entries: List<Pair<Expr, Expr>>, override val span: SourceSpan) : Expr()

// TypeName { key: value, ... }  (named struct construction)
data class StructLit(val typeName: String, val fields: List<RecordField>, override val span: SourceSpan) : Expr()

// spawn in expression position (returns process handle)
data class SpawnExpr(val expr: Expr, override val span: SourceSpan) : Expr()

data class ReceiveExpr(val channel: Expr, override val span: SourceSpan) : Expr()

// return in expression position (e.g., inside `else return ...`)
data class ReturnExpr(val value: Expr?, override val span: SourceSpan) : Expr()

// try expr — evaluates expr; if it errored, propagates the error to the caller and returns
data class TryExpr(val expr: Expr, override val span: SourceSpan) : Expr()

// expr catch e { block } — evaluates expr; if it errored, binds the message to errorVar and runs handler
data class TryCatchExpr(
    val expr: Expr,
    val errorVar: String,
    val handler: Block,
    override val span: SourceSpan
) : Expr()

data class ErrorExpr(val message: String, override val span: SourceSpan) : Expr()

// ── Supporting types ──────────────────────────────────────────────────────────
data class Param(val name: String, val type: TypeExpr?, val span: SourceSpan, val default: Expr? = null)
data class LambdaParam(val name: String, val span: SourceSpan)
data class Field(val name: String, val type: TypeExpr, val span: SourceSpan)
data class EnumVariant(val name: String, val fields: List<Field>, val span: SourceSpan)
data class RecordField(val name: String, val value: Expr, val span: SourceSpan)
data class Annotation(val name: String, val args: List<Expr>, val span: SourceSpan)

data class Arg(
    val name: String?,  // null = positional; non-null = named (restart = "always")
    val value: Expr,
    val span: SourceSpan
)

data class MatchArm(val pattern: Pattern, val body: ForExprBody, val span: SourceSpan, val guard: Expr? = null)

// Body for both lambda and for-expression: single expr or indented block.
sealed class ForExprBody { abstract val span: SourceSpan }
data class ExprBody(val expr: Expr, override val span: SourceSpan) : ForExprBody()
data class BlockBody(val block: Block, override val span: SourceSpan) : ForExprBody()

typealias LambdaBody = ForExprBody

// String interpolation parts
sealed class InterpPart { abstract val span: SourceSpan }
data class StringPart(val value: String, override val span: SourceSpan) : InterpPart()
data class ExprPart(val expr: Expr, override val span: SourceSpan) : InterpPart()

// ── Patterns ─────────────────────────────────────────────────────────────────
sealed class Pattern { abstract val span: SourceSpan }
data class WildcardPat(override val span: SourceSpan) : Pattern()
data class IdentPat(val name: String, override val span: SourceSpan) : Pattern()
data class TuplePat(val elements: List<Pattern>, override val span: SourceSpan) : Pattern()
data class ConstructorPat(val name: String, val arg: Pattern?, override val span: SourceSpan) : Pattern()
data class LiteralPat(val lit: Expr, override val span: SourceSpan) : Pattern()

// ── Type expressions ──────────────────────────────────────────────────────────
sealed class TypeExpr { abstract val span: SourceSpan }
data class NamedType(val name: String, override val span: SourceSpan) : TypeExpr()
data class GenericType(val name: String, val args: List<TypeExpr>, override val span: SourceSpan) : TypeExpr()
data class UnionType(val left: TypeExpr, val right: TypeExpr, override val span: SourceSpan) : TypeExpr()
data class OptionalType(val inner: TypeExpr, override val span: SourceSpan) : TypeExpr()
