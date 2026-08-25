## 18. Advanced concurrency

### What is this?

Sections 9 and 10 covered NOVA's basic concurrency: `spawn` to create tasks, `channel` and `send`/`receive` to communicate between them, and `select` to wait on multiple channels. But real concurrent programs need more. What happens when a task crashes? How do you avoid waiting forever? How do you build systems that recover from failures instead of dying?

This section covers three advanced concurrency tools: **monitors** (detecting when a task finishes or crashes), **timeouts** (bounding how long you wait), and **supervision** (building fault-tolerant systems that restart failed tasks). These are the same patterns that make Erlang/OTP (Open Telecom Platform) systems run for years without downtime, but in NOVA they work without special syntax or framework imports.

### Monitors -- watching for task completion

A monitor is a one-way observation link: you ask the runtime to notify you when a specific task finishes. The notification arrives on a channel that `monitor` returns, and you read it with `receive` just like any other channel message.

Why do you need this? Without monitors, the only way to know if a spawned task finished is to have it send you a message. But what if it crashes before sending? You would wait on `receive` forever. A monitor solves this: the runtime itself sends the notification, even if the task crashed or exited abnormally.

```nova
ch = channel()

pid = spawn fn()
    send(ch, 42)

mon = monitor(pid)
result = receive(ch)       // get the task's output
status = receive(mon)      // get notified when it exits
print(result)              // 42
print(status)              // exit status
```

**Line-by-line breakdown:**

- `ch = channel()` -- Creates a channel for the spawned task to send its result through.
- `pid = spawn fn() ...` -- Spawns a new green task that sends the value 42 on the channel. `spawn` returns a process identifier (PID), which is a handle to the running task.
- `mon = monitor(pid)` -- Sets up a monitor on the spawned task. `monitor` returns a channel. When the task identified by `pid` finishes (normally or abnormally), the runtime sends a status message on this channel.
- `result = receive(ch)` -- Blocks until the spawned task sends its value. Receives `42`.
- `status = receive(mon)` -- Blocks until the runtime reports the task's exit. This tells you whether the task finished normally or crashed.
- `print(result)` -- Prints `42`, the value the task computed.
- `print(status)` -- Prints the exit status. For a normal exit this is typically the task's return value or an indicator like `"normal"`.

**Key insight:** The monitor channel is separate from the data channel. The data channel carries your application values (`42`). The monitor channel carries lifecycle events from the runtime itself. You can have one without the other, but using both together gives you both the result and the guarantee that you know when the task is gone.

### Process linking and supervision

For fault-tolerant systems, you combine monitors with a loop that restarts failed tasks. This pattern -- called a **supervisor** -- is the backbone of Erlang-style reliability. Instead of trying to prevent every possible failure (which is impossible in distributed systems), you let tasks crash and automatically restart them.

```nova
fn worker(id, result_ch)
    // do some work
    send(result_ch, "worker {id} done")

fn supervisor()
    result_ch = channel()
    for i in 0..4
        pid = spawn fn()
            worker(i, result_ch)
        monitor(pid)

    // Collect results
    for i in 0..4
        print(receive(result_ch))
```

**Line-by-line breakdown:**

- `fn worker(id, result_ch)` -- Defines a worker function that takes an identifier and a channel to report results on.
- `send(result_ch, "worker {id} done")` -- The worker sends a string message back through the result channel. Note the string interpolation: `{id}` is replaced by the value of `id` at runtime. No prefix or dollar sign needed -- just curly braces inside a string.
- `fn supervisor()` -- Defines the supervisor function that manages workers.
- `result_ch = channel()` -- Creates a single shared channel. All workers send their results here.
- `for i in 0..4` -- Loops from 0 to 4 inclusive (five iterations: 0, 1, 2, 3, 4). This spawns five workers.
- `pid = spawn fn() ...` -- Each iteration spawns a new green task running the worker. The `spawn` returns a PID.
- `monitor(pid)` -- Sets up a monitor on each worker. If a worker crashes, the supervisor will be notified.
- `for i in 0..4` / `print(receive(result_ch))` -- Collects five results, one from each worker. Each `receive` blocks until a result arrives.

**What NOT to do -- forgetting to monitor:**

```nova
// WRONG: no monitors, no crash detection
fn fragile_supervisor()
    ch = channel()
    for i in 0..4
        spawn fn()
            worker(i, ch)
    // If worker 2 crashes, receive(ch) hangs forever
    // waiting for a message that will never come
    for i in 0..4
        print(receive(ch))      // blocks forever after crash
```

Without monitors, you have no way to detect that a worker crashed. The fourth `receive` call will block forever because only four messages will ever arrive (the crashed worker sent nothing). With monitors, you could detect the crash and either spawn a replacement or stop waiting.

**Real-world use case:** A web scraper with 100 concurrent fetch tasks. Some URLs will time out, some will return errors, some servers will drop the connection. With monitors, your coordinator task knows exactly which fetchers failed and can retry them or log the failure. Without monitors, you just see silence and have to guess.

### Timeouts

Use `recv_timeout` to avoid blocking forever. This is the single-channel version: wait up to N milliseconds for a message. If nothing arrives, it returns `null` instead of blocking.

```nova
ch = channel()

// Nobody will send on this channel
result = recv_timeout(ch, 1000)   // wait up to 1000ms
if result == null
    print("timed out after 1 second")
```

**Line-by-line breakdown:**

- `ch = channel()` -- Creates a channel. In this example, no task is sending on it, so any receive will wait forever -- unless we use a timeout.
- `result = recv_timeout(ch, 1000)` -- Waits for up to 1000 milliseconds (1 second) for a message on `ch`. If a message arrives within that window, `result` holds the message. If the deadline passes with no message, `result` is `null`.
- `if result == null` -- Checks whether we timed out. In NOVA, `null` is the sentinel for "nothing arrived."
- `print("timed out after 1 second")` -- Reports the timeout. In a real program, this is where you would retry, log an error, or take fallback action.

**Why timeouts matter:** In any networked or distributed system, the other side might be dead, unreachable, or just slow. Without timeouts, your program hangs indefinitely. Every `receive` in a production system should either have a timeout or be in a task with a monitor so that something, somewhere, can detect the stall.

**What NOT to do -- using `receive` without a timeout on external data:**

```nova
// WRONG: hangs forever if the remote service is down
response = receive(response_ch)
```

```nova
// RIGHT: bounded wait, then handle the failure
response = recv_timeout(response_ch, 5000)
if response == null
    print("service did not respond within 5 seconds")
    // retry, use cached data, or return an error to the user
```

### select with timeout

`select_timeout` extends the multi-channel `select` with a deadline. It waits on multiple channels simultaneously, returns the first message that arrives, or returns a timeout indicator if none arrives within the deadline.

```nova
ch1 = channel()
ch2 = channel()

result = select_timeout(ch1, ch2, 500)   // wait up to 500ms
if result[0] == -1
    print("no data on either channel within 500ms")
```

**Line-by-line breakdown:**

- `ch1 = channel()` / `ch2 = channel()` -- Creates two channels. In a real program these might carry responses from two different services.
- `result = select_timeout(ch1, ch2, 500)` -- Waits up to 500 milliseconds for a message on either channel. The last argument is always the timeout in milliseconds. All other arguments are channels to wait on. You can pass any number of channels.
- `result[0]` -- The index of the channel that produced data. `0` means `ch1` fired first, `1` means `ch2` fired first, `-1` means neither fired (timeout).
- `result[1]` -- The value that was received. If `result[0]` is `-1`, this value is `0` (no meaningful data).

**Practical example -- racing two services:**

```nova
fn fetch_from_primary(ch)
    sleep(200)                         // simulates network latency
    send(ch, "primary response")

fn fetch_from_backup(ch)
    sleep(800)                         // backup is slower
    send(ch, "backup response")

fn main()
    primary = channel()
    backup = channel()
    spawn fn()
        fetch_from_primary(primary)
    spawn fn()
        fetch_from_backup(backup)

    result = select_timeout(primary, backup, 1000)
    if result[0] == -1
        print("both services timed out")
    else if result[0] == 0
        print("got response from primary: {result[1]}")
    else
        print("got response from backup: {result[1]}")
```

This pattern -- called **hedged requests** -- is used by Google, Amazon, and other large-scale systems to reduce tail latency. You fire the same request at two servers and take whichever responds first. In NOVA, it is four lines of channel code.

---

## 19. Modules

### What is this?

As your NOVA programs grow beyond a single file, you need a way to organize code into separate units. NOVA's module system is deliberately simple: a module is just a `.nova` file, and `import` loads it. There is no `export` keyword, no `public`/`private` modifiers, no package manifests. Every top-level function in a module file is available to the importer.

This follows NOVA's principle of zero ceremony. In Python you write `import math` and use `math.sqrt`. In NOVA you write `import math_utils` and use `square(5)`. No prefixing, no aliasing, no boilerplate.

### Importing modules

```nova
import forge
import csvx
import bignum
```

**Line-by-line breakdown:**

- `import forge` -- Loads the file `forge.nova` and makes all of its top-level functions available in the current file. After this line, you can call functions like `forge.app()`, `forge.get()`, etc.
- `import csvx` -- Loads `csvx.nova`, a CSV (Comma-Separated Values) parser from the standard library.
- `import bignum` -- Loads `bignum.nova`, which provides arbitrary-precision integer arithmetic.

Each `import` is a single word -- the module name -- which maps directly to a file name. No paths, no version numbers, no curly braces.

### Module resolution

NOVA looks for modules in this order:

1. **Same directory** as the current file -- `import utils` looks for `utils.nova` in the same folder as the file containing the import.
2. **$NOVA_HOME/lib/** -- `import forge` looks for `$NOVA_HOME/lib/forge.nova`, where `$NOVA_HOME` is the directory where NOVA is installed.

This means you can create project-local modules by putting `.nova` files next to your main file, and use standard library modules by their name. Local files take priority: if you have a `forge.nova` in your project directory, it shadows the standard library's `forge.nova`.

**What NOT to do -- using file paths in import:**

```nova
// WRONG: import does not take a file path
import "../shared/utils.nova"

// WRONG: import does not take a URL
import "https://github.com/someone/novamod"

// RIGHT: import takes a bare module name
import utils
```

### Module files are just NOVA files

A module is just a `.nova` file. Any functions defined at the top level of the file become available to the importer. There is no special `export` keyword -- everything at the top level is public.

```nova
// math_utils.nova
fn square(x)
    x * x

fn cube(x)
    x * x * x
```

```nova
// main.nova
import math_utils

print(square(5))    // 25
print(cube(3))      // 27
```

**Line-by-line breakdown of main.nova:**

- `import math_utils` -- Loads `math_utils.nova` from the same directory. After this, `square` and `cube` are callable.
- `print(square(5))` -- Calls the `square` function from the imported module. No prefix needed. Prints `25`.
- `print(cube(3))` -- Calls the `cube` function. Prints `27`.

**How this compares to other languages:**

| Language | Import syntax | Export mechanism |
|----------|---------------|-----------------|
| Python | `import math` or `from math import sqrt` | Everything is public unless prefixed with `_` |
| Go | `import "fmt"` | Capitalized names are public |
| Rust | `use std::collections::HashMap` | `pub` keyword |
| Java | `import java.util.List` | `public`/`private`/`protected` |
| NOVA | `import math_utils` | Everything at top level is public |

NOVA's approach is the simplest: one keyword, one name, no access modifiers. This matches the "simpler than Python" goal.

### NOVA_HOME and the standard library

NOVA ships with a standard library in `$NOVA_HOME/lib/`. These modules are available with a simple `import`:

```nova
import forge           // web framework
import forge_crypto    // cryptographic functions (SHA, HMAC, AES, etc.)
import csvx            // CSV (Comma-Separated Values) parsing
import bignum          // arbitrary-precision integers
import complexnum      // complex numbers (a + bi)
import rational        // rational numbers (exact fractions)
import matrixx         // matrix operations
import prng            // PRNG (Pseudo-Random Number Generator) algorithms
import uuid            // UUID (Universally Unique Identifier) generation
import basex           // base encoding (base32, base58, etc.)
import bitset          // bit set operations
import strx            // extended string operations
import urlx            // URL (Uniform Resource Locator) parsing and encoding
import collx           // collection utilities
import corex           // core utilities
import getin           // nested data access
import setops          // set operations
import graphemex       // Unicode grapheme operations
import deflatex        // DEFLATE compression
import pvecx           // persistent vectors
```

**Distinction between built-in functions and module functions:** Many common operations in NOVA are built-in -- they work without any `import`. For example, `print`, `len`, `push`, `sha256`, `base64_encode`, `random_int`, `tcp_connect`, and all log functions are built-in. You only need `import` when using the standard library modules listed above, which provide more specialized functionality.

See [Appendix D](#appendix-d-standard-library-modules) for the complete module list.

---

## 20. Networking: TCP (Transmission Control Protocol) and UDP (User Datagram Protocol)

### What is this?

TCP and UDP are the two fundamental protocols that all internet communication is built on. Every web page, API (Application Programming Interface) call, database query, video stream, and online game uses one or both of them.

**TCP** provides reliable, ordered delivery. When you send data over TCP, the protocol guarantees it arrives, in order, without corruption. If a packet is lost, TCP retransmits it. The cost is overhead: connection setup takes a three-way handshake, and acknowledgments consume bandwidth. TCP is used for HTTP (Hypertext Transfer Protocol) web traffic, SMTP (Simple Mail Transfer Protocol) email, SSH (Secure Shell) sessions, database connections, and anything where correctness matters more than speed.

**UDP** provides fast, connectionless delivery. You send a packet (called a datagram) and it either arrives or it does not. No retransmission, no ordering guarantee, no connection setup. UDP is used for DNS (Domain Name System) lookups, video streaming, online games, and voice calls -- anywhere where speed matters more than guaranteed delivery.

NOVA provides built-in functions for both protocols. No `import` needed.

### TCP client/server

Here is a complete echo server and client. The server listens on a port, accepts one connection, reads the data, sends it back with an "ECHO:" prefix, and closes.

```nova
fn run_server(port)
    server = tcp_listen(port)
    print("Server listening on port {port}")
    client = tcp_accept(server)        // blocks until a client connects
    data = tcp_recv(client)            // read data from client
    tcp_send(client, "ECHO:" + data)   // send response
    tcp_close(client)
    tcp_close(server)

port = 19876

// Spawn server in a separate task
spawn fn()
    run_server(port)

// Give server time to start
sleep(100)

// Client connects
sock = tcp_connect("127.0.0.1", port)
tcp_send(sock, "hello")
reply = tcp_recv(sock)
tcp_close(sock)

print(reply)    // ECHO:hello
```

**Line-by-line breakdown:**

- `server = tcp_listen(port)` -- Binds to the given port number and starts listening for incoming TCP connections. Returns a listener handle. This does not accept a connection yet -- it just tells the OS (Operating System) "I want to receive connections on this port."
- `print("Server listening on port {port}")` -- Prints a status message. `{port}` is string interpolation -- replaced by the value of `port` at runtime.
- `client = tcp_accept(server)` -- Blocks (pauses execution) until a client connects. When a client connects, returns a connection handle. This handle represents the two-way communication pipe between the server and that specific client.
- `data = tcp_recv(client)` -- Reads data from the client connection. Blocks until the client sends something. Returns the data as a string.
- `tcp_send(client, "ECHO:" + data)` -- Sends a response back to the client. String concatenation with `+` prepends "ECHO:" to the data.
- `tcp_close(client)` -- Closes the client connection, freeing the OS socket.
- `tcp_close(server)` -- Closes the listener, stopping the server from accepting new connections.
- `spawn fn() run_server(port)` -- Runs the server in a separate green task. Without `spawn`, the server's `tcp_accept` would block and the client code below would never run.
- `sleep(100)` -- Waits 100 milliseconds to give the server task time to call `tcp_listen` and `tcp_accept`. Without this, the client might try to connect before the server is listening.
- `sock = tcp_connect("127.0.0.1", port)` -- Connects to the server. `"127.0.0.1"` is the loopback address (this machine). Returns a connection handle.
- `tcp_send(sock, "hello")` -- Sends the string "hello" to the server.
- `reply = tcp_recv(sock)` -- Reads the server's response. Blocks until data arrives.
- `tcp_close(sock)` -- Closes the client's connection.
- `print(reply)` -- Prints `ECHO:hello`.

### TCP API

| Function | Description |
|----------|-------------|
| `tcp_listen(port)` | Start listening on a port, returns a listener handle |
| `tcp_accept(listener)` | Block until a client connects, returns a connection handle |
| `tcp_connect(host, port)` | Connect to a remote host and port, returns a connection handle |
| `tcp_send(conn, data)` | Send a string over the connection |
| `tcp_recv(conn)` | Receive a string from the connection (blocks until data arrives) |
| `tcp_send_bytes(conn, bytes)` | Send raw bytes (for binary protocols) |
| `tcp_recv_bytes(conn)` | Receive raw bytes |
| `tcp_close(conn)` | Close the connection and release the OS socket |

### UDP

UDP is simpler than TCP because there is no connection. You just bind a socket and send/receive individual datagrams.

```nova
// Server: bind to a port and wait for a datagram
sock = udp_bind(9999)
data = udp_recv(sock)
print("received: {data}")

// Client: send a datagram to a host and port
udp_send("127.0.0.1", 9999, "hello via UDP")
```

**Line-by-line breakdown:**

- `sock = udp_bind(9999)` -- Binds a UDP socket to port 9999. Unlike TCP's `tcp_listen`, this does not create a "listener" waiting for connections. It creates a socket that can send and receive individual datagrams on that port.
- `data = udp_recv(sock)` -- Waits for a datagram to arrive. Unlike TCP, each `udp_recv` returns one complete datagram (not a stream of bytes).
- `udp_send("127.0.0.1", 9999, "hello via UDP")` -- Sends a single datagram to the target host and port. No connection needed -- just fire and forget.

**When to use UDP vs. TCP:**

| Use TCP when... | Use UDP when... |
|-----------------|-----------------|
| Data must arrive completely and in order | Speed matters more than reliability |
| You are building a web server or API | You are sending metrics, logs, or pings |
| You need a persistent connection (WebSocket, database) | Each message is independent |
| Retransmission of lost data is essential | Retransmitting old data is worse than skipping it |

### Green-aware networking

TCP operations (`tcp_accept`, `tcp_recv`, `tcp_connect`) are green-task-aware. When a green task calls `tcp_recv`, it does not block the entire OS thread. Instead, it parks on the scheduler's netpoller (using `epoll` on Linux, `WSAPoll` on Windows) and yields control to other green tasks. When data arrives on the socket, the netpoller wakes the parked task automatically.

This is the same architecture used by Go's goroutines, Erlang's processes, and Node.js's event loop -- but in NOVA it happens transparently. You write blocking-looking code, and the runtime turns it into non-blocking I/O (Input/Output) behind the scenes.

This means you can handle thousands of concurrent connections with just a few OS threads:

```nova
fn handle_client(conn)
    loop
        data = tcp_recv(conn)
        if len(data) == 0
            break
        tcp_send(conn, "ECHO:" + data)
    tcp_close(conn)

fn main()
    server = tcp_listen(8080)
    loop
        conn = tcp_accept(server)
        spawn fn()
            handle_client(conn)
```

**Line-by-line breakdown:**

- `fn handle_client(conn)` -- Defines a function that handles one client connection. Each client gets its own call to this function, running in its own green task.
- `loop` -- Infinite loop. The client handler keeps reading and echoing until the client disconnects.
- `data = tcp_recv(conn)` -- Reads data from the client. This call looks like it blocks, but under the hood the green task parks on the netpoller. Other tasks run while this task waits.
- `if len(data) == 0` / `break` -- When the client disconnects, `tcp_recv` returns an empty string. The handler breaks out of the loop.
- `tcp_send(conn, "ECHO:" + data)` -- Echoes the data back.
- `tcp_close(conn)` -- Cleans up the socket after the client disconnects.
- `server = tcp_listen(8080)` -- Starts listening on port 8080.
- `conn = tcp_accept(server)` -- Waits for the next client. Also parks on the netpoller.
- `spawn fn() handle_client(conn)` -- Spawns a new green task for each client. Green tasks use about 32KB of stack each, so 10,000 concurrent clients use roughly 320MB -- well within reach of any modern server.

**What NOT to do -- handling clients sequentially:**

```nova
// WRONG: only one client at a time
fn main()
    server = tcp_listen(8080)
    loop
        conn = tcp_accept(server)
        handle_client(conn)        // blocks until this client disconnects
        // next client cannot connect until the current one is done
```

Without `spawn`, each client is handled one at a time. The second client has to wait until the first disconnects. Always spawn a new task per client.

---

## 21. HTTP (Hypertext Transfer Protocol) client

### What is this?

HTTP is the protocol that powers the World Wide Web. Every time you visit a website, call a REST API (Representational State Transfer Application Programming Interface), or download a file, your browser or program sends an HTTP request and receives an HTTP response. The two most common request types are:

- **GET** -- Retrieves data. "Give me the user list." No request body.
- **POST** -- Sends data. "Create this new user." Includes a body (typically JSON -- JavaScript Object Notation).

NOVA provides built-in `http_get` and `http_post` functions for making outbound HTTP requests. No `import` needed. These are high-level convenience functions for the most common case: fetch data from a URL and get the response body as a string.

For building HTTP servers (handling incoming requests), use the Forge web framework (Section 25).

### Making HTTP requests

```nova
// GET request
response = http_get("http://example.com/api/users")
print(response)

// POST request
body = json_encode({"name": "Alice", "age": 30})
response = http_post("http://example.com/api/users", body)
print(response)
```

**Line-by-line breakdown:**

- `response = http_get("http://example.com/api/users")` -- Sends an HTTP GET request to the given URL. Blocks until the response arrives. Returns the response body as a string. If the server returns JSON, `response` will be a string containing JSON text.
- `print(response)` -- Prints the response body. For a JSON API this might look like `[{"name":"Alice"},{"name":"Bob"}]`.
- `body = json_encode({"name": "Alice", "age": 30})` -- Converts a NOVA dict (dictionary) into a JSON string. `json_encode` serializes the dict's key-value pairs into standard JSON format. The result is something like `{"name":"Alice","age":30}`.
- `response = http_post("http://example.com/api/users", body)` -- Sends an HTTP POST request with the JSON string as the request body. The server receives this data and (typically) creates a new resource.

**What NOT to do -- confusing json_encode with string interpolation:**

```nova
// WRONG: this sends a NOVA string representation, not valid JSON
body = str({"name": "Alice"})
response = http_post(url, body)

// RIGHT: use json_encode for proper JSON serialization
body = json_encode({"name": "Alice"})
response = http_post(url, body)
```

`str()` converts a value to its NOVA string representation, which may not be valid JSON. `json_encode` produces standards-compliant JSON text that any server will accept.

### Self-contained example (loopback test)

This example starts a local HTTP server and then connects to it with `http_get`, so you can run it without any external network:

```nova
fn main()
    // Spawn a local HTTP server
    spawn fn()
        sock = http_listen(18080)
        conn = http_accept_raw(sock)
        if len(conn) > 0
            client = conn[0]
            http_send_raw(client, "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 11\r\nConnection: close\r\n\r\nhello-nova!")

    sleep(800)    // wait for server to start

    // Fetch from our own server
    resp = http_get("http://127.0.0.1:18080/")
    print(resp)   // hello-nova!
```

**Line-by-line breakdown:**

- `spawn fn()` -- Runs the server in a green task so the client code below can execute concurrently.
- `sock = http_listen(18080)` -- Starts an HTTP listener on port 18080. This is the low-level API; for real servers, use Forge.
- `conn = http_accept_raw(sock)` -- Accepts a raw connection. Returns a list of connection handles.
- `if len(conn) > 0` -- Checks that at least one client connected.
- `client = conn[0]` -- Gets the first (and only) connection handle.
- `http_send_raw(client, "HTTP/1.1 200 OK\r\n...")` -- Sends a raw HTTP response. The `\r\n` sequences are CRLF (Carriage Return Line Feed) line endings, which HTTP requires. The headers specify the content type (plain text), content length (11 bytes for "hello-nova!"), and that the connection should close after the response.
- `sleep(800)` -- Waits 800 milliseconds for the server to start. In production code you would use a channel to signal readiness instead of a fixed sleep.
- `resp = http_get("http://127.0.0.1:18080/")` -- The client sends a GET request to the server running on localhost.
- `print(resp)` -- Prints `hello-nova!`.

**Real-world use case:** This loopback pattern is how you write integration tests for your API. Spawn the server, send real HTTP requests, and verify the responses -- all in one test file, no external tools needed.

For building HTTP servers with routing, middleware, JSON serialization, database access, and all the features you need for production APIs, use [Forge](#25-forge-building-a-rest-api) instead of raw HTTP functions.

---

## 22. Cryptography and encoding

### What is this?

Cryptography is the science of protecting information. Encoding is the science of representing information in different formats. They are often confused but serve different purposes:

- **Cryptography** makes data unreadable to anyone without the key. Examples: hashing passwords, signing messages, encrypting network traffic.
- **Encoding** changes the format of data without any secrecy. Examples: converting binary data to text (Base64), representing bytes as hexadecimal, making strings safe for URLs.

NOVA provides both categories as built-in functions (no `import` needed for the common ones) and as the `forge_crypto` module (for advanced cryptographic operations).

### Hashing -- turning data into a fixed-size fingerprint

A **hash function** takes input of any length and produces a fixed-size output (called a digest or hash). The key properties are:

1. **Deterministic** -- the same input always produces the same hash.
2. **One-way** -- you cannot reverse a hash to get the original input.
3. **Avalanche effect** -- changing one bit of input completely changes the hash.
4. **Collision-resistant** -- it is practically impossible to find two different inputs with the same hash.

Hashing is used for password storage (store the hash, not the password), data integrity checks (did the file change?), and digital signatures.

#### Cryptographic hashes (secure, slower)

The `sha256` function is built-in and returns the hex-encoded hash:

```nova
hash = sha256("hello")
print(hash)   // 2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824
```

**Line-by-line breakdown:**

- `hash = sha256("hello")` -- Computes the SHA-256 (Secure Hash Algorithm, 256-bit) digest of the string "hello". SHA-256 is part of the SHA-2 family designed by the NSA (National Security Agency) and published by NIST (National Institute of Standards and Technology). It produces a 256-bit (32-byte) digest, represented here as 64 hexadecimal characters.
- `print(hash)` -- Prints the hex string. Every time you hash "hello" with SHA-256, you get this exact string. Change even one character (say, "Hello" with a capital H) and the hash changes completely.

The `forge_crypto` module provides additional hash functions for advanced use:

```nova
import forge_crypto

// SHA-256 of the empty string (standard NIST test vector)
hash = sha256_hex("")
print(hash)   // e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855

// SHA-256 of byte arrays (for binary data)
data = str_to_bytes("hello")
hash = sha256_of_bytes(data)
```

**Line-by-line breakdown:**

- `import forge_crypto` -- Loads the cryptographic module, which provides `sha256_hex`, `sha256_of_bytes`, and other functions that operate on byte arrays rather than strings.
- `sha256_hex("")` -- Hashes the empty string. The result is a well-known constant used as a test vector in the NIST FIPS-180 (Federal Information Processing Standard) specification. If your SHA-256 implementation produces this exact hash for the empty string, it is almost certainly correct.
- `str_to_bytes("hello")` -- Converts a string to a list of byte values. Needed when hashing binary data that is not valid text.
- `sha256_of_bytes(data)` -- Hashes the byte array.

**When to use which hash:**
- Use `sha256(s)` for quick hashing of strings (passwords, checksums, identifiers).
- Use `sha256_hex(s)` or `sha256_of_bytes(b)` from `forge_crypto` when you need to work with byte arrays or need the full `forge_crypto` pipeline (HMAC, key derivation, etc.).

#### Non-cryptographic hashes (fast, not secure)

For hash tables, checksums, and data structures where speed matters more than security, NOVA provides fast built-in hash functions:

```nova
print(hash("hello"))          // integer hash value (fast, general-purpose)
print(fnv1a("hello"))         // FNV-1a (Fowler-Noll-Vo) hash
print(murmur3("hello", 0))   // MurmurHash3 (with seed 0)
print(crc32("hello"))         // CRC-32 (Cyclic Redundancy Check) checksum
```

**Line-by-line breakdown:**

- `hash("hello")` -- NOVA's built-in general-purpose hash. Returns an integer. Fast, but not cryptographically secure -- do not use it for passwords or security tokens.
- `fnv1a("hello")` -- The FNV-1a hash (Fowler-Noll-Vo, version 1a). A simple, fast hash commonly used for hash tables. Returns an integer.
- `murmur3("hello", 0)` -- MurmurHash3, a fast hash with a seed parameter. The second argument is the seed -- using different seeds produces different hashes of the same input. Returns an integer.
- `crc32("hello")` -- CRC-32 (Cyclic Redundancy Check, 32-bit). Not a hash function in the cryptographic sense -- it is a checksum designed to detect accidental data corruption (bit flips, truncation). Used in ZIP files, PNG (Portable Network Graphics) images, Ethernet frames, and many file formats.

**What NOT to do -- using non-cryptographic hashes for security:**

```nova
// WRONG: CRC-32 is trivially reversible, not a secure hash
password_hash = crc32(user_password)     // an attacker can find collisions

// WRONG: fnv1a is fast to brute-force
token = fnv1a(secret_key)               // brute-forceable in seconds

// RIGHT: use SHA-256 for anything security-sensitive
password_hash = sha256(user_password + salt)
```

Non-cryptographic hashes are designed for speed, not resistance to deliberate attacks. An attacker can find CRC-32 collisions in milliseconds. SHA-256 collisions would take longer than the age of the universe.

### HMAC (Hash-based Message Authentication Code)

HMAC answers the question: "Was this message sent by someone who knows the secret key, and has it been tampered with?" It combines a hash function with a secret key to produce a tag that can only be verified by someone with the same key.

Use case: API authentication. A server gives you a secret key. When you send a request, you compute `HMAC(key, request_body)` and include the result in a header. The server computes the same HMAC and checks if they match. If they do, the server knows the request came from you and was not modified in transit.

```nova
// Built-in HMAC-SHA256
mac = hmac_sha256("secret-key", "message to authenticate")
print(mac)    // hex-encoded MAC (Message Authentication Code)
```

**Line-by-line breakdown:**

- `mac = hmac_sha256("secret-key", "message to authenticate")` -- Computes an HMAC using SHA-256 as the underlying hash function. The first argument is the secret key (known only to the sender and receiver). The second is the message to authenticate. Returns the MAC as a hex-encoded string.

For byte-level HMAC operations (needed for JWT -- JSON Web Token -- signing, TLS -- Transport Layer Security -- key derivation, and other protocols), use the `forge_crypto` module:

```nova
import forge_crypto

// HMAC-SHA256 operating on byte lists (RFC 4231 compatible)
key_bytes = str_to_blist("Jefe")
msg_bytes = str_to_blist("what do ya want for nothing?")
mac = hex_of(hmac_sha256_bytes(key_bytes, msg_bytes))
print(mac)    // 5bdcc146bf60754e6a042426089575c75a003f089d2739839dec58b964ec3843
```

**Line-by-line breakdown:**

- `str_to_blist("Jefe")` -- Converts the string "Jefe" to a list of byte values (integer list). Byte-level functions operate on lists of integers (0-255), not strings.
- `hmac_sha256_bytes(key_bytes, msg_bytes)` -- Computes HMAC-SHA256 on raw byte lists. Returns a byte list (not a hex string).
- `hex_of(...)` -- Converts a byte list to its hex string representation.
- The output matches RFC (Request for Comments) 4231 test case 2 exactly, which serves as a correctness proof.

### Base64 encoding/decoding

Base64 converts binary data into text using 64 printable ASCII (American Standard Code for Information Interchange) characters (A-Z, a-z, 0-9, +, /). This is how binary data (images, encrypted blobs, certificates) is embedded in text-only formats like JSON, XML (Extensible Markup Language), email, and HTTP headers.

```nova
encoded = base64_encode("Hello, NOVA!")
print(encoded)                // SGVsbG8sIE5PVkEh

decoded = base64_decode(encoded)
print(decoded)                // Hello, NOVA!
```

**Line-by-line breakdown:**

- `encoded = base64_encode("Hello, NOVA!")` -- Converts the 12-byte string into a Base64-encoded string. Every 3 bytes of input become 4 characters of output. "Hel" becomes "SGVs", "lo," becomes "bG8s", and so on. The result `SGVsbG8sIE5PVkEh` is safe to include in JSON, HTTP headers, or any text format.
- `decoded = base64_decode(encoded)` -- Converts the Base64 string back to the original bytes. Reversible -- `base64_decode(base64_encode(x))` always equals `x`.

**When to use Base64:**
- Embedding binary data (images, files) in JSON API responses.
- Encoding authentication credentials in HTTP headers (`Authorization: Basic ...` uses Base64).
- Encoding cryptographic keys and certificates in PEM (Privacy-Enhanced Mail) format.

**What NOT to do -- using Base64 for security:**

```nova
// WRONG: Base64 is encoding, not encryption
secret = base64_encode("my-password")   // anyone can decode this

// RIGHT: Base64 is for format conversion, not secrecy
api_key_header = base64_encode(username + ":" + password)
// This is the HTTP Basic Auth format -- the security comes
// from HTTPS encrypting the transport, not from Base64
```

Base64 is a reversible encoding, not encryption. Anyone can decode a Base64 string. It provides zero secrecy.

### Hex encoding/decoding

Hex (hexadecimal) encoding represents each byte as two characters (0-9, a-f). It is used for displaying binary data, hash digests, memory addresses, and color codes.

```nova
encoded = hex_encode("Hello")
print(encoded)                // 48656c6c6f

decoded = hex_decode(encoded)
print(decoded)                // Hello
```

**Line-by-line breakdown:**

- `hex_encode("Hello")` -- Converts each byte of "Hello" into two hex characters. The ASCII value of 'H' is 72, which is `48` in hexadecimal. 'e' is 101 = `65`, 'l' is 108 = `6c`, 'o' is 111 = `6f`. Result: `48656c6c6f`.
- `hex_decode(encoded)` -- Converts the hex string back to the original bytes. Every two hex characters become one byte.

**Hex vs. Base64:**

| Property | Hex | Base64 |
|----------|-----|--------|
| Characters used | 0-9, a-f (16) | A-Z, a-z, 0-9, +, / (64) |
| Size overhead | 2x (1 byte becomes 2 chars) | 1.33x (3 bytes become 4 chars) |
| Human readability | Easy to read byte values | Not human-readable |
| Common uses | Hash digests, debugging, color codes | Embedding binary in text, HTTP auth |

Use hex when you want to inspect individual bytes. Use Base64 when you want compact text representation.

### URL (Uniform Resource Locator) encoding/decoding

URLs can only contain certain characters safely. Characters like spaces, ampersands, equals signs, and non-ASCII characters must be encoded using percent-encoding (`%XX` where XX is the hex value of the byte). NOVA provides built-in functions for this:

```nova
encoded = url_encode("hello world&foo=bar")
print(encoded)                // hello+world%26foo%3Dbar

decoded = url_decode(encoded)
print(decoded)                // hello world&foo=bar
```

**Line-by-line breakdown:**

- `url_encode("hello world&foo=bar")` -- Encodes special characters for safe inclusion in a URL. Spaces become `+`, the `&` character becomes `%26` (hex 26 = decimal 38, the ASCII code for `&`), and `=` becomes `%3D` (hex 3D = decimal 61).
- `url_decode(encoded)` -- Reverses the encoding. `+` becomes a space, `%26` becomes `&`, etc.

**When you need URL encoding:**
- Building query strings: `http://example.com/search?q=hello+world`
- Sending form data in POST requests
- Any time user input appears in a URL (search terms, names with spaces, international characters)

### Random values

NOVA provides both general-purpose random numbers and cryptographically secure random bytes.

```nova
// Random integer in range (inclusive on both ends)
n = random_int(1, 100)
print(n)                      // random number between 1 and 100

// Random float between 0.0 and 1.0
f = random_float()
print(f)                      // 0.7234... (example)

// Cryptographically secure random bytes
data = secure_bytes(32)       // 32 random bytes
```

**Line-by-line breakdown:**

- `random_int(1, 100)` -- Returns a pseudo-random integer between 1 and 100, inclusive. Uses a fast PRNG (Pseudo-Random Number Generator). Good enough for games, simulations, and randomized algorithms. NOT suitable for cryptographic keys or tokens.
- `random_float()` -- Returns a pseudo-random floating-point number in the range [0.0, 1.0). Useful for probabilities, Monte Carlo simulations, and random sampling.
- `secure_bytes(32)` -- Returns 32 cryptographically secure random bytes. Uses the OS's secure random source (`CryptGenRandom` on Windows, `/dev/urandom` on Linux). Suitable for generating encryption keys, session tokens, nonces, and anything where predictability would be a security vulnerability.

**What NOT to do -- using random_int for security tokens:**

```nova
// WRONG: pseudo-random, predictable if the seed is known
session_id = str(random_int(0, 999999999))

// WRONG: random_bytes is not cryptographically secure
token_bytes = random_bytes(32)

// RIGHT: cryptographically secure random, unpredictable
token_data = secure_bytes(32)
session_id = hex_encode(str(token_data))    // 64-char hex token
```

`random_int` uses a fast PRNG that is deterministic given the seed. An attacker who can guess the seed (or observe enough outputs) can predict future values. `secure_bytes` uses hardware-backed entropy and is unpredictable by design.

### UUID (Universally Unique Identifier) generation

A UUID is a 128-bit identifier formatted as 32 hex digits in 5 groups separated by hyphens (e.g., `550e8400-e29b-41d4-a716-446655440000`). UUIDs are designed so that anyone, anywhere, can generate one without coordination and it will be unique. They are used as database primary keys, session identifiers, file names, and request correlation IDs.

```nova
id = uuid4()
print(id)    // e.g., "550e8400-e29b-41d4-a716-446655440000"
```

**Line-by-line breakdown:**

- `uuid4()` -- Generates a version 4 UUID, which is based on random numbers. The "4" indicates this variant: 122 of the 128 bits are random, and the remaining 6 bits encode the version (4) and variant (RFC 4122). The probability of generating two identical UUID4 values is approximately 1 in 5.3 x 10^36 -- for practical purposes, impossible.
- The result is a 36-character string: 32 hex digits plus 4 hyphens, in the format `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx` where `y` is one of `8`, `9`, `a`, or `b`.

---

## 23. System and environment

### What is this?

Every program runs inside an operating system. It receives command-line arguments, reads environment variables, interacts with the file system, and can launch other programs. NOVA provides built-in functions for all of these system interactions -- no `import` needed.

These functions are the bridge between your NOVA code and the world outside it: the shell, the OS, the hardware, and other programs.

### Command-line arguments

When you run a NOVA program from the terminal, any words after the file name become command-line arguments. The `args()` function returns them as a list of strings.

```nova
// Run with: nova run script.nova arg1 arg2 arg3
arguments = args()
print(arguments)       // ["script.nova", "arg1", "arg2", "arg3"]
print(arguments[1])    // arg1
```

**Line-by-line breakdown:**

- `arguments = args()` -- Returns a list of all command-line arguments. The first element (`arguments[0]`) is the script name itself. The remaining elements are the arguments passed by the user.
- `print(arguments)` -- Prints the entire list. NOVA prints lists in bracket notation.
- `print(arguments[1])` -- Accesses the second element (index 1), which is the first user-provided argument. Prints `arg1`.

**Real-world use case -- a simple CLI (Command-Line Interface) tool:**

```nova
fn main()
    a = args()
    if len(a) < 2
        print("Usage: nova run tool.nova <filename>")
        exit(1)
    filename = a[1]
    content = read_file(filename)
    print("File has {len(content)} characters")
```

This pattern -- check arguments, show usage if missing, exit with a non-zero code on error -- is the standard way to write command-line tools in any language.

### Environment variables

Environment variables are key-value pairs set by the OS or the user. They configure program behavior without changing code. Common examples: `PATH` (where to find executables), `HOME` (user's home directory), `DATABASE_URL` (database connection string).

```nova
// Read an environment variable
home = env("HOME")
print(home)            // /home/user (or C:\Users\user on Windows)

// Set an environment variable (for the current process only)
set_env("MY_VAR", "hello")
print(env("MY_VAR"))   // hello
```

**Line-by-line breakdown:**

- `env("HOME")` -- Reads the value of the environment variable `HOME`. If the variable is not set, returns an empty string `""`.
- `set_env("MY_VAR", "hello")` -- Sets the environment variable `MY_VAR` to `"hello"` for the current process. This does NOT affect the parent shell or other processes -- it only exists for the lifetime of this program. Returns `1` on success.
- `env("MY_VAR")` -- Reads back the variable we just set. Returns `"hello"`.

**What NOT to do -- hardcoding configuration:**

```nova
// WRONG: hardcoded database URL
db_url = "postgres://localhost:5432/mydb"

// RIGHT: configurable via environment variable
db_url = env("DATABASE_URL")
if len(db_url) == 0
    db_url = "postgres://localhost:5432/mydb"   // default for development
```

Environment variables let operators change configuration without recompiling. This is the standard pattern for 12-factor apps, Docker containers, and CI/CD (Continuous Integration / Continuous Deployment) systems.

### System information

NOVA provides functions to query the current system:

```nova
print(os_name())       // "windows" or "linux" or "macos"
print(arch_name())     // "x86_64" or "arm64"
print(hostname())      // your computer's hostname
print(getpid())        // current PID (Process Identifier)
print(cpu_count())     // number of CPU (Central Processing Unit) cores
print(temp_dir())      // temporary directory path
print(self_exe_path()) // absolute path to the current executable
print(cwd())           // current working directory
```

**Line-by-line breakdown:**

- `os_name()` -- Returns the name of the operating system as a lowercase string. Use this for platform-specific behavior: `"windows"`, `"linux"`, or `"macos"`.
- `arch_name()` -- Returns the CPU architecture. Common values: `"x86_64"` (64-bit Intel/AMD) or `"arm64"` (64-bit ARM, used by Apple Silicon and many servers).
- `hostname()` -- Returns the machine's network hostname. Useful for logging and identifying which server is running the code.
- `getpid()` -- Returns the PID of the current OS process. Every running program has a unique PID assigned by the OS. Useful for logging, creating unique temp files, and process management.
- `cpu_count()` -- Returns the number of CPU cores available. Useful for deciding how many worker tasks to spawn.
- `temp_dir()` -- Returns the system's temporary directory (`C:\Users\<name>\AppData\Local\Temp` on Windows, `/tmp` on Linux). Use this for temporary files instead of hardcoding paths.
- `self_exe_path()` -- Returns the absolute path to the currently running executable. Useful for finding resources relative to the program's installation directory.
- `cwd()` -- Returns the current working directory. This is the directory from which the program was launched.

**Practical example -- platform-specific behavior:**

```nova
fn get_config_dir()
    if os_name() == "windows"
        return env("APPDATA") + "\\myapp"
    return env("HOME") + "/.config/myapp"
```

Unlike C's `#ifdef _WIN32` preprocessor directives, NOVA's `if os_name() == "windows"` is a runtime check -- both branches are type-checked by the compiler, so you catch errors on all platforms, not just the one you are building on.

### Running external commands

NOVA provides three ways to run external commands, each for different use cases:

```nova
// exec: run a command and capture its output as a string
output = exec("echo hello")
print(output)          // hello

// system: run a command and get its exit code (0 = success)
result = system("git status")
print(result)          // 0 (if git succeeded)

// shell: run a command through the shell and capture output
output = shell("echo hello")
print(output)          // hello
```

**Line-by-line breakdown:**

- `exec("echo hello")` -- Runs the command and returns its standard output as a string. Use this when you need to capture and process the command's output.
- `system("git status")` -- Runs the command and returns its exit code as an integer. `0` means success, non-zero means failure. Use this when you only care whether the command succeeded, not what it printed.
- `shell("echo hello")` -- Similar to `exec`, runs the command through the system shell and returns its output. Use this for commands that need shell features like pipes, redirection, or globbing.

**When to use which:**

| Function | Returns | Use when... |
|----------|---------|-------------|
| `exec(cmd)` | Output string | You need to read the command's output |
| `system(cmd)` | Exit code (int) | You only need success/failure |
| `shell(cmd)` | Output string | You need shell features (pipes, globbing) |

### Process management

For full control over subprocesses -- including writing to their standard input (stdin) and reading their standard output (stdout) incrementally -- use the process management functions:

```nova
// Open a subprocess
proc = proc_open("cmd /c echo hello from subprocess")
output = proc_read_stdout(proc)
exit_code = proc_wait(proc)
print(output)           // hello from subprocess
print(exit_code)        // 0
```

**Line-by-line breakdown:**

- `proc = proc_open("cmd /c echo hello from subprocess")` -- Launches a subprocess with the given command string. Returns a process handle (an integer). The subprocess runs concurrently with your NOVA program. On Windows, `cmd /c` runs a command through the Windows command interpreter.
- `output = proc_read_stdout(proc)` -- Reads a chunk of output from the subprocess's stdout. Returns an empty string when there is no more output.
- `exit_code = proc_wait(proc)` -- Waits for the subprocess to finish and returns its exit code. `0` means success.

**Advanced: writing to a subprocess's stdin:**

```nova
fn main()
    proc = proc_open("cmd /c sort")
    proc_write_stdin(proc, "banana\r\n")
    proc_write_stdin(proc, "apple\r\n")
    proc_write_stdin(proc, "cherry\r\n")
    proc_close_stdin(proc)              // signal end of input
    output = proc_read_stdout(proc)
    code = proc_wait(proc)
    print(output)                       // apple\r\nbanana\r\ncherry
```

**Line-by-line breakdown:**

- `proc_open("cmd /c sort")` -- Launches the `sort` command, which reads lines from stdin and outputs them sorted.
- `proc_write_stdin(proc, "banana\r\n")` -- Writes "banana" followed by a CRLF (Carriage Return Line Feed) line ending to the subprocess's stdin. The subprocess receives this as one line of input.
- `proc_close_stdin(proc)` -- Closes the stdin pipe, signaling to the subprocess that there is no more input. Many programs (like `sort`) wait for all input before producing output, so this step is essential.
- `proc_read_stdout(proc)` -- Reads the sorted output.
- `proc_wait(proc)` -- Waits for the process to exit and gets its exit code.

**What NOT to do -- forgetting to close stdin:**

```nova
// WRONG: sort waits forever for more input
proc = proc_open("cmd /c sort")
proc_write_stdin(proc, "banana\r\n")
proc_write_stdin(proc, "apple\r\n")
// forgot proc_close_stdin(proc)
output = proc_read_stdout(proc)     // hangs forever
```

If you write to a subprocess's stdin but never close it, the subprocess may wait indefinitely for more input. Always call `proc_close_stdin` when you are done writing.

### Exit

To terminate the program immediately with a specific exit code:

```nova
if critical_error
    print("Fatal error!")
    exit(1)    // exit with non-zero status code
```

**Line-by-line breakdown:**

- `exit(1)` -- Terminates the program immediately with exit code 1. By convention, exit code 0 means success and any non-zero code means failure. The specific non-zero value can indicate what went wrong (e.g., 1 = general error, 2 = invalid arguments). The parent process (shell, CI system, supervisor) reads this code to determine whether the program succeeded.

Exit codes are how programs communicate success or failure to the outside world. CI/CD pipelines, shell scripts with `set -e`, and supervisor systems all check exit codes. Always exit with 0 on success and non-zero on failure.

---

## 24. Logging

### What is this?

Logging is how programs record what they are doing. Unlike `print`, which is for user-facing output, logs are for developers and operators who need to understand what happened when something goes wrong at 3 AM.

Good logging tells you: what happened, when it happened, how severe it was, and what context surrounds it. Bad logging is either silent (nothing recorded) or noisy (everything recorded at the same level, so the critical error message is buried in a million "request handled" lines).

NOVA provides a built-in structured logging system with six severity levels. All log functions are built-in -- no `import` needed. Logs are emitted to stdout (standard output) for INFO and below, and to stderr (standard error) for WARN and above, with automatic timestamps.

### Log levels

NOVA has six log levels, ordered from least to most severe:

| Level | Numeric value | Purpose | Example |
|-------|---------------|---------|---------|
| TRACE | 0 | Extremely detailed diagnostic info | "Entering function parse_request" |
| DEBUG | 1 | Information useful during development | "Cache miss for key user:42" |
| INFO | 2 | Normal operational events | "Server started on port 8080" |
| WARN | 3 | Something unusual that might indicate a problem | "Request took 5200ms (threshold: 1000ms)" |
| ERROR | 4 | Something went wrong but the program can continue | "Failed to send email: connection refused" |
| FATAL | 5 | Critical failure, program cannot continue | "Database connection lost, shutting down" |

Each log function takes two arguments: a message string and a fields value (typically a dict for structured key-value data, or `{}` for no extra fields):

```nova
log_trace("entering request handler", {})
log_debug("cache lookup", {"key": "user:42"})
log_info("server started", {"port": 8080})
log_warn("slow request", {"elapsed_ms": 5200})
log_error("email send failed", {"error": "connection refused"})
log_fatal("database lost", {"host": "db.example.com"})
```

**Line-by-line breakdown:**

- `log_trace("entering request handler", {})` -- Logs a TRACE-level message with no extra fields. The second argument `{}` is an empty dict. TRACE messages are only visible when the log level is set to 0 (TRACE). In production, you almost never want TRACE enabled -- it generates enormous volumes of output.
- `log_debug("cache lookup", {"key": "user:42"})` -- Logs a DEBUG-level message with a structured field. The dict `{"key": "user:42"}` adds a key-value pair to the log line. Structured fields are machine-parseable -- log aggregation tools (Elasticsearch, Splunk, Grafana Loki) can filter and search by these fields.
- `log_info("server started", {"port": 8080})` -- Logs an INFO-level message. This is the default minimum level. INFO messages record normal milestones: server started, request handled, job completed.
- `log_warn("slow request", {"elapsed_ms": 5200})` -- Logs a WARN-level message. Warnings indicate something unexpected that does not stop the program but might need attention. WARN and above go to stderr, not stdout, so they are visually separated from normal output.
- `log_error("email send failed", {"error": "connection refused"})` -- Logs an ERROR-level message. Errors mean something went wrong but the program is still running. The request failed, but the server is still serving other requests.
- `log_fatal("database lost", {"host": "db.example.com"})` -- Logs a FATAL-level message and then terminates the program via a panic. Use FATAL only for unrecoverable situations where continuing would cause data corruption or security issues.

**Output format (human-readable mode):**

```
[INFO] 2026-06-28T14:30:00Z server started port=8080
[WARN] 2026-06-28T14:30:01Z slow request elapsed_ms=5200
```

Each line includes: the severity level in brackets, a timestamp, the message, and any structured fields as `key=value` pairs.

**What NOT to do -- using print instead of log functions:**

```nova
// WRONG: no severity, no timestamp, no structured fields, no filtering
print("ERROR: email send failed, error=connection refused")

// RIGHT: structured, filterable, timestamped, goes to stderr
log_error("email send failed", {"error": "connection refused"})
```

With `print`, every message goes to stdout at the same "level." There is no way to filter out noise, no way to route errors to a different stream, and no automatic timestamps. The `log_*` functions give you all of these for free.

### Setting log level

You control how much logging output you see by setting the minimum level. Any message below the minimum level is silently discarded (not even formatted, so there is no performance cost).

```nova
log_set_level(2)    // only show INFO (2) and above -- hides TRACE (0) and DEBUG (1)
```

**Line-by-line breakdown:**

- `log_set_level(2)` -- Sets the minimum log level to 2 (INFO). After this call, `log_trace` and `log_debug` produce no output. `log_info`, `log_warn`, `log_error`, and `log_fatal` still work. The argument is a numeric level, not a string.

The level numbers and their names:

| Number | Level |
|--------|-------|
| 0 | TRACE |
| 1 | DEBUG |
| 2 | INFO (default) |
| 3 | WARN |
| 4 | ERROR |
| 5 | FATAL |

You can also set the level via the `NOVA_LOG` environment variable, so operators can change verbosity without recompiling:

```
NOVA_LOG=debug nova run app.nova
```

This makes debug messages visible. Useful for troubleshooting a production issue without deploying new code.

**Real-world pattern -- different levels for different environments:**

```nova
fn main()
    if env("ENVIRONMENT") == "production"
        log_set_level(3)     // WARN and above only -- quiet
    else
        log_set_level(1)     // DEBUG and above -- verbose during development
    log_info("application starting", {"env": env("ENVIRONMENT")})
```

### Structured logging in JSON (JavaScript Object Notation) format

For production deployments where logs are consumed by machines (log aggregation services, monitoring dashboards, alerting systems), switch to JSON output:

```nova
log_set_json(1)                           // enable JSON output (1 = on, 0 = off)
log_info("request handled", {"status": 200, "path": "/api/users"})
// Output: {"ts":1719576000000,"level":"info","msg":"request handled","status":"200","path":"/api/users"}
```

**Line-by-line breakdown:**

- `log_set_json(1)` -- Enables JSON-formatted log output. Pass `1` to enable, `0` to disable (returns to human-readable format). When JSON mode is on, every log line is a single JSON object on one line, which tools like `jq`, Elasticsearch, and Splunk can parse directly.
- The output is a JSON object with fields: `ts` (timestamp in milliseconds since the Unix epoch), `level` (severity as a lowercase string), `msg` (the message), and all structured fields from the dict.

**Why JSON logging matters:** Human-readable logs like `[INFO] server started port=8080` are easy to read in a terminal. But when you have 50 servers each producing 10,000 log lines per second, you need machine-parseable formats. JSON lets you:

- Filter: "show me all ERROR logs where path starts with /api"
- Aggregate: "count requests per status code per minute"
- Alert: "notify me if error rate exceeds 1%"

**What NOT to do -- logging without structure:**

```nova
// WRONG: hard to parse, hard to search, hard to aggregate
log_info("User alice logged in from 192.168.1.1 at 2026-06-28", {})

// RIGHT: structured fields are searchable and filterable
log_info("user login", {"user": "alice", "ip": "192.168.1.1"})
```

When the fields are separate key-value pairs, a log aggregation tool can instantly answer "how many logins from IP 192.168.1.1?" or "show all events for user alice." When the data is buried in a message string, you need fragile regex parsing.

### The logx module -- library-level structured logging

For applications that need composable, testable logging (where you pass a logger object around rather than using globals), NOVA's standard library provides the `logx` module:

```nova
import logx

fn main()
    lg = logx.logger(1)     // minimum level = INFO (1 in logx)

    // log_info returns the formatted line (or "" if filtered)
    line = logx.log_info(lg, "request", [["path", "/api"], ["status", 200]])
    logx.log_emit(line)      // prints: level=INFO msg=request path=/api status=200

    // DEBUG is level 0 in logx, below the threshold of 1 -- filtered out
    filtered = logx.log_debug(lg, "trace detail", [])
    // filtered == "" (empty string, nothing emitted)

    // env-configured logger: reads NOVA_LOG_LEVEL environment variable
    prod_lg = logx.logger_from_env()
    logx.log_emit(logx.log_warn(prod_lg, "high latency", [["ms", 1200]]))
```

**Line-by-line breakdown:**

- `logx.logger(1)` -- Creates a logger with minimum level 1 (INFO in logx's scheme: 0=DEBUG, 1=INFO, 2=WARN, 3=ERROR). The logger is a value, not a global. You can create multiple loggers with different levels and pass them to different subsystems.
- `logx.log_info(lg, "request", [["path", "/api"], ["status", 200]])` -- Logs an INFO message with structured fields. Fields are a list of `[key, value]` pairs. Returns the formatted line as a string in logfmt format: `level=INFO msg=request path=/api status=200`.
- `logx.log_emit(line)` -- Prints the log line if it is non-empty. This is the "sink" -- the place where the formatted string actually goes to output.
- `logx.log_debug(lg, "trace detail", [])` -- Attempts to log at DEBUG level (0). Since the logger's minimum is 1 (INFO), DEBUG messages (level 0) are filtered to empty string.
- `logx.logger_from_env()` -- Creates a logger whose level is read from the `NOVA_LOG_LEVEL` environment variable. Accepts `"debug"`, `"info"`, `"warn"`, `"error"`. Defaults to `"info"` if the variable is not set or unrecognized.

**Built-in vs. logx:** The built-in `log_info(msg, fields)` uses global state (a process-wide level and format flag). The `logx` module gives you logger-as-a-value, which is testable (check the returned string), composable (different loggers for different subsystems), and has no global side effects. Use built-in logging for simple scripts and small programs. Use `logx` for applications where you need to control logging per-subsystem or write tests that verify log output.

---
