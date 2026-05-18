# NOVA Examples

## Quicksort

```nova
fn quicksort(arr: list) -> list
    if len(arr) <= 1
        return arr
    let pivot = arr[0]
    let less = []
    let greater = []
    let i = 1
    while i < len(arr)
        if arr[i] <= pivot
            push(less, arr[i])
        else
            push(greater, arr[i])
        i = i + 1
    let sorted_less = quicksort(less)
    let sorted_greater = quicksort(greater)
    push(sorted_less, pivot)
    let result = sorted_less
    for item in sorted_greater
        push(result, item)
    result

fn main()
    let data = [38, 27, 43, 3, 9, 82, 10]
    print(quicksort(data))
```

## Fibonacci with Memoization

```nova
fn fib_memo(n: int, cache: dict) -> int
    if contains(cache, str(n))
        return cache[str(n)]
    if n <= 1
        return n
    let result = fib_memo(n - 1, cache) + fib_memo(n - 2, cache)
    cache[str(n)] = result
    result

fn main()
    let cache = {}
    let i = 0
    while i <= 30
        print(f"fib({i}) = {fib_memo(i, cache)}")
        i = i + 1
```

## Prime Sieve

```nova
fn sieve(limit: int) -> list
    let is_prime = []
    let i = 0
    while i <= limit
        push(is_prime, 1)
        i = i + 1
    is_prime[0] = 0
    is_prime[1] = 0
    let p = 2
    while p * p <= limit
        if is_prime[p] == 1
            let j = p * p
            while j <= limit
                is_prime[j] = 0
                j = j + p
        p = p + 1
    let primes = []
    let k = 0
    while k <= limit
        if is_prime[k] == 1
            push(primes, k)
        k = k + 1
    primes

fn main()
    let primes = sieve(100)
    print(f"Primes up to 100: {len(primes)} found")
    for p in primes
        print(p)
```

## Word Counter

```nova
fn count_words(text: string) -> dict
    let words = split(text, " ")
    let counts = {}
    for word in words
        let w = lower(trim(word))
        if len(w) > 0
            if contains(counts, w)
                counts[w] = counts[w] + 1
            else
                counts[w] = 1
    counts

fn main()
    let text = "the quick brown fox jumps over the lazy dog the fox"
    let counts = count_words(text)
    for word in keys(counts)
        print(f"{word}: {counts[word]}")
```

## Simple Web Scraper

```nova
fn main()
    let url = "https://httpbin.org/get"
    let response = http_get(url)
    print(f"Response length: {len(response)}")
    print(response)
```

## File Processing

```nova
fn process_csv(path: string)
    let content = read_file(path)
    if len(content) == 0
        print(f"Error: cannot read {path}")
        return 0
    let lines = split(content, "\n")
    let row_count = 0
    for line in lines
        let trimmed = trim(line)
        if len(trimmed) > 0
            let fields = split(trimmed, ",")
            print(f"Row {row_count}: {len(fields)} fields")
            row_count = row_count + 1
    print(f"Total: {row_count} rows")

fn main()
    process_csv("data.csv")
```

## Concurrent Workers

```nova
fn worker(id: int, ch)
    let i = 0
    while i < 3
        send(ch, f"worker {id}: task {i} done")
        i = i + 1

fn main()
    let ch = channel()
    spawn worker(1, ch)
    spawn worker(2, ch)

    let received = 0
    while received < 6
        let msg = receive(ch)
        print(msg)
        received = received + 1
    print("All tasks complete")
```

## Pattern Matching Calculator

```nova
type BinOp(op: string, left: int, right: int)

fn eval(expr: BinOp) -> int
    match expr
        BinOp(op, left, right) =>
            if op == "+"
                left + right
            else if op == "-"
                left - right
            else if op == "*"
                left * right
            else if op == "/"
                left / right
            else
                0

fn main()
    print(eval(BinOp("+", 10, 20)))   // 30
    print(eval(BinOp("*", 6, 7)))     // 42
    print(eval(BinOp("-", 100, 58)))   // 42
```

## Config File Parser

```nova
fn parse_config(path: string) -> dict
    let config = {}
    let content = read_file(path)
    if len(content) == 0
        return config
    let lines = split(content, "\n")
    for line in lines
        let trimmed = trim(line)
        if len(trimmed) == 0 or starts_with(trimmed, "#")
            continue
        let eq = find(trimmed, "=")
        if eq >= 0
            let key = trim(slice(trimmed, 0, eq))
            let val = trim(slice(trimmed, eq + 1, len(trimmed)))
            config[key] = val
    config

fn main()
    write_file("test.conf", "host = localhost\nport = 8080\n# comment\nname = NOVA\n")
    let config = parse_config("test.conf")
    for key in keys(config)
        print(f"{key} = {config[key]}")
```
