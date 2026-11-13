/* fastest-primes: count primes <= N (1 <= N <= 5,000,000).
 * Reads N from stdin, prints the count on stdout.
 * Odd-only Sieve of Eratosthenes over a byte array.
 * is_comp[i] == 1  <=>  2*i+1 is composite. Index 0 (number 1) unused.
 * gcc -O3 -march=native -o primes primes.c
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    long n;
    if (scanf("%ld", &n) != 1) return 0;
    if (n < 2) { puts("0"); return 0; }
    if (n == 2) { puts("1"); return 0; }

    long m = (n + 1) / 2;              /* odds 1,3,5,...,<=n -> m entries */
    unsigned char *is_comp = (unsigned char *)malloc((size_t)m);
    if (!is_comp) return 1;
    memset(is_comp, 0, (size_t)m);

    for (long p = 3; p * p <= n; p += 2) {
        if (!is_comp[p >> 1]) {
            long step = p << 1;        /* 2p: stay on odd multiples */
            long start = p * p;
            for (long j = start; j <= n; j += step)
                is_comp[j >> 1] = 1;
        }
    }

    long count = 1;                    /* prime 2 */
    for (long i = 1; i < m; i++)
        count += !is_comp[i];
    free(is_comp);
    printf("%ld\n", count);
    return 0;
}
