# Research Standards

## When Researching Any Technical Question

1. **Go deep, not wide.** Understanding ONE language's approach thoroughly is worth more than surveying ten languages superficially. Read the actual source code, the RFCs, the rejected proposals. "Go has generics" is surface. "Go added generics in 1.18 using type parameters with interface constraints after 10 years of debate, rejecting contracts and template-based approaches because they added complexity without matching the language's simplicity ethos" is depth.

2. **Distinguish between "what they claim" and "what actually happens."** Every language's documentation describes the ideal. Read the bug trackers, the RFC discussions, the post-mortems to understand reality. Rust claims zero-cost abstractions — but `async` requires a heap-allocated `Pin<Box<dyn Future>>` in many real patterns. Go claims simple concurrency — but channel performance under contention is poor and runtime scheduling adds latency. Know the REAL story.

3. **Always ask "why did they make this choice?"** The context behind a decision matters as much as the decision itself. Rust chose ownership because Mozilla needed memory safety for a browser engine. That context shaped everything. Go chose CSP because Rob Pike worked on Plan 9 which used CSP. Erlang chose actor isolation because Ericsson needed 99.999% uptime in telecom switches.

4. **Track the evolution, not just the current state.** Languages change. Rust 1.0 is very different from Rust 2024. Go added generics. Java added records and pattern matching. Swift added structured concurrency. Understanding WHY they changed reveals what their original design got wrong — and what NOVA can get right from the start.

5. **Research must conclude with implications for NOVA.** Every research document must end with: "This means NOVA should..." or "This means NOVA should NOT..." Abstract knowledge without application is wasted effort.

6. **Know the numbers.** Performance claims must be backed by benchmarks. "Go compiles fast" → Go compiles ~10K lines/sec, Rust compiles ~1K lines/sec, C with `-O2` compiles ~5K lines/sec. "Erlang handles millions of processes" → BEAM processes use ~300 bytes each, scheduled preemptively on reduction counts. Numbers ground decisions in reality.

7. **Know the failure modes.** Every successful language feature also has known failure modes. Haskell's lazy evaluation causes space leaks. Rust's borrow checker fights graph data structures. Go's goroutines can leak if channels aren't closed. Python's GIL prevents true parallelism. For NOVA to beat these languages, we must understand exactly WHERE they fail and design around it.

## Research Document Structure

Every research document must contain:
- **Problem statement** — What question are we answering?
- **Existing solutions** — Who attempted this and what happened? Include the timeline: when was it introduced, how has it evolved, what was tried and abandoned?
- **Deep analysis** — Why did solutions succeed or fail? What are the underlying tradeoffs? What are the failure modes in production? Include concrete numbers where available.
- **Novel ideas** — What approaches haven't been tried? What combinations might work? Why hasn't anyone tried this before — is it actually novel or is there a hidden reason it was rejected?
- **Implications for NOVA** — What specific design choices does this research support or reject? How does this interact with NOVA's existing design (Values/Processes/Channels)?
- **Competitive scorecard** — For the feature area being researched, where does NOVA stand vs. C, Rust, Go, Python, Erlang, JavaScript? Mark each as: NOVA wins / tie / NOVA loses (with plan to fix)
- **Open questions** — What do we still not know?
