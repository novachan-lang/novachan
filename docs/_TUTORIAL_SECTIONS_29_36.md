## 29. Forge: HTML (HyperText Markup Language) builder

### What is this?

When you build a web application, you need to send HTML (HyperText Markup Language) back to the browser. There are two ways to do this:

1. **Template strings** -- You write raw HTML as a string with variables inserted. This is error-prone: you can forget to close tags, misspell attribute names, or introduce XSS (Cross-Site Scripting) vulnerabilities by forgetting to escape user input.

2. **An HTML builder** -- You construct HTML using function calls. Each function represents an HTML element. The builder guarantees that tags are properly nested and closed. This is what Forge provides through the `forge_html` module.

The HTML builder approach is used by frameworks like Elm, Mithril, and Phoenix LiveView. It treats HTML as data (a tree of function calls) rather than text (a raw string). This makes it composable -- you can build reusable page fragments as regular NOVA functions and combine them.

### Building a complete page

```nova
import forge
import forge_html

fn main()
    app = forge.app()

    forge.get(app, "/page", fn(req)
        page = html([
            h("h1", "Welcome to NOVA"),
            p("This is a paragraph."),
            div([
                h("h2", "Features"),
                ul([
                    li("Fast — C-level performance"),
                    li("Safe — no data races"),
                    li("Simple — simpler than Python")
                ])
            ]),
            a("https://nova-lang.org", "Learn more")
        ])
        forge.html(page)
    )

    forge.serve(app, 8080)
```

**Line-by-line explanation:**

- `import forge` -- Loads the Forge web framework module for routing and serving.
- `import forge_html` -- Loads the HTML builder functions (`html`, `h`, `p`, `div`, `ul`, `li`, `a`, etc.).
- `app = forge.app()` -- Creates a new Forge application instance that holds routes and middleware.
- `forge.get(app, "/page", fn(req) ...)` -- Registers a handler for GET requests to the `/page` URL path. The anonymous function `fn(req)` receives the incoming HTTP request.
- `page = html([...])` -- `html()` wraps a list of child elements into a complete HTML document. It generates the `<html>`, `<head>`, and `<body>` tags automatically.
- `h("h1", "Welcome to NOVA")` -- Creates an HTML heading element. The first argument is the tag name (any valid HTML tag), the second is the text content. This generates `<h1>Welcome to NOVA</h1>`.
- `p("This is a paragraph.")` -- Creates a `<p>` paragraph element with text content.
- `div([...])` -- Creates a `<div>` container element. The argument is a list of child elements that go inside the `<div>`.
- `ul([li("Fast..."), li("Safe..."), li("Simple...")])` -- Creates an unordered list (`<ul>`) with three list items (`<li>`).
- `a("https://nova-lang.org", "Learn more")` -- Creates an anchor link (`<a href="...">text</a>`). First argument is the URL, second is the display text.
- `forge.html(page)` -- Sends the generated HTML string as the HTTP response with `Content-Type: text/html`.
- `forge.serve(app, 8080)` -- Starts the HTTP server on port 8080.

### Composing reusable page fragments

Because HTML elements are just function calls, you can extract page sections into regular functions and reuse them across routes:

```nova
import forge
import forge_html

fn nav_bar(current_page)
    nav([
        a("/", "Home"),
        a("/about", "About"),
        a("/contact", "Contact"),
        span("Current: {current_page}")
    ])

fn page_footer()
    footer([
        hr(),
        p("Copyright 2026 My App"),
        p("Built with NOVA + Forge")
    ])

fn page_layout(title, content)
    html([
        h("h1", title),
        nav_bar(title),
        div(content),
        page_footer()
    ])

fn main()
    app = forge.app()

    forge.get(app, "/", fn(req)
        forge.html(page_layout("Home", [
            p("Welcome to our site."),
            p("This content is specific to the home page.")
        ]))
    )

    forge.get(app, "/about", fn(req)
        forge.html(page_layout("About", [
            p("We build things with NOVA.")
        ]))
    )

    forge.serve(app, 8080)
```

**Line-by-line explanation:**

- `fn nav_bar(current_page)` -- A reusable function that returns a navigation bar. It takes the current page name so it can display where the user is.
- `nav([...])` -- Creates an HTML `<nav>` element (semantic navigation container).
- `span("Current: {current_page}")` -- Creates an inline `<span>` with string interpolation showing the current page. Note: NOVA string interpolation uses `{expr}` directly inside quotes -- no prefix needed.
- `fn page_footer()` -- Returns a footer section that is identical on every page. Define it once, use it everywhere.
- `hr()` -- Creates a horizontal rule (`<hr>`) element -- a self-closing tag with no content.
- `fn page_layout(title, content)` -- The master layout function. It takes a title string and a list of content elements, wraps them in the standard page structure, and returns the complete HTML.
- In the route handlers, `page_layout("Home", [...])` and `page_layout("About", [...])` produce complete pages that share the same nav and footer but have different body content.

### Dynamic content from data

```nova
import forge
import forge_html

fn user_card(user)
    div([
        h("h3", user["name"]),
        p("Email: {user["email"]}"),
        p("Role: {user["role"]}")
    ])

fn user_list_page(users)
    html([
        h("h1", "Team Directory"),
        div(map(users, fn(u) user_card(u)))
    ])

fn main()
    app = forge.app()

    forge.get(app, "/team", fn(req)
        users = [
            {"name": "Alice", "email": "alice@co.com", "role": "Engineer"},
            {"name": "Bob", "email": "bob@co.com", "role": "Designer"},
            {"name": "Carol", "email": "carol@co.com", "role": "Manager"}
        ]
        forge.html(user_list_page(users))
    )

    forge.serve(app, 8080)
```

**Line-by-line explanation:**

- `fn user_card(user)` -- Takes a dict representing one user and returns an HTML fragment (a `<div>` with the user's info). This is the "component" pattern -- one function per visual unit.
- `div(map(users, fn(u) user_card(u)))` -- Uses `map` to transform a list of user dicts into a list of HTML elements, then wraps them in a `<div>`. This is the idiomatic way to render a list of items.
- The data (`users`) could come from a database query, an API call, or any other source. The HTML builder does not care where the data comes from.

### Complete list of available HTML functions

| Function | HTML element | Usage |
|----------|-------------|-------|
| `h(tag, text)` | Any tag | Generic element: `h("h1", "Title")` produces `<h1>Title</h1>` |
| `p(text)` | `<p>` | Paragraph |
| `div(children)` | `<div>` | Container (takes a list of child elements) |
| `span(text)` | `<span>` | Inline text container |
| `section(children)` | `<section>` | Semantic section |
| `article(children)` | `<article>` | Semantic article |
| `header(children)` | `<header>` | Page or section header |
| `footer(children)` | `<footer>` | Page or section footer |
| `nav(children)` | `<nav>` | Navigation container |
| `ul(children)` | `<ul>` | Unordered list (children should be `li` elements) |
| `ol(children)` | `<ol>` | Ordered (numbered) list |
| `li(text)` | `<li>` | List item |
| `table(children)` | `<table>` | Table (children should be `tr` elements) |
| `tr(children)` | `<tr>` | Table row (children should be `td` or `th`) |
| `td(text)` | `<td>` | Table data cell |
| `th(text)` | `<th>` | Table header cell |
| `img(src)` | `<img>` | Image (src is the URL) |
| `link(href, rel)` | `<link>` | Link (for stylesheets, etc.) |
| `meta(name, content)` | `<meta>` | Meta tag |
| `form(children)` | `<form>` | Form container |
| `input_tag(type, name)` | `<input>` | Input field (named `input_tag` to avoid conflict with NOVA built-in) |
| `button(text)` | `<button>` | Clickable button |
| `label(text)` | `<label>` | Form label |
| `a(href, text)` | `<a>` | Anchor link |
| `br()` | `<br>` | Line break (self-closing) |
| `hr()` | `<hr>` | Horizontal rule (self-closing) |
| `code(text)` | `<code>` | Inline code |
| `pre(text)` | `<pre>` | Preformatted text block |
| `em(text)` | `<em>` | Emphasized (italic) text |
| `strong(text)` | `<strong>` | Strong (bold) text |
| `raw(html_string)` | (none) | Insert raw HTML without escaping -- use only for trusted content |

### What NOT to do

```nova
// WRONG: building HTML by string concatenation
// This is fragile and vulnerable to XSS attacks
fn bad_page(username)
    "<html><body><h1>Hello " + username + "</h1></body></html>"
    // If username is: <script>alert('hacked')</script>
    // the browser executes the attacker's JavaScript!

// CORRECT: using the HTML builder
fn good_page(username)
    html([
        h("h1", "Hello {username}")
    ])
    // The builder escapes special characters in text content
```

```nova
// WRONG: using raw() with user-supplied data
fn unsafe_page(user_input)
    html([
        raw(user_input)   // NEVER do this -- raw() does not escape!
    ])

// CORRECT: only use raw() for trusted, developer-written HTML
fn safe_page()
    html([
        raw("<style>body \{ font-family: sans-serif; \}</style>")
    ])
```

### Real-world use case: admin dashboard

```nova
import forge
import forge_html

fn stat_card(label, value, color)
    div([
        h("h3", label),
        h("h2", str(value)),
        p("trend: {color}")
    ])

fn dashboard_page(stats)
    html([
        h("h1", "Admin Dashboard"),
        div([
            stat_card("Users", stats["users"], "green"),
            stat_card("Revenue", stats["revenue"], "blue"),
            stat_card("Errors", stats["errors"], "red")
        ]),
        table([
            tr([th("Metric"), th("Value"), th("Status")]),
            tr([td("Uptime"), td("99.97%"), td("OK")]),
            tr([td("Latency"), td("12ms"), td("OK")]),
            tr([td("Memory"), td("847MB"), td("WARN")])
        ])
    ])
```

---

## 30. Forge: advanced features

### What is this?

Sections 25-29 covered Forge's core features: routing, JSON APIs, databases, WebSocket, SSE (Server-Sent Events), authentication, and HTML building. This section covers the production-readiness features that every real web application needs: input validation (rejecting bad data before it reaches your logic), rate limiting (preventing abuse), CORS (Cross-Origin Resource Sharing, which controls which websites can call your API), static file serving, response customization, API documentation, health checks for container orchestrators, response compression, and request metrics for monitoring.

These features are all implemented as middleware or utility functions. Middleware is a function that wraps around your route handlers -- it runs before and/or after your handler, adding behavior without changing your route code.

### Input validation

**What is this?** Input validation means checking that data sent by a client (form fields, JSON bodies, query parameters) meets your requirements before you process it. Without validation, bad data flows into your database, crashes your logic, or creates security holes. Every production API validates every input.

```nova
import forge

fn main()
    app = forge.app()

    forge.post(app, "/register", fn(req)
        body = forge.body_json(req)
        errors = forge.validate(body, {
            "email": [forge.required(), forge.email()],
            "password": [forge.required(), forge.min_len(8)],
            "role": [forge.one_of(["user", "admin"])]
        })
        if len(errors) > 0
            return forge.errors_response(errors)
        // ... create user ...
        forge.json("{\"created\": true}")
    )

    forge.serve(app, 8080)
```

**Line-by-line explanation:**

- `body = forge.body_json(req)` -- Parses the request body as JSON (JavaScript Object Notation) and returns a NOVA dict. If the body is not valid JSON, this returns an empty dict.
- `errors = forge.validate(body, {...})` -- Validates the dict against a set of rules. The second argument is a dict where each key is a field name and each value is a list of validation rules.
- `forge.required()` -- The field must be present and non-empty. If the client omits `email`, this rule produces an error.
- `forge.email()` -- The field must look like a valid email address (contains `@`, has a domain part). This is a format check, not a deliverability check.
- `forge.min_len(8)` -- The field must be at least 8 characters long. For passwords, this enforces a minimum complexity.
- `forge.one_of(["user", "admin"])` -- The field's value must be one of the listed strings. Any other value produces an error.
- `if len(errors) > 0` -- If any validation rule failed, `errors` is a non-empty list of error descriptions.
- `return forge.errors_response(errors)` -- Returns a 422 (Unprocessable Entity) response with the validation errors as JSON. The `return` keyword is needed here for early exit -- without it, execution would continue to the user creation code.

**Available validation rules:**

| Rule | What it checks |
|------|---------------|
| `forge.required()` | Field must be present and non-empty |
| `forge.email()` | Must match email format (`user@domain.tld`) |
| `forge.min_len(n)` | String length must be at least `n` |
| `forge.max_len(n)` | String length must be at most `n` |
| `forge.one_of(list)` | Value must be one of the listed options |
| `forge.matches_re(pattern)` | Value must match the regex pattern |
| `forge.min_val(n)` | Numeric value must be at least `n` |
| `forge.max_val(n)` | Numeric value must be at most `n` |

**What NOT to do:**

```nova
// WRONG: processing input without validation
forge.post(app, "/register", fn(req)
    body = forge.body_json(req)
    // What if body["email"] is missing? Or body["password"] is ""?
    // What if body["role"] is "superadmin" (a role you don't support)?
    create_user(body["email"], body["password"], body["role"])
    forge.json("{\"created\": true}")
)

// CORRECT: always validate, then process
forge.post(app, "/register", fn(req)
    body = forge.body_json(req)
    errors = forge.validate(body, {
        "email": [forge.required(), forge.email()],
        "password": [forge.required(), forge.min_len(8)]
    })
    if len(errors) > 0
        return forge.errors_response(errors)
    create_user(body["email"], body["password"])
    forge.json("{\"created\": true}")
)
```

### Rate limiting

**What is this?** Rate limiting restricts how many requests a single client can make in a time window. Without it, a single user (or an automated script) can flood your server with thousands of requests per second, overwhelming it and denying service to everyone else. This is called a DoS (Denial of Service) attack.

```nova
forge.use(app, forge.mw_rate_limit(100, 60))  // 100 requests per 60 seconds
```

**Line-by-line explanation:**

- `forge.use(app, ...)` -- Installs a middleware function on the application. Middleware runs on every request before your route handler.
- `forge.mw_rate_limit(100, 60)` -- Creates a rate-limiting middleware. The first argument (`100`) is the maximum number of requests allowed. The second argument (`60`) is the time window in seconds. If a client exceeds 100 requests within any 60-second window, subsequent requests receive a 429 (Too Many Requests) response until the window resets.

### CORS (Cross-Origin Resource Sharing)

**What is this?** When a web page at `https://myapp.com` tries to call an API at `https://api.myapp.com`, the browser blocks the request by default. This is the Same-Origin Policy -- a security measure that prevents a malicious website from calling your API using your users' cookies. CORS headers tell the browser "yes, this other origin is allowed to call me." Without CORS configuration, your API works from command-line tools like curl but fails from browser JavaScript.

```nova
forge.use(app, forge.mw_cors())                      // allow all origins
forge.use(app, forge.mw_cors_origin("example.com"))   // specific origin
```

**Line-by-line explanation:**

- `forge.mw_cors()` -- Allows requests from ANY origin. This is convenient for development and public APIs but insecure for private APIs (any website could call your API and potentially act as the user).
- `forge.mw_cors_origin("example.com")` -- Only allows requests from `example.com`. The browser will block requests originating from any other domain.

**What NOT to do:**

```nova
// WRONG: using mw_cors() (allow-all) in production for a private API
// Any website can now call your API using your users' session cookies
forge.use(app, forge.mw_cors())

// CORRECT: restrict to your frontend domain(s)
forge.use(app, forge.mw_cors_origin("myapp.com"))
```

### Static files

**What is this?** Static files are files that the server sends to the browser without modification: images, CSS (Cascading Style Sheets) stylesheets, JavaScript files, downloadable PDFs, etc. Unlike API responses which are generated dynamically per request, static files are just read from disk and sent as-is.

```nova
forge.get(app, "/static/:file", fn(req)
    filename = forge.query_get(req, "file")
    forge.serve_file("public/" + filename)
)
```

**Line-by-line explanation:**

- `"/static/:file"` -- Route pattern with a parameter. `:file` captures whatever comes after `/static/` in the URL. For example, requesting `/static/style.css` sets the `file` parameter to `"style.css"`.
- `filename = forge.query_get(req, "file")` -- Retrieves the captured route parameter value.
- `forge.serve_file("public/" + filename)` -- Reads the file from the `public/` directory relative to the working directory and sends it as the response. The Content-Type header is set automatically based on the file extension (`.css` becomes `text/css`, `.png` becomes `image/png`, etc.).

**Security note:** In a production system, you should validate that `filename` does not contain `..` (path traversal) to prevent attackers from reading files outside the `public/` directory.

### Response headers and cookies

**What is this?** HTTP responses carry metadata in headers -- key-value pairs that tell the browser how to handle the response. Common uses include setting cache policies, security headers, and cookies. A cookie is a small piece of data the server asks the browser to store and send back with future requests -- this is how sessions, shopping carts, and "remember me" features work.

```nova
forge.get(app, "/", fn(req)
    resp = forge.resp_text("Hello")
    forge.resp_set_header(resp, "X-Custom", "value")
    forge.resp_set_cookie(resp, "session", "abc123")
    resp
)
```

**Line-by-line explanation:**

- `resp = forge.resp_text("Hello")` -- Creates a response object with a plain text body. Unlike `forge.text(...)` which returns the response directly, `forge.resp_text(...)` returns a response object that you can modify before sending.
- `forge.resp_set_header(resp, "X-Custom", "value")` -- Adds a custom HTTP header to the response. Headers starting with `X-` are, by convention, custom (non-standard) headers. Common standard headers you might set: `Cache-Control` (caching policy), `X-Frame-Options` (clickjacking prevention), `Content-Security-Policy` (XSS prevention).
- `forge.resp_set_cookie(resp, "session", "abc123")` -- Tells the browser to store a cookie named `"session"` with value `"abc123"`. The browser will send this cookie back with every future request to this domain.
- `resp` -- Returns the modified response object. This is the last expression in the function, so it becomes the return value.

### OpenAPI (Open Application Programming Interface) documentation

**What is this?** OpenAPI (formerly known as Swagger) is a standard format for describing REST APIs. An OpenAPI spec is a JSON file that lists every endpoint, what parameters it accepts, and what it returns. Tools like Swagger UI can read this spec and generate an interactive documentation page where developers can try your API directly from their browser. Forge can generate this spec automatically from your route registrations.

```nova
import forge

fn main()
    app = forge.app()
    forge.enable_docs(app)    // enables /openapi.json and /docs (Swagger UI)

    forge.get_doc(app, "/users", "List all users", fn(req)
        forge.json("[]")
    )

    forge.post_doc(app, "/users", "Create a user", fn(req)
        forge.json("{\"id\": 1}")
    )

    forge.serve(app, 8080)
```

**Line-by-line explanation:**

- `forge.enable_docs(app)` -- Activates the documentation system. This adds two automatic routes: `/openapi.json` (the machine-readable API spec) and `/docs` (a human-readable Swagger UI page).
- `forge.get_doc(app, "/users", "List all users", fn(req) ...)` -- Like `forge.get(...)` but also registers a description for the OpenAPI spec. The third argument (`"List all users"`) becomes the operation summary in the docs.
- `forge.post_doc(app, "/users", "Create a user", fn(req) ...)` -- Same pattern for POST routes. The description appears in the Swagger UI.

After starting the server, visit `http://localhost:8080/docs` in a browser to see the interactive documentation page.

### Health checks

**What is this?** Container orchestrators like Kubernetes, Docker Compose, and AWS ECS (Elastic Container Service) need to know if your application is alive and ready to handle requests. They do this by periodically sending HTTP requests to a health check endpoint. If the endpoint stops responding (or returns an error), the orchestrator restarts your container. There are two types: liveness checks ("is the process alive?") and readiness checks ("is it ready to accept traffic?").

```nova
forge.health_route(app, "/health")    // returns {"status": "ok"}
forge.readyz_route(app, "/readyz")    // readiness probe
```

**Line-by-line explanation:**

- `forge.health_route(app, "/health")` -- Registers a GET endpoint at `/health` that returns `{"status": "ok"}` with a 200 status code. This is the liveness probe. If your server can respond to this, it is alive.
- `forge.readyz_route(app, "/readyz")` -- Registers a GET endpoint at `/readyz` for readiness probes. This can include checks like "is the database connection working?" to signal that the app is not just alive but actually ready to serve user requests.

### Compression

**What is this?** HTTP responses can be large -- a JSON list of 10,000 users, an HTML page with many elements, etc. Compression (specifically gzip, a compression algorithm) reduces the response size by 60-90% for text content, which means faster page loads for users and lower bandwidth costs for you. The middleware automatically compresses responses when the client indicates it supports compression (via the `Accept-Encoding: gzip` request header).

```nova
forge.use(app, forge.mw_compress())   // gzip responses automatically
```

**Line-by-line explanation:**

- `forge.mw_compress()` -- Creates a middleware that checks each response: if the response body is text-based (HTML, JSON, CSS, JavaScript) and the client supports gzip, the middleware compresses the body and sets the `Content-Encoding: gzip` header. Binary responses (images, already-compressed files) are left unchanged.

### Request metrics

**What is this?** Monitoring systems like Prometheus, Grafana, and Datadog need to collect metrics from your application: how many requests per second, what the response times are, how many errors are occurring. The metrics middleware tracks these numbers automatically. The `/metrics` endpoint exposes them in Prometheus format (a text-based format that monitoring tools can scrape).

```nova
forge.use(app, forge.mw_metrics())
forge.get(app, "/metrics", fn(req)
    forge.text(forge.metrics_prometheus())
)
```

**Line-by-line explanation:**

- `forge.use(app, forge.mw_metrics())` -- Installs a middleware that records the start time, end time, status code, and path for every request. This data accumulates in memory.
- `forge.get(app, "/metrics", fn(req) ...)` -- Registers an endpoint that exposes the accumulated metrics.
- `forge.metrics_prometheus()` -- Formats all recorded metrics as a Prometheus-compatible text string. Prometheus scrapes this endpoint at regular intervals (typically every 15-30 seconds) and stores the data for graphing and alerting.

### Real-world use case: production-ready API setup

Here is how you would combine all of these features in a real production application:

```nova
import forge

fn main()
    app = forge.app()

    // Production middleware stack (order matters)
    forge.use(app, forge.mw_metrics())              // track request metrics
    forge.use(app, forge.mw_compress())              // compress responses
    forge.use(app, forge.mw_cors_origin("myapp.com"))  // CORS for browser clients
    forge.use(app, forge.mw_rate_limit(1000, 60))   // 1000 req/min per client

    // Health checks for Kubernetes
    forge.health_route(app, "/health")
    forge.readyz_route(app, "/readyz")

    // API documentation
    forge.enable_docs(app)

    // Metrics endpoint for Prometheus
    forge.get(app, "/metrics", fn(req)
        forge.text(forge.metrics_prometheus())
    )

    // Application routes
    forge.post_doc(app, "/api/users", "Create user", fn(req)
        body = forge.body_json(req)
        errors = forge.validate(body, {
            "email": [forge.required(), forge.email()],
            "name": [forge.required(), forge.min_len(1)]
        })
        if len(errors) > 0
            return forge.errors_response(errors)
        // ... create user in database ...
        forge.json("{\"id\": 1, \"created\": true}")
    )

    forge.serve(app, 8080)
```

---

## 31. FFI (Foreign Function Interface): calling C

### What is this?

Every programming language exists inside an ecosystem of existing code. Billions of lines of C code have been written over the past 50 years: operating system APIs, database engines, image processing libraries, compression algorithms, cryptographic primitives, scientific computing libraries, and more. A new language that cannot use this existing code forces its users to rewrite everything from scratch -- an impractical demand.

An FFI (Foreign Function Interface) is the mechanism that lets one language call functions written in another language. NOVA's FFI lets you call C functions directly. This means you can use any C library -- SQLite, OpenSSL, zlib, libcurl, POSIX system calls, Windows APIs -- from NOVA code.

**How it works under the hood:**

1. You declare a C function's signature using `extern fn`, telling NOVA the function's name, parameter types, and return type.
2. The NOVA compiler generates LLVM IR (Intermediate Representation) code that calls the function using the C calling convention (the standard rules for how arguments are passed in registers/stack and how return values are retrieved).
3. At link time, the linker resolves the function name to the actual compiled C code in a shared library (`.dll` on Windows, `.so` on Linux, `.dylib` on macOS) or a static library (`.lib`/`.a`).
4. At runtime, the CPU executes the C function directly -- there is no wrapper, no translation, no overhead. The call is as fast as a C-to-C function call.

### Basic FFI: calling the C standard library

```nova
extern fn puts(s: string) -> int

puts("Hello from C!")
```

**Line-by-line explanation:**

- `extern fn puts(s: string) -> int` -- Declares a function named `puts` that exists in external (C) code. The `extern` keyword tells the compiler "do not look for this function in NOVA source code; it will be provided by a linked C library." The parameter `s: string` maps to C's `char*` (a pointer to a null-terminated character array). The return type `-> int` maps to C's `int`. The C standard library function `puts()` writes a string to standard output followed by a newline and returns a non-negative number on success.
- `puts("Hello from C!")` -- Calls the C function. NOVA strings are internally represented as null-terminated C strings, so they can be passed directly to C functions that expect `char*`.

NOVA links against the C standard library by default, so you do not need any `@link` annotation to call functions like `puts`, `printf`, `strlen`, `memcpy`, `malloc`, `free`, `fopen`, etc.

### Calling math functions from libm

```nova
extern fn pow(base: float, exp: float) -> float
extern fn sin(x: float) -> float
extern fn cos(x: float) -> float
extern fn sqrt(x: float) -> float

print(pow(2.0, 10.0))    // 1024.0
print(sin(3.14159))      // ~0.0 (sine of pi radians is approximately zero)
print(cos(0.0))          // 1.0  (cosine of 0 radians is exactly 1)
print(sqrt(144.0))       // 12.0
```

**Line-by-line explanation:**

- `extern fn pow(base: float, exp: float) -> float` -- Declares the C math library function `pow()` which computes `base` raised to the power `exp`. In C, this function takes two `double` arguments and returns a `double`. NOVA's `float` type maps to C's `double` (64-bit IEEE 754 floating point).
- `extern fn sin(x: float) -> float` -- The sine function. Takes an angle in radians (not degrees). To convert degrees to radians, multiply by `3.14159265 / 180.0`.
- The remaining declarations follow the same pattern. Each tells the NOVA compiler "this function exists in C with this signature."
- The function calls (`pow(2.0, 10.0)`, etc.) work exactly like calling any NOVA function. The compiler generates a standard C-calling-convention call.

Note: NOVA also has built-in `pow`, `sin`, `cos`, `sqrt` functions that you can use without `extern fn`. The FFI declarations above are shown for pedagogical purposes -- in practice you would use the built-ins.

### Calling SQLite directly

```nova
extern fn sqlite3_open(path: string, db: ptr) -> int
extern fn sqlite3_exec(db: ptr, sql: string, cb: ptr, arg: ptr, err: ptr) -> int
extern fn sqlite3_close(db: ptr) -> int

@link("sqlite3")
```

**Line-by-line explanation:**

- `extern fn sqlite3_open(path: string, db: ptr) -> int` -- Declares the SQLite function that opens (or creates) a database file. The `path` is the file path as a string. The `db` parameter is a pointer to a pointer (in C: `sqlite3**`) -- SQLite writes the database handle into this location. NOVA's `ptr` type maps to C's `void*`, the generic pointer type. The return value is an integer status code (0 means success, non-zero means error).
- `extern fn sqlite3_exec(db: ptr, sql: string, cb: ptr, arg: ptr, err: ptr) -> int` -- Executes an SQL statement. `db` is the database handle from `sqlite3_open`. `sql` is the SQL text. `cb` is a callback function pointer (pass `null` if you do not need per-row callbacks). `arg` is a user data pointer passed to the callback. `err` is a pointer where SQLite writes an error message string if something goes wrong.
- `extern fn sqlite3_close(db: ptr) -> int` -- Closes the database connection and frees associated resources.
- `@link("sqlite3")` -- This annotation tells the linker to link against the SQLite library. On Linux this finds `libsqlite3.so`, on macOS `libsqlite3.dylib`, on Windows `sqlite3.dll` (or `sqlite3.lib` for static linking). Without this annotation, the linker would report "undefined symbol: sqlite3_open" because it would not know where to find the SQLite code.

### The `@link` annotation: how linking works

When you compile a NOVA program, the process has two phases:

1. **Compilation** -- The NOVA compiler translates your `.nova` source code into LLVM IR, and then LLVM compiles the IR into machine code (a `.o` object file). At this stage, external function calls are recorded as unresolved symbols -- the compiler knows the function's name and signature but not where the code lives.

2. **Linking** -- The linker combines your object file with library files to produce the final executable. It resolves every unresolved symbol by finding it in a library. The `@link("name")` annotation tells the linker which libraries to search.

```nova
@link("m")         // libm: advanced math functions (pow, sin, cos, etc.)
@link("sqlite3")   // libsqlite3: the SQLite database engine
@link("ssl")       // libssl: OpenSSL's SSL/TLS implementation
@link("crypto")    // libcrypto: OpenSSL's cryptographic primitives
@link("z")         // libz (zlib): compression/decompression
@link("curl")      // libcurl: HTTP client, FTP, and more
@link("pthread")   // libpthread: POSIX threads (Linux/macOS)
```

Each `@link("name")` annotation maps to a linker flag `-lname`. The linker searches standard library paths (`/usr/lib`, `/usr/local/lib`, the system library directory) for a file named `libname.so` (Linux), `libname.dylib` (macOS), or `name.lib`/`name.dll` (Windows).

### Complete type mapping between C and NOVA

When declaring `extern fn`, you must use the correct NOVA type for each C parameter and return type. If the types do not match, the function call will produce garbage results or crash -- the compiler cannot verify C function signatures.

| C type | NOVA type | Size (bytes) | Notes |
|--------|-----------|-------------|-------|
| `int` | `int` | 4 (C) / 8 (NOVA) | NOVA `int` is always 64-bit. C `int` is typically 32-bit. NOVA handles the conversion automatically for return values, but passing a NOVA int larger than 2,147,483,647 to a C function expecting `int` will truncate silently. |
| `long` | `int` | 4 or 8 (C) / 8 (NOVA) | C `long` is 4 bytes on Windows, 8 bytes on Linux/macOS. NOVA `int` is always 8 bytes. |
| `long long` | `int` | 8 | Exact match on all platforms. |
| `size_t` | `int` | 8 | Both are 64-bit unsigned/signed. |
| `double` | `float` | 8 | Exact match: both are IEEE 754 64-bit double-precision. |
| `float` (C) | `float` | 4 (C) / 8 (NOVA) | NOVA does not have a 32-bit float type. Passing `float` to a C function expecting C's 32-bit `float` requires care -- the C calling convention promotes `float` to `double` in variadic functions but not in fixed-parameter functions. |
| `char*` | `string` | pointer | NOVA strings are null-terminated, so they can be passed directly as `char*`. |
| `const char*` | `string` | pointer | Same as `char*` for read-only C parameters. |
| `void*` | `ptr` | pointer | Generic pointer. Used for handles, opaque structures, raw memory. |
| `FILE*` | `ptr` | pointer | File handle. Opaque to NOVA code. |
| `struct foo*` | `ptr` | pointer | Pointer to any C struct. NOVA cannot access C struct fields directly -- you must call C functions that operate on the struct. |
| `int (*)(...)` | `ptr` | pointer | Function pointer. Pass NOVA function pointers as `ptr` for C callbacks. |
| `void` (return) | (omit `->`) | 0 | If a C function returns `void`, omit the `-> type` part of the declaration. |

### Safety concerns with FFI

C code does not have NOVA's safety guarantees. When you call a C function:

- **No bounds checking.** C functions can read and write beyond array boundaries, causing memory corruption.
- **No null checking.** Passing `null` where a C function expects a valid pointer causes a segmentation fault (crash).
- **No type checking across the boundary.** If your `extern fn` declaration does not match the actual C function's signature, the call will pass wrong data and the behavior is undefined.
- **Resource leaks.** C functions that allocate memory (like `malloc`, `sqlite3_open`, `fopen`) require you to manually free that memory (via `free`, `sqlite3_close`, `fclose`). NOVA's memory management does not track C-allocated resources.
- **Thread safety is your responsibility.** C libraries may use global state that is not thread-safe. Calling such functions from multiple green tasks concurrently can cause data corruption.

For these reasons, wrap C FFI calls in `unsafe` blocks when they involve raw pointers or memory manipulation. See Section 32 for details.

### Real-world example: building a complete FFI binding

Here is a complete example that uses raw pointer operations with FFI:

```nova
extern fn qsort(base: ptr, nmemb: int, size: int, compar: ptr) -> int

unsafe
    // Allocate space for 5 integers (5 * 8 bytes = 40 bytes)
    arr = alloc_raw(40)

    // Write 5 unsorted values
    ptr_write(arr, 0, 50)
    ptr_write(arr, 8, 20)
    ptr_write(arr, 16, 40)
    ptr_write(arr, 24, 10)
    ptr_write(arr, 32, 30)

    // Note: qsort requires a comparison function pointer.
    // In practice, you would use NOVA's built-in sort() instead.
    // This example shows the FFI mechanics.

    // Read values back
    for i in 0..4
        val = ptr_read(arr, i * 8)
        print("arr[{i}] = {val}")

    free_raw(arr)
```

**Line-by-line explanation:**

- `extern fn qsort(base: ptr, nmemb: int, size: int, compar: ptr) -> int` -- Declares C's `qsort`. `base` is a pointer to the array. `nmemb` is the number of elements. `size` is the size of each element in bytes. `compar` is a pointer to a comparison function.
- `unsafe` -- Enters an unsafe block because we are doing raw pointer operations (`alloc_raw`, `ptr_write`, `ptr_read`, `free_raw`). See Section 32 for why unsafe blocks exist.
- `arr = alloc_raw(40)` -- Allocates 40 bytes of raw memory (5 integers, each 8 bytes on a 64-bit system).
- `ptr_write(arr, 0, 50)` -- Writes the integer value `50` at byte offset `0` from the base pointer.
- `ptr_write(arr, 8, 20)` -- Writes `20` at byte offset `8` (the second 8-byte slot).
- `ptr_read(arr, i * 8)` -- Reads an integer from the given byte offset.
- `free_raw(arr)` -- Frees the raw memory. Forgetting this causes a memory leak.

### What NOT to do

```nova
// WRONG: declaring the wrong types in extern fn
// C's fopen returns FILE*, not int
extern fn fopen(path: string, mode: string) -> int  // BUG!
// This compiles but returns garbage -- the pointer is truncated to an int

// CORRECT:
extern fn fopen(path: string, mode: string) -> ptr
extern fn fclose(fp: ptr) -> int
```

```nova
// WRONG: forgetting @link for non-standard-library functions
extern fn sqlite3_open(path: string, db: ptr) -> int
// Compiles, but linking fails: "undefined symbol: sqlite3_open"

// CORRECT: tell the linker where to find the function
extern fn sqlite3_open(path: string, db: ptr) -> int
@link("sqlite3")
```

```nova
// WRONG: forgetting to free C-allocated resources
extern fn fopen(path: string, mode: string) -> ptr
fp = fopen("data.txt", "r")
// ... use fp ...
// BUG: never called fclose(fp) -- file handle leak!
// After ~1000 opens, the OS runs out of file descriptors and all opens fail.

// CORRECT: always close/free in a finally or cleanup pattern
extern fn fclose(fp: ptr) -> int
fp = fopen("data.txt", "r")
// ... use fp ...
fclose(fp)
```

---

## 32. Unsafe and low-level

### What is this?

NOVA is a safe language by default. The compiler and runtime work together to prevent entire categories of bugs: buffer overflows (reading/writing past the end of an array), use-after-free (using memory that has already been deallocated), null pointer dereferences (following a pointer that points to nothing), data races (two tasks modifying the same data simultaneously), and integer overflow (arithmetic that wraps around silently). These bugs are responsible for roughly 70% of all security vulnerabilities in C and C++ software (according to Microsoft and Google's own analyses of their codebases).

However, some legitimate programming tasks require stepping outside these safety guarantees:

1. **Raw memory manipulation** -- Writing a custom allocator, implementing a data structure with pointer tricks, or interacting with memory-mapped hardware.
2. **Calling C functions that use raw pointers** -- Many C APIs pass data through `void*` pointers that NOVA cannot type-check.
3. **Interfacing with the operating system** -- System calls, device drivers, and hardware registers require reading and writing specific memory addresses.
4. **Performance-critical inner loops** -- In rare cases, removing bounds checks on array access can improve performance in a tight loop that has been proven correct by other means.

The `unsafe` block is NOVA's escape hatch. Code inside `unsafe` can perform operations that the compiler normally forbids. The key insight is that `unsafe` does not turn off safety everywhere -- it creates a clearly marked, auditable region where the developer takes responsibility for correctness.

**Why not just make everything safe?** Because some operations are inherently impossible to verify at compile time. For example, when you call `ptr_write(ptr, offset, value)`, the compiler cannot know whether `ptr + offset` is a valid memory address -- that depends on how `ptr` was allocated, how much memory is available, whether the memory has been freed, etc. The compiler would need to solve the halting problem to verify these things, which is mathematically impossible. So instead, NOVA asks you to put these operations in `unsafe` blocks, making them visible and auditable.

### Basic unsafe: allocating and using raw memory

```nova
unsafe
    // Allocate 100 bytes of raw memory, initialized to zero
    buf = alloc_raw(100)

    // Write individual bytes (unsigned 8-bit values, range 0-255)
    ptr_write_u8(buf, 0, 72)    // byte at offset 0 = 72  (ASCII 'H')
    ptr_write_u8(buf, 1, 105)   // byte at offset 1 = 105 (ASCII 'i')
    ptr_write_u8(buf, 2, 33)    // byte at offset 2 = 33  (ASCII '!')

    // Read individual bytes back
    print(ptr_read_u8(buf, 0))  // 72
    print(ptr_read_u8(buf, 1))  // 105
    print(ptr_read_u8(buf, 2))  // 33

    // CRITICAL: free the memory when done
    // Forgetting this line causes a memory leak
    free_raw(buf)
```

**Line-by-line explanation:**

- `unsafe` -- Begins an unsafe block. All indented lines below this are inside the block. NOVA uses indentation-based blocks (like Python), so there is no closing brace or `end` keyword.
- `buf = alloc_raw(100)` -- Allocates 100 bytes of contiguous memory from the operating system's heap. Returns a raw pointer (`ptr`) to the first byte. If the OS cannot allocate the memory (extremely rare, means the system is out of memory), this returns a null pointer. In safe NOVA code, `alloc_raw` is not available -- you would use lists, dicts, or structs instead.
- `ptr_write_u8(buf, 0, 72)` -- Writes a single unsigned 8-bit byte at the given offset. Three arguments: the base pointer, the byte offset from the base, and the value (0-255). The value 72 is the ASCII code for the character 'H'. You can find ASCII values in any ASCII table, or compute them in NOVA with `ord("H")` which returns 72.
- `ptr_read_u8(buf, 0)` -- Reads a single unsigned 8-bit byte. Returns an integer (0-255).
- `free_raw(buf)` -- Returns the memory to the OS. After this call, `buf` is a dangling pointer -- using it is undefined behavior (the memory may be reused for something else, and reading/writing it corrupts arbitrary data).

### Pointer arithmetic: working with typed memory slots

Raw pointers address memory at the byte level. When storing NOVA integers (which are 8 bytes each), you must calculate byte offsets manually:

```nova
unsafe
    // Allocate space for 5 NOVA integers: 5 * 8 bytes = 40 bytes
    base = alloc_raw(40)

    // Write 5 integer values at 8-byte intervals
    i = 0
    while i < 5
        ptr_write(base, i * 8, i * 100)
        i = i + 1
    // Memory layout after this loop:
    // Offset 0:  value 0   (0 * 100)
    // Offset 8:  value 100 (1 * 100)
    // Offset 16: value 200 (2 * 100)
    // Offset 24: value 300 (3 * 100)
    // Offset 32: value 400 (4 * 100)

    // Read them back
    i = 0
    while i < 5
        val = ptr_read(base, i * 8)
        print("slot {i} = {val}")
        i = i + 1
    // Output:
    // slot 0 = 0
    // slot 1 = 100
    // slot 2 = 200
    // slot 3 = 300
    // slot 4 = 400

    free_raw(base)
```

**Line-by-line explanation:**

- `base = alloc_raw(40)` -- 5 slots times 8 bytes per slot = 40 bytes total.
- `ptr_write(base, i * 8, i * 100)` -- `ptr_write` writes a full 8-byte NOVA integer (unlike `ptr_write_u8` which writes a single byte). The offset is in bytes, so slot `i` starts at byte `i * 8`.
- `ptr_read(base, i * 8)` -- Reads an 8-byte NOVA integer from the given byte offset.
- The `while` loop is used instead of `for` because this is low-level code where explicit control is clearer.

### What can go wrong: the dangers of unsafe code

Here are the specific bugs that unsafe code can introduce:

**1. Buffer overflow -- writing past the end of allocated memory:**

```nova
unsafe
    buf = alloc_raw(10)      // only 10 bytes
    ptr_write(buf, 80, 999)  // writing at byte 80 -- past the end!
    // This corrupts whatever data lives at buf+80.
    // Could crash, could silently corrupt another variable,
    // could be exploited by an attacker to execute arbitrary code.
    free_raw(buf)
```

**2. Use-after-free -- using memory that has been freed:**

```nova
unsafe
    buf = alloc_raw(100)
    free_raw(buf)
    val = ptr_read(buf, 0)   // BUG: reading freed memory!
    // buf still holds the old address, but the memory may have been
    // reused for something else. You read garbage or crash.
```

**3. Double free -- freeing the same memory twice:**

```nova
unsafe
    buf = alloc_raw(100)
    free_raw(buf)
    free_raw(buf)             // BUG: double free!
    // The memory allocator's internal data structures are corrupted.
    // Future allocations may return overlapping memory regions,
    // causing silent data corruption.
```

**4. Memory leak -- forgetting to free:**

```nova
unsafe
    buf = alloc_raw(1000000)  // 1 MB (megabyte)
    // ... use buf ...
    // BUG: never freed! This 1 MB is permanently leaked.
    // In a server that handles 1000 requests/second, this leaks
    // 1 GB (gigabyte) per second and crashes in minutes.
```

### Atomic operations

**What is this?** When multiple green tasks (or OS threads) need to read and modify a shared counter, list, or flag, they must coordinate to avoid data races. The simplest coordination mechanism is an atomic operation -- a single CPU instruction that reads, modifies, and writes a value in one indivisible step. No other thread can see the value in a half-modified state.

Atomic operations do NOT require an `unsafe` block because they are safe by design -- the hardware guarantees they cannot corrupt memory.

```nova
// Create an atomic counter initialized to 0
counter = atomic_new(0)
print(atomic_get(counter))         // 0

// Add 5 atomically (no race condition even if multiple tasks do this)
atomic_add(counter, 5)
print(atomic_get(counter))         // 5

// Subtract 2 atomically
atomic_sub(counter, 2)
print(atomic_get(counter))         // 3

// CAS (Compare-And-Swap): the fundamental building block of lock-free code
// "If counter is currently 3, change it to 10. Tell me what it was."
old = atomic_cas(counter, 3, 10)
print(old)                         // 3 (it was 3, so the swap happened)
print(atomic_get(counter))         // 10

// CAS that fails (because counter is now 10, not 3)
old = atomic_cas(counter, 3, 999)
print(old)                         // 10 (it was NOT 3, so no swap happened)
print(atomic_get(counter))         // 10 (unchanged)
```

**Line-by-line explanation:**

- `atomic_new(0)` -- Creates a new atomic variable with initial value 0. Internally this is a memory location with special hardware-level access guarantees.
- `atomic_get(counter)` -- Reads the current value atomically. Even if another task is writing to `counter` at the exact same instant, `atomic_get` returns a complete, consistent value -- never a half-written one.
- `atomic_add(counter, 5)` -- Atomically adds 5. This is a single CPU instruction (`lock xadd` on x86). It is impossible for two concurrent `atomic_add` calls to lose an update (a problem called a "lost update" that happens with non-atomic `counter = counter + 5`).
- `atomic_cas(counter, 3, 10)` -- CAS stands for Compare-And-Swap. It atomically performs: "read the current value; if it equals the expected value (3), replace it with the new value (10); return the value that was read." If the current value is NOT the expected value, the swap does not happen. CAS is the building block for lock-free data structures (queues, stacks, hash maps that work without mutexes).

**Available atomic operations:**

| Function | What it does |
|----------|-------------|
| `atomic_new(initial)` | Create a new atomic variable |
| `atomic_get(a)` | Read the current value |
| `atomic_set(a, v)` | Set to a new value |
| `atomic_add(a, n)` | Add `n` (returns previous value) |
| `atomic_sub(a, n)` | Subtract `n` (returns previous value) |
| `atomic_cas(a, expected, desired)` | Compare-and-swap (returns previous value) |

### Rules for writing unsafe code

> **DO:** Keep unsafe blocks as small as possible. A 3-line unsafe block that allocates, writes, and frees is easy to audit. A 300-line unsafe block is not.
>
> **DO:** Document every pointer's lifetime. Write a comment explaining when the pointer was allocated and when it will be freed.
>
> **DO:** Free every allocation on every code path, including error paths. If a function has an early `return` after `alloc_raw`, make sure `free_raw` happens before the return.
>
> **DON'T:** Use `unsafe` to work around type errors. If the compiler says two types do not match, the fix is to correct the types, not to cast through raw pointers.
>
> **DON'T:** Store raw pointers in data structures that outlive the unsafe block. The pointer becomes a dangling reference when the memory is freed.
>
> **DON'T:** Use raw pointers for tasks that safe NOVA handles. Need an array? Use a list. Need key-value storage? Use a dict. Need a buffer? Use `bytes`. Raw pointers are for interfacing with C code and hardware, not for everyday programming.

---

## 33. Bytes and binary data

### What is this?

Computers ultimately work with binary data -- sequences of 0s and 1s grouped into 8-bit bytes (values 0 through 255). Text (strings) is one way to interpret bytes (using encoding schemes like ASCII or UTF-8), but many kinds of data are not text:

- **Network protocols** -- TCP packets, DNS queries, TLS handshakes are all binary. An HTTP/2 frame starts with a 3-byte length field, a 1-byte type field, and a 1-byte flags field -- none of which are human-readable text.
- **File formats** -- PNG images start with the bytes `[137, 80, 78, 71, 13, 10, 26, 10]`. ZIP files start with `[80, 75, 3, 4]`. PDF files start with `[37, 80, 68, 70]` (which happens to be the ASCII text `%PDF`). All of these contain binary data that cannot be meaningfully represented as strings.
- **Cryptographic operations** -- Hash functions, encryption algorithms, and digital signatures operate on raw bytes, not strings. A SHA-256 (Secure Hash Algorithm, 256-bit) digest is 32 bytes that can contain any value 0-255, including bytes that are not valid UTF-8 characters.
- **Hardware communication** -- Sensor data, serial port communication, and USB device protocols use raw byte sequences.

NOVA's `bytes` type is a mutable array of raw bytes. Unlike strings (which are sequences of characters with encoding), bytes are just numbers from 0 to 255 with no encoding assumption.

**Bytes vs. strings:**

| Property | `string` | `bytes` |
|----------|----------|---------|
| Content | Human-readable text | Raw binary data |
| Values | Unicode characters | Integers 0-255 |
| Encoding | UTF-8 | None (raw) |
| Mutability | Immutable | Mutable |
| Use case | Text processing, display | Protocols, files, crypto |

### Creating bytes

```nova
// Create a byte array of 10 bytes, all initialized to zero
buf = bytes(10)
print(bytes_len(buf))     // 10
print(bytes_get(buf, 0))  // 0
```

**Line-by-line explanation:**

- `buf = bytes(10)` -- Allocates a byte buffer of 10 bytes. All bytes are initialized to 0. This is analogous to `calloc(10, 1)` in C. The argument is the number of bytes, not bits. 10 bytes = 80 bits.
- `bytes_len(buf)` -- Returns the number of bytes in the buffer. Unlike `len()` for strings (which returns character count), `bytes_len()` always returns the exact byte count.
- `bytes_get(buf, 0)` -- Returns the byte value at index 0 as an integer (0-255). Indices start at 0, so a 10-byte buffer has valid indices 0 through 9.

### Setting and getting individual bytes

```nova
buf = bytes(10)
bytes_set(buf, 0, 72)     // byte 0 = 72  = ASCII 'H'
bytes_set(buf, 1, 101)    // byte 1 = 101 = ASCII 'e'
bytes_set(buf, 2, 108)    // byte 2 = 108 = ASCII 'l'
bytes_set(buf, 3, 108)    // byte 3 = 108 = ASCII 'l'
bytes_set(buf, 4, 111)    // byte 4 = 111 = ASCII 'o'

print(bytes_get(buf, 0))  // 72
print(bytes_get(buf, 4))  // 111
```

**Line-by-line explanation:**

- `bytes_set(buf, 0, 72)` -- Sets byte at index 0 to the value 72. The three arguments are: the byte buffer, the index (0-based), and the value (0-255). The value 72 is the ASCII code for the character 'H'. You can find ASCII values in any ASCII table, or compute them in NOVA with `ord("H")` which returns 72.
- `bytes_get(buf, 4)` -- Returns the byte value at index 4 as a NOVA integer. The returned value is always in the range 0-255.

### Converting between strings and bytes

Strings and bytes are different types in NOVA, but you often need to convert between them. A string is text with a known character encoding (NOVA uses UTF-8). Bytes are raw data. Converting from string to bytes gives you the UTF-8 encoded form. Converting from bytes to string interprets the bytes as UTF-8 text.

```nova
// String to bytes: get the UTF-8 encoded byte representation
data = str_to_bytes("NOVA")
print(bytes_len(data))         // 4 (each ASCII char is 1 byte in UTF-8)
print(bytes_get(data, 0))     // 78  (ASCII code for 'N')
print(bytes_get(data, 1))     // 79  (ASCII code for 'O')
print(bytes_get(data, 2))     // 86  (ASCII code for 'V')
print(bytes_get(data, 3))     // 65  (ASCII code for 'A')

// Bytes to string: interpret bytes as UTF-8 text
buf = bytes(5)
bytes_set(buf, 0, 72)    // H
bytes_set(buf, 1, 101)   // e
bytes_set(buf, 2, 108)   // l
bytes_set(buf, 3, 108)   // l
bytes_set(buf, 4, 111)   // o
text = bytes_to_str(buf)
print(text)               // Hello
```

**Line-by-line explanation:**

- `str_to_bytes("NOVA")` -- Converts the string "NOVA" into its UTF-8 byte representation. For ASCII characters (English letters, digits, basic punctuation), each character is exactly 1 byte. For non-ASCII characters (accented letters, Chinese characters, emoji), a single character may be 2, 3, or 4 bytes in UTF-8. For example, `str_to_bytes("cafe")` is 4 bytes, but `str_to_bytes("café")` is 5 bytes because the accented 'e' is 2 bytes in UTF-8.
- `bytes_to_str(buf)` -- Interprets the byte buffer as a UTF-8 encoded string. If the bytes are not valid UTF-8, the result may contain replacement characters or be truncated.

### Slicing bytes

```nova
data = str_to_bytes("NOVA")
sub = bytes_slice(data, 1, 3)
print(bytes_len(sub))          // 2
print(bytes_to_str(sub))       // OV
```

**Line-by-line explanation:**

- `bytes_slice(data, 1, 3)` -- Creates a new byte buffer containing bytes from index 1 up to (but not including) index 3. This is the same half-open interval convention used by NOVA string slicing. Index 1 is 'O' (79), index 2 is 'V' (86). Index 3 is excluded.

### Byte overflow wrapping

Byte values are always in the range 0-255. If you set a value outside this range, it wraps around using modular arithmetic (value modulo 256). This is the same behavior as an unsigned 8-bit integer in C.

```nova
buf = bytes(1)
bytes_set(buf, 0, 256)
print(bytes_get(buf, 0))   // 0   (256 % 256 = 0)

bytes_set(buf, 0, 300)
print(bytes_get(buf, 0))   // 44  (300 % 256 = 44)

bytes_set(buf, 0, -1)
print(bytes_get(buf, 0))   // 255 (-1 wraps to 255 in unsigned byte arithmetic)

bytes_set(buf, 0, 511)
print(bytes_get(buf, 0))   // 255 (511 % 256 = 255)
```

### Endianness: byte order matters

**What is this?** When you store a multi-byte number (like an integer that needs 2 or 4 bytes), the bytes can be arranged in two orders:

- **Little-endian** -- Least significant byte first. The value 1000 (hex 0x03E8) is stored as `[0xE8, 0x03]`. Intel/AMD processors (x86/x64) use this. Most of the world's computers are little-endian.
- **Big-endian** (also called "network byte order") -- Most significant byte first. The value 1000 is stored as `[0x03, 0xE8]`. Network protocols (TCP, IP, DNS, HTTP/2) use this by convention.

When reading or writing multi-byte values in binary protocols, you must know which byte order is expected. Getting it wrong makes 1000 look like 59395 (because `0xE8 * 256 + 0x03 = 59395`).

```nova
// Encode a 32-bit integer in little-endian byte order (4 bytes)
fn encode_u32_le(value)
    buf = bytes(4)
    bytes_set(buf, 0, value % 256)
    bytes_set(buf, 1, (value / 256) % 256)
    bytes_set(buf, 2, (value / 65536) % 256)
    bytes_set(buf, 3, (value / 16777216) % 256)
    buf

// Encode a 32-bit integer in big-endian byte order (network order)
fn encode_u32_be(value)
    buf = bytes(4)
    bytes_set(buf, 3, value % 256)
    bytes_set(buf, 2, (value / 256) % 256)
    bytes_set(buf, 1, (value / 65536) % 256)
    bytes_set(buf, 0, (value / 16777216) % 256)
    buf

// Decode a 32-bit big-endian integer from bytes
fn decode_u32_be(buf, offset)
    b0 = bytes_get(buf, offset)
    b1 = bytes_get(buf, offset + 1)
    b2 = bytes_get(buf, offset + 2)
    b3 = bytes_get(buf, offset + 3)
    b0 * 16777216 + b1 * 65536 + b2 * 256 + b3
```

**Line-by-line explanation:**

- `value % 256` -- Extracts the least significant byte (the lowest 8 bits). For value = 1000, this is 232 (0xE8).
- `(value / 256) % 256` -- Integer-divides by 256 (right-shifts by 8 bits), then takes the lowest byte. For value = 1000, this is 3 (0x03).
- `(value / 65536) % 256` -- Extracts the third byte (bits 16-23). 65536 = 256 * 256 = 2^16.
- `(value / 16777216) % 256` -- Extracts the fourth byte (bits 24-31). 16777216 = 256^3 = 2^24.
- In big-endian, the most significant byte goes at offset 0. In little-endian, it goes at the highest offset.

### Binary protocol example: length-prefixed messages

Many network protocols frame messages by sending the message length first, then the message data. The receiver reads the length, then reads exactly that many bytes to get the complete message. This is how protocols avoid the "where does one message end and the next begin?" problem.

```nova
// Build a length-prefixed message:
// [length as 4-byte big-endian integer] [payload bytes]
fn encode_message(msg)
    data = str_to_bytes(msg)
    length = bytes_len(data)
    header = bytes(4)
    // Encode length as 4-byte big-endian (network byte order)
    bytes_set(header, 0, (length / 16777216) % 256)
    bytes_set(header, 1, (length / 65536) % 256)
    bytes_set(header, 2, (length / 256) % 256)
    bytes_set(header, 3, length % 256)
    bytes_concat(header, data)

// Decode a length-prefixed message
fn decode_message(raw)
    // Read the 4-byte length header
    b0 = bytes_get(raw, 0)
    b1 = bytes_get(raw, 1)
    b2 = bytes_get(raw, 2)
    b3 = bytes_get(raw, 3)
    length = b0 * 16777216 + b1 * 65536 + b2 * 256 + b3
    // Extract the payload
    payload = bytes_slice(raw, 4, 4 + length)
    bytes_to_str(payload)
```

**Line-by-line explanation:**

- `data = str_to_bytes(msg)` -- Convert the message string to bytes so we can measure its byte length (not character length -- a message containing Unicode characters may have more bytes than characters).
- `length = bytes_len(data)` -- The byte count of the payload.
- `header = bytes(4)` -- Allocate exactly 4 bytes for the length header.
- The four `bytes_set` lines encode the length as a 4-byte big-endian integer. This supports messages up to 4,294,967,295 bytes (about 4 GB (gigabytes)).
- `bytes_concat(header, data)` -- Concatenates the 4-byte header and the payload into a single byte buffer.
- In `decode_message`, we reverse the process: read 4 bytes, reconstruct the integer length, then slice the payload.

### What NOT to do

```nova
// WRONG: using strings for binary data
// Strings assume UTF-8 encoding -- bytes 0x80-0xFF that aren't valid
// UTF-8 sequences will be corrupted or lost
fn bad_binary_read(path)
    data = read_file(path)    // reads as UTF-8 string -- binary data corrupted!
    // Byte 0xFF in the file becomes the replacement character

// CORRECT: use bytes for binary data
fn good_binary_read(path)
    data = read_file_bytes(path)  // reads as raw bytes -- no encoding assumption
```

```nova
// WRONG: accessing bytes out of bounds
buf = bytes(4)
bytes_get(buf, 4)     // index 4 on a 4-byte buffer -- valid indices are 0..3!
                      // This is an out-of-bounds access

// CORRECT: always check bounds
buf = bytes(4)
idx = 4
if idx < bytes_len(buf)
    print(bytes_get(buf, idx))
else
    print("index out of range")
```

### Real-world use case: parsing a BMP (Bitmap) image header

The BMP file format starts with a 14-byte header that contains the file size, reserved fields, and the offset to the pixel data. Here is how you would parse it:

```nova
fn parse_bmp_header(data)
    // Bytes 0-1: signature (must be 0x42, 0x4D = "BM")
    sig0 = bytes_get(data, 0)    // should be 66 (ASCII 'B')
    sig1 = bytes_get(data, 1)    // should be 77 (ASCII 'M')
    if sig0 != 66 or sig1 != 77
        return err("not a BMP file")

    // Bytes 2-5: file size (little-endian 32-bit)
    file_size = bytes_get(data, 2) +
                bytes_get(data, 3) * 256 +
                bytes_get(data, 4) * 65536 +
                bytes_get(data, 5) * 16777216

    // Bytes 10-13: pixel data offset (little-endian 32-bit)
    pixel_offset = bytes_get(data, 10) +
                   bytes_get(data, 11) * 256 +
                   bytes_get(data, 12) * 65536 +
                   bytes_get(data, 13) * 16777216

    ok({"file_size": file_size, "pixel_offset": pixel_offset})
```

---

## 34. AI (Artificial Intelligence) and tensors

### What is this?

A tensor is a multi-dimensional array of numbers. If you have never worked with machine learning before, here is the hierarchy:

- A **scalar** is a single number: `42.0`. It has zero dimensions.
- A **vector** is a 1-dimensional (1D) array of numbers: `[1.0, 2.0, 3.0]`. It has one dimension (its length). A vector with 3 elements has shape `[3]`.
- A **matrix** is a 2-dimensional (2D) grid of numbers. It has two dimensions: rows and columns. A 2x3 matrix has shape `[2, 3]` -- 2 rows and 3 columns, for a total of 6 elements.
- A **tensor** is the generalization to any number of dimensions. A 3D tensor with shape `[2, 3, 4]` has 2 * 3 * 4 = 24 elements. You can think of it as 2 matrices, each 3x4.

**Why do AI systems use tensors?** Machine learning models are fundamentally linear algebra -- they multiply matrices of input data by matrices of learned weights, add bias vectors, and apply nonlinear activation functions. A neural network is a pipeline of these operations. Every input (an image, a sentence, an audio clip) is converted to a tensor, processed through many tensor operations, and the output tensor is the prediction.

NOVA has built-in tensor operations so that AI workloads can be expressed directly in the language without importing external libraries like NumPy (Python) or PyTorch.

**Key terminology:**

- **Shape** -- A list of integers describing the size of each dimension. Shape `[2, 3]` means 2 rows, 3 columns. Shape `[10]` means a vector of 10 elements. Shape `[3, 224, 224]` means 3 channels (RGB) of 224x224 pixel images.
- **Rank** -- The number of dimensions. A scalar has rank 0, a vector has rank 1, a matrix has rank 2, a 3D tensor has rank 3.
- **Size** -- The total number of elements. For shape `[2, 3]`, size = 6. For shape `[3, 224, 224]`, size = 150,528.
- **Element-wise operation** -- An operation applied to each element independently. Adding two 2x3 matrices adds each pair of corresponding elements.
- **Matrix multiplication** (matmul) -- NOT element-wise. Combines rows of the first matrix with columns of the second. The inner dimensions must match: `[2, 3] * [3, 4]` works (producing `[2, 4]`), but `[2, 3] * [4, 5]` does not (3 != 4).

### Creating tensors

```nova
// From a flat list with a shape specification
// The flat list is filled into the shape in row-major order
t = tensor_from_list([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], [2, 3])
// This creates a 2x3 matrix arranged as:
//   Row 0: [1.0, 2.0, 3.0]
//   Row 1: [4.0, 5.0, 6.0]
// In mathematical notation:
//   | 1  2  3 |
//   | 4  5  6 |

print(tensor_shape(t))    // [2, 3]
print(tensor_rank(t))     // 2 (two dimensions: rows and columns)
print(tensor_size(t))     // 6 (total number of elements: 2 * 3)

// Zero tensor -- useful for bias vectors, accumulators, output buffers
z = tensor_zeros([3, 3])
// Creates:
//   | 0  0  0 |
//   | 0  0  0 |
//   | 0  0  0 |

// Access individual elements by their coordinates
print(tensor_get(t, [0, 0]))    // 1.0 (row 0, column 0)
print(tensor_get(t, [0, 2]))    // 3.0 (row 0, column 2)
print(tensor_get(t, [1, 0]))    // 4.0 (row 1, column 0)
print(tensor_get(t, [1, 2]))    // 6.0 (row 1, column 2)
```

**Line-by-line explanation:**

- `tensor_from_list([1.0, 2.0, ...], [2, 3])` -- The first argument is a flat list of all elements. The second argument is the shape (a list of dimension sizes). The elements fill in row-major order: the last dimension changes fastest. So the first 3 values fill row 0, and the next 3 fill row 1. The number of elements in the flat list must equal the product of the shape dimensions (here, 2 * 3 = 6).
- `tensor_shape(t)` -- Returns the shape as a list of integers.
- `tensor_rank(t)` -- Returns the number of dimensions. Rank is just `len(tensor_shape(t))`.
- `tensor_size(t)` -- Returns the total element count. This is the product of all shape dimensions.
- `tensor_get(t, [0, 0])` -- Accesses the element at the given coordinates. The coordinate list must have exactly `rank` entries. For a 2D tensor, you provide `[row, column]`.

### Tensor arithmetic: element-wise operations

Element-wise operations apply the same operation to each pair of corresponding elements. The two tensors must have the same shape.

```nova
a = tensor_from_list([1.0, 2.0, 3.0, 4.0], [2, 2])
// a = | 1  2 |
//     | 3  4 |

b = tensor_from_list([5.0, 6.0, 7.0, 8.0], [2, 2])
// b = | 5  6 |
//     | 7  8 |

// Element-wise addition: each a[i,j] + b[i,j]
c = tensor_add(a, b)
// c = | 1+5  2+6 | = | 6   8  |
//     | 3+7  4+8 |   | 10  12 |

// Element-wise subtraction
d = tensor_sub(a, b)
// d = | 1-5  2-6 | = | -4  -4 |
//     | 3-7  4-8 |   | -4  -4 |

// Element-wise multiplication (NOT matrix multiplication!)
e = tensor_mul(a, b)
// e = | 1*5  2*6 | = | 5   12 |
//     | 3*7  4*8 |   | 21  32 |

// Element-wise division
f = tensor_div(a, b)
// f = | 1/5  2/6 | = | 0.2    0.333 |
//     | 3/7  4/8 |   | 0.429  0.5   |

// Scalar multiplication: multiply every element by a constant
g = tensor_scale(a, 2.0)
// g = | 1*2  2*2 | = | 2  4 |
//     | 3*2  4*2 |   | 6  8 |
```

**Line-by-line explanation:**

- `tensor_add(a, b)` -- Adds corresponding elements. Position `[0,0]` of the result is `a[0,0] + b[0,0]`. Requires `a` and `b` to have the same shape.
- `tensor_mul(a, b)` -- Element-wise multiplication, also called the Hadamard product. This is NOT matrix multiplication. `tensor_mul` multiplies corresponding elements: position `[0,0]` of the result is `a[0,0] * b[0,0]`. For matrix multiplication, use `tensor_matmul`.
- `tensor_scale(a, 2.0)` -- Multiplies every element in `a` by the scalar 2.0. Useful for learning rate scaling in neural network training.

### Matrix multiplication (matmul)

Matrix multiplication is the core operation of linear algebra and neural networks. It combines a matrix of inputs with a matrix of weights to produce outputs.

**How matrix multiplication works:**

For matrices A (shape `[m, n]`) and B (shape `[n, p]`), the result C has shape `[m, p]`. Each element `C[i, j]` is the dot product of row `i` of A and column `j` of B:

```
C[i, j] = A[i, 0] * B[0, j] + A[i, 1] * B[1, j] + ... + A[i, n-1] * B[n-1, j]
```

The inner dimensions must match: the number of columns in A must equal the number of rows in B.

```nova
// A is 2x3 (2 rows, 3 columns)
a = tensor_from_list([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], [2, 3])
// a = | 1  2  3 |
//     | 4  5  6 |

// B is 3x2 (3 rows, 2 columns)
b = tensor_from_list([7.0, 8.0, 9.0, 10.0, 11.0, 12.0], [3, 2])
// b = | 7   8  |
//     | 9   10 |
//     | 11  12 |

// Matmul: [2,3] * [3,2] -> [2,2]
// Inner dimension 3 matches. Result is 2x2.
c = tensor_matmul(a, b)
print(tensor_shape(c))    // [2, 2]

// C[0,0] = 1*7 + 2*9 + 3*11 = 7 + 18 + 33 = 58
// C[0,1] = 1*8 + 2*10 + 3*12 = 8 + 20 + 36 = 64
// C[1,0] = 4*7 + 5*9 + 6*11 = 28 + 45 + 66 = 139
// C[1,1] = 4*8 + 5*10 + 6*12 = 32 + 50 + 72 = 154
// c = | 58   64  |
//     | 139  154 |

print(tensor_get(c, [0, 0]))    // 58.0
print(tensor_get(c, [1, 1]))    // 154.0
```

**What NOT to do with matmul:**

```nova
// WRONG: mismatched inner dimensions
a = tensor_from_list([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], [2, 3])  // shape [2, 3]
b = tensor_from_list([1.0, 2.0, 3.0, 4.0], [2, 2])              // shape [2, 2]
c = tensor_matmul(a, b)  // ERROR: inner dimensions 3 != 2
// A has 3 columns, B has 2 rows -- they don't match!
```

```nova
// WRONG: confusing tensor_mul with tensor_matmul
a = tensor_from_list([1.0, 2.0, 3.0, 4.0], [2, 2])
b = tensor_from_list([5.0, 6.0, 7.0, 8.0], [2, 2])
c = tensor_mul(a, b)     // element-wise: [5, 12, 21, 32]
d = tensor_matmul(a, b)  // matrix multiply: [19, 22, 43, 50]
// These are DIFFERENT operations with DIFFERENT results!
```

### Neural network activation functions

**What are these?** In a neural network, each layer multiplies inputs by weights and adds a bias. This is a linear operation -- stacking multiple linear operations is equivalent to a single linear operation, which means a 100-layer network would be no more powerful than a 1-layer network. Activation functions introduce nonlinearity, allowing the network to learn complex patterns.

```nova
x = tensor_from_list([-2.0, -1.0, 0.0, 1.0, 2.0], [5])

// ReLU (Rectified Linear Unit): max(0, x)
// The most common activation function in modern neural networks.
// Negative values become 0, positive values pass through unchanged.
// Fast to compute, works well in practice.
r = tensor_relu(x)
// r = [0.0, 0.0, 0.0, 1.0, 2.0]
// Visualization:
//   input:  -2  -1   0   1   2
//   output:  0   0   0   1   2
```

- `tensor_relu(x)` -- Applies the ReLU function to each element: if the element is negative, replace it with 0; if non-negative, keep it. Named "Rectified Linear Unit" because it rectifies (clips) negative values to zero while keeping the linear part (positive values unchanged). This is the activation function used in most modern neural networks because it is computationally cheap (one comparison) and does not suffer from the "vanishing gradient" problem.

```nova
// Sigmoid: 1 / (1 + e^(-x))
// Squashes any value into the range (0, 1).
// Used for binary classification ("is this a cat? probability 0.87")
s = tensor_sigmoid(x)
// s = [0.119, 0.269, 0.5, 0.731, 0.881]
// Visualization:
//   input:  -2     -1      0     1      2
//   output:  0.119  0.269  0.5   0.731  0.881
// Note: sigmoid(0) is always 0.5 (the midpoint)
```

- `tensor_sigmoid(x)` -- Applies the logistic sigmoid function. For very negative inputs, the output approaches 0. For very positive inputs, it approaches 1. For 0, it returns exactly 0.5. This function is used when you need a probability output (always between 0 and 1).

```nova
// Tanh (Hyperbolic Tangent): (e^x - e^(-x)) / (e^x + e^(-x))
// Squashes values into the range (-1, 1).
// Like sigmoid but centered at 0, which helps gradient flow.
h = tensor_tanh(x)
// h = [-0.964, -0.762, 0.0, 0.762, 0.964]
```

- `tensor_tanh(x)` -- Similar to sigmoid but outputs range from -1 to 1 instead of 0 to 1. Centered around 0, which can help neural networks learn faster because the mean output is near 0.

```nova
// Softmax: e^(xi) / sum(e^(xj) for all j)
// Converts a vector of arbitrary values into a probability distribution
// (all positive, sums to 1.0). Used for multi-class classification.
probs = tensor_softmax(x)
// probs = [0.011, 0.033, 0.090, 0.245, 0.665]
// Note: all values > 0 and they sum to approximately 1.0
// The largest input (2.0) gets the highest probability (0.665)
```

- `tensor_softmax(x)` -- Converts raw scores (called "logits") into probabilities. Each output is `e^(x_i) / sum(e^(x_j))`. The outputs are all positive and sum to 1.0, making them valid probabilities. The largest input gets the highest probability. Used as the final layer in classification networks -- if you have 10 classes (like digits 0-9), softmax tells you the probability of each class.

### Reduction and reshaping operations

```nova
x = tensor_from_list([-1.0, 3.0, 1.0, 2.0], [4])

// Sum: add all elements
print(tensor_sum(x))        // 5.0 (-1 + 3 + 1 + 2 = 5)

// Argmax: index of the largest element (useful for classification)
print(tensor_argmax(x))     // 1 (element at index 1 is 3.0, the largest)

// Reshape: change the shape without changing the data
t = tensor_from_list([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], [2, 3])
// t = | 1  2  3 |
//     | 4  5  6 |

t2 = tensor_reshape(t, [3, 2])
// Same 6 elements, rearranged into 3 rows and 2 columns:
// t2 = | 1  2 |
//      | 3  4 |
//      | 5  6 |

t3 = tensor_reshape(t, [6])
// Flattened to a 1D vector: [1, 2, 3, 4, 5, 6]

// Transpose: swap rows and columns
t4 = tensor_transpose(t)
// Original: | 1  2  3 |     Transposed: | 1  4 |
//           | 4  5  6 |                 | 2  5 |
//                                       | 3  6 |
print(tensor_shape(t4))     // [3, 2]
```

**Line-by-line explanation:**

- `tensor_sum(x)` -- Adds all elements and returns a scalar (a single number). For a loss function, you might sum the individual losses.
- `tensor_argmax(x)` -- Returns the index of the maximum element. In classification, after softmax gives probabilities `[0.1, 0.7, 0.2]`, argmax returns `1` meaning "class 1 is the prediction."
- `tensor_reshape(t, [3, 2])` -- Changes the dimensions without moving data. The total number of elements must stay the same: `2 * 3 = 6 = 3 * 2`. The elements are read in row-major order from the source and written in row-major order to the destination.
- `tensor_transpose(t)` -- Swaps the row and column dimensions. Element at `[i, j]` moves to `[j, i]`. Shape `[m, n]` becomes `[n, m]`.

### Complete example: a 2-layer neural network forward pass

This example ties everything together. It implements the forward pass (inference) of a neural network that takes 3 inputs and produces 2 output probabilities. This is the same computation that happens in production neural networks, just at a smaller scale.

```nova
fn forward(input, weights1, bias1, weights2, bias2)
    // Layer 1: linear transformation + ReLU activation
    // h = ReLU(input * weights1 + bias1)
    h = tensor_matmul(input, weights1)    // [1,3] * [3,4] -> [1,4]
    h = tensor_add(h, bias1)              // [1,4] + [1,4] -> [1,4]
    h = tensor_relu(h)                    // apply ReLU element-wise

    // Layer 2: linear transformation + softmax
    // out = softmax(h * weights2 + bias2)
    out = tensor_matmul(h, weights2)      // [1,4] * [4,2] -> [1,2]
    out = tensor_add(out, bias2)          // [1,2] + [1,2] -> [1,2]
    tensor_softmax(out)                   // convert to probabilities
```

**Line-by-line explanation:**

- `tensor_matmul(input, weights1)` -- Multiplies the input vector (shape `[1, 3]` -- 1 sample with 3 features) by the weight matrix (shape `[3, 4]` -- connecting 3 inputs to 4 hidden neurons). The result has shape `[1, 4]` -- 4 hidden neuron values.
- `tensor_add(h, bias1)` -- Adds the bias vector. Every neuron has a learnable bias that shifts its activation. Without bias, the network can only learn patterns that pass through the origin.
- `tensor_relu(h)` -- Applies ReLU nonlinearity. Negative hidden values become 0. This is what gives the network its ability to learn nonlinear patterns.
- `tensor_matmul(h, weights2)` -- Second linear transformation: hidden layer (shape `[1, 4]`) times second weight matrix (shape `[4, 2]`) produces output (shape `[1, 2]`).
- `tensor_softmax(out)` -- Converts the raw outputs into a probability distribution over 2 classes. The two output values will be positive and sum to 1.0.

```nova
// Set up: 3 inputs -> 4 hidden neurons -> 2 output classes
input = tensor_from_list([1.0, 0.5, -0.3], [1, 3])

// Weight matrices (in a real network, these are learned from data)
w1 = tensor_from_list([
    0.1, 0.2, 0.3, 0.4,
    -0.1, 0.1, 0.2, -0.2,
    0.3, -0.3, 0.1, 0.2
], [3, 4])
b1 = tensor_zeros([1, 4])

w2 = tensor_from_list([
    0.1, 0.2,
    -0.1, 0.3,
    0.2, -0.2,
    0.1, 0.4
], [4, 2])
b2 = tensor_zeros([1, 2])

// Run inference
probs = forward(input, w1, b1, w2, b2)
print(tensor_get(probs, [0, 0]))    // probability of class 0
print(tensor_get(probs, [0, 1]))    // probability of class 1

// The predicted class is the one with the highest probability
predicted = tensor_argmax(probs)
print("Predicted class: {predicted}")
```

**Line-by-line explanation:**

- `input = tensor_from_list([1.0, 0.5, -0.3], [1, 3])` -- One sample with 3 features. The `[1, 3]` shape means 1 row (1 sample) and 3 columns (3 features). In a real system, you might batch multiple samples: shape `[32, 3]` would process 32 samples at once.
- `w1 = tensor_from_list([...], [3, 4])` -- The weight matrix for the first layer. Shape `[3, 4]` means 3 input features connecting to 4 hidden neurons. Each of the 12 values is a learned weight. In practice, weights are initialized randomly and adjusted by a training algorithm (SGD, Adam, etc.).
- `b1 = tensor_zeros([1, 4])` -- Bias vector for the first layer. Initialized to zeros. During training, these biases are adjusted along with the weights.
- `tensor_argmax(probs)` -- Returns the index of the class with the highest probability. If probs = `[0.3, 0.7]`, argmax returns `1`, meaning "the network predicts class 1."

### What NOT to do

```nova
// WRONG: mismatched shape and data count
t = tensor_from_list([1.0, 2.0, 3.0], [2, 2])
// Shape [2,2] requires 2*2=4 elements, but only 3 were provided!
// This is an error.

// CORRECT: element count must equal the product of shape dimensions
t = tensor_from_list([1.0, 2.0, 3.0, 4.0], [2, 2])   // 4 elements, shape [2,2], 2*2=4
```

```nova
// WRONG: accessing elements with wrong number of coordinates
t = tensor_from_list([1.0, 2.0, 3.0, 4.0], [2, 2])
tensor_get(t, [0])          // ERROR: rank is 2, need [row, col]
tensor_get(t, [0, 0, 0])   // ERROR: rank is 2, not 3

// CORRECT: coordinate list must have exactly 'rank' entries
tensor_get(t, [0, 0])      // 1.0 (row 0, column 0)
tensor_get(t, [1, 1])      // 4.0 (row 1, column 1)
```

---

## 35. Distributed computing

### What is this?

In Sections 17-18, you learned about NOVA's concurrency model: green tasks communicate through channels using `send` and `receive`. Those channels work within a single machine -- all tasks share the same process memory (though each task gets an independent copy of sent values).

Distributed computing extends this model across the network. Instead of tasks on one machine, you have programs running on different machines (or different ports on the same machine) that need to communicate. NOVA provides remote channels for this purpose: `remote_send` and `remote_recv` have the exact same semantics as `send` and `receive`, but the values travel over a TCP (Transmission Control Protocol) network connection instead of through shared memory.

**Why this matters:** The same mental model works at every scale:

| Scale | Mechanism | Example |
|-------|-----------|---------|
| Same task | Function call | `result = compute(data)` |
| Same machine | `send`/`receive` on channel | Tasks processing a work queue |
| Different machines | `remote_send`/`remote_recv` | Microservices communicating |

NOVA's vision is that the developer writes the same code regardless of whether tasks are local or remote. The communication pattern (send a value, receive a value, the receiver gets an independent copy) is identical at all three scales.

### How remote channels work under the hood

When you call `remote_send(conn, value)`, here is what happens:

1. **Serialization** -- NOVA converts the value to JSON (JavaScript Object Notation). Integers, floats, strings, lists, dicts, and nested combinations of these are all serializable. Structs are serialized as JSON objects. Functions, channels, and raw pointers cannot be serialized (they are local resources).

2. **Length prefixing** -- The JSON string is converted to bytes, and a 4-byte big-endian length header is prepended. This tells the receiver exactly how many bytes to read before it has a complete message.

3. **TCP transmission** -- The length-prefixed bytes are sent over the TCP connection. TCP guarantees in-order, reliable delivery -- if the network drops packets, TCP retransmits them automatically. If the connection breaks entirely, the send fails with an error.

4. **Deserialization on receive** -- The receiver reads the length header, reads that many bytes, parses the JSON back into a NOVA value. The received value is a completely independent copy -- modifying it does not affect the sender's copy.

This is the same deep-copy semantics as local channels: when you `send(ch, data)`, the receiver gets a deep copy of `data`. Remote channels just extend this across the network.

### Setting up a remote server (listener)

```nova
fn run_server()
    // Listen for incoming connections on all interfaces, port 9000
    listener = remote_listen("0.0.0.0", 9000)

    // Accept one incoming connection (blocks until a client connects)
    conn = remote_accept(listener)

    // Receive a value from the client
    msg = remote_recv(conn)
    print("Server received: {msg}")

    // Send a response back
    remote_send(conn, {"reply": "got it", "status": "ok"})

    // Clean up
    remote_close(conn)
```

**Line-by-line explanation:**

- `remote_listen("0.0.0.0", 9000)` -- Creates a TCP listener socket bound to all network interfaces (`"0.0.0.0"` means "accept connections on any IP address this machine has") on port 9000. This is analogous to `socket()` + `bind()` + `listen()` in C. The port number must be between 1 and 65535, and ports below 1024 require administrator/root privileges on most operating systems.
- `remote_accept(listener)` -- Blocks until a client connects. When a connection arrives, returns a connection object that represents the two-way communication channel with that specific client. In a real server, you would call `remote_accept` in a loop and `spawn` a new task for each connection.
- `remote_recv(conn)` -- Blocks until the client sends a value. The value is deserialized from JSON and returned as a native NOVA value (dict, list, string, int, etc.).
- `remote_send(conn, {"reply": "got it", "status": "ok"})` -- Sends a value to the client. The dict is serialized to JSON and transmitted over TCP.
- `remote_close(conn)` -- Closes the TCP connection and frees associated resources. Always close connections when done to avoid resource leaks (each open connection consumes a file descriptor, and the OS has a limited number of file descriptors).

### Setting up a remote client (connector)

```nova
fn run_client()
    // Connect to the server at 127.0.0.1 (localhost), port 9000
    conn = remote_connect("127.0.0.1", 9000)

    // Send a request
    remote_send(conn, {"op": "hello", "data": "world"})

    // Receive the server's response
    reply = remote_recv(conn)
    print("Client got: {reply}")

    // Clean up
    remote_close(conn)
```

**Line-by-line explanation:**

- `remote_connect("127.0.0.1", 9000)` -- Establishes a TCP connection to the server. `"127.0.0.1"` is the loopback address (same machine). To connect to a remote machine, use its IP address or hostname (e.g., `"192.168.1.50"` or `"server.example.com"`). This call blocks until the connection is established or fails (e.g., if the server is not running, a connection-refused error is returned).
- `remote_send(conn, {"op": "hello", "data": "world"})` -- Sends a dict to the server. The dict is serialized as the JSON string `{"op":"hello","data":"world"}`.
- `remote_recv(conn)` -- Blocks until the server sends a response. Returns the deserialized value.

### Running both together

To test distributed channels on a single machine, spawn the server and client as separate green tasks:

```nova
fn main()
    // Start the server in a background task
    spawn fn()
        run_server()

    // Give the server a moment to start listening
    sleep(100)

    // Run the client
    run_client()
```

**Line-by-line explanation:**

- `spawn fn() run_server()` -- Starts the server in a separate green task. It begins listening on port 9000.
- `sleep(100)` -- Waits 100 milliseconds to ensure the server has time to bind the port and start listening. In production, you would use a more robust synchronization mechanism (like a ready signal on a channel), but for simple testing, a short sleep suffices.
- `run_client()` -- Runs the client in the main task. It connects to the server, exchanges messages, and prints the reply.

### Multi-client server with spawn

A real server handles multiple clients concurrently. Here is the pattern:

```nova
fn handle_client(conn)
    msg = remote_recv(conn)
    print("Handling: {msg}")

    // Process the request
    result = process_request(msg)

    // Send the response
    remote_send(conn, {"result": result})
    remote_close(conn)

fn run_multi_server()
    listener = remote_listen("0.0.0.0", 9000)
    print("Server listening on port 9000")

    // Accept clients in a loop, spawn a task for each
    loop
        conn = remote_accept(listener)
        spawn fn()
            handle_client(conn)
```

**Line-by-line explanation:**

- `fn handle_client(conn)` -- Handles one client in its own green task. Each client gets independent, concurrent processing.
- `loop ... remote_accept(listener)` -- Infinite loop that accepts new connections. Each connection is handed off to a new green task.
- `spawn fn() handle_client(conn)` -- The key pattern: spawn a green task per connection. Green tasks are cheap (~1 microsecond to create, ~300 bytes of memory each), so you can handle thousands of concurrent connections.

### Failure modes and how to handle them

Distributed systems fail in ways that local programs do not. Here are the common failure modes:

**1. Connection refused -- the server is not running:**

```nova
// This will fail if no server is listening on port 9000
conn = remote_connect("127.0.0.1", 9000)
// Solution: wrap in match/try, retry, or report the error
```

**2. Connection lost -- the network drops or the remote process crashes:**

```nova
// The connection was established, but then the server crashes
conn = remote_connect("127.0.0.1", 9000)
remote_send(conn, {"op": "ping"})
reply = remote_recv(conn)
// If the server crashed, remote_recv returns null or an error
// Always check the return value!
if reply == null
    print("server disconnected")
```

**3. Timeout -- the remote side is too slow to respond:**

```nova
// In a production system, never wait forever
conn = remote_connect("127.0.0.1", 9000)
remote_send(conn, {"op": "heavy_computation"})
// If the server takes 10 minutes, your client is stuck for 10 minutes
// Use channel_recv_timeout for a deadline
```

**4. Serialization failure -- you send something that cannot be serialized:**

```nova
ch = channel()
// WRONG: channels cannot be serialized to JSON
remote_send(conn, {"channel": ch})   // ERROR!
// Functions, channels, and raw pointers are local resources
// Only send serializable values: ints, floats, strings, lists, dicts
```

### What NOT to do

```nova
// WRONG: forgetting to close connections
fn leaky_client()
    conn = remote_connect("127.0.0.1", 9000)
    remote_send(conn, {"op": "hello"})
    reply = remote_recv(conn)
    // BUG: never called remote_close(conn)!
    // Each leaked connection holds an OS file descriptor.
    // After ~1000 leaked connections, the OS refuses new connections.

// CORRECT: always close
fn clean_client()
    conn = remote_connect("127.0.0.1", 9000)
    remote_send(conn, {"op": "hello"})
    reply = remote_recv(conn)
    remote_close(conn)
```

```nova
// WRONG: sending huge data structures over remote channels
fn bad_pattern()
    conn = remote_connect("127.0.0.1", 9000)
    // Sending 1 million records as one message
    all_data = load_all_records()   // might be 500 MB of JSON
    remote_send(conn, all_data)     // serialization alone takes seconds

// CORRECT: send in chunks or send only what's needed
fn good_pattern()
    conn = remote_connect("127.0.0.1", 9000)
    remote_send(conn, {"query": "active_users", "limit": 100})
    page = remote_recv(conn)
    // Process 100 records at a time
```

### Real-world use case: a distributed task queue

```nova
// Worker node: receives tasks, processes them, sends results back
fn worker(server_host, server_port)
    conn = remote_connect(server_host, server_port)
    remote_send(conn, {"type": "register", "role": "worker"})

    loop
        task = remote_recv(conn)
        if task == null
            break   // server disconnected
        print("Processing task: {task["id"]}")
        result = process_task(task)
        remote_send(conn, {"type": "result", "id": task["id"], "value": result})

    remote_close(conn)

// Coordinator: distributes tasks to workers
fn coordinator()
    listener = remote_listen("0.0.0.0", 9000)
    workers = []

    // Wait for 3 workers to connect
    for i in 0..2
        conn = remote_accept(listener)
        reg = remote_recv(conn)
        if reg["type"] == "register"
            push(workers, conn)
            print("Worker {i} connected")

    // Distribute tasks round-robin
    tasks = generate_tasks(100)
    for i, task in enumerate(tasks)
        worker_idx = i % len(workers)
        remote_send(workers[worker_idx], task)

    // Collect results
    results = []
    for i in 0..len(tasks) - 1
        // Any worker might respond
        // In a real system, you'd use select() on the worker connections
        result = remote_recv(workers[i % len(workers)])
        push(results, result)

    // Close all connections
    for w in workers
        remote_close(w)
```

---

## 36. Performance guide

### What is this?

Performance means "how fast does my program run and how much memory does it use." NOVA's promise is C-level performance -- your NOVA program should run within a few percent of the equivalent C program, while being dramatically simpler to write and safer by default.

This section explains how the NOVA compiler achieves high performance, what coding patterns help it, what patterns defeat it, how to measure performance accurately, and how to diagnose and fix performance problems.

### The fundamental model: how NOVA compiles to machine code

NOVA programs go through a multi-stage compilation pipeline:

```
Your .nova file
    -> NOVA compiler (lexing, parsing, type inference, IR generation)
    -> LLVM IR (Intermediate Representation) -- a portable assembly language
    -> LLVM/clang optimization passes (-O2 level)
    -> Native machine code (.exe on Windows, ELF binary on Linux)
```

**Stage 1: NOVA to LLVM IR.** The NOVA compiler translates your source code into LLVM IR. LLVM IR (Intermediate Representation) is a typed, low-level language that serves as a portable assembly language. This is the same IR used by Clang (the C/C++ compiler), Rust, Swift, Julia, and many other languages. The quality of this IR determines performance -- if the NOVA compiler generates the same IR that Clang would generate for equivalent C code, the final executable runs at the same speed.

**Stage 2: LLVM optimization.** The LLVM optimizer applies dozens of optimization passes to the IR: dead code elimination (removing unreachable code), constant folding (computing `3 + 4` at compile time instead of runtime), loop invariant code motion (moving constant expressions out of loops), inlining (replacing function calls with the function body), auto-vectorization (using SIMD instructions to process multiple data elements simultaneously), and many more. These are the same optimizations applied to C code compiled with `clang -O2`.

**Stage 3: Machine code generation.** LLVM generates native machine code for the target architecture (x86-64, ARM64, WebAssembly). The result is a standalone executable with no runtime dependencies beyond the C standard library and the NOVA runtime.

**What this means for you:** Any NOVA code that compiles down to the same LLVM IR as equivalent C code will have identical performance. The NOVA compiler's job is to reach that IR. For most code, it succeeds. For some patterns, it does not -- and this section explains which patterns those are.

### Measured performance against C (`clang -O2`)

These are real measurements from the NOVA test suite, not theoretical claims:

| Operation | NOVA vs. C | What this means |
|-----------|-----------|-----------------|
| Integer arithmetic (loops, counters) | ~1.00-1.02x | Identical to C. The compiled code is the same machine instructions. |
| Struct field math (lowercase types) | ~1.02-1.04x | Within measurement noise. NOVA generates native `fmul`/`fadd` instructions, same as C. |
| Float array operations | ~1.05x | Very close to C. Minor overhead from bounds checking. |
| String operations (typical) | ~1.10-1.20x | Slightly slower due to NOVA's UTF-8 aware string handling vs. C's raw `char*`. |
| Dict (hash map) lookup | ~1.5-3x | NOVA's open-addressing hash map is good but not as tuned as specialized C hash map libraries. |

For comparison, here are typical Python 3 measurements for the same operations:

| Operation | Python 3 vs. C | NOVA vs. Python |
|-----------|---------------|-----------------|
| Integer loop | ~50x slower | NOVA is ~50x faster than Python |
| Struct field math | ~150x slower | NOVA is ~150x faster than Python |
| Float array (NumPy) | ~1x (NumPy calls C) | NOVA matches or beats pure Python; ties with NumPy |
| String operations | ~5-10x slower | NOVA is ~5-10x faster than Python |

### What makes code fast

#### 1. Scalar arithmetic compiles to native CPU instructions

When the NOVA compiler can determine that variables are integers or floats, it generates native CPU arithmetic instructions -- the same `add`, `mul`, `fmul`, `fadd` instructions that C compiles to.

```nova
fn sum_squares(n: int) -> int
    total = 0
    for i in 1..n
        total = total + i * i
    total
```

**Line-by-line explanation:**

- `n: int` -- The type annotation tells the compiler this parameter is always an integer. The compiler generates native 64-bit integer operations.
- `total = 0` -- The compiler infers `total` is an integer (it is assigned an integer literal).
- `total = total + i * i` -- Compiles to two native instructions: `imul` (integer multiply `i * i`) and `add` (add the result to `total`). No function calls, no type checks, no boxing/unboxing. This is identical to what C compiles to.
- `total` -- The last expression is the return value. The compiler places it in the return register.

**The compiled LLVM IR for this function is essentially:**

```
; (simplified for clarity)
entry:
  %total = 0
  br label %loop

loop:
  %i = phi [1, entry], [%i.next, loop]
  %t = phi [0, entry], [%t.next, loop]
  %sq = mul i64 %i, %i        ; native integer multiply
  %t.next = add i64 %t, %sq   ; native integer add
  %i.next = add i64 %i, 1
  %cmp = icmp sle i64 %i.next, %n
  br i1 %cmp, label %loop, label %exit
```

This is the same IR that `clang -O2` generates for equivalent C. Same IR = same machine code = same performance.

#### 2. Struct field math with lowercase type names compiles to native operations

This is the single most important performance rule in NOVA. Struct field types must use lowercase names (`float`, `int`) to get native code generation.

```nova
// FAST: lowercase field types -> native LLVM fmul/fadd instructions
type Vec3
    x: float
    y: float
    z: float

fn dot(a: Vec3, b: Vec3) -> float
    a.x * b.x + a.y * b.y + a.z * b.z
```

**Line-by-line explanation:**

- `x: float` -- Lowercase `float` tells the compiler this field is always a 64-bit IEEE 754 double. The compiler stores it directly in the struct layout (no boxing, no tag, no indirection).
- `a.x * b.x` -- Compiles to a single `fmul double` LLVM instruction. No function call, no type check.
- `+ a.y * b.y` -- Another `fmul` and an `fadd`. The entire `dot` function compiles to 3 `fmul` + 2 `fadd` instructions, which is exactly what C compiles to.

```nova
// SLOW: capital field types -> dynamic dispatch (100-150x slower!)
type Vec3Slow
    x: Float    // capital F -- dynamic dispatch on every operation!
    y: Float
    z: Float
```

**Why is capital `Float` slow?** When you write `Float` (capital F), the compiler treats the field as a dynamically-typed value. At runtime, every arithmetic operation (`*`, `+`) must:

1. Check the type tag of the left operand (is it an int? float? string? list?)
2. Check the type tag of the right operand
3. Look up the correct operation for that type combination
4. Perform the operation
5. Box the result (wrap it in a tagged value)

This takes ~20-50 nanoseconds per operation vs. ~0.3 nanoseconds for a native `fmul`. That is a 60-150x difference.

**The rule is simple: always use lowercase type names in struct fields.**

| Write this | Not this |
|-----------|----------|
| `x: float` | `x: Float` |
| `count: int` | `count: Int` |
| `name: string` | `name: String` |

#### 3. Type-inferred parameters are specialized automatically

When the NOVA compiler can determine a function's parameter types from all its call sites, it generates specialized native code without any type annotations:

```nova
fn scale(v: Vec3, factor: float) -> Vec3
    Vec3 { x: v.x * factor, y: v.y * factor, z: v.z * factor }
```

**Line-by-line explanation:**

- The compiler sees that `v` is always called with a `Vec3` and `factor` is always a `float`. It generates native `fmul` for `v.x * factor` (since `Vec3.x` is lowercase `float` and `factor` is `float`).
- `Vec3 { x: ..., y: ..., z: ... }` -- Constructs a new Vec3 with computed field values. The compiler allocates the struct and fills its fields with native float values.

#### 4. The arena allocator eliminates garbage collection pauses

Many languages (Java, Go, Python, JavaScript) use a garbage collector (GC) to automatically free unused memory. GC is convenient but introduces pauses -- the program stops for milliseconds (or even seconds in extreme cases) while the GC scans memory.

NOVA's Forge framework uses a per-request arena allocator instead. An arena is a large block of memory. All allocations during a request come from the arena (just incrementing a pointer -- extremely fast). When the request is done, the entire arena is freed in one step (just resetting the pointer). No GC scan, no reference counting on the hot path, no pauses.

This means Forge's response latency is consistent -- the 99th percentile latency is close to the median, unlike GC-based frameworks where occasional GC pauses cause latency spikes.

#### 5. Green tasks are cheap to create and schedule

Creating a green task with `spawn` costs approximately 1 microsecond and ~300 bytes of memory. For comparison:

| Runtime | Task creation cost | Memory per task |
|---------|-------------------|-----------------|
| NOVA (green task) | ~1 microsecond | ~300 bytes |
| Go (goroutine) | ~1-2 microseconds | ~2-8 KB (kilobytes) |
| Erlang (process) | ~3-5 microseconds | ~300 bytes |
| Java (virtual thread, JDK 21+) | ~1-2 microseconds | ~1 KB |
| Python (thread) | ~10-50 microseconds | ~8 MB (megabytes) stack |
| C (pthread) | ~50-100 microseconds | ~8 MB stack |

NOVA's work-stealing scheduler automatically distributes green tasks across all available CPU cores. You do not need to manually assign tasks to cores or manage thread pools.

### What makes code slow

#### 1. Capital type names in struct fields (100-150x penalty)

Already covered above. This is the number one performance mistake in NOVA. Search your code for `type` blocks and verify all field type names are lowercase.

```nova
// This one character (F vs f) is a 100-150x performance difference
type Bad                    type Good
    x: Float                    x: float
    y: Float                    y: float
```

#### 2. String building with `+` in a loop -- O(n squared) complexity

String concatenation with `+` creates a new string every time. In a loop, each iteration copies all previous characters plus the new one. The total work grows quadratically with the number of iterations.

```nova
// SLOW: O(n^2) -- each + creates a new string, copying all previous content
// For 10,000 items: ~50,000,000 character copies
result = ""
for item in large_list
    result = result + str(item) + ", "
```

**Why is this O(n squared)?** On iteration 1, `result` is "" (0 chars), and we copy 0 + length(item). On iteration 2, `result` has ~10 chars, and we copy those 10 + length(item). On iteration k, `result` has ~10k chars, and we copy all 10k + length(item). The total copies are approximately 10 * (1 + 2 + 3 + ... + n) = 10 * n*(n+1)/2, which is O(n squared).

```nova
// FAST: O(n) -- build a list, then join once
parts = []
for item in large_list
    push(parts, str(item))
result = join(parts, ", ")
```

**Why is this O(n)?** `push` appends to a list in amortized O(1) time. The final `join` traverses all parts once, computing the total length, allocating one string, and copying each part once. Total work: proportional to the sum of all part lengths, which is O(n).

```nova
// FASTEST: buffer-based -- no intermediate allocations
buf = buffer_create()
for item in large_list
    buf_append(buf, str(item))
    buf_append(buf, ", ")
result = buf_to_str(buf)
```

**Why is this fastest?** A buffer pre-allocates memory and doubles its capacity when full (amortized O(1) per append). There are no intermediate string allocations at all -- just one final string creation from the buffer contents.

**Performance comparison for 10,000 items:**

| Method | Approximate time |
|--------|-----------------|
| String `+` in loop | ~500 ms |
| `join()` | ~1 ms |
| `buffer_create()` | ~0.5 ms |

#### 3. Large values sent over channels in tight loops

Channel `send` performs a deep copy of the value. This is necessary for safety (the sender and receiver must have independent copies to avoid data races), but it means sending a large dict or list copies the entire data structure.

```nova
// SLOW: copies large_data (maybe 1 MB) on every iteration
for i in 0..9999
    send(ch, large_data)
// Total: 10,000 copies of 1 MB = 10 GB of copying

// FAST: compute locally, send only the small result
for i in 0..9999
    result = compute(large_data, i)
    send(ch, result)   // result is a small value (maybe 100 bytes)
// Total: 10,000 copies of 100 bytes = 1 MB of copying
```

#### 4. Recursive functions without tail-call optimization

NOVA does not currently perform tail-call optimization (TCO). Deep recursion (10,000+ frames) can overflow the stack. Use loops instead of recursion for performance-critical code:

```nova
// SLOW (and crashes for large n): recursive
fn factorial_rec(n)
    if n <= 1
        return 1
    n * factorial_rec(n - 1)

// FAST: iterative
fn factorial_iter(n)
    result = 1
    for i in 2..n
        result = result * i
    result
```

### Measuring performance accurately

#### Basic timing

```nova
start = time_ms()
result = expensive_computation()
elapsed = time_ms() - start
print("took {elapsed}ms")
```

**Line-by-line explanation:**

- `time_ms()` -- Returns the current time in milliseconds since the Unix epoch (January 1, 1970). The difference between two `time_ms()` calls gives wall-clock elapsed time.
- `elapsed = time_ms() - start` -- Calculates how many milliseconds the computation took.

#### Micro-benchmarks: measuring fast operations

For operations that complete in microseconds, a single measurement is too noisy (OS scheduling, cache effects, etc. introduce variation). Run the operation thousands of times and compute the average:

```nova
N = 100_000
start = time_ms()
for i in 0..N - 1
    result = my_function(i)
elapsed = time_ms() - start
per_op_us = (elapsed * 1000) / N
print("{N} iterations in {elapsed}ms")
print("average: {per_op_us}us per operation")
```

**Line-by-line explanation:**

- `N = 100_000` -- Run the operation 100,000 times. The underscore is a digit separator for readability (100_000 = 100000).
- `for i in 0..N - 1` -- Loop from 0 to N-1 inclusive. NOVA ranges are inclusive on both ends, so `0..N-1` gives exactly N iterations.
- `elapsed * 1000 / N` -- Converts milliseconds to microseconds (`* 1000`) and divides by the number of iterations to get the average time per operation.

#### Benchmarking rules

1. **Warm up first.** Run the operation a few thousand times before starting the timer. This fills CPU caches and brings the LLVM-compiled code into the instruction cache.

2. **Use the result.** If you compute a result but never use it, the compiler might optimize away the entire computation (dead code elimination). Print or accumulate the result to prevent this.

3. **Run multiple trials.** Run the benchmark 3-5 times and take the minimum. Outliers are caused by OS scheduling, not by your code.

4. **Compare against a baseline.** Raw numbers ("it takes 5ms") are less useful than comparisons ("it takes 1.02x as long as the C version"). Write the same algorithm in C and measure both.

```nova
// Good benchmark: uses the result, runs multiple trials
fn bench_sum_squares(n)
    best = 999999
    for trial in 0..4
        start = time_ms()
        total = 0
        for i in 1..n
            total = total + i * i
        elapsed = time_ms() - start
        if elapsed < best
            best = elapsed
    print("sum_squares({n}): {best}ms (result={total})")

bench_sum_squares(10_000_000)
```

### Performance comparison matrix

| Operation | NOVA time | C (`clang -O2`) | Python 3 | NOVA vs C | NOVA vs Python |
|---|---|---|---|---|---|
| Integer loop (10M iterations) | ~15ms | ~15ms | ~750ms | 1.00x (identical) | 50x faster |
| Struct dot product (1M calls, lowercase) | ~3ms | ~3ms | ~450ms | 1.00-1.04x | 150x faster |
| Struct dot product (Capital types) | ~450ms | ~3ms | ~450ms | 150x slower | same as Python |
| Float array sum (1M elements) | ~2.1ms | ~2ms | ~200ms | 1.05x | 100x faster |
| String concat in loop (10K items) | ~500ms | ~50ms | varies | 10x slower | varies |
| String join (10K items) | ~1ms | ~0.8ms | ~5ms | 1.2x | 5x faster |
| Dict lookup (1M lookups) | ~45ms | ~15ms | ~150ms | 3x slower | 3x faster |
| Spawn green task | ~1us | N/A | ~10us (thread) | N/A | 10x faster |
| HTTP round-trip (Forge) | <100us | N/A | ~1ms (Flask) | N/A | 10x faster |

### The compiler is the genius, not the developer

NOVA's compiler does extensive work to optimize your code. You do NOT need to:

- **Annotate types on local variables.** The type inferrer determines types automatically from usage. `x = 42` is inferred as `int`. `y = 3.14` is inferred as `float`. `items = [1, 2, 3]` is inferred as a list of integers.
- **Manually inline functions.** The LLVM optimizer inlines small functions automatically. Writing `a.x * b.x + a.y * b.y + a.z * b.z` directly instead of calling a `dot()` function does not make your code faster.
- **Write SIMD (Single Instruction, Multiple Data) intrinsics.** LLVM's auto-vectorizer detects loop patterns that can use SIMD instructions and generates them automatically. Manual SIMD is rarely needed.
- **Manage memory allocation.** NOVA's arena allocator (for request-scoped data) and reference counting (for long-lived data) handle memory automatically.
- **Write lock-free algorithms.** For basic concurrent patterns (producer-consumer, work distribution, result collection), channels are the right tool. Atomic operations and lock-free algorithms are only needed for specialized high-contention scenarios.

You DO need to:

- **Use lowercase type names in struct fields.** This is the one thing the compiler cannot fix for you. Capital types are semantically different (dynamic dispatch), so the compiler cannot silently change them.
- **Use `join()` or `buffer_create()` for string building in loops.** The compiler cannot transform `result = result + item` into a buffer-based pattern because the semantics are subtly different (string `+` creates a new immutable string; a buffer mutates in place).
- **Design channels to carry small values.** Send results, not raw data. The compiler deep-copies on every `send` for safety.
- **Profile before optimizing.** Do not guess where performance problems are. Measure, find the bottleneck, fix it. Most code runs fast enough without any optimization.

> **DO:** Write simple, readable code first. Measure performance. Optimize only the parts that are actually slow.
>
> **DON'T:** Rewrite clean NOVA code in a "more C-like" style. The compiler generates the same machine code for `a.x * b.x + a.y * b.y` whether you wrote it as a function call or inline. Readability is free; premature optimization is expensive.
>
> **DO:** Use `time_ms()` to measure before and after any optimization attempt. If your "optimization" does not produce a measurable improvement, revert it -- you made the code harder to read for no benefit.

---

## Appendix A: Quick reference

This appendix is a comprehensive reference for every keyword, operator, built-in function, and syntax form in NOVA. It is organized by category. For each entry, the table shows the syntax and a brief description. For detailed explanations with examples, see the corresponding tutorial section.

### Keywords

| Keyword | Purpose | Example | See section |
|---|---|---|---|
| `fn` | Define a function. Indentation-based body. Last expression is return value. | `fn add(a, b)` followed by indented `a + b` | 5 |
| `type` | Define a struct (product type) with named fields. | `type Point` followed by indented `x: float` and `y: float` | 6 |
| `enum` | Define a sum type (tagged union) with named variants. | `enum Shape` followed by indented `Circle(radius: float)` and `Rectangle(w: float, h: float)` | 7 |
| `trait` | Define an interface: a set of methods that types must implement. | `trait Drawable` followed by indented `fn draw(self)` | 6 |
| `let` | Bind a value to a name. Identical to bare assignment (`x = 5`) but more explicit. | `let count = 0` | 3 |
| `return` | Explicit early return from a function. Not needed for the last expression. | `if n < 0` followed by indented `return err("negative")` | 5 |
| `if` | Conditional branch. Can be a statement (with indented body) or an expression (with `then`/`else` on one line). | `if x > 0` followed by indented body; or `result = if x > 0 then "pos" else "neg"` | 4 |
| `else` | Alternative branch for `if`. | `else` followed by indented body | 4 |
| `while` | Loop while a condition is true. Test at the top of each iteration. | `while i < 10` followed by indented body | 4 |
| `for` | Iterate over a list, dict, string, or range. Supports `for x in items`, `for i, x in items` (with index), and `for x in items if condition` (with guard). | `for item in list` followed by indented body | 4 |
| `in` | Used in `for ... in` loops, `x in collection` membership tests, and `not in` negated membership. | `if "key" in dict` | 4, 10 |
| `loop` | Infinite loop. Exit with `break` or `return`. | `loop` followed by indented body with `break` | 4 |
| `match` | Pattern match an expression against cases. Arms use `=>` (not `->`). | `match x` followed by indented `1 => "one"` and `_ => "other"` | 8 |
| `break` | Exit the nearest enclosing `while`, `for`, or `loop`. | `if done` followed by indented `break` | 4 |
| `continue` | Skip to the next iteration of the nearest enclosing loop. | `if item == null` followed by indented `continue` | 4 |
| `spawn` | Create a new green task (lightweight thread). The task runs concurrently. | `spawn fn()` followed by indented body | 17 |
| `send` | Send a value on a channel. The value is deep-copied. | `send(ch, 42)` | 17 |
| `receive` | Block until a value arrives on a channel, then return it. | `msg = receive(ch)` | 17 |
| `select` | Block until any one of multiple channels has a value. Returns `[index, value]`. | `result = select(ch1, ch2)` | 18 |
| `channel` | Create a new unbounded channel (an inter-task communication pipe). | `ch = channel()` | 17 |
| `import` | Import a module. Three forms: `import mod`, `import mod as alias`, `import mod.{a, b}`. | `import forge` | 19 |
| `extern fn` | Declare a C function for FFI (Foreign Function Interface). | `extern fn puts(s: string) -> int` | 31 |
| `unsafe` | Begin a block where safety checks are relaxed (raw pointers, etc.). Indentation-based. | `unsafe` followed by indented body | 32 |
| `try` | Unwrap an `Ok` value or propagate an `Err` to the caller. | `content = try read_file(path)` | 9 |
| `true` | Boolean literal for true. | `done = true` | 3 |
| `false` | Boolean literal for false. | `found = false` | 3 |
| `null` | Represents the absence of a value. | `if result == null` | 3 |
| `and` | Logical AND (short-circuiting). Evaluates right side only if left is true. NOT `&&`. | `if x > 0 and x < 100` | 3 |
| `or` | Logical OR (short-circuiting). Evaluates right side only if left is false. NOT `||`. | `if a or b` | 3 |
| `not` | Logical negation. NOT `!`. | `if not done` | 3 |
| `not in` | Negated membership test. | `if key not in dict` | 10 |
| `as` | Type cast. Converts between numeric types. | `x as float` | 3 |
| `matches` | Test whether a string matches a regular expression pattern. | `if text matches "^[0-9]+$"` | 13 |

### Operators

| Operator | Category | Meaning | Example | Result |
|---|---|---|---|---|
| `+` | Arithmetic | Addition (ints, floats) or string concatenation | `3 + 4` | `7` |
| `-` | Arithmetic | Subtraction | `10 - 3` | `7` |
| `*` | Arithmetic | Multiplication | `6 * 7` | `42` |
| `/` | Arithmetic | Division (integer division for ints, float division for floats) | `10 / 3` | `3` (int) |
| `%` | Arithmetic | Modulo (remainder after division) | `10 % 3` | `1` |
| `==` | Comparison | Equal to | `x == 5` | `true` or `false` |
| `!=` | Comparison | Not equal to | `x != 5` | `true` or `false` |
| `<` | Comparison | Less than | `a < b` | `true` or `false` |
| `<=` | Comparison | Less than or equal to | `a <= b` | `true` or `false` |
| `>` | Comparison | Greater than | `a > b` | `true` or `false` |
| `>=` | Comparison | Greater than or equal to | `a >= b` | `true` or `false` |
| `and` | Logical | Short-circuiting AND (NOT `&&`) | `a and b` | `true` if both true |
| `or` | Logical | Short-circuiting OR (NOT `||`) | `a or b` | `true` if either true |
| `not` | Logical | Negation (NOT `!`) | `not done` | opposite of `done` |
| `&` | Bitwise | Bitwise AND | `0xFF & 0x0F` | `0x0F` (15) |
| `\|` | Bitwise | Bitwise OR | `0xF0 \| 0x0F` | `0xFF` (255) |
| `^` | Bitwise | Bitwise XOR (Exclusive OR) | `0xFF ^ 0x0F` | `0xF0` (240) |
| `<<` | Bitwise | Left shift (multiply by 2^n) | `1 << 8` | `256` |
| `>>` | Bitwise | Right shift (divide by 2^n) | `256 >> 4` | `16` |
| `in` | Membership | Test if element is in collection | `5 in [1,5,9]` | `true` |
| `not in` | Membership | Test if element is NOT in collection | `5 not in [1,2,3]` | `true` |
| `x => body` | Closure | Single-parameter anonymous function | `x => x * 2` | a function |
| `(a, b) => body` | Closure | Multi-parameter anonymous function | `(a, b) => a + b` | a function |
| `a..b` | Range | Inclusive integer range from a to b (includes both a AND b) | `0..4` | `0, 1, 2, 3, 4` |
| `+=` | Compound assignment | Add and assign | `x += 5` | same as `x = x + 5` |
| `-=` | Compound assignment | Subtract and assign | `x -= 3` | same as `x = x - 3` |
| `*=` | Compound assignment | Multiply and assign | `x *= 2` | same as `x = x * 2` |
| `/=` | Compound assignment | Divide and assign | `x /= 4` | same as `x = x / 4` |
| `%=` | Compound assignment | Modulo and assign | `x %= 3` | same as `x = x % 3` |
| `matches` | Regex | Test string against regex pattern | `s matches "^\\d+$"` | `true` or `false` |
| `\|>` | Pipe | Pass left value as first argument to right function | `5 \|> double` | `double(5)` |

### Built-in functions (core)

| Function | Description | Example | Result |
|---|---|---|---|
| `print(v)` | Print any value followed by a newline. Structs are printed structurally (field names and values). | `print("hello")` | prints `hello` |
| `str(v)` | Convert any value to its string representation. Works on ints, floats, bools, lists, dicts, structs. | `str(42)` | `"42"` |
| `int(v)` | Convert a string or float to an integer. Truncates floats toward zero. | `int("42")`, `int(3.9)` | `42`, `3` |
| `float(v)` | Convert a string or int to a 64-bit float. | `float("3.14")`, `float(42)` | `3.14`, `42.0` |
| `bool(v)` | Convert to boolean. `0`, `""`, `null`, `false`, empty list/dict are false; everything else is true. | `bool(0)`, `bool("hi")` | `false`, `true` |
| `len(v)` | Length of a string (characters), list (elements), dict (keys), or bytes (byte count). | `len("hello")`, `len([1,2,3])` | `5`, `3` |
| `type_of(v)` | Get the type name as a string. | `type_of(42)`, `type_of([])` | `"int"`, `"list"` |

### Built-in functions (collections)

| Function | Description | Returns |
|---|---|---|
| `push(list, v)` | Append value to end of list. Mutates the list in place. | nothing (side effect) |
| `pop(list)` | Remove and return the last element. Errors if list is empty. | the removed element |
| `insert(list, i, v)` | Insert value at index `i`, shifting later elements right. | nothing (side effect) |
| `remove(list, v)` | Remove the first occurrence of value `v`. Does nothing if not found. | nothing (side effect) |
| `remove_at(list, i)` | Remove the element at index `i`, shifting later elements left. | the removed element |
| `sort(list)` | Sort the list in place (ascending order). Works on ints, floats, strings. | nothing (side effect) |
| `reverse(list)` | Reverse the list in place. | nothing (side effect) |
| `sort_by(list, cmp)` | Sort with a custom comparison function `cmp(a, b)` returning negative/0/positive. | nothing (side effect) |
| `keys(dict)` | Return a list of all keys in the dict. | list of keys |
| `values(dict)` | Return a list of all values in the dict. | list of values |
| `delete(dict, key)` | Remove a key-value pair from the dict. Does nothing if key not found. | nothing (side effect) |
| `contains(v, x)` | Test membership: `x` in list, key in dict, substring in string. | `true` or `false` |
| `merge(d1, d2)` | Create a new dict with all key-value pairs from both. `d2` values win on conflicts. | new dict |
| `map(list, f)` | Apply function `f` to each element, return new list of results. | new list |
| `filter(list, f)` | Return new list of elements where `f(element)` is true. | new list |
| `reduce(list, init, f)` | Fold list to single value: start with `init`, call `f(accumulator, element)` for each. | single value |
| `flatten(lists)` | Flatten a list of lists into a single list. `[[1,2],[3]]` becomes `[1,2,3]`. | new list |
| `sum(list)` | Sum all elements (must be numeric). | number |
| `join(list, sep)` | Join a list of strings with separator. `join(["a","b"], ",")` produces `"a,b"`. | string |
| `enumerate(list)` | Return list of `[index, value]` pairs. | list of pairs |

### Built-in functions (strings)

| Function | Description | Example | Result |
|---|---|---|---|
| `split(s, sep)` | Split string by separator into a list of parts. | `split("a,b,c", ",")` | `["a", "b", "c"]` |
| `find(s, sub)` | Index of first occurrence of `sub` in `s`. Returns `-1` if not found. | `find("hello", "ll")` | `2` |
| `slice(s, a, b)` | Substring from index `a` to `b` (exclusive). | `slice("hello", 1, 4)` | `"ell"` |
| `upper(s)` | Convert all characters to uppercase. | `upper("hello")` | `"HELLO"` |
| `lower(s)` | Convert all characters to lowercase. | `lower("HELLO")` | `"hello"` |
| `trim(s)` | Remove leading and trailing whitespace. | `trim("  hi  ")` | `"hi"` |
| `ltrim(s)` | Remove leading whitespace only. | `ltrim("  hi  ")` | `"hi  "` |
| `rstrip(s)` | Remove trailing whitespace only. | `rstrip("  hi  ")` | `"  hi"` |
| `replace(s, from, to)` | Replace all occurrences of `from` with `to`. | `replace("aab", "a", "x")` | `"xxb"` |
| `starts_with(s, p)` | Test if `s` begins with prefix `p`. | `starts_with("hello", "hel")` | `true` |
| `ends_with(s, p)` | Test if `s` ends with suffix `p`. | `ends_with("hello", "llo")` | `true` |
| `char_at(s, i)` | Character at index `i` as a single-character string. | `char_at("hello", 0)` | `"h"` |
| `ord(c)` | Unicode code point of a single character. | `ord("A")` | `65` |
| `chr(n)` | Character from Unicode code point. | `chr(65)` | `"A"` |
| `repeat(s, n)` | Repeat string `n` times. | `repeat("ab", 3)` | `"ababab"` |
| `pad_left(s, w, c)` | Left-pad string to width `w` with character `c`. | `pad_left("42", 5, "0")` | `"00042"` |
| `pad_right(s, w, c)` | Right-pad string to width `w` with character `c`. | `pad_right("hi", 5, ".")` | `"hi..."` |
| `center(s, w, c)` | Center-pad string to width `w` with character `c`. | `center("hi", 6, "-")` | `"--hi--"` |

### Built-in functions (math)

| Function | Description | Example | Result |
|---|---|---|---|
| `abs(x)` | Absolute value. | `abs(-5)` | `5` |
| `min(a, b)` | Smaller of two values. | `min(3, 7)` | `3` |
| `max(a, b)` | Larger of two values. | `max(3, 7)` | `7` |
| `sqrt(x)` | Square root. | `sqrt(144.0)` | `12.0` |
| `pow(base, exp)` | Raise `base` to the power `exp`. | `pow(2.0, 10.0)` | `1024.0` |
| `floor(x)` | Round down to nearest integer (toward negative infinity). | `floor(3.7)` | `3.0` |
| `ceil(x)` | Round up to nearest integer (toward positive infinity). | `ceil(3.2)` | `4.0` |
| `round(x)` | Round to nearest integer. | `round(3.5)` | `4.0` |
| `sin(x)` | Sine of angle in radians. | `sin(0.0)` | `0.0` |
| `cos(x)` | Cosine of angle in radians. | `cos(0.0)` | `1.0` |
| `tan(x)` | Tangent of angle in radians. | `tan(0.0)` | `0.0` |
| `asin(x)` | Inverse sine. Returns radians. | `asin(1.0)` | `1.5708` |
| `acos(x)` | Inverse cosine. Returns radians. | `acos(1.0)` | `0.0` |
| `atan(x)` | Inverse tangent. Returns radians. | `atan(1.0)` | `0.7854` |
| `atan2(y, x)` | Two-argument arctangent. Returns angle of point (x, y). | `atan2(1.0, 1.0)` | `0.7854` |
| `exp(x)` | Exponential: e raised to the power x. | `exp(1.0)` | `2.7183` |
| `log(x)` | Natural logarithm (base e). | `log(2.7183)` | `~1.0` |
| `log2(x)` | Logarithm base 2. | `log2(8.0)` | `3.0` |
| `log10(x)` | Logarithm base 10. | `log10(1000.0)` | `3.0` |
| `hypot(a, b)` | Hypotenuse: `sqrt(a*a + b*b)`. Numerically stable. | `hypot(3.0, 4.0)` | `5.0` |

### Built-in functions (I/O -- Input/Output)

| Function | Description | Returns |
|---|---|---|
| `read_file(path)` | Read entire file contents as a UTF-8 string. | string (or error) |
| `write_file(path, s)` | Write string to file, creating or overwriting it. | nothing |
| `append_file(path, s)` | Append string to end of file. | nothing |
| `file_exists(path)` | Check if a file or directory exists. | `true` or `false` |
| `file_size(path)` | File size in bytes. | integer |
| `mkdir(path)` | Create a single directory. Fails if parent does not exist. | nothing |
| `mkdir_p(path)` | Create directory and all parent directories as needed. | nothing |
| `list_dir(path)` | List names of files and directories in the given directory. | list of strings |
| `cwd()` | Current working directory as an absolute path. | string |
| `path_join(a, b)` | Join two path components with the OS-appropriate separator. | string |
| `path_ext(path)` | File extension including the dot. `path_ext("a.txt")` returns `".txt"`. | string |

### Built-in functions (concurrency)

| Function | Description | Returns |
|---|---|---|
| `channel()` | Create an unbounded channel (buffer grows as needed). | channel |
| `channel_bounded(n)` | Create a bounded channel with capacity `n`. `send` blocks when full. | channel |
| `send(ch, v)` | Send a deep-copied value on the channel. Blocks if bounded and full. | nothing |
| `receive(ch)` | Block until a value arrives on the channel, then return it. | the value |
| `select(ch1, ch2)` | Block until either channel has a value. Returns `[index, value]` where index is 0 or 1. | `[int, value]` |
| `monitor(pid)` | Monitor a spawned task. Returns a channel that receives a notification when the task completes. | channel |
| `reschedule()` | Voluntarily yield the current green task to let other tasks run. Use in CPU-bound loops. | nothing |
| `pmap(list, f)` | Parallel map: applies `f` to each element concurrently across all CPU cores. | new list |
| `channel_recv_timeout(ch, ms)` | Receive with timeout. Returns `null` if no value arrives within `ms` milliseconds. | value or `null` |

### String interpolation

NOVA uses `{expression}` inside double-quoted strings for interpolation. There is no prefix (no `f"..."` like Python, no `$"..."` like C#). Any expression can appear inside the braces.

```nova
name = "world"
print("Hello, {name}!")          // Hello, world!
print("1 + 1 = {1 + 1}")        // 1 + 1 = 2
print("len={len(name)}")         // len=5
print("upper={upper(name)}")     // upper=WORLD

// To include literal braces in the output, escape them with backslash
print("escaped: \{not code\}")   // escaped: {not code}
print("JSON: \{\"key\": 42\}")   // JSON: {"key": 42}
```

---

## Appendix B: Common patterns

This appendix shows complete, annotated solutions to common programming tasks. Each pattern is a self-contained example you can copy and adapt.

### Parse a config file (key=value format)

**What is this?** Many applications use simple text files for configuration: one key-value pair per line, separated by `=`, with `#` for comments. This pattern reads such a file and returns a dict of configuration values.

```nova
fn parse_config(path: string) -> Result
    content = try read_file(path)
    result = {}
    for line in split(content, "\n")
        line = trim(line)
        if len(line) == 0 or starts_with(line, "#")
            continue
        eq = find(line, "=")
        if eq < 0
            continue
        key = trim(slice(line, 0, eq))
        val = trim(slice(line, eq + 1, len(line)))
        result[key] = val
    ok(result)
```

**Line-by-line explanation:**

- `content = try read_file(path)` -- Read the file. `try` unwraps the `Ok` or propagates the `Err` to the caller. If the file does not exist, the function returns `Err("file not found")` automatically.
- `result = {}` -- Start with an empty dict.
- `for line in split(content, "\n")` -- Split the file content on newlines and iterate over each line.
- `line = trim(line)` -- Remove leading/trailing whitespace (handles Windows `\r\n` line endings too, since `\r` is whitespace).
- `if len(line) == 0 or starts_with(line, "#")` -- Skip empty lines and comment lines (lines starting with `#`).
- `eq = find(line, "=")` -- Find the position of the `=` separator. Returns `-1` if not found.
- `if eq < 0` then `continue` -- Skip malformed lines that have no `=`.
- `key = trim(slice(line, 0, eq))` -- Everything before `=` is the key. `trim` removes whitespace around the key.
- `val = trim(slice(line, eq + 1, len(line)))` -- Everything after `=` is the value.
- `result[key] = val` -- Store the key-value pair in the dict.
- `ok(result)` -- Wrap the result in `Ok` for the `Result` return type.

**Usage:**

```nova
match parse_config("app.conf")
    Ok(cfg) =>
        host = if contains(cfg, "host") then cfg["host"] else "localhost"
        port = if contains(cfg, "port") then int(cfg["port"]) else 8080
        print("connecting to {host}:{port}")
    Err(e) =>
        print("config error: {e}")
```

### Retry with exponential backoff

**What is this?** Network operations fail transiently -- a database might be temporarily overloaded, an API might time out, a DNS lookup might fail due to a brief network hiccup. Exponential backoff retries the operation with increasing delays between attempts, giving the remote system time to recover.

```nova
fn with_retry(max_attempts: int, f)
    attempt = 0
    last_err = "unknown error"
    while attempt < max_attempts
        r = f()
        match r
            Ok(v) => return ok(v)
            Err(e) =>
                last_err = e
                attempt = attempt + 1
                if attempt < max_attempts
                    sleep(100 * attempt)
    err("failed after {max_attempts} attempts: {last_err}")
```

**Line-by-line explanation:**

- `fn with_retry(max_attempts: int, f)` -- Takes the maximum number of attempts and a function `f` that returns a `Result`. The function `f` takes no arguments.
- `attempt = 0` -- Counter starting at 0 (first attempt is attempt 0).
- `r = f()` -- Call the operation. It returns `Ok(value)` on success or `Err(message)` on failure.
- `Ok(v) => return ok(v)` -- On success, immediately return the successful result. The `return` keyword is needed for early exit from the `while` loop.
- `Err(e) =>` -- On failure, record the error, increment the attempt counter, and sleep.
- `sleep(100 * attempt)` -- Wait 100ms on the first retry, 200ms on the second, 300ms on the third. This linear backoff gives the remote system increasing time to recover.
- `err("failed after ...")` -- After all attempts are exhausted, return the final error.

**Usage:**

```nova
result = with_retry(3, fn() connect_to_database("mydb.db"))
match result
    Ok(db) => print("connected")
    Err(e) => print("gave up: {e}")
```

### Pipeline pattern (data transformation chain)

**What is this?** A pipeline passes data through a sequence of transformation steps. Each step receives the output of the previous step and produces input for the next. This is a common pattern in data processing, ETL (Extract, Transform, Load) systems, and functional programming.

```nova
fn pipeline(data, steps)
    result = data
    for step in steps
        result = step(result)
    result
```

**Line-by-line explanation:**

- `fn pipeline(data, steps)` -- Takes initial data and a list of transformation functions.
- `result = data` -- Start with the original data.
- `for step in steps` -- Apply each function in order.
- `result = step(result)` -- Each step transforms the data. The output of step N becomes the input of step N+1.
- `result` -- Return the final transformed data.

**Usage:**

```nova
processed = pipeline(raw_items, [
    items => filter(items, item => item.active),
    items => map(items, item => normalize(item)),
    items => sort(items),
    items => items[0:100]
])
```

### Worker pool (concurrent job processing)

**What is this?** A worker pool spawns a fixed number of worker tasks, then distributes jobs to them through a channel. This limits concurrency (you do not want 10,000 simultaneous database connections) while still processing work in parallel.

```nova
fn worker_pool(num_workers: int, jobs: list, handler) -> list
    work_ch = channel()
    result_ch = channel()

    // Spawn workers
    for i in 0..num_workers - 1
        spawn fn()
            loop
                job = receive(work_ch)
                if job == -1
                    break
                result = handler(job)
                send(result_ch, result)

    // Send all jobs
    for job in jobs
        send(work_ch, job)

    // Send poison pills (one per worker) to signal "no more work"
    for i in 0..num_workers - 1
        send(work_ch, -1)

    // Collect all results
    results = []
    for i in 0..len(jobs) - 1
        push(results, receive(result_ch))
    results
```

**Line-by-line explanation:**

- `work_ch = channel()` -- Channel for sending jobs to workers.
- `result_ch = channel()` -- Channel for collecting results from workers.
- `for i in 0..num_workers - 1` -- Spawn `num_workers` green tasks. `0..num_workers - 1` is inclusive on both ends, giving exactly `num_workers` iterations.
- `job = receive(work_ch)` -- Each worker blocks until a job is available.
- `if job == -1` then `break` -- The sentinel value `-1` tells the worker to stop. This is called a "poison pill" pattern.
- `result = handler(job)` -- Process the job using the provided handler function.
- `send(result_ch, result)` -- Send the result back to the collector.
- The main task sends all jobs, then sends one poison pill per worker.
- Finally, it receives one result per job.

**Usage:**

```nova
results = worker_pool(4, [1, 2, 3, 4, 5, 6, 7, 8], x => x * x)
print(results)   // [1, 4, 9, 16, 25, 36, 49, 64] (order may vary)
```

### HTTP (HyperText Transfer Protocol) API client

**What is this?** A thin wrapper around NOVA's built-in HTTP functions that provides a cleaner interface for making API calls. Wraps `http_get` and `http_post` with automatic JSON encoding/decoding.

```nova
fn api_get(base_url, path)
    resp = http_get(base_url + path)
    json_decode(resp)

fn api_post(base_url, path, data)
    resp = http_post(base_url + path, json_encode(data))
    json_decode(resp)
```

**Line-by-line explanation:**

- `http_get(base_url + path)` -- Makes an HTTP GET request. String concatenation builds the full URL.
- `json_decode(resp)` -- Parses the response body as JSON and returns a NOVA dict/list.
- `http_post(base_url + path, json_encode(data))` -- Makes an HTTP POST request. `json_encode` serializes the NOVA dict `data` to a JSON string for the request body.

**Usage:**

```nova
users = api_get("http://localhost:8080", "/api/users")
new_user = api_post("http://localhost:8080", "/api/users", {"name": "Alice"})
```

### Concurrent data fetcher

**What is this?** Fetch data from multiple URLs simultaneously. Instead of waiting for each request to complete sequentially (slow), spawn a green task for each URL and collect results through a channel (fast).

```nova
fn fetch_all(urls)
    ch = channel()
    for url in urls
        spawn fn()
            result = http_get(url)
            send(ch, {"url": url, "data": result})

    results = []
    for i in 0..len(urls) - 1
        push(results, receive(ch))
    results
```

**Line-by-line explanation:**

- `for url in urls` -- For each URL, spawn a concurrent task.
- `spawn fn() ...` -- Each task makes an HTTP GET request independently. All tasks run concurrently.
- `send(ch, {"url": url, "data": result})` -- Each task sends its result (tagged with the URL) to the shared channel.
- `for i in 0..len(urls) - 1` -- Collect exactly as many results as there are URLs. Each `receive(ch)` blocks until a result is available.

**Usage:**

```nova
data = fetch_all([
    "http://api1.example.com/data",
    "http://api2.example.com/data",
    "http://api3.example.com/data"
])
// All three fetched concurrently -- total time is max(individual times),
// not sum(individual times)
```

### State machine

**What is this?** A state machine is a programming pattern where a system can be in exactly one of several states, and transitions between states are defined by a function. State machines are useful for modeling workflows, protocols, game logic, parsers, and any system with a lifecycle.

```nova
enum State
    Idle()
    Running(progress: int)
    Done(result: string)
    Failed(error: string)

fn tick(state)
    match state
        Idle() => Running(0)
        Running(p) =>
            if p >= 100
                Done("completed")
            else
                Running(p + 10)
        Done(r) => Done(r)
        Failed(e) => Failed(e)
```

**Line-by-line explanation:**

- `enum State` -- Defines four possible states. Each variant can carry data (a progress counter, a result string, an error message, or nothing).
- `fn tick(state)` -- One "step" of the state machine. Takes the current state, returns the next state.
- `Idle() => Running(0)` -- From idle, transition to running with progress 0.
- `Running(p) =>` -- Destructure the `Running` variant to get the progress value `p`.
- `if p >= 100` then `Done("completed")` -- When progress reaches 100, transition to done.
- `else Running(p + 10)` -- Otherwise, advance progress by 10 and stay in running.
- `Done(r) => Done(r)` -- Once done, stay done (terminal state).
- `Failed(e) => Failed(e)` -- Once failed, stay failed (terminal state).

**Usage:**

```nova
state = Idle()
while true
    match state
        Done(r) =>
            print("Finished: {r}")
            break
        Failed(e) =>
            print("Error: {e}")
            break
        _ =>
            state = tick(state)
```

### Memoization (caching function results)

**What is this?** Memoization stores the results of expensive function calls so that repeated calls with the same arguments return the cached result instantly instead of recomputing.

```nova
fn make_memoized(f)
    cache = {}
    fn(arg)
        key = str(arg)
        if contains(cache, key)
            return cache[key]
        result = f(arg)
        cache[key] = result
        result
```

**Line-by-line explanation:**

- `cache = {}` -- The cache dict is captured by the closure. It persists across calls.
- `fn(arg)` -- Returns a new function that wraps the original function `f`.
- `key = str(arg)` -- Convert the argument to a string for use as a dict key.
- `if contains(cache, key)` -- If we have already computed this result, return it immediately.
- `result = f(arg)` -- Otherwise, compute the result by calling the original function.
- `cache[key] = result` -- Store the result for future calls.

**Usage:**

```nova
fn slow_fibonacci(n)
    if n <= 1
        return n
    slow_fibonacci(n - 1) + slow_fibonacci(n - 2)

fast_fibonacci = make_memoized(fn(n)
    if n <= 1
        return n
    fast_fibonacci(n - 1) + fast_fibonacci(n - 2)
)

print(fast_fibonacci(40))   // instant (vs. minutes without memoization)
```

### Debounce (rate-limit function calls)

**What is this?** Debouncing ensures a function is called at most once per time window, even if it is triggered many times. Common in UI programming (search-as-you-type should not fire a query on every keystroke) and monitoring (you do not want 1000 alert emails per second).

```nova
fn debounced(delay_ms, f)
    last_call = 0
    fn(arg)
        now = time_ms()
        if now - last_call >= delay_ms
            last_call = now
            f(arg)
```

**Line-by-line explanation:**

- `last_call = 0` -- Tracks the timestamp of the last actual invocation.
- `now = time_ms()` -- Current time in milliseconds.
- `if now - last_call >= delay_ms` -- Only call `f` if enough time has passed since the last call.
- `last_call = now` -- Update the timestamp.

---

## Appendix C: Troubleshooting

This appendix covers the most common errors and problems encountered when writing NOVA programs, with explanations of why each happens and how to fix it.

### "cannot find module 'forge'" (or any module)

**What went wrong:** NOVA cannot find the module file on disk. Modules are `.nova` files in the `$NOVA_HOME/lib/` directory.

**How to fix:**

1. Check that the `NOVA_HOME` environment variable is set:

```bash
echo $NOVA_HOME
```

2. Verify the module file exists:

```bash
ls $NOVA_HOME/lib/forge.nova
```

3. If `NOVA_HOME` is not set, set it to the NOVA installation directory (the one containing the `lib/` folder):

```bash
export NOVA_HOME=/path/to/nova    # Linux/macOS
set NOVA_HOME=C:\path\to\nova     # Windows
```

4. If you are using a custom module (not a standard library module), make sure the `.nova` file is in the same directory as your program or in `$NOVA_HOME/lib/`.

### "type mismatch: expected float, got Int"

**What went wrong:** You used a capital type name (`Int`, `Float`, `String`, `Bool`) in a struct field declaration. Capital type names create dynamically-typed fields. When you try to do arithmetic on these fields, the result types are dynamic, and the compiler cannot guarantee they are the type you expect.

**How to fix:** Change all struct field types to lowercase.

```nova
// WRONG:
type Point
    x: Float    // capital F -- dynamic
    y: Float

// CORRECT:
type Point
    x: float    // lowercase f -- native
    y: float
```

This error most commonly appears when doing arithmetic on struct fields: `p.x * p.y` with `Float` fields triggers dynamic dispatch, and the result type may not match what you assign it to.

### Green task hangs or starves other tasks

**What went wrong:** A CPU-bound green task is running a long loop without yielding. NOVA's green task scheduler is cooperative -- a task must voluntarily give up control for other tasks to run. If a task loops for millions of iterations without yielding, all other tasks on the same OS thread are frozen.

**How to fix:** Add `reschedule()` calls inside long-running loops:

```nova
spawn fn()
    i = 0
    while i < 10_000_000
        i = i + 1
        if i % 100_000 == 0
            reschedule()   // yield to other tasks every 100K iterations
```

**Line-by-line explanation:**

- `if i % 100_000 == 0` -- Check every 100,000 iterations.
- `reschedule()` -- Voluntarily yield. The scheduler runs other ready tasks, then resumes this one. The overhead is negligible (~100 nanoseconds per call).

**Choosing the frequency:** Yield too often (every iteration) and you waste time on scheduling overhead. Yield too rarely (every billion iterations) and other tasks starve. Every 10,000 to 1,000,000 iterations is usually the right range, depending on how much work each iteration does.

### "arena object not found in heap"

**What went wrong:** A value created inside a Forge request handler (which uses a per-request arena allocator) is being referenced after the request finishes. When the request completes, the arena is freed, and all values in it become invalid.

**How to fix:** Store long-lived values (caches, counters, session data, connection pools) at module scope, not inside handler functions:

```nova
// WRONG: cache created inside handler -- destroyed after each request
forge.get(app, "/data", fn(req)
    cache = {}               // created in request arena
    cache["key"] = compute() // stored in request arena
    // cache is destroyed when this request finishes!
    forge.json(cache["key"])
)

// CORRECT: cache at module scope -- lives for the entire server lifetime
cache = {}

forge.get(app, "/data", fn(req)
    if not contains(cache, "key")
        cache["key"] = compute()
    forge.json(cache["key"])
)
```

### Struct arithmetic is unexpectedly slow

**What went wrong:** One or more struct field types use capital letters (`Float`, `Int`), forcing dynamic dispatch on every arithmetic operation.

**How to diagnose:** Search your code for `type` blocks and check every field type:

```bash
grep -A 10 "^type " myprogram.nova
```

Look for capital-letter type names: `Float`, `Int`, `String`, `Bool`. Change them all to lowercase: `float`, `int`, `string`.

**The performance difference is 100-150x.** A dot product that takes 3 nanoseconds with lowercase types takes 450 nanoseconds with capital types.

### "index N out of bounds"

**What went wrong:** You accessed a list or string at an index that does not exist. Lists and strings are 0-indexed: a list with 5 elements has valid indices 0, 1, 2, 3, 4. Accessing index 5 is out of bounds.

**How to fix:** Check the length before accessing:

```nova
if i < len(items)
    print(items[i])
else
    print("index {i} is out of range (list has {len(items)} elements)")
```

**Common causes:**

1. **Off-by-one error.** `for i in 0..len(items)` iterates one too many times because `0..N` is inclusive on both ends (gives 0 through N, which is N+1 values). Use `for i in 0..len(items) - 1` or the idiomatic `for item in items`.

2. **Empty list.** Calling `items[0]` on an empty list crashes. Always check `len(items) > 0` first, or use `match` to handle the empty case.

3. **Negative index.** NOVA does not support negative indexing (unlike Python where `items[-1]` gets the last element). To get the last element, use `items[len(items) - 1]`.

### Function returns unexpected 0, empty string, or null

**What went wrong:** The last statement in your function is a side-effect operation (like `print`, assignment, or `push`) instead of an expression that produces a value. NOVA functions return their last expression. If the last expression is a side-effect statement, the return value is meaningless.

```nova
// BUG: print() returns null, so this function returns null
fn add(a, b)
    print(a + b)

// BUG: assignment returns nothing useful
fn add(a, b)
    result = a + b

// CORRECT: the last line is the value expression
fn add(a, b)
    a + b

// ALSO CORRECT: explicit return
fn add(a, b)
    result = a + b
    return result

// ALSO CORRECT: last expression on its own line
fn add(a, b)
    result = a + b
    result
```

### Channel receive blocks forever (deadlock)

**What went wrong:** No task is sending on the channel you are receiving from. The `receive` call blocks indefinitely.

**Common causes:**

1. **The sender task crashed.** If a spawned task encounters an error and exits before calling `send`, the receiver waits forever. Monitor the task with `monitor()` to detect crashes.

2. **Wrong channel.** You created two channels and are sending on one but receiving on the other.

```nova
// BUG: two channels, send on one, receive on the other
ch1 = channel()
ch2 = channel()
spawn fn()
    send(ch1, 42)    // sending on ch1
result = receive(ch2) // receiving on ch2 -- blocks forever!

// FIX: use the same channel
ch = channel()
spawn fn()
    send(ch, 42)
result = receive(ch)   // correct: same channel
```

3. **Sender exited without sending.** The spawned task returned or broke out of its loop before sending a result.

4. **Bounded channel is full.** If you use `channel_bounded(n)` and the buffer is full, `send` blocks until the receiver drains a value. If both sides are blocking, you have a deadlock.

**How to diagnose:** Use `channel_recv_timeout` to add a timeout, so you can at least detect the problem:

```nova
result = channel_recv_timeout(ch, 5000)   // wait up to 5 seconds
if result == null
    print("timed out -- is the sender running?")
```

### "undefined variable" or "undefined function"

**What went wrong:** You used a name that has not been defined in the current scope. Common causes:

1. **Typo.** `pirnt("hello")` instead of `print("hello")`.
2. **Scope issue.** Variables defined inside an `if` block or loop are not accessible outside it.
3. **Missing import.** You are calling a function from a module without importing it first.
4. **Order issue.** You are calling a function that is defined later in the file. NOVA requires functions to be defined before they are called (in file order).

### Program compiles but produces wrong results silently

**How to diagnose:** Add `print` statements at key points to trace the values:

```nova
fn process(data)
    print("process input: {data}")      // trace input
    result = transform(data)
    print("after transform: {result}")  // trace intermediate value
    final = validate(result)
    print("after validate: {final}")    // trace output
    final
```

For more systematic debugging, use NOVA's `assert` and `assert_eq`:

```nova
assert(len(items) > 0, "items should not be empty")
assert_eq(result, expected_value)
```

---

## Appendix D: Standard library modules

NOVA ships with 40+ standard library modules in `$NOVA_HOME/lib/`. Import any module with `import module_name`. This appendix describes what each module does, when to use it, and provides a representative example for each category.

### Web Framework

| Module | What it does | When to use it |
|--------|-------------|---------------|
| `forge` | Complete HTTP server: routing (GET/POST/PUT/DELETE/PATCH), middleware pipeline, request/response handling, JSON parsing, WebSocket support, SSE (Server-Sent Events), static files, CSRF (Cross-Site Request Forgery) protection, JWT (JSON Web Token) authentication, rate limiting, CORS (Cross-Origin Resource Sharing), input validation, OpenAPI spec generation, Swagger UI. | Whenever you are building a web application, REST API, WebSocket server, or any HTTP-based service. This is the starting point for all server-side web development in NOVA. |
| `forge_db` | Database connection pooling and query helpers for SQLite. Provides `db.all(sql)`, `db.run(sql)`, and parameterized queries. | When your Forge application needs to store and retrieve data from a SQLite database. Manages connection lifecycle and provides safe query APIs. |
| `forge_auth` | Authentication utilities: password hashing, token generation, session management helpers. | When you need user login/logout, password verification, or session-based authentication. |
| `forge_admin` | Automatic admin interface generator. Given your database tables, generates CRUD pages for managing data. | When you need a quick back-office tool for managing data without building custom admin screens. |
| `forge_html` | HTML builder: composable functions for generating HTML as data instead of string templates. Functions for every common HTML element (`div`, `p`, `h`, `ul`, `table`, `form`, etc.). | When you want to generate HTML programmatically with guaranteed well-formedness, instead of string concatenation or template files. |
| `forge_live` | LiveView: server-rendered reactive UI. The server maintains the UI state and pushes HTML diffs to the browser over WebSocket. No JavaScript framework needed on the client. | When you want interactive, real-time web UIs without writing any JavaScript. Similar to Phoenix LiveView (Elixir). |
| `forge_obs` | Observability: structured logging, request tracing, error tracking, and performance metrics. | When you need production monitoring: understanding what your server is doing, how fast it is doing it, and what errors are occurring. |
| `forge_otp` | OTP (Open Telecom Platform)-style building blocks: supervisors (restart crashed tasks automatically), agents (stateful server tasks), and job queues (background task processing). | When you need fault-tolerant task management. Supervisors restart crashed workers. Agents hold mutable state safely. Job queues process work asynchronously. Inspired by Erlang/OTP. |
| `forge_dist` | Distributed Forge: run a Forge application across multiple machines (nodes). Handles node discovery, request routing, and state synchronization. | When a single machine cannot handle your traffic and you need horizontal scaling. |
| `forge_mq` | Message queue: durable, persistent task queue for asynchronous job processing. Jobs survive server restarts. | When you need to process work in the background (sending emails, generating reports, processing uploads) and need guaranteed delivery even across restarts. |
| `forge_compress` | Response compression middleware using gzip. Reduces response sizes by 60-90% for text content. | When you want to reduce bandwidth usage and speed up page loads. Enable with one line: `forge.use(app, forge.mw_compress())`. |
| `forge_pg` | PostgreSQL adapter. Provides connection pooling and query helpers for PostgreSQL databases. | When your application uses PostgreSQL instead of SQLite. |

**Example: a complete Forge server setup**

```nova
import forge
import forge_db
import forge_html

fn main()
    app = forge.app()
    db = forge_db.connect("app.db")

    forge.get(app, "/users", fn(req)
        users = forge_db.all(db, "SELECT name, email FROM users")
        forge.json(json_encode(users))
    )

    forge.serve(app, 8080)
```

### Cryptography and Security

| Module | What it does | When to use it |
|--------|-------------|---------------|
| `forge_crypto` | Core cryptographic primitives. Hash functions: SHA-256, SHA-512, SHA-384, MD5 (Message Digest 5, insecure but needed for legacy protocols). MAC (Message Authentication Code) algorithms: HMAC (Hash-based Message Authentication Code), Poly1305. Key derivation: PBKDF2 (Password-Based Key Derivation Function 2, for hashing passwords), HKDF (HMAC-based Key Derivation Function, for deriving keys from shared secrets). Symmetric encryption: AES-128/256-CTR/GCM (Advanced Encryption Standard), ChaCha20-Poly1305. Key exchange: X25519 (Elliptic-curve Diffie-Hellman). Signatures: Ed25519 (Edwards-curve Digital Signature Algorithm). | When you need hashing, encryption, key derivation, key exchange, or digital signatures. All implemented in pure NOVA (no OpenSSL dependency). |
| `forge_x509` | X.509 certificate parsing and verification. Reads DER (Distinguished Encoding Rules)-encoded certificates, extracts fields (subject, issuer, validity period, public key), and verifies signatures. | When you need to read, validate, or inspect TLS/SSL certificates. Used internally by the TLS modules. |
| `forge_p256` | ECDSA (Elliptic Curve Digital Signature Algorithm) on the NIST P-256 curve. Sign and verify operations. | When you need to create or verify digital signatures using the P-256 curve (common in web standards like WebAuthn and JWT). |
| `forge_rsa` | RSA (Rivest-Shamir-Adleman) signature verification. Supports PKCS#1 v1.5 and PSS (Probabilistic Signature Scheme) padding. Verification only (no signing -- RSA key generation is expensive and rarely needed in application code). | When you need to verify RSA signatures on certificates, JWTs, or signed documents. |
| `forge_tls` | TLS (Transport Layer Security) 1.3 key schedule and handshake message processing. Implements the cryptographic core of TLS 1.3: key derivation, transcript hashing, Finished message verification, CertificateVerify for all signature algorithms. | Used internally by `forge_tls_client` and `forge_tls_server`. You typically do not import this directly unless you are building a custom TLS implementation. |
| `forge_tls_client` | TLS 1.3 client. Establishes encrypted connections to HTTPS servers. Performs the full TLS 1.3 handshake, verifies the server's certificate, and provides an encrypted channel. | When you need to make HTTPS requests or connect to any TLS-secured server. |
| `forge_tls_server` | TLS 1.3 server. Accepts encrypted connections from HTTPS clients. | When you need to serve HTTPS traffic (encrypted web pages, APIs). |
| `forge_chain` | X.509 certificate chain validation (PKI -- Public Key Infrastructure). Verifies that a certificate was issued by a trusted CA (Certificate Authority) by walking the chain of trust. | When you need to validate whether a server's certificate is legitimate. Used internally by the TLS modules. |

### Data and Math

| Module | What it does | When to use it |
|--------|-------------|---------------|
| `bignum` | Arbitrary-precision integers. Numbers with hundreds or thousands of digits, limited only by available memory. Supports addition, subtraction, multiplication, division, modular exponentiation, GCD (Greatest Common Divisor), and comparison. | When you need integers larger than 2^63 - 1 (the maximum for NOVA's built-in `int` type). Common in cryptography, financial calculations, and combinatorics. |
| `complexnum` | Complex number arithmetic. A complex number has a real part and an imaginary part: `a + bi` where `i = sqrt(-1)`. Supports addition, subtraction, multiplication, division, magnitude, and phase. | When you need to work with complex numbers: signal processing (FFT -- Fast Fourier Transform), control systems, quantum computing simulations, electrical engineering. |
| `rational` | Rational number arithmetic. A rational number is an exact fraction `p/q`. Unlike floats, rationals never lose precision: `1/3` stays exactly `1/3`, not `0.333333`. | When you need exact arithmetic without floating-point rounding errors. Financial calculations, mathematical proofs, computer algebra. |
| `matrixx` | Matrix operations: creation, addition, multiplication, transpose, determinant, inverse. Works with lists of lists. | When you need linear algebra operations and do not want to use the tensor API (tensors are more general but matrices are simpler for 2D operations). |
| `prng` | Pseudo-Random Number Generators. Deterministic random number generation with seedable state. | When you need reproducible random numbers (testing, simulations, procedural generation). For cryptographic randomness, use `forge_crypto` instead. |
| `bitset` | Bit set operations. A compact representation of a set of non-negative integers using a bit array. Supports union, intersection, difference, membership test, and iteration. | When you need to track which items in a numbered set are present/absent. Memory-efficient for dense sets of small integers. |
| `pvecx` | Persistent (immutable) vectors. A data structure where "modifications" produce a new version without copying the entire vector (structural sharing). Previous versions remain accessible. | When you need immutable data structures with efficient updates: undo/redo systems, concurrent data access without locks, functional programming patterns. |

**Example: bignum for cryptographic-sized numbers**

```nova
import bignum

a = bignum.from_str("123456789012345678901234567890")
b = bignum.from_str("987654321098765432109876543210")
c = bignum.add(a, b)
print(bignum.to_str(c))  // 1111111110111111111011111111100
```

### Text and Encoding

| Module | What it does | When to use it |
|--------|-------------|---------------|
| `strx` | Extended string operations beyond the built-ins. Title case, camel case, snake case, word wrapping, word counting, levenshtein distance (edit distance between strings), string similarity. | When you need string transformations not covered by built-in functions (`upper`, `lower`, `trim`, etc.). |
| `basex` | Base encoding/decoding: Base32 (RFC 4648), Base58 (Bitcoin addresses), Base64 (RFC 4648, email attachments, data URIs). | When you need to encode binary data as text for transport (email, URLs, JSON). Base64 is the most common: `base64_encode(str_to_bytes("hello"))` produces `"aGVsbG8="`. |
| `graphemex` | Unicode grapheme cluster operations. A grapheme cluster is what humans perceive as a single character -- it may be multiple Unicode code points (e.g., a flag emoji is two code points, an accented character may be a base character plus a combining mark). | When you need to correctly count, split, or iterate over user-perceived characters in multilingual text. |
| `csvx` | CSV (Comma-Separated Values) parsing and generation. Handles quoted fields, escaped commas, multiline values. | When you need to read or write spreadsheet-compatible data files. |
| `urlx` | URL (Uniform Resource Locator) parsing and manipulation. Extracts scheme, host, port, path, query parameters, and fragment. Encodes/decodes URL-escaped characters. | When you need to parse URLs, extract query parameters, or build URLs programmatically. |
| `deflatex` | DEFLATE compression and decompression. DEFLATE is the algorithm used by gzip and ZIP files. | When you need to compress or decompress data. Used internally by `forge_compress` for HTTP response compression. |

**Example: Base64 encoding**

```nova
import basex

encoded = basex.base64_encode(str_to_bytes("Hello, NOVA!"))
print(encoded)  // SGVsbG8sIE5PVkEh

decoded = bytes_to_str(basex.base64_decode(encoded))
print(decoded)  // Hello, NOVA!
```

### Utilities

| Module | What it does | When to use it |
|--------|-------------|---------------|
| `corex` | Core utilities: identity function, constant function, pipe, compose, memoize, timing helpers, retry logic. | When you need functional programming utilities or general-purpose helpers. |
| `collx` | Collection utilities beyond built-in `map`/`filter`/`reduce`: `group_by` (group list elements by a key function), `chunk` (split list into fixed-size sublists), `zip` (combine two lists element-wise), `uniq` (remove duplicates), `frequencies` (count occurrences). | When you need collection transformations not covered by built-ins. |
| `setops` | Set operations: union (all elements from both sets), intersection (elements in both sets), difference (elements in the first set but not the second), symmetric difference (elements in either set but not both). Works with NOVA's set type (`{1, 2, 3}`). | When you need mathematical set operations. |
| `getin` | Nested data access: `get_in(data, ["users", 0, "name"])` safely navigates nested dicts and lists, returning `null` if any key is missing. `assoc_in` creates a modified copy with a value set at a nested path. | When you need to read or modify deeply nested JSON-like data structures without writing chains of null checks. |
| `uuid` | UUID (Universally Unique Identifier) v4 generation. Produces random 128-bit identifiers formatted as `"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"`. | When you need unique identifiers for database records, request tracing, session IDs, or any situation where you need globally unique IDs without a central registry. |
| `coro` | Coroutine/generator support. Create functions that can yield multiple values lazily, producing one value at a time on demand instead of computing all values upfront. | When you need lazy sequences: processing large files line by line without loading the entire file into memory, infinite sequences, or producer-consumer patterns where the producer runs at the consumer's pace. |

**Example: collection utilities**

```nova
import collx

// Group users by role
users = [
    {"name": "Alice", "role": "admin"},
    {"name": "Bob", "role": "user"},
    {"name": "Carol", "role": "admin"},
    {"name": "Dave", "role": "user"}
]
grouped = collx.group_by(users, fn(u) u["role"])
// grouped = {"admin": [Alice, Carol], "user": [Bob, Dave]}

// Chunk a list into pages of 3
items = [1, 2, 3, 4, 5, 6, 7, 8]
pages = collx.chunk(items, 3)
// pages = [[1, 2, 3], [4, 5, 6], [7, 8]]

// Count frequencies
words = ["the", "cat", "sat", "on", "the", "mat", "the"]
freq = collx.frequencies(words)
// freq = {"the": 3, "cat": 1, "sat": 1, "on": 1, "mat": 1}
```

---

*NOVA (Natively Optimized Versatile Architecture) language version: gen3 (self-hosted compiler). This tutorial reflects the language as implemented and tested. For formal grammar and semantic rules, see `LANGUAGE_SPEC.md`. For the complete framework API reference, see the Forge source in `lib/forge.nova`.*
