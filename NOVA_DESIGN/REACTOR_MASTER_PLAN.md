# REACTOR — The Game Engine Master Plan

> **What this is.** The canonical plan for **Reactor**, NOVA's game engine — designed not to *match* Unity, Unreal, Godot, and Bevy but to **structurally out-architect** them, and to keep winning on hardware that does not exist yet. Built from exhaustive research (every major engine + every subsystem + current and future silicon) cross-checked against NOVA's **actual** codebase (`nova_runtime.c`, `nova_compiler.nova`, the IMPLEMENTATION_AUDIT). Every claim here is marked **REAL today / plumbing / must-build**, with the hard risks named, not hidden.
>
> **Status:** Design + sequencing. This is a *plan*, not a build order to start today. Planning ≠ building — the compiler work continues elsewhere. Created 2026-06-18.
>
> **Companion docs:** [FRAMEWORK_ECOSYSTEM_STRATEGY.md](FRAMEWORK_ECOSYSTEM_STRATEGY.md) (Reactor's place among the 9 frameworks), [PERFORMANCE_SPECIALIZATION.md](PERFORMANCE_SPECIALIZATION.md) (the i64→native-float work that gates Reactor's perf), [IMPLICIT_ASYNC_DESIGN.md](IMPLICIT_ASYNC_DESIGN.md) (the scheduler Reactor builds on), [IMPLEMENTATION_AUDIT.md](IMPLEMENTATION_AUDIT.md) (what's real).

---

## 0. The Thesis in One Sentence

**A game engine where the frame is not a loop but a graph of isolated Processes communicating over typed Channels — so the render graph, the netcode, the audio mixer, the physics solver, and the editor are all the same three primitives, and the *same source* retargets to a CPU, a GPU work-graph node, an NPU tile, a browser, or a machine that doesn't exist yet, by adding a backend, not rewriting the engine.**

Every incumbent bolted a bespoke C++ render-graph compiler, a separate shader language, a separate netcode stack, and a separate audio engine onto a CPU-orchestrated, single-clock core. Reactor's renderer/netcode/audio/physics are **retargets of compiler analyses NOVA already has** (dependency, liveness, ownership, capability inference). That is the moat: not any single feature, but that the features are *free for NOVA and a ground-up rewrite for everyone else.*

---

## 1. Why Reactor — The Structural Opening

The incumbents are not bad. They are **architecturally frozen** at the wrong layer, and the hardware has moved past them.

| Engine | Defining strength | Defining structural flaw (Reactor's opening) |
|---|---|---|
| **Unity** (~48% market) | Accessibility, biggest asset store | Two incompatible worlds: classic MonoBehaviour vs DOTS/ECS — 7 years, half-finished, stranded ecosystem. Boehm GC → frame hitches. Single-thread main loop. |
| **Unreal 5** (~31% Steam revenue) | AAA rendering (Nanite, Lumen), Blueprint | Single-threaded actor tick (the entire reason UE6 exists, ~2028). Blueprint↔C++ perf cliff (15–60×). PSO shader stutter. Opaque `.uasset` lock-in. |
| **Godot 4** (rising on trust/MIT) | Open, editor-in-engine, accessible | Fast path = abandon friendly Nodes for raw RID Server calls (a cliff + `RID free()` use-after-free). 3 languages with a marshaling tax. Web export degraded. |
| **Bevy** (best ECS, ~0 studios) | World-class data-oriented ECS | Editorless for half a decade. Storage (Table vs SparseSet) + ordering (.before/.after) are *user* chores. Per-frame runtime conflict-graph cost. Shaders are WGSL (foreign to the compiler). 5-minute Rust rebuilds. |

**The meta-lesson from the research:** engines die not from missing features but from a **frozen core abstraction the hardware outgrows.** The fixed-function pipeline froze → programmable shaders killed the engines that couldn't adapt. Single-threaded scene graphs froze → multicore + GPU-driven killed them. **The CPU-orchestrated, explicit-copy, single-clock model is freezing right now.** Whoever builds the next core on the *right* model — a heterogeneous dataflow graph over coherent memory — inherits the next 15 years.

NOVA's three primitives (Values / Processes / Channels) **are** that model. Reactor is the bet that the unfair advantage is structural, not incremental.

---

## 2. The Governing Thesis — The Frame Is a Process/Channel Graph

This is the spine every subsystem lowers into. **Freeze this before any subsystem code is written**, or every subsystem gets built CPU-pinned and single-clock — recreating the exact retrofit tar pit (Unity DOTS, UE6) the whole engine exists to avoid.

**The Placement-Agnostic Process Graph (PAPG).** A Reactor game ships as a serializable, typed process/channel IR graph — *not* a binary pinned to one ISA. A "device" is just a **placement target with a cost descriptor.** Retargeting to new hardware = add a placement target + backend, touch **zero** game code.

```
  PapgNode { id, kind:(System|RenderPass|ComputeKernel|NeuralStage|AudioStage|InputDecoder|Compositor),
             body_ref, reads:[ChanId], writes:[ChanId],
             cost: CostVector,            // flops, bytes_touched (ranked ABOVE flops), serial depth, deadline
             caps: {Pure,NoAlloc,Sendable,GpuSafe,Deterministic,...},   // compiler-inferred, same lattice as Sendable
             clock: (Sim|Render|Present|Audio|Free) }
  PapgEdge  { src, dst, payload_type, volume_hint, qos:(ReliableOrdered|UnreliableSequenced|Unreliable|Local) }
```

Every field is **compiler-derived** from analyses NOVA already runs: `reads/writes` = the channel endpoints a function touches; `caps` = the capability inference NOVA already does for `Sendable`/`GpuSafe`; `clock` = inferred from which channels a node is wired to; the whole graph is `to_json`-serializable for free (NOVA's automatic structural serialization). **No competitor can emit this** — none has a language whose compiler sees gameplay + shaders + netcode + audio as ONE typed graph.

**Three clocks, not one** (the structural answer to "the frame is no longer one tick"):
- **Sim clock** — fixed `dt`, deterministic, may stall/rollback.
- **Render clock** — variable, consumes the latest Sim snapshot over a channel.
- **Present clock** — *hard-realtime* (90–144 Hz / XR), runs the Compositor node that samples the freshest pose and reprojects the last frame **even if Sim and Render are parked** (XR async-timewarp falls out of the model, not bolted on).

**Channels absorb the entire memory/interconnect hierarchy.** The compiler costs each edge by where its endpoints land:

| Edge | Transport the compiler inserts | Cost |
|---|---|---|
| CPU↔CPU, co-located | erased to a function call / shared-arena pointer | 0 |
| CPU↔GPU, **unified memory** (PS5/Apple/MI300A) | zero-copy pointer pass + barrier token | ≈0 |
| CPU↔GPU, **discrete** (PCIe5 ~63 GB/s) | batched DMA — compiler hoists/minimizes | real, ranked |
| GPU stage↔stage | on-chip buffer / pipeline barrier | cheap |
| node↔remote node | binary delta over UDP/QUIC (cloud split) | network |

The developer writes `send(ch, frame)`. The compiler picks copy-vs-zero-copy *per topology*. The same source is correct on a discrete RTX PC **and** a unified-memory console **and** the browser — something no engine offers because none has one channel model spanning CPU/GPU/network.

---

## 3. The Hardware — NOW (2024–2026)

> The user's mandate: *win on current hardware AND future hardware.* Here is the present landscape and what it forces. The one-line truth: **the GPU now schedules itself and the CPU is a feeder; the winner is whoever touches the fewest bytes.**

**The flagship GPUs:**

| Part | Compute | RT / AI silicon | Memory | Bandwidth |
|---|---|---|---|---|
| **NVIDIA RTX 5090** (Blackwell, Jan 2025) | 21,760 CUDA cores (all dual-issue FP32) | 170 4th-gen RT + 680 5th-gen Tensor (FP4) | 32 GB GDDR7, 98 MB L2 | **1,792 GB/s** |
| **AMD RX 9070 XT** (RDNA4, Mar 2025) | 64 CUs / 4,096 SP | 64 RT accel + 128 AI accel (1,557 TOPS) | 16 GB GDDR6 + 64 MB Infinity Cache | ~640 GB/s eff. |
| **Apple M4 Max** | 40-core GPU, HW mesh shading, Dynamic Caching | 2nd-gen RT | up to **128 GB unified** | 546 GB/s |

**The consoles (the floor every engine must hit, and the proof of the future architecture):**
- **PS5**: 36 CU RDNA2 (10.3 TFLOPS), **16 GB unified GDDR6 @ 448 GB/s**, custom SSD with *hardware* Kraken decompression (the SSD is a memory tier, not storage).
- **PS5 Pro** (Nov 2024): ~16.7 TFLOPS, 576 GB/s, **PSSR** dedicated ML upscaler.
- **Xbox Series X**: 52 CU (12.15 TFLOPS), **split 16 GB** (10 GB @ 560 + 6 GB @ 336 GB/s — a real NUMA trap). **Series S** (8 GB usable) = the true min-spec.
- **Switch 2** (2025): NVIDIA T239, Ampere + Tensor + RT, **DLSS in a handheld** — proof AI upscaling is now the equalizer at the bottom.

**Three facts that decide the architecture:**

1. **The memory wall is the real bottleneck.** Compute grew ~10× faster than bandwidth over two decades. The 5090 has **~0.08 bytes/FLOP** — starved by 10–50×. *Every* hardware feature is a bandwidth-hiding trick: huge L2/Infinity Cache, neural texture compression (~7× VRAM), DLSS/FSR/PSSR (render fewer pixels), DirectStorage GPU decompress, mesh-shader cull-before-fetch. **Reactor optimizes the data-movement graph, not the FLOP count** — `bytes_touched` is ranked above `flops` in the cost model (§2).

2. **The APIs went GPU-driven.** Mesh shaders (DX12 Ultimate / VK_EXT_mesh_shader) replace the fixed VS/HS/DS/GS pipeline with compute-like stages doing on-GPU cull/LOD. **Work Graphs** (D3D12 SM6.8, 2024; VK_AMDX_shader_enqueue) let the GPU **spawn its own work nodes** — draw calls become graph nodes, the CPU leaves the inner loop. **This is a dataflow graph of processes communicating over channels.** Reactor is born as that graph; the incumbents retrofit it.

3. **Unified memory is winning.** Consoles + Apple + integrated already share one address space (zero-copy). Discrete PCIe PCs are the outlier, and resizable-BAR + DirectStorage are PCs *emulating* unified memory. The explicit upload/download/staging API every current engine exposes is **becoming a legacy emulation path.**

**The traps (what Reactor must design around):** the PCIe cliff (per-frame CPU→GPU copy over 63 GB/s stalls a 1,792 GB/s GPU); VRAM exhaustion on the mid-tier (16 GB / 8 GB); the Series-X split-memory NUMA hazard; RT divergence without ray reordering; PSO shader stutter (an architectural failure to precompile); single-thread command submission.

---

## 4. The Hardware — FUTURE (3–15 years) and the Isomorphism Claim

> This is the pillar that decides the next decade. **Reactor's claim is not "we support future hardware" — it is that NOVA's three primitives are *isomorphic* to where silicon is going,** so the future is a backend matrix, not a rewrite.

**The five converging vectors:**

1. **Neural rendering moves up the pipeline.** Trajectory: temporal upscaling (DLSS/FSR) → ray reconstruction → frame generation (DLSS4 = a real-time *transformer*, up to 3 generated frames per rendered, 8× → DLSS4.5 6×) → **neural materials/shaders** (small MLPs *inside* a pixel shader via DirectX Cooperative Vectors / RTX Neural Shaders) → **Neural Radiance Cache** (a network that learns indirect light *during the play session*). End state: large fractions of frames are *inferred, not rasterized.* An engine whose core assumes "the shader writes the final pixel" is structurally obsolete.

2. **GPU+NPU convergence.** NPUs everywhere (Snapdragon X2 Elite 80 TOPS, Apple M4 38 TOPS, Intel Lunar Lake 48, AMD Ryzen AI ~50). The GPU itself grows dedicated neural blocks: Sony/AMD **Project Amethyst** "Neural Arrays" + "Radiance Cores." Future silicon = shader ALUs + RT cores + tensor/neural arrays + radiance cores **on one die, all fed concurrently.** "Inference" becomes a first-class workload scheduled onto whichever tile is cheapest.

3. **Chiplets + heterogeneous package + coherent memory.** Datacenter leads: AMD **MI300A** = Zen4 CPU + CDNA3 GPU + **128 GB shared HBM3 in one coherent address space** (no host/device copies, ~44% memory cut, 5.3 TB/s). AMD merges RDNA+CDNA → **UDNA** (~2026). **PS6 "Orion"** (~3 nm, Zen6 + RDNA5/UDNA, up to 40 GB GDDR7, 2.5–3× raster / 6–12× RT over PS5). The explicit-copy model is dying.

4. **ARM-everywhere + a fragmenting target matrix.** The target is now `{x86, ARM, WASM} × {discrete, integrated, mobile, none} × {NPU, no-NPU}`. Every `#ifdef NVIDIA` is a future port tax.

5. **Frontier (lower-confidence, 10–15 yr):** neuromorphic (Intel Loihi 3, ~100× efficiency on event/spiking workloads — relevant to event-driven AI NPCs) and photonic AI (~65 TOPS at 78 W in the lab). Not gaming-critical, but they reinforce the thesis: **compute becomes a zoo of specialized accelerators behind one memory fabric.**

**The future platforms (interaction + deployment):**
- **XR / spatial** (Apple Vision Pro 12 ms photon-to-photon @ 90 Hz, eye-tracked foveation; Quest 3 120 Hz). The frame is stereo, foveated, and bound by **motion-to-photon (~20 ms nausea threshold), not FPS.** The compositor *must* run even if the sim freezes — exactly Reactor's Present-clock process.
- **Cloud / split rendering** (GeForce NOW ~30 ms click-to-photon). The frame is sliced across client/edge/datacenter — the engine must be **relocatable per-subsystem at runtime**, which is exactly a channel cut across a distributed boundary.
- **WebGPU + WASM** — the browser became a real AAA target in 2024–2026 (UE5 Lyra in WASM+WebGPU; Sponza + 400 lights + RT @ ~50 fps on an M1). The *same source* must emit native and wasm32 with the graphics layer swapping WebGPU for Vulkan/Metal/DX12.
- **Generative NPCs** (on-device small models, NVIDIA ACE / Nemotron-4 4B) and **probabilistic input** (Meta Neural Band sEMG, shipped Sept 2025) — input becomes a *high-rate, noisy, probabilistic stream*, not button events.

**The isomorphism, made mechanical:**

| Future hardware reality | NOVA primitive it already is |
|---|---|
| GPU Work Graph node spawning child nodes | a **Process** spawning Processes |
| memory barrier / queue handoff / PCIe transfer / coherent-memory pass | a **Channel** (ownership transfer point) |
| SoA component arrays the compiler lays out | **Values** with compiler-chosen allocation |
| tile placement (CU / RT core / tensor array / NPU / remote node) | **Process scheduling** (extend the M:N scheduler's placement) |
| neural reconstruction / NRC / per-NPC model | a **Process**: Values in, Values out (online-training safe by isolation) |
| the self-scheduling dataflow frame | the **PAPG** (§2) |

When the GPU becomes a fully self-scheduling heterogeneous processor over coherent memory, **NOVA's model already *is* that machine in silicon.** Unity/Unreal/Godot/Bevy must rewrite C++ for each new paradigm; Reactor's source doesn't change — the compiler's target selection does. **This is the deepest future-proofing, and it is structural, not marketing.**

*Honest boundary (a risk we name up front):* keep the **deterministic Sim sub-graph on a single canonical executor** (CPU or one designated tile) — do *not* float deterministic nodes across heterogeneous silicon (different rounding breaks bit-identity). Only the **probabilistic/render periphery** floats freely across tiles. "Frontier-open, not frontier-dependent": spend **zero** core complexity assuming photonic/neuromorphic exists this decade — but keep the door open (it's "one more tile/backend").

---

## 5. The Eight Novel Weapons (What Only NOVA Can Field)

Each is a **consequence** of the three primitives + the whole-program compiler — not a feature. An incumbent can copy any single *surface behavior* with enough C++, but cannot get the *set* coherently, because they all rest on the same substrate, and adopting that substrate means rewriting the engine **and** the language **and** the compiler.

1. **The single-world unification.** The simple struct+loop code *is* the SoA-vectorized fast code, because the compiler does AoS→SoA + monomorphization invisibly. No DOTS to learn, no HPC#/Burst toolchain, no Blueprint-vs-C++ cliff, no storage knob. The beginner and the shipping-AAA dev write the *identical* source.

2. **Statically-proven parallelism, zero per-frame cost.** Two systems run in parallel iff their owned value-sets are disjoint — a **compile-time** fact (process isolation), not Bevy's per-frame `FixedBitSet` rebuild or Unity's runtime job-safety subsystem. That entire race-detection subsystem **evaporates**. UE6's flagship (multithreaded sim, ~2028) is Reactor's day-one default.

3. **One primitive = game event + change-detection + netcode + GPU transfer + editor-poke + audio command.** A footstep is one typed-channel send that is simultaneously a gameplay signal, a network packet (codec auto-generated from the Value's structure — no IDL), a GPU upload, an audio trigger, and an editor-observable event. Incumbents have **five** separate subsystems here.

4. **Compiler-proven cross-platform determinism.** A `Deterministic` capability (sibling to `Sendable`) pins `-ffp-contract=off`, bans float reassociation, links NOVA-native transcendentals, bans wall-clock/RNG/dict-iteration-order dependence — and **proves** the sim is bit-identical, or rejects with the exact offending line. Unity/Unreal *structurally cannot* claim this (PhysX is non-deterministic across hardware; they ship Photon Quantum *beside* the engine). Plus a **deterministic replay debugger** and **native↔WASM bit-identity as a CI gate.**

5. **One language for engine + gameplay + shaders + neural nets + tools + build.** A shader is a NOVA function the compiler infers as a `GpuKernel`, lowered to SPIR-V/DXIL/MSL/WGSL. `brdf` is *shared* between CPU (baking/preview) and GPU (runtime) — one definition, type-checked across the boundary, bind groups auto-derived. Bevy=WGSL+Rust, Unreal=HLSL+C++, Unity=HLSL+C#, Godot=GDShader+GDScript. Reactor=one.

6. **The render graph is a retarget of the language's own analyses.** GPU barriers = channel ownership-transfer edges; transient VRAM aliasing = the *same* liveness analysis used for CPU heap; async scheduling = the parallel-process scheduler. Every rival hand-wrote a render-graph compiler in C++ on a language that can't see the graph. Reactor's improves whenever the NOVA compiler improves.

7. **Instant, crash-proof, *structural* hot reload (including schema changes).** State lives in isolated processes reachable only via channels — swap the code, hand the state over a channel (name-keyed structural snapshot), kill the old process. Nothing with the old layout survives → corruption is *structurally impossible*. Covers add/remove/reorder fields, which Unreal Live Coding cannot; auto-rolls-back on a bad reload via the same fault-boundary + supervisor path. **Reload is a planned crash; a crash is an unplanned reload — one code path.**

8. **Same source → native + WASM/WebGPU + distributed, byte-identical.** NOVA already proved byte-identical native↔WASM for dicts/structs (WASM m6). Green M:N cooperative threads give the game full logic concurrency in single-threaded WASM *without* SharedArrayBuffer (escaping Godot's web-threading/monetization trap). A render/sim/audio process can be **remote** (cloud split-render) using the identical graph.

---

## 6. The Architecture — Subsystem by Subsystem

Each subsystem is designed the NOVA way, grounded in the real codebase. For each: **the design**, **how it destroys the incumbents**, and **what must be built first.**

### 6.1 The ECS Spine — *the foundation everything else lowers into*

**The one decision that determines everything: an entity is NOT a process. A *system* is a process. Components are Values laid out as compiler-chosen SoA columns.** Process-per-entity dies on the bandwidth wall (a column iterates 1M entities at ~16 GB/s; 1M green fibers cost orders more memory + cache misses). Process-per-**system** (dozens–hundreds of coarse units) maps perfectly onto NOVA's existing M:N work-stealing scheduler. **Columns for data, processes for the parallel system graph.**

- **Entity** = a 64-bit generational id `{u32 index, u32 generation}` (stale ids silently fail, never alias). A plain Value — no UObject, no vtable, no per-entity heap object.
- **Component** = a NOVA struct with **zero annotations**. A struct *becomes* a component the moment it's attached. No `#[derive(Component)]`, no `MonoBehaviour` inheritance, no `UPROPERTY`. *This is the single biggest ergonomic win over every incumbent.*
- **Storage strategy is a COMPILER DECISION, not a user flag** (the killer differentiator). The compiler analyzes whole-program usage and picks per component:
  - **archetype-column (SoA)** — default, for iterated-hot stable components (16 KB chunks, matching DOTS).
  - **sparse-set** — for components toggled/churned every frame (O(1) structural change). *This auto-resolves the MoonTools 300→5 FPS archetype-fragmentation disaster.*
  - **bitmask-tag** — for zero-size/boolean components (`is_dead`, `selected`) → toggle a bit, not a structural move.
  - **hot/cold field split** — if a system reads only `Position.x/y`, split the cold fields out → no 64-byte-component / 1-per-cache-line footgun.

  EnTT forces view-vs-group; Bevy forces Table-vs-SparseSet (core devs debated *deleting* SparseSet because users get it wrong). **Reactor makes the choice automatic and correct** — the #1 thing users get wrong becomes a thing they never see. No competitor can copy this without whole-program type+usage inference fused with codegen, i.e. without becoming NOVA.

- **Archetype discovery is whole-program.** The compiler scans every `spawn`/`add`/`remove` site, pre-computes every archetype + transition edge → an add/remove is a *precompiled memcpy* with offsets baked at compile time, not a runtime hashmap lookup.
- **Systems = processes, parallelism statically proven.** The developer writes a plain loop; the compiler derives each system's read-set/write-set from the query types + body, and two systems share a parallel layer iff their access sets don't conflict. Bevy computes this *every frame*; Reactor computes it *once at compile time* → **zero per-frame scheduling overhead + proven race-freedom.** Within a system, chunk-parallelism fans out across carriers automatically.
- **The deterministic tick barrier** (the move that beats everyone on netcode): systems run in parallel, but their effects **commit in a canonical, content-derived order** (stable entity id) at the tick boundary via the command channel. *Parallel execution, deterministic commit.* Every other engine forces parallel OR deterministic; Reactor's channel-as-commit-boundary gives BOTH.

**Beats:** Unity (one model, not classic-vs-DOTS; no GC hitches; ~100% of users get DOTS perf because there's no opt-in) · Unreal (parallel day-one; no UObject tax) · Godot (the ergonomic unit *is* the fast unit) · Bevy (infers storage + ordering Bevy makes you choose; static race-freedom vs runtime conflict graph; 800K/sec spawn vs ~500K).

**Benchmark targets:** single system / 1M entities **< 2 ms single-core, < 0.5 ms multi-core**; 7 systems / 1M entities **beat flecs's 16 ms** by going parallel; structural change **match pico_ecs's 11 ms destroy / 48 ms create**; **100K+ entities @ 60 fps in the browser from the same source** (no competitor hits this).

**Must-build (the gate):** PERFORMANCE_SPECIALIZATION **Stage 3 (struct SROA)** + **Stage 4 (float-column raw `double[]` + SIMD)** + **Stage 5 (whole-program use-set monomorphization for ECS system bodies)**. *Without native float codegen for column iteration, every system loop falls back to `nova_rt_mul` (150–300× slower) and the ECS thesis collapses to "a slower flecs."* This is **the hardest and highest-leverage compiler work in the whole engine.** (Stage 1 direct-call native math is DONE and proves the path; Stage 2 was attempted twice and reverted — see §11.)

### 6.2 Rendering — *the render graph as a process/channel DAG*

The renderer is a retarget of three NOVA analyses that already exist: the channel dependency graph (→ barriers + async scheduling), escape/liveness allocation inference (→ VRAM transient aliasing), and the typed-IR `fmul/fadd` path (→ NOVA-as-shader-language).

- **Layer 0 — GPU resources are Values with an inferred `GpuResident` capability** (one structural walk, same as `Sendable`): blittable, pointer-free layout → lives in VRAM. A `gpu list<Vertex>` reuses the Stage-4 raw-array work with a residency tag. VRAM is reclaimed by the *same* arena-drop that frees CPU memory — no Godot `RID free()` use-after-free.
- **Layer 1 — the CPU↔GPU boundary is a channel** with the per-topology cost model (§2). Sending a non-`GpuResident` value on a GPU channel is a **compile error** with NOVA's signature message style.
- **Layer 2 — the render graph IS a NOVA process/channel DAG.** A render pass is a process; its resources are the Values it sends/receives. From the channel wiring the compiler **derives** the three things every engine hand-writes: **barriers** (= read-after-write edges), **transient VRAM aliasing** (= the same liveness analysis, retargeted to a VRAM heap — Frostbite saved ~50% RT memory this way), **async-compute scheduling** (= independent subtrees). Dead-pass culling falls out of NOVA's existing DCE. The plan is an inspectable Value (`print(plan)` works).
- **Layer 3 — shaders are NOVA, lowered to SPIR-V (then Slang IR for DXIL/MSL/WGSL).** A shader entry point is a **leaf, monomorphic** function — exactly the case where Stage-1 specialization is *already proven sound* today (no `ti_fn_param_types` trap). Bind groups are derived from data flow (no `layout(set=0,binding=3)` boilerplate). **Adopt Slang as the multi-target backend IR** (Khronos standard since Jan 2025, native D3D12/Vulkan/Metal/WebGPU/CUDA/CPU + autodiff for neural rendering) — do NOT hand-roll an N-hop cross-compiler.
- **Layer 4 — GPU-driven by default.** Compute cull → indirect draw → bindless. And the work-graph endgame: `spawn pass(...)` where `pass` is a `GpuKernel` lowers to a **D3D12 Work Graph mesh node** where supported, classic indirect-draw where not — *same source.* The hardware's self-scheduling model already *is* NOVA's process/channel model.
- **Layer 5 — neural rendering is a graph node type, not a plugin.** DLSS-class upscale / NRC / neural materials are NOVA Processes (Values in, Values out) reusing NOVA's existing tensor primitive (`tensor_*` is REAL today) lowered onto tensor tiles via Cooperative Vectors. Online-trainable NRC = a process holding mutable weight-Values, safe by isolation.
- **Erasure kills Unreal's fixed ms floor:** a 2D game that never references GI/RT/virtualized-geometry → those passes are DCE'd → **zero cost.** A Snake game's render graph is `clear → draw_sprites → present`.

**Must-build (hard prerequisites, in order):** windowing + surface + swapchain (FFI); real GPU device bindings behind the *existing* `nova_rt_gpu_*` integer-handle ABI (target **wgpu-native first** — one binding = Vulkan/D3D12/Metal/GL/WebGPU + the browser); `f32`/`f16`/`f32x3`/`u32` scalar+vector types; the `GpuResident` walk; GPU-channel transport + cost model; the **NOVA→SPIR-V GpuIR backend** (the largest net-new component). *Today `nova_rt_gpu_*` is a calloc CPU stub — this is the single largest unbuilt subsystem.*

### 6.3 One Language + Crash-Proof Hot Reload

**The substrate already exists** (verified in the runtime): `nova_rt_spawn` deep-copies context but **shares channels**; `nova_rt_monitor` fires on process exit (the supervisor's restart trigger); file-watch + `dlopen`/`hot_reload`/`hot_sym`/`hot_call` are real; the per-task setjmp fault boundary contains a crash and reports it as a channel message.

**Why isolation makes structural reload safe where shared memory makes it fragile:** in Unreal, a live `AActor*` is held by the renderer, AI, and save system — recompile its class and every held pointer is wrong (so Live Coding forbids add/remove `UPROPERTY`). In NOVA, **nothing outside the physics process holds a pointer into it** — the renderer holds a *channel handle*. Reload = serialize state out with a name-keyed structural codec, throw the old isolated process away, reconstruct into the new shape. **A structural change is the normal case.**

**The reload protocol** (existing primitives + one new intrinsic): watch → recompile *one* system (sub-second incremental) → `Drain` at a frame boundary → `snapshot(self)` (a layout-independent, name-keyed structural Value) → supervisor `spawn`s the new code with the *same channel handles* + the snapshot → new process rehydrates. **< 100 ms, single-digit ms realistically.** A bad reload panics on first `Reload` → the fault boundary fires → supervisor re-spawns the last-good module → **auto-rollback, game never crashes.** A bad Live Coding patch can crash the Unreal editor.

**Replay-safe:** a swap is logged as a frame-boundary checkpoint, so you can hot-reload during a *recorded competitive match* and the replay still verifies bit-identical.

**Must-build:** `snapshot`/`restore` as a **name-keyed** (not offset-keyed) structural intrinsic (extends shipped auto-Show/to_json machinery — *this is the load-bearing new piece*); the reload-orchestration glue; per-system shared-object emission from `nova_build`. *Honest limit:* FFI-backed systems (Box2D world pointer, open socket) reload only if the lib exposes serialize/restore — such resources must live behind a channel to a device-owner process, and the compiler flags a non-snapshottable field in a reloadable process.

### 6.4 Physics — *the island is the process, determinism is a compiler property*

**The island is the process; the substep is the deterministic tick; determinism is a compiler-emitted `@det` mode.** A physics **island** (connected component of the contact+joint graph) is by definition causally independent within a step — which is *exactly* NOVA's process-isolation invariant. **Island parallelism is not scheduled; it is a consequence of the model.** Jolt needs ~2000 lines of hand-written lock-free atomics + a 32-split atomic island-splitter precisely because its bodies live in shared memory; Reactor's bodies are process-local → the race is impossible by construction → **the atomic machinery evaporates.**

- **Pipeline per step:** broadphase (one coordinator, two-tree AABB) → island build (Union-Find, deterministic island id = min stable entity id) → **solve (one process per island, in a contiguous SoA arena, mutated in place — zero channel traffic, zero deep-copy, zero locks)** → commit barrier (canonical order).
- **Large-island splitting without atomics:** graph-color the constraint graph (deterministic order), sub-spawn one process per color (each internally race-free), solve colors in fixed sequence.
- **The deep-copy danger, resolved:** an island process is spawned **once** with its arena (cheap, amortized) and **persists across frames**, mutated in place. Body state *never crosses a channel during solve* (the runtime's `channel_send` deep-copies — fatal at 60–120 Hz × substeps). Only topology changes migrate a body between arenas — rare, bounded.
- **`@det` codegen mode** (only possible because NOVA owns the compiler): for code reachable from the physics process, pin `-ffp-contract=off`, forbid reassociation/fast-math in the auto-vectorizer **for that region only**, link NOVA-native deterministic `sin/cos/atan2`, statically reject clock/RNG/iteration-order dependence, and offer an **optional Q48.16 fixed-point backend as a Value-swap** (not a rewrite). Box2D applies this recipe by hand in C; Reactor *bakes it into the compiler and proves it.*
- **`world.physics(verify: true)`** re-runs each step and asserts byte-identity **AND** asserts native == WASM — turning netcode's hardest QA problem into a checkbox.
- **Rollback = COW, not deep-copy:** `snapshot()` structure-shares island arenas (O(columns)); first mutation after a snapshot copies that arena only (O(changed), not O(world)). Reuses NOVA's RC/version-tick headers.

**Beats:** PhysX (non-deterministic across HW — a *capability* win, not a perf win) · Jolt (matches the architecture, deletes the atomics; +15–30% on many-island scenes once SoA lands; shape-pair monomorphization removes the per-contact virtual dispatch Jolt pays) · Box2D (bakes its determinism recipe into the compiler and extends it to user code) · Bevy/Avian (parallel AND deterministic, which Bevy can't be without manual ordering).

**The unique triple no one else has simultaneously:** parallel (free) + deterministic (compiler-proven, default) + rollback-ready (COW + replay debugger + native↔WASM bit-identity).

### 6.5 Audio — *a realtime process class the compiler proves glitch-free*

**The audio callback is the one place NOVA's entire concurrency model is illegal** — an OS-elevated RT thread that must fill 256–1024 samples every 3–21 ms and may *never* allocate, lock, do I/O, or run on a cooperative fiber. So the design's first job is a **new process kind** the compiler **proves** is alloc-free, lock-free, and copy-free.

- **Three process classes:** `world` (green, sim clock, normal deep-copy channels) · **`realtime`** (NEW — one pinned OS thread elevated to MMCSS Pro Audio / CoreAudio workgroup / SCHED_FIFO, audio-block clock, **compiler-proven NO allocation**, lock-free SPSC move-channels) · `offload` (existing pool — decode/stream).
- **The compiler proves no-glitch:** the realtime body is type-checked under a restricted effect lattice — heap alloc, normal channel send/recv (deep-copy + park), locks, unbounded loops, and any call to a non-`realtime` function are **compile errors with locations.** *"The compiler rejects any audio code that could underrun"* — FMOD/Wwise/Unity *hope*; they cannot prove. This is a language-level capability.
- **The green↔RT channel** is a new lock-free SPSC `move` channel of POD-only commands (`PlayVoice`, `SetParam`, `StopVoice`) — verified `Pod` by the compiler. Clip *data* never travels it — only IDs into a pre-loaded immutable, RC-frozen sample bank (read-only sharing is safe).
- **The DSP graph is a Value the compiler fuses:** a voice→highpass→EQ→compressor chain compiles to ONE fused per-sample kernel (sample stays in registers, no buffer round-trips), const-folds fixed params, auto-SIMDs the block loop, auto-parallelizes independent submix subtrees onto RT helper threads. Middleware can't — each DSP unit is a separate dynamically-dispatched object.
- **Spatial:** Tier-1 (HRTF binaural + distance + Doppler) in the RT block; Tier-2 (occlusion, reflections, reverb params) computed off-thread by an `offload` process ray-tracing against **the same scene BVH the renderer builds** (acoustic and visual rays are the same math). FTZ/DAZ on entry; voice virtualization (top-K audible) for scale.
- **WebAudio:** the same DSP source compiles to an AudioWorklet (128-sample quantum); green cooperative threads give full logic concurrency without SharedArrayBuffer — escaping Godot's web-audio garble.

**Must-build (P0):** the `realtime` process class + the no-glitch proof (the hardest, load-bearing part); pinned RT OS thread + platform priority (zero such code today); the lock-free SPSC move-channel; `Pod` inference. *Honest risk:* proving no-alloc through NOVA's RC/boxing value model (the float-into-`any` boxing hazard the codebase has fought) is genuinely hard — fallback is a hand-audited unsafe block for v0.1, but the *proof* is the differentiator and must land by R1.0.

### 6.6 Netcode & Mesh — *the engine's execution model IS the netcode substrate*

**Lockstep, rollback, and client-prediction/reconciliation are not three subsystems — they are three *configurations* of one `sim world` process,** differing only in who is authoritative, who rolls back, and the channel QoS. **The client and server are the same source.** Structurally uncopyable by the incumbents because it's enabled by language properties, not a library.

- **Layer 0 — the deterministic core** (the `det` effect, §6.4 shared): same-inputs → byte-identical state on every platform, native AND WASM, *proven by the compiler.* The **deterministic tick barrier** (parallel read-phase over the frozen previous tick → canonical-order commit) is the linchpin. A **determinism fuzzer** (`reactor test --determinism`) runs 1-carrier vs N-carrier and native vs WASM and asserts bit-identity.
- **Layer 1 — COW snapshot/restore/resimulate** (O(changed), not O(world)): snapshot RC-bumps the frozen columns (near-free); the commit phase copies only columns changed since a held snapshot. 32 retained snapshots per client (Quake3's number) is cheap because unchanged columns are shared.
- **Layer 2 — compile-time delta/quantization codec.** Because the compiler knows every field's layout, it emits a per-component **dirty-bitmask delta encoder** (1 bit/unchanged field) + a **type-driven quantizer** (a `Position in [-1024,1024]@0.01` → 16-bit) at *compile time* — beating Photon/Lightyear/NGO which generate replication from *runtime* reflection. **Channel QoS** = `{reliable-ordered (TCP/QUIC), unreliable-sequenced (UDP), unreliable}`; the hot path is `[tick|ack|ackbits|binary-delta]` over UDP — **replacing the current TCP+JSON `remote_*`, which is fatal for real-time** (head-of-line + bloat). **Interest management (AOI)** makes bandwidth O(visible), the MMO-scale lever.
- **Layer 3 — three models, one engine:** lockstep (input-only channels) · rollback (predict + COW restore + resimulate inside the frame) · authoritative predict-reconcile (server snapshot + replay unacked inputs + snapshot interpolation + lag compensation). **One-codebase client+server:** `reactor build --server` strips client-only systems via dead-code erasure → *desync-by-divergent-code is structurally impossible.*
- **Layer 4 — Mesh:** the authoritative server/relay/shard is a NOVA process over a (binary, QoS'd) distributed channel; MMO sharding = one `sim world` per spatial shard, AOI channels stitching boundaries. **Deterministic replay debugger** = record the input log, reproduce *any* desync byte-exactly — netcode's worst pain, as a language feature.

**Beats:** Photon Quantum (its real engine IS the deterministic engine — no second engine, no per-CCU billing, self-hostable) · Mirror (prediction+rollback built-in, 3–6× less bandwidth via delta) · Unity NGO / Unreal replication (no GC, parallel, compiler-proven determinism they can't claim) · Bevy/Lightyear (proves determinism the developer must hand-maintain; generates codec at runtime).

**This is the rare subsystem that does NOT block on the GPU gap** — it can be built and proven **headless** before a single pixel is drawn. **Must-build (P0):** binary QoS UDP channel; the `det` effect + optimizer pinning + det math lib; the deterministic tick barrier (the hardest piece); COW snapshot; the compile-time codec.

### 6.7 Editor & Asset Pipeline — *the real moat*

The research is blunt: **the editor, not the runtime, is where lock-in and developer love live** (Bevy has a world-class ECS and ~zero studios because it shipped editorless). The editor is **a live process tree**, and the "scene" is a snapshot of that tree's Values.

- **Scene format = the language's structural identity.** `json_stringify`/`==`/`copy`/`hash`/`from_json` are ONE compiler-derived field-walk — so serialization, content-hash identity, structural equality, deep-clone, and the editor inspector all come from the same code and *provably cannot drift.* The scene is `json_stringify(world_snapshot)` — diffable, mergeable, AI-generatable. Beats Unity's external-GUID-DB AND Unreal's opaque binary `.uasset`. *(Real constraint: the scene root is a wrapper struct, not a bare list, to dodge the known top-level-`list<Struct>` serialization gap.)* Cross-references are **content hashes** → free dedup + incremental cook.
- **Play-in-editor = `spawn game_root(copy(authoring_world))`.** The game runs in an isolated subtree; "Stop" kills it; the authoring document is *untouched* because the game got a copy. No domain reload (Unity recommends *disabling* its 5–30 s reload).
- **Hot reload** (§6.3) — the headline: structural changes, crash-proof, ~50× Unity's iteration loop.
- **Asset pipeline = a content-addressed process/channel build graph.** Each cook stage (import_gltf, quantize_mesh, encode_texture BC7/ASTC, compile_shader, pack) is a process; artifacts flow over channels keyed by content hash → **incrementality + dedup + distributed cook over the existing distributed channels** (a build farm with zero new infra), all as a *consequence* of the language, not UE's bespoke DDC/Zen/Multi-Process-Cook. Unused assets are dead-stripped by the same erasure that strips dead code. **Compile-time embed into the binary** (go:embed-equivalent) → single-binary ship.
- **Skeletal animation + anim graphs** = a process pipeline of pose channels (clip_sampler → blend_space → state_machine → IK). A single character erases to a tight inlined native function; 10,000 characters auto-parallelize across the M:N scheduler (Unreal is game-thread-bound). GPU skinning = a NOVA `GpuKernel`.
- **The editor runs in the browser from the same source as the desktop editor** (WASM frontend Stages 0–3 are REAL: host=peer-process, import-table=channel, DOM build via export dispatch). Inspectors auto-generate from the same structural walk (field type → widget, zero boilerplate). *Honest boundary:* the inspector/scene-tree UI runs in-browser today; the 3D viewport waits on the GPU backend, and full play-in-browser waits on WASM Stage 4 (full C-runtime→wasm + the 32-bit-pointer CVE re-test).

### 6.8 The Future Pillar — *placement-agnostic processes as a hardware-heterogeneity compiler*

This is §2 + §4 made into the **architectural spine** every other subsystem lowers into. The **placement scheduler** is the part everyone hand-waves; here is the concrete algorithm:

- **CostVector per node** (static, from the IR): `{flops, bytes_touched (ranked first), branch_div, serial_chain, has_atomics, mlp_macs, deadline_us}`. **bytes_touched is ranked above flops** because off-chip byte ≈ 100–1000× a FLOP's energy.
- **DeviceDescriptor per tile** (probed at launch): `{kind, lanes, peak_flops, mem_bw, mem_coherent, feature_bits:{bindless, mesh_shaders, work_graphs, rt_cores, tensor_cores, foveation}, link_to_host_bw, deadline_capable}`.
- **Static placement** = a fast list-scheduling / critical-path heuristic (NOT an NP-hard solver — keep compiles fast): topologically order; for each node × compatible device compute `compute_cost + Σ incoming_edge.transfer_cost`; greedily assign to the min-cost device under two hard constraints (Present/Audio nodes get a deadline-capable device; caps must satisfy the device); **coalesce adjacent same-device nodes by erasing the channel** (NOVA's existing single-process erasure, applied across the render graph).
- **Runtime refiner** (M:N scheduler extension): **priority/deadline bands** (the Compositor never misses 90–120 Hz even if Sim is parked) + **tile-aware stealing** + re-placement when real hardware is discovered (no NPU → a NeuralStage falls back to a CPU/GPU MLP) or a cloud edge appears (split rendering).

**Worked example — one game, three targets, zero code change:** RTX 5090 PC (Sim on CPU; Cull/Shade as mesh-shader + work-graph nodes on the discrete GPU; one batched PCIe DMA on the Sim→Cull edge; Upscale on tensor cores) · PS5 unified memory (same PAPG; Sim→Cull becomes a **zero-copy pointer pass**; work-graph nodes fall back to compute-cull + indirect-draw) · Browser (same PAPG; WebGPU backend per RenderPass; Sim single-thread cooperative-green; determinism gate asserts byte-identity vs native).

---

## 7. Honest Reality Check — What NOVA Has TODAY

> Per the failure-hunt mandate: the design is audacious; the implementation gap is wide. Here is the truth, separated cleanly.

**REAL today (the foundation — production-grade, load-bearing, do not rebuild):**
- ✅ Process isolation + `spawn` (deep-copy isolated state, shared channels)
- ✅ Typed channels (local) + supervisor crash-restart (let-it-crash, setjmp fault boundary) + supervisor strategies (one_for_all/rest_for_one)
- ✅ M:N work-stealing green scheduler + netpoller (10K green tasks / 10K parked, 382 ms)
- ✅ **Stage-1 direct-call native math** (unannotated scalar + struct params → `fmul/fadd`, ~1.04× C, zero `nova_rt_*`)
- ✅ WASM logic + DOM frontend (byte-identical native↔WASM for dicts/structs — m6) + TCP + UDP sockets + distributed channels (TCP+JSON)
- ✅ Tensor primitive (`tensor_*`: matmul/relu/softmax) · automatic structural Show/serialize/==/hash/copy · file-watch + `dlopen` hot-swap primitives · `nova_build` incremental

**PARTIAL:** ECS (functional but flat **linear-scan, string-keyed** — `nova_runtime.c` — the worst possible layout; no archetype/SoA perf) · hot reload (file-watch real; live code-swap + state migration unbuilt).

**STUB / NOT STARTED (the engine's body):** rendering (the `nova_rt_gpu_*` handle is a **calloc CPU stub** — no device dispatch, no SPIR-V, no windowing) · audio · physics · raw/non-blocking input · image/texture/glTF decoders · shaders-in-NOVA · deterministic netcode · real-time process class.

**What you can build today:** turn-based / logic-only games, headless network multiplayer, WASM-deployed logic. **What you cannot:** anything with real-time graphics, audio, physics, fast input, or vsync'd frame coherence — *yet.*

**The brutal meta-truth:** Reactor could be technically superior on every axis above and **still lose** if it has no editor, no asset store, no flagship game (Unity won mobile on *accessibility*, Godot is rising on *trust*, Bevy has the best ECS and near-zero adoption). The technical moat is necessary, not sufficient. **Win the editor + hot-reload + one-language tooling layer (where the moat actually is) AND ship a flagship game on it** — Epic's playbook. That is years, not quarters.

---

## 8. The Critical Path — Language/Runtime Gaps (Dependency Order)

These are NOVA-language capabilities that must exist *before* Reactor proper. The linearized chain: **G0 → {G1 → G2 → G3 → G4, G5, G6}; G7 parallel.** G0 is the universal blocker; G7 is the universal perf gate.

| Gap | What | Size | Blocks |
|---|---|---|---|
| **G0** | **C FFI hardening**: struct-by-value across the ABI, **callback FFI** (C→NOVA, mandatory for audio callbacks + event pumps), opaque non-copyable handle Values | medium | *everything* |
| **G7** | **Perf-spec S3 (struct SROA) + S4 (float-column raw `double[]`/SIMD) + S5 (HOF/closure monomorphization)** | hard | ECS/physics/audio perf — the "destroy" claim |
| **G1** | Raw/non-blocking input as a **probabilistic typed-event channel** `{kind, code, value, confidence, t_ns}` (reserves the shape for gaze/EMG/BCI) | small | input |
| **G2** | Windowing + surface/swapchain (SDL3 or native) | small-med | rendering |
| **G3** | **GPU device bindings** (wgpu-native first = 6 backends + browser) behind the existing handle ABI; GPU-channel transport + cost model | large | all visual |
| **G4** | **NOVA→SPIR-V** shader lowering (reuse frontend + typed-IR; Slang IR for multi-target) | large | one-language shaders, GPU-driven |
| **G5** | Audio backend (miniaudio) on the **realtime process class** + lock-free SPSC channel | medium | audio |
| **G6** | Image/texture/glTF/OGG decode (FFI for v0.1, pure-NOVA for WASM purity) + content-addressed cache | medium | assets/anim |
| **+** | Scheduler **priority/deadline lanes** + OS-thread pinning + tile placement hooks | medium | compositor, audio, future-HW |
| **+** | The **`Deterministic` capability** + COW snapshot + binary QoS channel | hard | netcode/replay |

---

## 9. The Phased Build Sequence (Honest Timelines + Gates)

Timelines assume the solo developer + the verified gate (edit → precheck → gen4 smoke → bootstrap reconverge → regression → commit). Conservative; the audio proof and shader codegen are the long poles.

| Phase | Delivers | Gate (must pass to proceed) | ~Effort |
|---|---|---|---|
| **R0 — Runtime Foundations** | G0 (FFI+callback+handles), realtime process + lock-free channel, scheduler priority/deadline lanes, **G7 S3/S4** | Compiler-proven no-alloc audio process renders a sine glitch-free 1 hr under load; a `float[]` column loop emits native SIMD (verified in `.ll`, zero `nova_rt_*`). **If S4 doesn't land, STOP — the ECS claim is dead.** | 10–16 wk |
| **R1 — Input + Window + ECS spine** | G1+G2+G3 minimal; archetype storage + static disjointness DAG replacing linear-scan | 100K entities / 5 systems auto-parallel in **< 1.5 ms**; window + input + clear at locked 60 fps; bootstrap reconverged | 3–5 wk |
| **R2 — 2D Renderer + Audio + Assets (first real game)** | sprite batching, texture upload via GPU-channel, proven-no-alloc audio mixer, PNG/OGG decode, content-addressed cache | **Ship a real 2D game** at 60 fps, 10K sprites; hot-reload a system in < 100 ms with no state loss; **same source runs in the browser** byte-identical; kill the audio process → game survives | 8–12 wk |
| **R3 — Netcode + Determinism (the structural KO)** | binary QoS UDP channel, `Deterministic` capability, COW snapshot, deterministic tick barrier, compile-time delta codec | **4-player rollback game, byte-identical native AND WASM** (fuzzer asserts it); 7-frame rollback+resim inside 16 ms; lockstep AND predict-reconcile from one core | 8–12 wk |
| **R4 — 3D Renderer (GPU-driven) + Shaders-in-NOVA** | render graph as process/channel DAG; compute-cull → indirect → bindless; NOVA→SPIR-V; all PSOs precompiled | 1000 PBR objects + 100 lights @ 60 fps/1080p; **zero first-appearance shader hitch** (precompiled); a NOVA shader runs on Vulkan AND WebGPU from one source | 16–24 wk |
| **R1.0 — Physics + Editor + Animation** | island-as-process physics; NOVA-native editor (native + WASM, text+content-hash scenes); structural hot reload; anim pipeline | **Ship a 3D game** with physics, an editor a non-programmer can use, instant safe hot-reload incl. schema changes, deterministic replay debugger | 24–36 wk |
| **Future (post-1.0)** | GPU-process lowering (spawn → work-graph/mesh node); neural rendering stages + online-trained NRC; tile-aware placement scheduler; XR compositor process; cloud/distributed split rendering | each is "one more backend/process kind," not a rewrite | — |

---

## 10. Competitive Scorecard

**WIN** = structural advantage today or falling directly out of NOVA's real model. **TIE** = parity, no structural edge. **LOSE-NOW/WIN-WHEN-BUILT** = incumbent genuinely ahead today; the win rests on an unbuilt subsystem (labeled honestly — nothing on an unbuilt subsystem is marked WIN today).

| Axis | Unity | Unreal | Godot | Bevy |
|---|---|---|---|---|
| **CPU perf / no-GC** | **WIN** (no GC hitches; ~1.04× C zero-annotation) | **WIN** (parallel day-one) / TIE single-thread | **WIN** (large) | **WIN-when-S5** / TIE today |
| **ECS** | **WIN** (one model, inferred storage) | **WIN** (decisive; UE isn't DOD) | **WIN** | **WIN** ergonomics+safety / TIE raw-iter today |
| **Rendering** | LOSE-NOW / **WIN-when-built** (render-graph-as-language; zero PSO stutter) | LOSE-NOW / **WIN-when-built** | LOSE-NOW / **WIN-when-built** | LOSE-NOW / **WIN-when-built** |
| **Scripting / language** | **WIN** (one lang, no GC, no IL2CPP) | **WIN** (decisive; no BP/C++ cliff) | **WIN** (no marshaling) | **WIN** ergonomics |
| **Netcode** | **WIN-when-built** (deepest weapon) / LOSE today | **WIN-when-built** | **WIN-when-built** | **WIN-when-built** |
| **Editor / tooling** | **WIN on hot-reload** / LOSE on maturity | **WIN on hot-reload** / LOSE on maturity | TIE-to-WIN / LOSE on maturity | **WIN** (Bevy has none) |
| **Platform reach** | TIE-to-LOSE / **WIN on web** | LOSE on console maturity / **WIN on web+edge** | **WIN on web** | **WIN** |
| **Future-hardware readiness** | **WIN (decisive)** | **WIN (decisive)** | **WIN (decisive)** | **WIN (decisive)** |

The honest summary: **today** Reactor is a foundation + a slow linear-scan ECS + no renderer. **Built**, it wins the structural axes (ECS, language, netcode, hot-reload, future-hardware) decisively and matches-then-beats on rendering. The future-hardware row is the one that decides the next 15 years, and it is a WIN *by construction.*

---

## 11. The Biggest Risks (Named, Not Hidden)

The make-or-break items, hardest first. These are where a junior implementation ships a disaster.

1. **PERFORMANCE_SPECIALIZATION Stage 2–5 is the linchpin and partly unsolved.** Without native float column codegen, every system/render/audio/physics loop falls back to `nova_rt_mul` (150–300× slower) and Reactor is "a slower flecs with nicer ergonomics." **Stage 2 was attempted twice and reverted** (a load-dependent float value-model flake). The sound HOF path is **Stage-5 whole-program use-set monomorphization** (the naive `ti_fn_param_types` fix is documented UNSOUND — it read int bits as a double, breaking math3d/complexnum). It's *tractable* because ECS systems are monomorphic-by-construction — but it is the hardest compiler campaign on the critical path. **Falsifiable:** `_dot_untyped` over a `double[]` column must emit `fmul`, zero `nova_rt_*`.

2. **The deterministic tick barrier is a fundamental tension, not just unbuilt code.** Weapon 2 (parallel via work-stealing) is *nondeterministic in order*; Weapon 4 (proven determinism) *demands* bit-identical order. The resolution — parallel execution, canonical-order commit — is sound in principle but unproven, adds latency/memory, and requires the auto-vectorizer to be determinism-mode-aware. **Falsifiable:** a 100K-entity sim with cross-system same-tick dependencies must produce byte-identical state native vs WASM vs across thread-counts, within frame budget. Until that passes, Weapon 4 is a hypothesis.

3. **Deep-copy channel semantics are fatal on hot paths** (audio block, per-frame rollback, intra-island handoff). The runtime's `channel_send` deep-copies — verified. The design requires **three distinct new mechanisms** (zero-copy intra-island arena, COW snapshot distinct from spawn-deep-copy, no-alloc audio channel) — none exist, each departs from the current isolation model. If they can't be added without breaking the isolation guarantee that *makes NOVA safe*, the audio/physics/rollback weapons stall.

4. **The GPU backend is the largest unbuilt subsystem** and gates rendering + shaders + WASM-GPU. If NOVA→SPIR-V hits impedance mismatches (the value model vs SPIR-V's no-heap / restricted-control-flow constraints), the "one language for shaders" weapon degrades to "a NOVA-flavored shader subset" — recreating the very dialect split we mock. **Falsifiable:** can a non-trivial NOVA function lower to valid SPIR-V *without* a restricted subset? Per-platform golden-image CI is mandatory.

5. **The no-alloc audio proof may be intractable through NOVA's RC-heavy value model.** Proving a hot path touches no strings/lists/dicts/implicit-boxing requires a restricted value subset + a real effect pass. If it can't, audio degrades to a hand-audited unsafe block — acceptable for v0.1 but it forfeits the FMOD/Wwise-beating differentiator.

6. **Ecosystem + trust, not tech, decide the market** — and Reactor has zero. (See §7.) Mitigation: win the editor/tooling moat *and* ship a flagship game. Years, not quarters.

7. **The meta-risk: trying to be best at everything violates "simplicity is sacred / never become C++."** Eight weapons + render graph + netcode + audio + editor + GPU + WASM is an enormous surface. **The discipline: every weapon must FALL OUT of the three primitives, never be bolted into the language for games.** The moment Reactor needs a game-specific language feature, the thesis has failed.

---

## 12. Project Structure

### 12.1 What a developer's game looks like (`reactor new mygame`)

```
mygame/
  reactor.toml              # engine version, targets, asset roots
  src/
    main.nova               # entry: reactor.run(world)
    components/             # plain structs — become components by attachment (zero annotation)
    systems/               # plain fns over queries — become parallel processes
    shaders/               # NOVA fns inferred as GpuKernel → SPIR-V/WGSL/MSL/DXIL
    scenes/                # *.scene = json_stringify(world_snapshot), text, diffable
  assets/                  # raw: gltf/png/ogg — content-addressed, cooked at build
  net/                     # sim world is here; `--server`/`--client` strip via dead-code erasure
  build/                   # cooked + embedded artifacts (single-binary output)
```

The boundary the compiler enforces: scene-persistable state is **pure Values** (a `Persistable` capability, sibling to `Sendable`); live handles (channels, GPU buffers, sockets) are reconstructed on load, never serialized.

### 12.2 Reactor's own internal modules (the engine, in NOVA)

```
reactor/
  ecs/          # archetype/sparse/bitmask storage (compiler-chosen), generational ids, command buffer, static scheduler
  render/       # render-graph-as-channel-DAG, GpuResident, barrier+aliasing derivation, GPU-driven, neural nodes
  shader/       # NOVA→GpuIR→SPIR-V; Slang-IR multi-target; bind-group derivation
  physics/      # island-as-process, broadphase, GJK/EPA/SAT, TGS-soft solver, @det, COW snapshot
  audio/        # realtime process class, lock-free SPSC, DSP-graph fusion, HRTF, backends
  net/          # det effect, tick barrier, COW snapshot, delta/quantization codec, QoS channels, AOI
  input/        # probabilistic typed-event channel; decoders (controller/gaze/EMG)
  assets/       # content-addressed cook graph (process/channel), embed-into-binary, decoders
  anim/         # skeleton Values, blend/state-machine/IK as a pose-channel pipeline, GPU skinning
  editor/       # NOVA app (native + WASM); auto-inspectors from the structural walk; play-in-editor; hot reload
  platform/     # windowing/surface, RT-thread pinning, device descriptors, the thin per-OS FFI shims
  papg/         # the placement-agnostic graph: cost vectors, placement scheduler, three-clock bands
```

Every directory is a *retarget of NOVA analyses*, not a bespoke C++ subsystem — which is exactly why no incumbent can copy the set.

---

## 13. The One-Paragraph Summary

Reactor is a game engine in which **the frame is a graph of isolated Processes communicating over typed Channels**, so the render graph, netcode, audio mixer, physics solver, and editor are all the same three primitives — and the same source retargets, by adding a backend rather than rewriting, to a CPU, a GPU work-graph node, an NPU tile, a browser, or a remote machine. It destroys Unity (one model, no GC, no DOTS split), Unreal (parallel day-one, no Blueprint cliff, no PSO stutter), Godot (the ergonomic unit *is* the fast unit, one language), and Bevy (compiler-inferred storage + static parallelism + an editor) — and on the axis that decides the next 15 years, **future hardware, it wins by construction**, because GPU work-graphs, coherent memory, neural pipeline stages, and heterogeneous tiles *are* Values/Processes/Channels in silicon. The technical moat is real and uncopyable (each weapon falls out of the language, not a library); the build is large and gated on three hard things — finishing the native-float specialization (S3/S4/S5), the deterministic tick barrier, and the GPU/SPIR-V backend — and the market still demands an editor and a flagship game. The plan is honest about all of it. **One developer, one language, builds the engine and the game and the shaders and the tools and the netcode — and ships them to every platform that exists, and the next one too.**
