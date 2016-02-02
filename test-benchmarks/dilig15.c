#include <assert.h>
#include <stdio.h>
#include <stdint.h>
void trace(int loopID, char *fmt);

void static_assert(int x) {}
void assume(int x) {}

/*
 * from Invgen test suite
 */

int run(int n, int k) {

  int j;

  assume(n>0);

  assume(k>n);
  j = 0;
  while( j < n ) {
    trace(0, "n=%dk=%dj=%d", (int32_t)n, (int32_t)k, (int32_t)j);
    j++;
    k--;
  } 
  trace(0, "n=%dk=%dj=%d", (int32_t)n, (int32_t)k, (int32_t)j);
  //printf("n = %d k = %d j = %d\n", n, k, j);
  static_assert(k>=0);
  return 0;
}

void main() {
  run(5, 9);
}
