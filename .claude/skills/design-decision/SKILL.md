---
name: design-decision
description: Make and record a formal NOVA design decision with full rationale. Use when the team is ready to commit to a design choice after analysis and stress-testing.
user-invocable: true
argument-hint: "<decision topic>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Design Decision Record

Recording a formal design decision for NOVA.

**Decision topic:** $ARGUMENTS

## Process

### Step 1: Gather Context
- Read all relevant research documents in `NOVA_DESIGN/research/`
- Read all relevant open problems in `NOVA_DESIGN/open_problems/`
- Read existing decisions in `NOVA_DESIGN/decisions/` to check for conflicts
- Summarize what analysis has been done so far

### Step 2: Present the Decision
Write a decision record with this exact structure:

```markdown
# Decision: [Title]

## Date: [YYYY-MM-DD]

## Status: ACCEPTED / PROVISIONAL / SUPERSEDES [previous decision]

## Context
What is the problem? Why must a decision be made now? What forces are at play?

## Decision
What is the decision? State it clearly in 1-3 sentences.

## Rationale
Why this choice over the alternatives? What evidence supports it?

## Alternatives Considered
For each alternative:
- What it is
- Its strongest argument
- Why it was rejected

## Consequences
### Positive
- What this decision enables

### Negative
- What this decision costs or limits

### Neutral
- What this decision changes without clear positive/negative valence

## Tradeoffs Explicitly Accepted
What are we knowingly giving up? Why is that acceptable?

## Interaction with Other Decisions
How does this relate to existing decisions? Does it constrain future decisions?

## Reversal Cost
If this decision turns out to be wrong, how hard is it to change? What would need to be rewritten?

## Validation Criteria
How will we know if this decision was correct? What evidence would prove it wrong?
```

### Step 3: Save
- Save to `NOVA_DESIGN/decisions/` with sequential numbering
- Update `NOVA_DESIGN/00_DESIGN_INDEX.md`
- Update relevant open problem documents (mark as resolved or partially resolved)
- Update `CLAUDE.md` if the decision affects core design direction
