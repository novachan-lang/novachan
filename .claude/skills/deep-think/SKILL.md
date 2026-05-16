---
name: deep-think
description: Deep analysis of a NOVA design problem. Use when facing a fundamental design question that requires thorough reasoning, not quick answers. Produces a structured analysis document.
user-invocable: true
argument-hint: "<problem description>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - WebFetch
  - WebSearch
---

# Deep Think — Rigorous Design Analysis

You are performing deep analysis on a NOVA programming language design problem.

**Problem to analyze:** $ARGUMENTS

## Process

Follow this exact process. Do NOT skip steps.

### Step 1: Frame the Problem (5 minutes of thinking)
- What exactly is the question?
- Why is this hard? What makes it a genuine design challenge?
- What are the competing forces / tensions?
- What decisions does this block?
- What decisions does this depend on?

### Step 2: Research Existing Solutions
- Which languages / systems have faced this exact problem?
- For each: What did they do? Why? What were the consequences (good and bad)?
- Read relevant design documents in `NOVA_DESIGN/` to understand current context
- Check if this problem connects to any existing open problems

### Step 3: Generate Candidate Solutions
- Generate at least 3 genuinely different approaches (not minor variations)
- For each approach: describe the mechanism, not just the outcome
- For each approach: identify the strongest argument FOR and AGAINST

### Step 4: Stress Test Each Candidate
Test each candidate against these NOVA scenarios:
1. A beginner writing their first NOVA program
2. A systems programmer writing performance-critical code
3. A team building a distributed AI-powered web application
4. The NOVA compiler compiling itself (self-hosting test)

### Step 5: Synthesize
- Which candidate survives all stress tests?
- If none do perfectly, which fails least badly?
- What refinements would improve the best candidate?
- What open questions remain?

### Step 6: Record
Write the analysis to `NOVA_DESIGN/research/` with a clear filename.
Update `NOVA_DESIGN/00_DESIGN_INDEX.md` to include the new document.

## Output Format

Structure your analysis as a document, not a conversation. It should be readable by someone who wasn't part of this session.
