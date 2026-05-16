---
name: stress-test
description: Stress-test a NOVA design proposal against real-world scenarios. Use when a design idea needs validation before being accepted. Tries to BREAK the proposal.
user-invocable: true
argument-hint: "<design proposal to test>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Stress Test — Break the Proposal

Your job is to be the **devil's advocate**. Try to BREAK the following design proposal:

**Proposal to stress-test:** $ARGUMENTS

## Process

### Step 1: Understand the Proposal
- Read relevant design documents in `NOVA_DESIGN/`
- Understand exactly what is being proposed and why
- Identify the claims (explicit and implicit)

### Step 2: Attack from 5 Angles

**Angle 1 — Performance:**
Can this design achieve C-level performance when needed? Where does it add overhead? Is the overhead acceptable? What's the worst-case scenario?

**Angle 2 — Simplicity:**
Can a beginner understand this? Does it add concepts the developer must learn? Does it create "gotchas" or surprising behavior? Can you explain it in one sentence?

**Angle 3 — Edge Cases:**
What happens at the boundaries? What about empty inputs, huge inputs, circular references, recursive structures, concurrent access, distributed failure?

**Angle 4 — Interaction with Other Decisions:**
Does this contradict any existing design decision? Does it make any future decision harder? Does it close off options we might want later?

**Angle 5 — Real-World Usage:**
Write 3 concrete code examples that exercise this proposal. Do they look natural? Are there cases where the developer would fight the design?

### Step 3: Verdict

Rate the proposal:
- **SOLID** — Survived all angles. Minor issues only. Proceed.
- **PROMISING BUT FLAWED** — Good core idea, but specific problems identified. Fix before proceeding.
- **FUNDAMENTALLY BROKEN** — Core assumption doesn't hold. Rethink.
- **NEEDS MORE INFORMATION** — Can't evaluate without resolving specific unknowns first.

### Step 4: Record
Write results to `NOVA_DESIGN/research/` as a stress-test report.
