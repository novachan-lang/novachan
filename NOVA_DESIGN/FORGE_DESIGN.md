& NOVA FORGE -- Unified Web Framework Architecture (v0.3)

Status: DESIGN -- decisive synthesis, adversarially reviewed against the live tree (iter-88).
Owner: Chief Language Architect. Build order in section 9. First module + gate in section 10.

------------------------------------------------------------------------

1. THE VISION

NOVA's identity is: one developer, one language, builds + runs ANYTHING. Forge is
where that identity becomes a downloadable, runnable thing. When a developer downloads
NOVA, they build a FULL-STACK APPLICATION -- backend, data layer, HTML, middleware, and
(at the endgame) a WASM frontend -- in ONE language, compiled to ONE static binary, with
ZERO installed dependencies. No pip, no npm, no gunicorn, no node_modules, no external
ORM, no separate template language.

THE HEADLINE PITCH
NOVA Forge is the first web framework where one developer writes the backend, the data
layer, the HTML, the middleware, and (at the endgame) the WASM frontend in ONE language
that compiles to ONE static binary with ZERO installed dependencies -- and gets Go-class
M:N concurrency, Erlang-class per-request crash isolation, and Rust-class type-checked
templates for free. Flask is simple but blocks (you bolt on gunicorn + workers=N); Node
is non-blocking but colors every function async with callbacks; Rails and Phoenix are
productive but drag a runtime, a package manager, and an ORM behind them. Forge collapses
all of that: spawn gives a green task per connection on the real netpoller-parked
scheduler (10k concurrent connections, no async keyword, handlers read as straight-line
synchronous code), return user serializes a struct to JSON with zero annotations via
automatic structural reflection (no jsonify, no Serde derive, no Pydantic class), and a
panic in a handler is contained to that request instead of killing the process.

------------------------------------------------------------------------

2. CURRENT STATE -- HONEST ASSESSMENT

What exists today (grounded against the live tree):

forge.nova (v0.2, ~290 lines, working MVP)
  - Response builders: text/html/json/json_obj/redirect/serve_file + status helpers
    (ok_text/bad_request/not_found/...).
  - Request parsing: parse_method/parse_path/parse_path_clean/parse_body/parse_query/
    query_get/header_get.
  - recv_request: reads a FULL request (headers, then body per Content-Length), correctly
    handling TCP segmentation -- this is real and reusable.
  - serve(port, handler) + serve_n(port, handler, n); handler = (method,path,body)->string.
  - CORS: with_cors / cors_preflight.

routerx.nova (standalone, NOT integrated into forge)
  - router_new / route_add(method,pattern,handler) / route_match(router,method,path)
    -> Result of {handler, params}. Supports path params (/users/:id via :name) and
    method matching. router.nova is a larger 14KB variant.

Core capabilities to LEVERAGE (all real + tested)
  - M:N green scheduler: spawn -> green task, 10k+ tasks, netpoller-parked socket I/O
    (verified: nova_rt_sched_spawn 32KB fiber; tcp_recv/send/accept park via
    nova_sched_in_task / nova_sched_park_io at nova_runtime.c:9062).
  - Automatic structural reflection: str/print/to_json on any struct, zero annotation.
  - SQLite (sqlitex): db_open/db_exec/db_query, injection-safe bound params.
  - TLS: OpenSSL client + POSIX server (Windows-Schannel server is a gap).
  - JSON encode/decode; typed Result + monadic-? error handling; sum types/generics/traits;
    Unicode (NFC/NFD/casefold/collation).

THE THREE NAMED MVP GAPS (this design closes all three)
  G1. serve handles each connection SYNCHRONOUSLY in the accept loop (despite a stale
      "spawn per conn" comment). A slow client in recv_request starves tcp_accept for
      everyone -- Express's single-thread failure mode.
  G2. The handler signature (m,p,b)->string cannot see the raw request; the v2 demo had to
      hand-write serve_with_raw to work around it.
  G3. No Request/Response object model -- so middleware must do fragile string surgery
      (with_cors does find(CRLFCRLF) + slice), and there is no place to thread state.

THE PER-REQUEST LEAK REALITY (measured this iter -- a TRACKED CORE FOLLOW-ON, not a Forge
blocker; the design must reflect this honestly and never claim it is solved)
  - iter-87 fixed the loop-REASSIGNMENT leak (leak_baseline list/dict 2000->1 under
    NOVA_T8_FULLRC).
  - A request-handling server STILL leaks ~41 heap objects/request, IDENTICAL with
    NOVA_T8_FULLRC and +NOVA_T8_DROP. Cause: web handler temporaries are STRING-heavy (not
    covered by the list/dict/struct/closure drop) and are fresh-per-call locals that leak
    at SCOPE-EXIT (not loop-reassignment, which is the only path drops cover today).
  - Full server-leak-freedom needs a TOTAL-RC follow-on: scope-exit drops + string
    coverage + channels.
  - Production envelope: tolerable for dev / moderate load (~KB/req, single-digit MB over
    thousands of requests); FATAL at sustained high throughput until total-RC lands.

THE CORRECTNESS CLIFF (the single biggest risk -- a CORE problem wearing a Forge mask)
  Forge's whole DX (return user, forge.json(value), auto-coercion, structural show/== on
  responses) depends on structural reflection surviving the `any` boundary. TODAY IT DOES
  NOT. A record struct is built as a tagless positional list (nova_compiler.nova:7782 ->
  runtime NOVA_MEM_LIST, no field names). Reflection dispatch is resolved STATICALLY at the
  call site: json_stringify dispatches to <Type>__to_json only when ir_expr_struct_type
  returns a non-empty type (nova_compiler.nova:7529-7533), and for an identifier that
  resolves via ir_locals only when the local's type is a known struct, not `1`/any
  (nova_compiler.nova:8243-8246). The instant a struct flows through an `any`-typed
  parameter, channel, or list, its static type is gone, dispatch falls through to
  nova_rt_json_stringify, and json_stringify_value hits the LIST branch
  (nova_runtime.c:3124-3137) and emits [3,4] -- a JSON ARRAY -- instead of {"x":3,"y":4}.
  This is SILENT WRONG OUTPUT, not a crash. It sits directly under the README's headline
  feature. See section 4 for how this design closes it (a return-site compiler hook), and
  section 9/10 for why it forces module-1 ordering and is NOT zero-compiler-change.

------------------------------------------------------------------------

3. THE ONE DECISION THAT RESOLVES EVERY DISAGREEMENT

The central design question is: is the handler req -> Response (routing/data/DX view) or
Ctx -> Ctx, one threaded mutable value (middleware view)? Both cannot be the public shape.
The choice is FORCED by three constraints that must all hold at once:

  - Leak reality: an immutable Response returned fresh per middleware mutation multiplies
    the exact string-temporary churn that already leaks ~41 objs/req. The middleware view
    is right that a single threaded MUTABLE value allocates strictly less.
  - DX / simpler than Python: the hero must read fn(req) forge.json(user). A handler that
    takes a fat Ctx and must return ctx after mutating ctx.out is ceremony a Flask dev
    rejects. The routing/DX view is right that req -> Response is the ergonomic contract.
  - Testability: both want pure value-in / value-out. Both achieve it.

RESOLUTION -- the two shapes are the SAME OBJECTS at two altitudes, not two competing models.
  - The PUBLIC handler is fn(Request) -> Response (or -> any, coerced).
  - The MIDDLEWARE shape is fn(Handler) -> Handler, composed by function-wrapping.
  - Request and Response are BOTH plain reflection-printable structs. There is NO third
    Ctx type. Request.state: dict carries the cross-cutting middleware scratch (session,
    user) that Ctx wanted. Response is the single MUTABLE accumulator middleware writes
    headers/status into. Response.halted: bool lets a guard short-circuit without
    exceptions. The middleware view's Ctx simply IS Request(.state) + the mutable Response,
    split into the two structs the other views already require.

One model. Everything else (auto-JSON coercion, spawn-per-conn, routerx integration,
structs-not-ORM, HTML-as-a-function, signed sessions, per-request crash isolation) is
additive and non-conflicting -- adopted.

------------------------------------------------------------------------

4. TARGET ARCHITECTURE

4.1 THE CORE OBJECT MODEL -- four structs, two function shapes

  struct Request
      method   : string   // "GET"
      path     : string   // "/users/42"  (clean, query stripped)
      raw_path : string   // "/users/42?tab=x"
      params   : dict      // {"id":"42"}  filled by the router at match time
      query    : dict      // {"tab":"x"}  parsed ONCE
      headers  : dict      // lowercased keys -> value, parsed ONCE (case-insensitive free)
      body     : string
      raw      : string    // full request (escape hatch + WebSocket/stream upgrade)
      state    : dict      // middleware scratch: state["session"], state["user"], ...
      conn     : int       // raw fd (streaming / upgrade)

  struct Response
      status   : int       // 200
      headers  : dict      // "content-type" -> ..., "set-cookie" accumulated
      body     : string
      halted   : bool      // a guard set the response; downstream skips, no exceptions

  struct App
      router      : dict   // routerx router (router_new) -- the integrated matching engine
      mws         : list   // middleware stack, applied outside-in
      prefix      : string // route-group prefix (sub-App shares router, deeper prefix)
      static_root : string // serve_static fallback dir, "" = disabled
      not_found   : any    // fn(Request)->Response, default 404
      on_panic    : any    // fn(Request, reason)->Response, default 500
      db          : int    // optional sqlite handle threaded to handlers
      shutdown    : bool    // graceful-drain flag

  THE TWO SHAPES
      Handler    = fn(Request) -> Response | any   // public; auto-coerced (see 4.3)
      Middleware = fn(Handler)  -> Handler         // composition by function-wrapping

  Decisive justifications (each is a strict win and most also REDUCE the leak surface):
   - params/query/headers are dicts parsed ONCE. Today's query_get/header_get do an O(n)
     raw-string scan PER lookup and have the documented xkey= false-match bug
     (forge.nova:112). One-time parse -> O(1) access, case-insensitive headers for free,
     fewer transient strings.
   - Response is a struct, not the MVP's wire string. Middleware must mutate headers (CORS,
     Set-Cookie) and status. On a string that is fragile find(CRLFCRLF)+slice surgery, O(n)
     per mutation (exactly what with_cors does). On a struct it is resp.headers[k]=v, O(1),
     and the wire string is serialized EXACTLY ONCE at finalize.
   - No separate Ctx. A third top-level type the developer must learn violates "one obvious
     way." Request.state + mutable Response carry everything Ctx did.

4.2 THE PUBLIC API -- one flat, free-function surface (NO method-style, NO fictional sugar)

  IMPORTANT: NOVA has no method-table dispatch on structs and no decorators. app.get(...)
  does NOT compile. The API is free-function only. forge.get(app, ...) is one token more
  than Flask per route -- this is honest and unavoidable, not a stylistic choice.

  // construction
  forge.app()                          -> App
  forge.group(app, "/api/v1")          -> App   // sub-App, same router, deeper prefix

  // routing (thin wrappers over routerx route_add)
  forge.get(app, pattern, handler)
  forge.post(app, pattern, handler)
  forge.put(app, pattern, handler)
  forge.delete(app, pattern, handler)
  forge.patch(app, pattern, handler)
  forge.static(app, url_prefix, root)           // traversal-safe static files

  // middleware
  forge.use(app, mw)                            // push onto stack (outside-in)
  forge.logger() / forge.recover() / forge.cors(origin)
  forge.limit_body(maxBytes) / forge.rate_limit(n, windowMs)
  forge.sessions(secret) / forge.csrf() / forge.require_auth(verify)

  // responses -- VALUE-POLYMORPHIC via reflection
  forge.json(value)                             // any struct/list/dict -> JSON, status 200
  forge.text(s)   forge.html(s)
  forge.redirect(url)   forge.file(path)
  forge.status(resp, code)                      // fluent override: resp.status=code; resp
  forge.bad_request(msg) / forge.not_found(msg) / forge.unauthorized() / forge.internal_error(msg)
  // NOTE: there is NO forge.json(status, value) overload. NOVA codegen has no arity
  // dispatch (json_stringify keys on len(children)==1). Non-200 JSON is the fluent form
  // forge.status(forge.json(v), 201). One way to do each thing.

  // request accessors -- dicts are PRIMARY (real field access, fewer chars than Flask)
  req.params["id"]   req.query["tab"]   req.headers["host"]     // the default hit path
  // total/safe fallbacks (never crash, return "" / {} on miss) -- use only when you want
  // the default-on-miss behavior:
  forge.param(req, k)   forge.q(req, k)   forge.header(req, name)   forge.cookie(req, name)
  forge.json_body(req)                          // json_decode(req.body) -> dict/list

  // data -- type-driven via the `let` site (works today; NOT the broken any path)
  forge.query_as(db, sql, params)               // -> list<T> (row->struct by column order)
  forge.query_one(db, sql, params)              // -> Result<T>
  forge.exec(db, sql, params)                   // -> last_insert_id; params ALWAYS bound
  forge.body_as(req)                            // -> T (body JSON typed by the let)
  forge.form_as(req)                            // -> T (urlencoded form -> struct)

  // views -- HTML is a NOVA function, escape-by-default
  forge.esc_text(s)   forge.esc_attr(s)   forge.el(tag, inner)   forge.tag(name, attrs, inner)
  forge.each(items, f)   forge.layout(title, bodyHtml)   forge.render(tmpl, vars)

  // serving + lifecycle
  forge.serve(app, port)                        // INFINITE: spawn green task per connection
  forge.serve_n(app, port, n)                   // deterministic: exactly N requests (tests)
  forge.run(port)                               // 3-line sugar: implicit global app + serve

  // testing -- no socket, no port
  forge.mock_request(method, path, body) -> Request
  forge.dispatch(app, req)               -> Response   // pure: route + run, isolated test

4.3 THE COERCION KEYSTONE -- and why it needs a compiler hook (NOT zero-change)

  The unanimous biggest ergonomic win is value-polymorphic return: return user, where user
  is a struct, serializes to {"name":...} via automatic structural reflection. Flask needs
  jsonify(obj.__dict__); Express res.json(obj); Serde #[derive(Serialize)]; FastAPI a
  Pydantic class. NOVA: return user.

  BUT a generic runtime _coerce(any) CANNOT do this correctly. Traced against source:
  _coerce takes v as a bare param, so at the json_stringify(v) site v's local type is `1`
  (any); ir_expr_struct_type returns "" (nova_compiler.nova:8243-8246); dispatch falls
  through to nova_rt_json_stringify; a tagless record struct (NOVA_MEM_LIST) serializes as
  [3,4] (nova_runtime.c:3124-3137), not {"x":3,"y":4}. Silent wrong output to the wire.

  THE FIX (decisive, and it dictates module ordering): the coercion must happen at the
  HANDLER's RETURN SITE, where the static struct type is still known, BEFORE the value is
  erased to `any`. Concretely, a compiler hook rewrites a handler's
      return <struct-expr>            -> return forge.json(<Type>__to_json(<expr>) as body)
      return <list-of-struct-expr>    -> the existing list-of-structs json path
                                          (nova_compiler.nova:7534-7546, already works)
  so the right __to_json is emitted while ir_expr_struct_type can still resolve the type.
  String and already-Response returns pass through unchanged. This is a SMALL, LOCALIZED
  compiler change (a context-scoped return rewrite), NOT the deep runtime-typed-struct
  upgrade -- but it IS a compiler change, so module 1 is not "no compiler change."

  Runtime glue for the non-struct cases (string -> text, dict/list -> json) is fine through
  a normal coercion; only the BARE-STRUCT case must be resolved at the return site.

      fn _coerce(v) -> Response
          if is_response(v)   return v
          if is_string(v)     return forge.text(v)   // string -> text/plain
          forge.json(v)                              // dict/list -> json (struct handled
                                                     // at the return site, pre-erasure)

  HONEST SCOPING UNTIL THE HOOK SHIPS: do NOT document "return user" as working. The
  typed-let data paths (query_as, body_as) DO work today (driven by the let's declared
  type, not the any boundary). The handler-return-bare-struct path requires the hook.
  Long-term, giving record structs a runtime type-id header (so nova_rt_json_stringify / ==
  / show recover field names dynamically) is the general fix; it is tracked deep core work
  and Forge is the use case that forces it.

4.4 THE REQUEST LIFECYCLE -- one trace, every mechanism in its place

  tcp_accept(listener)                          [serve loop, parks on netpoller when idle]
    -> spawn fn() _serve_conn(app, conn)         [THE FIX: green task per connection]
         -> raw = _recv_request_timeout(conn)    [Slowloris-bounded recv_request]
         -> req = _build_request(raw, conn)      [parse ONCE -> Request; params={} for now]
         -> resp = _run(app, req)                [middleware chain + dispatch]
              -> stack = chain(app.mws, _dispatch)   [fold middleware outside-in]
              -> recover() wraps _dispatch in spawn+monitor -> contained panic => 500
              -> logger / cors / limit_body / rate_limit / sessions / csrf  may set halted
              -> _dispatch: route_match(app.router, req.method, req.path)
                   - ok:  req.params = hit["params"]; resp = _coerce(hit["handler"](req))
                   - miss + pattern-exists-other-method: 405 + Allow header [second pass]
                   - miss entirely: static fallback, else app.not_found(req)  [404]
         -> tcp_send(conn, finalize(resp))       [Response struct -> wire string, ONCE]
         -> keep-alive? loop : tcp_close(conn)   [per-conn keep-alive loop, capped]

  Middleware composes by function-wrapping: chain([...], terminal) folds inside-out so the
  left-most middleware is OUTERMOST (sees request first, response last). A guard
  short-circuits by setting resp.halted and returning; downstream links check
  `if resp.halted return resp` at entry. No exceptions; fully visible control flow.

  routerx is the matching ENGINE, App is the face. Zero changes to route_add/route_match.
  Two small extensions only: _match_pattern gains a *name catch-all case; dispatch gains the
  405-vs-404 second pass (on miss, re-scan ignoring method; pattern match -> 405 + Allow;
  total miss -> 404). ~10 lines, not a rewrite.

4.5 CONCURRENCY, LIFECYCLE, FAULT ISOLATION -- the decisive calls

  Spawn-per-connection is mandatory and IS the central bug fix (closes G1). One word:
      fn serve(app, port)
          let listener = tcp_listen(port)
          while not app.shutdown
              let conn = tcp_accept(listener)    // parks on netpoller when idle
              spawn fn() _serve_conn(app, conn)  // green task; accept loops back immediately
  Verified real: spawn -> nova_rt_sched_spawn (32KB fiber, not OS thread); tcp_recv/send/
  accept branch on nova_sched_in_task() and park via nova_sched_park_io transparently on a
  fiber (nova_runtime.c:9062). 10k parked connections = ~320MB stacks + ~0 carrier CPU
  (green_scale_test applied to sockets). NO async/await keyword -- db_query/http_get/tcp_recv
  park transparently, so handlers read straight-line synchronous while behaving fully async.
  This resolves the contradiction Flask (simple but blocking) and Node (non-blocking but
  callback-colored) cannot.

  Scoping calls (to keep v0.3 shippable AND honest):
   - Keep-alive loop -- ADOPT, but cap with a SMALL max_keepalive_reqs. Critical
     interaction: a keep-alive task does NOT exit between requests, so leaked per-request
     temporaries accumulate for the LIFE of the connection -- the loop-body-local argument
     (section 6) does not reclaim anything until total-RC lands. The cap is the
     load-bearing leak mitigation, not an optimization.
   - _recv_request_timeout -- ADOPT (Slowloris defense; bounds the unbounded while sep<0
     loop). Defaults: read 15s, keep-alive idle 5s. The deadline-between-parks form needs
     ZERO runtime change; a tighter park_io_with_deadline hook is a deferred follow-on.
   - Graceful shutdown (inflight channel + tcp_close(listener) to wake accept) -- ADOPT but
     mark v0.3.1; not needed for the hello-world or full-stack demo to land.

  Per-request crash isolation -- ADOPT as OPT-IN recover(): each request's downstream chain
  runs in a spawn'd task with monitor; a panic is CONTAINED (verified crash_isolation_test /
  exit_reason_test), exit_reason becomes a structured 500, the server lives. This is a
  genuine match for BEAM request isolation at LLVM-AOT speed and a structural win over Go
  (unrecovered goroutine panic kills the process) and Node (unhandled rejection can kill the
  loop). Honest cost: one extra spawn+channel+monitor PER REQUEST -> opt-in, removable by
  latency-critical experts. HONEST SCOPE: supx is restart-on-SIGNALED-failure (a cooperating
  child sends a failure signal), NOT OS-process isolation of an arbitrary crash -- do not
  overclaim full Phoenix-parity.

  Lock-free rate limiting via an OWNER ACTOR -- ADOPT: one green task owns the per-IP counter
  map; request tasks ask over a channel. No Arc<Mutex>, no sync.Map contention cliff --
  process-isolation-as-memory-safety. A genuine Erlang-class structural win.

4.6 DATA + VIEWS -- the decisive calls

  JSON: the typed `let` is the entire contract. let u: User = forge.body_as(req) -- the LHS
  type selects User__from_json, no @derive, no wrapper generic. Beats FastAPI (Pydantic
  class), Axum (Json<T>), Serde (derive). Track from_json_safe -> Result<T> so monadic-?
  handles malformed bodies; ship body_as now (works today), land the safe variant as the
  production upgrade.

  DB: structs-not-ORM. sqlitex.db_query ALWAYS binds params (injection impossible).
  query_as maps each row to the let's element struct by COLUMN ORDER = FIELD ORDER, coercing
  per field type (int->parse_int, bool->=="1"). Same type-driven structural dispatch as
  from_json -- one more _make_* method on the existing hook, NO new compiler subsystem.
  Deliberately stops short of a query-builder DSL / relations / migrations: joins are SQL
  strings (the thing every dev already knows). This is Go's database/sql WITHOUT rows.Scan
  boilerplate; sqlx WITHOUT the macro/async weight. Track last_insert_rowid extern (one
  line) and the documented bool convention.

  Views: HTML is a NOVA FUNCTION, NOT a template language (a core-identity decision; the
  non-decision IS the deliverable). No Jinja/EJS -- a template language is a second language
  with its own control flow, scoping, and injection class, violating "the developer never
  leaves." Loops are each (HOF over real lists); conditionals are if; partials are
  functions; inheritance is composition. u.name is a REAL field access -> a typo is a
  COMPILE error, not a blank in output (no string-template engine can match that).
  Escape-by-default, with TWO escapers (one escaper is an XSS hole):
    - esc_text: element content (escapes < > &).
    - esc_attr: attribute values (escapes " ' and rejects/encodes javascript:/data: in
      URL-typed attrs).
  {{{raw}}} is the loud greppable opt-out -- safety by default, beating Jinja's opt-in
  autoescape. Three tiers, progressive disclosure: serve_file (static) -> render(tmpl, vars)
  (fill-the-holes) -> el/each/tag (programmatic).

  Static files: traversal defense is MANDATORY. serve_static must url_decode FIRST (so
  %2e%2e%2f cannot slip past a naive .. check), then reject .. / leading-/ / null-byte
  before touching the FS. Named CVE class, guarded explicitly.

  Forms: application/x-www-form-urlencoded is done -- urlx.parse_query url-decodes into a
  dict; form_as reuses the SAME dict->struct mapper as from_json. Multipart is the only
  net-new parser -- ship with a max_body_bytes cap; streaming-to-disk + byte-clean binary
  buffers are tracked CORE follow-ons (value-model, not Forge).

------------------------------------------------------------------------

5. CANONICAL HELLO-WORLD + FULL-STACK EXAMPLE

5.1 The 10-line hero (every line buys production capability)

  use forge

  fn main()
      let app = forge.app()
      forge.get(app, "/", fn(req) forge.json({"hello": "nova"}))
      forge.get(app, "/users/:id", fn(req) forge.json({"id": req.params["id"]}))
      forge.serve(app, 8080)

  7 lines of logic. forge.json(dict) -> reflection serializes, zero boilerplate.
  forge.serve -> green-task-per-conn on the real M:N scheduler, 10k concurrent, no
  workers=N, no gunicorn. req.params["id"] -> routerx :id extraction (real field access).
  The 3-line forge.run(8080) sugar (implicit global app) exists for the tweet, but
  forge.app() is the documented default because routing is needed on request #2.

5.2 Full-stack example -- backend + DB + frontend + middleware, one language

  use forge
  use sqlitex

  type Note
      id: int
      text: string

  type NewNote
      text: string

  fn list_notes(req)
      let notes: list<Note> = forge.query_as(db(), "SELECT id, text FROM notes ORDER BY id DESC", [])
      forge.json(notes)                              // list<struct> -> JSON via reflection

  fn add_note(req)
      let n: NewNote = forge.body_as(req)            // JSON body -> struct, typed by the let
      if len(n.text) == 0
          return forge.bad_request("text required")
      let id = forge.exec(db(), "INSERT INTO notes(text) VALUES(?)", [n.text])  // bound = safe
      forge.status(forge.json(Note { id: id, text: n.text }), 201)

  fn main()
      sqlitex.db_exec(db(), "CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMARY KEY, text TEXT)")
      let app = forge.app()
      forge.use(app, forge.recover())                // panic in a handler -> 500, server lives
      forge.use(app, forge.logger())
      forge.use(app, forge.cors("*"))
      forge.static(app, "/", "public")               // serves public/index.html (frontend)
      forge.get(app,  "/api/notes", list_notes)
      forge.post(app, "/api/notes", add_note)
      forge.serve(app, 8080)

  public/index.html is plain fetch() HTML served by forge.static -- no build step. A complete
  full-stack app: SQLite-backed injection-safe REST API + browser frontend + per-request
  crash isolation + structural JSON, ONE language, ONE static binary, ZERO external services.
  Flask needs pip + jsonify + gunicorn + SQLAlchemy; Express needs npm + node_modules + a
  process manager. Forge needs nothing installed. (Endgame, documented-not-promised: the
  frontend itself in NOVA -> WASM, sharing the type-checked Request/Note across the wire --
  the thing Flask/Express structurally cannot do.)

------------------------------------------------------------------------

6. THE LEAK REALITY -- STRUCTURED FOR TOTAL RECLAMATION (honest, not solved)

  The measured ~41 heap objs/req leak (string-heavy handler temporaries; fresh-per-call
  locals leaking at SCOPE-EXIT, not loop-reassignment) is NOT solved by this design, and the
  design must not claim it is. Two architectural rules make Forge INHERIT leak-freedom the
  moment total-RC (scope-exit drops + string coverage + channels) lands, with ZERO API
  change:

   1. All per-request allocation lives in locals inside the per-connection loop body --
      Request, Response, every dict, every intermediate string. Nothing escapes upward into
      a growing structure (no request caching in a list). This is a constraint imposed NOW so
      the FUTURE fix is total. Honest caveat: it buys FUTURE reclamation, not present
      reclamation (scope-exit drops do not exist yet). And for keep-alive the task does not
      exit between requests, so leaked objects accumulate for the connection's life -- which
      is exactly why max_keepalive_reqs is capped small (section 4.5).
   2. A single MUTABLE Response threaded through middleware, not immutable-builder. This is
      WHY the Ctx-immutable-return and resp.with_header().with_status() fluent-fresh forms
      were rejected: each allocates a fresh struct per mutation, multiplying the exact leak
      class. One mutable Response = strictly fewer allocations than today's MVP. Plus
      finalize writes the wire string into one pre-sized buffer (StringBuilder-style),
      cutting the ~7 concatenations-per-response to near-zero transient strings -- a pure win
      TODAY, less to drop TOMORROW.

  HONEST POSITIONING (the README must say exactly this): production-ready for dev and
  moderate load today (~KB/req, single-digit MB over thousands of requests); FATAL at
  sustained high throughput until total-RC lands. Mitigation available now:
  max_keepalive_reqs cap + supervisor process-recycle (the uWSGI max-requests pattern). NOT
  "production at scale" yet.

------------------------------------------------------------------------

7. THE TLS / HTTPS ENVELOPE (honest, under-disclosed in earlier drafts)

  Server TLS exists (tls_listen / tls_accept, SSL_accept at nova_runtime.c:16173+) but only
  under -DNOVA_HAVE_OPENSSL. Two truths the design states plainly:
   - The TLS handshake (SSL_accept) is BLOCKING and does not park on the netpoller. It MUST
     move INTO the spawned _serve_conn (post-spawn), not run in the accept loop -- otherwise
     a single slow/malicious TLS client stalls accept for everyone (the exact starvation the
     green model claims to fix). The serve loop calls plain tcp_accept (which parks); the
     handshake happens inside the per-conn task.
   - On Windows, OpenSSL is not bundled; the default build has NO HTTPS server (Schannel
     server is a gap). So: HTTPS server requires OpenSSL at build time -- bundled on Linux,
     manual on Windows. Plain HTTP is the zero-dependency default. Do NOT imply
     HTTPS-everywhere.

------------------------------------------------------------------------

8. COMPETITIVE TABLE -- where Forge WINS, where it MUST MATCH

  Dimension                 | Flask        | Express      | Rails        | Phoenix      | NOVA Forge -- verdict
  --------------------------+--------------+--------------+--------------+--------------+----------------------------------------
  Concurrency model         | thread/block | single-loop  | thread/block | BEAM procs   | WIN: M:N green per-conn, 10k parked,
                            | + gunicorn   | callbacks    | + puma       |              | no async kw, straight-line handlers
  JSON from a domain object | jsonify(d)   | res.json(o)  | to_json+as_  | Jason +      | WIN (after hook): return user, zero
                            |              |              | json hooks   | derive       | annotation -- but SILENTLY BROKEN
                            |              |              |              |              | until the return-site hook ships (4.3)
  Request crash isolation   | per-worker   | kills loop   | per-worker   | per-process  | WIN/MATCH: opt-in recover() contains a
                            |              | (rejection)  |              | (real win)   | panic to the request; costs a fiber/req
  Type-checked templates    | none (Jinja) | none (EJS)   | none (ERB)   | none (EEx)   | WIN: HTML is NOVA fns, u.name is a real
                            |              |              |              |              | field -> typo is a COMPILE error
  Injection-safe DB         | SQLAlchemy   | knex/pg      | ActiveRecord | Ecto         | MATCH: sqlitex always binds; structs-
                            |              |              |              |              | not-ORM (Go database/sql w/o Scan)
  Deploy footprint          | pip+gunicorn | npm+node_mod | gem+bundler  | mix+BEAM     | WIN: one static binary, zero installed
                            | +SQLAlchemy  | +pm2         | +rails       | +erlang      | deps (plain HTTP); HTTPS needs OpenSSL
  Routing ergonomics        | @app.route   | app.get      | resources    | router DSL   | MATCH-minus: forge.get(app,..) free-fn,
                            |              |              |              |              | one token more (no decorators/methods)
  Sustained high-load mem   | mature GC    | V8 GC        | mature GC    | per-proc GC  | LOSE (tracked): ~41 objs/req leak until
                            |              |              |              |              | total-RC core follow-on; cap + recycle
  Sessions/auth/CSRF        | ext + Flask- | passport+    | Devise       | built-in     | MATCH: signed cookie (HttpOnly/SameSite),
                            | Login        | csurf        |              |              | constant-time verify, double-submit CSRF
  Peak request throughput   | CPython slow | V8 JIT       | MRI slow     | BEAM mid     | WIN (intent): LLVM-AOT native, no warmup
                            |              |              |              |              | -- pending GATE-5 web bench validation

  Reading: Forge already WINS concurrency, templates, crash isolation, and deploy footprint
  on architecture. The JSON win is real but BLOCKED on the section-4.3 hook (must ship, or be
  honestly scoped). The one clear LOSE is sustained high-load memory -- a tracked CORE
  follow-on, mitigated by the keep-alive cap + process recycle, not papered over.

------------------------------------------------------------------------

9. MODULE ROADMAP (ordered, iter-sized; each gated edit->precheck->gen4 smoke->bootstrap
   reconverge->regression->commit)

  Leverages = existing real code reused. New = net-new pure-NOVA. Compiler change is flagged.

  1. forge2-core (Request/Response/App + integrated routing + AUTO-JSON-ON-RETURN HOOK)
     What: the four structs; _build_request (parse-once dicts, fixes xkey= bug + O(1)
       access + case-insensitive headers); total accessors as safe fallbacks; value-
       polymorphic forge.json/text/html/redirect/file; _coerce; finalize (struct -> wire,
       single pre-sized buffer); forge.app/get/post/put/delete/group; _dispatch wrapping
       route_match; dispatch/mock_request/status_of/body_of for pure testing. CRITICAL: the
       return-site compiler hook that emits <Type>__to_json (and the existing list-of-structs
       json path) for a handler's return BEFORE any-erasure.
     Leverages: forge.nova builders/parsers/recv_request; routerx route_match; reflection
       <Type>__to_json; the existing list-of-structs json path (nova_compiler.nova:7534-7546)
       + ir_expr_struct_type (8220).
     Compiler change? YES -- the return-site auto-JSON hook (the keystone delta; NOT the
       "no change" the earlier roadmap claimed). Small + localized, gated via bootstrap
       reconverge.

  2. green-per-request-serve + lifecycle
     What: serve does spawn _serve_conn per accept (THE fix, closes G1); per-conn keep-alive
       loop (capped by a small max_keepalive_reqs -- the load-bearing leak mitigation);
       _recv_request_timeout (Slowloris bound, deadline-between-parks, zero runtime change);
       Connection negotiation (stop hardcoding close); serve_n retains deterministic form.
       TLS handshake moved INSIDE _serve_conn (section 7).
     Leverages: spawn -> green scheduler + netpoller-parked tcp_* (verified real,
       nova_runtime.c:9062); recv_request segmentation.
     Compiler change? No.

  3. router-extensions (wildcard + 405/404 + groups + traversal-safe static)
     What: _match_pattern gains *name catch-all; 405-vs-404 second pass + Allow header;
       group prefix sub-App; forge.static traversal-safe (url_decode FIRST, then reject ..
       / leading-/ / null-byte).
     Leverages: routerx _match_pattern (routerx.nova:9) / route_match; serve_file + _ext_ctype;
       urlx url_decode.
     Compiler change? No.

  4. middleware-engine + core middleware
     What: chain (outside-in fold); Response.halted short-circuit (reply); forge.use; logger,
       cors (struct-field, not string surgery), limit_body, recover (spawn+monitor+exit_reason
       -> 500), rate_limit (owner-actor, lock-free).
     Leverages: spawn/monitor/exit_reason/channel (verified: crash_isolation_test); with_cors
       logic.
     Compiler change? No.

  5. data (DB row->struct + typed JSON/form bodies)
     What: query_as/query_one/exec (row->struct by column order, always-bound); body_as/
       form_as (typed by the let, reuse dict->struct); track from_json_safe -> Result<T>.
       NOTE: the typed-let path works today (let-driven, not the broken any path); this
       module's only delta is the row->struct structural method + a one-line last_insert_rowid
       extern.
     Leverages: sqlitex db_query (bound params); from_json/json_stringify; urlx parse_query;
       the existing _make_* structural hook.
     Compiler change? Small -- row->struct structural method + last_insert_rowid extern.

  6. views (HTML-as-function, escape-by-default)
     What: esc_text/esc_attr/el/tag/each/layout; render (auto-escaping {{}}, {{{raw}}} opt-out);
       the explicit decision: NO template language (the non-decision IS the deliverable).
     Leverages: urlx html_escape; tmplx template_render pattern.
     Compiler change? No.

  7. sessions / auth / CSRF
     What: sessions(secret) (signed cookie, HttpOnly + SameSite=Lax default, constant-time
       verify); server-side variant (token(16) + sqlitex); require_auth(verify); csrf()
       (double-submit, _ct_eq); basic_verifier over authx.
     Leverages: hmac_sign/hmac_verify (_ct_eq); authx basic_auth_decode/verify_password;
       sqlitex; reflection.
     Compiler change? No.

  8. graceful-shutdown + supervision
     What: inflight channel counter; _drain; tcp_close(listener) to wake accept; _signal_watcher;
       supervise the rate/session-GC actors via supervise/one_for_one. Honest: supx is
       restart-on-signaled-failure, not arbitrary-crash supervision.
     Leverages: channel; supx supervise/strategies (verified real).
     Compiler change? No.

  9. flagship-full-stack-demo + toolchain DX
     What: the section-5 notes app (DB + REST + frontend + middleware); convert demo_forge_v2's
       serve_with_raw workaround into canonical fn(req)->Response; nova new webapp template;
       nova dev watch-recompile-restart; nova deploy (cross-compile + Railway path).
     Leverages: sqlitex, full forge stack, reflection; nova_build incremental + cross-compile;
       live Railway path.
     Compiler change? No.

  Sequencing rationale: modules 1-3 deliver a correct, concurrent, routed server (the three
  named MVP gaps closed) -- shippable and demoable alone. The KEYSTONE compiler delta is in
  MODULE 1 (corrected from the earlier draft that buried it in module 5), because _coerce's
  auto-JSON is silently broken without it and it must be gated through the bootstrap reconverge
  before anything depends on it. Module 4 adds the composition spine. Module 5 is highest
  value-per-line (typed DB+JSON is the data identity) and carries only a tiny structural method
  + one extern (the typed-let path already works). Modules 6-7 are pure-NOVA breadth. Module 8
  hardens for deploy. Module 9 is the flagship. Every module honors the leak rule (all
  per-request state stays loop-body-local) so total-RC, when it lands, reclaims everything with
  zero API change.

------------------------------------------------------------------------

10. ITER-89 FIRST MODULE + ITS GATE

  BUILD: Module 1 -- forge2-core, EXPANDED to include the auto-JSON-on-return compiler hook
  (NOT the "no compiler change" version). Deliver the four structs + parse-once Request +
  _dispatch over route_match + finalize (single pre-sized buffer) + value-polymorphic
  forge.json/text/html/redirect/file + the pure-test surface (mock_request/dispatch/status_of/
  body_of), AND the compiler rewrite that emits <Type>__to_json (or the list-of-structs json
  path) at a handler's return <struct-or-list-of-struct> so coercion happens BEFORE
  any-erasure.

  WHY THIS FIRST: it is the keystone. The headline DX claim "return user -> {...}" is silently
  broken via _coerce (ir_expr_struct_type returns "" for an any-typed local -> dispatch falls
  through -> a tagless record struct serializes as [3,4]). Shipping module 1 as the earlier
  "no compiler change" spec would ship the headline feature emitting silently-wrong JSON to
  the wire. The compiler delta cannot be deferred.

  GATE (mandatory order, kill-on-timeout enforced):
    edit -> precheck -> gen4 smoke -> bootstrap reconverge (gen5.ll == gen6.ll, compare .ll
    files NOT exe SHAs) -> full regression (all must stay green) -> commit.

  PROOF GATE (a NEW test -- handler_return_json_test): a handler that returns a BARE Point
  struct must produce wire body {"x":3,"y":4}, NOT [3,4]. auto_json_test does NOT cover this
  because it serializes a statically-typed local -- the exact condition _coerce destroys by
  routing through an any parameter. If that test cannot be made to pass via the return-site
  hook without the runtime-typed-struct core upgrade, then iter-89's REAL deliverable becomes
  that core upgrade (a hidden type-id header on record-struct allocations so
  nova_rt_json_stringify / == / show recover field names dynamically), and Forge module 1
  waits on it. Either way, the headline feature must not ship emitting wrong JSON.

------------------------------------------------------------------------

APPENDIX -- relevant files (absolute paths)
  C:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\forge.nova
  ...\routerx.nova   ...\router.nova   ...\sqlitex.nova   ...\supx.nova   ...\urlx.nova
  ...\authx.nova   ...\demo_forge_v2_test.nova   ...\auto_json_test.nova
  ...\from_json_test.nova   ...\crash_isolation_test.nova   ...\exit_reason_test.nova
  ...\nova_compiler.nova  (json_stringify dispatch @7529-7546; ir_expr_struct_type @8220;
                           ir_list_elem_struct @8308; struct_init lowering @7782)
  ...\output\nova_runtime.c  (json_stringify_value @3095-3137; nova_rt_json_stringify @3157;
                              tcp_accept park @9062; tls_listen/accept @16173)