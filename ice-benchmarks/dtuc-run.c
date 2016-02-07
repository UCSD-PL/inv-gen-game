#include <stdio.h>

int main() { 
  int n, k, i, j;
  k = 0;
  i = 0;

  printf("[LOOP]\ti\tj\tk\tn\n");

  while(i < n)
  {
    printf("[1]\t%d\t%d\t%d\t%d\n", i, j, k, n);
    i = i + 1;
    k = k + 1;
  }
  printf("[1]\t%d\t%d\t%d\t%d\n", i, j, k, n);

  j = n;

  while(j > 0)
  {
    printf("[2]\t%d\t%d\t%d\t%d\n", i, j, k, n);
  	//__VERIFIER_assert(k > 0);
    j = j - 1;
   	k = k - 1;
  }
  printf("[2]\t%d\t%d\t%d\t%d\n", i, j, k, n);
}
