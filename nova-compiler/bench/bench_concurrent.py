import time
import threading
import queue

def channel_bench():
    q = queue.Queue()
    def producer():
        for i in range(10000):
            q.put(i)
        q.put(-1)

    t = threading.Thread(target=producer)
    t.start()
    total = 0
    while True:
        val = q.get()
        if val == -1:
            break
        total += val
    t.join()
    return total

def spawn_bench():
    total = 0
    for i in range(100):
        q = queue.Queue()
        def worker(ch, id):
            ch.put(id * id)
        t = threading.Thread(target=worker, args=(q, i))
        t.start()
        val = q.get()
        total += val
        t.join()
    return total

t = time.perf_counter()
r = channel_bench()
print(f"Python channel (Queue): {(time.perf_counter()-t)*1000:.1f} ms ({r})")

t = time.perf_counter()
r = spawn_bench()
print(f"Python spawn (Thread): {(time.perf_counter()-t)*1000:.1f} ms ({r})")
