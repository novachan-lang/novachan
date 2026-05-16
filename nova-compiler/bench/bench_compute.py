import time

def fib(n):
    if n <= 1:
        return n
    return fib(n-1) + fib(n-2)

def integrate_sin(n):
    h = 3.14159265358979 / n
    total = 0.0
    for i in range(n):
        x = i * h
        sinX = x - x*x*x/6.0 + x*x*x*x*x/120.0
        total += sinX * h
    return total

t = time.perf_counter()
r = fib(40)
print(f"Python fib(40): {(time.perf_counter()-t)*1000:.1f} ms ({r})")

t = time.perf_counter()
r = integrate_sin(10000000)
print(f"Python num_bench: {(time.perf_counter()-t)*1000:.1f} ms ({r})")
