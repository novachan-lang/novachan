import time

def string_work(n):
    result = ""
    for i in range(n):
        result += "hello"
    return len(result)

def string_search(n):
    s = "the quick brown fox jumps over the lazy dog"
    count = 0
    for i in range(n):
        if "fox" in s:
            count += 1
        if s.startswith("the"):
            count += 1
        if s.endswith("dog"):
            count += 1
    return count

def dict_insert_lookup(n):
    d = {"init": 0}
    for i in range(n):
        d["key" + str(i)] = i * i
    total = 0
    for j in range(n):
        total += d["key" + str(j)]
    return total

def list_build_and_sum(n):
    lst = []
    for i in range(n):
        lst.append(i * 2 + 1)
    total = 0
    for x in lst:
        total += x
    return total

def list_filter_sum(n):
    lst = []
    for i in range(n):
        lst.append(i)
    total = 0
    for x in lst:
        if x % 3 == 0:
            total += x
    return total

# String benchmark
t = time.perf_counter()
r1 = string_work(1000)
r2 = string_search(100000)
print(f"Python string: {(time.perf_counter()-t)*1000:.1f} ms ({r1}, {r2})")

# Dict benchmark
t = time.perf_counter()
result = dict_insert_lookup(10000)
print(f"Python dict: {(time.perf_counter()-t)*1000:.1f} ms ({result})")

# List benchmark
t = time.perf_counter()
r1 = list_build_and_sum(100000)
r2 = list_filter_sum(100000)
print(f"Python list: {(time.perf_counter()-t)*1000:.1f} ms ({r1}, {r2})")
