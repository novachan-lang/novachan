---
name: research-problem
description: Deep research into how existing languages and systems solved a specific problem. Use when NOVA faces a design challenge and we need to understand the landscape before proposing solutions.
user-invocable: true
argument-hint: "<problem or topic to research>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - WebFetch
  - WebSearch
---

# Research Problem — Deep Investigation

Conducting deep research on a specific problem for NOVA's design.

**Research topic:** $ARGUMENTS

## Process

### Step 1: Define the Research Question
- What exactly do we need to understand?
- Why does NOVA need this knowledge?
- What decisions will this research inform?

### Step 2: Survey the Landscape
Investigate at least 5 relevant systems/languages. For each:
- What problem were they solving?
- What approach did they take?
- What were the results (performance, usability, adoption)?
- What went wrong? What would they do differently?

Sources to check:
- Language documentation and specifications
- Research papers and conference talks
- RFC discussions and design documents
- Bug trackers and post-mortems (where the real truth lives)
- Community discussions and experience reports

### Step 3: Identify Patterns
- What approaches have been tried multiple times?
- What approaches consistently work?
- What approaches consistently fail?
- What hasn't been tried that might work?

### Step 4: Synthesize for NOVA
- Given NOVA's specific constraints (unified, simple, performant), what does this research suggest?
- What approaches are compatible with NOVA's design philosophy?
- What approaches are incompatible and should be avoided?
- What novel combinations might work for NOVA specifically?

### Step 5: Identify Unknowns
- What questions does this research NOT answer?
- What would we need to prototype to answer remaining questions?
- What expertise are we missing?

### Step 6: Record
Save to `NOVA_DESIGN/research/` with descriptive filename.
Update `NOVA_DESIGN/00_DESIGN_INDEX.md`.
