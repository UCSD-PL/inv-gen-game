#include <assert.h>
#include <stdio.h>

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
    printf("n = %d k = %d j = %d\n", n, k, j);
    j++;
    k--;
  } 
  printf("n = %d k = %d j = %d\n", n, k, j);
  static_assert(k>=0);
  return 0;
}

void main() {
  run(7, 9);
}