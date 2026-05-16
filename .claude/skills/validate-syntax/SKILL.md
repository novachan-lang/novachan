---
name: validate-syntax
description: Write sample NOVA code for a proposed syntax and evaluate if it feels right. Use when testing if a proposed language feature looks and reads naturally.
user-invocable: true
argument-hint: "<syntax feature to validate>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Validate Syntax — Does This Feel Right?

Testing whether a proposed NOVA syntax is natural, readable, and consistent.

**Syntax to validate:** $ARGUMENTS

## Process

### Step 1: Understand the Proposal
- What syntax is being proposed?
- What does it express?
- What existing NOVA syntax does it need to be consistent with?

### Step 2: Write 10 Real Examples
Write 10 realistic code snippets using this syntax, ranging from:
1. Simplest possible use (one-liner)
2. Common everyday use (5-10 lines)
3. Complex real-world use (20+ lines)
4. Edge cases and unusual but valid uses
5. Interaction with other NOVA features

### Step 3: Readability Test
For each example, ask:
- Can a Python developer guess what this does? (Accessibility test)
- Can a Rust developer see the performance implications? (Transparency test)
- Is there only ONE way to write this, or multiple? (Consistency test)
- Does it look cluttered or clean? (Aesthetics test)
- Does it read left-to-right naturally? (Flow test)

### Step 4: Comparison
Write the same examples in 3 existing languages (choose the most relevant: Rust, Go, Python, TypeScript, Swift, Kotlin, Elixir). Compare:
- Is NOVA's version simpler?
- Is NOVA's version more expressive?
- Is NOVA's version more readable?
- Where does NOVA's version lose to existing syntax?

### Step 5: Verdict
- ADOPT — This syntax is clear, consistent, and better than alternatives
- REVISE — Good idea but specific changes needed (list them)
- REJECT — Doesn't work for reasons (list them), suggest alternative direction

### Step 6: Record
Save examples and analysis to `NOVA_DESIGN/research/` for reference.
