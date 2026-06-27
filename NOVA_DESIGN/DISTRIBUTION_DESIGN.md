# Distribution (remote_spawn + cross-node messaging) — Design

**Goal:** complete "channels across ALL boundaries" — spawn a process on a *remote* node and message it as
if local, so a NOVA cluster is just processes + channels over the network. This is the Erlang/OTP
distribution moat (`spawn` on another node, transparent message passing, cross-node monitors).

## What already exists
- `remote_*` (connect / listen / send / recv / close) = NOVA channels over TCP (length-prefixed JSON),
  green-aware (parks on the netpoller). Point-to-point, working (see [[project-distributed-channels]]).
- The local OTP layer: spawn / monitor / supervisor / GenServer (`forge_otp.nova`).
- Deep-copy for message payloads across the spawn/channel boundary.
- **`remote_spawn` is a STUB** — the gap this design fills.

## Design

1. **Node identity + registry.** Each node has an id `name@host:port`. A node connects to peers
   (`node_connect(peer)`) establishing a single duplex TCP **link** per peer (reusing the `remote_*`
   framing). A local registry maps `node_id -> link`. A peer directory lets a node resolve `node_id`.

2. **remote_spawn protocol.** Functions can't serialize as closures, so they ship **by registered
   name**: a per-node `fn-id registry` (top-level fns registered at startup, same name+id on every node).
   `remote_spawn(node, "fn_name", args)` sends `{op:"spawn", fn:"fn_name", args:<deep-copied/JSON>}` over
   the link; the remote node looks up `fn_name`, `spawn`s it locally with the args, and replies
   `{pid:<local_pid>}`. The caller gets a **remote pid** `= {node, pid}`. (Args travel as JSON/deep-copy;
   the fn must exist on both nodes — a cluster runs the same binary.)

3. **Message routing to remote pids.** `send(remote_pid, msg)` routes over the target node's link as
   `{op:"msg", pid:<local_pid>, body:<msg>}`; a per-node **router** task drains the link and delivers each
   message to the addressed local process's mailbox (its channel). Replies carry the sender's remote pid so
   the receiver can reply across nodes symmetrically.

4. **Failure / monitor across nodes.** A link carries heartbeats; on link close / heartbeat timeout the
   node is **down**. Local monitors of remote pids on that node get a `DOWN` signal (reuse the OTP monitor
   mechanism — the router synthesizes DOWN for every remote pid on the dead link). This gives cross-node
   supervision (a supervisor can restart a remote child elsewhere).

## Reuse vs new
- **Reuse:** `remote_*` (link + framing), the OTP local side (spawn/monitor/supervisor), deep-copy/JSON.
- **New:** the fn-id registry, the node registry + link manager, the spawn/msg/heartbeat protocol on the
  link, the router (pid demux), cross-node DOWN synthesis.

## First sub-step
The **fn-id registry** + `remote_spawn` over an existing link to a same-binary peer, returning a remote
pid, with a `{op:"msg"}` round-trip. (Monitors + heartbeat next.)

## Gate (focused, multi-process session)
Two processes (two nodes): node A `remote_spawn`s a fn on node B, sends it a message, gets a reply; then
kill node B and assert node A's monitor fires `DOWN`. Real sockets, two OS processes, kill-on-timeout.
