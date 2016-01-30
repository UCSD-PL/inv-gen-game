#include <stdio.h>

void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

#define a (1)
#define SIZE 8

int main() { 
  int i, sn=0;
  printf("i\tsn\n");

  for(i=1; i<=SIZE; i++) {
  	printf("%d\t%d\n", i, sn);
    sn = sn + a;
  }
  printf("%d\t%d\n", i, sn);
  __VERIFIER_assert(sn==SIZE*a || sn == 0);
}

