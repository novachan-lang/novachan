public class BenchJava {
    static int fib(int n) {
        if (n <= 1) return n;
        return fib(n - 1) + fib(n - 2);
    }

    static int countPrimes(int limit) {
        int count = 0;
        for (int n = 2; n <= limit; n++) {
            boolean isP = true;
            for (int d = 2; d * d <= n; d++) {
                if (n % d == 0) { isP = false; break; }
            }
            if (isP) count++;
        }
        return count;
    }

    static long sumSquares(int n) {
        long sum = 0;
        for (int i = 0; i < n; i++) {
            sum += (long)i * i;
        }
        return sum;
    }

    public static void main(String[] args) {
        long t1 = System.currentTimeMillis();
        int f = fib(40);
        long t2 = System.currentTimeMillis();
        System.out.println("fib(40) = " + f + "  [" + (t2 - t1) + "ms]");

        long t3 = System.currentTimeMillis();
        int p = countPrimes(100000);
        long t4 = System.currentTimeMillis();
        System.out.println("primes <= 100000: " + p + "  [" + (t4 - t3) + "ms]");

        long t5 = System.currentTimeMillis();
        long s = sumSquares(10000000);
        long t6 = System.currentTimeMillis();
        System.out.println("sum_squares(10M) = " + s + "  [" + (t6 - t5) + "ms]");
    }
}
