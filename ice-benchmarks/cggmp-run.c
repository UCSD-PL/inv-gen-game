#include <stdio.h>

void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

void main() {
    int i,j;
    i = 1;
    j = 10;
    
    printf("i\tj\n");

    while (j >= i) {
      printf("%d\t%d\n", i, j);
      i = i + 2;
      j = -1 + j;
    }
    printf("%d\t%d\n", i, j);
    
    __VERIFIER_assert(j == 6);
}

/*
i   j
1   10
3   9
5   8
7   7
9   6
*/