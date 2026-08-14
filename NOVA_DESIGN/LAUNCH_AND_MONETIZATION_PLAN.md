# NOVA Launch & Monetization Plan

> **Created:** 2026-08-04
> **Status:** PLANNING — nothing started yet
> **Owner:** Mangesh Mane (solo founder)
> **Goal:** Take NOVA from private project to public language with revenue path

---

## Context

NOVA is a self-hosting programming language with:
- 22k-line self-hosting compiler (byte-identical fixpoint)
- C-class scalar performance (1.04x)
- 570+ KAT-gated standard libraries
- Forge web framework (HTTP, WebSocket, ORM, MySQL/PG, crypto, TLS)
- VS Code extension with 14 LSP features (v0.4.0)
- Working concurrency (green threads, channels, select)

Current state: powerful but invisible. Zero external users, zero public presence.

---

## AI-Era Risk Assessment

Traditional "complexity = protection" is weaker now. AI tools can analyze and explain
any public codebase. Realistic protection comes from:

1. **Speed of execution** — stay 6-12 months ahead of anyone who tries to clone
2. **Brand & trust** — be the official, maintained, supported version
3. **Platform lock-in** — Nova Cloud infrastructure can't be copy-pasted
4. **Community** — contributors, docs, tutorials, ecosystem packages
5. **Commercial relationships** — enterprise contracts, support SLAs

What does NOT protect: keeping code hidden (kills adoption), complexity (AI reads it),
obscurity (nobody pays for what they don't know exists).

---

## Licensing Strategy (Decision Needed)

| Component | Recommended License | Rationale |
|-----------|-------------------|-----------|
| Compiler (`nova_compiler.nova`) | MIT or Apache-2.0 | Must be open for trust/adoption |
| Runtime (`nova_runtime.c`) | MIT or Apache-2.0 | Ships with every NOVA binary |
| Standard library (`std/`) | MIT or Apache-2.0 | Core language, must be open |
| Forge framework (`forge/`) | BSL 1.1 (3-year) | Commercial protection, source-visible |
| Nova Cloud (future) | Proprietary | The actual revenue product |
| Nova Pro tools (future) | Proprietary | Paid developer tools |

**BSL (Business Source License):** Code is visible and usable, but can't be used to
compete commercially. Converts to full open source after 3 years. Used by HashiCorp,
Sentry, MariaDB, CockroachDB.

**Decision point:** Exact license choice. Consider also: AGPL (strong copyleft, deters
SaaS competitors), or full MIT (maximum adoption, zero protection).

---

## Revenue Streams

### Stream 1: Nova Cloud (Primary — months 6-12)
Managed deployment platform. Developer writes NOVA app, runs `nova deploy`, gets a
live production environment with auto-scaling, database, TLS, monitoring.

- Hobby: $29/month
- Pro: $99/month
- Team: $499/month
- Enterprise: custom pricing

Build on top of existing cloud (AWS/GCP/Fly.io) initially, not own infrastructure.
Revenue potential: $300K-$600K ARR at 5,000 developers, 2% paid conversion.

### Stream 2: Nova Enterprise (months 6-18)
Sell directly to companies that adopt NOVA for production:

- Priority support + SLA: $5,000-$50,000/year
- Private package registry
- SSO/SAML integration
- Compliance certifications (SOC2, HIPAA — later)
- Training and onboarding
- Custom feature development

Revenue potential: $100K-$1M/year from 10-20 enterprise customers.

### Stream 3: Nova Pro Developer Tools (months 3-6)
Paid tier of developer tools:

- AI-powered NOVA code completion (trained on NOVA patterns)
- Advanced profiler and debugger
- Forge Pro: admin dashboard generator, production monitoring
- Official NOVA Developer Certification ($200-500/exam)

Revenue potential: $10-20/month per developer, scales with adoption.

### Stream 4: Grants & Sponsorship (months 1-3, immediate)
No product needed, just public presence:

- GitHub Sponsors / Open Collective
- Sovereign Tech Fund (Germany — funds open source language infra)
- GitHub Accelerator program
- NLnet Foundation
- FOSS Contributor Fund

Revenue potential: $500-$5,000/month while building the real products.

---

## Pre-Launch Checklist (Before Going Public)

### Must-Do (Blockers)
- [ ] Choose license (MIT vs Apache-2.0 vs BSL split)
- [ ] Clean repo — remove any secrets, personal paths, temp files
- [ ] Remove/mask any hardcoded Windows paths in compiler/runtime
- [ ] Ensure Linux builds work (at least compiler + basic programs)
- [ ] Write README.md for GitHub (see template below)
- [ ] Create 3 demo programs that show NOVA's identity
- [ ] Fix the 8 Forge prod-readiness blockers (or document as known issues)
- [ ] Create a CONTRIBUTING.md
- [ ] Create a CODE_OF_CONDUCT.md
- [ ] Set up CI (GitHub Actions — build + test on push)

### Should-Do (High Impact)
- [ ] Landing page / website (nova-lang.org or similar)
- [ ] Blog post: "Building a self-hosting language from scratch"
- [ ] Benchmark page: NOVA vs Go vs Rust vs Python (perf + LOC + time)
- [ ] Package manager MVP (even basic `nova install <name>`)
- [ ] 5-minute getting started tutorial
- [ ] Record a 3-minute demo video

### Nice-to-Have (Post-Launch)
- [ ] Discord / community server
- [ ] Playground (NOVA code runs in browser via WASM)
- [ ] Syntax highlighting for GitHub (Linguist PR)
- [ ] Conference talk submission (Strange Loop, FOSDEM, etc.)
- [ ] "Awesome NOVA" curated list

---

## Demo Programs (The "Show Don't Tell")

### Demo 1: Full-Stack Web API (NOVA's Identity)
A REST API with database, auth, and JSON — all in one file, zero imports from
outside NOVA. Shows: simpler than Python, faster than Go, safer than C.
Target: under 100 lines total.

### Demo 2: Concurrent Data Pipeline
Reads data from multiple sources in parallel using spawn/channels, processes it,
writes results. Shows: goroutine-easy concurrency, C-level throughput.
Target: under 50 lines.

### Demo 3: CLI Tool
A practical command-line tool (maybe a JSON processor, or a file search tool).
Shows: NOVA for everyday scripting, not just servers.
Target: under 40 lines.

---

## README Template (Draft Structure)

```
# NOVA — One Language for Everything

NOVA is a programming language where one developer builds anything — backend,
frontend, AI, systems — in one language that's simpler than Python and faster
than C.

## What Makes NOVA Different
- Zero type annotations (95%+ code needs none — the compiler infers everything)
- C-level performance (1.04x on scalar benchmarks)
- Built-in concurrency (green threads, channels — as easy as Go)
- Self-hosting compiler (NOVA compiles itself)
- Full web framework included (HTTP, WebSocket, ORM, TLS)

## Quick Example
[simple program here]

## Getting Started
[install instructions]

## Benchmarks
[perf comparison table]

## Status
[honest current state — what works, what's in progress]

## License
[chosen license]
```

---

## Launch Sequence (Week by Week)

### Week 1-2: Prepare
- Clean repo, choose license, fix critical Linux issues
- Write README, CONTRIBUTING, CODE_OF_CONDUCT
- Build 3 demo programs
- Set up GitHub Actions CI

### Week 3: Soft Launch
- Push to GitHub (public)
- Post to r/ProgrammingLanguages (friendly, niche audience)
- Set up GitHub Sponsors
- Apply to Sovereign Tech Fund / NLnet

### Week 4: Public Launch
- Blog post on personal blog / dev.to / Medium
- Submit to Hacker News ("Show HN: I built a self-hosting language...")
- Post to r/programming, Twitter/X, Lobsters
- Set up Discord community

### Month 2-3: Build Momentum
- Weekly blog posts (technical deep dives)
- Respond to issues/PRs (community building)
- Start Nova Pro tools (paid IDE features)
- Start Nova Cloud MVP

### Month 4-6: First Revenue
- Nova Cloud beta launch
- First enterprise conversations
- Package manager v1
- Target: 1,000 GitHub stars, 100 active users

---

## Investment Pitch (When Ready — Month 6+)

**One-liner:** "NOVA replaces 3-4 languages in a typical stack — one developer
ships what used to take a team."

**Ask:** $1.5M seed round

**Use of funds:**
- 2 engineers (compiler + runtime)
- 1 DevRel / community person
- Cloud infrastructure for Nova Cloud
- 12 months runway

**Metrics investors want to see before pitch:**
- 2,000+ GitHub stars
- 200+ weekly active developers
- 5+ companies using NOVA in production
- Some revenue (even $1K/month from sponsors or cloud)
- Linux + macOS support working
- Growing community (Discord 500+, contributors 10+)

**Target investors:**
- Heavybit (developer tools focus)
- Redpoint Ventures
- Greylock (developer tools practice)
- Y Combinator (apply to batch)
- Sequoia Scout
- Angel investors from dev-tools space (find on Twitter/X)

---

## Key Decisions Still Needed

1. **License choice** — MIT (max adoption) vs BSL (commercial protection) vs split
2. **Company name** — "Nova Labs"? "Nova Computing"? Check availability
3. **Domain name** — nova-lang.org? novalang.dev? Check availability
4. **Timing** — when to actually go public (after Forge blockers fixed? or now?)
5. **Solo vs co-founder** — investors strongly prefer 2+ founders. Consider finding
   a co-founder (DevRel/business person, or second compiler engineer)

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Someone forks and competes | LOW | MEDIUM | Speed + brand + platform |
| AI-assisted clone | LOW-MEDIUM | MEDIUM | Platform revenue, not code revenue |
| No adoption traction | MEDIUM | HIGH | Multiple launch channels, iterate |
| Burnout (solo) | HIGH | CRITICAL | Find co-founder or first hire early |
| Investor rejection | MEDIUM | MEDIUM | Grants + bootstrap path as fallback |
| Major compiler bug in public | MEDIUM | MEDIUM | Thorough testing pre-launch, fast response |
