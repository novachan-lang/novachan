---
# Design Decision: Naming Convention

**Date:** 2026-05-10
**Status:** ACCEPTED
**Decided by:** Creator + Chief Language Architect

## Decision

NOVA uses camelCase for all identifiers:
- **Functions:** `camelCase` — `circleArea`, `sumTo`, `collatzSteps`
- **Variables:** `camelCase` — `totalCount`, `loopIndex`, `sinValue`  
- **Types/Structs:** `PascalCase` — `HttpRequest`, `UserProfile`, `Vec3`
- **Constants:** `SCREAMING_SNAKE_CASE` — `MAX_SIZE`, `PI` (for module-level constants only)
- **Modules/Files:** `camelCase` — `httpClient`, `mathUtils`

## Why camelCase (not snake_case)

1. **More concise** — no underscores: `circleArea` vs `circle_area`, `toFloat` vs `to_float`
2. **Creator's background** — Java developer; camelCase is natural and familiar
3. **Majority of modern languages** — Java, Kotlin, JavaScript, C#, Swift all use camelCase for functions
4. **Python is the simplicity target, not the style target** — NOVA aims to be simpler to write than Python, not to look like Python
5. **Consistency with Kotlin** — the compiler's implementation language uses camelCase

## What This Means

- The NOVA standard library uses camelCase: `readFile`, `parseInt`, `joinWith`
- The formatter enforces this convention (Phase 5)
- Type names are always PascalCase: `List`, `Map`, `HttpResponse`
- No mixing allowed — the formatter will rename snake_case to camelCase

## Alternatives Rejected

- **snake_case** (Python/Rust style): Rejected — verbose, adds characters, unfamiliar to Java developers
- **Free choice**: Rejected — NOVA's design principle is "one obvious way"; mixed conventions in a codebase are noise

## Reversal Cost: LOW
This is a convention enforced by the formatter, not by the parser or type system. Changing it later requires only a formatter update and a codebase rename pass.
